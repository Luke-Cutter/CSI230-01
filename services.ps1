# Define valid options
$validOptions = @('all', 'stopped', 'running', 'quit')

# Function to list services based on user input
function List-Services {
    param (
        [string]$status
    )

    if ($status -eq 'all') {
        Get-Service | Format-Table -Property DisplayName, ServiceName, Status -AutoSize
    } elseif ($status -eq 'stopped') {
        Get-Service | Where-Object { $_.Status -eq 'Stopped' } | Format-Table -Property DisplayName, ServiceName, Status -AutoSize
    } elseif ($status -eq 'running') {
        Get-Service | Where-Object { $_.Status -eq 'Running' } | Format-Table -Property DisplayName, ServiceName, Status -AutoSize
    }
}

# Main loop
while ($true) {
    # Prompt user for input
    $userInput = Read-Host "Enter 'all', 'stopped', 'running', or 'quit' to exit"

    # Check if the input is valid
    if ($validOptions -notcontains $userInput) {
        Write-Host "Invalid input. Please enter 'all', 'stopped', 'running', or 'quit'."
        continue
    }

    # Check if the user wants to quit
    if ($userInput -eq 'quit') {
        break
    }

    # List services based on user input
    List-Services -status $userInput
}
