cmake_minimum_required(VERSION 3.25)
set(CMAKE_CXX_STANDARD 20)
project(webview_test LANGUAGES CXX VERSION 1.0)

include(${CMAKE_CURRENT_LIST_DIR}/cmake/webview.cmake)

add_executable(webview_test main.cpp)
target_link_libraries(webview_test PUBLIC webview)