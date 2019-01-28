$header = "DNS,Nombre de host,Nombre de tarea,Hora proxima ejecucion,Estado,Modo de inicio de sesion,Ultimo tiempo de ejecucion,Ultimo resultado,Autor,Tarea que se ejecutara,Iniciar en,Comentario,Estado de tarea programada,Tiempo de inactividad,Administracion de energia,Ejecutar como usuario,Eliminar tarea si no se vuelve a programar,Eliminar tarea si ejecuta durante X horas y X minutos,Programación,Tipo de programacion,Hora de inicio,Fecha de inicio,Fecha final,Dias,Meses,Repetir: cada,Repetir: hasta: hora,Repetir: hasta: duracion,Repetir: detener si aun se ejecuta,Error"
[string[]]$servers= Get-Content '.\txts\IP_SERVER.txt' # Lista de servidores
[string[]]$DNS= Get-Content '.\txts\DNS_SERVER.txt' # Lista de dns
$contador = 0
$ruta = ".\log\TAREAS_PROGRAMADAS\tareas_SERVER_$(Get-Date -Uformat "%d%m%Y%H%M").csv"
$header >> $ruta
write-host "Archivo siendo generado en '" + $ruta + "'"
write-host [(Get-Date -Format g)]"Inicio Script: $server [$dominio]" -foreground "DarkGreen"
foreach ($server in $servers) {
    $dominio = $DNS[$contador]
    $query = schtasks /Query /S $server /U instctx /P "qwaszx.123" /V /FO CSV
    if($?){
        foreach($linea in $query){
            If ($linea -match "ERROR:") {
                #$linea
                $linea = $linea -split ": "
                #$linea = $linea[1] -split ":"
                #write-host "ERROR: $linea"
                $linea = $dominio + "," + $server + "," + $linea[2] + ",,,,,,,,,,,,,,,,,,,,,,,,,,,1"
                $linea >> $ruta
            } ElseIf (!($linea -match "Nombre")) {
                $linea = $dominio + "," + $linea + ",0"
                $linea >> $ruta
            }
        }
    } else {
        $linea = $DNS[$contador] + "," + $server + ",,,,,,,,,,,,,,,,,,,,,,,,,,,,2"
        $linea >> $ruta
    }
    $contador += 1
    write-host [(Get-Date -Format g)]"Servidor Analizado: $server [$dominio]" -foreground "Green"
}
write-host [(Get-Date -Format g)]"Fin Script: $server [$dominio]" -foreground "DarkGreen"