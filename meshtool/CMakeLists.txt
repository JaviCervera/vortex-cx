cmake_minimum_required(VERSION 2.6)

project(meshtool)

file(GLOB ALL_FILES "src/*.h" "src/*.cpp")

#Add preprocessor definitions and platform specific compiler options
add_definitions(-DGLEW_STATIC)
if (MSVC)
	add_definitions(-D_CRT_SECURE_NO_WARNINGS)
elseif (${CMAKE_SYSTEM_NAME} MATCHES "Mac")
	add_definitions(-std=c++11 -stdlib=libc++ -m32)
else (MSVC)
	add_definitions(-std=c++11 -m32)
endif (MSVC)

link_directories(${LINK_DIRECTORIES} ${CMAKE_CURRENT_SOURCE_DIR}/irrlicht)
add_executable(meshtool ${ALL_FILES})
