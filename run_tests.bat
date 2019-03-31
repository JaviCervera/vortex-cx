@echo off

echo copying vortex dll...
copy "_build\vortex.dll" test

echo building tests...
cd test
gcc -o test.exe test.c -I../lib/allegro/include -I../lib/allegro/_CMAKE/include -L../lib/allegro/_CMAKE/lib -lallegro_monolith-static -lopengl32 -ldsound -lpsapi -lshlwapi -lwinmm -lgdi32 -lcomdlg32 -lole32

echo running tests...
echo.
test.exe

echo cleaning up...
del vortex.dll
del test.exe
cd ..

pause
