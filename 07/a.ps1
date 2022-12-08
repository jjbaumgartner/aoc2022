[CmdletBinding()]

Param(
	[Parameter(Mandatory = $false)]
	[string]$Path = "input.txt"
)

class File {
	[string]$Name
	[UInt32]$Size

	File([string]$Name, [UInt32]$Size) {
		$this.Name = $Name
		$this.Size = $Size
	}
}

class Directory {
	[string]$Name
	[Directory[]]$DirContents
	[File[]]$FileContents

	Directory([string]$Name) {
		$this.Name = $Name
		$this.FileContents = @()
		$this.DirContents = @()
	}

	[UInt32] Size() {
		return ($this.FileContents | Measure-Object -Sum Size | Select-Object -ExpandProperty Sum) + ($this.DirContents | ForEach-Object { $_.Size() } | Measure-Object -Sum | Select-Object -ExpandProperty Sum)
	}

	[Object] ls() {
		$Output = @()
		$TmpObj += New-Object Object
		$TmpObj | Add-Member -Type NoteProperty -Name Name -Value $this.Name
		$TmpObj | Add-Member -Type NoteProperty -Name Size -Value $this.Size()
		$Output += $TmpObj
		$Output += $this.DirContents | ForEach-Object { $_.ls() }
		return $Output
	}

	[string]ToString() {
		return $this.Name
	}
}

$DirPath = New-Object System.Collections.Generic.Stack[Object]
$Root = [Directory]::new("/")
$DirPath.Push($Root)

Get-Content -Path $Path | ForEach-Object {
	$Line = $_ -split "\s+"
	if($Line[0] -eq "`$") {
		# Command
		if($Line[1] -eq "ls") {
			# List
			Write-Verbose "Executing ls"
		} elseif($Line[1] -eq "cd") {
			# Change Directory
			if($Line[2] -eq "/") {
				Write-Verbose "Going to root dir"
				while($DirPath.Count -gt 1) {
					$DirPath.Pop() | Out-Null
					Write-Verbose "Moved up to $($DirPath.Name -join "/")"
				}
			} elseif($Line[2] -eq "..") {
				Write-Verbose "Moving from $($DirPath -join "/")"
				$DirPath.Pop() | Out-Null
				Write-Verbose "  to $($DirPath -join "/")"
			} elseif($null -ne $Line[2]) {
				Write-Verbose "Changing to subdirectory $($Line[2])"
				$DirPath.Push(($DirPath.Peek().DirContents | Where-Object { $_.Name -eq $Line[2] }))
			}
		}
	} else {
		# Response
		if($Line[0] -eq "dir") {
			$NewDir = [Directory]::new($Line[1])
			$DirPath.Peek().DirContents += $NewDir
			Write-Verbose "Added new directory $NewDir"
		} else {
			$DirPath.Peek().FileContents += [File]::new($Line[1], $Line[0])
			Write-Verbose "Added file $($Line[1])"
			$FileTotal += $Line[0]
		}
	}
}

$Root.ls() | Where-Object { $_.Size -le 100000 } | Measure-Object -Sum Size | Select-Object -ExpandProperty Sum