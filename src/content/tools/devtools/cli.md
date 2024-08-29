---
# title: Run DevTools from the command line
title: 명령줄에서 DevTools 실행
# description: Learn how to launch and use DevTools from the command line.
description: 명령줄에서 DevTools를 시작하고 사용하는 방법을 알아보세요.
---

CLI에서 DevTools를 실행하려면, 경로에 `dart`가 있어야 합니다. 
그런 다음 DevTools를 시작하려면, `dart devtools` 명령을 실행합니다.

DevTools를 업그레이드하려면, Flutter를 업그레이드합니다. 
최신 Dart SDK(Flutter SDK에 포함됨)에 최신 버전의 DevTools가 포함된 경우, 
`dart devtools`를 실행하면 이 버전이 자동으로 시작됩니다. 
`which dart`가 Flutter SDK에 포함되지 않은 Dart SDK를 가리키는 경우, 
해당 Dart SDK를 업데이트해도 Flutter 버전은 업데이트되지 않습니다.

명령줄에서 DevTools를 실행하면, 다음과 같은 출력이 표시됩니다.

```plaintext
Serving DevTools at http://127.0.0.1:9100
```

## 디버깅 할 애플리케이션 시작 {:#start-an-application-to-debug}

다음으로, 연결할 앱을 시작합니다. 
이는 Flutter 애플리케이션 또는 Dart 명령줄 애플리케이션일 수 있습니다. 
아래 명령은 Flutter 앱을 지정합니다.

```console
cd path/to/flutter/app
flutter run
```

`flutter run`이 작동하려면 기기를 연결하거나 시뮬레이터를 열어야 합니다. 
앱이 시작되면 터미널에 다음과 같은 메시지가 표시됩니다.

```console
An Observatory debugger and profiler on macOS is available at:
http://127.0.0.1:52129/QjqebSY4lQ8=/
The Flutter DevTools debugger and profiler on macOS is available at:
http://127.0.0.1:9100?uri=http://127.0.0.1:52129/QjqebSY4lQ8=/
```

Chrome에서 두 번째 링크를 열어, 앱에 연결된 DevTools 인스턴스를 엽니다.

이 URL에는 보안 토큰이 포함되어 있으므로, 앱을 실행할 때마다 다릅니다. 
즉, 애플리케이션을 중지하고 다시 실행하면 새 URL로 DevTools에 다시 연결해야 합니다.

## 새 앱 인스턴스에 연결 {:#connect-to-a-new-app-instance}

앱 실행이 중지되거나 DevTools를 수동으로 연 경우, **Connect** 대화 상자가 표시됩니다.


![Screenshot of the DevTools connect dialog](/assets/images/docs/tools/devtools/connect_dialog.png){:width="100%"}

앱을 실행하여 얻은 Observatory 링크(예: `http://127.0.0.1:52129/QjqebSY4lQ8=/`)를 복사하여, 
연결 대화 상자에 붙여넣으면 DevTools를 새 앱 인스턴스에 수동으로 연결할 수 있습니다.