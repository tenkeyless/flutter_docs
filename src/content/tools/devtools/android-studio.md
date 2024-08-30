---
# title: Run DevTools from Android Studio
title: Android Studio에서 DevTools 실행
# description: Learn how to launch and use DevTools from Android Studio.
description: Learn how to launch and use DevTools from Android Studio.
---

## Flutter 플러그인 설치 {:#install-the-flutter-plugin}

아직 설치하지 않았다면 Flutter 플러그인을 추가하세요. 
IntelliJ 및 Android Studio 설정의 일반 **Plugins** 페이지를 사용하여 수행할 수 있습니다. 
해당 페이지가 열리면 마켓플레이스에서 Flutter 플러그인을 검색할 수 있습니다.

## 디버깅 할 앱 시작 {:#start-an-app-to-debug}

DevTools를 열려면, 먼저 Flutter 앱을 실행해야 합니다. 
Flutter 프로젝트를 열고, 기기가 연결되어 있는지 확인하고, 
**Run** 또는 **Debug** 툴바 버튼을 클릭하면 됩니다.

## 툴바/메뉴에서 DevTools 실행 {:#launch-devtools-from-the-toolbarmenu}

앱이 실행되면, 다음 기술 중 하나를 사용하여 DevTools를 시작할 수 있습니다.

* Run 뷰에서 **Open DevTools** 툴바 작업을 선택합니다.
* Debug 뷰에서 **Open DevTools** 툴바 작업을 선택합니다. (디버깅하는 경우)
* Flutter Inspector 뷰의 **More Actions** 메뉴에서 **Open DevTools** 작업을 선택합니다.

![screenshot of Open DevTools button](/assets/images/docs/tools/devtools/android_studio_open_devtools.png){:width="100%"}

## Action에서 DevTools 실행 {:#launch-devtools-from-an-action}

IntelliJ 작업에서 DevTools를 열 수도 있습니다. 
**Find Action...** 대화 상자를 열고(macOS에서는 <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>A</kbd>를 누름) **Open DevTools** 작업을 검색합니다. 
해당 작업을 선택하면 DevTools 서버가 시작되고 DevTools 앱을 가리키는 브라우저 인스턴스가 열립니다.

IntelliJ 작업으로 열면 DevTools가 Flutter 앱에 연결되지 않습니다. 
현재 실행 중인 앱에 대한 서비스 프로토콜 포트를 제공해야 합니다. 
인라인 **Connect to a running app** 대화 상자를 사용하여 이 작업을 수행할 수 있습니다.
