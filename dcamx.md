
# DeshiCode Dcamx

Main Chip: Ingenic T23N
Sensor: GC2083
WIFI: txw901
Flash Size: 16MB

## GPIO 
| Name | PCB Label | GPIO | Configuration | Logic Level | Comments |
|------|-----------|------|---------------|-------------|----------|
| White Led | WL | 17 | Active High | 3.3 | Used in low light env.|
| Staus Led | BLU | 16 | Active High | 3.3 | |
| IR LEDs | IR | 59 | Active High | 3.3 | Lights up the ir array. |
| Light Sensor | IRC | 14 | - | - | Using info from [Chinese Firmware](findings).|
| IR CUT | IRCUT | 57 | Active High | 3.3 | Goes into the motor driver's ain |
| IR CUT | IRCUT | 58 | Active High | 3.3 | Goes into the motor drivers' bin |
| Speaker | SPK | 7 | - | - | Got it from the [Chinese Firmware bin.](findings) |
| Reset Button | RST | 50 | Active Low, pull-up | 3.3 | Found by GPIO scan, confirmed working (chime on press) after a clean rebuild. |
| SD Card Detect | CD | 49 | Active Low, pull-up | 3.3 | Found by GPIO scan, confirmed working (auto-mount on insert/remove) after a clean rebuild. |
| Sensor Reset | - | 18 | Active High | 3.3 | GC2083 reset line. Already found/driven by the kernel's own `sensor_reset` driver (`BR2_PACKAGE_THINGINO_RAPTOR_CONF_SENSOR_RST_GPIO` auto-detect) - nothing to configure. |
| Tilt Motor (MV) | - | 51, 61, 62, 63 | 4-wire, via ULN2803 | 3.3 | Found by GPIO scan + spin test. Order confirmed: clean clockwise rotation in this order. |
| Pan Motor (MH) | - | 53, 52, 54, 64 | 4-wire, via ULN2803 | 3.3 | Found by GPIO scan + spin test. Order confirmed: clean counter-clockwise rotation in this order. |

**Siren**: still unknown. `play /usr/share/sounds/chime_1.opus` was tested as a "maybe it's just the
amp output on the jack" theory - ruled out, the sound came from the onboard speaker, not the
jack-connected siren. So it is a separate trigger, not piggybacking on GPIO 7. Still to find.




+--------+------------+-------------+-------------------+--------------------------------------------------------------------------+
| Name   | Model      | Driver      | Extra             | Link                                                                     |
+--------+------------+-------------+-------------------+--------------------------------------------------------------------------+
| Chip   | T23N       |             |                   |                                                                          |
| Sensor | gc2083     | H20240219a |                    |                                                                          |
| Flash  | xm25QH128  |             | xmc 25qh128ch1q   | https://www.xmcwh.com/en/site/product_con/203                            |
| Wifi   | TXW901     |             |                   | https://www.globalsources.com/Telecom-IC-chipset/IOT-1227724769p.htm     |
+--------+------------+-------------+-------------------+--------------------------------------------------------------------------+

