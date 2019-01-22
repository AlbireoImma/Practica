cls

$vuln = "MS17-010"
$MS = ".\" + $vuln + ".txt"

[string[]]$servers= Get-Content '..\listado_ip2.txt' # Lista de servidores
[string[]]$DNS= Get-Content '..\listado_dns2.txt' # Lista de dns
[string[]]$KBS= Get-Content $MS # Lista de dns

$contador = -1
$ruta = ".\log\$($vuln)_$(Get-Date -Uformat "%d%m%Y%H%M").csv"
"IP,HOSTNAME,KB_ID,MS,INSTALADO,ERROR" >> $ruta

foreach($server in $servers){
    $contador += 1
    write-host [(Get-Date -format g)] $server": Analizando IP" -foreground "DarkYellow"
    $test = Test-Connection $server -Count 1 -Quiet
    if ($test) {
        write-host [(Get-Date -format g)] $server": Conexion establecida" -foreground "DarkGray"
        $job = Get-Wmiobject -class Win32_QuickFixEngineering -computername $server -AsJob
        if($?){
            $estado = ($job | wait-job -Timeout 360).state
            if ($estado -eq "Completed") {
                $a = Receive-Job $job | where-object {$KBS -contains $_.HotfixID} | Select-Object -property "HotFixID"
                if ($a) {
                    write-host [(Get-Date -format g)] $server": Fix Encontrado" -foreground "DarkGray"
                    $linea = $server + "," + $DNS[$contador] + "," + $a.HotfixID + "," + $vuln + ",Si,Ninguno"
                    $linea >> $ruta
                } else {
                    write-host [(Get-Date -format g)] $server": Fix No Encontrado" -foreground "DarkGray"
                    $linea = $server + "," + $DNS[$contador] + ",," + $vuln + ",No,Ninguno"
                    $linea >> $ruta
                }
                remove-job -state completed
            } else {
                stop-job $job
                remove-job -state failed
                $linea = $server + "," + $DNS[$contador] + ",," + $vuln + ",Desconocido,Tiempo Excedido o error al crear el trabajo"
                $linea >> $ruta
            }
        } else {
            write-host [(Get-Date -format g)] $server": No se pudieron obtener los KB" -foreground "DarkRed"
            $linea = $server + "," + $DNS[$contador] + ",," + $vuln + ",Desconocido,No se pudieron obtener los KB"
            $linea >> $ruta
            write-host [(Get-Date -format g)] $server": IP Analizada" -foreground "DarkGreen"
        }
    } else {
        write-host [(Get-Date -format g)] $server": Conexion rechazada" -foreground "DarkRed"
        $linea = $server + "," + $DNS[$contador] + ",," + $vuln + ",Desconocido,No se pudo establecer conexion"
        $linea >> $ruta
    }
    write-host [(Get-Date -format g)] $server": IP Analizada" -foreground "DarkGreen"
}




