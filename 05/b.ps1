[CmdletBinding()]

Param(
	[Parameter(Mandatory = $false)]
	[string]$Path = "input.txt"
)

# Load content
$Content = Get-Content -Path $Path

# Get the header/initial stack setup
$StackSetup = @()
do {
	$Line, $Content = $Content
	$StackSetup += $Line
} while($Line.Length -ne 0)

# Find the number of columns, make the stacks
$Columns = $StackSetup[-2].Trim() -split "\s+" | Sort-Object -Descending | Select-Object -First 1

$Stacks = New-Object System.Collections.Generic.List[System.Collections.Generic.Stack[Object]]
for($i = 0; $i -lt $Columns; ++$i) {
	$Stacks.Add((New-Object System.Collections.Generic.Stack[Object]))
}

for($i = $StackSetup.Length - 3 ; $i -ge 0 ; --$i) {
	for($j = 0 ; $j -lt $Columns ; ++$j) {
		$Crate = ([string]$StackSetup[$i]).SubString((($j * 4) + 1), 1)
		if($Crate -ne ' ') {
			$Stacks[$j].Push($Crate)
		}
	}
}

# Run the actions
do {
	$Line, $Content = $Content
	if($Line.Length -ne 0) {
		if($Line -match "move (\d+) from (\d+) to (\d+)") {
			$Source = $matches[2]
			$Dest = $matches[3]
			$Num = $matches[1]
			$Temp = New-Object System.Collections.Generic.Stack[Object]
			for($i = 0; $i -lt $Num; ++$i) {
				$Temp.Push($Stacks[$Source - 1].Pop())
			}
			for($i = 0; $i -lt $Num; ++$i) {
				$Stacks[$Dest - 1].Push($Temp.Pop())
			}
			Write-Verbose "Moving $Num from $Source to $Dest"
		} else {
			Write-Error "FAILED TO PARSE LINE: $Line"
		}
	}
} while($Line.Length -ne 0)

# What's on top of each stack?
$Out = @()
for($i = 0; $i -lt $Columns; ++$i) {
	$Out += $Stacks[$i].Pop()
}
$Out -join ""