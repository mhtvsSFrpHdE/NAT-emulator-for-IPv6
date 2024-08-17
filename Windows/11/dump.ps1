param(
    [String[]] $Hosts = @(),
    [String[]] $ProcessNames = @()
)
$ErrorActionPreference = "Stop"

$filterByProcessName = $ProcessNames.Count -gt 0

Write-Output "TCP"
$tcpConnections = Get-NetTCPConnection | Where-Object {($_.LocalAddress -in $Hosts) -or ($_.LocalAddress -eq "127.0.0.1") -or ($_.LocalAddress -eq "0.0.0.0")}
foreach ($item in $tcpconnections){
    $owningProcess = (Get-Process -Id ($item).OwningProcess).ProcessName
    if ($filterByProcessName){
        if ($owningProcess -in $ProcessNames){
            Write-Output "$($item.LocalAddress):$($item.LocalPort) $($owningProcess)"
        }
    }
    if ($filterByProcessName -eq $False){
        Write-Output "$($item.LocalAddress):$($item.LocalPort) $($owningProcess)"
    }
}

Write-Output ""
Write-Output "UDP"
$udpConnections = Get-NetUDPEndpoint | Where-Object {($_.LocalAddress -in $Hosts) -or ($_.LocalAddress -eq "127.0.0.1") -or ($_.LocalAddress -eq "0.0.0.0")}
foreach ($item in $udpConnections){
    $owningProcess = (Get-Process -Id ($item).OwningProcess).ProcessName
    if ($filterByProcessName){
        if ($owningProcess -in $ProcessNames){
            Write-Output "$($item.LocalAddress):$($item.LocalPort) $($owningProcess)"
        }
    }
    if ($filterByProcessName -eq $False){
        Write-Output "$($item.LocalAddress):$($item.LocalPort) $($owningProcess)"
    }
}
