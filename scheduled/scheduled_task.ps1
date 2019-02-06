### scheduled_task.ps1 - Francisco Abarca - 06-02-2019
## Script que dado un listado de IP (IP.txt) y DNS (DNS.txt) obtiene las tareas programadas de estos
## generando un archivo CSV para parseo y representacion de los datos

# Encabezado del CSV con los atributos que contiene el CSV generado
$header = "DNS,Nombre de host,Nombre de tarea,Hora proxima ejecucion,Estado,Modo de inicio de sesion,Ultimo tiempo de ejecucion,Ultimo resultado,Autor,Tarea que se ejecutara,Iniciar en,Comentario,Estado de tarea programada,Tiempo de inactividad,Administracion de energia,Ejecutar como usuario,Eliminar tarea si no se vuelve a programar,Eliminar tarea si ejecuta durante X horas y X minutos,Programación,Tipo de programacion,Hora de inicio,Fecha de inicio,Fecha final,Dias,Meses,Repetir: cada,Repetir: hasta: hora,Repetir: hasta: duracion,Repetir: detener si aun se ejecuta,Error"
[string[]]$servers= Get-Content '.\txts\IP.txt' # Lista de servidores
[string[]]$DNS= Get-Content '.\txts\DNS.txt' # Lista de dns
$contador = 0 # Contador para llevar la cuenta en el recorrido de la variable $DNS
$ruta = ".\log\TAREAS_PROGRAMADAS\tareas_$(Get-Date -Uformat "%d%m%Y%H%M").csv" # Ruta para el archivo generado
$header >> $ruta # Escribimos el encabezado en la ruta definida
write-host "Archivo siendo generado en '" + $ruta + "'" # imprimimos por pantalla la ruta del archivo generado
write-host [(Get-Date -Format g)]"Inicio Script: $server [$dominio]" -foreground "DarkGreen" # Imprimimos por pantalla el evento del inicio del script
foreach ($server in $servers) { # Recorremos todas las IP del listado $servers
    $dominio = $DNS[$contador] # Obtenemos el DNS de la IP actual
    # Obtenemos las tareas de la IP en cuestion con las credenciales /U usuario /P password y lo exportamos en formato csv con /FO
    $query = schtasks /Query /S $server /U instctx /P "qwaszx.123" /V /FO CSV
    if($?){ # Si no hubo un error por parte de la query
        foreach($linea in $query){ # Recorremos las lineas de la query
            If ($linea -match "ERROR:") { # Vemos si la linea contiene un error
                $linea = $linea -split ": " # Parseamos la linea y la reescribimos
                $linea = $dominio + "," + $server + "," + $linea[2] + ",,,,,,,,,,,,,,,,,,,,,,,,,,,1" # Generamos una linea con codigo de error 1
                $linea >> $ruta # Escribimos la linea en la ruta definida
            } ElseIf (!($linea -match "Nombre")) { # Si la linea no es encabezado
                $linea = $dominio + "," + $linea + ",0" # Añadimos la IP y DNS a la linea, además del codigo de error 0
                $linea >> $ruta # Escribimos la linea al archivo generado en la variable $ruta
            }
        }
    } else  { # Si hubo un error por parte de la query
        $linea = $DNS[$contador] + "," + $server + ",,,,,,,,,,,,,,,,,,,,,,,,,,,,2" # Generamos una linea con codigo de error 2
        $linea >> $ruta # Escribimos la linea al archivo generado en la variable $ruta
    }
    $contador += 1 # Aumentamos el contador para pasar al siguiente DNS
    write-host [(Get-Date -Format g)]"Servidor Analizado: $server [$dominio]" -foreground "Green" # Imprimimos por pantalla el final del analisis de la IP actual
}
write-host [(Get-Date -Format g)]"Fin Script: $server [$dominio]" -foreground "DarkGreen" # Imprimimos por pantalla el final del Script