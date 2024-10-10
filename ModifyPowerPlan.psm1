function Update-PowerPlan {
    Write-Output "===================================================================="
    Write-Output "Modify Power Plan"

    # 获取当前电源计划的GUID
    $powerPlanGUID = (powercfg /getactivescheme | Select-String -Pattern 'GUID: (\S+)').Matches[0].Groups[1].Value

    # 设置电源按钮按下时的行为为“无操作” (AC 和 DC 都设置)
    powercfg /setacvalueindex $powerPlanGUID SUB_BUTTONS PBUTTONACTION 0
    powercfg /setDcValueIndex $powerPlanGUID SUB_BUTTONS PBUTTONACTION 0

    # 应用修改
    powercfg /S $powerPlanGUID
}

Export-ModuleMember -Function Update-PowerPlan
