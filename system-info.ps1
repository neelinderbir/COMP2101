# This Function  will retrive the system hardware.
function Detail-Sys-Hardware{
    $systemDetail = Get-WmiObject -Class Win32_ComputerSystem
    $output = @()
    $output += "Hardware Manufacturer: $($systemDetail.Manufacturer)"
    $output += "Hardware Model: $($systemDetail.Model)"
    $output += "Total Physical Memory: $([math]::Round($systemDetail.TotalPhysicalMemory / 1GB, 2)) GB"
    $output += "Hardware Description: $($systemDetail.Description)"
    $output += "System Type: $($systemDetail.SystemType)"
    return $output

}

# This Function  will retrive the operating system detail.
Function Detail-OperatingSystem {
    $osDetail = Get-WmiObject -Class Win32_OperatingSystem
    $output = @()
    $output += "System Name: $($osDetail.Caption)"
    $output += "Version Number: $($osDetail.Version)"
    return $output
}

# This Function  will retrive the Detail processor.
Function Detail-processor {
    $processor = Get-WmiObject -Class Win32_Processor
    $output = @()
    $output += "Name: $($processor.Name)"
    $output += "Number of Cores: $($processor.NumberOfCores)"
    $output += "Speed: $($processor.MaxClockSpeed) MHz"
    if ($processor.L1CacheSize -ne $null) {
        $output += "L1 Cache Size: $($processor.L1CacheSize / 1KB) KB"
    } else {
        $output += "L1 Cache Size: N/A"
    }
    if ($processor.L2CacheSize -ne $null) {
        $output += "L2 Cache Size: $($processor.L2CacheSize / 1KB) KB"
    } else {
        $output += "L2 Cache Size: N/A"
    }
    if ($processor.L3CacheSize -ne $null) {
        $output += "L3 Cache Size: $($processor.L3CacheSize / 1KB) KB"
    } else {
        $output += "L3 Cache Size: N/A"
    }
    return $output
}

# This Function  will retrive the Ram memory.
Function Detail-RAM-Memory {
   $memory = Get-WmiObject -Class Win32_PhysicalMemory
    $totalMemory = 0
    $output = @()
    
    foreach ($mem in $memory) {
        $output += [PSCustomObject]@{
            Vendor = $mem.Manufacturer
            Description = $mem.Description
            Capacity = "{0:N2} GB" -f ($mem.Capacity / 1GB)
            "Bank/Slot" = $mem.DeviceLocator
            "Memory Type" = $mem.MemoryType
            Speed = $mem.Speed
        }
          $totalMemory += $mem.Capacity
    }
    
    $output | Format-Table -AutoSize
    Write-Host "Total RAM installed: $(('{0:N2}' -f ($totalMemory / 1GB))) GB"

 }

# This Function  will retrive the Disk drive.
function Detail-DiskDrive{
 $diskdrives = Get-CIMInstance CIM_diskdrive

  foreach ($disk in $diskdrives) {
      $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition
      foreach ($partition in $partitions) {
            $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($logicaldisk in $logicaldisks) {
	$freeSpace = [math]::Round(($logicaldisk.FreeSpace / $logicaldisk.Size) * 100, 2)

#new-object -typename psobject -property 
		$drive = [PSCustomObject]@{

			Manufacturer=$disk.Manufacturer
                                                          Model=$disk.Model     
			 Size = "{0:N2} GB" -f ($logicaldisk.Size / 1GB)
               			  "Free Space" = "{0:N2} GB" -f ($logicaldisk.FreeSpace / 1GB)
			"Free space in %" = "$freeSpace%"
                                                     }
		 $drive 
           }
      }
  }

}
                                                         
# This Function  will retrive the video Controller.
Function Detail-VideoController {
    $video = Get-WmiObject -Class Win32_VideoController
    $output= foreach ($v in $video) {
        [PSCustomObject]@{
            Vendor = $v.VideoProcessor
            Description = $v.Description
            Resolution = "{0}x{1}" -f $v.CurrentHorizontalResolution, $v.CurrentVerticalResolution
        }
    }
    $output
}


# I have used Write-Output for formatting the report.
#fortting the output for system hardware detail
Write-Output "      "
Write-Output "      "
Write-Output "					System Information Report"
Write-Output "      "
Write-Output "============================================================================================"
Write-Output "Hardware Detail"
Write-Output "============================================================================================"

# to call the system hardware function.
Detail-Sys-Hardware
Write-Output "      "

#operating system detail
Write-Output "============================================================================================"
Write-Output "Operating System Detail"
Write-Output "============================================================================================"
# to call the system hardware function.
Detail-OperatingSystem
Write-Output "      "
Write-Output "      "

# To print output for processor
Write-Output "============================================================================================"
Write-Output "Processor Detail"
Write-Output "============================================================================================"
# to call the system hardware function.
Detail-processor

Write-Output "      "

#to print output for Memory
Write-Output "============================================================================================"
Write-Output "RAM Detail"
Write-Output "============================================================================================"
# to call the system hardware function.
Detail-RAM-Memory
Write-Output "      "

#to print output for Disk
Write-Output "============================================================================================"
Write-Output "Disk Detail"
Write-Output "============================================================================================"
Detail-DiskDrive | Format-Table -AutoSize
Write-Output "      "


# I am calling the Network adapter Configuration
ipconfig-info.ps1

# I am calling the video Controller
Write-Output "============================================================================================"
Write-Output "Video Controller Detail"
Write-Output "============================================================================================"
Detail-VideoController | Format-List
Write-Output "      "