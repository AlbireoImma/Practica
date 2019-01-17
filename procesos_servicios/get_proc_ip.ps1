# DNS,IP,Nombre de imagen,PID,Nombre de sesion,Num. de sesion,Uso de memoria,Nombre de usuario,Tiempo de CPU,ERROR
[string[]]$servers= Get-Content '.\listado_ip2.txt' # Lista de servidores
[string[]]$DNS= Get-Content '.\listado_dns2.txt' # Lista de dns
$contador = 0
$ruta = ".\procesos_servicios\log\logins_$(Get-Date -Uformat "%d%m%Y%H%M").csv"
"DNS,IP,Nombre de imagen,PID,Nombre de sesion,Num. de sesion,Uso de memoria,Nombre de usuario,Tiempo de CPU,ERROR" >> $ruta
$fecha = Get-Date -Uformat "%d%m%Y%H%M"

foreach ($server in $servers) {
    $dominio = $DNS[$contador]
    write-host [(Get-Date -Format g)]"Analizando server: $server [$dominio]" -foreground "DarkGreen"
    try {
        $procesos = tasklist /S $server /V /U instctx /P qwaszx.123 /FO csv
        if ($?) {
            $Flag = 0
            foreach ($linea in $procesos) {
                if ($flag -eq 0) {
                    $flag = 1
                } else {
                    $linea = $linea -replace '"',""
                    $linea = $DNS[$contador] + "," + $server + "," + $linea + ",0"
                    $linea >> $ruta
                }
            }
        } else {
            $linea = $DNS[$contador] + "," + $server + ",,,,,,,,1"
            $linea >> $ruta
        }
    } catch {
        $linea = $DNS[$contador] + "," + $server + ",,,,,,,,1"
        $linea >> $ruta
    }
    $contador = $contador + 1
    write-host [(Get-Date -Format g)]"Servidor Analizado: $server [$dominio]" -foreground "Green"
}