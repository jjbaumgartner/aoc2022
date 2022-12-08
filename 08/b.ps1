[CmdletBinding()]

Param(
	[Parameter(Mandatory = $false)]
	[string]$Path = "input.txt"
)

$Map = New-Object System.Collections.Generic.List[Object]

# Build the map
Get-Content -Path $Path | ForEach-Object {
	$MapRow = New-Object System.Collections.Generic.List[Object]
	$_.Trim() -split "" | Where-Object { $_.Length -gt 0 } | ForEach-Object {
		$MapRow.Add($_)
	}
	$Map.Add($MapRow)
}

$HighScore = 0
for($row = 1; $row -lt $Map.Count - 1; ++$row) {
	for($col = 1; $col -lt $Map[$row].Count - 1; ++$col) {
		# Look up
		$Up = 0
		for($i = $row - 1; $i -ge 0; --$i) {
			++$Up
			if($Map[$i][$col] -ge $Map[$row][$col]) {
				break
			}
		}
		Write-Verbose "[$row][$col] UP = $Up"

		# Look down
		$Down = 0
		for($i = $row + 1; $i -lt $Map.Count; ++$i) {
			++$Down
			if($Map[$i][$col] -ge $Map[$row][$col]) {
				break
			}
		}
		Write-Verbose "[$row][$col] DOWN = $Down"

		# Look left
		$Left = 0
		for($i = $col - 1; $i -ge 0; --$i) {
			++$Left
			if($map[$row][$i] -ge $Map[$row][$col]) {
				break
			}
		}
		Write-Verbose "[$row][$col] LEFT = $Left"

		# Look right
		$Right = 0
		for($i = $col + 1; $i -lt $Map[$row].Count; ++$i) {
			++$Right
			if($Map[$row][$i] -ge $Map[$row][$col]) {
				break
			}
		}
		Write-Verbose "[$row][$col] RIGHT = $Right"

		# Calculate score
		$Score = $Up * $Down * $Left * $Right
		if($Score -gt $HighScore) {
			Write-Verbose "--- [$row][$col] Score = $Score"
			$HighScore = $Score
		}
	}
}
$HighScore