param([string]$vuln = "",[string]$date = "")
# date de la forma YYYY-MM-DD
$MS = "..\txts\" + $vuln + ".txt"
[string[]]$KBS= Get-Content $MS # Lista de dns
$ruta = "..\scripts\MAESTRO_KB\$($vuln)_$(Get-Date -Uformat "%d%m%Y%H%M").sql"
$header = "BEGIN Try INSERT INTO sondeoBK.dbo.MAESTRO_KB(MS,KB) VALUES('"
$inter = "','"
$end = "'); END Try Begin Catch END Catch"
"BEGIN Try INSERT INTO sondeoBK.dbo.MAESTRO_MS(MS,FECHA) VALUES ('" + $vuln + $inter + $date + $end >> $ruta
foreach ($KB in $KBS) {
    $header + $vuln + $inter + $KB + $end >> $ruta
}