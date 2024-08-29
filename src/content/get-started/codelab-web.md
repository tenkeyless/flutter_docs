---
# title: Write your first Flutter app on the web
title: 웹에서 첫 번째 Flutter 앱 작성하기
# description: How to create a Flutter web app.
description: Flutter 웹 앱을 만드는 방법.
# short-title: Write your first web app
short-title: 첫 번째 웹 앱을 작성하세요
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="get-started/codelab_web"?>

:::tip
이 코드랩은 특히 웹에서 첫 번째 Flutter 앱을 작성하는 방법을 안내합니다. 
더 일반적인 접근 방식을 취하는 [다른 코드랩][first_flutter_codelab]을 시도하는 것이 좋습니다. 
이 페이지의 코드랩은 적절한 도구를 다운로드하고 구성하면 모바일과 데스크톱에서 작동합니다.
:::

<img src="/assets/images/docs/get-started/sign-up.gif" alt="The web app that you'll be building." class='site-image-right'>

이것은 첫 번째 Flutter **웹** 앱을 만드는 가이드입니다. 
객체 지향 프로그래밍과 변수, 루프, 조건문과 같은 개념에 익숙하다면, 이 튜토리얼을 완료할 수 있습니다. 
Dart, 모바일 또는 웹 프로그래밍에 대한 이전 경험은 필요하지 않습니다.

## 당신이 만들 것 {:#what-youll-build .no_toc}

로그인 화면을 표시하는 간단한 웹 앱을 구현합니다. 
화면에는 이름(first name), 성(last name), 사용자 이름(username)이라는 세 개의 텍스트 필드가 있습니다. 
사용자가 필드를 채우면, 로그인 영역 상단을 따라 진행률 표시줄이 애니메이션으로 표시됩니다. 
세 개의 필드가 모두 채워지면, 진행률 표시줄이 로그인 영역의 전체 너비를 따라 녹색으로 표시되고, 
**Sign up** 버튼이 활성화됩니다. 
**Sign up** 버튼을 클릭하면 화면 하단에서 환영 화면이 애니메이션으로 표시됩니다.

애니메이션 GIF는 이 랩을 완료했을 때 앱이 작동하는 방식을 보여줍니다.

:::secondary 학습할 내용
* 웹에서 자연스럽게 보이는 Flutter 앱을 작성하는 방법.
* Flutter 앱의 기본 구조.
* Tween 애니메이션을 구현하는 방법.
* stateful 위젯을 구현하는 방법.
* 디버거를 사용하여 중단점을 설정하는 방법.
:::

:::secondary 사용할 것
이 랩을 완료하려면 세 가지 소프트웨어가 필요합니다.

* [Flutter SDK][]
* [Chrome 브라우저][Chrome browser]
* [텍스트 편집기 또는 IDE][editor]

개발하는 동안, Chrome에서 웹 앱을 실행하여, Dart DevTools(Flutter DevTools라고도 함)로 디버깅할 수 있습니다.
:::

## 0단계: 스타터 웹 앱 받기 {:#step-0-get-the-starter-web-app}

우리가 여러분을 위해 제공한 간단한 웹 앱으로 시작해 보겠습니다.

<ol>
<li>웹 개발을 활성화합니다.<br>
명령줄에서, 다음 명령을 실행하여 Flutter가 올바르게 설치되었는지 확인하세요.

```console
$ flutter doctor
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, {{site.appnow.flutter}}, on macOS darwin-arm64, locale en)
[✓] Android toolchain - develop for Android devices (Android SDK version {{site.appnow.android_sdk}})
[✓] Xcode - develop for iOS and macOS (Xcode {{site.appnow.xcode}})
[✓] Chrome - develop for the web
[✓] Android Studio (version {{site.appnow.android_studio}})
[✓] VS Code (version {{site.appnow.vscode}})
[✓] Connected device (4 available)
[✓] HTTP Host Availability

• No issues found!
```

"flutter: command not found"가 표시되면, [Flutter SDK][]를 설치했고 경로에 있는지 확인하세요.

앱은 웹 전용이므로 Android 툴체인, Android Studio 및 Xcode 도구가 설치되지 않아도 괜찮습니다. 
나중에 이 앱을 모바일에서 작동시키려면, 추가 설치 및 설정이 필요합니다.
</li>

<li>

장치를 나열합니다.<br>
웹이 _설치되어 있는지_ 확인하려면, 사용 가능한 장치를 나열합니다. 다음과 같은 내용이 표시되어야 합니다.

```console
$ flutter devices
4 connected devices:

sdk gphone64 arm64 (mobile) • emulator-5554                        •
android-arm64  • Android 13 (API 33) (emulator)
iPhone 14 Pro Max (mobile)  • 45A72BE1-2D4E-4202-9BB3-D6AE2601BEF8 • ios
• com.apple.CoreSimulator.SimRuntime.iOS-16-0 (simulator)
macOS (desktop)             • macos                                •
darwin-arm64   • macOS 12.6 21G115 darwin-arm64
Chrome (web)                • chrome                               •
web-javascript • Google Chrome 105.0.5195.125
```

**Chrome** 기기는 자동으로 Chrome을 시작하고, Flutter DevTools 도구를 사용할 수 있도록 설정합니다.

</li>

<li>

시작 앱은 다음 DartPad에 표시됩니다.

<?code-excerpt "lib/starter.dart"?>
```dartpad title="Flutter beginning getting started hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const SignUpApp());

class SignUpApp extends StatelessWidget {
  const SignUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const SignUpScreen(),
      },
    );
  }
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: const Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: SignUpForm(),
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _usernameTextController = TextEditingController();

  double _formProgress = 0;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: _formProgress),
          Text('Sign up', style: Theme.of(context).textTheme.headlineMedium),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _firstNameTextController,
              decoration: const InputDecoration(hintText: 'First name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _lastNameTextController,
              decoration: const InputDecoration(hintText: 'Last name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _usernameTextController,
              decoration: const InputDecoration(hintText: 'Username'),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                return states.contains(WidgetState.disabled)
                    ? null
                    : Colors.white;
              }),
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                return states.contains(WidgetState.disabled)
                    ? null
                    : Colors.blue;
              }),
            ),
            onPressed: null,
            child: const Text('Sign up'),
          ),
        ],
      ),
    );
  }
}
```

:::important
이 페이지는 [DartPad][]의 임베디드 버전을 사용하여 예제와 연습을 표시합니다. 
DartPad 대신 빈 상자가 표시되면, [DartPad 문제 해결 페이지][DartPad troubleshooting page]로 이동하세요.
:::

</li>

<li>

예제를 실행합니다.<br>
**Run** 버튼을 클릭하여 예제를 실행합니다. 텍스트 필드에 입력할 수 있지만, **Sign up** 버튼은 비활성화되어 있습니다.

</li>

<li>

코드를 복사합니다.<br>
코드 창의 오른쪽 위에 있는 클립보드 아이콘을 클릭하여, Dart 코드를 클립보드에 복사합니다.

</li>

<li>

새 Flutter 프로젝트를 만듭니다.<br>
IDE, 편집기 또는 명령줄에서 [새 Flutter 프로젝트 만들기][create a new Flutter project]를 입력하고, 
`signin_example`이라는 이름을 지정합니다.

</li>

<li>

`lib/main.dart`의 내용을 클립보드의 내용으로 바꿉니다.

</li>
</ol>

### 관찰한 내용 {:#observations .no_toc}

* 이 예제의 전체 코드는 `lib/main.dart` 파일에 있습니다.
* Java를 알고 있다면, Dart 언어가 매우 친숙할 것입니다.
* 앱의 모든 UI는 Dart 코드로 만들어졌습니다. 자세한 내용은 [선언적 UI 소개][Introduction to declarative UI]를 참조하세요.
* 앱의 UI는 모든 기기나 플랫폼에서 실행되는 시각적 디자인 언어인 [Material Design][]을 따릅니다. 
  Material Design 위젯을 사용자 정의할 수 있지만 다른 것을 선호하는 경우, 
  Flutter는 현재 iOS 디자인 언어를 구현하는 Cupertino 위젯 라이브러리도 제공합니다. 
  또는 커스텀 위젯 라이브러리를 직접 만들 수도 있습니다.
* Flutter에서는 거의 모든 것이 [Widget][]입니다. 
  앱 자체도 위젯입니다. 앱의 UI는 위젯 트리로 설명할 수 있습니다.

## 1단계: Welcome 화면 표시 {:#step-1-show-the-welcome-screen}

`SignUpForm` 클래스는 stateful 위젯입니다. 
이는 위젯이 사용자 입력이나 피드의 데이터와 같이, 변경될 수 있는 정보를 저장한다는 것을 의미합니다. 
위젯 자체는 변경할 수 없으므로(immutable. 생성된 후에는 수정할 수 없음)
Flutter는 `State` 클래스라는 동반 클래스에 상태 정보를 저장합니다. 
이 랩에서, 모든 편집은 private `_SignUpFormState` 클래스에 적용됩니다.

:::tip 재미있는 사실
Dart 컴파일러는 밑줄로 시작하는 모든 식별자에 대해 개인 정보 보호를 적용합니다. 
자세한 내용은 [효과적인 Dart 스타일 가이드][Effective Dart Style Guide]를 참조하세요.
:::

먼저, `lib/main.dart` 파일에서, `SignUpScreen` 클래스 뒤에 `WelcomeScreen` 위젯에 대한 다음 클래스 정의를 추가합니다.

<?code-excerpt "lib/step1.dart (welcome-screen)"?>
```dart
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome!',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}
```

다음으로, 화면을 표시하기 위한 버튼을 활성화하고 이를 표시하는 메서드를 생성합니다.

<ol>

<li>

`_SignUpFormState` 클래스의 `build()` 메서드를 찾으세요. 
이것은 SignUp 버튼을 빌드하는 코드의 일부입니다. 
버튼이 어떻게 정의되어 있는지 주목하세요: 
파란색 배경, 흰색 텍스트로 **Sign up**이라고 쓰여 있고, 눌렀을 때 아무것도 하지 않는 `TextButton`입니다.

</li>

<li>

`onPressed` 속성을 업데이트합니다.<br>
`onPressed` 속성을 변경하여, welcome 화면을 표시하는 (존재하지 않는) 메서드를 호출합니다.

`onPressed: null`을 다음과 같이 변경합니다.

<?code-excerpt "lib/step1.dart (on-pressed)"?>
```dart
onPressed: _showWelcomeScreen,
```

</li>

<li>

`_showWelcomeScreen` 메서드를 추가합니다.<br>
분석기에서 보고한 `_showWelcomeScreen`이 정의되지 않았다는 오류를 수정합니다. 
`build()` 메서드 바로 위에, 다음 함수를 추가합니다.

<?code-excerpt "lib/step1.dart (show-welcome-screen)"?>
```dart
void _showWelcomeScreen() {
  Navigator.of(context).pushNamed('/welcome');
}
```

</li>

<li>

`/welcome` 경로를 추가합니다.<br>
새로운 화면을 표시하기 위한 연결을 만듭니다. 
`SignUpApp`의 `build()` 메서드에서 `'/'` 아래에 다음 경로를 추가합니다.

<?code-excerpt "lib/step1.dart (welcome-route)"?>
```dart
'/welcome': (context) => const WelcomeScreen(),
```

</li>

<li>

앱을 실행합니다.<br>
**Sign up** 버튼이 이제 활성화되어야 합니다. 
클릭하여 welcome 화면을 불러옵니다. 
아래에서 애니메이션이 어떻게 나타나는지 주목하세요. 이러한 동작은 무료로 제공됩니다.

</li>

</ol>

### 관찰한 내용 {:#observations-1 .no_toc}

* `_showWelcomeScreen()` 함수는 `build()` 메서드에서 콜백 함수로 사용됩니다. 
  콜백 함수는 종종 Dart 코드에서 사용되며, 이 경우 "버튼을 누르면 이 메서드를 호출합니다"를 의미합니다.
* 생성자 앞에 있는 `const` 키워드는 매우 중요합니다. 
  Flutter가 상수 위젯을 만나면, 대부분의 재빌드 작업을 중단하여, 렌더링을 더 효율적으로 만듭니다.
* Flutter에는 `Navigator` 객체가 하나뿐입니다. 
  이 위젯은 스택 내에서 Flutter의 화면(_경로(routes)_ 또는 _페이지(pages)_ 라고도 함)을 관리합니다. 
  스택 맨 위에 있는 화면은 현재 표시되는 뷰입니다. 이 스택에 새 화면을 푸시하면 디스플레이가 새 화면으로 전환됩니다. 
  이것이 `_showWelcomeScreen` 함수가 `WelcomeScreen`을 Navigator의 스택에 푸시하는 이유입니다. 
  사용자가 버튼을 클릭하면, 짜잔, welcome 화면이 나타납니다. 
  마찬가지로, `Navigator`에서 `pop()`을 호출하면 이전 화면으로 돌아갑니다. 
  Flutter의 탐색은 브라우저의 탐색에 통합되어 있기 때문에, 브라우저의 뒤로 화살표 버튼을 클릭하면 암묵적으로 발생합니다.

## 2단계: 로그인 진행 추적 활성화 {:#step-2-enable-sign-in-progress-tracking}

이 로그인 화면에는 세 개의 필드가 있습니다. 
다음으로, 사용자가 양식 필드를 채우는 진행 상황을 추적하고, 양식이 완료되면 앱의 UI를 업데이트하는 기능을 활성화합니다.

:::note
이 예는 사용자 입력의 정확성을 검증하지 **않습니다**.
당신이 좋다면, 나중에 양식 검증을 사용하여 추가할 수 있을 것입니다.
:::

<ol>
<li>

`_formProgress`를 업데이트하는 메서드를 추가합니다. 
`_SignUpFormState` 클래스에서, `_updateFormProgress()`라는 새 메서드를 추가합니다.

<?code-excerpt "lib/step2.dart (update-form-progress)"?>
```dart
void _updateFormProgress() {
  var progress = 0.0;
  final controllers = [
    _firstNameTextController,
    _lastNameTextController,
    _usernameTextController
  ];

  for (final controller in controllers) {
    if (controller.value.text.isNotEmpty) {
      progress += 1 / controllers.length;
    }
  }

  setState(() {
    _formProgress = progress;
  });
}
```

이 메서드는 비어 있지 않은 텍스트 필드의 수에 따라, `_formProgress` 필드를 업데이트합니다.

</li>

<li>

양식이 변경되면, `_updateFormProgress`를 호출합니다.<br>
`_SignUpFormState` 클래스의 `build()` 메서드에서, `Form` 위젯의 `onChanged` 인수에 콜백을 추가합니다. 
아래 코드 중, NEW로 표시한 부분이 추가된 것입니다.

<?code-excerpt "lib/step2.dart (on-changed)"?>
```dart
return Form(
  onChanged: _updateFormProgress, // NEW
  child: Column(
```

</li>

<li>

`onPressed` 속성을 다시 업데이트합니다.<br>
`1단계`에서 **Sign up** 버튼의 `onPressed` 속성을 수정하여 welcome 화면을 표시했습니다. 
이제, 해당 버튼을 업데이트하여, 양식이 완전히 채워졌을 때만 welcome 화면을 표시합니다.

<?code-excerpt "lib/step2.dart (on-pressed)"?>
```dart
TextButton(
  style: ButtonStyle(
    foregroundColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.disabled)
          ? null
          : Colors.white;
    }),
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.disabled)
          ? null
          : Colors.blue;
    }),
  ),
  onPressed:
      _formProgress == 1 ? _showWelcomeScreen : null, // UPDATED
  child: const Text('Sign up'),
),
```

</li>

<li>

앱을 실행합니다.<br>
**Sign up** 버튼은 처음에는 비활성화되어 있지만, 세 개의 텍스트 필드 모두에 어떠한 텍스트라도 포함되어 있으면 활성화됩니다.

</li>
</ol>

### 관찰한 내용 {:#observations-2 .no_toc}

* 위젯의 `setState()` 메서드를 호출하면, Flutter에 위젯을 화면에서 업데이트해야 한다는 것을 알립니다. 
  그런 다음, 프레임워크는 이전의 불변(immutable) 위젯(및 자식 위젯)을 폐기하고, 
  새 위젯(수반되는 자식 위젯 트리 포함)을 만든 다음 화면에 렌더링합니다. 
  이를 원활하게 작동하려면 Flutter가 빨라야 합니다. 
  특히 애니메이션의 경우, 매끄러운 시각적 전환을 만들려면, 새 위젯 트리를 1/60초 이내에 만들고 화면에 렌더링해야 합니다. 
  다행히 Flutter는 _빠릅니다._
* `progress` 필드는 부동 소수점 값으로 정의되고, `_updateFormProgress` 메서드에서 업데이트됩니다. 
  세 필드가 모두 채워지면, `_formProgress`가 1.0으로 설정됩니다. 
  `_formProgress`가 1.0으로 설정되면, `_onPressed` 콜백이 `_showWelcomeScreen` 메서드로 설정됩니다. 
  이제 `onPressed` 인수가 null이 아니므로, 버튼이 활성화됩니다. 
  Flutter의 대부분 Material Design 버튼과 마찬가지로, 
  [TextButton][]은 `onPressed` 및 `onLongPress` 콜백이 null인 경우 기본적으로 비활성화됩니다.
* `_updateFormProgress`가 `setState()`에 함수를 전달한다는 점에 유의하세요. 
  이를 익명 함수라고 하며 다음과 같은 구문을 갖습니다.

  ```dart
  methodName(() {...});
  ```
  
  여기서 `methodName`은 익명 콜백 함수를 인수로 받는 명명된 함수입니다.
* 마지막 단계에서 welcome 화면을 표시하는 Dart 구문은 다음과 같습니다.
  <?code-excerpt "lib/step2.dart (ternary)" replace="/, \/\/ UPDATED//g"?>
  ```dart
  _formProgress == 1 ? _showWelcomeScreen : null
  ```

  이것은 Dart 조건부 할당이며, 구문은 `condition ? expression1 : expression2`입니다. 
  표현식 `_formProgress == 1`이 참이면, 전체 표현식은 `:`의 왼쪽에 있는 값을 반환하는데, 
  이 경우 `_showWelcomeScreen` 메서드입니다.

## 2.5단계: Dart DevTools 실행 {:#step-2-5-launch-dart-devtools}

Flutter 웹 앱을 어떻게 디버깅하나요? 
모든 Flutter 앱을 디버깅하는 것과 크게 다르지 않습니다. 
[Dart DevTools][]를 사용해야 합니다! (Chrome DevTools와 혼동하지 마세요.)

현재 앱에는 버그가 없지만 어쨌든 확인해 보겠습니다. 
DevTools를 시작하기 위한 다음 지침은 모든 워크플로에 적용되지만, IntelliJ를 사용하는 경우 단축키가 있습니다. 
자세한 내용은 이 섹션의 끝에 있는 팁을 참조하세요.

<ol>
<li>

앱을 실행합니다.<br>
앱이 현재 실행(running) 중이 아니면, 실행(launch)합니다. 
풀다운에서 **Chrome** 기기를 선택하고, IDE에서 실행하거나, 명령줄에서 `flutter run -d chrome`을 사용합니다.

</li>

<li>

DevTools의 웹 소켓 정보를 가져옵니다.<br>
명령줄이나 IDE에서, 다음과 같은 메시지가 표시되어야 합니다.

```console
Launching lib/main.dart on Chrome in debug mode...
Building application for the web...                                11.7s
Attempting to connect to browser instance..
Debug service listening on <b>ws://127.0.0.1:54998/pJqWWxNv92s=</b>
```

굵은 글씨로 표시된 디버그 서비스의 주소를 복사합니다. 
DevTools를 시작하려면 이것이 필요합니다.

</li>

<li>

Dart 및 Flutter 플러그인이 설치되었는지 확인하세요.<br>
IDE를 사용하는 경우 [VS Code][] 및 [Android Studio 및 IntelliJ][Android Studio and IntelliJ] 페이지에 설명된 대로, 
Flutter 및 Dart 플러그인이 설정되어 있는지 확인하세요. 
명령줄에서 작업하는 경우 [DevTools 명령줄][DevTools command line] 페이지에 설명된 대로 DevTools 서버를 시작하세요.

</li>

<li>

DevTools에 연결합니다.<br>
DevTools가 시작(launches)되면, 다음과 같은 내용이 표시됩니다.

```console
Serving DevTools at http://127.0.0.1:9100
```

Chrome 브라우저에서 이 URL로 이동합니다. 
DevTools 시작 화면이 표시되어야 합니다. 다음과 같아야 합니다.

![Screenshot of the DevTools launch screen](/assets/images/docs/get-started/devtools-launch-screen.png){:width="100%"}

</li>

<li>

실행 중인 앱에 연결합니다.<br>
**Connect to a running site**에서, 2단계에서 복사한 웹 소켓(ws) 위치를 붙여넣고, **Connect**를 클릭합니다. 
이제 Chrome 브라우저에서 Dart DevTools가 성공적으로 실행되는 것을 볼 수 있습니다.

![Screenshot of DevTools running screen](/assets/images/docs/get-started/devtools-running.png){:width="100%"}

축하합니다. 이제 Dart DevTools를 실행하고 있습니다!

</li>
</ol>

:::note
DevTools를 시작하는 유일한 방법은 아닙니다. 
IntelliJ를 사용하는 경우, **Flutter Inspector** -> **More Actions** -> **Open DevTools**로 이동하여, 
DevTools를 열 수 있습니다.

![Screenshot of Flutter inspector with DevTools menu](/assets/images/docs/get-started/intellij-devtools.png){:width="100%"}
:::

<ol>
<li>

중단점을 설정합니다.<br>
DevTools가 실행 중이면, 상단의 파란색 막대에서 **Debugger** 탭을 선택합니다. 
디버거 창이 나타나고, 왼쪽 하단에 예제에서 사용된 라이브러리 리스트가 표시됩니다. 
`lib/main.dart`를 선택하여, 중앙 창에 Dart 코드를 표시합니다.

![Screenshot of the DevTools debugger](/assets/images/docs/get-started/devtools-debugging.png){:width="100%"}

</li>

<li>

중단점을 설정합니다.<br>
Dart 코드에서, `progress`가 업데이트되는 곳까지 아래로 스크롤합니다.

<?code-excerpt "lib/step2.dart (for-loop)"?>
```dart
for (final controller in controllers) {
  if (controller.value.text.isNotEmpty) {
    progress += 1 / controllers.length;
  }
}
```

for 루프가 있는 줄에 중단점을 두려면, 줄 번호 왼쪽을 클릭합니다. 
중단점은 이제 창 왼쪽의 **Breakpoints** 섹션에 나타납니다.

</li>

<li>

중단점을 트리거합니다.<br>
실행 중인 앱에서, 텍스트 필드 중 하나를 클릭하여 포커스를 얻습니다. 
앱이 중단점에 도달하고 일시 중지됩니다. 
DevTools 화면에서, 왼쪽에 `progress` 값이 0인 것을 볼 수 있습니다. 
이는 필드가 하나도 채워지지 않았기 때문에 예상된 것입니다. 
for 루프를 단계별로 실행하여 프로그램 실행을 확인합니다.

</li>

<li>

앱을 재개합니다.<br>
DevTools 창에서 녹색 **Resume** 버튼을 클릭하여 앱을 재개합니다.

</li>

<li>

중단점을 삭제합니다.<br>
중단점을 다시 클릭하여, 삭제하고 앱을 재개합니다.

</li>
</ol>

이것은 DevTools를 사용하여 무엇이 가능한지 약간 엿볼 수 있게 해주지만, 
그보다 훨씬 더 많은 것이 있습니다! 자세한 내용은 [DevTools 문서][DevTools documentation]를 ​​참조하세요.

## 3단계: 로그인 진행에 대한 애니메이션 추가 {:#step-3-add-animation-for-sign-in-progress}

애니메이션을 추가할 시간입니다! 
이 마지막 단계에서는, 로그인 영역 상단에 있는 `LinearProgressIndicator`에 대한 애니메이션을 만듭니다. 
애니메이션은 다음과 같은 동작을 합니다.

* 앱이 시작되면, 로그인 영역 상단에 작은 빨간색 막대가 나타납니다.
* 텍스트 필드 하나에 텍스트가 포함된 경우, 빨간색 막대가 주황색으로 바뀌고, 로그인 영역을 가로질러 0.15만큼 애니메이션이 적용됩니다.
* 텍스트 필드 두 개에 텍스트가 포함된 경우, 주황색 막대가 노란색으로 바뀌고, 로그인 영역을 가로질러 절반만큼 애니메이션이 적용됩니다.
* 텍스트 필드 세 개에 모두 텍스트가 포함된 경우, 주황색 막대가 녹색으로 바뀌고, 로그인 영역을 가로질러 애니메이션이 적용됩니다. 
  또한, **Sign up** 버튼이 활성화됩니다.

<ol>
<li>

`AnimatedProgressIndicator`를 추가합니다.<br>
파일 하단에 이 위젯을 추가합니다.

<?code-excerpt "lib/step3.dart (animated-progress-indicator)"?>
```dart
class AnimatedProgressIndicator extends StatefulWidget {
  final double value;

  const AnimatedProgressIndicator({
    super.key,
    required this.value,
  });

  @override
  State<AnimatedProgressIndicator> createState() {
    return _AnimatedProgressIndicatorState();
  }
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _curveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    final colorTween = TweenSequence([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.red, end: Colors.orange),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.orange, end: Colors.yellow),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.yellow, end: Colors.green),
        weight: 1,
      ),
    ]);

    _colorAnimation = _controller.drive(colorTween);
    _curveAnimation = _controller.drive(CurveTween(curve: Curves.easeIn));
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => LinearProgressIndicator(
        value: _curveAnimation.value,
        valueColor: _colorAnimation,
        backgroundColor: _colorAnimation.value?.withOpacity(0.4),
      ),
    );
  }
}
```

[`didUpdateWidget`][] 함수는 `AnimatedProgressIndicator`가 변경될 때마다, 
`AnimatedProgressIndicatorState`를 업데이트합니다.

</li>

<li>

새로운 `AnimatedProgressIndicator`를 사용합니다.<br>
그런 다음, `Form`의 `LinearProgressIndicator`를 이 새로운 `AnimatedProgressIndicator`로 바꿉니다.

<?code-excerpt "lib/step3.dart (use-animated-progress-indicator)"?>
```dart
child: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    AnimatedProgressIndicator(value: _formProgress), // NEW
    Text('Sign up', style: Theme.of(context).textTheme.headlineMedium),
    Padding(
```

이 위젯은 `AnimatedBuilder`를 사용하여, 진행률 표시기를 최신 값으로 애니메이션화합니다.

</li>

<li>

앱을 실행합니다.<br>
세 필드에 무엇이든 입력하여 애니메이션이 작동하는지 확인하고, 
**Sign up** 버튼을 클릭하면 **Welcome** 화면이 나타나는지 확인합니다.

</li>
</ol>

### 완성된 샘플 {:#complete-sample}

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter complete getting started hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const SignUpApp());

class SignUpApp extends StatelessWidget {
  const SignUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const SignUpScreen(),
        '/welcome': (context) => const WelcomeScreen(),
      },
    );
  }
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: const Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: SignUpForm(),
          ),
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome!',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _usernameTextController = TextEditingController();

  double _formProgress = 0;

  void _updateFormProgress() {
    var progress = 0.0;
    final controllers = [
      _firstNameTextController,
      _lastNameTextController,
      _usernameTextController
    ];

    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }

    setState(() {
      _formProgress = progress;
    });
  }

  void _showWelcomeScreen() {
    Navigator.of(context).pushNamed('/welcome');
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      onChanged: _updateFormProgress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedProgressIndicator(value: _formProgress),
          Text('Sign up', style: Theme.of(context).textTheme.headlineMedium),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _firstNameTextController,
              decoration: const InputDecoration(hintText: 'First name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _lastNameTextController,
              decoration: const InputDecoration(hintText: 'Last name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              controller: _usernameTextController,
              decoration: const InputDecoration(hintText: 'Username'),
            ),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                return states.contains(WidgetState.disabled)
                    ? null
                    : Colors.white;
              }),
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                return states.contains(WidgetState.disabled)
                    ? null
                    : Colors.blue;
              }),
            ),
            onPressed: _formProgress == 1 ? _showWelcomeScreen : null,
            child: const Text('Sign up'),
          ),
        ],
      ),
    );
  }
}

class AnimatedProgressIndicator extends StatefulWidget {
  final double value;

  const AnimatedProgressIndicator({
    super.key,
    required this.value,
  });

  @override
  State<AnimatedProgressIndicator> createState() {
    return _AnimatedProgressIndicatorState();
  }
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _curveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    final colorTween = TweenSequence([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.red, end: Colors.orange),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.orange, end: Colors.yellow),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.yellow, end: Colors.green),
        weight: 1,
      ),
    ]);

    _colorAnimation = _controller.drive(colorTween);
    _curveAnimation = _controller.drive(CurveTween(curve: Curves.easeIn));
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => LinearProgressIndicator(
        value: _curveAnimation.value,
        valueColor: _colorAnimation,
        backgroundColor: _colorAnimation.value?.withOpacity(0.4),
      ),
    );
  }
}
```

### 관찰한 내용 {:#observations-3 .no_toc}

* `AnimationController`를 사용하면, 어떤 애니메이션이든 실행할 수 있습니다.
* `AnimatedBuilder`는 `Animation`의 값이 변경될 때, 위젯 트리를 다시 빌드합니다.
* `Tween`을 사용하면 거의 모든 값(이 경우 `Color`) 사이를 보간할 수 있습니다.

## 그 다음은 무엇일까요? {:#what-next}

축하합니다!
Flutter를 사용하여 첫 번째 웹 앱을 만들었습니다!

이 예제를 계속 사용하고 싶다면 폼 검증을 추가할 수 있습니다. 
이를 수행하는 방법에 대한 조언은 [Flutter 쿡북][Flutter cookbook]의 [검증이 포함된 폼 빌드][Building a form with validation] 레시피를 참조하세요.

Flutter 웹 앱, Dart DevTools 또는 Flutter 애니메이션에 대한 자세한 내용은 다음을 참조하세요.

* [애니메이션 문서][Animation docs]
* [Dart DevTools][]
* [암묵적 애니메이션][Implicit animations] 코드랩
* [웹 샘플][Web samples]

[Android Studio and IntelliJ]: /tools/devtools/android-studio
[Animation docs]: /ui/animations
[Building a form with validation]: /cookbook/forms/validation
[Chrome browser]: https://www.google.com/chrome/?brand=CHBD&gclid=CjwKCAiAws7uBRAkEiwAMlbZjlVMZCxJDGAHjoSpoI_3z_HczSbgbMka5c9Z521R89cDoBM3zAluJRoCdCEQAvD_BwE&gclsrc=aw.ds
[create a new Flutter project]: /get-started/test-drive
[Dart DevTools]: /tools/devtools
[DartPad]: {{site.dartpad}}
[DevTools command line]: /tools/devtools/cli
[DevTools documentation]: /tools/devtools
[DevTools installed]: /tools/devtools#start
[DartPad troubleshooting page]: {{site.dart-site}}/tools/dartpad/troubleshoot
[`didUpdateWidget`]: {{site.api}}/flutter/widgets/State/didUpdateWidget.html
[editor]: /get-started/editor
[Effective Dart Style Guide]: {{site.dart-site}}/guides/language/effective-dart/style#dont-use-a-leading-underscore-for-identifiers-that-arent-private
[Flutter cookbook]: /cookbook
[Flutter SDK]: /get-started/install
[Implicit animations]: /codelabs/implicit-animations
[Introduction to declarative UI]: /get-started/flutter-for/declarative
[Material Design]: {{site.material}}/get-started
[TextButton]: {{site.api}}/flutter/material/TextButton-class.html
[VS Code]: /tools/devtools/vscode
[Web samples]: {{site.repo.samples}}/tree/main/web
[Widget]: {{site.api}}/flutter/widgets/Widget-class.html
[first_flutter_codelab]: /get-started/codelab
