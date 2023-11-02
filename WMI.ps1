# Use the Get-WMIobject cmdlet
#Get-WmiObject -Class Win32_service | select Name, PathName, ProcessId

#get-wmiobject -list | where { $_.Name -ilike "Win32_[n-z]*" } | Sort-Object

#Get-WmiObject -Class Win32_Account | Get-Member

#Task: Grab the network adapter information using the WMI class 
# Get the IP address, default gateway, and the DNS servers. 
# BONUS: Get the DHCP server

# Get network adapter information https://learn.microsoft.com/en-us/powershell/module/netadapter/get-netadapter?view=windowsserver2022-ps
$adapters = Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }

# Loop through each network adapter
foreach ($adapter in $adapters) {
    Write-Host "Network Adapter: $($adapter.Description)"
    Write-Host "IP Address: $($adapter.IPAddress)"
    Write-Host "Default Gateway: $($adapter.DefaultIPGateway)"
    Write-Host "DNS Servers: $($adapter.DNSServerSearchOrder)"
    
    # Get the DHCP server if available
    $dhcpServer = $adapter.DHCPServer
    if ($dhcpServer) {
        Write-Host "DHCP Server: $dhcpServer"
    } else {
        Write-Host "DHCP Server: Not available"
    }
    
    Write-Host "--------------------------------"
}
