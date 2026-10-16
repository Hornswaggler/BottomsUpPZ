@echo off
powershell -NoProfile -Command "Get-Content '%USERPROFILE%\Zomboid\console.txt' -Wait -Tail 10"
pause