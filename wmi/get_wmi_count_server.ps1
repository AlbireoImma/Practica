$entrada = @(([string]$args).split())


function all_wmi {
    write-host [(Get-Date -Format g)]"Inicio Script" -foreground "DarkGreen"
    [string[]]$servers= Get-Content '.\txts\IP_SERVER.txt' # Lista de servidores
    [string[]]$DNS= Get-Content '.\txts\DNS_SERVER.txt' # Lista de dns
    $header = '"DNS","IP","NameSpace","Wmi Class","Error"'
    $contador = 0
    #$namespaces = @(Get-WmiObject -Namespace Root -Class __Namespace -erroraction silentlycontinue | Select-Object -Property Name).count
    #write-host "> Cantidad de Namespaces: $namespaces"
    #$nombres = @(Get-WmiObject -Namespace Root -Class __Namespace | Select-Object -Property Name)
    #$total = 0
    $date = Get-Date -Uformat "%d%m%Y%H%M"
    $ruta = ".\log\WMI\wmi_$date.csv"
    $header >> $ruta
    foreach($server in $servers){
        write-host ">>> Servidor: $server" -foreground "Green"
        $prefijo = '"' + $DNS[$contador] + '","' + $server + '",'
        $nombres = @(Get-WmiObject -Namespace Root -Class __Namespace -computername $server -erroraction silentlycontinue | Select-Object -Property Name)
        if ($?) {
            foreach ($nombre in $nombres) {
                $nombre = ($nombre).Name
                write-host ">> NameSpace: $nombre" -foreground "DarkGray"
                $nombre = "root/$nombre"
                $wmis = Get-WMIObject -List -Namespace $nombre -computername $server -erroraction silentlycontinue
                if($?){
                    foreach($wmi in $wmis){
                        $linea = $prefijo + '"' + $nombre + '","' + $wmi.name + '","Sin Errores"'
                        $linea >> $ruta
                    }
                } else {
                    $linea = $prefijo +'"'+$nombre+'",,"Error Namespace"' # Error de Namespace
                    $linea >> $ruta
                }
                #write-host ">>> Cantidad de objetos wmi: $wmi" -foreground "DarkGreen"
                #$total += $wmi
            }
        } else {
            $linea = $prefijo + ',,"Error Acceso"' # Error de acceso
            $linea >> $ruta
        }
        $contador += 1
    }
    #write-host "> Total de clases wmi: $total"
    write-host [(Get-Date -Format g)]"Fin Script" -foreground "DarkGreen"
}

all_wmi

function wmi_exist($name,$ip) {
    write-host $name $ip -foregroundcolor "Black" -backgroundcolor "Yellow"
    $namespaces = @(Get-WmiObject -Namespace Root -Class __Namespace -ComputerName $ip | Select-Object -Property Name)
    foreach ($namespace in $namespaces) {
        $nombre = $namespace.Name
        $nombre = "root/$nombre"
        if(Get-WmiObject -namespace $nombre -computername $ip -List | where { $_.Name -eq $name}) {
            write-host $nombre" -> class exist" -foregroundcolor "Black" -backgroundcolor "Green"
        } else {
            write-host $nombre" -> class do not exist" -foregroundcolor "Black" -backgroundcolor "Red"
        }
    }
}

# Ejemplo entrada -> PS> .\get_wmi_count.ps1 $clase $ip
# wmi_exist $entrada[0] $entrada[1]