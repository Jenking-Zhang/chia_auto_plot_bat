@echo off
Setlocal enabledelayedexpansion
::CODER BY Jenking POWERD BY iBAT

rem 设置监控磁盘
set disk_partition=E
rem 设置监控磁盘
set disk_partition2=F
rem 设置检查间隔(s)
set /a check_time=60

set log_file=%USERPROFILE%\Desktop\cpu_mem_disk.csv
if exist %log_file% (
  del /q %log_file% >nul
)
echo 时间,CPU负载,CPU使用率,可用内存(MB),%disk_partition%盘剩余空间(GB),%disk_partition2%盘剩余空间(GB) >> %log_file%

mode con cols=52 lines=10
:start
cls
set /a times+=1
title CPU、内存、硬盘监控(已检查%times%次)
color 4f
for /f "tokens=2 delims==" %%i in ('wmic cpu get loadpercentage /value ^|find "="') do set loadper=%%i 
for /f "tokens=2 delims==" %%a in ('wmic path Win32_PerfFormattedData_PerfOS_Processor get PercentProcessorTime /value ^| findstr "PercentProcessorTime"') do set UseCPU=%%a
for /f "tokens=2 delims==" %%a in ('wmic path Win32_PerfFormattedData_PerfOS_Memory get * /value ^| findstr "AvailableBytes"') do set free_mem=%%a &&	set /a free_mem=!free_mem:~0,-5%!/1049
for /f "tokens=2 delims==" %%a in ('wmic logicaldisk !disk_partition!: get FreeSpace/value') do set "space=%%a" && set /a space=!space:~0,-6%!/10737
for /f "tokens=2 delims==" %%a in ('wmic logicaldisk !disk_partition2!: get FreeSpace/value') do set "space2=%%a" && set /a space2=!space2:~0,-6%!/10737
set now_time=%date:~0,4%-%date:~5,2%-%date:~8,2%^/%time:~0,2%:%time:~3,2%:%time:~6,2%

color 0a
echo %now_time%
echo CPU负载：%loadper%%%
echo CPU使用率：%UseCPU%%%
echo 可用内存(MB)：%free_mem%
echo %disk_partition%盘剩余空间(GB)：%space%
echo %disk_partition2%盘剩余空间(GB)：%space2%
echo %now_time%,%loadper%%%,%UseCPU%%%,%free_mem%,%space%,%space2% >> %log_file%

timeout /t %check_time% /nobreak
goto start
pause