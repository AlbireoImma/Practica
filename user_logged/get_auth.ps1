### get_auth.ps1 - Francisco Abarca - 06-02-2019
## Script que dado un listado de IP (IP_SERVER.txt) obtiene las sesiones (inicios/request) en esa IP
## generando un archivo log con el listado detallado de los logins obtenidos


function get-loggedonuser ($computername){ # Funcion usada para obtener los logins que recibe como parametro la IP
    $regexa = '.+Domain="(.+)",Name="(.+)"$' # Expresión regular para el nombre mas el dominio
    $regexd = '.+LogonId="(\d+)"$' # Expresión regular para el id del login
    $logontype = @{ # Listado con los tipos de logins para pasar de ID -> Verbose
        "0"="Local System"
        "2"="Interactive" #(login local)
        "3"="Network" # (login remoto)
        "4"="Batch" # (Tarea programada)
        "5"="Service" # (login de servicio de cuentas)
        "7"="Unlock" #(Via pantalla de inicio)
        "8"="NetworkCleartext" # (Login via cleartext)
        "9"="NewCredentials" #(Credenciales alternativas)
        "10"="RemoteInteractive" #(Interactivo remoto)
        "11"="CachedInteractive" #(Interactivo en cache)
    }
    $logon_sessions = @(gwmi win32_logonsession -ComputerName $computername -erroraction silentlycontinue) # Obtener las sesiones logueadas
    $logon_users = @(gwmi win32_loggedonuser -ComputerName $computername -erroraction silentlycontinue) # Obtener los usuarios logueados
    $session_user = @{}
    $logon_users |% {
        $_.antecedent -match $regexa > $nul # Usar las expresiones regulares para parsear
        $username = $matches[1] + "\" + $matches[2] # Usar las expresiones regulares para parsear
        $_.dependent -match $regexd > $nul # Usar las expresiones regulares para parsear
        $session = $matches[1] # Guardar la id de la sesión
        $session_user[$session] += $username # Guardar el usuario Dominio\usuario
    }
    $logon_sessions |%{
        $starttime = [management.managementdatetimeconverter]::todatetime($_.starttime)
        $loggedonuser = New-Object -TypeName psobject # creación objeto usuario
        $loggedonuser | Add-Member -MemberType NoteProperty -Name "Session" -Value $_.logonid # Añadir el id de la sesion al objeto
        $loggedonuser | Add-Member -MemberType NoteProperty -Name "User" -Value $session_user[$_.logonid] # Añadir el usuario al objeto Dominio\usuario
        $loggedonuser | Add-Member -MemberType NoteProperty -Name "Type" -Value $logontype[$_.logontype.tostring()] # Añadir el tipo de acceso al objeto
        $loggedonuser | Add-Member -MemberType NoteProperty -Name "Auth" -Value $_.authenticationpackage # Añadir el tipo de autentificación al objeto 
        $loggedonuser | Add-Member -MemberType NoteProperty -Name "StartTime" -Value $starttime # Añadir la fecha inicio de sesión
        $loggedonuser
    }
}

$date = Get-Date -Format d # generamos una variable con la fecha a modo de diferenciar el log
[string[]]$servers= Get-Content '.\txts\IP.txt' # Lista de servidores
Get-Date -Format f >> ".\log\LOGINS\auth_$date.log" # Insertamos la fecha de inicio en el log
foreach($ip in $servers){ # Recorremos las IP en la lista $servers
	"@@@@@@@@@@@@@@@@" >> ".\log\LOGINS\auth_$date.log" # Insertamos delimitador para la IP en el log
	$ip >> ".\log\LOGINS\auth_$date.log" # Insertamos la IP en el log
	"@@@@@@@@@@@@@@@@" >> ".\log\LOGINS\auth_$date.log" # Insertamos delimitador para la IP en el log
	get-loggedonuser($ip) | Format-List >> ".\log\LOGINS\auth_$date.log" # Insertamos la informacion obtenida de la IP por la funcion
}
