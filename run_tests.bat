@echo off

echo copying vortex dll...
copy "_build\libvortex.dll" test

echo building tests...
cd test
gcc -o test.exe test.c -DDLLIMPORT -L../_CMAKE -lvortex.dll

echo running tests...
echo.
test.exe

echo cleaning up...
del libvortex.dll
del test.exe
cd ..

pause
