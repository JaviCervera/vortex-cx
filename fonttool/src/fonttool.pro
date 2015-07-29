win32:TARGET = ../../fonttool
!win32:TARGET = ../fonttool
TEMPLATE = app
CONFIG += console
CONFIG -= app_bundle
CONFIG -= qt

#mac:QMAKE_MAC_SDK = macosx10.9

#Ensure that project builds in 32 bit mode on OS X
mac:QMAKE_CFLAGS += -m32
mac:QMAKE_CXXFLAGS += -m32
mac:QMAKE_LFLAGS += -m32

DEFINES += _CRT_SECURE_NO_WARNINGS

INCLUDEPATH += ../../common/

SOURCES += \
    main.cpp \
    stb_truetype.c \
    stb_image_write.c

HEADERS += \
    stb_truetype.h \
    stb_image_write.h \
    ../../common/array.hpp \
    ../../common/string.hpp \
    ../../common/types.hpp \
    ../../meshtool/source/stringutils.h
