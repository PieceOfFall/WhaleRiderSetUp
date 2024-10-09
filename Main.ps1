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

Write-Output "===================================================================="
Write-Output "WhaleRider SetUp v1.0`n"

# 安装nodejs
Install-Msi -MsiPath "$scriptDir\files\node.msi"

# 关闭防火墙
Update-Firewall -Enabled $false

# 修改注册EdgeUI注册表，关闭滑动
Register-EdgeUI

Pause