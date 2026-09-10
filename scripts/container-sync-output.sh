#!/bin/bash
# shellcheck disable=SC2086
#
# Copy the small, user-facing build artifacts (finished images, logs,
# .config) from the container-only output volume back onto the bind-mounted
# workspace, mirroring the $(GIT_BRANCH)/$(CAMERA)-... subdirectory layout.
# It also drops a copy of the flashable firmware image and the U-Boot images
# straight into the repo root, so the most recently built firmware is always
# available there without digging through output/.
#
# Why this exists: Buildroot's per-package build isolation
# (BR2_PER_PACKAGE_DIRECTORIES) hard-links files - including compatibility
# symlinks like host/usr and host/lib64 - between per-package directories.
# Docker Desktop's bind mount for macOS/Windows (virtiofs/osxfs onto APFS or
# NTFS) cannot hard-link symlinks, so the full output tree has to live on a
# container-native volume (mounted at /build-output, see Makefile.container's
# THINGINO_OUTPUT_ROOT_DIR). This script is the step that makes the finished
# artifacts show up on the host afterward, the same way `make ram-build`
# copies out of tmpfs.
#
# Usage: container-sync-output.sh [SRC_ROOT] [DST_ROOT] [ROOT_DST]
#   SRC_ROOT  defaults to /build-output (the container-native volume)
#   DST_ROOT  defaults to /workspace/output (bind-mounted, host-visible)
#   ROOT_DST  defaults to /workspace (repo root, for the root-level copy)

set -euo pipefail

SRC_ROOT="${1:-/build-output}"
DST_ROOT="${2:-/workspace/output}"
ROOT_DST="${3:-/workspace}"

[ -d "$SRC_ROOT" ] || exit 0

# The volume can hold output for more than one branch/camera at once (it's
# keyed off the workspace path, not the branch, and past builds are never
# purged). Track whichever images/ dir this run actually touched most
# recently so the root-level copy below reflects THIS build, not a stale one.
latest_images=""
latest_mtime=0

# Output dirs are two levels deep: $(GIT_BRANCH)/$(CAMERA)-$(KERNEL_VERSION)-$(TOOLCHAIN_LIBC)
while IFS= read -r outdir; do
	rel="${outdir#"$SRC_ROOT"/}"
	dst="$DST_ROOT/$rel"
	mkdir -p "$dst"

	if [ -d "$outdir/images" ]; then
		mkdir -p "$dst/images"
		cp -a "$outdir/images/." "$dst/images/"

		fw=$(find "$outdir/images" -maxdepth 1 -name 'thingino-*.bin' -type f -print -quit)
		if [ -n "$fw" ]; then
			mtime=$(stat -c %Y "$fw" 2>/dev/null || echo 0)
			if [ "$mtime" -gt "$latest_mtime" ]; then
				latest_mtime=$mtime
				latest_images="$dst/images"
			fi
		fi
	fi

	if [ -d "$outdir/logs" ]; then
		mkdir -p "$dst/logs"
		cp -a "$outdir/logs/." "$dst/logs/"
	fi

	for f in "$outdir"/.config*; do
		[ -e "$f" ] && cp -a "$f" "$dst/"
	done

	for f in buildscope-report.json uenv.txt; do
		[ -e "$outdir/$f" ] && cp -a "$outdir/$f" "$dst/"
	done
done < <(find "$SRC_ROOT" -mindepth 2 -maxdepth 2 -type d)

# Root-level copy: the flashable firmware image plus the two U-Boot images
# needed to flash it, from whichever build was just synced above.
if [ -n "$latest_images" ]; then
	for f in "$latest_images"/thingino-*.bin "$latest_images"/u-boot-with-tpl-lzma.bin "$latest_images"/u-boot-env.bin; do
		[ -e "$f" ] && cp -a "$f" "$ROOT_DST/"
	done
fi
