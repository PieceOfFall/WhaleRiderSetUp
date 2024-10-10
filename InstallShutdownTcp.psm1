function Install-ShutdownTcp {
    param (
        [string]$FilePath
    )

    if (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
        Write-Host "Error! Admin Access Needed!" -ForegroundColor Red
        Pause
        exit
    }

    Write-Output "===================================================================="
    Write-Output "Install Shutdown Tcp Script"

    # 复制关机脚本到目标位置
    Copy-Item -Path "$FilePath\node" -Destination "D:\" -Recurse

    # 复制nssm到C盘根目录
    Copy-Item -Path "$FilePath\nssm-2.24" -Destination "C:\" -Recurse

    # 使用nssm注册tcp脚本服务
    . "C:\nssm-2.24\win64\nssm.exe" install app "C:\Program Files\nodejs\node.exe" "D:\node\app.js"

    # nssm启动tcp脚本服务
    . "C:\nssm-2.24\win64\nssm.exe" start app

    NETSTAT.EXE -ano|findstr.exe "7788"
}

Export-ModuleMember -Function Install-ShutdownTcp
