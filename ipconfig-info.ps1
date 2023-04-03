# I am storing the filtered output in a variable  named adatpterobj.
$adapterobjs = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled}

# i have used Write-Output for formatting the report.
Write-Output "      "
Write-Output "============================================================================================"
Write-Output "IP Configuration Report"
Write-Output "============================================================================================"
Write-Output "      "

# this foreach loop i have created to extract the details for each of the adapter which is then stored in variable named report.
$report = foreach ($adapterobj in $adapterobjs) {
    [PSCustomObject]@{
        "Adapter Description" = $adapterobj.Description
        "Index" = $adapterobj.Index
        "IP Address(es)" = $adapterobj.IPAddress
        "Subnet Mask(s)" = $adapterobj.IPSubnet
        "DNS Domain Name" = $adapterobj.DNSDomain
        "DNS Server(s)" = $adapterobj.DNSServerSearchOrder
#     "MAC Address " = $adapterobj.MACAddress
    }
}

#to formate table i have pass it directly to variable where the data output is stored.
$report | Format-Table -AutoSize
