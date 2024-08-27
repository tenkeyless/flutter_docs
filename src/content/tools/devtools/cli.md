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

Next, start an app to connect to.
This can be either a Flutter application
or a Dart command-line application.
The command below specifies a Flutter app:

```console
cd path/to/flutter/app
flutter run
```

You need to have a device connected, or a simulator open,
for `flutter run` to work. Once the app starts, you'll see a
message in your terminal that looks like the following:

```console
An Observatory debugger and profiler on macOS is available at:
http://127.0.0.1:52129/QjqebSY4lQ8=/
The Flutter DevTools debugger and profiler on macOS is available at:
http://127.0.0.1:9100?uri=http://127.0.0.1:52129/QjqebSY4lQ8=/
```

Open the DevTools instance connected to your app
by opening the second link in Chrome.

This URL contains a security token, 
so it's different for each run of your app. 
This means that if you stop your application and re-run it, 
you need to connect to DevTools again with the new URL.

## 새 앱 인스턴스에 연결 {:#connect-to-a-new-app-instance}

If your app stops running
or you opened DevTools manually,
you should see a **Connect** dialog:

![Screenshot of the DevTools connect dialog](/assets/images/docs/tools/devtools/connect_dialog.png){:width="100%"}

You can manually connect DevTools to a new app instance
by copying the Observatory link you got from running your app,
such as `http://127.0.0.1:52129/QjqebSY4lQ8=/`
and pasting it into the connect dialog:
