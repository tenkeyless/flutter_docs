---
# title: Run DevTools from VS Code
title: VS Code에서 DevTools 실행
# description: Learn how to launch and use DevTools from VS Code.
description: VS Code에서 DevTools를 시작하고 사용하는 방법을 알아보세요.
---

## VS Code 확장 프로그램 추가 {:#add-the-vs-code-extensions}

VS Code에서 DevTools를 사용하려면, [Dart 확장][Dart extension]이 필요합니다. 
Flutter 애플리케이션을 디버깅하는 경우, [Flutter 확장][Flutter extension]도 설치해야 합니다.

## 디버깅 할 애플리케이션 시작 {:#start-an-application-to-debug}

VS Code에서 프로젝트의 루트 폴더(`pubspec.yaml`이 포함된 폴더)를 열고, 
**Run > Start Debugging** (`F5`)을 클릭하여 애플리케이션의 디버그 세션을 시작합니다.

## DevTools 실행 {:#launch-devtools}

디버그 세션이 활성화되고 애플리케이션이 시작되면, 
**Open DevTools** 명령이 VS Code 명령 팔레트(`F1`)에서 사용 가능해집니다.

![Screenshot showing Open DevTools commands](/assets/images/docs/tools/vs-code/vscode_command.png){:width="100%"}

선택한 도구는 VS Code에 임베드되어 열립니다.

![Screenshot showing DevTools embedded in VS Code](/assets/images/docs/tools/vs-code/vscode_embedded.png){:width="100%"}

`dart.embedDevTools` 설정을 사용하여 DevTools를 항상 브라우저에서 열도록 선택할 수 있으며, 
`dart.devToolsLocation` 설정을 사용하여 전체 창으로 열지 또는 현재 편집기 옆의 새 열로 열지 제어할 수 있습니다.

Dart/Flutter 설정의 전체 리스트는 [dartcode.org](https://dartcode.org/docs/settings/) 또는 [VS Code 설정 편집기](https://code.visualstudio.com/docs/getstarted/settings#_settings-editor)에서 사용할 수 있습니다. 
VS Code에서 Dart/Flutter에 대한 몇 가지 권장 설정도 [dartcode.org](https://dartcode.org/docs/recommended-settings/)에서 찾을 수 있습니다.

또한 DevTools가 실행 중인지 확인하고, 
언어 상태 영역(상태 표시줄의 **Dart** 옆에 있는 `{}` 아이콘)에서 브라우저에서 시작할 수 있습니다.

![Screenshot showing DevTools in the VS Code language status area](/assets/images/docs/tools/vs-code/vscode_status_bar.png){:width="100%"}

[Dart extension]: https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code
[Flutter extension]: https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter
