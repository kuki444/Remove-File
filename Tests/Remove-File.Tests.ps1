# Remove-File.Tests
# 

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$exePath = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace '\\Tests', ''
#. "$here\$sut"

Describe "Remove-File" {
    # create test file
    BeforeAll {
        New-Item "$PSScriptRoot\temp" -type directory -Force 
        New-Item "$PSScriptRoot\temp\dir1" -type directory -Force 
        New-Item "$PSScriptRoot\temp\dir2" -type directory -Force 
        New-Item "$PSScriptRoot\temp\dir2\dir21" -type directory -Force 
        New-Item "$PSScriptRoot\temp\dir2\dir22" -type directory -Force 
        New-Item "$PSScriptRoot\temp\testfile1.txt" -type file -Force 
        New-Item "$PSScriptRoot\temp\testfile2.txt" -type file -Force 
        New-Item "$PSScriptRoot\temp\testfile3.txt" -type file -Force 
        New-Item "$PSScriptRoot\temp\testfile4.txt" -type file -Force 
        New-Item "$PSScriptRoot\temp\testfile5.txt" -type file -Force 
        New-Item "$PSScriptRoot\temp\testfile6.txt" -type file -Force 
        New-Item "$PSScriptRoot\temp\filekeep.txt" -type file -Force 
        New-Item "$PSScriptRoot\temp\dir1\testfile4.txt" -type file -Force 
        New-Item "$PSScriptRoot\temp\dir1\testfile5.txt" -type file -Force 
        New-Item "$PSScriptRoot\temp\dir1\testfile6.txt" -type file -Force 
        New-Item "$PSScriptRoot\temp\dir2\testfile7.txt" -type file -Force 
        New-Item "$PSScriptRoot\temp\dir2\dir21\testfile8.txt" -type file -Force 
        New-Item "$PSScriptRoot\temp\dir2\dir22\testfile9.txt" -type file -Force 
        #更新日変更
        Set-ItemProperty "$PSScriptRoot\temp\testfile4.txt" -Name LastWriteTime -Value "2015/01/01 10:20:30"
        #作成日変更
        Set-ItemProperty "$PSScriptRoot\temp\testfile4.txt" -Name CreationTime  -Value "2015/01/01 10:20:30"
    }

    AfterAll {
       Remove-Item "$PSScriptRoot\temp" -Recurse
    }

    Context "check delete file true" {
        It "check delte " {
            . $exePath\$sut -v -f -path $PSScriptRoot\temp
        
            "$PSScriptRoot\temp\testfile1.txt" | Should Not Exist
            "$PSScriptRoot\temp\dir1\testfile4.txt" | Should Exist
        }
        It "check delte option -r " {
            . $exePath\$sut -v -r -f -path $PSScriptRoot\temp

            "$PSScriptRoot\temp\testfile1.txt" | Should Not Exist
            "$PSScriptRoot\temp\dir1\testfile4.txt" | Should Not Exist
            "$PSScriptRoot\temp\dir2\dir21\testfile8.txt" | Should Not Exist
        }
        It "check delte option -include " {
            . $exePath\$sut -v -r -f -include test* -path $PSScriptRoot\temp

            "$PSScriptRoot\temp\filekeep.txt" | Should Exist
            "$PSScriptRoot\temp\testfile1.txt" | Should Not Exist
            "$PSScriptRoot\temp\dir1\testfile4.txt" | Should Not Exist
            "$PSScriptRoot\temp\dir2\dir21\testfile8.txt" | Should Not Exist
        }
    }

}
