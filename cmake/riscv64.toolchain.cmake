# Copyright (c) 2024 SiFive, Inc. All rights reserved.
# Copyright (c) 2024, Phoebe Chen <phoebe.chen@sifive.com>
# Licensed under the MIT License.

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR riscv64)

list(APPEND CMAKE_TRY_COMPILE_PLATFORM_VARIABLES RISCV_TOOLCHAIN_ROOT)

if(NOT RISCV_TOOLCHAIN_ROOT)
  message(FATAL_ERROR "RISCV_TOOLCHAIN_ROOT is not defined. Please set the RISCV_TOOLCHAIN_ROOT variable.")
endif()

set(CMAKE_C_COMPILER "${RISCV_TOOLCHAIN_ROOT}/bin/riscv64-unknown-linux-gnu-gcc")
set(CMAKE_ASM_COMPILER "${RISCV_TOOLCHAIN_ROOT}/bin/riscv64-unknown-linux-gnu-gcc")
set(CMAKE_CXX_COMPILER "${RISCV_TOOLCHAIN_ROOT}/bin/riscv64-unknown-linux-gnu-g++")

set(CMAKE_FIND_ROOT_PATH ${RISCV_TOOLCHAIN_ROOT})
set(CMAKE_SYSROOT "${RISCV_TOOLCHAIN_ROOT}/sysroot")
set(CMAKE_INCLUDE_PATH "${RISCV_TOOLCHAIN_ROOT}/sysroot/usr/include/")
set(CMAKE_LIBRARY_PATH "${RISCV_TOOLCHAIN_ROOT}/sysroot/usr/lib/")
set(CMAKE_PROGRAM_PATH "${RISCV_TOOLCHAIN_ROOT}/sysroot/usr/bin/")

set(onnxruntime_RISCV_VPU "none" CACHE STRING "Select RISC-V VPU mode (none, vlen128, vlen256)")
set_property(CACHE onnxruntime_RISCV_VPU PROPERTY STRINGS "none" "vlen128" "vlen256")

message(STATUS "onnxruntime_RISCV_VPU = ${onnxruntime_RISCV_VPU}")

if(onnxruntime_RISCV_VPU STREQUAL "vlen128")
  add_compile_options(-march=rv64gcv_zvl128b -mabi=lp64d -mrvv-vector-bits=zvl)
  add_link_options(-march=rv64gcv_zvl128b -mabi=lp64d -mrvv-vector-bits=zvl)
elseif(onnxruntime_RISCV_VPU STREQUAL "vlen256")
  add_compile_options(-march=rv64gcv_zvl256b -mabi=lp64d -mrvv-vector-bits=zvl)
  add_link_options(-march=rv64gcv_zvl256b -mabi=lp64d -mrvv-vector-bits=zvl)
else()
  add_compile_options(-march=rv64gc -mabi=lp64d)
  add_link_options(-march=rv64gc -mabi=lp64d)
endif()

if(RISCV_QEMU_PATH)
  message(STATUS "RISCV_QEMU_PATH=${RISCV_QEMU_PATH} is defined during compilation.")
  set(CMAKE_CROSSCOMPILING_EMULATOR "${RISCV_QEMU_PATH};-L;${CMAKE_SYSROOT}")
endif()

set(CMAKE_CROSSCOMPILING TRUE)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

