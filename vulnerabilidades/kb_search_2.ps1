cls

$vuln = "MS17-010"
$MS = ".\MS17-010.txt"

$Username = 'instctx'
$Password = 'qwaszx.123'
$pass = ConvertTo-SecureString -AsPlainText $Password -Force
$Cred = New-Object System.Management.Automation.PSCredential -ArgumentList $Username,$pass

[string[]]$servers= Get-Content '..\listado_ip2.txt' # Lista de servidores
[string[]]$DNS= Get-Content '..\listado_dns2.txt' # Lista de dns
[string[]]$KBS= Get-Content $MS # Lista de dns
$contador = 0
$ruta = ".\log\$($vuln)_$(Get-Date -Uformat "%d%m%Y%H%M").csv"
"IP,HOSTNAME,KB_ID,MS,INSTALADO" >> $ruta

$code = {
    write-host [(Get-Date -format g)] $server": Conexion establecida" -foreground "DarkGray"
    try {
        $a = Get-Hotfix -ErrorAction Stop | where-object {$KBS -contains $_.HotfixID} | Select-Object -property "HotFixID"
        write-host [(Get-Date -format g)] $a" :Resultado" -foreground "DarkGray"
        if ($a) {
            write-host [(Get-Date -format g)] $server": Fix Encontrado" -foreground "DarkGray"
            $linea = $server + "," + $DNS[$contador] + "," + $a.HotfixID + "," + $vuln + ",Si"
            return $linea
        } else {
            write-host [(Get-Date -format g)] $server": Fix No Encontrado" -foreground "DarkGray"
            $linea = $server + "," + $DNS[$contador] + ",," + $vuln + ",No"
            return $linea
        }
    }
    catch {
        write-host [(Get-Date -format g)] $server": No se pudieron obtener los KB" -foreground "DarkRed"
        $linea = $server + "," + $DNS[$contador] + ",," + $vuln + ",No se pudieron obtener los KB"
        write-host [(Get-Date -format g)] $server": IP Analizada" -foreground "DarkGreen"
        return $linea
    }
}


foreach($server in $servers){
    write-host [(Get-Date -format g)] $server": Analizando IP" -foreground "DarkYellow"
    $test = Test-Connection $server -Count 1 -Quiet
    if ($test) {
        try {
            $result = Invoke-Command -ScriptBlock $Code -Credential $Cred -ComputerName $server
            $result >> $ruta
        }
        catch {
            write-host [(Get-Date -format g)] $server": Error Invoke-Command" -foreground "DarkRed"
        }
    } else {
        write-host [(Get-Date -format g)] $server": Conexion rechazada" -foreground "DarkRed"
        $linea = $server + "," + $DNS[$contador] + ",," + $vuln + ",No se pudo establecer conexion"
        $linea >> $ruta
    }
    write-host [(Get-Date -format g)] $server": IP Analizada" -foreground "DarkGreen"
    $contador += 1
}




