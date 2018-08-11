# Input for Target & Credentials
$Target = Read-Host -Prompt 'Enter a Single Hostname or IP..'
$username = Read-Host -Prompt 'Enter Username'
$password = Read-Host -Prompt 'Enter Password' 
$password = ConvertTo-SecureString $password -AsPlainText -Force

$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $password

$ErrorActionPreference = "SilentlyContinue"

# Query Host for Installed AV Products and Get Service Binary Location
Write-Host "Getting a List of Installed AV Products.."

$AVServices = Invoke-Command -ComputerName $Target -ScriptBlock {Get-WMIObject AntiVirusProduct -namespace root\securitycenter2 | Select-Object pathToSignedReportingExe} -credential $cred

# Start Loop in Case of More than One AV Solution
foreach ($i in $AVServices){

$SvcPath = $i | foreach { $_.pathToSignedReportingExe }

$SvcDirectory = Split-Path -Path $SvcPath

# Create Backup Directory
Invoke-Command -ComputerName $Target -ScriptBlock {New-Item -ItemType directory -Path $args[0]} -credential $cred -ArgumentList $SvcDirectory"BACKUP"

# Move Service Files to "BACKUP" in Parent Directory
Write-Host "Moving AV Service Binaries from $SvcDirectory to $SvcDirectory"BACKUP""

Invoke-Command -ComputerName $Target -ScriptBlock {Move-Item -Path ($args[0] + "\*") -Destination ($args[0] + "BACKUP\") -Force} -credential $cred -ArgumentList $SvcDirectory

}
