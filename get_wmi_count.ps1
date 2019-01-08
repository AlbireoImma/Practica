$namespaces = @(Get-WmiObject -Namespace Root -Class __Namespace | Select-Object -Property Name).count
write-host "> Cantidad de Namespaces: $namespaces" -Foreground "Green"
$nombres = @(Get-WmiObject -Namespace Root -Class __Namespace | Select-Object -Property Name)
$total = 0
foreach ($nombre in $nombres) {
    $nombre = ($nombre).Name
    write-host ">> NameSpace: $nombre" -Foreground "DarkYellow"
    $nombre = "root/$nombre"
    $wmi = @(Get-WMIObject -List -Namespace $nombre).count
    write-host ">>> Cantidad de objetos wmi: $wmi" -Foreground "DarkGray"
    $total += $wmi
}
write-host "> Total de clases wmi: $total" -Foreground "DarkCyan"