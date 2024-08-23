---
# title: Testing plugins
title: 플러그인 테스트
# description: Learn how to test your plugin package.
description: 플러그인 패키지를 테스트하는 방법을 알아보세요.
---

모든 [일반적인 Flutter 테스트 타입][usual types of Flutter tests]은 플러그인 패키지에도 적용되지만, 
플러그인에는 네이티브 코드가 포함되어 있기 때문에, 모든 기능을 테스트하기 위해 다른 종류의 테스트도 필요한 경우가 많습니다.

[usual types of Flutter tests]: /testing/overview

:::note
플러그인 코드를 테스트하는 방법을 알아보려면 계속 읽어보세요. 
Flutter 앱을 테스트할 때 플러그인으로 인한 충돌을 방지하는 방법을 알아보려면, 
[Flutter 테스트의 플러그인][Plugins in Flutter tests]을 확인하세요.
:::

[Plugins in Flutter tests]: /testing/plugins-in-tests

## 플러그인 테스트 타입 {:#types-of-plugin-tests}

To see examples of each of these types of tests, you can
[create a new plugin from the plugin template][plugin-tests]
and look in the indicated directories.

* <strong>Dart [unit tests][] and [widget tests][]</strong>.
  These tests allow you to test the Dart portion of your plugin
  just as you would test the Dart code of a non-plugin package.
  However, the plugin's native code [won't be loaded][],
  so any calls to platform channels need to be [mocked in tests][].

  See the `test` directory for an example.

* <strong>Dart [integration tests][]</strong>.
  Since integration tests run in the context of a
  Flutter application (the example app),
  they can test both the Dart and native code,
  as well as the interaction between them.
  They are also useful for unit testing web implementation
  code that needs to run in a browser.

  These are often the most important tests for a plugin.
  However, Dart integration tests can't interact with native UI,
  such as native dialogs or the contents of platform views.

  See the  `example/integration_test` directory for an example.

* <strong>Native unit tests.</strong>
  Just as Dart unit tests can test the Dart portions
  of a plugin in isolation, native unit tests can
  test the native parts in isolation.
  Each platform has its own native unit test system,
  and the tests are written in the same native languages
  as the code it is testing.

  Native unit tests can be especially valuable
  if you need to mock out APIs wrapped by your plugin code,
  which isn't possible in a Dart integration test.

  You can set up and use any native test frameworks
  you are familiar with for each platform,
  but the following are already configured in the plugin template:

  * <strong>Android</strong>:
    [JUnit][] tests can be found in `android/src/test/`.

  * <strong>iOS</strong> and <strong>macOS</strong>:
    [XCTest][] tests can be found in `example/ios/RunnerTests/`
    and `example/macos/RunnerTests/` respectively.
    These are in the example directory,
    not the top-level package directory,
    because they are run via the example app's project.

  * <strong>Linux</strong> and <strong>Windows</strong>:
    [GoogleTest][] tests can be found in `linux/test/`
    and `windows/test/`, respectively.

Other types of tests, which aren't currently pre-configured
in the template, are <strong>native UI tests</strong>.
Running your application under a native UI testing framework,
such as [Espresso][] or [XCUITest][],
enables tests that interact with both native and Flutter UI elements,
so can be useful if your plugin can't be tested without
native UI interactions.


[Espresso]: {{site.repo.packages}}/tree/main/packages/espresso
[GoogleTest]: {{site.github}}/google/googletest
[integration tests]: /cookbook/testing/integration/introduction
[JUnit]: {{site.github}}/junit-team/junit4/wiki/Getting-started
[mocked in tests]: /testing/plugins-in-tests#mock-the-platform-channel
[plugin-tests]: /packages-and-plugins/developing-packages#step-1-create-the-package-1
[unit tests]: /cookbook/testing/unit/introduction
[widget tests]: /cookbook/testing/widget/introduction
[won't be loaded]: /testing/plugins-in-tests
[XCTest]: {{site.apple-dev}}/documentation/xctest
[XCUITest]: {{site.apple-dev}}/library/archive/documentation/DeveloperTools/Conceptual/testing_with_xcode/chapters/09-ui_testing.html

## 테스트 실행 {:#running-tests}

### Dart 유닛 테스트 {:#dart-unit-tests}

These can be run like any other Flutter unit tests,
either from your preferred Flutter IDE,
or using `flutter test`.

### 통합 테스트 {:#integration-tests}

For information on running this type of test, check out the
[integration test documentation][].
The commands must be run in the `example` directory.

[integration test documentation]: /cookbook/testing/integration/introduction

### 네이티브 유닛 테스트 {:#native-unit-tests}

For all platforms, you need to build the example
application at least once before running the unit tests,
to ensure that all of the platform-specific build
files have been created.

<strong>Android JUnit</strong><br>

If you have the example opened as an Android project
in Android Studio, you can run the unit tests using
the [Android Studio test UI][].

To run the tests from the command line,
use the following command in the `example/android` directory:

```sh
./gradlew testDebugUnitTest
```

<strong>iOS and macOS XCTest</strong><br>

If you have the example app opened in Xcode,
you can run the unit tests using the [Xcode Test UI][].

To run the tests from the command line,
use the following command in the `example/ios` (for iOS)
or `example/macos` (for macOS) directory:

```sh
xcodebuild test -workspace Runner.xcworkspace -scheme Runner -configuration Debug
```

For iOS tests, you might need to first open
`Runner.xcworkspace` in Xcode to configure code signing.

<strong>Linux GoogleTest</strong><br>

To run the tests from the command line,
use the following command in the example directory,
replacing "my_plugin" with your plugin project name:

```sh
build/linux/plugins/x64/debug/my_plugin/my_plugin_test
```

If you built the example app in release mode rather than
debug, replace "debug" with "release".

<strong>Windows GoogleTest</strong><br>

If you have the example app opened in Visual Studio,
you can run the unit tests using the [Visual Studio test UI][].

To run the tests from the command line,
use the following command in the example directory,
replacing "my_plugin" with your plugin project name:

```sh
build/windows/plugins/my_plugin/Debug/my_plugin_test.exe
```

If you built the example app in release mode rather
than debug, replace "Debug" with "Release".

## 어떤 타입의 테스트를 추가해야 합니까? {:#what-types-of-tests-to-add}

The [general advice for testing Flutter projects][general advice]
applies to plugins as well.
Some extra considerations for plugin testing:

* Since only integration tests can test the communication
  between Dart and the native languages,
  try to have at least one integration test of each
  platform channel call.

* If some flows can't be tested using integration
  tests—for example if they require interacting with
  native UI or mocking device state—consider writing
  "end to end" tests of the two halves using unit tests:

  * Native unit tests that set up the necessary mocks,
    then call into the method channel entry point
    with a synthesized call and validate the method response.

  * Dart unit tests that mock the platform channel,
    then call the plugin's public API and validate the results.

[Android Studio test UI]: {{site.android-dev}}/studio/test/test-in-android-studio
[general advice]: /testing/overview
[Visual Studio test UI]: https://learn.microsoft.com/en-us/visualstudio/test/getting-started-with-unit-testing?view=vs-2022&tabs=dotnet%2Cmstest#run-unit-tests
[Xcode Test UI]: {{site.apple-dev}}/library/archive/documentation/DeveloperTools/Conceptual/testing_with_xcode/chapters/05-running_tests.html

