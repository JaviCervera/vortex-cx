@echo off

rem echo compressing...
rem upx.exe _build/vortex.dll
upx.exe --brute _build/vortex.dll

pause
