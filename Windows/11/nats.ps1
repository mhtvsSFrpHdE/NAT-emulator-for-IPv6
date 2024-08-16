param(
    [switch]$Sure = $False
)
$ErrorActionPreference = "Stop"

$inboundRules = Get-NetFirewallRule | Where-Object { ($_.Direction -eq "Inbound") -and ($_.Enabled -eq $True) }
foreach ($item in $inboundRules) {
    # Add your own skip condition here
    $userSkipCondition = $False

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
