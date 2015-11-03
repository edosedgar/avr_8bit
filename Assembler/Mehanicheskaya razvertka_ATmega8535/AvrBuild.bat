@ECHO OFF
"D:\Program Files\Atmel\AVR Tools\AvrAssembler2\avrasm2.exe" -S "D:\PROJECT\meh_raz\labels.tmp" -fI -W+ie -C V2E -o "D:\PROJECT\meh_raz\meh_raz.hex" -d "D:\PROJECT\meh_raz\meh_raz.obj" -e "D:\PROJECT\meh_raz\meh_raz.eep" -m "D:\PROJECT\meh_raz\meh_raz.map" "D:\PROJECT\meh_raz\meh_raz.asm"
