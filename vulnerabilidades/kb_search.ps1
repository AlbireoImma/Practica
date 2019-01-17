cls

$vuln = "MS17-010"
$MS = ".\MS17-010.txt"

[string[]]$servers= Get-Content '..\listado_ip2.txt' # Lista de servidores
[string[]]$DNS= Get-Content '..\listado_dns2.txt' # Lista de dns
[string[]]$KBS= Get-Content $MS # Lista de dns


$contador = -1
$ruta = ".\log\$($vuln)_$(Get-Date -Uformat "%d%m%Y%H%M").csv"
"IP,HOSTNAME,KB_ID,MS,INSTALADO" >> $ruta

foreach($server in $servers){
    $contador += 1
    write-host [(Get-Date -format g)] $server": Analizando IP" -foreground "DarkYellow"
    $test = Test-Connection $server -Count 1 -Quiet
    if ($test) {
        write-host [(Get-Date -format g)] $server": Conexion establecida" -foreground "DarkGray"
        try {
            $job = start-job Get-Wmiobject -class Win32_QuickFixEngineering -computername $server -AsJob
            $estado = ($job | wait-job -Timeout 360).state
            if ($estado -eq "Completed") {
                $a = Receive-Job -Job $job | where-object {$KBS -contains $_.HotfixID} | Select-Object -property "HotFixID"
                write-host [(Get-Date -format g)] $a" :Resultado" -foreground "DarkGray"
                if ($a) {
                    write-host [(Get-Date -format g)] $server": Fix Encontrado" -foreground "DarkGray"
                    $linea = $server + "," + $DNS[$contador] + "," + $a.HotfixID + "," + $vuln + ",Si"
                    $linea >> $ruta
                } else {
                    write-host [(Get-Date -format g)] $server": Fix No Encontrado" -foreground "DarkGray"
                    $linea = $server + "," + $DNS[$contador] + ",," + $vuln + ",No"
                    $linea >> $ruta
                }
            } else {
                $job | stop-job
                $linea = $server + "," + $DNS[$contador] + ",," + $vuln + ",Tiempo Excedido"
                $linea >> $ruta
            }
            
        }
        catch {
            write-host [(Get-Date -format g)] $server": No se pudieron obtener los KB" -foreground "DarkRed"
            $linea = $server + "," + $DNS[$contador] + ",," + $vuln + ",No se pudieron obtener los KB"
            $linea >> $ruta
            write-host [(Get-Date -format g)] $server": IP Analizada" -foreground "DarkGreen"
            continue
        }
    } else {
        write-host [(Get-Date -format g)] $server": Conexion rechazada" -foreground "DarkRed"
        $linea = $server + "," + $DNS[$contador] + ",," + $vuln + ",No se pudo establecer conexion"
        $linea >> $ruta
    }
    write-host [(Get-Date -format g)] $server": IP Analizada" -foreground "DarkGreen"
}




