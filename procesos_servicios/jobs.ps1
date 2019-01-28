[string[]]$servers= Get-Content '.\txts\IP.txt' # Lista de servidores
[string[]]$DNS= Get-Content '.\txts\DNS.txt' # Lista de dns
$contador = 0
$ruta = ".\log\PROCESOS\procesos_$(Get-Date -Uformat "%d%m%Y%H%M").csv"
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