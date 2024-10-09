function Install-Msi {
    param (
        [string]$MsiPath
    )
    
    if (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
        Write-Host "Error! Admin Access Needed!" -ForegroundColor Red
        Pause
        exit
    }

    Write-Output "===================================================================="
    Write-Output "Install Msi: $MsiPath"

    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$MsiPath`" /quiet /norestart" -Wait
}

Export-ModuleMember -Function Install-Msi
