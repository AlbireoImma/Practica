#IP;DNS;LOGID;LOGNAME;FECHA;TIPO;ERROR
$user = "<user name>" # Si se desea buscar un usuario en especifico
[string[]]$servers= Get-Content '.\listado_ip2.txt' # Lista de servidores
$date = Get-Date -Format d
[string[]]$DNS= Get-Content '.\listado_dns2.txt' # Lista de dns
$contador = 0
$ruta = ".\user_logged\log\logins_$(Get-Date -Uformat "%d%m%Y%H%M").csv"
write-host [(Get-Date -Format g)]"Inicio de Trabajo" -Foreground "Green"
function on_log($servers){
	"IP;DNS;LOGID;LOGNAME;FECHA;TIPO;ERROR" >> $ruta
	foreach ($server in $servers){
		write-host [(Get-Date -Format g)]"Analizando server: $server" -foreground "DarkGreen"
		$logons = gwmi win32_loggedonuser -computername $server -erroraction silentlycontinue # Obtenemos los wmi de los inicios de sesión
		if($?){
			foreach ($logon in $logons){ # Recorremos los logins del servidor
				$logonid = $logon.dependent.split("=")[1] # Obtenemos el dependiente de la clase
				$logoname = $logon.antecedent.split("=")[2]
				$logonid =  $logonid -replace '["]',''
				$session = get-wmiobject -class "Win32_LogonSession" -ComputerName $server -erroraction silentlycontinue |? {$_.LogonId -match $logonid}
				$type = $session.LogonType
				$fecha = $session.StartTime
				$linea = $server + ";" + $DNS[$contador] + ";" + $logonid + ";" + $logoname + ";" + $fecha + ";" + $type + ";"
				$linea >> $ruta
			}
		} else {
			$linea = $server + ";" + $DNS[$contador] + ";;;;; Error al obtener las clases wmi"
			$linea >> $ruta
		}
		write-host [(Get-Date -Format g)]"Servidor Analizado: $server" -foreground "Green"
		$contador = $contador + 1
		$job | Remove-Job -erroraction silentlycontinue
		$jobber | Remove-Job -erroraction silentlycontinue
	}
	write-host [(Get-Date -Format g)]"Final del Trabajo" -Foreground "Green"
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