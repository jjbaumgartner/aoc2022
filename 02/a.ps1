[CmdletBinding()]

Param(
	[Parameter(Mandatory = $false)]
	[string]$Path = "input.txt"
)

$TotalScore = 0
Get-Content -Path $Path | ForEach-Object {
	($Opponent, $Me) = $_ -split "\W+"
	$Opponent = switch ($Opponent) {
		"A" { "Rock" ; break }
		"B" { "Paper" ; break }
		"C" { "Scissors" ; break }
	}
	$Me = switch ($Me) {
		"X" { "Rock" ; break }
		"Y" { "Paper" ; break }
		"Z" { "Scissors" ; break }
	}
	Write-Verbose "Opponent = $Opponent, Me = $Me"
	$Score = switch ($Opponent) {
		"Rock" {
			switch ($Me) {
				"Rock" { 1 + 3 ; break }
				"Paper" { 2 + 6 ; break }
				"Scissors" { 3 + 0 ; break }
			}
			break;
		}
		"Paper" {
			switch ($Me) {
				"Rock" { 1 + 0 ; break }
				"Paper" { 2 + 3 ; break }
				"Scissors" { 3 + 6 ; break }
			}
			break;
		}
		"Scissors" {
			switch ($Me) {
				"Rock" { 1 + 6 ; break }
				"Paper" { 2 + 0 ; break }
				"Scissors" { 3 + 3 ; break }
			}
			break;
		}
	}
	Write-Verbose "  Score = $Score"
	$TotalScore += $Score
}
Write-Output $TotalScore