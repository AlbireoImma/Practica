[string[]]$servers= Get-Content '.\listado_ip2.txt' # Lista de servidores
$date = Get-Date -Format d # Fecha para asuntos de formato
write-host [(Get-Date -Format g)]" Inicio de Script" -foreground "Green"
foreach ($server in $servers){
	try {
		">>> Server: "+$server >> ".\user_logged\log\sesiones_$date.log"
		$job = get-wmiobject Win32_PerfFormattedData_LocalSessionManager_TerminalServices -ComputerName $server -AsJob -erroraction silentlycontinue | Wait-Job -Timeout 30
		$sesiones = $job | Receive-Job -erroraction silentlycontinue | select ActiveSessions,TotalSessions
	} catch [System.UnauthorizedAccessException],[GetWMICOMException]{
		"<< Error al intentar obtener la clase WMI" >> ".\user_logged\log\sesiones_$date.log"
		"<< Revisar configuracion WMI, RCP, permisos y/o conexión de la ip a la red" >> ".\user_logged\log\sesiones_$date.log"
	} catch {
		"<< Error al intentar obtener la clase WMI" >> ".\user_logged\log\sesiones_$date.log"
	} finally {
		"<< Sesiones: "+$sesiones.TotalSessions >> ".\user_logged\log\sesiones_$date.log"
		"<< Sesiones Activas: "+$sesiones.ActiveSessions >> ".\user_logged\log\sesiones_$date.log"
	}
}
write-host [(Get-Date -Format g)]" Finalizacion de Script" -foreground "Green"