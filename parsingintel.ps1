# Array of Websites containing threat intel
$drop_urls = @('https://rules.emergingthreats.net/blockrules/emerging-botcc.rules','https://rules.emergingthreats.net/blockrules/compromised-ips.txt')

# Loop through the URLS for the rules list
foreach ($u in $drop_urls) {
    # Extract the filename
    $temp = $u.split("/")
    # The last element in the array plucked off is the filename
    $file_name = $temp[4]

    if (Test-Path $file_name){
        continue
    } else {
       
    # Download the rules list: 
    Invoke-WebRequest -Uri $u -OutFile $file_name

    } # closes if statement
} # closes the foreach loop

# Array containing the filename
$input_paths = @('compromised-ips.txt', '.\emerging-botcc.rules')

# Extract the IP addresses
# 108.190.109.107
# 108.191.2.72
$regex_drop = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'

# Append the IP addresses to the temporary IP list
select-string -Path $input_paths -Pattern $regex_drop | `
ForEach-Object { $_.Matches} | `
ForEach-Object { $_.Value} | Sort-Object | Get-Unique | `
Out-File -FilePath "ips-bad.tmp"
# Get the IP addresses discovered, loop through and replace the beginning of the line with the IPTables syntax
# After the IP address, add the remaining IPTables syntax and save the results to a file
# iptables -A INPUT -s 108.191.2.72 -j
(Get-Content -Path ".\ips-bad.tmp") | ForEach-Object { $_ -replace "^", "iptables -A INPUT -s " -replace "$", " -j DROP"} | Out-File -FilePath ".\iptables.bash"

# TASK PORTION
# Switch statement to create IPTables and Windows firewall ruleset
switch ($env:OS) {
    "Windows_NT" {
        # Windows Firewall rules
        (Get-Content -Path ".\ips-bad.tmp") | ForEach-Object { "New-NetFirewallRule -DisplayName 'Block $_' -Direction Inbound -RemoteAddress $_ -Action Block" } | Out-File -FilePath "C:\Users\champuser\Desktop\windows-firewall-rules.ps1"
           }
        "Linux" {
    # Linux IPTables rules
    (Get-Content -Path ".\ips-bad.tmp") | ForEach-Object { "iptables -A INPUT -s $_ -j DROP" } | Out-File -FilePath "C:\Users\champuser\Desktop\iptables-rules.sh"
}  
    Default {
        Write-Host "Unsupported operating system."
    }
}
