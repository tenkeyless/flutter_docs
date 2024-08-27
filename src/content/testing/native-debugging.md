---
# title: Use a native language debugger
title: 네이티브 언어 디버거 사용
# short-title: debuggers
short-title: 디버거
# description: How to connect a native debugger to your running Flutter app.
description: 실행 중인 Flutter 앱에 네이티브 디버거를 연결하는 방법.
---

<?code-excerpt path-base="testing/native_debugging"?>

:::note
이 가이드를 이해하려면 일반적인 디버깅을 이해하고, Flutter와 git을 설치했으며, 
Dart 언어와 Java, Kotlin, Swift 또는 Objective-C 중 하나에 익숙해야 합니다.
:::

Dart 코드로만 Flutter 앱을 작성하는 경우, IDE의 디버거를 사용하여 코드를 디버깅할 수 있습니다. Flutter 팀은 VS Code를 권장합니다.

플랫폼별 플러그인을 작성하거나, 플랫폼별 라이브러리를 사용하는 경우, 네이티브 디버거로 해당 코드 부분을 디버깅할 수 있습니다.

- Swift 또는 Objective-C로 작성된 iOS 또는 macOS 코드를 디버깅하려면, Xcode를 사용할 수 있습니다.
- Java 또는 Kotlin으로 작성된 Android 코드를 디버깅하려면, Android Studio를 사용할 수 있습니다.
- C++로 작성된 Windows 코드를 디버깅하려면, Visual Studio를 사용할 수 있습니다.

이 가이드에서는 Dart 앱에 _두 개_ 의 디버거를 연결하는 방법을 보여줍니다. 
하나는 Dart용이고, 다른 하나는 네이티브 코드용입니다.

## Dart 코드 디버그 {:#debug-dart-code}

이 가이드에서는 VS Code를 사용하여 Flutter 앱을 디버깅하는 방법을 설명합니다. 
Flutter 및 Dart 플러그인이 설치 및 구성된 선호하는 IDE를 사용할 수도 있습니다.

## VS Code를 사용하여 Dart 코드 디버그 {:#debug-dart-code-using-vs-code}

다음 절차에서는 기본 샘플 Flutter 앱에서 Dart 디버거를 사용하는 방법을 설명합니다. 
VS Code의 추천 구성 요소는 작동하며, Flutter 프로젝트를 디버깅할 때도 나타납니다.

1. 기본 Flutter 앱을 만듭니다.

    ```console
    $ flutter create my_app
    ```

    ```console
    Creating project my_app...
    Resolving dependencies in my_app... 
    Got dependencies in my_app.
    Wrote 129 files.

    All done!
    You can find general documentation for Flutter at: https://docs.flutter.dev/
    Detailed API documentation is available at: https://api.flutter.dev/
    If you prefer video documentation, consider: https://www.youtube.com/c/flutterdev

    In order to run your application, type:

      $ cd my_app
      $ flutter run

    Your application code is in my_app/lib/main.dart.
    ```

    ```console
    $ cd my_app
    ```

2. VS Code를 사용하여 Flutter 앱에서 `lib\main.dart` 파일을 엽니다.

3. 버그 아이콘(![Flutter 앱의 디버깅 모드를 트리거하는 VS Code의 버그 아이콘](/assets/images/docs/testing/debugging/vscode-ui/icons/debug.png))을 클릭합니다. 
   그러면 VS Code에서 다음 창이 열립니다.

   - **Debug (디버그)**
   - **Debug Console (디버그 콘솔)**
   - **Widget Inspector (위젯 검사기)**

   디버거를 처음 실행할 때 가장 오래 걸립니다.

{% comment %}
   ![VS Code window with debug panes opened](/assets/images/docs/testing/debugging/vscode-ui/screens/vscode-debugger.png){:width="100%"}
{% endcomment %}

1. 디버거를 테스트합니다.

   a. `main.dart`에서, 이 줄을 클릭합니다. 

      ```dart
      _counter++;
      ```

   b. <kbd>Shift</kbd> + <kbd>F9</kbd>를 누릅니다. 이렇게 하면 `_counter` 변수가 증가하는 곳에 중단점이 추가됩니다.

   c. 앱에서, **+** 버튼을 클릭하여 카운터를 증가시킵니다. 앱이 일시 중지됩니다.

{% comment %}
      ![Flutter test app paused](/assets/images/docs/testing/debugging/native/macos/basic-app.png){:width="50%"}
      <div class="figure-caption">

      Default Flutter app as rendered on macOS.

      </div>
{% endcomment %}

   d. 이 시점에서, VS Code는 다음을 표시합니다.

      - **편집기 그룹(Editor Groups)** 에서:
        - `main.dart`의 강조 표시된 중단점
        - **위젯 검사기(Widget Inspector)** 의 **위젯 트리(Widget Tree)** 에 있는 Flutter 앱의 위젯 계층 구조
      - **사이드 바**에서:
        - **호출 스택(Call Stack)** 섹션의 앱 상태
        - **변수(Variables)** 섹션의 `this` 로컬 변수 값
      - **패널**에서:
        - **디버그 콘솔**의 Flutter 앱 로그

{% comment %}
      ![VS Code window with Flutter app paused](/assets/images/docs/testing/debugging/vscode-ui/screens/vscode-debugger-paused.png){:width="100%"}
{% endcomment %}

### VS Code Flutter 디버거 {:#vs-code-flutter-debugger}

VS Code용 Flutter 플러그인은 VS Code 사용자 인터페이스에 여러 구성 요소를 추가합니다.

#### VS Code 인터페이스 변경 사항 {:#changes-to-vs-code-interface}

Flutter 디버거가 실행되면, VS 코드 인터페이스에 디버깅 도구를 추가합니다.

다음 스크린샷과 표는 각 도구의 목적을 설명합니다.

![VS Code with the Flutter plugin UI additions](/assets/images/docs/testing/debugging/vscode-ui/screens/debugger-parts.png)

| 스크린샷의 하이라이트 색상 | Bar, Panel 또는 Tab  | 내용                                                                          |
|-------------------------------|---------------------|-----------------------------------------------------------------------------------|
| **Yellow**                    | Variables           | Flutter 앱의 변수의 현재 값 리스트                            |
|                               | Watch               | Flutter 앱에서 추적하도록 선택한 아이템 리스트     |
|                               | Call Stack          | Flutter 앱의 활성 서브루틴 스택                                    |
|                               | Breakpoints         | 설정한 예외 및 중단점 리스트                   |
| **Green**                     | `<Flutter files>`   | 편집 중인 파일  |
| **Pink**                      | Widget Inspector    | 실행 중인 Flutter 앱의 위젯 계층 구조                    |
| **Blue**                      | Layout Explorer     | 위젯 검사기에서 선택한 위젯을 Flutter가 배치한 방식을 시각적으로 보여줍니다.  |
|                               | Widget Details Tree | 위젯 검사기에서 선택된 위젯의 속성 리스트      |
| **Orange**                    | Problems            | Dart 분석기가 현재 Dart 파일에서 발견한 문제 리스트            |
|                               | Output              | Flutter 앱을 빌드할 때 반환되는 응답            |
|                               | Debug Console       | 디버깅하는 동안 Flutter 앱이 생성하는 로그 또는 오류 메시지    |
|                               | Terminal            | VS Code에 포함된 시스템 셸 프롬프트           |

{:.table .table-striped}

VS Code에서 패널(**주황색**)이 나타나는 위치를 변경하려면, 
**View** > **모Appearance양** > **Panel Position**로 이동합니다.

#### VS Code Flutter 디버깅 툴바 {:#vs-code-flutter-debugging-toolbar}

툴바를 사용하면 어떤 디버거를 사용하든, 디버깅할 수 있습니다. 
Dart 문장을 step in, out, over하고, 핫 리로드하거나 앱을 재개할 수 있습니다.

![Flutter debugger toolbar in VS Code](/assets/images/docs/testing/debugging/vscode-ui/screens/debug-toolbar.png)

| 아이콘                                                | 액션                | 디폴트 키보드 단축키                             |
|-----------------------------------------------------|-----------------------|-------------------------------------------------------|
| {% render docs/vscode-flutter-bar/play.md %}        | 시작 또는 재개       | <kbd>F5</kbd>                                         |
| {% render docs/vscode-flutter-bar/pause.md %}       | 일시 정지                 | <kbd>F6</kbd>                                         |
| {% render docs/vscode-flutter-bar/step-over.md %}   | Step Over             | <kbd>F10</kbd>                                        |
| {% render docs/vscode-flutter-bar/step-into.md %}   | Step Into             | <kbd>F11</kbd>                                        |
| {% render docs/vscode-flutter-bar/step-out.md %}    | Step Out              | <kbd>Shift</kbd> + <kbd>F11</kbd>                     |
| {% render docs/vscode-flutter-bar/hot-reload.md %}  | 핫 리로드            | <kbd>Ctrl</kbd> + <kbd>F5</kbd>                       |
| {% render docs/vscode-flutter-bar/hot-restart.md %} | 핫 재시작           | <kbd>Shift</kbd> + <kbd>Special</kbd> + <kbd>F5</kbd> |
| {% render docs/vscode-flutter-bar/stop.md %}        | 멈추기                  | <kbd>Shift</kbd> + <kbd>F5</kbd>                      |
| {% render docs/vscode-flutter-bar/inspector.md %}   | 위젯 검사기 열기 |                        |

{:.table .table-striped}

## Flutter 앱 테스트 업데이트 {:#update-test-flutter-app}

이 가이드의 나머지 부분에서는, 테스트 Flutter 앱을 업데이트해야 합니다. 
이 업데이트는 디버깅을 위한 네이티브 코드를 추가합니다.

1. 선호하는 IDE를 사용하여 `lib/main.dart` 파일을 엽니다.

1. `main.dart`의 내용을 다음 코드로 바꿉니다.

    <details>
    <summary>이 예제의 Flutter 코드를 보려면 확장하세요.</summary>

    ```dart title="lib/main.dart"
    // Copyright 2023 The Flutter Authors. All rights reserved.
    // Use of this source code is governed by a BSD-style license that can be
    // found in the LICENSE file.

    import 'package:flutter/material.dart';
    import 'package:url_launcher/url_launcher.dart';

    void main() {
      runApp(const MyApp());
    }

    class MyApp extends StatelessWidget {
      const MyApp({super.key});

      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'URL Launcher',
          theme: ThemeData(
            colorSchemeSeed: Colors.purple,
            brightness: Brightness.light,
          ),
          home: const MyHomePage(title: 'URL Launcher'),
        );
      }
    }

    class MyHomePage extends StatefulWidget {
      const MyHomePage({super.key, required this.title});
      final String title;

      @override
      State<MyHomePage> createState() => _MyHomePageState();
    }

    class _MyHomePageState extends State<MyHomePage> {
      Future<void>? _launched;

      Future<void> _launchInBrowser(Uri url) async {
        if (!await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        )) {
          throw Exception('Could not launch $url');
        }
      }

      Future<void> _launchInWebView(Uri url) async {
        if (!await launchUrl(
          url,
          mode: LaunchMode.inAppWebView,
        )) {
          throw Exception('Could not launch $url');
        }
      }

      Widget _launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const Text('');
        }
      }

      @override
      Widget build(BuildContext context) {
        final Uri toLaunch = Uri(
            scheme: 'https',
            host: 'docs.flutter.dev',
            path: 'testing/native-debugging');
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(toLaunch.toString()),
                ),
                FilledButton(
                  onPressed: () => setState(() {
                    _launched = _launchInBrowser(toLaunch);
                  }),
                  child: const Text('Launch in browser'),
                ),
                const Padding(padding: EdgeInsets.all(16)),
                FilledButton(
                  onPressed: () => setState(() {
                    _launched = _launchInWebView(toLaunch);
                  }),
                  child: const Text('Launch in app'),
                ),
                const Padding(padding: EdgeInsets.all(16.0)),
                FutureBuilder<void>(future: _launched, builder: _launchStatus),
              ],
            ),
          ),
        );
      }
    }
    ```

    </details>

2. `url_launcher` 패키지를 종속성으로 추가하려면, `flutter pub add`를 실행하세요.

    ```console
    $ flutter pub add url_launcher
    ```

    ```console
    Resolving dependencies... 
      collection 1.17.1 (1.17.2 available)
    + flutter_web_plugins 0.0.0 from sdk flutter
      matcher 0.12.15 (0.12.16 available)
      material_color_utilities 0.2.0 (0.8.0 available)
    + plugin_platform_interface 2.1.4
      source_span 1.9.1 (1.10.0 available)
      stream_channel 2.1.1 (2.1.2 available)
      test_api 0.5.1 (0.6.1 available)
    + url_launcher 6.1.11
    + url_launcher_android 6.0.36
    + url_launcher_ios 6.1.4
    + url_launcher_linux 3.0.5
    + url_launcher_macos 3.0.5
    + url_launcher_platform_interface 2.1.3
    + url_launcher_web 2.0.17
    + url_launcher_windows 3.0.6
    Changed 10 dependencies!
    ```

3. 코드베이스에서 어떤 변경이 이루어졌는지 확인하려면:

   {: type="a"}
   1. Linux 또는 macOS에서는, 이 `find` 명령을 실행합니다.

      ```console
      $ find ./ -mmin -120 
      ```

      ```console
      ./ios/Flutter/Debug.xcconfig
      ./ios/Flutter/Release.xcconfig
      ./linux/flutter/generated_plugin_registrant.cc
      ./linux/flutter/generated_plugins.cmake
      ./macos/Flutter/Flutter-Debug.xcconfig
      ./macos/Flutter/Flutter-Release.xcconfig
      ./macos/Flutter/GeneratedPluginRegistrant.swift
      ./pubspec.lock
      ./pubspec.yaml
      ./windows/flutter/generated_plugin_registrant.cc
      ./windows/flutter/generated_plugins.cmake
      ```
   2. Windows의 경우, 명령 프롬프트에서 이 명령을 실행합니다.

      ```powershell
      Get-ChildItem C:\dev\example\ -Rescurse | Where-Object {$_.LastWriteTime -gt (Get-Date).AddDays(-1)}
      ```

      ```powershell
      C:\dev\example\ios\Flutter\


      Mode                LastWriteTime         Length Name
      ----                -------------         ------ ----
                      8/1/2025   9:15 AM                Debug.xcconfig
                      8/1/2025   9:15 AM                Release.xcconfig

      C:\dev\example\linux\flutter\


      Mode                LastWriteTime         Length Name
      ----                -------------         ------ ----
                      8/1/2025   9:15 AM                generated_plugin_registrant.cc
                      8/1/2025   9:15 AM                generated_plugins.cmake

      C:\dev\example\macos\Flutter\


      Mode                LastWriteTime         Length Name
      ----                -------------         ------ ----
                      8/1/2025   9:15 AM                Flutter-Debug.xcconfig
                      8/1/2025   9:15 AM                Flutter-Release.xcconfig
                      8/1/2025   9:15 AM                GeneratedPluginRegistrant.swift

      C:\dev\example\


      Mode                LastWriteTime         Length Name
      ----                -------------         ------ ----
                      8/1/2025   9:15 AM                pubspec.lock
                      8/1/2025   9:15 AM                pubspec.yaml

      C:\dev\example\windows\flutter\


      Mode                LastWriteTime         Length Name
      ----                -------------         ------ ----
                      8/1/2025   9:15 AM                generated_plugin_registrant.cc
                      8/1/2025   9:15 AM                generated_plugins.cmake
      ```

`url_launcher`를 설치하면, Flutter 앱 디렉토리의 모든 대상 플랫폼에 대한 구성 파일과 코드 파일이 추가됩니다.

## 동시에 Dart와 네이티브 언어 코드 디버깅 {:#debug-dart-and-native-language-code-at-the-same-time}

이 섹션에서는 Flutter 앱의 Dart 코드와 모든 네이티브 코드를 일반 디버거로 디버깅하는 방법을 설명합니다. 
이 기능을 사용하면 네이티브 코드를 편집할 때, Flutter의 핫 리로드를 활용할 수 있습니다.

### Android Studio를 사용하여 Dart 및 Android 코드 디버그 {:#debug-dart-and-android-code-using-android-studio}

네이티브 Android 코드를 디버깅하려면, Android 코드가 포함된 Flutter 앱이 필요합니다. 
이 섹션에서는, Dart, Java 및 Kotlin 디버거를 앱에 연결하는 방법을 알아봅니다. 
Dart와 Android 코드를 모두 디버깅하는 데 VS Code가 필요하지 않습니다. 
이 가이드에는 Xcode 및 Visual Studio 가이드와 일관성을 유지하기 위한 VS Code 지침이 포함되어 있습니다.

이 섹션에서는 [테스트 Flutter 앱 업데이트](#update-test-flutter-app)에서 만든 동일한, 
예제 Flutter `url_launcher` 앱을 사용합니다.

{% include docs/debug/debug-flow-android.md %}

### Xcode를 사용하여 Dart 및 iOS 코드 디버그 {:#debug-dart-and-ios-code-using-xcode}

iOS 코드를 디버깅하려면, iOS 코드가 포함된 Flutter 앱이 필요합니다. 
이 섹션에서는, 앱에 두 개의 디버거를 연결하는 방법을 알아봅니다. 
VS Code와 Xcode를 통한 Flutter입니다. 
VS Code와 Xcode를 모두 실행해야 합니다.

이 섹션에서는 [테스트 Flutter 앱 업데이트](#update-test-flutter-app)에서 만든 동일한 예제 Flutter `url_launcher` 앱을 사용합니다.

{% include docs/debug/debug-flow-ios.md %}

### Xcode를 사용하여 Dart 및 macOS 코드 디버그 {:#debug-dart-and-macos-code-using-xcode}

macOS 코드를 디버깅하려면, macOS 코드가 포함된 Flutter 앱이 필요합니다. 
이 섹션에서는, 앱에 두 개의 디버거를 연결하는 방법을 알아봅니다. 
VS Code와 Xcode를 통한 Flutter입니다. 
VS Code와 Xcode를 모두 실행해야 합니다.

이 섹션에서는 [Update test Flutter app](#update-test-flutter-app)에서 만든 동일한 예제 Flutter `url_launcher` 앱을 사용합니다.

{% include docs/debug/debug-flow-macos.md %}

### Visual Studio를 사용하여 Dart 및 C++ 코드 디버그 {:#debug-dart-and-c-code-using-visual-studio}

C++ 코드를 디버깅하려면, C++ 코드가 포함된 Flutter 앱이 필요합니다. 
이 섹션에서는, VS Code와 Visual Studio를 통한 Flutter라는 두 개의 디버거를 앱에 연결하는 방법을 알아봅니다. 
VS Code와 Visual Studio를 모두 실행해야 합니다.

이 섹션에서는 [Update test Flutter app](#update-test-flutter-app)에서 만든 동일한 예제 Flutter `url_launcher` 앱을 사용합니다.

{% include docs/debug/debug-flow-windows.md %}

## 리소스 {:#resources}

Flutter, iOS, Android, macOS 및 Windows 디버깅에 대한 다음 리소스를 확인하세요.

### Flutter {:#flutter}

- [Flutter 앱 디버깅][Debugging Flutter apps]
- [Flutter 검사기][Flutter inspector] 및 [DevTools][] 문서
- [성능 프로파일링][Performance profiling]

[Debugging Flutter apps]: /testing/debugging
[Performance profiling]: /perf/ui-performance

### Android {:#android}

다음 디버깅 리소스는 [developer.android.com][]에서 찾을 수 있습니다.

- [앱 디버깅][Debug your app]
- [Android 디버그 브리지(adb)][Android Debug Bridge (adb)]

### iOS 및 macOS {:#ios-and-macos}

다음 디버깅 리소스는 [developer.apple.com][]에서 찾을 수 있습니다.

- [디버깅][Debugging]
- [Instruments 도움말][Instruments Help]

### Windows {:#windows}

[Microsoft Learn][]에서 디버깅 리소스를 찾을 수 있습니다.

- [Visual Studio Debugger][Visual Studio Debugger]
- [Visual Studio를 사용하여 C++ 코드 디버깅 방법 알아보기][Learn to debug C++ code using Visual Studio]

[Android Debug Bridge (adb)]: {{site.android-dev}}/studio/command-line/adb
[Debug your app]: {{site.android-dev}}/studio/debug
[Debugging]: {{site.apple-dev}}/support/debugging/
[developer.android.com]: {{site.android-dev}}
[developer.apple.com]: {{site.apple-dev}}
[DevTools]: /tools/devtools
[Flutter inspector]: /tools/devtools/inspector
[Instruments Help]: https://help.apple.com/instruments/mac/current/
[Microsoft Learn]: https://learn.microsoft.com/visualstudio/
[Visual Studio Debugger]: https://learn.microsoft.com/visualstudio/debugger/?view=vs-2022
[Learn to debug C++ code using Visual Studio]: https://learn.microsoft.com/visualstudio/debugger/getting-started-with-the-debugger-cpp?view=vs-2022
