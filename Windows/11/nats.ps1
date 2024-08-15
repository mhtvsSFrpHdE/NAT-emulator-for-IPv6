$ErrorActionPreference = "Stop"

$inboundRules = Get-NetFirewallRule | Where-Object { ($_.Direction -eq "Inbound") -and ($_.Enabled -eq $True) }
foreach ($item in $inboundRules) {
    # Add your own skip condition here
    $userSkipCondition = $False

    $hasGroupProperty = $item | Get-Member DisplayGroup
    $skipCoreNetworking = $False
    $skipRemoteDesktop = $False
    if ($hasGroupProperty) {
        $skipCoreNetworking = $item.DisplayGroup -eq "Core Networking"
        $skipRemoteDesktop = $item.DisplayGroup -eq "Remote Desktop"
    }

    $skip = $skipCoreNetworking -or $skipRemoteDesktop -or $userSkipCondition
    if ($skip -eq $False) {
        Write-Output "Disabling: $($item.DisplayName)"
        $item | Disable-NetFirewallRule
    }
}
