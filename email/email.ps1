### email.ps1 - Francisco Abarca - 06-02-2019
## Script que dada las variables necesarias es capaz de enviar un correo
## al mail objetivo, la idea es usarlo para notificar eventos en los scripts powershell

$nombrepc = Hostname # Se podrían obtener o sacar más datos que tansolo el nombre
$email = "" # Correo destino es un correo autoenviado de la persona a si misma
$pass = "" # Contraseña del correo para las credenciales
$smtpServer = "smtp.gmail.com" # Direccion del servidor smtp
$msg = new-object Net.Mail.MailMessage # Creacion del objeto mensaje/correo
$smtp = new-object Net.Mail.SmtpClient($smtpServer) # Creación del objeto con la conexión smtp
$smtp.EnableSsl = $true # Opcional dependiendo de la configuración del servidor smtp
$msg.From = "$email" # Especificamos la dirección de la cual se va a enviar el correo
$msg.To.Add("$email") # Especificamos la dirección a la cual irá el correo, en este caso la misma
$msg.BodyEncoding = [system.Text.Encoding]::Unicode 
$msg.SubjectEncoding = [system.Text.Encoding]::Unicode  # Definimos la codificación del asunto como el cuerpo del correo como unicode
$msg.IsBodyHTML = $true # Definimos el cuerpo del correo como html, esto solo si se desea puede ser un string
$msg.Subject = "Alerta uso CPU" # Agregamos el asunto al correo
# Agregamos el cuerpo al correo
$msg.Body = "<h2> Uso alto de la CPU </h2> 
</br> 
En el PC con nombre: $($nombrepc)
"
$SMTP.Credentials = New-Object System.Net.NetworkCredential("$email", "$pass"); # Creamos el objeto con las credenciales de conexión
$smtp.Send($msg) # Enviamos el mensaje