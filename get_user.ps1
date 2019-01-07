Function Get-QUser {
	[cmdletbinding()]
	param(
		[String]
		$ComputerName = $env:COMPUTERNAME
	)

	If ($ComputerName -eq $env:COMPUTERNAME) {
		$stringOutput = quser.exe
	}
	Else {
        $stringOutput = Invoke-Command -ComputerName $ComputerName -ScriptBlock {quser.exe}
        write-host $stringOutput
		If (!$stringOutput) {Throw "Unable to retrieve quser info for `"$ComputerName`""}
	}

	ForEach ($line in $stringOutput) {
		If ($line -match "logon time") {Continue}

		$idleStringValue = $line.SubString(54, 9).Trim().Replace('+', '.')
		If ($idleStringValue -eq "none") {$idle = $null}
		elseif ($idleStringValue -eq ".") {$idle = $null}
		Else {$idle = [timespan]$idleStringValue}
		
		[PSCustomObject]@{
                            Username = $line.SubString(1, 20).Trim()
							SessionName = $line.SubString(23, 17).Trim()
							ID = $line.SubString(42, 2).Trim()
							State = $line.SubString(46, 6).Trim()
							IdleTime = $idle
							LogonTime = $line.SubString(65)
						}
	}
}

Get-QUser