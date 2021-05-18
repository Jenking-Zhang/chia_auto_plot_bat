@echo off
Setlocal enabledelayedexpansion
title Chia Auto Plots Scripts For SSD v1.1
::CODER BY Jenking POWERD BY iBAT

rem -----------------------------P�̲���-----------------------------
rem �����û���ǣ����㲻ͬ�˺�ͬʱʹ��
set "user_tag=user1"
rem farmer��Կ
set "farmer_key=0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
rem ��ع�Կ
set "pool_key=0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
rem ����ڴ�
set /a max_ram=4300
rem k����
set /a plot_size=32
rem �߳���
set /a threads=10
rem Ͱ��С
set /a buckets=128
rem ��һ����·��
set "temp_path=D:\"
rem �Ƿ�ʹ�õڶ����棬0�����ã�1��ʹ��
set /a use_temp2=0
rem �ڶ�����·��
set "temp_path2=C:\"
rem ���ö�������������Կո�ʼ�磺 -e��
set "extra_parm="
rem ʹ������Ŀ¼������Ԥ��10��·����������Ӽ��ɣ�
set /a final_dir_num=4
rem ��һ������Ŀ¼·��
set "final_path1=K:\HP"
rem �ڶ�������Ŀ¼·��
set "final_path2=L:\HP"
rem ����������Ŀ¼·��
set "final_path3=M:\HP"
rem ���ĸ�����Ŀ¼·��
set "final_path4=P:\HP"
rem ���������Ŀ¼·��
set "final_path5=Q:\HP"
rem ����������Ŀ¼·��
set "final_path6=I:\HP"
rem ���߸�����Ŀ¼·��
set "final_path7=J:\HP"
rem �ڰ˸�����Ŀ¼·��
set "final_path8=N:\HP"
rem �ھŸ�����Ŀ¼·��
set "final_path9=G:\HP"
rem ��ʮ������Ŀ¼·��
set "final_path10=H:\HP"

rem -----------------------------�ű���ز���-----------------------------
rem ��ȡchia����汾
for /f "tokens=2 delims=-" %%a in ('dir %LocalAppData%\chia-blockchain ^| find "app-"') do set "app_version=%%a"
rem chia����·��
set "chia_path=%LocalAppData%\chia-blockchain\app-%app_version%\resources\app.asar.unpacked\daemon\chia.exe"
rem �������ͬʱ��һ�׶ζ�����
set /a max_p1=5
rem �������ͬʱP�̶�����
set /a max_progress_all=15
rem ��־Ŀ¼
set "log_path=C:\chia_log"
rem ���̼��Ƶ�ʣ�s��
set /a run_frq=300
rem ���̳�ʱʱ�䣨min��
set /a time_out=90

rem -----------------------------�����-----------------------------
rem �����ļ���С��GB��
set /a final_size=102
rem ���ڶ��׶ο�ʼ�ı�־�ַ�
set "str_phase2=Starting phase 2/4"
rem �������׶ο�ʼ�ı�־�ַ�
set "str_phase3=Starting phase 3/4"
rem �����Ľ׶ο�ʼ�ı�־�ַ�
set "str_phase4=Starting phase 4/4"
rem ���P����ɵı�־�ַ�
set "str_done=Renamed final file"

rem -----------------------------�ڲ�����-----------------------------
rem ��ʼ���ű�������
set /a times=0
rem ��ʼ�������������
set /a task_num=0
rem ��ʼ������������Ŀ¼����
set /a unavailable_final_path_num=0
rem ��ʼ������Ŀ¼ѭ������
set /a final_path_sequence=0
rem ��ʼ��ÿ��������ɼ�������
for /l %%i in (1,1,%max_progress_all%) do set /a p%%i_finish_num=0
rem ��ʼ���������
for /f "tokens=1,2 delims=#" %%a in ('"prompt #$h#$e# & echo on & for %%b in (1) do rem"') do (
	set "del=%%a"
)

rem -----------------------------�ű���ʼ-----------------------------
call :ColorText 0c "=============================FBI Warning=============================" & echo.
call :ColorText 0c "    �ű�ͨ����־����ж�����״̬������ǰ���Ƴ����ࣨδ���У�����" & echo.
call :ColorText 0c "��־������ű����ж��ö��б�ռ�ã��ű������������޸ġ�ɾ����־�ļ���" & echo.
call :ColorText 0c "����Ӱ�����С�" & echo.
call :ColorText 0c "=====================================================================" & echo.
echo. 
echo ���������ʼ...
pause >nul

rem �������Ŀ¼����������������
echo.
call :ColorText 2f "���ڼ������Ŀ¼�����������������Ժ�" & echo.
for /l %%i in (1,1,%final_dir_num%) do (
	echo ---------------------------------------------------------------------
	set final_path=!final_path%%i!
	set disk_partition=!final_path:~0,1!
	echo ��%%i������Ŀ¼·����!final_path!
	call :getfreespace !final_path!
	if !free_space! lss %final_size% (
		set /a unavailable_final_path_num+=1
		call :ColorText 0c "����!disk_partition!��ʣ����ÿռ䣺!free_space!GB�������ã�" & echo.
	) else (
		call :ColorText 0a "!disk_partition!��ʣ����ÿռ䣺!free_space!GB�����ã�" & echo.
	)
)
echo.
if !unavailable_final_path_num! GTR 0 (
	call :ColorText 4f "!unavailable_final_path_num!������Ŀ¼����������Ҫ���Ƿ����������������������˳���رմ��ڣ�" & echo.
	pause >nul
)
echo.

rem �����־Ŀ¼�Ƿ�Ϊ��
echo ���ڼ����־Ŀ¼...
if exist %log_path% (
	if exist %log_path%\*.log (
		echo.
		call :ColorText 4e "Warning����־Ŀ¼�����ļ������鲢ɾ������Ҫ����־�������" & echo.
		echo.
		echo �����������־Ŀ¼...
		pause >nul
		start explorer %log_path%
		echo.
		call :ColorText 2f "ȷ����־����󣬰������������" & echo.
		pause >nul
		echo.
	)
) else (
	mkdir %log_path% > nul
)

:start
rem ��ʼ������
set /a times+=1
set /a running_num=0
set /a after_p1_num=0
set /a in_p1_num=0
set /a in_p2_num=0
set /a in_p3_num=0
set /a in_p4_num=0
set /a outtime_num=0
set /a available_sequence=0
set /a remaining_progress=0
set /a remaining_p1=0
set /a add_progress=0
set /a finish_num=0
set /a add_progress_tag=0
rem ��ʼ������Ŀ¼�����̷�ʹ�ü�������
for /l %%i in (1,1,%final_dir_num%) do (
	set disk_partition=!final_path%%i:~0,1!
	for %%j in (!disk_partition!) do set /a %%j_in_use=0
)

cls
title %user_tag%��Chia Auto Plots Scripts For SSD v1.1 (�Ѽ��%times%��)
rem ���SSD����
echo =====================SSD P�������б���%times%�μ��=====================
for /l %%i in (1,1,%max_progress_all%) do (
	set /a sequence=%%i
	set "log_file=%log_path%\%user_tag%_p%%i.log"
	if exist !log_file! (
		set /a running_num+=1
		findstr /i /c:"%str_done%" "!log_file!" >nul 2>nul && (
			call :ColorText 2f "����%%i�������P��,���п��ã�"
			set /a p%%i_finish_num+=1
			set /a available_sequence+=1
			set /a running_num+=-1
			set /a available!available_sequence!=%%i
			for /f "tokens=1,2 delims= " %%a in ('dir !log_file! ^| find "2021"') do set "log_file_time=%%a-%%b"
			set log_file_time=!log_file_time:~0,4!-!log_file_time:~5,2!-!log_file_time:~8,2!-!log_file_time:~11,2!-!log_file_time:~14,2!
			if not exist %log_path%\completed mkdir %log_path%\completed > nul
			move /y !log_file! %log_path%\completed\%user_tag%_p%%i_!log_file_time!.log > nul
		) || (
			rem �����־������ʱ��
			for /f "tokens=5 delims= " %%a in ('findstr "Partition" !log_file!') do set disk_partition=%%a
			for %%j in (!disk_partition!) do set /a %%j_in_use+=%final_size%
			for /f "tokens=1,2 delims= " %%a in ('dir !log_file! ^| find "2021"') do set "log_file_time=%%a %%b"
			call :datetomins !log_file_time:~0,4! !log_file_time:~5,2! !log_file_time:~8,2! !log_file_time:~11,2! !log_file_time:~14,3! mlog_file_time
			call :datetomins %date:~0,4% %date:~5,2% %date:~8,2% %time:~0,2% %time:~3,2% now_time
 			set /a mminus=now_time-mlog_file_time
			if !mminus! gtr %time_out% (
				set /a outtime_num+=1
				findstr /i /c:"%str_phase2%" "!log_file!" >nul 2>nul && (
					findstr /i /c:"%str_phase3%" "!log_file!" >nul 2>nul && (
						findstr /i /c:"%str_phase4%" "!log_file!" >nul 2>nul && (
							call :ColorText 4f "����%%i�����ڵ�4�׶Σ�����־�����ѳ�ʱ�����飡����"
							set /a in_p4_num+=1
						) || (
							call :ColorText 4f "����%%i�����ڵ�3�׶Σ�����־�����ѳ�ʱ�����飡����"
							set /a in_p3_num+=1
						)
					) || (
						call :ColorText 4f "����%%i�����ڵ�2�׶Σ�����־�����ѳ�ʱ�����飡����"
						set /a in_p2_num+=1
					)
				) || (
					call :ColorText 4f "����%%i�����ڵ�1�׶Σ�����־�����ѳ�ʱ�����飡����"
					set /a in_p1_num+=1
				)
			) else (
				findstr /i /c:"%str_phase2%" "!log_file!" >nul 2>nul && (
					findstr /i /c:"%str_phase3%" "!log_file!" >nul 2>nul && (
						findstr /i /c:"%str_phase4%" "!log_file!" >nul 2>nul && (
							call :ColorText 3f "����%%i�����ڵ�4�׶Σ�������ɣ�"
							set /a in_p4_num+=1
						) || (
							call :ColorText f1 "����%%i�����ڵ�3�׶Σ����Ժ�"
							set /a in_p3_num+=1
						)
					) || (
						call :ColorText 0b "����%%i�����ڵ�2�׶Σ����Ժ�"
						set /a in_p2_num+=1
					)
				) || (
					call :ColorText 4f "����%%i�����ڵ�1�׶Σ������ĵȴ���"
					set /a in_p1_num+=1
				)
			)
		)
 	) else (
			call :ColorText 0a "����%%i��û���ҵ�%user_tag%_p%%i.log������δ���У����ã�"
			set /a available_sequence+=1
			set /a available!available_sequence!=%%i
	)
	call :ColorText 0e "�����!p%%i_finish_num!�Σ�" & echo.
)

rem ����Ƿ����SSD����
if %running_num% lss %max_progress_all% (
	if %in_p1_num% lss %max_p1% (
		set /a add_progress_tag=1
	) else (
		set /a add_progress_tag=0
	)
) else (
		set /a add_progress_tag=0
)

rem ���SSD P������
if %add_progress_tag% equ 1 (
	set /a remaining_progress=%max_progress_all%-%running_num%
	set /a remaining_p1=%max_p1%-%in_p1_num%
	if !remaining_progress! lss !remaining_p1! (
		set /a add_progress=!remaining_progress!
	) else (
		set /a add_progress=!remaining_p1!
	)
	echo.
	call :ColorText 2f "�����ɣ���������SSD P���������%running_num%������һ�׶ζ���%in_p1_num%��,������� !add_progress!�����У�" && echo.
	echo.
	call :ColorText 6f "׼�����SSD P������!" && echo.
	for /l %%i in (1,1,!add_progress!) do (
		echo.
		call :ColorText 6f "������ӵ�%%i��������!available%%i!������!add_progress!��" && echo.
		echo ���ڼ��������ļ����Ŀ¼�����Ժ�
		call :checkpathspace
		echo !disk_partition!
		start cmd /k plotter.bat !available%%i! !final_path! SDD
		call :ColorText 6f "��ɣ�" && echo.
		set /a task_num+=1
		timeout /t 1 /nobreak > nul
	)
	echo.
	call :ColorText 0a "!add_progress!�����������ɣ�10s�����¼��" && echo. && timeout /t 10 /nobreak > nul && goto start
) else (
	echo.
	call :ColorText 0c "�����ɣ��������ж���%running_num%������һ�׶ζ���%in_p1_num%��,����������¶���������" && echo.
)

timeout /t %run_frq% /nobreak
goto start

:colortext
rem ������0=��ɫ 1=��ɫ 2=��ɫ 3=ǳ��ɫ 4=��ɫ 5=��ɫ 6=��ɫ 7=��ɫ 8=��ɫ 9=����ɫ
rem ���壺A=����ɫ B=��ǳ��ɫ C=����ɫ D=����ɫ E=����ɫ F=����ɫ
<nul set /p ".=%del%" > "%~2"
findstr /v /a:%1 /r "^$" "%~2" nul
del "%~2" > nul 2>&1
goto :eof

:getfreespace %check_path% result
set /a free_space=0
set check_path=%1
set check_partition=%check_path:~0,1%
for /f "tokens=2 delims==" %%j in ('wmic logicaldisk %check_partition%: get FreeSpace/value') do set "free_space=%%j"
if "%free_space%" equ "" (
	set /a free_space=0
) else (
	if "%free_space%"=="0" (
		set /a free_space=0
	) else (
		set /a free_space=%free_space:~0,-6%/10737
	)	
)
goto :eof

:checkpathspace
set /a final_path_sequence+=1
set /a space=0
if !loop_times! gtr %final_dir_num% call :ColorText 4f "����!ȫ������Ŀ¼�����ã�����������������" && echo. && pause >nul && set /a loop_times=0
set /a loop_times+=1
set /a path_sequence=!final_path_sequence!%%%final_dir_num%
if !path_sequence! equ 0 set /a path_sequence=%final_dir_num%
for %%j in (!path_sequence!) do set final_path=!final_path%%j!
set disk_partition=!final_path:~0,1!
echo ���ڼ��!final_path!�������������Ժ�
call :getfreespace !final_path!
for %%k in (!disk_partition!) do set /a in_use=!%%k_in_use!
for %%k in (!disk_partition!) do set /a free_space=!free_space!-!%%k_in_use!
if !free_space! lss %final_size% (
	call :ColorText 0c "����!disk_partition!��ʣ����ÿռ䣺!free_space!GB���������н���ռ��!in_use!GB�������ã�" && echo.
	call :checkpathspace
) else (
	call :ColorText 0a "!disk_partition!��ʣ����ÿռ䣺!free_space!GB�����ã�" && echo.
)
goto :eof

:datetomins %yy% %mm% %dd% %hh% %nn% result
set yy=%1 & set mm=%2 & set dd=%3 & set hh=%4 & set nn=%5
if 1%yy% lss 200 if 1%yy% lss 170 (set yy=20%yy%) else (set yy=19%yy%)
set /a dd=100%dd%%%100,mm=100%mm%%%100
set /a z=14-mm,z/=12,y=yy+4800-z,m=mm+12*z-3,j=153*m+2
set /a j=j/5+dd+y*365+y/4-y/100+y/400-2472633
if 1%hh% lss 20 set hh=0%hh%
if {%nn:~2,1%} equ {p} if "%hh%" neq "12" set hh=1%hh% & set/a hh-=88
if {%nn:~2,1%} equ {a} if "%hh%" equ "12" set hh=00
if {%nn:~2,1%} geq {a} set nn=%nn:~0,2%
set /a hh=100%hh%%%100,nn=100%nn%%%100,j=j*1440+hh*60+nn
set %6=%j% 
goto :eof
