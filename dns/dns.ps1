### dns.ps1 - Francisco Abarca - 24-01-2019
## Script que dado un archivo con rango de IP y otro con un listado de IP
## genera queries y archivos .txt que obtienen los DNS de las IP solicitadas


# Archivo con los rangos de IP de los endpoints de la forma XXX.YYY.ZZZ.
[string[]]$endpoints= Get-Content '.\txts\rangos_dns.txt'
# Archivo con el listado de IP de los servidores
[string[]]$servers= Get-Content '.\txts\IP_SERVER.txt'

$a = 0 # Variable usada para recorrer el rango de IP
$count_error = 0 # Variable usada para el debug, contabiliza los fallos de conexion

# Cuerpo inicial de la query para insertar informacion en la tabla MAESTRO_DNS
$query = "BEGIN Try INSERT INTO sondeoBK.dbo.MAESTRO_DNS(IP,NAME,TIPO) VALUES ('"
# Cuerpo final de la query para endpoints
$sufix = "','Endpoint'); END Try BEGIN Catch END Catch"
# Cuerpo final de la query para servidores
$sufix2 = "','Servidor'); END Try BEGIN Catch END Catch"
# Ruta en donde se generara el archivo .sql
$ruta = ".\scripts\MAESTRO_DNS\Script_MAESTRO_DNS$(Get-Date -Uformat "%d%m%Y%H%M").sql"
# Ruta en donde se almacenaran todas las IP en forma de .txt
$rutaIP = ".\txts\IP$(Get-Date -Uformat "%d%m%Y%H%M").txt"
# Ruta en donde se almacenaran todos los DNS en forma de .txt
$rutaDNS = ".\txts\DNS$(Get-Date -Uformat "%d%m%Y%H%M").txt"
# Query que elimina los elementos de la tabla MAESTRO DNS para reinsercion
"BEGIN Try DELETE FROM sondeoBK.dbo.MAESTRO_DNS END Try BEGIN Catch END Catch;" >> $ruta

# Recorremos cada rango de IP desde el sufijo 0 hasta el 255
foreach($ip in $endpoints){
    while ($a -le 255) {
        try {
            $direccion = $ip + $a
            $nombre = [System.Net.Dns]::GetHostByAddress($direccion).Hostname # Solicitamos el DNS a la IP recorrida
            $query + $direccion + "','" + $nombre + $sufix >> $ruta # Armamos la Query y la escribimos en el archivo .sql
            $direccion >> $rutaIP # Escribimos el IP y DNS a los archivos correspondientes
            $nombre >> $rutaDNS
        } catch {
            $count_error += 1 # Si atrapamos un error lo sumamos a nuestra cuenta
        }
        $a += 1 # Sumamos una posicion al sufijo
    }
    $a = 0 # Reseteamos el sufijo al acabar el loop
}

# Recorremos cada IP de los servidores
foreach($ip in $servers){
    try {
        $nombre = [System.Net.Dns]::GetHostByAddress($ip).Hostname # Solicitamos el DNS a la IP recorrida
        $query + $ip + "','" + $nombre + $sufix2 >> $ruta # Armamos la Query y la escribimos en el archivo .sql
        $ip >> $rutaIP # Escribimos el IP y DNS a los archivos correspondientes
        $nombre >> $rutaDNS
    } catch {
        $count_error += 1 # Si atrapamos un error lo sumamos a nuestra cuenta
    }
}