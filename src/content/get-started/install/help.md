---
# title: Install help
title: 설치 도움말
# description: This page describes some common installation issues new Flutter users have run into and offers suggestions to resolve them.
description: 이 페이지에서는 새로운 Flutter 사용자가 겪을 수 있는 일반적인 설치 문제를 설명하고 이를 해결하기 위한 제안을 제공합니다.
---

이 페이지에서는 새로운 Flutter 사용자가 마주친 일반적인 설치 문제를 설명하고, 
이를 해결하는 방법에 대한 제안을 제공합니다. 
여전히 문제가 발생하는 경우, [커뮤니티 지원 채널][community support channels]에 나열된 리소스에 문의하는 것을 고려하세요. 
이 페이지에 주제를 추가하거나 수정하려면, 
페이지 상단의 버튼을 사용하여 문제나 풀 리퀘스트를 제출할 수 있습니다.

## Flutter SDK 받기 {:#get-the-flutter-sdk}

### `flutter` 명령을 찾을 수 없습니다 {:#unable-to-find-the-flutter-command}

__이 문제는 어떻게 생겼나요?__

`flutter` 명령을 실행하려고, 하면 콘솔에서 찾을 수 없습니다. 
오류는 일반적으로 다음과 같습니다.

```plaintext
'flutter' is not recognized as an internal or external command operable program or batch file
```

macOS 및 Linux의 오류 메시지는 Windows의 오류 메시지와 약간 다를 수 있습니다.

__설명 및 제안__

플랫폼의 `PATH` 환경 변수에 Flutter를 추가했습니까? 
Windows에서는 이 [경로에 명령을 추가하는 방법][windows path]을 따르세요.

Flutter 개발을 위해 이미 [VS Code를 설정][set up VS Code]했다면, 
Flutter 확장 프로그램의 **Locate SDK** 프롬프트를 사용하여, 
`flutter` 폴더의 위치를 ​​식별할 수 있습니다.

다음도 참조하세요: [PATH 및 환경 변수 구성 - Dart Code][config path]


### 특수 폴더의 Flutter {:#flutter-in-special-folders}

__이 문제는 어떻게 생겼나요?__

Flutter 프로젝트를 실행하면 다음과 같은 오류가 발생합니다.

```plaintext
The Flutter SDK is installed in a protected folder and may not function correctly.
Please move the SDK to a location that is user-writable without Administration permissions and restart.
```

__설명 및 제안__

Windows에서, 이는 일반적으로 Flutter가 높은 권한이 필요한 `C:\Program Files\`와 같은 디렉토리에 설치될 때 발생합니다. 
Flutter를 `C:\src\flutter`와 같은 다른 폴더로 옮겨보세요.

## Android 셋업 {:#android-setup}

### 여러 버전의 Java가 설치되어 있음 {:#having-multiple-versions-of-java-installed}

__이 문제는 어떻게 생겼나요?__

`flutter doctor --android-licenses` 명령이 실패합니다. 
`flutter doctor –verbose`를 실행하면 다음과 같은 오류 메시지가 표시됩니다.

```plaintext
java.lang.UnsupportedClassVersionError: com/android/prefs/AndroidLocationsProvider 
has been compiled by a more recent version of the Java Runtime (class file version 55.0), 
this version of the Java Runtime only recognizes class file versions up to 52.0
```

__설명 및 제안__

이 오류는 컴퓨터에 이전 버전의 Java Development Kit(JDK)가 설치되어 있을 때 발생합니다.

여러 버전의 Java가 필요하지 않으면, 컴퓨터에서 기존 JDK를 제거하세요. 
Flutter는 Android Studio에 포함된 JDK를 자동으로 사용합니다.

다른 버전의 Java가 필요한 경우, 장기적 솔루션이 구현될 때까지 [이 GitHub 문제][java binary path]에 설명된 해결 방법을 시도하세요. 
자세한 내용은 [Android Java Gradle 마이그레이션 가이드][Android Java Gradle migration guide] 또는 [flutter doctor --android-licenses가 java.lang.UnsupportedClassVersionError로 인해 작동하지 않음 - Stack Overflow][so java version]을 확인하세요.

### `cmdline-tools` 구성 요소가 없음 {:#cmdline-tools-component-is-missing}

__이 문제는 어떻게 생겼나요?__

`flutter doctor` 명령이 Android 툴체인에서 `cmdline-tools`가 누락되었다고 컴플레인합니다. 
예를 들어:

```plaintext noHighlight
[!] Android toolchain - develop for Android devices (Android SDK version 33.0.2) 
    • Android SDK at C:\Users\My PC\AppData\Local\Android\sdk 
    X cmdline-tools component is missing 
```

__설명 및 제안__

cmdline-tools를 얻는 가장 쉬운 방법은 Android Studio의 SDK 관리자를 사용하는 것입니다. 
이를 위해, 다음 지침을 따르세요.

1. 메뉴 바에서 **Tools > SDK Manager**를 선택하여 Android Studio에서 SDK 관리자를 엽니다.
1. 최신 Android SDK(또는 앱에 필요한 특정 버전), Android SDK 명령줄 도구, Android SDK 빌드 도구를 선택합니다.
2. **Apply**를 클릭하여 선택한 아티팩트를 설치합니다.

![Android Studio SDK Manager](/assets/images/docs/get-started/install_android_tools.png)

Android Studio를 사용하지 않는 경우, [sdkmanager][] 명령줄 도구를 사용하여 도구를 다운로드할 수 있습니다.

## 기타 문제 {:#other-problems}

### Exit code 69 {:#exit-code-69}

__이 문제는 어떻게 생겼나요?__

`flutter` 명령을 실행하면, 다음 예와 같이 "exit code: 69" 오류가 발생합니다.

```plaintext
Running "flutter pub get" in flutter_tools...
Resolving dependencies in .../flutter/packages/flutter_tools... (28.0s)
Got TLS error trying to find package test at https://pub.dev/.
pub get failed
command:
".../flutter/bin/cache/dart-sdk/bin/
dart __deprecated_pub --color --directory
.../flutter/packages/flutter_tools get --example"
pub env: {
  "FLUTTER_ROOT": ".../flutter",
  "PUB_ENVIRONMENT": "flutter_cli:get",
  "PUB_CACHE": ".../.pub-cache",
}
exit code: 69
```

__설명 및 제안__

이 문제는 네트워킹과 관련이 있습니다. 다음 지침에 따라 문제를 해결해 보세요.

* 인터넷 연결을 확인하세요. 인터넷에 연결되어 있고 연결이 안정적인지 확인하세요.
* 컴퓨터와 네트워킹 장비를 포함한 기기를 다시 시작하세요.
* VPN을 사용하여 네트워크에 연결하는 것을 방해할 수 있는 제한을 우회하세요.
* 이러한 모든 단계를 시도했는데도 여전히 오류가 발생하는 경우, 
  `flutter doctor -v` 명령으로 자세한 로그를 출력하고, 
  [커뮤니티 지원 채널][community support channels] 중 하나에서 도움을 요청하세요.

## 커뮤니티 지원 {:#community-support}

Flutter 커뮤니티는 친절하고 환영해줍니다. 
위의 제안 중 어느 것도 설치 문제를 해결하지 못한다면, 다음 채널 중 하나에서 지원을 요청해 보세요.

* Reddit의 [/r/flutterhelp](https://www.reddit.com/r/flutterhelp/)
* Discord의 [/r/flutterdev](https://discord.gg/rflutterdev), 특히 이 서버의 `install-and-setup` 채널.
* [StackOverflow][], 특히 [#flutter][] 또는 [#dart][] 태그가 지정된 질문.

모든 사람의 시간을 존중하기 위해, 새로운 문제를 게시하기 전에, 아카이브에서 비슷한 문제를 검색해 보세요.

[StackOverflow]: {{site.so}}
[#dart]: {{site.so}}/questions/tagged/dart
[#flutter]: {{site.so}}/questions/tagged/flutter
[Android Java Gradle migration guide]: /release/breaking-changes/android-java-gradle-migration-guide
[community support channels]: #community-support
[java binary path]: {{site.repo.flutter}}/issues/106416#issuecomment-1522198064
[so java version]: {{site.so}}/questions/75328050/
[set up VS Code]: /get-started/editor
[config path]: https://dartcode.org/docs/configuring-path-and-environment-variables/
[sdkmanager]: {{site.android-dev}}/studio/command-line/sdkmanager
[windows path]: https://www.wikihow.com/Change-the-PATH-Environment-Variable-on-Windows
