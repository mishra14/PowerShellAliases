# PowerShellAliases
Some git (and other) power shell aliases that come in handy.

# Usage
```javascript
git clone https://github.com/mishra14/PowerShellAliases.git
.\init.ps1
```

# Git Examples

| Alias          | Equivalent Command    |
| -------------- |:---------------------:|
| gits           | git status            |
| gitc           | git commit            |
| gitr           | git reset             |
| gitrh          | git reset --hard      |
| gitd           | git diff              |
| gitaa          | git add -A            |
| mskill         | taskkill /F /IM msbuild.exe  |

# NuGet Examples

| Alias          | Equivalent Command    |
| -------------- |:---------------------:|
| c              | .\configure.ps1       |
| bfast          | .\build.ps1 -SkipUnitTest -Fast   |
| bfull          | .\build.ps1 -SkipUnitTest     |
| cb             | .\configure.ps1; .\build.ps1 -SkipUnitTest   |
| cbf            | .\configure.ps1; .\build.ps1 -SkipUnitTest -Fast   |
| mskill         | taskkill /F /IM msbuild.exe  |
| gpgkill        | taskkill /F /IM gpg*         |
| patchcli       | patch local cli with NuGet.CommandLine.dll  |

# Tooling Examples

| Alias          | Equivalent Command    |
| -------------- |:---------------------:|
| Run-NuGetTargetsCustom | Run a custom target in msbuild |
| Run-TestsWithFilter    | Run a custom set of tests      |

# Notes

* You need to have powershell installed.
* I have only tested this on Windows.
* If you already have a powershell profile then the Init script fails. If you want to over write the existing copy of the file, then use ```.\init.ps1 -f```
