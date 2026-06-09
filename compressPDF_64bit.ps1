# Скрипт для сжатия файлов pdf с помощью ghostscript

Param (
 [Parameter(Mandatory)]
 [string]$inputfile,
 [Parameter(Mandatory)]
 [string]$outputfile
)

 gswin64c.exe -dSAFER `
             -dBATCH `
             -sDEVICE=pdfwrite `
             -dCompatibilityLevel="1.7" `
             -dPDFSETTINGS=/ebook `
             -dNOPAUSE `
            -dQUIET `
            -sOutputFile="$outputfile" "$inputfile"
