---
# title: Set up an editor
title: 편집기 설정
# description: Configuring an IDE for Flutter.
description: Flutter를 위한 IDE 구성.
prev:
  title: 설치
  path: /get-started/install
next:
  title: 테스트 드라이브
  path: /get-started/test-drive
toc: false
---

Flutter의 명령줄 도구와 결합된 모든 텍스트 편집기나 통합 개발 환경(IDE)을 사용하여, 
Flutter로 앱을 빌드할 수 있습니다. 
Flutter 팀은 VS Code 및 Android Studio와 같이, 
Flutter 확장 프로그램이나 플러그인을 지원하는 편집기를 사용하는 것을 권장합니다. 
이러한 플러그인은 코드 완성, 구문 강조, 위젯 편집 지원, 실행 및 디버그 지원 등을 제공합니다.

Visual Studio Code, Android Studio 또는 IntelliJ IDEA Community, Educational 및 Ultimate 에디션에 지원되는 플러그인을 추가할 수 있습니다. 
[Flutter 플러그인][Flutter plugin]은 Android Studio 및 나열된 IntelliJ IDEA _에디션에서만_ 작동합니다.

([Dart 플러그인][Dart plugin]은 8개의 추가 JetBrains IDE를 지원합니다.)

[Flutter plugin]: https://plugins.jetbrains.com/plugin/9212-flutter
[Dart plugin]: https://plugins.jetbrains.com/plugin/6351-dart

다음 절차에 따라 VS Code, Android Studio 또는 IntelliJ에 Flutter 플러그인을 추가하세요.

다른 IDE를 선택하는 경우, [다음 단계: 테스트 드라이브](/get-started/test-drive)로 건너뛰세요.

{% tabs %}
{% tab "Visual Studio Code" %}

## VS Code 설치 {:#install-vs-code}

[VS Code][]는 앱을 빌드하고 디버깅하는 코드 편집기입니다. 
Flutter 확장 프로그램을 설치하면 Flutter 앱을 컴파일, 배포 및 디버깅할 수 있습니다.

최신 버전의 VS Code를 설치하려면, 해당 플랫폼에 대한 Microsoft 지침을 따르세요.

- [macOS에 설치][Install on macOS]
- [Windows에 설치][Install on Windows]
- [Linux에 설치][Install on Linux]

[VS Code]: https://code.visualstudio.com/
[Install on macOS]: https://code.visualstudio.com/docs/setup/mac
[Install on Windows]: https://code.visualstudio.com/docs/setup/windows
[Install on Linux]: https://code.visualstudio.com/docs/setup/linux

## VS Code Flutter 확장 프로그램 설치 {:#install-the-vs-code-flutter-extension}

1. **VS Code**를 시작합니다.

2. 브라우저를 열고, Visual Studio Marketplace의 [Flutter 확장 프로그램][Flutter extension] 페이지로 이동합니다.

3. **Install**을 클릭합니다. Flutter 확장 프로그램을 설치하면, Dart 확장 프로그램도 설치됩니다.

[Flutter extension]: https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter

## VS Code 설정 검증 {:#validate-your-vs-code-setup}

1. **View** <span aria-label="and then">></span> **Command Palette...** 로 이동합니다.

   <kbd>Ctrl</kbd> / <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd>를 누를 수도 있습니다.

2. `doctor`를 입력합니다.

3. **Flutter: Run Flutter Doctor**를 선택합니다.

   이 명령을 선택하고, VS Code에서 다음을 수행합니다.

   - **Output** 패널을 엽니다.
   - 이 패널의 오른쪽 위 드롭다운에 **flutter (flutter)** 를 표시합니다.
   - Flutter Doctor 명령의 출력을 표시합니다.

{% endtab %}
{% tab "Android Studio 및 IntelliJ" %}

## Android Studio 또는 IntelliJ IDEA 설치 {:#install-android-studio-or-intellij-idea}

Android Studio와 IntelliJ IDEA는 Flutter 플러그인을 설치하면, 완전한 IDE 환경을 제공합니다.

다음 IDE의 최신 버전을 설치하려면 해당 지침을 따르세요.

- [Android Studio][]
- [IntelliJ IDEA Community][]
- [IntelliJ IDEA Ultimate][]

[Android Studio]: {{site.android-dev}}/studio/install
[IntelliJ IDEA Community]: https://www.jetbrains.com/idea/download/
[IntelliJ IDEA Ultimate]: https://www.jetbrains.com/idea/download/

## Flutter 플러그인을 설치하세요 {:#install-the-flutter-plugin}

설치 지침은 플랫폼마다 다릅니다.

### macOS {:#macos}

macOS의 경우 다음 지침을 따르세요.

1. Android Studio 또는 IntelliJ를 시작합니다.

2. macOS 메뉴 바에서, **Android Studio**(또는 **IntelliJ**) <span aria-label="and then">></span> **Settings...** 로 이동합니다.

   <kbd>Cmd</kbd> + <kbd>,</kbd>를 누를 수도 있습니다.

   **Preferences** 대화 상자가 열립니다.

3. 왼쪽 리스트에서, **Plugins**을 선택합니다.

4. 이 패널의 상단에서, **Marketplace**를 선택합니다.

5. 플러그인 검색 필드에 `flutter`를 입력합니다.

6. **Flutter** 플러그인을 선택합니다.

7. **Install**를 클릭합니다.

8. 플러그인을 설치하라는 메시지가 표시되면 **Yes**를 클릭합니다.

9. 메시지가 표시되면 **Restart**을 클릭합니다.

### Linux 또는 Windows {:#linux-or-windows}

Linux 또는 Windows의 경우 다음 지침을 따르세요.

1. **File** <span aria-label="and then">></span> **Settings**으로 이동합니다.

   <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>S</kbd>를 누를 수도 있습니다.

   **Preferences** 대화 상자가 열립니다.

2. 왼쪽 리스트에서 **Plugins**을 선택합니다.

3. 이 패널의 상단에서 **Marketplace**를 선택합니다.

4. 플러그인 검색 필드에 `flutter`를 입력합니다.

5. **Flutter** 플러그인을 선택합니다.

6. **Install**를 클릭합니다.

7. 플러그인을 설치하라는 메시지가 표시되면 **Yes**를 클릭합니다.

8. 메시지가 표시되면 **Restart**을 클릭합니다.

{% endtab %}
{% endtabs %}

