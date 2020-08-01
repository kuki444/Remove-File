# Remove-File.ps1
# PowerShell 5 over
# Opthions:
#   -r: Recursive Search Directory
#   -v: View Remove File LIst
#   -f: Force Remove File Messege
#   -include: Include File Name
#   -exclude: Exclude File Name
#   -days: days Remove File 
#   -$path: Find Path (defult:.\)
# Param
param([switch] $r, [switch] $f, [switch] $v, $include, $exclude, $days, $path)
# Param Include Setting .\ Off
if($null -ne $include)
{
    if($include.StartsWith(".\"))
    {
        $include = $include.Remove(0,2)
    }
}
# Param Exclude Setting .\ Off
if ($null -ne $exclude)
{
    if($exclude.StartsWith(".\"))
    {
        $exclude = $exclude.Remove(0,2)
    }
}
# Param Path Setting
if ($null -eq $path)
{
    $path = "*"
}
# Param Recursion Setting And Find File
if ($r -eq $false)
{
    $result = Get-ChildItem -Path $path -Include $include -Exclude $exclude -File | Where-Object{$_.PSIsContainer -eq $false } | Where-Object{((Get-Date).Subtract($_.LastWriteTime)).Days -ge $days}
}
elseif ($r -eq $true)
{
    $result = Get-ChildItem -Path $path -Include $include -Exclude $exclude -Recurse -Force -File | Where-Object{$_.PSIsContainer -eq $false } | Where-Object{((Get-Date).Subtract($_.LastWriteTime)).Days -ge $days}
}
# Param View RemoveFile List
if ($v -eq $true)
{
    $result | Foreach-Object{$_.fullname}
}
if ($f -eq $false)
{
    $ans = "n"
    # Printing File Count   
    if ([string]::IsNullOrEmpty($result))
    {
        # File Count 0
        "`nCount`n---------`n" + 0
    }
    elseif ($result.gettype().fullname.toupper() -eq "SYSTEM.OBJECT[]")
    {
        # File Count 2 over
        "`nCount`n---------`n" + $result.length
        "Remove Regular Files? (y/n)"
        $ans = Read-Host
    }
    else
    {
        # File Count 1
        "`nCount`n---------`n" + 1
        "Remove Regular File? (y/n)"
        $ans = Read-Host
    }
    if ($ans.ToLower() -ne "y")
    {
        return
    }
}
    
# Remove Regular File
$result | Foreach-Object{Remove-Item $_.fullname}
