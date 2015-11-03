@ECHO OFF
"D:\Program Files\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "D:\PROJECT\sound\labels.tmp" -fI -W+ie -C V2E -o "D:\PROJECT\sound\sound.hex" -d "D:\PROJECT\sound\sound.obj" -e "D:\PROJECT\sound\sound.eep" -m "D:\PROJECT\sound\sound.map" "D:\PROJECT\sound\sound.asm"
