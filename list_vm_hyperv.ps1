Get-VM | ForEach-Object {
    $vm = $_
    $ipAddress = (Get-VMNetworkAdapter -VM $vm).IPAddresses
    Get-VMHardDiskDrive -VM $vm | ForEach-Object {
        $vhd = Get-VHD -Path $_.Path
        [PSCustomObject]@{
            VMName            = $vm.Name
            State             = $vm.State
            CPU               = $vm.ProcessorCount
            RAM               = [math]::round($vm.MemoryAssigned  / 1GB, 2)
            DiskPath          = $_.Path
            AllocatedSizeGB   = [math]::round($vhd.FileSize / 1GB, 2)
            UsedSizeGB        = [math]::round(($vhd.FileSize - $vhd.SavedSpace) / 1GB, 2)
            IPAddress         = $ipAddress -join ', '  # Junte múltiplos IPs, se houver
        }
    }
} | Select-Object VMName, State, CPU, AllocatedRAM_GB, DiskPath, AllocatedSizeGB, UsedSizeGB, IPAddress | Export-Csv -Path C:\VMs_Info.csv -NoTypeInformation -Delimiter ';'
