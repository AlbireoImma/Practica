### get_proc_ip.ps1 - Francisco Abarca - 06-02-2019
## Script el cual retrae los procesos ejecutandose en los equipos designados por el archivo IP.txt
## la información es obtenida en un csv generado en la direccion de la variable $ruta

# Encabezado CSV generado
# DNS,IP,Nombre de imagen,PID,Nombre de sesion,Num. de sesion,Uso de memoria,Nombre de usuario,Tiempo de CPU,ERROR
[string[]]$servers= Get-Content '.\txts\IP.txt' # Lista de servidores
[string[]]$DNS= Get-Content '.\txts\DNS.txt' # Lista de dns
$contador = 0 # Contador para llevar la cuenta en el recorrido de la variable $DNS
$ruta = ".\log\PROCESOS\procesos_$(Get-Date -Uformat "%d%m%Y%H%M").csv" # Ruta para el archivo generado
"DNS,IP,Nombre de imagen,PID,Nombre de sesion,Num. de sesion,Uso de memoria,Nombre de usuario,Tiempo de CPU,ERROR" >> $ruta # Escribimos el encabezado del CSV
$fecha = Get-Date -Uformat "%d%m%Y%H%M" # Recorremos todas las IP del listado $servers

foreach ($server in $servers) { # Recorremos todas las IP del listado $servers
    $dominio = $DNS[$contador] # Obtenemos el DNS de la IP actual
    write-host [(Get-Date -Format g)]"Analizando server: $server [$dominio]" -foreground "DarkGreen" # Imprimimos por pantalla el server analizado en el momento
    try { # Intentamos la ejecución del bloque de código siguiente
        # Obtenemos los procesos de la IP en cuestion con las credenciales /U usuario /P password y lo exportamos en formato csv con /FO
        $procesos = tasklist /S $server /V /U instctx /P qwaszx.123 /FO csv
        if ($?) { # Si no hubo un error por parte de la query
            $Flag = 0 # Seteamos una bandera para saltarnos el encabezado
            foreach ($linea in $procesos) { # Recorremos las lineas de la query
                if ($flag -eq 0) { # La primera la saltamos
                    $flag = 1 # Levantamos la bandera para dar paso a la informacion
                } else {
                    $linea = $linea -replace '"',"" # Quitamos las " de la linea revisada
                    $linea = $DNS[$contador] + "," + $server + "," + $linea + ",0" # Añadimos el DNS la IP y el codigo de error 0 a la linea
                    $linea >> $ruta # Escribimos la linea al archivo generado en la variable $ruta
                }
            }
        } else { # Si hubo un error por parte de la query
            $linea = $DNS[$contador] + "," + $server + ",,,,,,,,1" # Generamos una linea con codigo de error 1
            $linea >> $ruta # Escribimos la linea al archivo generado en la variable $ruta
        }
    } catch {
        $linea = $DNS[$contador] + "," + $server + ",,,,,,,,1" # Generamos una linea con codigo de error 1
        $linea >> $ruta # Escribimos la linea al archivo generado en la variable $ruta
    }
    $contador = $contador + 1 # Aumentamos el contador para pasar al siguiente DNS
    write-host [(Get-Date -Format g)]"Servidor Analizado: $server [$dominio]" -foreground "Green" # Imprimimos por pantalla el final del analisis de la IP actual
}