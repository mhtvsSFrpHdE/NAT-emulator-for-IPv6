param(
    [switch]$Sure = $False,
    [String[]] $Ignores = @()
)
$ErrorActionPreference = "Stop"

$inboundRules = Get-NetFirewallRule | Where-Object { ($_.Direction -eq "Inbound") -and ($_.Enabled -eq $True) }
foreach ($item in $inboundRules) {
    $userSkipCondition = $False
    foreach ($ignore in $Ignores){
        if ($item.DisplayName.Contains($ignore)){
            $userSkipCondition = $True
        }
    }

    $hasGroupProperty = $item | Get-Member DisplayGroup
    $skipCoreNetworking = $False
    $skipRemoteDesktop = $False
    if ($hasGroupProperty) {
        # Core Networking
        $skipCoreNetworking = $item.Group -eq "@FirewallAPI.dll,-25000"
        # Remote Desktop
        $skipRemoteDesktop = $item.Group -eq "@FirewallAPI.dll,-28752"
    }

    $skip = $skipCoreNetworking -or $skipRemoteDesktop -or $userSkipCondition
    if ($skip -eq $False) {
        if ($Sure) {
            Write-Output "Disabling: $($item.DisplayName)"
            $item | Disable-NetFirewallRule
        }
        else {
            Write-Output "WhatIf: Disabling: $($item.DisplayName)"
        }
    }
}
