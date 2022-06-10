@echooff

set folder="C:\Users\systemizer\Videos\Debut\"
cd /d %folder%
for /F "delims=" %%i in ('dir /b') do (rmdir "%%i" /s/q || del "%%i" /s/q)

waitfor SomethingThatIsNeverHappening /t 3


start ms-settings:windowsupdate -WindowStyle maximized
Powershell.exe -executionpolicy remotesigned -File  C:\Users\systemizer\Documents\winupdate.ps1

waitfor SomethingThatIsNeverHappening /t 5


start ms-settings:windowsupdate-options

Powershell.exe -executionpolicy remotesigned -File  C:\Users\systemizer\Documents\wsup_option.ps1

waitfor SomethingThatIsNeverHappening /t 5

start ms-settings:about

Powershell.exe -executionpolicy remotesigned -File  C:\Users\systemizer\Documents\about.ps1

waitfor SomethingThatIsNeverHappening /t 5


start ms-settings:windowsdefender

waitfor SomethingThatIsNeverHappening /t 5


start ms-settings:yourinfo

waitfor SomethingThatIsNeverHappening /t 5


powershell -Command "& { Get-LocalUser | Where Enabled -eq "True" }"

waitfor SomethingThatIsNeverHappening /t 5



