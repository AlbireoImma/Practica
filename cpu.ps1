$repeat_count = 10
$cpu_threshold = 85
$sleep_interval = 1
$hit = 0
$nombrepc = Hostname
$email = "faam1612@gmail.com"
$pass = "warofworld1612"
$smtpServer = "smtp.gmail.com"
$msg = new-object Net.Mail.MailMessage
$smtp = new-object Net.Mail.SmtpClient($smtpServer) 
$smtp.EnableSsl = $true
$msg.From = "$email"  
$msg.To.Add("$email")
$msg.BodyEncoding = [system.Text.Encoding]::Unicode 
$msg.SubjectEncoding = [system.Text.Encoding]::Unicode 
$msg.IsBodyHTML = $true  
$msg.Subject = "Alerta uso CPU"
$msg.Body = "<h2> Uso alto de la CPU </h2> 
</br> 
En el PC con nombre: $($nombrepc)
"


foreach($turn in 1..$repeat_count) {
$cpu = (gwmi -class Win32_Processor).LoadPercentage
echo "CPU utilization is Currently at $($cpu)%"
If($cpu -ge $cpu_threshold) {
$hit = $hit+1
}
start-sleep $sleep_interval
}

if($hit -eq 10) {
write-host “CPU utilization is over threshold”
$SMTP.Credentials = New-Object System.Net.NetworkCredential("$email", "$pass");
$smtp.Send($msg)
} else {
write-host “CPU utilization is below threshold level”
}