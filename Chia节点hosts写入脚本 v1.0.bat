@echo off
title Chia节点hosts写入脚本 v1.0
cd /d %~dp0
%1 start "" mshta vbscript:createobject("shell.application").shellexecute("""%~0""","::",,"runas",1)(window.close)&exit

echo Y|cacls %windir%\System32\drivers\etc\hosts /T /G Everyone:F > nul
attrib %windir%\System32\drivers\etc\hosts -r

echo 54.148.161.21 node.chia.net >>%systemroot%\system32\drivers\etc\hosts
echo 52.36.85.74 node.chia.net >>%systemroot%\system32\drivers\etc\hosts
echo 18.181.21.197 node.chia.net >>%systemroot%\system32\drivers\etc\hosts
echo 18.179.127.148 node.chia.net >>%systemroot%\system32\drivers\etc\hosts
echo 3.9.208.191 node.chia.net >>%systemroot%\system32\drivers\etc\hosts
echo 18.130.174.242 node.chia.net >>%systemroot%\system32\drivers\etc\hosts

start notepad "%windir%\System32\drivers\etc\hosts"

ipconfig -flushdns
echo HOSTS修改完成，请按任意键退出
pause > nul