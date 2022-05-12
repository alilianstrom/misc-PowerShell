# Patch-Test.ps1
# Function from https://4sysops.com/archives/use-dcdiag-with-powershell-to-check-domain-controller-health/

# Define the function
function Invoke-DcDiag {
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$DomainController
    )
    $result = dcdiag /s:$DomainController
    $result | select-string -pattern '\. (.*) \b(passed|failed)\b test (.*)' | foreach {
        $obj = @{
            TestName = $_.Matches.Groups[3].Value
            TestResult = $_.Matches.Groups[2].Value
            Entity = $_.Matches.Groups[1].Value
        }
        [pscustomobject]$obj
    }
}

write-output "Checking firewall logs`r`n"
get-content -Tail 20 "c:\Windows\system32\LogFiles\Firewall\pfirewall.log"
cmd /c 'pause'
write-output "`r`nChecking the FalconStrike Service`r`n"
get-service CsFalconService
cmd /c 'pause'
write-output "`r`nChecking the Change Auditor Service `r`n"
Get-Service npsrvhost
cmd /c 'pause'
write-output "`r`nChecking the Semperis Services`r`n"
Get-Service SmprsBootstrap
Get-Service SmprsAdfrAgent
cmd /c 'pause'
write-output "`r`nChecking the Event Logs`r`n"
# "Application","Security","System","Active Directory Web Services","DFS Replication","Directory Service" | ForEach-Object { write-output "$_`r`n"; Get-Eventlog -Newest 10 -LogName $_ ;Write-output "`r`n" }
"Application","Security","System","Active Directory Web Services","DFS Replication","Directory Service" | ForEach-Object { write-output "$_`r`n"; Get-WinEvent -filterhash @{Logname = $_ } -MaxEvents 10 | Format-Table Id,TimeCreated,LevelDisplayName,Message ;Write-output "`r`n";cmd /c 'pause' }
# Get-WinEvent -filterhash @{Logname = 'system'} -MaxEvents 10 | Format-Table Id,TimeCreated,LevelDisplayName,Message
# cmd /c 'pause'
write-output "`r`nRunning DCDiag Tests`r`n"
$DC = hostname
Invoke-DcDiag -DomainController $DC
cmd /c 'pause'
write-output "`r`nCreating GPO report`r`n"
$location = (Get-Location).path
# Build a GPO report file name
$GPOFile = "$location\gpo.txt"
# Check for the GPO log file and delete if it exists
if (Test-Path $GPOFile)
    {
        Remove-Item $GPOFile
    }
$commmm = "gpresult /scope computer /z > $GPOFile"
cmd /c $commmm
cmd /c 'pause'
$commmm = "notepad $location\gpo.txt"
cmd /c $commmm