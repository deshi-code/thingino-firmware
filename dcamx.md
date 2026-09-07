
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




+--------+------------+-------------+-------------------+--------------------------------------------------------------------------+
| Name   | Model      | Driver      | Extra             | Link                                                                     |
+--------+------------+-------------+-------------------+--------------------------------------------------------------------------+
| Chip   | T23N       |             |                   |                                                                          |
| Sensor | gc2083     | H20240219a |                    |                                                                          |
| Flash  | xm25QH128  |             | xmc 25qh128ch1q   | https://www.xmcwh.com/en/site/product_con/203                            |
| Wifi   | TXW901     |             |                   | https://www.globalsources.com/Telecom-IC-chipset/IOT-1227724769p.htm     |
+--------+------------+-------------+-------------------+--------------------------------------------------------------------------+

