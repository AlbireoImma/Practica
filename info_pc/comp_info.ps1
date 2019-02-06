### comp_info.ps1 - Francisco Abarca - 06-02-2019
## Script que obtiene información de los PC en el listado proveido por el archivo
## IP.txt en la carpeta txts, puede ser modificado para obtener solo servers con IP_SERVER.txt

[string[]]$servers= Get-Content '..\txts\IP.txt' # Archivo con las ip a analizar con nombre IP.txt
$date = (Get-Date -Uformat "%d%m%Y%H%M") # Generamos variable con la fecha para la ruta del archivo final
foreach ($server in $servers) { # Recorremos cada servidor del listado en el archivo IP.txt
    write-host "Servidor: $server" -foreground "DarkGray" # imprimimos la IP analizada en el momento por consola
    try { # intentamos ejecutar el siguiente bloque
        $objeto = Get-WmiObject -Class Win32_OperatingSystem -Namespace root/cimv2 -ComputerName $server -erroraction Stop # Obtenemos el objeto wmi con la información
        $objeto >> "..\log\INFO_PC\INFO_" + $date + ".txt" # Escribimos el objeto a la ruta en la carpeta log
        write-host "Informacion Obtenida" -foreground "DarkGreen" # Imprimimos por pantalla el exito en la obtención/escritura de los datos
    }
    catch { # En caso de fallar al ejecutar el bloque anterior
        write-host "Error de Conexion" -foreground "DarkRed" # Imprimimos por pantalla que hubo un error en la obtención/escritura de los datos
        Continue # Continuamos con el script
    }
}