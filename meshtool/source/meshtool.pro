win32:TARGET = ../../meshtool
!win32:TARGET = ../meshtool
TEMPLATE = app
CONFIG += console
CONFIG -= app_bundle
CONFIG -= qt

mac:QMAKE_CXXFLAGS += -std=c++11 -stdlib=libc++
mac:QMAKE_LFLAGS += -std=c++11 -stdlib=libc++
mac:QMAKE_POST_LINK += install_name_tool -change /Users/Javi/Downloads/assimp-3.1.1/_BUILD/code/libassimp.3.dylib libassimp.dylib ../meshtool
unix:!mac:QMAKE_CXXFLAGS += -std=c++11
unix:!mac:QMAKE_LFLAGS += -std=c++11

#Ensure that project builds in 32 bit mode on OS X
mac:QMAKE_CFLAGS += -m32
mac:QMAKE_CXXFLAGS += -m32
mac:QMAKE_LFLAGS += -m32

DEFINES += _CRT_SECURE_NO_WARNINGS

INCLUDEPATH += assimp/

win32:LIBS += -L../source/assimp/ -lassimp.win32 -lzlibstatic.win32
mac:LIBS += -L../source/assimp/ -lassimp.mac32 -lz
unix:!mac:LIBS += -L../source/assimp/ -lassimp.linux64 -lzlibstatic.linux64

SOURCES += \
	meshtool.cpp

HEADERS += \
    stringutils.h
