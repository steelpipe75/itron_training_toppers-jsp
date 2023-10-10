# 動作確認できたCMakeのバージョン
cmake_minimum_required(VERSION 3.16)

#################################################################################

if(NOT WORKSPACE_ROOT_DIR)
    set(WORKSPACE_ROOT_DIR "../../..")
endif()

#################################################################################

if(NOT CFG_DIR)
    set(CFG_DIR "${WORKSPACE_ROOT_DIR}/lib/third_party/toppers-jsp-for-linux/jsp-1.4.4.1-full/cfg")
endif()

set(COMMON_CFG_SRCS

    ${CFG_DIR}/base/manager.cpp
    ${CFG_DIR}/base/directorymap.cpp
    ${CFG_DIR}/base/message.cpp
    ${CFG_DIR}/base/garbage.cpp
    ${CFG_DIR}/base/component.cpp
    ${CFG_DIR}/base/singleton.cpp
    ${CFG_DIR}/base/except.cpp
    ${CFG_DIR}/base/event.cpp
    ${CFG_DIR}/base/collection.cpp
    ${CFG_DIR}/base/option.cpp
)

#################################################################################

add_executable(cfg

    ${CFG_DIR}/base/parser.cpp
    ${CFG_DIR}/base/mpstrstream.cpp

    ${CFG_DIR}/jsp/jsp_checkscript.cpp
    ${CFG_DIR}/jsp/jsp_parser.cpp
    ${CFG_DIR}/jsp/jsp_staticapi.cpp
    ${CFG_DIR}/jsp/jsp_common.cpp

    ${COMMON_CFG_SRCS}
)

target_include_directories(cfg PRIVATE
    ${CFG_DIR}
)

target_compile_options(cfg
  PRIVATE $<$<CXX_COMPILER_ID:MSVC>:/W4 /WX- /utf-8>
  PRIVATE $<$<CXX_COMPILER_ID:Clang>:-Wall -Wextra>
  PRIVATE $<$<AND:$<CXX_COMPILER_ID:Clang>,$<CONFIG:Debug>>:-g -O0>
  PRIVATE $<$<AND:$<CXX_COMPILER_ID:Clang>,$<CONFIG:Release>>:-O3 -DNDEBUG>
)

#################################################################################

add_executable(chk

    ${CFG_DIR}/base/filecontainer.cpp
    ${CFG_DIR}/base/fc_binutils.cpp

    ${CFG_DIR}/jsp/jsp_check.cpp

    ${COMMON_CFG_SRCS}
)

target_include_directories(chk PRIVATE
    ${CFG_DIR}
)

target_compile_options(chk
  PRIVATE $<$<CXX_COMPILER_ID:MSVC>:/W4 /WX- /utf-8>
  PRIVATE $<$<CXX_COMPILER_ID:Clang>:-Wall -Wextra>
  PRIVATE $<$<AND:$<CXX_COMPILER_ID:Clang>,$<CONFIG:Debug>>:-g -O0>
  PRIVATE $<$<AND:$<CXX_COMPILER_ID:Clang>,$<CONFIG:Release>>:-O3 -DNDEBUG>
)

