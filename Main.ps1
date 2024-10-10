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

Write-Host "====================================================================" -ForegroundColor Yellow
Write-Host "WhaleRider SetUp v1.0`n" -ForegroundColor Yellow
Write-Host "====================================================================" -ForegroundColor Yellow

# 安装nodejs msi
Install-Msi -MsiPath "$scriptDir\files\node.msi"

# 关闭防火墙
Update-Firewall -Enabled $false

# 修改电源按钮行为
Update-PowerPlan

# 配置静态IP
Set-IP -IP 192.168.2.111

# 修改注册EdgeUI注册表，关闭滑动
Register-EdgeUI

# 修改注册表关闭Windows自动更新
Close-AutoUpdate

Write-Output "===================================================================="
Write-Host "Set Up Successfully!`n" -ForegroundColor Green
Pause