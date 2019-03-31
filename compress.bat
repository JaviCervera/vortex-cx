@echo off

rem echo compressing...
rem upx.exe _build/libvortex.dll
upx.exe --brute _build/libvortex.dll

pause
