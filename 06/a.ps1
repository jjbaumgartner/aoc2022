[CmdletBinding()]

Param(
	[Parameter(Mandatory = $false)]
	[string]$Path = "input.txt"
)

$Data = (Get-Content -Path $Path) -split ""

$Buffer = New-Object System.Collections.Generic.Queue[System.Object]

$First = $null
$Count = 0
while($Data.Count -gt 0) {
	$Char, $Data = $Data
	if($Char -notin ('a'..'z')) { continue }
	Write-Verbose "Processing $Char"
	$Count++
	$Buffer.Enqueue($Char)
	while($Buffer.Count -gt 4) {
		Write-Verbose "Dequeuing down to 4"
		$Buffer.Dequeue() | Out-Null
	}
	if($Buffer.Count -eq 4) {
		Write-Verbose "Queue is at length 4"
		if(($Buffer | Sort-Object -Unique).Count -eq 4) {
			if($null -eq $First) {
				$First = $Count
			}
		}
	}
}
$First