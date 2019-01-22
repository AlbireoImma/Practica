cls

$vuln = "MS17-010"
$MS = ".\" + $vuln + ".txt"

[string[]]$servers= Get-Content '..\listado_ip2.txt' # Lista de servidores
[string[]]$DNS= Get-Content '..\listado_dns2.txt' # Lista de dns
[string[]]$KBS= Get-Content $MS # Lista de dns

$FLAG = 0
$contador = -1
$ruta = ".\log\$($vuln)_$(Get-Date -Uformat "%d%m%Y%H%M").csv"
"IP,HOSTNAME,KB_ID,MS,INSTALADO,ERROR,VALOR,INCERTIDUMBRE" >> $ruta

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
            $historial = $buscador.QueryHistory(0,$registros) | where-object {2,3 -eq $_.ResultCode} | select-object Title
            write-host [(Get-Date -format g)] "Query Realizada" -foreground "DarkGreen"
            foreach ($linea in $historial) {
                if ($linea -match "(KB\d{4,})") {
                    if ($KBS -contains $Matches[1]) {
                        write-host [(Get-Date -format g)] "Fix Encontrado" -foreground "Green"
                        $line = $server + "," + $DNS[$contador] + "," + $Matches[1] + "," + $vuln + ",Si,Ninguno,1,0"
                        $line >> $ruta
                        $FLAG = 1
                        break
                    }
                }
            }
            if ($FLAG -eq 0) {
                write-host [(Get-Date -format g)] "Fix no encontrado" -foreground "DarkRed"
                $line = $server + "," + $DNS[$contador] + ",," + $vuln + ",No,Ninguno,0,0"
                $line >> $ruta
            } else {
                $FLAG = 0
            }
        } else {
            write-host [(Get-Date -format g)] "Sesion rechazada" -foreground "DarkRed"
            $linea = $server + "," + $DNS[$contador] + ",," + $vuln + ",Desconocido,No se pudo establecer la sesion,0,1"
            $linea >> $ruta
        }
    } else {
        write-host [(Get-Date -format g)] "Conexion rechazada" -foreground "DarkRed"
            $linea = $server + "," + $DNS[$contador] + ",," + $vuln + ",Desconocido,No se pudo establecer la conexion"
            $linea >> $ruta
    }
    #write-host [(Get-Date -format g)] $server": IP Analizado" -foreground "DarkYellow"
}



