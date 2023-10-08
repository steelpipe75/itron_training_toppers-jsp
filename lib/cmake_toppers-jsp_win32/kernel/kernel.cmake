# 動作確認できたCMakeのバージョン
cmake_minimum_required(VERSION 3.16)

#################################################################################

if(NOT WORKSPACE_ROOT_DIR)
    set(WORKSPACE_ROOT_DIR "../../..")
endif()

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

