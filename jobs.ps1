Get-WmiObject Win32_PerfFormattedData_PerfProc_Process `
    | Where-Object { $_.name -inotmatch '_total|idle' } `
    | ForEach-Object { 
        "Process={0,-25} CPU_Usage={1,-12} Memory_Usage_(MB)={2,-16}" -f `
            $_.Name,$_.PercentProcessorTime,([math]::Round($_.WorkingSetPrivate/1Mb,2))
    }