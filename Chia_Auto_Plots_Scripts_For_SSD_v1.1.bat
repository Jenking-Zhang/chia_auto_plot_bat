@echo off
Setlocal enabledelayedexpansion
title Chia Auto Plots Scripts For SSD v1.1
::CODER BY Jenking POWERD BY iBAT

rem -----------------------------P盘参数-----------------------------
rem 设置用户标记，方便不同账号同时使用
set "user_tag=user1"
rem farmer公钥
set "farmer_key=0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
rem 矿池公钥
set "pool_key=0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
rem 最大内存
set /a max_ram=4300
rem k参数
set /a plot_size=32
rem 线程数
set /a threads=10
rem 桶大小
set /a buckets=128
rem 第一缓存路径
set "temp_path=D:\"
rem 是否使用第二缓存，0：禁用；1：使用
set /a use_temp2=0
rem 第二缓存路径
set "temp_path2=C:\"
rem 设置额外参数（必须以空格开始如： -e）
set "extra_parm="
rem 使用最终目录个数（预设10个路径，超出添加即可）
set /a final_dir_num=4
rem 第一个最终目录路径
set "final_path1=K:\HP"
rem 第二个最终目录路径
set "final_path2=L:\HP"
rem 第三个最终目录路径
set "final_path3=M:\HP"
rem 第四个最终目录路径
set "final_path4=P:\HP"
rem 第五个最终目录路径
set "final_path5=Q:\HP"
rem 第六个最终目录路径
set "final_path6=I:\HP"
rem 第七个最终目录路径
set "final_path7=J:\HP"
rem 第八个最终目录路径
set "final_path8=N:\HP"
rem 第九个最终目录路径
set "final_path9=G:\HP"
rem 第十个最终目录路径
set "final_path10=H:\HP"

rem -----------------------------脚本监控参数-----------------------------
rem 获取chia程序版本
for /f "tokens=2 delims=-" %%a in ('dir %LocalAppData%\chia-blockchain ^| find "app-"') do set "app_version=%%a"
rem chia程序路径
set "chia_path=%LocalAppData%\chia-blockchain\app-%app_version%\resources\app.asar.unpacked\daemon\chia.exe"
rem 最大允许同时第一阶段队列数
set /a max_p1=5
rem 最大允许同时P盘队列数
set /a max_progress_all=15
rem 日志目录
set "log_path=C:\chia_log"
rem 进程检查频率（s）
set /a run_frq=300
rem 进程超时时间（min）
set /a time_out=90

rem -----------------------------检查标记-----------------------------
rem 最终文件大小（GB）
set /a final_size=102
rem 检查第二阶段开始的标志字符
set "str_phase2=Starting phase 2/4"
rem 检查第三阶段开始的标志字符
set "str_phase3=Starting phase 3/4"
rem 检查第四阶段开始的标志字符
set "str_phase4=Starting phase 4/4"
rem 检查P盘完成的标志字符
set "str_done=Renamed final file"

rem -----------------------------内部参数-----------------------------
rem 初始化脚本检查次数
set /a times=0
rem 初始化已添加任务数
set /a task_num=0
rem 初始化不可用最终目录计数
set /a unavailable_final_path_num=0
rem 初始化最终目录循环计数
set /a final_path_sequence=0
rem 初始化每个队列完成计数参数
for /l %%i in (1,1,%max_progress_all%) do set /a p%%i_finish_num=0
rem 初始化输出任务
for /f "tokens=1,2 delims=#" %%a in ('"prompt #$h#$e# & echo on & for %%b in (1) do rem"') do (
	set "del=%%a"
)

rem -----------------------------脚本开始-----------------------------
call :ColorText 0c "=============================FBI Warning=============================" & echo.
call :ColorText 0c "    脚本通过日志输出判定程序状态，启动前请移除多余（未运行）队列" & echo.
call :ColorText 0c "日志，否则脚本将判定该队列被占用，脚本运行中请勿修改、删除日志文件，" & echo.
call :ColorText 0c "以免影响运行。" & echo.
call :ColorText 0c "=====================================================================" & echo.
echo. 
echo 按任意键开始...
pause >nul

rem 检查最终目录容量分区可用容量
echo.
call :ColorText 2f "正在检查最终目录分区可用容量，请稍后！" & echo.
for /l %%i in (1,1,%final_dir_num%) do (
	echo ---------------------------------------------------------------------
	set final_path=!final_path%%i!
	set disk_partition=!final_path:~0,1!
	echo 第%%i个最终目录路径：!final_path!
	call :getfreespace !final_path!
	if !free_space! lss %final_size% (
		set /a unavailable_final_path_num+=1
		call :ColorText 0c "错误！!disk_partition!盘剩余可用空间：!free_space!GB，不可用！" & echo.
	) else (
		call :ColorText 0a "!disk_partition!盘剩余可用空间：!free_space!GB，可用！" & echo.
	)
)
echo.
if !unavailable_final_path_num! GTR 0 (
	call :ColorText 4f "!unavailable_final_path_num!个最终目录容量不满足要求，是否继续？（按任意键继续，退出请关闭窗口）" & echo.
	pause >nul
)
echo.

rem 检查日志目录是否为空
echo 正在检查日志目录...
if exist %log_path% (
	if exist %log_path%\*.log (
		echo.
		call :ColorText 4e "Warning：日志目录存在文件，请检查并删除不需要的日志后继续！" & echo.
		echo.
		echo 按任意键打开日志目录...
		pause >nul
		start explorer %log_path%
		echo.
		call :ColorText 2f "确认日志无误后，按任意键继续！" & echo.
		pause >nul
		echo.
	)
) else (
	mkdir %log_path% > nul
)

:start
rem 初始化参数
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
rem 初始化最终目录所在盘符使用计数参数
for /l %%i in (1,1,%final_dir_num%) do (
	set disk_partition=!final_path%%i:~0,1!
	for %%j in (!disk_partition!) do set /a %%j_in_use=0
)

cls
title %user_tag%：Chia Auto Plots Scripts For SSD v1.1 (已检查%times%次)
rem 检查SSD任务
echo =====================SSD P盘任务列表，第%times%次检查=====================
for /l %%i in (1,1,%max_progress_all%) do (
	set /a sequence=%%i
	set "log_file=%log_path%\%user_tag%_p%%i.log"
	if exist !log_file! (
		set /a running_num+=1
		findstr /i /c:"%str_done%" "!log_file!" >nul 2>nul && (
			call :ColorText 2f "队列%%i：已完成P盘,队列可用！"
			set /a p%%i_finish_num+=1
			set /a available_sequence+=1
			set /a running_num+=-1
			set /a available!available_sequence!=%%i
			for /f "tokens=1,2 delims= " %%a in ('dir !log_file! ^| find "2021"') do set "log_file_time=%%a-%%b"
			set log_file_time=!log_file_time:~0,4!-!log_file_time:~5,2!-!log_file_time:~8,2!-!log_file_time:~11,2!-!log_file_time:~14,2!
			if not exist %log_path%\completed mkdir %log_path%\completed > nul
			move /y !log_file! %log_path%\completed\%user_tag%_p%%i_!log_file_time!.log > nul
		) || (
			rem 检查日志最后更新时间
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
							call :ColorText 4f "队列%%i：正在第4阶段，但日志更新已超时，请检查！！！"
							set /a in_p4_num+=1
						) || (
							call :ColorText 4f "队列%%i：正在第3阶段，但日志更新已超时，请检查！！！"
							set /a in_p3_num+=1
						)
					) || (
						call :ColorText 4f "队列%%i：正在第2阶段，但日志更新已超时，请检查！！！"
						set /a in_p2_num+=1
					)
				) || (
					call :ColorText 4f "队列%%i：正在第1阶段，但日志更新已超时，请检查！！！"
					set /a in_p1_num+=1
				)
			) else (
				findstr /i /c:"%str_phase2%" "!log_file!" >nul 2>nul && (
					findstr /i /c:"%str_phase3%" "!log_file!" >nul 2>nul && (
						findstr /i /c:"%str_phase4%" "!log_file!" >nul 2>nul && (
							call :ColorText 3f "队列%%i：正在第4阶段，即将完成！"
							set /a in_p4_num+=1
						) || (
							call :ColorText f1 "队列%%i：正在第3阶段，请稍后！"
							set /a in_p3_num+=1
						)
					) || (
						call :ColorText 0b "队列%%i：正在第2阶段，请稍后！"
						set /a in_p2_num+=1
					)
				) || (
					call :ColorText 4f "队列%%i：正在第1阶段，请耐心等待！"
					set /a in_p1_num+=1
				)
			)
		)
 	) else (
			call :ColorText 0a "队列%%i：没有找到%user_tag%_p%%i.log，队列未运行，可用！"
			set /a available_sequence+=1
			set /a available!available_sequence!=%%i
	)
	call :ColorText 0e "共完成!p%%i_finish_num!次！" & echo.
)

rem 检查是否添加SSD任务
if %running_num% lss %max_progress_all% (
	if %in_p1_num% lss %max_p1% (
		set /a add_progress_tag=1
	) else (
		set /a add_progress_tag=0
	)
) else (
		set /a add_progress_tag=0
)

rem 添加SSD P盘任务
if %add_progress_tag% equ 1 (
	set /a remaining_progress=%max_progress_all%-%running_num%
	set /a remaining_p1=%max_p1%-%in_p1_num%
	if !remaining_progress! lss !remaining_p1! (
		set /a add_progress=!remaining_progress!
	) else (
		set /a add_progress=!remaining_p1!
	)
	echo.
	call :ColorText 2f "检查完成，正在运行SSD P盘任务队列%running_num%个，第一阶段队列%in_p1_num%个,可以添加 !add_progress!个队列！" && echo.
	echo.
	call :ColorText 6f "准备添加SSD P盘任务!" && echo.
	for /l %%i in (1,1,!add_progress!) do (
		echo.
		call :ColorText 6f "正在添加第%%i个（队列!available%%i!），共!add_progress!个" && echo.
		echo 正在计算最终文件存放目录，请稍后！
		call :checkpathspace
		echo !disk_partition!
		start cmd /k plotter.bat !available%%i! !final_path! SDD
		call :ColorText 6f "完成！" && echo.
		set /a task_num+=1
		timeout /t 1 /nobreak > nul
	)
	echo.
	call :ColorText 0a "!add_progress!个任务添加完成！10s后重新检查" && echo. && timeout /t 10 /nobreak > nul && goto start
) else (
	echo.
	call :ColorText 0c "检查完成，正在运行队列%running_num%个，第一阶段队列%in_p1_num%个,不满足添加新队列条件！" && echo.
)

timeout /t %run_frq% /nobreak
goto start

:colortext
rem 背景：0=黑色 1=蓝色 2=绿色 3=浅绿色 4=红色 5=紫色 6=黄色 7=白色 8=灰色 9=淡蓝色
rem 字体：A=淡绿色 B=淡浅绿色 C=淡红色 D=淡紫色 E=淡黄色 F=亮白色
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
if !loop_times! gtr %final_dir_num% call :ColorText 4f "错误！!全部储存目录不可用，请检查后按任意键继续！" && echo. && pause >nul && set /a loop_times=0
set /a loop_times+=1
set /a path_sequence=!final_path_sequence!%%%final_dir_num%
if !path_sequence! equ 0 set /a path_sequence=%final_dir_num%
for %%j in (!path_sequence!) do set final_path=!final_path%%j!
set disk_partition=!final_path:~0,1!
echo 正在检查!final_path!分区容量，请稍后！
call :getfreespace !final_path!
for %%k in (!disk_partition!) do set /a in_use=!%%k_in_use!
for %%k in (!disk_partition!) do set /a free_space=!free_space!-!%%k_in_use!
if !free_space! lss %final_size% (
	call :ColorText 0c "错误！!disk_partition!盘剩余可用空间：!free_space!GB，正在运行进程占用!in_use!GB，不可用！" && echo.
	call :checkpathspace
) else (
	call :ColorText 0a "!disk_partition!盘剩余可用空间：!free_space!GB，可用！" && echo.
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
