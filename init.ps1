#script to move profile into the right place

$docsPath = [Environment]::GetFolderPath("MyDocuments")
$destFolder = Join-Path $docsPath "WindowsPowerShell"
$destPath = Join-Path $destFolder "Microsoft.PowerShell_profile.ps1"
$sourcePath = Join-Path ".\" "Microsoft.PowerShell_profile.ps1"

if (Test-Path $destFolder) {
	if (Test-Path $destPath) {
		Write-Host "$destPath already exists. Exiting!"
		Exit
	}
}
else {
	New-Item -ItemType directory -Path $destFolder
}
# Move the file to the correct location
Copy-Item $sourcePath $destPath
Write-Host "PowerShell profile copied to $destPath"