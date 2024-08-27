---
# title: Report errors to a service
title: 서비스에 오류 보고
# description: How to keep track of errors that users encounter.
description: 사용자가 겪는 오류를 추적하는 방법.
---

<?code-excerpt path-base="cookbook/maintenance/error_reporting/"?>

버그가 없는 앱을 만들려고 항상 노력하지만, 가끔씩 버그가 생깁니다. 
버그가 있는 앱은 사용자와 고객에게 불만을 안겨주기 때문에, 
사용자가 버그를 얼마나 자주 경험하는지, 그리고 버그가 어디에서 발생하는지 이해하는 것이 중요합니다. 
이렇게 하면, 가장 큰 영향을 미치는 버그를 우선 순위로 지정하고 이를 수정하기 위해 노력할 수 있습니다.

사용자가 버그를 얼마나 자주 경험하는지 어떻게 알 수 있을까요? 
오류가 발생할 때마다, 발생한 오류와 관련 스택 추적을 포함하는 보고서를 만듭니다. 
그런 다음, 보고서를 [Bugsnag][], [Datadog][], [Firebase Crashlytics][], [Rollbar][] 또는 Sentry와 같은
오류 추적 서비스로 보낼 수 있습니다.

오류 추적 서비스는 사용자가 경험하는 모든 충돌을 집계하여 그룹화합니다. 
이를 통해 앱이 실패하는 빈도와 사용자가 문제를 겪는 곳을 알 수 있습니다.

이 레시피에서는, 다음 단계를 사용하여 [Sentry][] 충돌 보고 서비스에 오류를 보고하는 방법을 알아봅니다.

  1. Sentry에서 DSN을 받습니다.
  2. Flutter Sentry 패키지 가져오기
  3. Sentry SDK 초기화
  4. 프로그래밍 방식으로 오류 캡처

## 1. Sentry에서 DSN 받기 {:#1-get-a-dsn-from-sentry}

Sentry에 오류를 보고하기 전에, Sentry.io 서비스에서 앱을 고유하게 식별할 수 있는 "DSN"이 필요합니다.

DSN을 받으려면, 다음 단계를 따르세요.

1. [Sentry 계정 만들기][Create an account with Sentry]
2. 계정에 로그인합니다.
3. 새 Flutter 프로젝트를 만듭니다.
4. DSN이 포함된 코드 조각을 복사합니다.

## 2. Sentry 패키지 가져오기 {:#2-import-the-sentry-package}

[`sentry_flutter`][] 패키지를 앱으로 가져옵니다. 
sentry 패키지를 사용하면 Sentry 오류 추적 서비스에 오류 보고서를 보내는 것이 더 쉬워집니다.

`sentry_flutter` 패키지를 종속성으로 추가하려면, `flutter pub add`를 실행합니다.

```console
$ flutter pub add sentry_flutter
```

## 3. Sentry SDK 초기화 {:#3-initialize-the-sentry-sdk}

다양한 처리되지 않은 오류를 자동으로 캡처하기 위해 SDK를 초기화합니다.

<?code-excerpt "lib/main.dart (InitializeSDK)"?>
```dart
import 'package:flutter/widgets.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) => options.dsn = 'https://example@sentry.io/example',
    appRunner: () => runApp(const MyApp()),
  );
}
```

또는, `dart-define` 태그를 사용하여 DSN을 Flutter에 전달할 수 있습니다.

```sh
--dart-define SENTRY_DSN=https://example@sentry.io/example
```

### 그러면 나에게 무슨 도움이 되나요? {:#what-does-that-give-me}

이것이 Sentry가 Dart와 네이티브 레이어에서 처리되지 않은 오류를 캡처하는 데 필요한 전부입니다. 
여기에는 iOS의 Swift, Objective-C, C, C++, Android의 Java, Kotlin, C, C++가 포함됩니다.

## 4. 프로그래밍 방식으로 오류 캡처 {:#4-capture-errors-programmatically}

SDK를 가져오고 초기화하여 Sentry가 생성하는 자동 오류 보고 외에도, API를 사용하여 Sentry에 오류를 보고할 수 있습니다.

<?code-excerpt "lib/main.dart (CaptureException)"?>
```dart
await Sentry.captureException(exception, stackTrace: stackTrace);
```

자세한 내용은, pub.dev의 [Sentry API][] 문서를 참조하세요.

## 더 알아보기 {:#learn-more}

Sentry SDK 사용에 대한 자세한 문서는 [Sentry 사이트][Sentry's site]에서 확인할 수 있습니다.

## 예제 완성 {:#complete-example}

실제 예제를 보려면, [Sentry flutter 예제][Sentry flutter example] 앱을 참조하세요.


[Sentry flutter example]: {{site.github}}/getsentry/sentry-dart/tree/main/flutter/example
[Create an account with Sentry]: https://sentry.io/signup/
[Bugsnag]: https://www.bugsnag.com/platforms/flutter
[Datadog]: https://docs.datadoghq.com/real_user_monitoring/flutter/
[Rollbar]: https://rollbar.com/
[Sentry]: https://sentry.io/welcome/
[`sentry_flutter`]: {{site.pub-pkg}}/sentry_flutter
[Sentry API]: {{site.pub-api}}/sentry_flutter/latest/sentry_flutter/sentry_flutter-library.html
[Sentry's site]: https://docs.sentry.io/platforms/flutter/
[Firebase Crashlytics]: {{site.firebase}}/docs/crashlytics
