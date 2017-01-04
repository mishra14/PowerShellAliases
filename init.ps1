#script to move profile into the right place

[CmdletBinding()]
param (
	[Alias('o')]
    [switch]$overwrite = $false
)

$docsPath = [Environment]::GetFolderPath("MyDocuments")
$destFolder = Join-Path $docsPath "WindowsPowerShell"
$destPath = Join-Path $destFolder "Microsoft.PowerShell_profile.ps1"
$sourcePath = Join-Path ".\" "Microsoft.PowerShell_profile.ps1"

if (Test-Path $destFolder) {
	if (Test-Path $destPath) {
		if($overwrite -eq $false){
			Write-Host "$destPath already exists. Please pass -o switch to over write existing aliases. Exiting!"
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