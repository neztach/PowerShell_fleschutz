<#
.SYNOPSIS
	Lists DNS servers
.DESCRIPTION
	This PowerShell script measures the latency of public and free DNS servers and lists it.
.EXAMPLE
	PS> ./list-dns-servers.ps1
      
	Provider                IPv4                             Latency
	--------                ----                             -------
	AdGuard DNS (Cyprus)    94.140.14.14 / 94.140.15.15      222 / 205 ms
	...
.LINK
	https://github.com/fleschutz/PowerShell
.NOTES
	Author: Markus Fleschutz | License: CC0
#>

function CheckDNSServer { param($Provider, $IPv4Pri, $IPv4Sec)
	Write-Progress "Measuring latency of $Provider..."
	$SW=[system.diagnostics.stopwatch]::startNew();$null=(nslookup fleschutz.de $IPv4Pri 2>$null);[int]$Lat1=$SW.Elapsed.TotalMilliseconds

	$SW=[system.diagnostics.stopwatch]::startNew();$null=(nslookup fleschutz.de $IPv4Sec 2>$null);[int]$Lat2=$SW.Elapsed.TotalMilliseconds

	New-Object PSObject -Property @{ Provider=$Provider; IPv4="$IPv4Pri / $IPv4Sec"; Latency="$Lat1 / $Lat2 ms" }
}

function List-DNS-Servers {
	Write-Progress "Loading Data/public-dns-servers.csv..."
      $Table = Import-CSV "$PSScriptRoot/../data/public-dns-servers.csv"
	foreach($Row in $Table) {
		CheckDNSServer $Row.PROVIDER $Row.IPv4_PRI $Row.IPv4_SEC	
	}
	Write-Progress -completed "."
}
 
try {
	List-DNS-Servers | Format-Table -property @{e='Provider';width=50},@{e='IPv4';width=32},@{e='Latency';width=15}
	exit 0 # success
} catch {
	"⚠️ Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}