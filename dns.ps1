# listar dominios de las ip
[string[]]$servers= Get-Content '.\listado_ip2.txt'
foreach($ip in $servers){
    try {
        [System.Net.Dns]::GetHostByAddress($ip).Hostname >> ".\listado_dns2.txt"
    } catch {
        "Excepcion al intentar retraer NDS" >> ".\listado_dns2.txt"
    }
}