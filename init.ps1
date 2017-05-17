#script to move profile into the right place

[CmdletBinding()]
param (
	[Alias('f')]
    [switch]$force = $false
)

$docsPath = [Environment]::GetFolderPath("MyDocuments")
$destFolder = Join-Path $docsPath "WindowsPowerShell"
$destPath = Join-Path $destFolder "Microsoft.PowerShell_profile.ps1"
$sourcePath = Join-Path ".\" "Microsoft.PowerShell_profile.ps1"

if (Test-Path $destFolder) {
	if (Test-Path $destPath) {
		if($force -eq $false){
			Write-Host "$destPath already exists. Please pass -f|-force switch to over write existing aliases. Exiting!"
			Exit
		}
	}
}
else {
	New-Item -ItemType directory -Path $destFolder
}
# Move the file to the correct location
Copy-Item $sourcePath $destPath
Write-Host "PowerShell profile copied to $destPath"