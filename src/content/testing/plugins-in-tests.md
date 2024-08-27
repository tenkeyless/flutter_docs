---
# title: Plugins in Flutter tests
title: Flutter 테스트의 플러그인
# short-title: Plugin tests
short-title: 플러그인 테스트
# description: Adding plugin as part of your Flutter tests.
description: Flutter 테스트의 일부로 플러그인을 추가합니다.
---

:::note
Flutter 앱을 테스트할 때 플러그인으로 인한 충돌을 방지하는 방법을 알아보려면, 계속 읽어보세요. 
플러그인 코드를 테스트하는 방법을 알아보려면, [플러그인 테스트][Testing plugins]를 확인하세요.
:::

[Testing plugins]: /testing/testing-plugins

거의 모든 [Flutter 플러그인][Flutter plugins]에는 두 가지 파트가 있습니다.

* Dart 코드 - 코드에서 호출하는 API를 제공합니다.
* Kotlin이나 Swift와 같이 해당 API를 구현하는 플랫폼별(또는 "호스트") 언어로 작성된 코드.

사실, 네이티브(또는 호스트) 언어 코드는 플러그인 패키지와 표준 패키지를 구분합니다.

[Flutter plugins]: /packages-and-plugins/using-packages

플러그인의 호스트 부분을 빌드하고 등록하는 것은 Flutter 애플리케이션 빌드 프로세스의 일부이므로, 
플러그인은 `flutter run`을 사용하거나 [통합 테스트][integration tests]를 실행할 때와 같이, 
애플리케이션에서 코드가 실행 중일 때만 작동합니다. 
[Dart 유닛 테스트][Dart unit tests] 또는 [위젯 테스트][widget tests]를 실행할 때는, 호스트 코드를 사용할 수 없습니다. 
테스트하는 코드에서 플러그인을 호출하는 경우, 다음과 같은 오류가 발생하는 경우가 많습니다.

```console
MissingPluginException(No implementation found for method someMethodName on channel some_channel_name)
```

[Dart unit tests]: /cookbook/testing/unit/introduction
[integration tests]: /cookbook/testing/integration/introduction
[widget tests]: {{site.api}}/flutter/flutter_test/flutter_test-library.html

:::note
[Dart만 사용하는][only use Dart] 플러그인 구현은 유닛 테스트에서 작동합니다. 
그러나, 이것은 플러그인의 구현 세부 사항이므로, 테스트는 이에 의존해서는 안 됩니다.
:::

[only use Dart]: /packages-and-plugins/developing-packages#dart-only-platform-implementations

플러그인을 사용하는 코드를 유닛 테스트할 때, 이 예외를 피하기 위한 몇 가지 옵션이 있습니다. 
다음 솔루션은 선호도 순서대로 나열되어 있습니다.

## 플러그인 래핑 {:#wrap-the-plugin}

In most cases, the best approach is to wrap plugin
calls in your own API,
and provide a way of [mocking][] your own API in tests.

This has several advantages:

* If the plugin API changes,
  you won't need to update your tests.
* You are only testing your own code,
  so your tests can't fail due to behavior of
  a plugin you're using.
* You can use the same approach regardless of
  how the plugin is implemented,
  or even for non-plugin package dependencies.

[mocking]: /cookbook/testing/unit/mocking

## 플러그인의 공개 API Mock하기 {:#mock-the-plugins-public-api}

If the plugin's API is already based on class instances,
you can mock it directly, with the following caveats:

* This won't work if the plugin uses
  non-class functions or static methods.
* Tests will need to be updated when
  the plugin API changes.

## 플러그인의 플랫폼 인터페이스 Mock하기 {:#mock-the-plugins-platform-interface}

If the plugin is a [federated plugin][],
it will include a platform interface that allows
registering implementations of its internal logic.
You can register a mock of that platform interface
implementation instead of the public API with the
following caveats:

* This won't work if the plugin isn't federated.
* Your tests will include part of the plugin's code,
  so plugin behavior could cause problems for your tests.
  For instance, if a plugin writes files as part of an
  internal cache, your test behavior might change
  based on whether you had run the test previously.
* Tests might need to be updated when the platform interface changes.

An example of when this might be necessary is
mocking the implementation of a plugin used by
a package that you rely on,
rather than your own code,
so you can't change how it's called.
However, if possible,
you should mock the dependency that uses the plugin instead.

[federated plugin]: /packages-and-plugins/developing-packages#federated-plugins

## 플랫폼 채널 Mock하기 {:#mock-the-platform-channel}

If the plugin uses [platform channels][],
you can mock the platform channels using
[`TestDefaultBinaryMessenger`][].
This should only be used if, for some reason,
none of the methods above are available,
as it has several drawbacks:

* Only implementations that use platform channels
  can be mocked. This means that if some implementations
  don't use platform channels,
  your tests will unexpectedly use
  real implementations when run on some platforms.
* Platform channels are usually internal implementation
  details of plugins.
  They might change substantially even
  in a bugfix update to a plugin,
  breaking your tests unexpectedly.
* Platform channels might differ in each implementation
  of a federated plugin. For instance,
  you might set up mock platform channels to
  make tests pass on a Windows machine,
  then find that they fail if run on macOS or Linux.
* Platform channels aren't strongly typed.
  For example, method channels often use dictionaries
  and you have to read the plugin's implementation
  to know what the key strings and value types are.

Because of these limitations, `TestDefaultBinaryMessenger`
is mainly useful in the internal tests
of plugin implementations,
rather than tests of code using plugins.

You might also want to check out
[Testing plugins][].

[platform channels]: /platform-integration/platform-channels
[`TestDefaultBinaryMessenger`]: {{site.api}}/flutter/flutter_test/TestDefaultBinaryMessenger-class.html
[Testing plugins]: /testing/testing-plugins
