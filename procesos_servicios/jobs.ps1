[string[]]$servers= Get-Content '..\listado_ip2.txt' # Lista de servidores
[string[]]$DNS= Get-Content '..\listado_dns2.txt' # Lista de dns
$contador = 0
$ruta = ".\log\logins_$(Get-Date -Uformat "%d%m%Y%H%M").csv"
"DNS;IP;NombreProceso;IDSesion;Error" >> $ruta
$fecha = Get-Date -Uformat "%d%m%Y%H%M"

foreach ($server in $servers) {
    try {
        $procesos = tasklist /S $server /V
        foreach ($proceso in $procesos) {
            $linea = $DNS[$contador] + ";" + $server
            $linea = $linea + ";" + $proceso.ProcessName
            $linea = $linea + ";" + $proceso.SessionId + ";0"
            $linea >> $ruta
            $linea = ""
        }
    } catch {
        $linea = $DNS[$contador] + ";" + $server + ";;;1"
        $linea >> $ruta
    }
    $contador = $contador + 1
}