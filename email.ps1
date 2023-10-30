# Storyline: Send an email
# Body of the email
$msg = "Hello there! - General Kenobi"

#Echoes to the screen
write-host -BackgroundColor Red -ForegroundColor white $msg

# EMail From Address 
$email = "luke.cutter@mymail.champlain.edu"

# EMail to address
$toEmail = "deployer@csi-web"

# Sending email
Send-MailMessage -From $email -to $toEmail -Subject "General Obi-Wan Kenobi" -body $msg -SmtpServer 192.168.6.71
