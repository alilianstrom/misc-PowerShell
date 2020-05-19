# Create-Startup-Command-File.ps1
# Copy this script to the location of the PowerShell script and run it with the PowerShell script
# as the parameter to the script
#
# .\Create-Startup-Command-File.ps1 script.ps1
#
Param (
    [string]$param1
    )
if (!($param1))
    {
        "`n`nNeed a PowerShell script to create a startup file for`n`n`n"
        exit
    }
# Get the current working directory
$CWD = Get-Location
# Get the location of the PowerShell executable
$PSExe = (get-command powershell).path
# Check to see if the file exists
if (Test-Path $param1 -PathType leaf)
    {
        "`n`nPut the following command in the startup file to run the script $param1`n`n"
        "$PSExe -NoProfile -Command " + '"' + "&" + " " + "'" + $CWD + "\" + $param1 + "'" + '"'
        "`n`n"
    }
else 
    {
        #If the file doesn't exist let the user know
        "`n`nThe file provided, $param1, does not exist in $CWD`n`nPlease provide a valid file name`n`n"
    }
