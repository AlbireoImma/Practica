[string[]]$servers= Get-Content '.\collection.txt' # Archivo con las ip a analizar
$date = Get-Date -Format d # Fecha para asuntos de formato
write-host [(Get-Date -Format g)]" Iniciando Script"
$date + " Iniciando barrido de servidores" >> "users_$date.txt"
foreach ($server in $servers) {
    "Detalle: $server" >> "users_$date.txt"
    quser /server:$server >> "users_$date.txt"
}
$date + " Barrido de servidores terminado" >> "users_$date.txt"
write-host [(Get-Date -Format g)]" Script Finalizado"

