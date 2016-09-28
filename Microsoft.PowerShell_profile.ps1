 $env:Path = ($env:Path).Replace("C:\Program Files (x86)\MSBuild\12.0\bin","C:\Program Files (x86)\MSBuild\14.0\bin")
 #Set-Location "E:\nuget\NuGet.Client"
 
 Function Show-Path 
 {
	echo ($env:Path).Replace(';',"`n")
 }
 
 Function Build
 {
	.\build.ps1
 }
 
 Function Build-Skip-Tests
 {
	.\build.ps1 -SkipTests
 }
 
 Function Build-Skip-Tests-Clean-Cache
 {
	.\build.ps1 -SkipTests -CleanCache
 }
 
 Function Build-Skip-Tests-Fast
 {
	.\build.ps1 -Fast
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
 
 
 Set-Alias -name path -value Show-Path -description "Pretty print system path"

 Set-Alias -name bb -value Build -description "Build Nuget Core project"
 Set-Alias -name bbs -value Build-Skip-Tests -description "Build Nuget Core project skip tests"
 Set-Alias -name bbsc -value Build-Skip-Tests-Clean-Cache -description "Build Nuget Core project skip tests and clean cache"
 Set-Alias -name bbf -value Build-Skip-Tests-Fast -description "Build Nuget Core project Fast"
  
 Set-Alias -name gitc -value Git-Clean -description "Git clean -xdf" 
 Set-Alias -name gits -value Git-Status -description "Git status"
 Set-Alias -name gitd -value Git-Diff -description "Git diff"
 Set-Alias -name gitdd -value Git-Diff-Dev -description "Git diff dev"
 Set-Alias -name gitr -value Git-Reset -description "Git reset"
 Set-Alias -name gitrh -value Git-Reset-Hard -description "Git reset --hard"