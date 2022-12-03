[CmdletBinding()]

Param(
	[Parameter(Mandatory = $false)]
	[string]$Path = "input.txt"
)

$Data = Get-Content -Path $Path

$Total = 0
while($Data.Length -gt 0) {
	$Group = $Data[0..2]
	$Data = $Data[3..$Data.Length]
	for($i = 0; $i -lt $Group.Length; $i++) {
		$Group[$i] = $Group[$i] -split "" | Where-Object { $_.Length -gt 0 }
	}
	$Items = foreach($Item in $Group[0]) {
		if(($Item -cin $Group[1]) -and ($Item -cin $Group[2])) {
			$Item
		}
	}
	$Duplicate = $Items | Sort-Object -Unique
	$Total += if($Duplicate -cin ('a'..'z')) {
		[char]$Duplicate - 96
	} else {
		[char]$Duplicate - 38
	}
}
$Total