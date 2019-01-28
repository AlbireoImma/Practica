# SERVER;DNS;TOTAL;ACTIVAS;ERROR
[string[]]$servers= Get-Content '.\txts\IP.txt' # Lista de servidores
[string[]]$DNS= Get-Content '.\txts\DNS.txt' # Lista de dns
$contador = 0 # Para movernos por los nombres de dominio mientras recorremos los servidores
$date = Get-Date -Format d # Fecha para asuntos de formato
$ruta = ".\log\SESIONES\sesiones_$(Get-Date -Uformat "%d%m%Y%H%M").csv"
write-host [(Get-Date -Format g)]" Inicio de Script" -foreground "Green"
"SERVER;DNS;TOTAL;ACTIVAS;ERROR" >> $ruta
foreach ($server in $servers){
	try {
		$job = get-wmiobject Win32_PerfFormattedData_LocalSessionManager_TerminalServices -ComputerName $server -AsJob -erroraction silentlycontinue | Wait-Job -Timeout 30
		$sesiones = $job | Receive-Job -erroraction silentlycontinue | select ActiveSessions,TotalSessions
		$linea = $server + ";" + $DNS[$contador] + ";" + $sesiones.TotalSessions + ";" + $sesiones.ActiveSessions + ";"
	} catch [System.UnauthorizedAccessException],[GetWMICOMException]{
		$linea = $linea + "1"
	} catch {
		$linea = $linea + "1"
	} finally {
		$linea >> $ruta
		$linea = ""
		$contador = $contador + 1
	}
}
write-host [(Get-Date -Format g)]" Finalizacion de Script" -foreground "Green"