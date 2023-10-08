# 動作確認できたCMakeのバージョン
cmake_minimum_required(VERSION 3.16)

# project情報
project(toppers_sample2
    DESCRIPTION "TOPPERS sample2 win32"
    LANGUAGES C CXX
)

# コンパイル情報をJSON形式で出力
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# in-source ビルドガード
if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
    message(FATAL_ERROR "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there. You may need to remove CMakeCache.txt. ")
endif()

#################################################################################

set(default_build_type "Debug")
if(NOT CMAKE_BUILD_TYPE)
    message(STATUS "Setting build type to '${default_build_type}' as none was specified.")
    set(CMAKE_BUILD_TYPE "${default_build_type}" CACHE
        STRING "Choose the type of build." FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
        "Debug" "Release")
endif()

#################################################################################

if(NOT WORKSPACE_ROOT_DIR)
    set(WORKSPACE_ROOT_DIR "../..")
endif()

#################################################################################

include(${WORKSPACE_ROOT_DIR}/lib/cmake_toppers-jsp_win32/cfg/cfg.cmake)

#################################################################################

include(${WORKSPACE_ROOT_DIR}/lib/cmake_toppers-jsp_win32/kernel/kernel.cmake)

#################################################################################

find_file(CONFIG_FILE sample2.cfg
    PATH ${TOPPERS_SAMPLE_WINDOWS_DIR}/
)

add_custom_command(
    OUTPUT  ${CMAKE_BINARY_DIR}/kernel_cfg.c ${CMAKE_BINARY_DIR}/kernel_id.h
    DEPENDS ${CMAKE_BINARY_DIR}/sample2.i
    DEPENDS cfg
    COMMAND cfg -s -c -v -obj -lj -cpu windows -system msvc <${CMAKE_BINARY_DIR}/sample2.i
)

add_executable(sample2

    ${KERNEL_SRCS}

    ${CMAKE_BINARY_DIR}/kernel_cfg.c
    ${TOPPERS_SAMPLE_WINDOWS_DIR}/sample2.c
)

target_link_libraries(sample2 winmm)

file(RELATIVE_PATH relative ${CMAKE_BINARY_DIR} ${CMAKE_SOURCE_DIR})

target_include_directories(sample2 PRIVATE
    ${TOPPERS_CONFIG_WINDOWS_DIR}
    ${TOPPERS_KERNEL_DIR}
    ${TOPPERS_LIBRARY_DIR}
    ${TOPPERS_SYSTASK_DIR}
    ${TOPPERS_SAMPLE_WINDOWS_DIR}
    ${TOPPERS_INCLUDE_DIR}
    ${CMAKE_BINARY_DIR}
)

target_sources(sample2 PRIVATE ../hal_resource.rc)

set_target_properties(sample2 PROPERTIES LINK_FLAGS "/SUBSYSTEM:WINDOWS")

target_compile_options(sample2
  PRIVATE $<$<CXX_COMPILER_ID:MSVC>:/W4 /WX->
)

set(MSVC_PREPROC_INC_OPT
    /I ${relative}${TOPPERS_CONFIG_WINDOWS_DIR}
    /I ${relative}${TOPPERS_KERNEL_DIR}
    /I ${relative}${TOPPERS_LIBRARY_DIR}
    /I ${relative}${TOPPERS_SYSTASK_DIR}
    /I ${relative}${TOPPERS_SAMPLE_WINDOWS_DIR}
    /I ${relative}${TOPPERS_INCLUDE_DIR}
    /I ${relative}${CMAKE_BINARY_DIR}
)

add_custom_command(
    OUTPUT  ${CMAKE_BINARY_DIR}/sample2.i
    DEPENDS ${CONFIG_FILE}
    COMMAND      ${CMAKE_C_COMPILER} ${CMAKE_C_COMPILER_ARG1} ${MSVC_PREPROC_INC_OPT} /P ${CONFIG_FILE}
)
