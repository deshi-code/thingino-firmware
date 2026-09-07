#!/bin/bash
# shellcheck disable=SC2086
#
# Copy the small, user-facing build artifacts (finished images, logs,
# .config) from the container-only output volume back onto the bind-mounted
# workspace, mirroring the $(GIT_BRANCH)/$(CAMERA)-... subdirectory layout.
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
# Usage: container-sync-output.sh [SRC_ROOT] [DST_ROOT]
#   SRC_ROOT defaults to /build-output (the container-native volume)
#   DST_ROOT defaults to /workspace/output (bind-mounted, host-visible)

set -euo pipefail

SRC_ROOT="${1:-/build-output}"
DST_ROOT="${2:-/workspace/output}"

[ -d "$SRC_ROOT" ] || exit 0

# Output dirs are two levels deep: $(GIT_BRANCH)/$(CAMERA)-$(KERNEL_VERSION)-$(TOOLCHAIN_LIBC)
find "$SRC_ROOT" -mindepth 2 -maxdepth 2 -type d | while read -r outdir; do
	rel="${outdir#"$SRC_ROOT"/}"
	dst="$DST_ROOT/$rel"
	mkdir -p "$dst"

	if [ -d "$outdir/images" ]; then
		mkdir -p "$dst/images"
		cp -a "$outdir/images/." "$dst/images/"
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
done
