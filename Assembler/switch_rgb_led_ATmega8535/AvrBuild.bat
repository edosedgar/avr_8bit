@ECHO OFF
"D:\Program Files\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "D:\PROJECT\switch_rgb_led\labels.tmp" -fI -W+ie -C V2E -o "D:\PROJECT\switch_rgb_led\switch_rgb_led.hex" -d "D:\PROJECT\switch_rgb_led\switch_rgb_led.obj" -e "D:\PROJECT\switch_rgb_led\switch_rgb_led.eep" -m "D:\PROJECT\switch_rgb_led\switch_rgb_led.map" "D:\PROJECT\switch_rgb_led\switch_rgb_led.asm"
