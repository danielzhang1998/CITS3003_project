cmake_minimum_required(VERSION 3.10)
project(bitmap)

set(CMAKE_CXX_STANDARD 17)

add_library(bitmap STATIC src/bitmap.c include/bitmap.h)

target_include_directories(bitmap PUBLIC . include)