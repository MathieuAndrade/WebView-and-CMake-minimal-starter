include(FetchContent)

# Microsoft.Web.WebView2
FetchContent_Declare(
        webview-sdk
        URL  https://www.nuget.org/api/v2/package/Microsoft.Web.WebView2/1.0.2045.28
        URL_HASH SHA1=ee330b7aa6d9471d9d9cd1cd5f36bc5ba2cc8a3e
)
FetchContent_MakeAvailable(webview-sdk)
include_directories(SYSTEM "${webview-sdk_SOURCE_DIR}/build/native/include/")

FetchContent_Declare(
        webview
        GIT_REPOSITORY https://github.com/webview/webview.git
        GIT_TAG 53ea174ce79ca2f52e28dd51d49052aebce3f4c5
)
FetchContent_GetProperties(webview)

if (NOT webview_POPULATED)
    # Library does not have a CMake build script
    # We have to do it ourselves
    FetchContent_Populate(webview)
    add_library(webview INTERFACE)
    target_sources(webview INTERFACE ${webview_SOURCE_DIR}/webview.h)
    target_include_directories(webview INTERFACE ${webview_SOURCE_DIR})

    # Set compile options
    # See: https://github.com/webview/webview/blob/master/script/build.sh
    if (WIN32)
        target_compile_definitions(webview INTERFACE WEBVIEW_EDGE)
    elseif (APPLE)
        target_compile_definitions(webview INTERFACE WEBVIEW_COCOA)
        target_compile_definitions(webview INTERFACE "GUI_SOURCE_DIR=\"${CMAKE_CURRENT_SOURCE_DIR}\"")
        target_compile_options(webview INTERFACE -Wno-all -Wno-extra -Wno-pedantic -Wno-delete-non-abstract-non-virtual-dtor)
        target_link_libraries(webview INTERFACE "-framework WebKit")
    elseif (UNIX)
        target_compile_definitions(webview INTERFACE WEBVIEW_GTK)
        target_compile_options(webview INTERFACE -Wall -Wextra -Wpedantic)
        target_link_libraries(webview INTERFACE "$(pkg-config --cflags --libs gtk+-3.0 webkit2gtk-4.0)")
    endif ()
endif ()