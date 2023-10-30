# Storyline: Review the security event log

# Directory to save files: 
$myDir = "C:\Users\champuser\Desktop\"

# List all available Windows Event Logs
Get-EventLog -list

# Create a prompt to allow user to select the Log to view
$readLog = Read-host -Prompt "Please select a log to review from the list above"

# Print the results for the log
Get-EventLog -LogName $readLog -Newest 40 | where {$_.Message -ilike "*New process has been*"} |export-csv -NoTypeInformation `
-Path "$myDir\SecurityLogs.csv"

# Task: Create a prompt that allows the user to specify a keyword or phrase to search on
# Find a string from your event logs to search on

# Prompt the user to enter a keyword or phrase to search in event logs
$keyword = Read-Host -Prompt "Enter a keyword or phrase to search in event logs"

# Search the Windows event logs for the specified keyword or phrase
$eventLogs = Get-WinEvent -LogName * | Where-Object { $_.Message -like "*$keyword*" }

# Display the search results
if ($eventLogs.Count -eq 0) {
    Write-Host "No matching entries found in the event logs for '$keyword'."
} else {
    Write-Host "Matching entries found in the event logs for '$keyword':"
    $eventLogs | Format-Table -AutoSize
}
