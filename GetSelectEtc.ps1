#Storyline: Using the Get-Process and Get-servicer
#Get-Process | Select-Object ProcessName, Path, ID | ` 
#Export-Csv -Path "C:\Users\champuser\Desktop\myProcesses.csv" -NoTypeInformation
#Get-Process | Get-Member
#Get-Service | Where { $_.Status -eq "Stopped" }
#ps | where { $_.ProcessName -eq "Slack" } | select ProcessName, ID, Path
