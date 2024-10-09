function Update-Firewall {
    param (
        [bool]$Enabled
    )
    if (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
        Write-Host "Error! Admin Access Needed!" -ForegroundColor Red
        Pause
        exit
    }

    $gpoBooleanValue = if ($Enabled) {
        'True'
    } else {
        'False'
    }

    Write-Output "===================================================================="
    Write-Output "Firewall Enabled $gpoBooleanValue"

    Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled $gpoBooleanValue
}

Export-ModuleMember -Function Update-Firewall
