@echo off

echo generating input codes...
g++ -std=c++11 gen_inputcodes.cc
a.exe
g++ -std=c++11 gen_inputcodes2.cc
a.exe
del gen_inputcodes2.cc

echo generating default font...
g++ gen_defaultfont.cc ../lib/base64/base64.c
a.exe

echo done.
del a.exe
pause

