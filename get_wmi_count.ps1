$namespaces = @(Get-WmiObject -Namespace Root -Class __Namespace | Select-Object -Property Name).count
write-host "> Cantidad de Namespaces: $namespaces"
$nombres = @(Get-WmiObject -Namespace Root -Class __Namespace | Select-Object -Property Name)
$total = 0
foreach ($nombre in $nombres) {
    $nombre = ($nombre).Name
    write-host ">> NameSpace: $nombre"
    $nombre = "root/$nombre"
    $wmi = @(Get-WMIObject -List -Namespace $nombre).count
    write-host ">>> Cantidad de objetos wmi: $wmi"
    $total += $wmi
}
write-host "> Total de clases wmi: $total"