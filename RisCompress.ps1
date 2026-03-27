# Скрипт для сжатия файлов рисунков на основе magick

param (
[Parameter(Mandatory)]
[string]$inputfile,
[Parameter(Mandatory)]
[string]$outputfile)

& 'magick.exe' "$inputfile" `
-resize 50% `
"$outputfile" 
