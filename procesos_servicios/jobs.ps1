### jobs.ps1 - Francisco Abarca - 06-02-2019 [Abandonado/No desarrollado totalmente] [Para una version completa revisar get_proc_ip.ps1]
## Script el cual retrae los procesos ejecutandose en los equipos designados por el archivo IP.txt
## la información es obtenida en un csv generado en la direccion de la variable $ruta


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