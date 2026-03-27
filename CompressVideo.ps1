# Скрипт для сжатия видео при помощи ffmpeg

param (
#[Parameter(Mandatory)]
[string]$inputfile,
#[Parameter(Mandatory)]
[string]$outputfile)

& ${env:programfiles(x86)}\ffmpeg\bin\ffmpeg.exe `
-i "$inputfile" `
-vcodec libx265 `
-preset fast `
"$outputfile"

