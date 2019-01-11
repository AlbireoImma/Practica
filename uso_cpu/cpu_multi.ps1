Function Average($array)
{
    $largo = 0;
	$suma = 0;
    foreach($i in $array){
        $largo += 1;
		$suma += $i;
    }
    return ([decimal]($suma) / [decimal]($largo));
}

$repeat_count = 10 # Cantidad de iteraciones
$cpu_threshold = 85 # Umbral de peligro del uso de la CPU, se anota un hit si es mayor o igual que este valor
$sleep_interval = 1 # Cantidad de timepo que el proceso duerme entre muestras
$hit = 0 # Variable utilizada para contar la cantidad de veces que se supera el umbral en las muestras
$nombrepc = Hostname # Se podrían obtener o sacar más datos que tansolo el nombre
$email = "faam1612@gmail.com" # Correo destino es un correo autoenviado de la persona a si misma
$pass = "warofworld1612" # Contraseña del correo para las credenciales
$smtpServer = "smtp.gmail.com" # Direccion del servidor smtp
$msg = new-object Net.Mail.MailMessage # Creacion del objeto mensaje/correo
$smtp = new-object Net.Mail.SmtpClient($smtpServer) # Creación del objeto con la conexión smtp
$smtp.EnableSsl = $true # Opcional dependiendo de la configuración del servidor smtp
$msg.From = "$email" # Especificamos la dirección de la cual se va a enviar el correo
$msg.To.Add("$email") # Especificamos la dirección a la cual irá el correo, en este caso la misma
$msg.BodyEncoding = [system.Text.Encoding]::Unicode 
$msg.SubjectEncoding = [system.Text.Encoding]::Unicode  # Definimos la codificación del asunto como el cuerpo del correo como unicode
$msg.IsBodyHTML = $false # Definimos el cuerpo del correo como html, esto solo si se desea puede ser un string
$msg.Subject = "Alerta uso CPU" # Agregamos el asunto al correo
$jobs = Get-Process | Sort-Object -Property cpu -Descending | Format-List | Out-String # Obtenemos los procesos que corren actualmente
# Agregamos el cuerpo al correo
$msg.Body = "Uso alto de la CPU
En el PC con nombre: $($nombrepc)
Trabajos
" + $jobs
while($true)
{
    # Iteramos desde 1 hasta la variable $repeat_count declarada al inicio, esta nos dicta cuantas muestras tomaremos
    write-host [(Get-Date -Format g)]"Working..."
    foreach($turn in 1..$repeat_count) {
        $cpu =  Get-WmiObject win32_processor | select -exp LoadPercentage
		$avg = Average($cpu)
		write-host [(Get-Date -Format g)]"CPU utilization is Currently at $($avg)%"
        If($cpu -ge $cpu_threshold) { # Si la muestra supera nuestro umbral determinado por la variable $cpu_threshold
            $hit = $hit+1 # Si se cumple la condición aumentamos nuestras muestras relevantes en uno
        }
        start-sleep $sleep_interval # Dormimos el proceso durante el tiempo definido en la variable $sleep_interval definido al inicio
    }

    if($hit -eq 10) { # Si la cantidad de hits es igual a la cantidad de muestras, este valor puede ser cambiado pero no debe superar la cantidad de muestras
        write-host [(Get-Date -Format g)]"CPU utilization is over threshold"
        $SMTP.Credentials = New-Object System.Net.NetworkCredential("$email", "$pass"); # Creamos el objeto con las credenciales de conexión
        $smtp.Send($msg) # Enviamos el mensaje
    } else {
        write-host [(Get-Date -Format g)]"CPU utilization is below threshold level"
    }
    write-host [(Get-Date -Format g)]"Sleeping..."
    start-sleep 60 # Se duerme un minuto entre muestras
	$hit = 0
}