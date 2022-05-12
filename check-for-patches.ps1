# check-for-patches.ps1
# https://docs.microsoft.com/en-us/answers/questions/191945/get-hotfix-not-returning-all-installed-kbs.html
Write-Output "`r`nGetting a list of installed patches`r`n"
# Get the location of where the script is being run from
$location = (get-location).path
# Build a report file name
$OutFile = "$location\installed-patches.txt"
# Check for the log file and delete if it exists
if (Test-Path $OutFile)
    {
        Remove-Item $OutFile
    }
# Create an object and query for the updates
$Session = New-Object -ComObject "Microsoft.Update.Session"
$Searcher = $Session.CreateUpdateSearcher()
$historyCount = $Searcher.GetTotalHistoryCount()
# There is a lot of information in the object. We are just after the date and title of the update that was applied
$Searcher.QueryHistory(0, $historyCount) | Select-Object Date, Title |Where-Object {$_.Date -notlike "12/30/1899*"} | out-file -Width 500 -filepath "$OutFile"
Write-output "`r`nCheck $OutFile for more information"