# Пример: последние 10 ошибок из журнала System
Get-WinEvent -FilterHashtable @{
    LogName = 'System' 
    Level   = 2  ` # 1-Критическая, 2-Ошибка, 3-Предупреждение, 4-Инфо 
} -MaxEvents 10
