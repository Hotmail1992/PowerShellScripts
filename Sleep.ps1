
# 1. Задаем временной интервал (последние 24 часа)
$Filter = @{
    LogName   = 'System'
    ProviderName = 'Microsoft-Windows-Kernel-Power', 'EventLog'
    ID        = 42, 107, 6005, 6006
    StartTime = (Get-Date).AddDays(-1)
}

# 2. Собираем события и сортируем по хронологии (от старых к новым)
$Events = Get-WinEvent -FilterHashtable $Filter -ErrorAction SilentlyContinue | Sort-Object TimeCreated

if (-not $Events) {
    Write-Warning "Событий включения/сна за последние 24 часа не найдено."
    return
}

$TotalActiveTime = New-TimeSpan
$LastWakeTime = $null

# Если первое событие в списке — это сон, значит до этого ноутбук работал
if ($Events[0].Id -eq 42 -or $Events[0].Id -eq 6006) {
    $LastWakeTime = (Get-Date).AddDays(-1)
}

# 3. Рассчитываем интервалы
foreach ($E in $Events) {
    if ($E.Id -eq 107 -or $E.Id -eq 6005) {
        # Запомнили время включения/пробуждения
        $LastWakeTime = $E.TimeCreated
    }
    elseif (($E.Id -eq 42 -or $E.Id -eq 6006) -and $LastWakeTime -ne $null) {
        # Компьютер заснул. Добавляем пройденный интервал к общему времени
        $TotalActiveTime += ($E.TimeCreated - $LastWakeTime)
        $LastWakeTime = $null
    }
}

# Если компьютер работает прямо сейчас (нет финального события сна)
if ($LastWakeTime -ne $null) {
    $TotalActiveTime += ((Get-Date) - $LastWakeTime)
}

# 4. Выводим красивый результат
[PSCustomObject]@{
    "Период анализа"       = "Последние 24 часа"
    "Чистое время работы"  = "{0} ч. {1} мин." -f [math]::Truncate($TotalActiveTime.TotalHours), $TotalActiveTime.Minutes
    "В режиме сна/выключен" = "{0} ч. {1} мин." -f [math]::Truncate((New-TimeSpan -Days 1).TotalHours - $TotalActiveTime.TotalHours), (60 - $TotalActiveTime.Minutes)
} | Format-List
