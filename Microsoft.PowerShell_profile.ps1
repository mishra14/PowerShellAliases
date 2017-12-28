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

Function Set-CI-EnvironmentVariable
{
    $env:CI = $True
}

Function Reset-CI-EnvironmentVariable
{
    $env:CI = $False
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

    & dotnet test --no-build --filter DisplayName~$filter
}

Function Git-MergeWithTheirs
{    
  <#
  .SYNOPSIS
  Merges the a branch into another branch.
  .DESCRIPTION
  Merges the a branch into another branch with resolving all conflicts in the other branch's favor.
  .EXAMPLE
  Git-MergeWithTheirs dev dev-anmishr-test
  .PARAMETER primaryBranch
  The primary branch which should be merged into.
  .PARAMETER secondaryBranch
  The secondary branch which should be merged into the primary branch.
  #>
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory=$True)]
    [Alias('p')]
    [string]$primaryBranch,
    [Parameter(Mandatory=$True)]
    [Alias('s')]
    [string]$secondaryBranch
  )

    Write-Host "git checkout $secondaryBranch"
    git checkout $secondaryBranch
    Write-Host "git checkout $primaryBranch"
    git checkout $primaryBranch
    Write-Host "git merge -X theirs"
    git merge -X theirs $secondaryBranch
}

Set-Alias -Name path -value Show-Path -description "Pretty print system path"

Set-Alias -Name c -value Configure -description "Run .\configure.ps1"
Set-Alias -Name b -value Build-VS15 -description "Run .\build.ps1 -SkipVS14 -SkipUnitTest"
Set-Alias -Name bfast -value Build-VS15-Fast -description "Run .\build.ps1 -SkipVS14 -SkipUnitTest -Fast"
Set-Alias -Name bfull -value Build -description "Run .\build.ps1"
Set-Alias -Name t -value Test -description "Run .\runTest.ps1"
Set-Alias -Name cb -value Configure-Build -description "Run .\configure.ps1; .\build.ps1 -SkipVS14 -SkipUnitTest"
Set-Alias -Name cbf -value Configure-Build-Fast -description "Run .\configure.ps1; .\build.ps1 -SkipVS14 -SkipUnitTest -Fast"

Set-Alias -Name gitc -value Git-Clean -description "Git clean -xdf" 
Set-Alias -Name gitaa -value Git-Add-All -description "Git add -A"
Set-Alias -Name gits -value Git-Status -description "Git status"
Set-Alias -Name gitd -value Git-Diff -description "Git diff"
Set-Alias -Name gitdd -value Git-Diff-Dev -description "Git diff dev"
Set-Alias -Name gitr -value Git-Reset -description "Git reset"
Set-Alias -Name gitrh -value Git-Reset-Hard -description "Git reset --hard"

Set-Alias -Name mskill -value Kill-MSBuild -description "Kill MSBuild processes"
Set-Alias -Name gpgkill -value Kill-GPG -description "Kill GPG processes"

Set-Alias -Name patchcli -value Patch-CLI -description "Move Commandline xplat dlls into cli"

Set-Alias -Name setci -Value Set-CI-EnvironmentVariable -Description 'Set $env:CI to True'
Set-Alias -Name resetci -Value Reset-CI-EnvironmentVariable -Description 'Set $env:CI to False'
