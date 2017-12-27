if ($env:computername -eq "MISHRA14-LAPTOP")
{
	Write-Host "Setting profile for mishra14-laptop"
	
    $nugetClientRoot = "C:\Users\anmishr\Documents\GitHub\NuGet.Client"
	$cliRoot = "C:\Users\anmishr\Documents\GitHub\cli"
	Set-Alias msbuild "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\bin\msbuild.exe"
	Set-Alias dotnetlocal "C:\Users\anmishr\Documents\GitHub\cli\bin\2\win10-x64\dotnet\dotnet.exe"
	Set-Alias xunitconsole "C:\Users\anmishr\Documents\GitHub\NuGet.Client\packages\xunit.runner.console.2.2.0\tools\xunit.console.x86.exe"
}
else
{
	Write-Host "Setting profile for mishra14-desktop"
	
    $nugetClientRoot = "E:\NuGet.Client"
	$cliRoot = "E:\cli"
	Set-Alias msbuild "C:\Program Files (x86)\Microsoft Visual Studio\2017Stable\Enterprise\MSBuild\15.0\bin\msbuild.exe"
	Set-Alias dotnetlocal "E:\cli\bin\2\win10-x64\dotnet\dotnet.exe"
	Set-Alias xunitconsole "E:\NuGet.Client\packages\xunit.runner.console.2.2.0\tools\xunit.console.x86.exe"
}

# Default location to NuGet root
Set-Location $nugetClientRoot

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) 
{
  Import-Module "$ChocolateyProfile"
}
# posh-git
Import-Module 'C:\tools\poshgit\dahlbyk-posh-git-a4faccd\src\posh-git.psd1'

Function Show-Path 
{
	echo ($env:Path).Replace(';',"`n")
}

Function Configure
{
	.\configure.ps1
}

Function Build-Full
{
	.\build.ps1
}

Function Test
{
	.\runTests.ps1
}

Function Build-VS15
{
	.\build.ps1 -SkipUnitTest 
}

Function Build-VS15-Fast
{
	.\build.ps1 -SkipUnitTest -Fast
}

Function Configure-Build
{
	Configure
	Build-VS15
}

Function Configure-Build-Fast
{
	Configure
	Build-VS15-Fast
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

Function Kill-MSBuild
{
    taskkill /F /IM msbuild.exe 
}

Function Kill-GPG
{
    taskkill /F /IM gpg*
}

Function Patch-CLI
{
    $cliArtifactsPath = [System.IO.Path]::Combine($cliRoot, 'artifacts', 'win10-x64', 'stage2', 'sdk')
    $nugetXplatArtifactsPath = [System.IO.Path]::Combine($nugetClientRoot, 'artifacts', 'NuGet.CommandLine.XPlat', '15.0', 'bin', 'Debug', 'netcoreapp1.0')

    if(-Not (Test-Path $nugetXplatArtifactsPath)) {
        Write-Error "$($nugetXplatArtifactsPath) not found!"
        return;
    }

    if(-Not (Test-Path $cliArtifactsPath)) {
        Write-Error "$($cliArtifactsPath) not found!"
        return;
    }
    
    $cli_path = (Get-ChildItem $cliArtifactsPath)[0].FullName
    
    Write-Host
    Write-Host "Source commandline path - $($nugetXplatArtifactsPath)"
    Write-Host "Destination cli path - $($cli_path)"
    Write-Host
    

    
    Get-ChildItem $nugetXplatArtifactsPath -Filter *.dll | 
    Foreach-Object {	
        $new_position = "$($cli_path)\$($_.BaseName )$($_.Extension )"
        Write-Host "Moving to - $($new_position)"
        Copy-Item $_.FullName $new_position
    }
}

Function Run-TestsWithFilter
{    
  <#
  .SYNOPSIS
  Restores, Builds and runs tests.
  .DESCRIPTION
  Restores, Builds and runs tests using dotnet and filtering of scope.
  .EXAMPLE
  Run-TestsWithFilter TestMethodName -restore -build
  .EXAMPLE
  Run-TestsWithFilter TestMethodName -b
  .PARAMETER filter
  The filter to be passed to dotnet test --filter option.
  .PARAMETER restore
  Restores the project before running tests.
  .PARAMETER build
  Builds the project before running tests.
  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory=$True)]
    [Alias('f')]
    [string]$filter,
    [Alias('r')]
    [switch]$restore,
    [Alias('b')]
    [switch]$build
  )

    if ($restore)
    {
        & msbuild /v:m /m /t:restore
    }

    if ($build)
    {
        & msbuild /v:m /m 
    }

    & dotnetlocal test --no-build --filter DisplayName~$filter
}

Function Run-NuGetTargetsCustom($projectPath, $target, $extra)
{   
    if ([string]::IsNullOrEmpty($target))
    {
        Write-Host "Defaulting to restore target..."
        $target = "restore"
    } 

    $nugetBuildTaskDllPath = Join-Path $nugetClientRoot "artifacts\NuGet.Build.Tasks\15.0\bin\Debug\net46\NuGet.Build.Tasks.dll"
    $nugetTargetsPath = Join-Path $nugetClientRoot "src\NuGet.Core\NuGet.Build.Tasks\NuGet.targets"
    Write-Host "msbuild $projectPath /t:$target /p:NuGetRestoreTargets=$nugetTargetsPath /p:RestoreTaskAssemblyFile=$nugetBuildTaskDllPath $extra"    
    & msbuild $projectPath /t:$target /p:NuGetRestoreTargets=$nugetTargetsPath /p:RestoreTaskAssemblyFile=$nugetBuildTaskDllPath $extra
}

Set-Alias -name path -value Show-Path -description "Pretty print system path"

Set-Alias -name c -value Configure -description "Run .\configure.ps1"
Set-Alias -name b -value Build-VS15 -description "Run .\build.ps1 -SkipVS14 -SkipUnitTest"
Set-Alias -name bfast -value Build-VS15-Fast -description "Run .\build.ps1 -SkipVS14 -SkipUnitTest -Fast"
Set-Alias -name bfull -value Build -description "Run .\build.ps1"
Set-Alias -name t -value Test -description "Run .\runTest.ps1"
Set-Alias -name cb -value Configure-Build -description "Run .\configure.ps1; .\build.ps1 -SkipVS14 -SkipUnitTest"
Set-Alias -name cbf -value Configure-Build-Fast -description "Run .\configure.ps1; .\build.ps1 -SkipVS14 -SkipUnitTest -Fast"

Set-Alias -name gitc -value Git-Clean -description "Git clean -xdf" 
Set-Alias -name gitaa -value Git-Add-All -description "Git add -A"
Set-Alias -name gits -value Git-Status -description "Git status"
Set-Alias -name gitd -value Git-Diff -description "Git diff"
Set-Alias -name gitdd -value Git-Diff-Dev -description "Git diff dev"
Set-Alias -name gitr -value Git-Reset -description "Git reset"
Set-Alias -name gitrh -value Git-Reset-Hard -description "Git reset --hard"

Set-Alias -name mskill -value Kill-MSBuild -description "Kill MSBuild processes"

Set-Alias -name gpgkill -value Kill-GPG -description "Kill GPG processes"

Set-Alias -name patchcli -value Patch-CLI -description "Move Commandline xplat dlls into cli"
