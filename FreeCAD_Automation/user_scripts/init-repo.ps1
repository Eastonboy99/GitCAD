# ==============================================================================================
#                                       Script Overview
# ==============================================================================================
# PowerShell script to call init-repo using git bash
# Usage: .\FreeCAD_Automation\user_scripts\init-repo.ps1

# ==============================================================================================
#                                  Call init-repo with Git Bash
# ==============================================================================================
# Use $PSScriptRoot to make paths work regardless of where FreeCAD_Automation is placed
& "$PSScriptRoot\..\bash.ps1" "$PSScriptRoot\init-repo" @args 

exit $SUCCESS
