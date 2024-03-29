$env:path += ";$home/documents/github/comp2101/powershell"

function welcome{
write-output "Welcome to planet $env:computername Overlord $env:username"
$now = get-date -format 'HH:MM tt on dddd'
write-output "It is $now."
}

function get-cpuinfo{
$cpuInfo = Get-CimInstance CIM_Processor | Select-Object Manufacturer, Name, MaxClockSpeed, CurrentClockSpeed, NumberOfCores
$cpuInfo | format-table 
}

function get-mydisks {
$diskinfo =Get-CimInstance CIM_DiskDrive | ForEach-Object {
        [PSCustomObject]@{
            Manufacturer= $_.Manufacturer
            Model= $_.Model
            SerialNumber= $_.SerialNumber
            FirmwareRevision = $_.FirmwareRevision
            Size= $_.Size
        }
    }     
$diskinfo | format-table -autosize
}