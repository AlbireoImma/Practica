### populate_BD.ps1 - Francisco Abarca - 06-02-2019
## Script que genera un script SQL para SQL Server
## el cual pobla la tabla MAESTRO_SCAN

cls

[string[]]$servers= Get-Content '..\txts\IP.txt' # Lista de servidores
[string[]]$DNS= Get-Content '..\txts\DNS.txt' # Lista de dns

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

foreach ($server in $servers) {
    $contador += 1
    write-host [(Get-Date -format g)] $server": Analizando IP" -foreground "DarkYellow"
    $test = Test-Connection $server -Count 1 -Quiet
    if ($test) {
        $historial = ""
        $sesion = [activator]::CreateInstance([type]::GetTypeFromProgID("Microsoft.Update.Session",$server))
        if ($?) {
            write-host [(Get-Date -format g)] "Conexion Aceptada" -foreground "DarkGreen"
            $buscador = $sesion.CreateUpdateSearcher()
            $registros = $buscador.GetTotalHistoryCount()
            write-host [(Get-Date -format g)] $registros": Registros" -foreground "DarkGray"
            $historial = $buscador.QueryHistory(0,$registros) | where-object {2,3 -eq $_.ResultCode} | select-object Title -Unique
            if ($?) {
                write-host [(Get-Date -format g)] "Query Realizada" -foreground "DarkGreen"
                foreach ($linea in $historial) {
                    if ($linea -match "(KB\d{4,})") {
                        $line = $query + $Matches[1] + "','" + $server + "'); END Try Begin Catch End Catch"
                        $line >> $ruta
                        $go_counter += 1
                        if ($go_counter -ge 4000) {
                            "GO" >> $ruta
                            $go_counter = 0
                        }
                    }
                }
                write-host [(Get-Date -format g)] "Lineas escritas en el script" -foreground "DarkGreen"
            }
        } else {
            $line = $error_query + $server + "','Sesion rechazada'); END Try Begin Catch End Catch"
            $line >> $ruta
            $go_counter += 1
            if ($go_counter -ge 4000) {
                "GO" >> $ruta
                $go_counter = 0
            }
            write-host [(Get-Date -format g)] "Sesion rechazada" -foreground "DarkRed"
        }
    } else {
        $line = $error_query + $server + "','Conexion rechazada'); END Try Begin Catch End Catch"
        $line >> $ruta
        $go_counter += 1
        if ($go_counter -ge 4000) {
            "GO" >> $ruta
            $go_counter = 0
        }
        write-host [(Get-Date -format g)] "Conexion rechazada" -foreground "DarkRed"
    }
    write-host [(Get-Date -format g)] $server": IP Analizado" -foreground "DarkYellow"
}

$final >> $ruta
"GO" >> $ruta



