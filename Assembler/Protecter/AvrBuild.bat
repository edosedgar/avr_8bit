@ECHO OFF
"D:\Program_Files\Atmel\AVR Studio 4\AvrAssembler2\avrasm2.exe" -S "E:\AVR_PROJECT\Assembler\Protecter\labels.tmp" -fI -W+ie -C V2E -o "E:\AVR_PROJECT\Assembler\Protecter\Protecter.hex" -d "E:\AVR_PROJECT\Assembler\Protecter\Protecter.obj" -e "E:\AVR_PROJECT\Assembler\Protecter\Protecter.eep" -m "E:\AVR_PROJECT\Assembler\Protecter\Protecter.map" "E:\AVR_PROJECT\Assembler\Protecter\Protecter.asm"