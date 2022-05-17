# rsn.ps1
# Take a certificate serial number and reverse it while retaining byte order so that it can be used to populate
# The AltSecurityIdentites attribute in Active Directory for KB5014754
$ExSN = "01020304050607080910111213141516171819"
write-output "`r`nCurrent SN`t$ExSN"
$numel = ($ExSN.length)/2
[array]$SnEl=$null;
$c=0;
while ($c -lt $numel)
    {
        $Position = $c * 2;
        $Element = $ExSN.substring($Position,2);
        $SnEl += $Element;
        $c++
    }
[array]::Reverse($SnEl)
$NewSN = -join($SnEl)
write-output "Reversed SN`t$NewSN"
