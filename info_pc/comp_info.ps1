[string[]]$servers= Get-Content '.\collection.txt' # Archivo con las ip a analizar con nombre collection.txt

foreach ($server in $servers) {
	write-host "Servidor: $server"
    Get-WmiObject -Class Win32_OperatingSystem -Namespace root/cimv2 -ComputerName $server
}