# Скрипт для блокировки сайтов по IP-адресу

param (
[Parameter(Mandatory)]
[string]$DisplayName,
[Parameter(Mandatory)]
	#[System.Net.IPAddress]$address,
$address,
[Parameter(Mandatory)]
[string]$Description
			)

New-NetFirewallRule -DisplayName $DisplayName `
										-Description $Description `
										-Direction Outbound `
										-LocalPort Any `
										-Protocol Any `
										-Action Block `
										-RemoteAddress $address
