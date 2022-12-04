[CmdletBinding()]

Param(
	[Parameter(Mandatory = $false)]
	[string]$Path = "input.txt"
)

class Range {
	[UInt32]$Low
	[UInt32]$High

	Range([string]$Range) {
		($this.Low, $this.High) = $Range -split "-"
	}

	[string] toString() {
		return (($this.Low)..($this.High)) -join ","
	}

	[bool] contains([Range]$Compare) {
		if(($this.Low -le $Compare.Low) -and ($this.High -ge $Compare.High)) {
			return $true
		}
		return $false
	}

	[bool] overlaps([Range]$Compare) {
		if((($Compare.Low -ge $This.Low) -and ($Compare.Low -le $this.High)) -or (($Compare.High -ge $This.Low) -and ($Compare.High -le $This.High))) {
			return $true
		}
		return $false
	}
}

$Total = 0
Get-Content -Path $Path | ForEach-Object {
	$Orders = $_ -split ","
	
	$AddOne = 0
	if([Range]::new($Orders[0]).overlaps($Orders[1])) {
		"$($Orders[0]) contains $($Orders[1])" | Write-Verbose
		$AddOne = 1
	}
	if([Range]::new($Orders[1]).overlaps($Orders[0])) {
		"$($Orders[1]) contains $($Orders[0])" | Write-Verbose
		$AddOne = 1
	}
	$Total += $AddOne
}
$Total