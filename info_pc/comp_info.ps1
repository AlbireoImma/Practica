[string[]]$servers= Get-Content '..\txts\IP.txt' # Archivo con las ip a analizar con nombre collection.txt
$date = (Get-Date -Uformat "%d%m%Y%H%M")
foreach ($server in $servers) {
    write-host "Servidor: $server" -foreground "DarkGray"
    try {
        $objeto = Get-WmiObject -Class Win32_OperatingSystem -Namespace root/cimv2 -ComputerName $server -erroraction Stop
        $objeto >> "..\log\INFO_PC\INFO_" + $date + ".txt"
        write-host "Informacion Obtenida" -foreground "DarkGreen"
    }
    catch {
        write-host "Error de Conexion" -foreground "DarkRed"
        Continue
    }
    
}