# 動作確認できたCMakeのバージョン
cmake_minimum_required(VERSION 3.16)

# project情報
project(toppers_sample
    DESCRIPTION "TOPPERS sample win32"
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
    set(WORKSPACE_ROOT_DIR "..")
endif()

#################################################################################

include(${WORKSPACE_ROOT_DIR}/lib/cmake_toppers-jsp_win32/cfg/cfg.cmake)

#################################################################################

set(TOPPERS_DIR                 "${WORKSPACE_ROOT_DIR}/lib/third_party/toppers-jsp-for-msvc/jsp-1.4.4.1-full")
set(TOPPERS_CONFIG_WINDOWS_DIR  "${TOPPERS_DIR}/config/windows")
set(TOPPERS_KERNEL_DIR          "${TOPPERS_DIR}/kernel")
set(TOPPERS_LIBRARY_DIR         "${TOPPERS_DIR}/library")
set(TOPPERS_SYSTASK_DIR         "${TOPPERS_DIR}/systask")
set(TOPPERS_SAMPLE_WINDOWS_DIR  "${TOPPERS_DIR}/tools/WINDOWS")
set(TOPPERS_INCLUDE_DIR         "${TOPPERS_DIR}/include")

set(KERNEL_SRCS ${KERNEL_SRCS}

    ${TOPPERS_CONFIG_WINDOWS_DIR}/com_support.cpp
    ${TOPPERS_CONFIG_WINDOWS_DIR}/cpu_config.c
    ${TOPPERS_CONFIG_WINDOWS_DIR}/cpu_defs.c
    ${TOPPERS_CONFIG_WINDOWS_DIR}/debugout.c
    ${TOPPERS_CONFIG_WINDOWS_DIR}/eventlog.c
    ${TOPPERS_CONFIG_WINDOWS_DIR}/hw_serial.c
    ${TOPPERS_CONFIG_WINDOWS_DIR}/hw_timer.c
    ${TOPPERS_CONFIG_WINDOWS_DIR}/primary_thread.c
    ${TOPPERS_CONFIG_WINDOWS_DIR}/sys_config.c

    ${TOPPERS_KERNEL_DIR}/banner.c
    ${TOPPERS_KERNEL_DIR}/cyclic.c
    ${TOPPERS_KERNEL_DIR}/dataqueue.c
    ${TOPPERS_KERNEL_DIR}/eventflag.c
    ${TOPPERS_KERNEL_DIR}/exception.c
    ${TOPPERS_KERNEL_DIR}/interrupt.c
    ${TOPPERS_KERNEL_DIR}/mailbox.c
    ${TOPPERS_KERNEL_DIR}/mempfix.c
    ${TOPPERS_KERNEL_DIR}/semaphore.c
    ${TOPPERS_KERNEL_DIR}/startup.c
    ${TOPPERS_KERNEL_DIR}/syslog.c
    ${TOPPERS_KERNEL_DIR}/sys_manage.c
    ${TOPPERS_KERNEL_DIR}/task.c
    ${TOPPERS_KERNEL_DIR}/task_except.c
    ${TOPPERS_KERNEL_DIR}/task_manage.c
    ${TOPPERS_KERNEL_DIR}/task_sync.c
    ${TOPPERS_KERNEL_DIR}/time_event.c
    ${TOPPERS_KERNEL_DIR}/time_manage.c
    ${TOPPERS_KERNEL_DIR}/wait.c

    ${TOPPERS_LIBRARY_DIR}/log_output.c
    ${TOPPERS_LIBRARY_DIR}/strerror.c
    ${TOPPERS_LIBRARY_DIR}/t_perror.c
    ${TOPPERS_LIBRARY_DIR}/vasyslog.c

    ${TOPPERS_SYSTASK_DIR}/logtask.c
    ${TOPPERS_SYSTASK_DIR}/serial.c
    ${TOPPERS_SYSTASK_DIR}/timer.c
)

#################################################################################

find_file(CONFIG_FILE sample1.cfg
    PATH ${TOPPERS_SAMPLE_WINDOWS_DIR}/
)

if(MSVC)
    add_custom_command(
        OUTPUT  ${CMAKE_BINARY_DIR}/sample1.i
        DEPENDS ${CONFIG_FILE}
        COMMAND ${CMAKE_C_COMPILER} ${CMAKE_C_COMPILER_ARG1} /P ${CONFIG_FILE}
    )
else()
    add_custom_command(
        OUTPUT  ${CMAKE_BINARY_DIR}/sample1.i
        DEPENDS ${CONFIG_FILE}
        COMMAND ${CMAKE_C_COMPILER} ${CMAKE_C_COMPILER_ARG1} -E -x c -o sample1.i ${CONFIG_FILE}
    )
endif()


add_custom_command(
    OUTPUT  ${CMAKE_BINARY_DIR}/kernel_cfg.c ${CMAKE_BINARY_DIR}/kernel_id.h
    DEPENDS ${CMAKE_BINARY_DIR}/sample1.i
    DEPENDS cfg
    COMMAND cfg -s -c -v -obj -lj -cpu windows -system msvc <${CMAKE_BINARY_DIR}/sample1.i
)

add_executable(sample1

    ${KERNEL_SRCS}

    ${TOPPERS_SAMPLE_WINDOWS_DIR}/kernel_cfg.c
    ${TOPPERS_SAMPLE_WINDOWS_DIR}/sample1.c
)

target_link_libraries(sample1 winmm)

target_include_directories(sample1 PRIVATE
    ${TOPPERS_CONFIG_WINDOWS_DIR}
    ${TOPPERS_KERNEL_DIR}
    ${TOPPERS_LIBRARY_DIR}
    ${TOPPERS_SYSTASK_DIR}
    ${TOPPERS_SAMPLE_WINDOWS_DIR}
    ${TOPPERS_INCLUDE_DIR}
)

target_sources(sample1 PRIVATE ${TOPPERS_CONFIG_WINDOWS_DIR}/hal_resource.rc)

set_target_properties(sample1 PROPERTIES LINK_FLAGS "/SUBSYSTEM:WINDOWS")

target_compile_options(sample1
  PRIVATE $<$<CXX_COMPILER_ID:MSVC>:/W4 /WX->
  PRIVATE $<$<CXX_COMPILER_ID:Clang>:-Wall -Wextra>
  PRIVATE $<$<AND:$<CXX_COMPILER_ID:Clang>,$<CONFIG:Debug>>:-g -O0>
  PRIVATE $<$<AND:$<CXX_COMPILER_ID:Clang>,$<CONFIG:Release>>:-O3 -DNDEBUG>
)

