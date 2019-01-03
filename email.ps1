$EmailTo = "faam1612@gmail.com"
$EmailFrom = "faam1612@gmail.com"
$Subject = "testing"
$Body = "Test Body"
$SMTPServer = "smtp.gmail.com"
$SMTPMessage = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo,$Subject,$Body)
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587) 
$SMTPClient.EnableSsl = $true 
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("faam1612@gmail.com", "warofworld1612");
$SMTPClient.Send($SMTPMessage)