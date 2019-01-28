cls

[string[]]$servers= Get-Content '.\txts\IP.txt' # Lista de servidores
[string[]]$DNS= Get-Content '.\txts\DNS.txt' # Lista de dns

$contador = -1

$ruta = "..\scripts\HISTORICO_KB\Script_HISTORICO_KB_$(Get-Date -Uformat "%d%m%Y%H%M").sql"
$date = (get-date -Format 'yyyy-MM-dd hh:mm:ss')
$go_counter = 0
$query = "BEGIN Try INSERT INTO sondeoBK.dbo.HISTORICO_KB(FECHA,KB,IP) VALUES ('"
$error_query = "BEGIN Try INSERT INTO sondeoBK.dbo.ERROR_IP(FECHA,IP,ERROR) VALUES ('"
$query = $query + $date + "','"
$error_query = $error_query + $date + "','"
$inicial = "BEGIN Try INSERT INTO sondeoBK.dbo.MAESTRO_SCAN(FECHA,ESTADO) VALUES ('" + $date + "','INICIADO'); END Try Begin Catch End Catch"
$inicial >> $ruta
$final = "UPDATE sondeoBK.dbo.MAESTRO_SCAN SET ESTADO = 'FINALIZADO' WHERE FECHA = '" + $date + "';"

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
                $a = Receive-Job $job | Select-Object -property "HotFixID"
                foreach($KB in $a){
                    $query + $KB.hotfixid + "','" + $server + "'); END Try Begin Catch End Catch" >> $ruta
                    $go_counter += 1
                    if ($go_counter -ge 4000) {
                        "GO" >> $ruta
                        $go_counter = 0
                    }
                }
                remove-job -state completed
            } else {
                stop-job $job
                remove-job -state failed
                $error_query + $server + "','Timeout'); END Try Begin Catch End Catch" >> $ruta
                $go_counter += 1
                if ($go_counter -ge 4000) {
                    "GO" >> $ruta
                    $go_counter = 0
                }
            }
        } else {
            write-host [(Get-Date -format g)] $server": No se pudieron obtener los KB" -foreground "DarkRed"
            $error_query + $server + "','Error de obtencion'); END Try Begin Catch End Catch" >> $ruta
            write-host [(Get-Date -format g)] $server": IP Analizada" -foreground "DarkGreen"
            $go_counter += 1
            if ($go_counter -ge 4000) {
                "GO" >> $ruta
                $go_counter = 0
            }
        }
    } else {
        write-host [(Get-Date -format g)] $server": Conexion rechazada" -foreground "DarkRed"
        $error_query + $server + "','Error de conexion'); END Try Begin Catch End Catch" >> $ruta
        $linea >> $ruta
        $go_counter += 1
        if ($go_counter -ge 4000) {
            "GO" >> $ruta
            $go_counter = 0
        }
    }
    write-host [(Get-Date -format g)] $server": IP Analizada" -foreground "DarkGreen"
}

$final >> $ruta
"GO" >> $ruta



