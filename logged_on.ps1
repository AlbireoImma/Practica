$user = "<user name>" # Si se desea buscar un usuario en especifico
[string[]]$servers= Get-Content '.\collection.txt' # Lista de servidores


function on_log($servers){
	foreach ($server in $servers){
		write-host "Analizando server: $server"
		$logons = gwmi win32_loggedonuser -computername $server # Obtenemos los wmi de los inicios de sesión
		foreach ($logon in $logons){ # Recorremos los logins del servidor
			# if ($logon.antecedent -match $user){ # Condicion de usuario
				$logonid = $logon.dependent.split("=")[1] # Obtenemos el dependiente de la clase
				$logoname = $logon.antecedent.split("=")[2]
				$logonid =  $logonid -replace '["]',''
				$session = get-wmiobject -class "Win32_LogonSession" -ComputerName $server |? {$_.LogonId -match $logonid}
				$type = $session.LogonType
				if ($session.LogonType -eq "10"){
					write-host "+++++++++++++++++++++++++++++++++++++++"
					Write-host "Actividad encontrada!"
					$fecha = $session.StartTime
					Write-host "Start Time: $fecha"
					write-host "Login Name: $logoname"
					write-host "Login ID: $logonid"
					write-host "Tipo de Sesion: $type"
					write-host "---------------------------------------"
				}
			# }
		}
		write-host "Servidor Analizado: $server"
	}
}

function log_individual($server){
	$logons = gwmi win32_loggedonuser -computername $server
	foreach ($logon in $logons){ # Recorremos los logins del servidor
		# if ($logon.antecedent -match $user){ # Condicion de usuario
			$logonid = $logon.dependent.split("=")[1] # Obtenemos el dependiente de la clase
			$logoname = $logon.antecedent.split("=")[2]
			$logonid =  $logonid -replace '["]',''
			$session = get-wmiobject -class "Win32_LogonSession" -ComputerName $server |? {$_.LogonId -match $logonid}
			$type = $session.LogonType
			if ($session.LogonType -eq "10"){
				write-host "+++++++++++++++++++++++++++++++++++++++"
					Write-host "Actividad encontrada!"
					$fecha = $session.StartTime
					Write-host "Start Time: $fecha"
					write-host "Login Name: $logoname"
					write-host "Login ID: $logonid"
					write-host "Tipo de Sesion: $type"
					write-host "---------------------------------------"
			}
		# }
	}
}

on_log($servers)