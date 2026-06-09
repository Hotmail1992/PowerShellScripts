function Compress-MyPdf {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]$Path,

        [Parameter(Mandatory = $false)]
        [ValidateSet('screen', 'ebook', 'printer', 'prepress')]
        [string]$Quality = 'ebook',

        [Parameter(Mandatory = $false)]
        [string]$Suffix = '_compressed'
    )

    process {
        # Разрешаем относительные пути
        $resolvedPath = Resolve-Path $Path
        $inputFile = $resolvedPath.Path
        
        # Формируем путь для выходного файла
        $directory = Split-Path $inputFile
        $filename = [System.IO.Path]::GetFileNameWithoutExtension($inputFile)
        $outputFile = Join-Path $directory ("$filename" + $Suffix + ".pdf")

        # Автоматический поиск Ghostscript в Program Files
        $gsExe = Get-ChildItem -Path "C:\Program Files\gs" -Filter "gswin64c.exe" -Recurse -ErrorAction SilentlyContinue | 
                 Select-Object -First 1

        if (-not $gsExe) {
            Write-Error "Ghostscript (gswin64c.exe) не найден в C:\Program Files\gs. Пожалуйста, установите его."
            return
        }

        Write-Host "Сжатие: $filename.pdf -> Качество: /$Quality" -ForegroundColor Cyan

        # Запуск сжатия
        $arguments = @(
            "-sDEVICE=pdfwrite",
            "-dCompatibilityLevel=1.7",
            "-dPDFSETTINGS=/$Quality",
            "-dNOPAUSE",
            "-dQUIET",
            "-dBATCH",
            "-sOutputFile=$outputFile",
            $inputFile
        )

        & $gsExe.FullName @arguments

        if ($LASTEXITCODE -eq 0) {
            Write-Host "Готово! Файл сохранен: $outputFile" -ForegroundColor Green
        } else {
            Write-Error "Произошла ошибка при работе Ghostscript."
        }
    }
}

Export-ModuleMember -Function Compress-MyPdf
