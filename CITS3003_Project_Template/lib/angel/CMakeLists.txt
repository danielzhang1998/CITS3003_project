cmake_minimum_required(VERSION 3.10)
project(angel)

set(CMAKE_CXX_STANDARD 17)

add_library(angel STATIC src/InitShader.cpp include/Angel.h include/mat.h include/vec.h include/CheckError.h)

target_include_directories(angel PUBLIC include)