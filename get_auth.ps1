function get-loggedonuser ($computername){

    $regexa = '.+Domain="(.+)",Name="(.+)"$' # Expresión regular para el nombre mas el dominio
    $regexd = '.+LogonId="(\d+)"$' # Expresión regular para el id del login

    $logontype = @{
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
    $logon_sessions = @(gwmi win32_logonsession -ComputerName $computername) # Obtener las sesiones logueadas
    $logon_users = @(gwmi win32_loggedonuser -ComputerName $computername) # Obtener los usuarios logueados
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
$ip = "172.22.1.56"
$ip2 = "172.20.2.48"
$ip3 = "172.20.2.22"
$date = Get-Date -Format d
get-loggedonuser($ip) >> $ip"_auth_$date.txt"
get-loggedonuser($ip2) >> $ip2"_auth_$date.txt"
get-loggedonuser($ip3) >> $ip3"_auth_$date.txt"