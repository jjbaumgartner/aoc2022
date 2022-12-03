[CmdletBinding()]

Param(
	[Parameter(Mandatory = $false)]
	[string]$Path = "input.txt"
)

Get-Content -Path $Path | ForEach-Object {
	($CompA, $CompB) = $_.Substring(0, $_.Length / 2), $_.Substring($_.Length / 2, $_.Length / 2)
	$CompA = $CompA -split "" | Where-Object { $_.Length -gt 0 }
	$CompB = $CompB -split "" | Where-Object { $_.Length -gt 0 }
	Write-Verbose "$_ ($($CompA -join ",")) ($($CompB -join ","))"
	foreach ($Item in $CompA) {
			if($Item -cin $CompB) {
				Write-Verbose "$Item in both A and B"
				$Duplicate = $Item
			}
	}
	if($Duplicate -cin ('a'..'z')) {
		[char]$Duplicate - 96
	} else {
		[char]$Duplicate - 38
	}
} | Measure-Object -Sum | Select-Object -ExpandProperty Sum