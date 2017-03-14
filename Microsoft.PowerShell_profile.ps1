Set-Location "E:\NuGet.Client"

Function Show-Path 
{
	echo ($env:Path).Replace(';',"`n")
}

Function Configure
{
	.\configure.ps1
}

Function Build
{
	.\build.ps1
}

Function Test
{
	.\runTests.ps1
}

Function Build-Fast
{
	.\build.ps1 -f
}

Function Build-Core
{
	.\build.ps1 -SkipVS14 -SkipVS15
}

Function Configure-Build-Core
{
	Configure
	Build-Core
}

Function Configure-Build
{
	Configure
	Build
}

Function Configure-Build-Test
{
	Configure
	Build
	Test
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


Set-Alias -name path -value Show-Path -description "Pretty print system path"

Set-Alias -name c -value Configure -description "Run .\configure.ps1"
Set-Alias -name b -value Build -description "Run .\build.ps1"
Set-Alias -name t -value Test -description "Run .\runTest.ps1"
Set-Alias -name bfast -value Build-Fast -description "Run .\build.ps1 -f"
Set-Alias -name bcore -value Build-Core -description "Run .\build.ps1 -SkipVS14 -SkipVS15"
Set-Alias -name cbcore -value Configure-Build-Core -description "Run  .\configure.ps1; .\build.ps1 -SkipVS14 -SkipVS15"
Set-Alias -name cb -value Configure-Build -description "Run .\configure.ps1 and .\build.ps1"
Set-Alias -name cbt -value Configure-Build-Test -description "Run .\configure.ps1, .\build.ps1 .\runTest.ps1"

Set-Alias -name gitc -value Git-Clean -description "Git clean -xdf" 
Set-Alias -name gitaa -value Git-Add-All -description "Git add -A"
Set-Alias -name gits -value Git-Status -description "Git status"
Set-Alias -name gitd -value Git-Diff -description "Git diff"
Set-Alias -name gitdd -value Git-Diff-Dev -description "Git diff dev"
Set-Alias -name gitr -value Git-Reset -description "Git reset"
Set-Alias -name gitrh -value Git-Reset-Hard -description "Git reset --hard"

Set-Alias -name mskill -value Kill-MSBuild -description "Kill MSBuild processes"