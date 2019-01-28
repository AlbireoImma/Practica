#IP;DNS;USER;SESION;ID;STATE;IDLE;LOGON;ERROR
[string[]]$servers = Get-Content '.\txts\IP.txt' # Archivo con las ip a analizar
[string[]]$DNS= Get-Content '.\txts\DNS.txt' # Lista de dns
$date = Get-Date -Format d # Fecha para asuntos de formato
write-host [(Get-Date -Format f)]" Iniciando Script" -foreground "Yellow"
# $date + " Iniciando barrido de servidores" >> ".\user_logged\log\users_$date.log"
$trap = 0
$contador = 0
"IP;DNS;USER;SESION;ID;STATE;IDLE;LOGON;ERROR" >> ".\user_logged\log\users_$date.csv"
foreach ($server in $servers) {
	write-host "Viendo server: $server" -foreground "Cyan"
    # "Detalle: $server" >> ".\user_logged\log\users_$date.log"
	$query = quser /server:$server
	if($?){
		foreach($ServerLine in @($query) -split "\n"){ #Each Server Line #USERNAME SESSIONNAME ID  STATE  IDLE TIME  LOGON TIME
			if ($trap -eq 0) {
				$trap = 1
			} else {
				$Parsed_Server = $ServerLine -split '\s+'
				$linea = $server + ";" + $DNS[$contador] + ";"
				$linea = $linea + $Parsed_Server[1] + ";" #USERNAME
				$linea = $linea + $Parsed_Server[2] + ";" #SESSIONNAME
				$linea = $linea + $Parsed_Server[3] + ";" #ID
				$linea = $linea + $Parsed_Server[4] + ";" #STATE
				$linea = $linea + $Parsed_Server[5] + ";" #IDLE TIME
				$linea = $linea + $Parsed_Server[6] + ";" #LOGON TIME
				$linea >> ".\log\USERS\users_$date.csv"
			}
		}
	}
	else {
		$linea = $server + ";" + $DNS[$contador] + ";;;;;;;Error al hacer la query, problemas de RPC, Firewall o no hay usuarios conectados"
		$linea >> ".\log\USERS\users_$date.csv"
	}
	$contador = $contador + 1
	$trap = 0
}
# $date + " Barrido de servidores terminado" >> ".\user_logged\log\users_$date.log"
write-host [(Get-Date -Format f)]" Script Finalizado" -foreground "Green"

