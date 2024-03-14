#Function to get DHCP lease information from a specific scope
function Get-DHCPLease {
    param(
        [string]$ScopeID
    )
    
    $leases = Get-DhcpServerv4Lease -ScopeId $ScopeID
    
    foreach ($lease in $leases) {
        $hostname = $lease.HostName
        $ipAddress = $lease.IPAddress
        if ($hostname -like "*hostname*") {
            [PSCustomObject]@{
                Hostname = $hostname
                IPAddress = $ipAddress
            }
            Write-Host "Device found named $hostname"
        }
    }
}

#Main script
$scopes = Get-DhcpServerv4Scope

$results = @()

foreach ($scope in $scopes) {
    Write-Host "Checking DHCP Scope $($scope.ScopeId)"
    $results += Get-DHCPLease -ScopeID $scope.ScopeId
}

#Export filtered results to CSV file
$results | Export-Csv -Path "$env:USERPROFILE\Downloads\GetDHCPExportHostname.csv" -NoTypeInformation

Write-Host "The leases have been exported to $env:USERPROFILE\Downloads\GetDHCPExportHostname.csv"