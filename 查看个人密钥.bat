@echo off
Setlocal enabledelayedexpansion
::CODER BY Jenking POWERD BY iBAT

for /f "tokens=2 delims=-" %%a in ('dir %LocalAppData%\chia-blockchain ^| find "app-"') do set "app_version=%%a"
%LocalAppData%\chia-blockchain\app-%app_version%\resources\app.asar.unpacked\daemon\chia.exe keys show  --show-mnemonic-seed

pause