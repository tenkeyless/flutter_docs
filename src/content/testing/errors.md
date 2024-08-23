---
# title: Handling errors in Flutter
title: Flutter에서 오류 처리
# description: How to control error messages and logging of errors
description: 오류 메시지 및 오류 로깅을 제어하는 ​​방법
---

<?code-excerpt path-base="testing/errors"?>

Flutter 프레임워크는 빌드, 레이아웃 및 페인트 단계에서 발생한 오류를 포함하여, 
프레임워크 자체에서 트리거한 콜백 중에 발생하는 오류를 포착합니다. 
Flutter의 콜백 내에서 발생하지 않는 오류는 프레임워크에서 포착할 수 없지만, 
[`PlatformDispatcher`][]에서 오류 처리기를 설정하여 처리할 수 있습니다.

Flutter에서 포착한 모든 오류는 [`FlutterError.onError`][] 처리기로 라우팅됩니다. 
기본적으로 이는 [`FlutterError.presentError`][]를 호출하여, 오류를 장치 로그에 덤프합니다. 
IDE에서 실행할 때, 검사기는 이 동작을 재정의하여 오류를 IDE의 콘솔로 라우팅하여, 
메시지에 언급된 객체를 검사할 수 있도록 합니다.

:::note
콘솔에서 로그를 보려면 커스텀 오류 처리기에서, [`FlutterError.presentError`][]를 호출하는 것을 고려하세요.
:::

빌드 단계에서 오류가 발생하면, [`ErrorWidget.builder`][] 콜백이 호출되어 실패한 위젯 대신 사용되는 위젯을 빌드합니다. 
기본적으로, 디버그 모드에서는 오류 메시지가 빨간색으로 표시되고, 릴리스 모드에서는 회색 배경으로 표시됩니다.

호출 스택에서 Flutter 콜백 없이 오류가 발생하면, `PlatformDispatcher`의 오류 콜백에서 처리합니다. 
기본적으로, 오류만 출력하고 다른 작업은 수행하지 않습니다.

이러한 동작은, 일반적으로 `void main()` 함수에서 값으로 설정하여, 커스터마이즈 할 수 있습니다.

각 오류 타입 처리에 대한 설명은 아래에 있습니다. 
맨 아래에는 모든 타입의 오류를 처리하는 코드 조각이 있습니다. 
조각만 복사하여 붙여넣을 수 있지만, 먼저 각 오류 타입을 알아보는 것이 좋습니다.

## Flutter에서 발견된 오류 {:#errors-caught-by-flutter}

예를 들어, Flutter가 릴리스 모드에서 오류를 포착할 때마다 애플리케이션이 즉시 종료되도록 하려면, 다음 핸들러를 사용할 수 있습니다.

<?code-excerpt "lib/quit_immediate.dart (on-error-main)"?>
```dart
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode) exit(1);
  };
  runApp(const MyApp());
}

// `flutter create` 코드의 나머지 부분...
```

:::note
최상위 [`kReleaseMode`][] 상수는 앱이 릴리스 모드로 컴파일되었는지 여부를 나타냅니다.
:::

이 핸들러는 로깅 서비스에 오류를 보고하는 데에도 사용할 수 있습니다.
자세한 내용은 [서비스에 오류 보고][reporting errors to a service]에 대한 요리책 장을 참조하세요.

## 빌드 단계 오류에 대한 커스텀 오류 위젯을 정의 {:#define-a-custom-error-widget-for-build-phase-errors}

빌더가 위젯을 빌드하지 못할 때마다 표시되는 커스터마이즈된 오류 위젯을 정의하려면, [`MaterialApp.builder`][]를 사용합니다.

<?code-excerpt "lib/excerpts.dart (custom-error)"?>
```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget) {
        Widget error = const Text('...rendering error...');
        if (widget is Scaffold || widget is Navigator) {
          error = Scaffold(body: Center(child: error));
        }
        ErrorWidget.builder = (errorDetails) => error;
        if (widget != null) return widget;
        throw StateError('widget is null');
      },
    );
  }
}
```

## Flutter에서 포착되지 않는 오류 {:#errors-not-caught-by-flutter}

`MethodChannel.invokeMethod`(또는 거의 모든 플러그인)와 같은, 비동기 함수를 호출하는 `onPressed` 콜백을 고려하세요. 예를 들어:

<?code-excerpt "lib/excerpts.dart (on-pressed)" replace="/return //g;/^\);$/)/g"?>
```dart
OutlinedButton(
  child: const Text('Click me!'),
  onPressed: () async {
    const channel = MethodChannel('crashy-custom-channel');
    await channel.invokeMethod('blah');
  },
)
```

`invokeMethod`가 오류를 throw하면, `FlutterError.onError`로 전달되지 않습니다. 대신, `PlatformDispatcher`로 전달됩니다.

이러한 오류를 catch 하려면, [`PlatformDispatcher.instance.onError`][]를 사용합니다.

<?code-excerpt "lib/excerpts.dart (catch-error)"?>
```dart
import 'package:flutter/material.dart';
import 'dart:ui';

void main() {
  MyBackend myBackend = MyBackend();
  PlatformDispatcher.instance.onError = (error, stack) {
    myBackend.sendError(error, stack);
    return true;
  };
  runApp(const MyApp());
}
```

## 모든 타입의 오류 처리 {:#handling-all-types-of-errors}

예외가 발생할 때마다 애플리케이션을 종료하고, 
위젯 빌드가 실패할 때마다 커스텀 오류 위젯을 표시하려는 경우, 
다음 코드 조각을 기반으로 오류 처리를 수행할 수 있습니다.

<?code-excerpt "lib/main.dart (all-errors)"?>
```dart
import 'package:flutter/material.dart';
import 'dart:ui';

Future<void> main() async {
  await myErrorsHandler.initialize();
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    myErrorsHandler.onErrorDetails(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    myErrorsHandler.onError(error, stack);
    return true;
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget) {
        Widget error = const Text('...rendering error...');
        if (widget is Scaffold || widget is Navigator) {
          error = Scaffold(body: Center(child: error));
        }
        ErrorWidget.builder = (errorDetails) => error;
        if (widget != null) return widget;
        throw StateError('widget is null');
      },
    );
  }
}
```

[`ErrorWidget.builder`]: {{site.api}}/flutter/widgets/ErrorWidget/builder.html
[`FlutterError.onError`]: {{site.api}}/flutter/foundation/FlutterError/onError.html
[`FlutterError.presentError`]: {{site.api}}/flutter/foundation/FlutterError/presentError.html
[`kReleaseMode`]:  {{site.api}}/flutter/foundation/kReleaseMode-constant.html
[`MaterialApp.builder`]: {{site.api}}/flutter/material/MaterialApp/builder.html
[reporting errors to a service]: /cookbook/maintenance/error-reporting
[`PlatformDispatcher.instance.onError`]: {{site.api}}/flutter/dart-ui/PlatformDispatcher/onError.html
[`PlatformDispatcher`]: {{site.api}}/flutter/dart-ui/PlatformDispatcher-class.html
