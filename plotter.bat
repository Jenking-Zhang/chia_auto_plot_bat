@echo off
Setlocal enabledelayedexpansion
::CODER BY Jenking POWERD BY iBAT
color 4e

rem ���к�
set /a task_sequence=%1
rem Ŀ��·��
set "final_path=%2"
rem ����
set "type=%3"
rem ������־�ļ���
if "%type%" equ "HDD" (
	set "log_file=%log_path%\%user_tag%_hdd_p%task_sequence%.log"
) else (
	set "log_file=%log_path%\%user_tag%_p%task_sequence%.log"
)
rem ���û���·��
set temp_path=%temp_path%%user_tag%_p%task_sequence%\
rem ���ö���·��
set temp_path2=%temp_path2%%user_tag%_p%task_sequence%\
rem �������л���Ŀ¼
if not exist %temp_path% mkdir %temp_path%\
rem ��ȡ��ǰʱ��(��ʼ)
set start_time=%date:~5,2%.%date:~8,2%/%time:~0,2%:%time:~3,2%

rem -----------------------------��ʼP��-----------------------------

rem д���̷���Ϣ����־
echo Final Path Partition is: %disk_partition% 2>>&1 | mtee.exe %log_file%

if %use_temp2% == 1 (
	title %type% P����,�����������ʼ��%start_time%�����У�%task_sequence%^/%max_progress_all%���̣߳�%threads%���ڴ棺%max_ram%��һ����%temp_path%��������%temp_path2%������·����%final_path%
	echo P�����%chia_path% plots create -f %farmer_key% -p %pool_key% -k %plot_size% -n 1 -r %threads% -b %max_ram% -u %buckets% -t %temp_path% -2 %temp_path2% -d %final_path%%extra_parm%
	%chia_path% plots create -f %farmer_key% -p %pool_key% -k %plot_size% -n 1 -r %threads% -b %max_ram% -u %buckets% -t %temp_path% -2 %temp_path2% -d %final_path%%extra_parm% 2>>&1 | mtee.exe /+ %log_file%
) else (
	title %type% P����,�����������ʼ��%start_time%�����У�%task_sequence%^/%max_progress_all%���̣߳�%threads%���ڴ棺%max_ram%�����棺%temp_path%������·����%final_path%
	echo P�����%chia_path% plots create -f %farmer_key% -p %pool_key% -k %plot_size% -n 1 -r %threads% -b %max_ram% -u %buckets% -t %temp_path% -d %final_path%%extra_parm%
	%chia_path% plots create -f %farmer_key% -p %pool_key% -k %plot_size% -n 1 -r %threads% -b %max_ram% -u %buckets% -t %temp_path% -d %final_path%%extra_parm% 2>>&1 | mtee.exe /+ %log_file%
)
color 2f
rem ��ȡ��ǰʱ�䣨������
set end_time=%date:~5,2%.%date:~8,2%/%time:~0,2%:%time:~3,2%
title P�̳������˳�������������־�����У�%task_sequence%^/%max_progress_all%����ʼ��%start_time%��������%end_time%
echo P�̳������˳�������������־�����У�%task_sequence%^/%max_progress_all%����ʼ��%start_time%��������%end_time%

pause >nul