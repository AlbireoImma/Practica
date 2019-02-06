### generate_MAESTRO_KB.ps1 - Francisco Abarca - 06-02-2019
## Script que genera un script SQL para SQL Server, el cual recibe como parametros
## una vulnerabilidad y la fecha en un formato establecido, el .sql generado completa la tabla MAESTRO_KB

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