[CmdletBinding()]

Param(
	[Parameter(Mandatory = $false)]
	[string]$Path = "input.txt"
)

((Get-Content -Path $Path) -join ',') -split ",," | ForEach-Object { $_ -split "," | Measure-Object -Sum | Select-Object -ExpandProperty Sum } | Sort-Object -Descending | Select-Object -First 1