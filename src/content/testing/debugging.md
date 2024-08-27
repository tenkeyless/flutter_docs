---
# title: Debug Flutter apps
title: Flutter 앱 디버깅
# description: How to debug your Flutter app.
description: Flutter 앱을 디버깅하는 방법.
---

<?code-excerpt path-base="testing/debugging"?>

Flutter 애플리케이션 디버깅을 돕는 다양한 도구와 기능이 있습니다. 
사용 가능한 도구 중 일부는 다음과 같습니다.

* [VS Code][](권장) 및 [Android Studio/IntelliJ][]
  * (Flutter 및 Dart 플러그인 사용 가능)
  * 이들은 중단점 설정, 코드 단계별 실행 및 값 검사 기능이 있는 빌트인 소스 레벨 디버거를 지원합니다.
* [DevTools][]
  * 브라우저에서 실행되는 성능 및 프로파일링 도구 모음입니다.
* [Flutter inspector][] 
  * DevTools에서 사용할 수 있고, Android Studio 및 IntelliJ에서 직접 사용할 수 있는 위젯 검사기(Flutter 플러그인 사용 가능). 
  * 이 검사기를 사용하면 위젯 트리의 시각적 표현을 검사하고, 개별 위젯과 해당 속성 값을 검사하고, 성능 오버레이를 활성화하는 등의 작업을 수행할 수 있습니다.
* GDB를 사용하여 Android 앱 프로세스 내에서 실행되는 Flutter 엔진을 원격으로 디버깅할 방법을 찾고 있다면, [`flutter_gdb`][]를 확인하세요.

[`flutter_gdb`]: {{site.repo.engine}}/blob/main/sky/tools/flutter_gdb

## 기타 리소스 {:#other-resources}

다음 문서가 유용할 수 있습니다.

* [성능 모범 사례][Performance best practices]
* [Flutter 성능 프로파일링][Flutter performance profiling]
* [네이티브 디버거 사용][Use a native debugger]
* [Flutter 모드][Flutter's modes]
* [프로그래밍 방식으로 Flutter 앱 디버깅][Debugging Flutter apps programmatically]

[Flutter enabled IDE/editor]: /get-started/editor

[Debugging Flutter apps programmatically]: /testing/code-debugging
[Flutter's modes]: /testing/build-modes
[Flutter performance profiling]: /perf/ui-performance
[Performance best practices]: /perf/best-practices
[Use a native debugger]: /testing/native-debugging

[Android Studio/IntelliJ]: /tools/android-studio#run-app-with-breakpoints
[VS Code]: /tools/vs-code#run-app-with-breakpoints
[DevTools]: /tools/devtools
[Flutter inspector]: /tools/devtools/inspector
