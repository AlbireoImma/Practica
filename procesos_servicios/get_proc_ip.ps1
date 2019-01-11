param (
    [string]$ip = ""
)

function get_proc ($ip) {
    write-host "------------------------ $($ip) --------------------------"
    $date = Get-Date -Format d
    write-host $date " Fecha"
    $gps = Get-Process -ComputerName $ip
    $gps >> $ip"_Procesos_"$date".txt"
    $gps | group name -NoElement | sort count -des >> $ip"_Recuento_"$date".txt"
    write-host "Dumping done"
    write-host "-------------------- Máquina local -----------------------"
    Get-Process | Sort-Object -Descending CPU
}

get_proc($ip)