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

$VisibleCount = 0
for($row = 0; $row -lt $Map.Count; ++$row) {
	for($col = 0; $col -lt $Map[$row].Count; ++$col) {
		$EdgeVisible = $true
		$LeftVisible = $true
		$RightVisible = $true
		$TopVisible = $true
		$BottomVisible = $true

		# Edges are immediately visible
		if(($row -eq 0) -or ($row -eq ($Map.Count - 1)) -or ($col -eq 0) -or ($col -eq ($Map[$row].Count - 1))) {
			Write-Verbose "[$row][$col] EDGE VISIBLE"
			$EdgeVisible = $true
		} else {
			$EdgeVisible = $false`
		}

		# Check the left part of the row
		for($i = 0; $i -lt $col; ++$i) {
			if($Map[$row][$i] -ge $Map[$row][$col]) {
				Write-Verbose "[$row][$col] LEFT IS TALLER/EQUAL"
				$LeftVisible = $false
			}
		}

		# Check the right part of the row
		for($i = $col + 1; $i -lt $Map[$row].Count; ++$i) {
			if($Map[$row][$i] -ge $Map[$row][$col]) {
				Write-Verbose "[$row][$col] RIGHT IS TALLER/EQUAL"
				$RightVisible = $false
			}
		}

		# Check the top part of the column
		for($i = 0; $i -lt $row; ++$i) {
			if($Map[$i][$col] -ge $Map[$row][$col]) {
				Write-Verbose "[$row][$col] TOP IS TALLER/EQUAL"
				$TopVisible = $false
			}
		}

		# Check the bottom part of the column
		for($i = $row + 1; $i -lt $Map[$row].Count; ++$i) {
			if($Map[$i][$col] -ge $Map[$row][$col]) {
				Write-Verbose "[$row][$col] BOTTOM IS TALLER/EQUAL"
				$BottomVisible = $false
			}
		}

		# Is it visible or not?
		if($EdgeVisible -or $LeftVisible -or $RightVisible -or $TopVisible -or $BottomVisible) {
			Write-Verbose "--VERDICT-- [$row][$col] VISIBLE"
			++$VisibleCount
		} else {
			Write-Verbose "--VERDICT-- [$row][$col] NOT VISIBLE"
		}
	}
}
$VisibleCount