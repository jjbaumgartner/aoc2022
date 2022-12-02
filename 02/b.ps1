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
		"X" { "Lose" ; break }
		"Y" { "Draw" ; break }
		"Z" { "Win" ; break }
	}
	Write-Verbose "Opponent = $Opponent, Me = $Me"
	$Score = switch ($Opponent) {
		"Rock" {
			switch ($Me) {
				"Win" { 2 + 6 ; break }
				"Lose" { 3 + 0 ; break }
				"Draw" { 1 + 3 ; break }
			}
			break;
		}
		"Paper" {
			switch ($Me) {
				"Win" { 3 + 6 ; break }
				"Lose" { 1 + 0 ; break }
				"Draw" { 2 + 3 ; break }
			}
			break;
		}
		"Scissors" {
			switch ($Me) {
				"Win" { 1 + 6 ; break }
				"Lose" { 2 + 0 ; break }
				"Draw" { 3 + 3 ; break }
			}
			break;
		}
	}
	Write-Verbose "  Score = $Score"
	$TotalScore += $Score
}
Write-Output $TotalScore