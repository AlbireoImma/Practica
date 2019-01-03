$Threshold = -100;
$Counter = "\Process(*)\% Processor Time";
$Data = Get-Counter $Counter;
$Cores = (Get-WmiObject -class win32_processor -Property numberOfCores).numberOfCores;
$CPUUsage = [math]::Round(($Data.CounterSamples | Where-Object {$_.InstanceName -eq "idle"} | Select-Object @{Name="Total";Expression={100 - $_.CookedValue / $Cores}}).Total,2);
If($CPUUsage -gt $Threshold) {
    $Processes = $Data.CounterSamples | Where-Object {$_.InstanceName -ne "idle" -and $_.InstanceName -ne "_Total"} | Sort-Object -Descending -Property CookedValue | Select-Object -First 10 -Property InstanceName, @{Name="Usage";Expression={[math]::Round(($_.CookedValue / $Cores),2)}};
    $Message = "Processes with high CPU: ";
    ForEach ($Process in $Processes) {
        $ProcName = $Process.InstanceName;
        $Usage = $Process.Usage;
        if ($Usage -gt 0) {
            $Message = $Message + "$ProcName($Usage%) ";
        }
    }
    # Append performance data
    $Message = $Message + "| "
    ForEach ($Process in $Processes) {
        $ProcName = $Process.InstanceName;
        $Usage = $Process.Usage;
        if ($Usage -gt 0) {
            $Message = $Message + "$ProcName=$Usage% ";
        }
    }
    Write-Host "$Message";
}