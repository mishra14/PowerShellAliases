 $env:Path = ($env:Path).Replace("C:\Program Files (x86)\MSBuild\12.0\bin","C:\Program Files (x86)\MSBuild\14.0\bin")
 Set-Location "E:\nuget\NuGet.Client"
 
 Function Show-Path 
 {
	echo ($env:Path).Replace(';',"`n")
 }
 
 Function Build-Configure
 {
	.\configure.ps1
 }
 
 Function Build-Only-Build
 {
	.\build.ps1
 }
 
 Function Build-Test
 {
	.\runTests.ps1
 }
 
 Function Build-Fast
 {
	.\build.ps1 -f
 }
 
 Function Build-Configure-Build
 {
	bc
	bb
 }
 
 Function Build-Configure-Test
 {
	bc
	bt
 }
 
 Function Git-Clean
 {
	git clean -xdf
 }
 
 Function Git-Status
 {
	git status
 } 
 
 Function Git-Diff
 {
	git diff
 } 
 
 Function Git-Diff-Dev
 {
	git diff dev
 } 
 
 Function Git-Reset
 {
	git reset
 } 
 
 Function Git-Reset-Hard
 {
	git reset --hard
 }
 
 Function Git-Add-All
 {
	git add -A
 }
 
 Function Patch-NuGet
 {
	\\scratch2\scratch\anmishr\vs2017\patchNuget.ps1 ./
 }
 
 
 Set-Alias -name path -value Show-Path -description "Pretty print system path"

 Set-Alias -name bc -value Build-Configure -description "Run configure.ps1"
 Set-Alias -name bb -value Build-Only-Build -description "Run build.ps1"
 Set-Alias -name bt -value Build-Test -description "Run runTest.ps1"
 Set-Alias -name bf -value Build-Fast -description "Run .\build.ps1 -f"
 Set-Alias -name bcb -value Build-Configure-Build -description "Run .\configure.ps1 and .\build.ps1"
 Set-Alias -name bct -value Build-Configure-Test -description "Run .\configure.ps1 and .\runTest.ps1"
  
 Set-Alias -name gitc -value Git-Clean -description "Git clean -xdf" 
 Set-Alias -name gitaa -value Git-Add-All -description "Git add -A"
 Set-Alias -name gits -value Git-Status -description "Git status"
 Set-Alias -name gitd -value Git-Diff -description "Git diff"
 Set-Alias -name gitdd -value Git-Diff-Dev -description "Git diff dev"
 Set-Alias -name gitr -value Git-Reset -description "Git reset"
 Set-Alias -name gitrh -value Git-Reset-Hard -description "Git reset --hard"
 
 Set-Alias -name patch -value Patch-NuGet -description "Patch local Nuget repo to build with VS15"