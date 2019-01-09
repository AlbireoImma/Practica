$entrada = @(([string]$args).split())


function all_wmi {
    $namespaces = @(Get-WmiObject -Namespace Root -Class __Namespace | Select-Object -Property Name).count
    write-host "> Cantidad de Namespaces: $namespaces"
    $nombres = @(Get-WmiObject -Namespace Root -Class __Namespace | Select-Object -Property Name)
    $total = 0
    foreach ($nombre in $nombres) {
        $nombre = ($nombre).Name
        write-host ">> NameSpace: $nombre" -foreground "DarkGray"
        $nombre = "root/$nombre"
        Get-WMIObject -List -Namespace $nombre
        $wmi = @(Get-WMIObject -List -Namespace $nombre).count
        write-host ">>> Cantidad de objetos wmi: $wmi" -foreground "DarkGreen"
        $total += $wmi
    }
    write-host "> Total de clases wmi: $total"
}

# all_wmi

function wmi_exist($name,$ip) {
    write-host $name $ip -foregroundcolor "Black" -backgroundcolor "Yellow"
    $namespaces = @(Get-WmiObject -Namespace Root -Class __Namespace | Select-Object -Property Name)
    foreach ($namespace in $namespaces) {
        $nombre = $namespace.Name
        $nombre = "root/$nombre"
        if(Get-WmiObject -namespace $nombre -computername $ip -List | where { $_.Name -eq $name}) {
            write-host $nombre" -> class exist" -foregroundcolor "Black" -backgroundcolor "Green"
        } else {
            write-host $print" -> class do not exist" -foregroundcolor "Black" -backgroundcolor "Red"
        }
    }
}

# Ejemplo entrada -> PS> .\get_wmi_count.ps1 $clase $ip
wmi_exist $entrada[0] $entrada[1]