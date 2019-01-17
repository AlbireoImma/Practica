param(
    # Parametros posibles que se pueden entregar
    [CmdletBinding()] 
    [Parameter(ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true)]
    [string[]]$ComputerName = 'localhost'
)
begin {
    # Usado para poder retener los errores con el catch
    $ErrorActionPreference = 'Stop'
}
process {
    write-host [(Get-Date -Format g)]" Inicio de Trabajo" -Foreground "Green"
    $date = (Get-Date).ToString("%d%m%yyyy_%HH:%mm") # Fecha para el formato del archivo se puede usar g o f como argumento para distintos formatos
    $ruta = ".\user_logged\log\users_verbose_$(Get-Date -Uformat "%d%m%Y%H%M").csv"
    [string[]]$servers= Get-Content '.\listado_ip2.txt' # Lista de servidores
    [string[]]$DNS= Get-Content '.\listado_dns2.txt' # Lista de dns
    $contador = 0 # Para movernos por los nombres de dominio mientras recorremos los servidores
    $ComputerName = $servers # Asimilamos los servidores en el archivo "listado_ip2.txt"
    # Encabezado del CSV el cual da el orden y tipo de separacion al archivo
    "USERNAME;COMPUTER_NAME;SERVER;SESSION;ID;STATE;IDLE_TIME;LOGON_TIME;ERROR" >> $ruta
    foreach ($Computer in $ComputerName) {
        try {
            # Query del servidor dentro del for, nos saltamos la primera linea que es de formato de la query
            quser /server:$Computer 2>&1 | Select-Object -Skip 1 | ForEach-Object {
                $CurrentLine = $_.Trim() -Replace '\s+',' ' -Split '\s' # Remplazamos los espacios innecesarios, y hacemos un split por espacio
                # Objeto el cual dara el formato e información necesaria para el CSV
                $HashProps = @{
                    UserName = $CurrentLine[0] # Nombre del usuario
                    ComputerName = $Computer # Nombre del equipo o VM
                    Server = $DNS[$contador] # Nombre del servidor dado por la lista retenida al inicio
                }
                # Si la sesión esta desconectada se usan parámetros distintos
                if ($CurrentLine[2] -eq 'Disc') {
                        $HashProps.SessionName = $null # Usamos null al estar desconectada
                        $HashProps.Ident = $CurrentLine[1] # Insertamos el identificador -> nombre de sesion
                        $HashProps.State = $CurrentLine[2] # El estado de la sesion
                        $HashProps.IdleTime = $CurrentLine[3] # Tiempo de inactividad
                        $HashProps.LogonTime = $CurrentLine[4..6] -join ' ' # Tiempo de Login o instancia para ser mas preciso
                        $HashProps.LogonTime = $CurrentLine[4..($CurrentLine.GetUpperBound(0))] -join ' '
                } else { # Sesión activa
                        $HashProps.SessionName = $CurrentLine[1]
                        $HashProps.Ident = $CurrentLine[2]
                        $HashProps.State = $CurrentLine[3]
                        $HashProps.IdleTime = $CurrentLine[4]
                        $HashProps.LogonTime = $CurrentLine[5..($CurrentLine.GetUpperBound(0))] -join ' '
                }
                # Creamos el objeto con la información parseada de la query
                $objeto = New-Object -TypeName PSCustomObject -Property $HashProps |
                Select-Object -Property UserName,ComputerName,Server,SessionName,Ident,State,IdleTime,LogonTime,Error
                # Separamos por ; para nuestro CSV
                $linea = $objeto.UserName + ";" + $objeto.ComputerName + ";" + $objeto.Server + ";" 
                $linea = $linea + $objeto.SessionName + ";" + $objeto.Ident + ";" + $objeto.State + ";" + $objeto.IdleTime + ";" + $objeto.LogonTime + ";" + $objeto.Error
                # write-host $linea -Foreground "Red" # Debug
                $linea >> $ruta # Escribimos en el CSV
            }
        } catch {
            # No pudimos obtener la query -> Problemas de RPC o administrativos
            # Almacenamos el IP, NDS y el Error
            $objeto = New-Object -TypeName PSCustomObject -Property @{
                ComputerName = $Computer
                Server = $DNS[$contador]
                Error = $_.Exception.Message
            } | Select-Object -Property UserName,ComputerName,Server,SessionName,Id,State,IdleTime,LogonTime,Error
            $linea = $objeto.UserName + ";" + $objeto.ComputerName + ";" + $objeto.Server + ";" 
            $linea = $linea + $objeto.SessionName + ";" + $objeto.Ident + ";" + $objeto.State + ";" + $objeto.IdleTime + ";" + $objeto.LogonTime + ";" + $objeto.Error
			$linea >> $ruta # Escribimos en el CSV
        }
        $contador += 1
    }
    # Avisamos el final del Script
    write-host [(Get-Date -Format g)]" Final del Trabajo" -Foreground "Green"
}