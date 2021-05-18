@echo off
Setlocal enabledelayedexpansion
::CODER BY Jenking POWERD BY iBAT
color 4e

rem 队列号
set /a task_sequence=%1
rem 目标路径
set "final_path=%2"
rem 类型
set "type=%3"
rem 设置日志文件名
if "%type%" equ "HDD" (
	set "log_file=%log_path%\%user_tag%_hdd_p%task_sequence%.log"
) else (
	set "log_file=%log_path%\%user_tag%_p%task_sequence%.log"
)
rem 设置缓存路径
set temp_path=%temp_path%%user_tag%_p%task_sequence%\
rem 设置二缓路径
set temp_path2=%temp_path2%%user_tag%_p%task_sequence%\
rem 创建队列缓存目录
if not exist %temp_path% mkdir %temp_path%\
rem 获取当前时间(开始)
set start_time=%date:~5,2%.%date:~8,2%/%time:~0,2%:%time:~3,2%

rem -----------------------------开始P盘-----------------------------

rem 写入盘符信息到日志
echo Final Path Partition is: %disk_partition% 2>>&1 | mtee.exe %log_file%

if %use_temp2% == 1 (
	title %type% P盘中,请勿操作！开始：%start_time%，队列：%task_sequence%^/%max_progress_all%，线程：%threads%，内存：%max_ram%，一缓：%temp_path%，二缓：%temp_path2%，最终路径：%final_path%
	echo P盘命令：%chia_path% plots create -f %farmer_key% -p %pool_key% -k %plot_size% -n 1 -r %threads% -b %max_ram% -u %buckets% -t %temp_path% -2 %temp_path2% -d %final_path%%extra_parm%
	%chia_path% plots create -f %farmer_key% -p %pool_key% -k %plot_size% -n 1 -r %threads% -b %max_ram% -u %buckets% -t %temp_path% -2 %temp_path2% -d %final_path%%extra_parm% 2>>&1 | mtee.exe /+ %log_file%
) else (
	title %type% P盘中,请勿操作！开始：%start_time%，队列：%task_sequence%^/%max_progress_all%，线程：%threads%，内存：%max_ram%，缓存：%temp_path%，最终路径：%final_path%
	echo P盘命令：%chia_path% plots create -f %farmer_key% -p %pool_key% -k %plot_size% -n 1 -r %threads% -b %max_ram% -u %buckets% -t %temp_path% -d %final_path%%extra_parm%
	%chia_path% plots create -f %farmer_key% -p %pool_key% -k %plot_size% -n 1 -r %threads% -b %max_ram% -u %buckets% -t %temp_path% -d %final_path%%extra_parm% 2>>&1 | mtee.exe /+ %log_file%
)
color 2f
rem 获取当前时间（结束）
set end_time=%date:~5,2%.%date:~8,2%/%time:~0,2%:%time:~3,2%
title P盘程序已退出，请检查运行日志！队列：%task_sequence%^/%max_progress_all%，开始：%start_time%，结束：%end_time%
echo P盘程序已退出，请检查运行日志！队列：%task_sequence%^/%max_progress_all%，开始：%start_time%，结束：%end_time%

pause >nul