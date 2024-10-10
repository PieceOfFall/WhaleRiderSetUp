

function Close-AutoUpdate {
    if (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
        Write-Host "Error! Admin Access Needed!" -ForegroundColor Red
        Pause
        exit
    }

    Write-Output "===================================================================="
    Write-Output "Close Windows Auto Update"

    # 定义要操作的注册表路径
    $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"

    # 创建注册表项 (如果项已存在，不会报错)
    New-Item -Path $registryPath -Force
  
    # 向注册表项中添加DWORD32记录
    New-ItemProperty -Path $registryPath -Name "NoAutoUpdate" -Value 1 -PropertyType DWord -Force
}

Export-ModuleMember -Function Close-AutoUpdate
