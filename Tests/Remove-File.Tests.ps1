# Remove-File.Tests
# 

BeforeAll {
    $exePath = Split-Path (Split-Path $PSCommandPath -Parent)
    $commandName = Split-Path $PSCommandPath.Replace('.Tests.ps1','.ps1') -Leaf
}

Describe "Remove-File" {
    # create test file
    BeforeAll {
        function Create-Data {
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
            # update file date
            Set-ItemProperty "$PSScriptRoot\temp\testfile4.txt" -Name LastWriteTime -Value "2015/01/01 10:20:30"
            # create file date
            Set-ItemProperty "$PSScriptRoot\temp\testfile4.txt" -Name CreationTime  -Value "2015/01/01 10:20:30"
        }
    }

    AfterAll {
       Remove-Item "$PSScriptRoot\temp" -Recurse
    }

    Context "check delete file true" {
        It "check delte " {
            Create-Data
            . $exePath\$commandName -v -f -path $PSScriptRoot\temp
        
            "$PSScriptRoot\temp\testfile1.txt" | Should -Not -Exist
            "$PSScriptRoot\temp\dir1\testfile4.txt" | Should -Exist
        }
        It "check delte option -r " {
            Create-Data
            . $exePath\$commandName -v -r -f -path $PSScriptRoot\temp

            "$PSScriptRoot\temp\testfile1.txt" | Should -Not -Exist
            "$PSScriptRoot\temp\dir1\testfile4.txt" | Should -Not -Exist
            "$PSScriptRoot\temp\dir2\dir21\testfile8.txt" | Should -Not -Exist
        }
        It "check delte option -include " {
            Create-Data
            . $exePath\$commandName -v -r -f -include test* -path $PSScriptRoot\temp

            "$PSScriptRoot\temp\filekeep.txt" | Should -Exist
            "$PSScriptRoot\temp\testfile1.txt" | Should -Not -Exist
            "$PSScriptRoot\temp\dir1\testfile4.txt" | Should -Not -Exist
            "$PSScriptRoot\temp\dir2\dir21\testfile8.txt" | Should -Not -Exist
        }
    }

}
