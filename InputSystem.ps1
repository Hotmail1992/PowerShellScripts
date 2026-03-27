# Список системных имен, которые мы игнорируем
$SystemUsers = @("SYSTEM", "NETWORK SERVICE", "LOCAL SERVICE", "DWM-*", "UMFD-*")

$Date = (Get-Date).AddDays(-4)

$Events = Get-WinEvent -FilterHashtable @{
    LogName = 'Security'
    StartTime = $Date 
    Id = 4624 # Только успешные входы
}

$HumanLogons = foreach ($Event in $Events) {
    $User = $Event.Properties[5].Value # Имя пользователя
    $LogonType = $Event.Properties[8].Value # Тип входа (2-локально, 10-RDP, 7-разблокировка)

    # Проверяем, не является ли пользователь системным
    $isSystem = $false
    foreach ($sys in $SystemUsers) { if ($User -like $sys) { $isSystem = $true } }

    if (-not $isSystem -and $User -ne "-") {
        [PSCustomObject]@{
            Time      = $Event.TimeCreated
            User      = $User
            Type      = switch($LogonType) {
				#                            2  {"Локально (Консоль)"}
				                    7  {"Разблокировка экрана"}
				#                            10 {"Удаленно (RDP)"}
				#                   3  {"Сетевой доступ"}
				#                      default {"Другое ($LogonType)"}
                        }
            IP        = $Event.Properties[18].Value # IP адрес источника
        }
    }
}

$HumanLogons | Out-GridView
