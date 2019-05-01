#Minimum version
cmake_minimum_required(VERSION 2.6)

#Define project
project(vortex)

#Define file groups
file(GLOB VORTEX_FILES "src/*.c" "lib/base64/base64.c" "lib/tinyfiledialogs/tinyfiledialogs.c")

#Add header and lib directories
include_directories(${INCLUDE_DIRECTORIES} ${CMAKE_CURRENT_SOURCE_DIR}/lib ${CMAKE_CURRENT_SOURCE_DIR}/lib/allegro/include ${CMAKE_CURRENT_SOURCE_DIR}/lib/allegro/_CMAKE/include)
link_directories(${LINK_DIRECTORIES} ${CMAKE_CURRENT_SOURCE_DIR}/lib/allegro/_CMAKE/lib ${CMAKE_CURRENT_SOURCE_DIR}/lib/glfw/_CMAKE/src ${CMAKE_CURRENT_SOURCE_DIR}/lib/sdl2/_CMAKE)

#Add executable targets
add_library(vortex SHARED ${VORTEX_FILES})

#Add platform specific options
if (${CMAKE_SYSTEM_NAME} MATCHES "Windows")
	add_definitions(-DWIN32 -DDLLEXPORT)
	if (MSVC)
		message("Platform is Windows (MSVC)")
		#add_definitions(-D_CRT_SECURE_NO_WARNINGS)
	else (MSVC)
		message("Platform is Windows (MinGW)")
		#set(CMAKE_C_FLAGS ${CMAKE_C_FLAGS} "-std=c90 -pedantic-errors -Wall")
		set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} "-std=c++98 -fno-exceptions -fno-rtti")
		set(CMAKE_EXE_LINKER_FLAGS ${CMAKE_EXE_LINKER_FLAGS} "-s -static -mwindows")
	endif (MSVC)
	target_link_libraries(vortex allegro_monolith-static glfw3 SDL2 opengl32 dsound gdi32 imm32 psapi shlwapi user32 version winmm ${TARGET_LINK_LIBRARIES})
elseif (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
	message("Platform is macOS")
	#add_definitions(-std=c++11 -stdlib=libc++)
	#set(CMAKE_C_FLAGS ${CMAKE_C_FLAGS} "-std=c90 -pedantic-errors -Wall")
	set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} "-std=c++98 -fno-exceptions -fno-rtti")
	target_link_libraries(vortex allegro_monolith-static glfw3 SDL2 iconv "-framework AppKit" "-framework AudioToolbox" "-framework Carbon" "-framework CoreAudio" "-framework CoreVideo" "-framework ForceFeedback" "-framework IOKit" "-framework OpenGL" ${TARGET_LINK_LIBRARIES})
elseif (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
	message("Platform is Linux")
	#set(CMAKE_C_FLAGS ${CMAKE_C_FLAGS} "-std=c90 -pedantic-errors -Wall")
	set(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} "-fno-exceptions -fno-rtti")
	#set(CMAKE_EXE_LINKER_FLAGS ${CMAKE_EXE_LINKER_FLAGS} "-s -static")
	target_link_libraries(vortex allegro_monolith-static glfw3 SDL2 asound dl GL m pthread pulse X11 Xcursor Xext Xi Xinerama Xrandr Xxf86vm ${TARGET_LINK_LIBRARIES})
else (${CMAKE_SYSTEM_NAME} MATCHES "Windows")
	message("Unrecognized platform " ${CMAKE_SYSTEM_NAME})
endif(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
