# 获取管理员权限
if (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    try {
        $scriptPath = (Get-Item -Path $PSCommandPath).FullName
        Start-Process powershell.exe -Verb runAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""
    }
    catch {
        Write-Host "Error! Admin Access Needed!" -ForegroundColor Red
        Pause
    }
    exit
}

# 获取当前目录绝对路径
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# 导入模块
Import-Module "$scriptDir\MsiInstall.psm1"
Import-Module "$scriptDir\FirewallCtrl.psm1"
Import-Module "$scriptDir\RegisterEdgeUI.psm1"
Import-Module "$scriptDir\CloseWindowsUpdate.psm1"
Import-Module "$scriptDir\ModifyPowerPlan.psm1"
Import-Module "$scriptDir\ConfigIP.psm1"
Import-Module "$scriptDir\InstallShutdownTcp.psm1"

Write-Host "====================================================================" -ForegroundColor Yellow
Write-Host "WhaleRider SetUp v1.0`n" -ForegroundColor Yellow
Write-Host "====================================================================" -ForegroundColor Yellow

$InputIp = Read-Host "Please Input IP (Directly Press Enter If Not Config)"
if (-not [string]::IsNullOrWhiteSpace($InputIp)) {
    # 配置静态IP
    Set-IP -IP $InputIp
}

# 安装nodejs msi
Install-Msi -MsiPath "$scriptDir\files\node.msi"

# 安装nssm并配置tcp关机脚本
Install-ShutdownTcp -FilePath "$scriptDir\files"

# 关闭防火墙
Update-Firewall -Enabled $false

# 修改电源按钮行为
Update-PowerPlan

# 修改注册EdgeUI注册表，关闭滑动
Register-EdgeUI

# 修改注册表关闭Windows自动更新
Close-AutoUpdate

# 前台安装VNC-Server
. "$scriptDir\files\VNC-Server-6.7.4-Windows.exe"
Write-Output "Install VNC, Active Code is: VKUPN-MTHHC-UDHGS-UWD76-6N36A"

Write-Output "===================================================================="
Write-Host "Set Up Successfully!`n" -ForegroundColor Green


Pause