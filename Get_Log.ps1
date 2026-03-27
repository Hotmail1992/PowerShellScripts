param(
	[Parameter(Mandatory)]
	[int]$DaysAgo,
	[Parameter(Mandatory)]
	[string]$NameLog,
	[Parameter(Mandatory)]
	[int]$level
	)
$Date = (Get-Date).AddDays(-$DaysAgo)
$filter = @{
	Logname = $NameLog #System, Security, HardwareEvents, Application, Setup, Microsoft-Client-licensing-platform/admin
	StartTime = $Date	
	Level = $level # 0 - LogAlways, 1 - Critical, 2 - Error, 3 - Warning, 4 - Information
}
Get-WinEvent -FilterHashTable $filter | Format-List *
