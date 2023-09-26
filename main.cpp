#include <filesystem>
#include <iostream>
#include <regex>

#include "webview.h"

std::string getFrontendDirectory()
{
  wchar_t rawPathName[MAX_PATH] = { 0 };
  GetModuleFileNameW(nullptr, rawPathName, MAX_PATH);
  std::string path = std::filesystem::path(rawPathName).parent_path().string();

  // If app isn't run from user installation, find real path
  if(path.find("cmake") != std::string::npos) {
    std::regex reg(R"([^\\\/]+[\\\/]?$)");
    path = std::regex_replace(path, reg, "");
  }

  path.append("frontend/index.html");

  return path;
}

int main()
{
    webview::webview view(true, nullptr);
    view.set_title("WebView and CMake Starter");
    view.set_size(480, 320, WEBVIEW_HINT_NONE);
    view.set_size(180, 120, WEBVIEW_HINT_MIN);

    view.bind("noop", [](std::string s) -> std::string {
      std::cout << s << std::endl;
      return s;
    });

    view.bind("add", [](const std::string& s) -> std::string {
      auto a = std::stoi(webview::detail::json_parse(s, "", 0));
      auto b = std::stoi(webview::detail::json_parse(s, "", 1));
      return std::to_string(a + b);
    });

    // Server static html file (or maybe a React/Vue/Svelte app)
    std::string indexPath = getFrontendDirectory();
    view.navigate("file://" + indexPath);
    view.run();

    return 0;
}