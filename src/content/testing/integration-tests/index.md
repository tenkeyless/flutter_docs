---
# title: Check app functionality with an integration test
title: 통합 테스트로 앱 기능 확인
# description: Learn how to write integration tests
description: 통합 테스트를 작성하는 방법을 알아보세요
---

<?code-excerpt path-base="testing/integration_tests/how_to"?>

이 레시피는 [`integration_test`][] 패키지를 사용하여 통합 테스트를 실행하는 방법을 설명합니다. 
Flutter SDK에는 `integration_test` 패키지가 포함되어 있습니다. 
이 패키지를 사용하는 통합 테스트에는 다음과 같은 속성이 있습니다.

* `flutter drive` 명령어를 사용하여 실제 기기나 에뮬레이터에서 테스트를 실행합니다.
* 다양한 기기에서 테스트를 자동화하기 위해 [Firebase Test Lab][]에서 실행합니다.
* [flutter_test][] API를 사용하여 [widget tests][]와 비슷한 스타일로 테스트를 작성할 수 있도록 합니다.

이 레시피에서는, 카운터 앱을 테스트하는 방법을 알아봅니다.

* 통합 테스트를 설정하는 방법
* 앱에 특정 텍스트가 표시되는지 확인하는 방법
* 특정 위젯을 탭하는 방법
* 통합 테스트를 실행하는 방법

이 레시피는 다음 단계를 사용합니다.

1. 테스트할 앱을 만듭니다.
2. `integration_test` 종속성을 추가합니다.
3. 테스트 파일을 만듭니다.
4. 통합 테스트를 작성합니다.
5. 통합 테스트를 실행합니다.

## 1. 테스트할 새 앱을 만들기 {:#create-a-new-app-to-test}

통합 테스트에는 테스트할 앱이 필요합니다. 
이 예제에서는 Flutter에서 `flutter create` 명령을 실행할 때 생성되는 기본 제공 **Counter App** 예제를 사용합니다. 
카운터 앱을 사용하면 사용자가 버튼을 탭하여 카운터를 늘릴 수 있습니다.

1. 기본 제공 Flutter 앱의 인스턴스를 만들려면, 터미널에서 다음 명령을 실행합니다.

```console
$ flutter create counter_app
```

1. `counter_app` 디렉터리로 변경합니다.

1. 선호하는 IDE에서 `lib/main.dart`를 엽니다.

1. `increment` 문자열 값을 갖는 `Key` 클래스의 인스턴스와 함께, `floatingActionButton()` 위젯에 `key` 매개변수를 추가합니다.

   ```dart
    floatingActionButton: FloatingActionButton(
      [!key: const ValueKey('increment'),!]
      onPressed: _incrementCounter,
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    ),
   ```

2. `lib/main.dart` 파일을 저장합니다.

이러한 변경 후, `lib/main.dart` 파일은 다음 코드와 유사해야 합니다.

<?code-excerpt "lib/main.dart"?>
```dart title="lib/main.dart"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Counter App',
      home: MyHomePage(title: 'Counter App Home Page'),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // 이 버튼에 Key를 제공합니다. 
        // 이렇게 하면, 테스트 모음 내에서 이 특정 버튼을 찾아 탭할 수 있습니다.
        key: const Key('increment'),
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

## 2. `integration_test` 종속성 추가 {:#add-the-integration_test-dependency}

새 앱에 테스트 패키지를 추가해야 합니다.

`sdk: flutter`를 사용하여 `integration_test` 및 `flutter_test` 패키지를 `dev_dependencies`로 추가하려면, 다음 명령을 실행합니다.

```console
$ flutter pub add 'dev:integration_test:{"sdk":"flutter"}'
```

출력

```console
Building flutter tool...
Resolving dependencies... 
Got dependencies.
Resolving dependencies... 
+ file 7.0.0
+ flutter_driver 0.0.0 from sdk flutter
+ fuchsia_remote_debug_protocol 0.0.0 from sdk flutter
+ integration_test 0.0.0 from sdk flutter
...
  test_api 0.6.1 (0.7.1 available)
  vm_service 13.0.0 (14.2.1 available)
+ webdriver 3.0.3
Changed 8 dependencies!
7 packages have newer versions incompatible with dependency constraints.
Try `flutter pub outdated` for more information.
```

업데이트된 `pubspec.yaml` 파일

```yaml title="pubspec.yaml"
# ...
dev_dependencies:
  # ... 추가된 종속성
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  [!integration_test:!]
    [!sdk: flutter!]
# ...
```

## 3. 통합 테스트 파일 생성 {:#create-the-integration-test-files}

통합 테스트는 Flutter 프로젝트 내부의 별도 디렉토리에 있습니다.

1. `integration_test`라는 이름의 새 디렉토리를 만듭니다.
2. 해당 디렉토리에 `app_test.dart`라는 이름의 빈 파일을 추가합니다.

결과 디렉토리 트리는 다음과 유사해야 합니다.

```plaintext
counter_app/
  lib/
    main.dart
  integration_test/
    app_test.dart
```

## 4. 통합 테스트 작성 {:#write-the-integration-test}

통합 테스트 파일은 `integration_test`, `flutter_test` 및 당신의 앱의 Dart 파일에 대한 종속성이 있는 Dart 코드 파일로 구성됩니다.

1. 선호하는 IDE에서 `integration_test/app_test.dart` 파일을 엽니다.

1. 다음 코드를 복사하여 `integration_test/app_test.dart` 파일에 붙여넣습니다. 
   마지막 import는 `counter_app`의 `main.dart` 파일을 가리켜야 합니다. 
   (이 `import`는 `introduction`이라는 예제 앱을 가리킵니다.)

    <?code-excerpt "integration_test/counter_test.dart (initial)" replace="/introduction/counter_app/g"?>
    ```dart title="integration_test/counter_test.dart"
    import 'package:flutter/material.dart';
    import 'package:flutter_test/flutter_test.dart';
    import 'package:how_to/main.dart';
    import 'package:integration_test/integration_test.dart';
    
    void main() {
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    
      group('end-to-end test', () {
        testWidgets('tap on the floating action button, verify counter',
            (tester) async {
          // 앱 위젯을 로드합니다.
          await tester.pumpWidget(const MyApp());
    
          // 카운터가 0에서 시작하는지 확인하세요.
          expect(find.text('0'), findsOneWidget);
    
          // 탭할 FAB(떠 있는 작업 버튼, floating action button)을 찾습니다.
          final fab = find.byKey(const ValueKey('increment'));
    
          // FAB를 탭하는 동작을 에뮬레이트합니다.
          await tester.tap(fab);
    
          // 프레임을 트리거합니다.
          await tester.pumpAndSettle();
    
          // 카운터가 1씩 증가하는지 확인하세요.
          expect(find.text('1'), findsOneWidget);
        });
      });
    }
    ```

이 예제는 세 단계를 거칩니다.

1. `IntegrationTestWidgetsFlutterBinding`을 초기화합니다. 
   이 싱글톤 서비스는 물리적 장치에서 테스트를 실행합니다.

2. `WidgetTester` 클래스를 사용하여 위젯과 상호 작용하고 테스트합니다.

3. 중요한 시나리오를 테스트합니다.

## 5. 통합 테스트 실행 {:#run-integration-tests}

실행되는 통합 테스트는 테스트하는 플랫폼에 따라 다릅니다.

* 데스크톱 플랫폼을 테스트하려면, 명령줄이나 CI 시스템을 사용합니다.
* 모바일 플랫폼을 테스트하려면, 명령줄이나 Firebase Test Lab을 사용합니다.
* 웹 브라우저에서 테스트하려면, 명령줄을 사용합니다.

---

### 데스크톱 플랫폼에서 테스트 {:#test-on-a-desktop-platform}

<details markdown="1">
<summary>CI 시스템을 사용하여 Linux 앱을 테스트하는 경우 확장</summary>

Linux 앱을 테스트하려면, CI 시스템이 먼저 X 서버를 호출해야 합니다. 
GitHub Action, GitLab Runner 또는 이와 유사한 구성 파일에서, 
통합 테스트를 `xvfb-run` 도구와 _함께_ 작동하도록 설정합니다.

이렇게 하면, Flutter가 Linux 앱을 실행하고 테스트할 수 있는 X Window 시스템이 호출됩니다.

GitHub Actions를 사용하는 예로, `jobs.setup.steps`에는 다음과 유사한 단계가 포함되어야 합니다.

```yaml
      - name: Run Integration Tests
        uses: username/xvfb-action@v1.1.2
        with:
          run: flutter test integration_test -d linux -r github
```

이렇게 하면 X Window 내에서 통합 테스트가 시작됩니다.

이런 방식으로 통합을 구성하지 않으면, Flutter에서 오류가 반환됩니다.

```console
Building Linux application...
Error waiting for a debug connection: The log reader stopped unexpectedly, or never started.
```

</details>

macOS, Windows 또는 Linux 플랫폼에서 테스트하려면, 다음 작업을 완료하세요.

1. 프로젝트 루트에서 다음 명령을 실행합니다.

   ```console
   $ flutter test integration_test/app_test.dart
   ```

2. 테스트할 플랫폼 선택이 제공되면, 데스크톱 플랫폼을 선택합니다. 
   데스크톱 플랫폼을 선택하려면 `1`을 입력합니다.

플랫폼에 따라 명령 결과는 다음 출력과 유사합니다.

{% tabs %}
{% tab "Windows" %}

{% render docs/test/integration/windows-example.md %}

{% endtab %}
{% tab "macOS" %}

{% render docs/test/integration/macos-example.md %}

{% endtab %}
{% tab "Linux" %}

{% render docs/test/integration/linux-example.md %}

{% endtab %}
{% endtabs %}

---

### 모바일 기기에서 테스트 {:#test-on-a-mobile-device}

실제 iOS 또는 Android 기기에서 테스트하려면, 다음 작업을 완료하세요.

1. 기기를 연결합니다.

1. 프로젝트 루트에서 다음 명령을 실행합니다.

   ```console
   $ flutter test integration_test/app_test.dart
   ```

   결과는 다음 출력과 유사해야 합니다. 이 예에서는 iOS를 사용합니다.

   ```console
   $ flutter test integration_test/app_test.dart
   00:04 +0: loading /path/to/counter_app/integration_test/app_test.dart
   00:15 +0: loading /path/to/counter_app/integration_test/app_test.dart
   00:18 +0: loading /path/to/counter_app/integration_test/app_test.dart   2,387ms
   Xcode build done.                                           13.5s
   00:21 +1: All tests passed!
   ```

2. 테스트가 완료되면 Counter App이 제거되었는지 확인합니다. 
   그렇지 않으면, 후속 테스트가 실패합니다. 필요한 경우, 앱을 누르고 컨텍스트 메뉴에서 **Remove App**를 선택합니다. 

---

### 웹 브라우저에서 테스트 {:#test-in-a-web-browser}

{% comment %}
TODO(ryjohn): Add back after other WebDriver versions are supported:
https://github.com/flutter/flutter/issues/90158

To test for web,
determine which browser you want to test against
and download the corresponding web driver:

* Chrome: Download [ChromeDriver][]
* Firefox: [Download GeckoDriver][]
* Safari: Safari can only be tested on a Mac;
  the SafariDriver is already installed on Mac machines.
* Edge [Download EdgeDriver][]
{% endcomment -%}

웹 브라우저에서 테스트하려면 다음 단계를 수행하세요.

1. [ChromeDriver][]를 선택한 디렉토리에 설치하세요.

   ```console
   $ npx @puppeteer/browsers install chromedriver@stable
   ```

   설치를 간소화하기 위해, 이 명령은 [`@puppeteer/browsers`][puppeteer] Node 라이브러리를 사용합니다.

   [puppeteer]: https://www.npmjs.com/package/@puppeteer/browsers

2. `$PATH` 환경 변수에 ChromeDriver 경로를 추가합니다.

3. ChromeDriver 설치가 성공했는지 확인합니다.

   ```console
   $ chromedriver --version
   ChromeDriver 124.0.6367.60 (8771130bd84f76d855ae42fbe02752b03e352f17-refs/branch-heads/6367@{#798})
   ```

4. `counter_app` 프로젝트 디렉토리에, `test_driver`라는 이름의 새 디렉토리를 만듭니다.

   ```console
   $ mkdir test_driver
   ```

5. 이 디렉토리에서, `integration_test.dart`라는 이름의 새 파일을 만듭니다.

6. 다음 코드를 복사하여 `integration_test.dart` 파일에 붙여넣습니다.

   <?code-excerpt "test_driver/integration_test.dart"?>
   ```dart title="test_driver/integration_test.dart"
   import 'package:integration_test/integration_test_driver.dart';
   
   Future<void> main() => integrationDriver();
   ```

7. 다음과 같이 `chromedriver`를 실행하세요.

   ```console
   $ chromedriver --port=4444
   ```

8. 프로젝트 루트에서 다음 명령을 실행합니다.

   ```console
   $ flutter drive \
     --driver=test_driver/integration_test.dart \
     --target=integration_test/app_test.dart \
     -d chrome
   ```

   응답은 다음 출력과 유사해야 합니다.

   ```console
   Resolving dependencies...
     leak_tracker 10.0.0 (10.0.5 available)
     leak_tracker_flutter_testing 2.0.1 (3.0.5 available)
     leak_tracker_testing 2.0.1 (3.0.1 available)
     material_color_utilities 0.8.0 (0.11.1 available)
     meta 1.11.0 (1.14.0 available)
     test_api 0.6.1 (0.7.1 available)
     vm_service 13.0.0 (14.2.1 available)
   Got dependencies!
   7 packages have newer versions incompatible with dependency constraints.
   Try `flutter pub outdated` for more information.
   Launching integration_test/app_test.dart on Chrome in debug mode...
   Waiting for connection from debug service on Chrome...             10.9s
   This app is linked to the debug service: ws://127.0.0.1:51523/3lofIjIdmbs=/ws
   Debug service listening on ws://127.0.0.1:51523/3lofIjIdmbs=/ws
   00:00 +0: end-to-end test tap on the floating action button, verify counter
   00:01 +1: (tearDownAll)
   00:01 +2: All tests passed!
   All tests passed.
   Application finished.
   ```

   이를 헤드리스 테스트로 실행하려면, `-d web-server` 옵션과 함께 `flutter drive`를 실행합니다.

   ```console
   $ flutter drive \
     --driver=test_driver/integration_test.dart \
     --target=integration_test/app_test.dart \
     -d web-server
   ```

자세한 내용은 [웹을 사용하여 Flutter 드라이버 테스트 실행][Running Flutter driver tests with web] 위키 페이지를 참조하세요.

---

### Firebase Test Lab을 사용하여 테스트 {:#test-using-the-firebase-test-lab}

Android와 iOS 대상을 모두 테스트하려면, Firebase Test Lab을 사용하면 됩니다.

#### Android 셋업 {:#android-setup}

README의 [Android 기기 테스트][Android Device Testing] 섹션의 지침을 따르세요.

#### iOS 셋업 {:#ios-setup}

README의 [iOS 기기 테스트][iOS Device Testing] 섹션의 지침을 따르세요.

#### Test Lab 프로젝트 셋업 {:#test-lab-project-setup}

1. [Firebase 콘솔][Firebase Console]을 시작합니다.

1. 필요한 경우 새 Firebase 프로젝트를 만듭니다.

2. **Quality > Test Lab**으로 이동합니다.

   <img src='/assets/images/docs/integration-test/test-lab-1.png' class="mw-100" alt="Firebase Test Lab Console">

#### 안드로이드 APK 업로드 {:#upload-an-android-apk}

1. Gradle을 사용하여 APK를 만듭니다.

   ```console
   $ pushd android
   # flutter build generates files in android/ for building the app
   flutter build apk
   ./gradlew app:assembleAndroidTest
   ./gradlew app:assembleDebug -Ptarget=integration_test/<name>_test.dart
   $ popd
   ```

   여기서 `<name>_test.dart`는 **Project Setup** 섹션에서 생성된 파일입니다.

:::note

`--dart-define`을 `gradlew`와 함께 사용하려면:

1. 모든 매개변수를 `base64`로 인코딩합니다.
2. 매개변수를 쉼표로 구분된 리스트로 gradle에 전달합니다.

   ```console
   ./gradlew project:task -Pdart-defines="{base64   (key=value)},[...]"
   ```

:::

Robo 테스트를 시작하고 다른 테스트를 실행하려면, `<flutter_project_directory>/build/app/outputs/apk/debug`에서 "debug" APK를 웹 페이지의 **Android Robo Test** 대상으로 끌어다 놓습니다.

<img src='/assets/images/docs/integration-test/test-lab-2.png' class="mw-100" alt="Firebase Test Lab upload">

1. **Run a test**을 클릭합니다.

2. **Instrumentation** 테스트 타입을 선택합니다.

3. 앱 APK를 **App APK or AAB** 상자에 추가합니다.

   `<flutter_project_directory>/build/app/outputs/apk/debug/<file>.apk`

4. 테스트 APK를 **Test APK** 상자에 추가합니다.

   `<flutter_project_directory>/build/app/outputs/apk/androidTest/debug/<file>.apk`

<img src='/assets/images/docs/integration-test/test-lab-3.png' class="mw-100" alt="Firebase Test Lab upload two APKs">

오류가 발생하면, 빨간색 아이콘을 클릭하여 출력을 확인하세요.

<img src='/assets/images/docs/integration-test/test-lab-4.png' class="mw-100" alt="Firebase Test Lab test results">

#### 명령줄에서 Android APK 업로드 {:#upload-an-android-apk-from-the-command-line}

명령줄에서 APK를 업로드하는 방법에 대한 지침은 [README의 Firebase Test Lab 섹션][Firebase Test Lab section of the README]을 참조하세요.

#### Xcode 테스트 업로드 {:#upload-xcode-tests}

.zip 파일을 업로드하는 방법을 알아보려면, Firebase 콘솔의 Firebase TestLab 섹션에서 [Firebase TestLab iOS 지침][Firebase TestLab iOS instructions]을 참조하세요.

#### 명령줄에서 Xcode 테스트 업로드 {:#upload-xcode-tests-from-the-command-line}

명령줄에서 .zip 파일을 업로드하는 방법을 알아보려면 README의 [iOS 기기 테스트][iOS Device Testing] 섹션을 참조하세요.

[`integration_test`]: {{site.repo.flutter}}/tree/main/packages/integration_test#integration_test
[Android Device Testing]: {{site.repo.flutter}}/tree/main/packages/integration_test#android-device-testing
[ChromeDriver]: https://googlechromelabs.github.io/chrome-for-testing/
[Download EdgeDriver]: https://developer.microsoft.com/en-us/microsoft-edge/tools/webdriver/
[Download GeckoDriver]: {{site.github}}/mozilla/geckodriver/releases
[Firebase Console]: http://console.firebase.google.com/
[Firebase Test Lab section of the README]: {{site.repo.flutter}}/tree/main/packages/integration_test#firebase-test-lab
[Firebase Test Lab]: {{site.firebase}}/docs/test-lab
[Firebase TestLab iOS instructions]: {{site.firebase}}/docs/test-lab/ios/firebase-console
[flutter_test]: {{site.api}}/flutter/flutter_test/flutter_test-library.html
[Integration testing]: /testing/integration-tests
[iOS Device Testing]: {{site.repo.flutter}}/tree/main/packages/integration_test#ios-device-testing
[Running Flutter driver tests with web]: {{site.repo.flutter}}/blob/master/docs/contributing/testing/Running-Flutter-Driver-tests-with-Web.md
[widget tests]: /testing/overview#widget-tests

[flutter_driver]: {{site.api}}/flutter/flutter_driver/flutter_driver-library.html
[integration_test usage]: {{site.repo.flutter}}/tree/main/packages/integration_test#usage
[samples]: {{site.repo.samples}}
[testing_app]: {{site.repo.samples}}/tree/main/testing_app/integration_test
[testWidgets]: {{site.api}}/flutter/flutter_test/testWidgets.html
