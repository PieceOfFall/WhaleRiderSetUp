function Set-IP {
    param (
        [string]$IP
    )
    if (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
        Write-Host "Error! Admin Access Needed!" -ForegroundColor Red
        Pause
        exit
    }

    Write-Output "===================================================================="
    Write-Output "Config Static IP"

    # 获取网卡的索引
    $ifIndex = (Get-NetAdapter | Select-Object -First 1).InterfaceIndex
    # 根据ip获取网关ip
    $Gateway = $IP -replace '\d+$', '1'

    # 关闭DHCP
    Set-NetIPInterface -InterfaceIndex $ifIndex -Dhcp Disabled
    # 配置IP,子网掩码,网关
    New-NetIPAddress -InterfaceIndex $ifIndex -IPAddress $IP -PrefixLength 24 -DefaultGateway $Gateway

    # 配置DNS
    Set-DnsClientServerAddress -InterfaceIndex $ifIndex -ServerAddresses $Gateway
}

Export-ModuleMember -Function Set-IP
