---
title: Visual Studio Code
short-title: VS Code
# description: How to develop Flutter apps in Visual Studio Code.
description: Visual Studio Code에서 Flutter 앱을 개발하는 방법.
---

<ul class="nav nav-tabs" id="ide-tabs" role="tablist">
  <li class="nav-item">
    <a class="nav-link" href="/tools/android-studio" role="tab" aria-selected="false">Android Studio 및 IntelliJ</a>
  </li>
  <li class="nav-item">
    <a class="nav-link active" role="tab" aria-selected="true">Visual Studio Code</a>
  </li>
</ul>

## 초기화 및 셋업 {:#installation-and-setup}

[편집기 설정][Set up an editor] 지침에 따라, 
Dart 및 Flutter 확장 프로그램(플러그인이라고도 함)을 설치하세요.

### 확장 프로그램 업데이트 {:#updating}

확장 프로그램 업데이트는 정기적으로 제공됩니다. 
기본적으로, VS Code는 업데이트가 있을 때 자동으로 확장 프로그램을 업데이트합니다.

직접 업데이트를 설치하려면:

1. 사이드 바에서 **Extensions**을 클릭합니다.
2. Flutter 확장 프로그램에 사용 가능한 업데이트가 있는 경우, **Update**를 클릭한 다음 **Reload**를 클릭합니다.
3. VS Code를 다시 시작합니다.

## 프로젝트 생성 {:#creating-projects}

새로운 프로젝트를 만드는 방법에는 여러 가지가 있습니다.

### 새로운 프로젝트 만들기 {:#creating-a-new-project}

Flutter 스타터 앱 템플릿에서 새 Flutter 프로젝트를 만들려면:

1. **View** <span aria-label="and then">></span> **Command Palette...**로 이동합니다.

   <kbd>Ctrl</kbd> / <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd>를 누를 수도 있습니다.

2. `flutter`를 입력합니다.
3. **Flutter: New Project**를 선택합니다.
4. <kbd>Enter</kbd>를 누릅니다.
5. **Application**을 선택합니다.
6. <kbd>Enter</kbd>를 누릅니다.
7. **Project location**을 선택합니다.
8. 원하는 **Project name**을 입력합니다.

### 기존 소스 코드에서 프로젝트 열기 {:#opening-a-project-from-existing-source-code}

기존 Flutter 프로젝트를 여는 방법:

1. **File** <span aria-label="and then">></span> **Open**로 이동합니다.

   <kbd>Ctrl</kbd> / <kbd>Cmd</kbd> + <kbd>O</kbd>를 누를 수도 있습니다.

2. 기존 Flutter 소스 코드 파일이 있는 디렉토리로 이동합니다.
3. **Open**를 클릭합니다.

## 코드 편집 및 문제 보기 {:#editing-code-and-viewing-issues}

Flutter 확장 프로그램은 코드 분석을 수행합니다.
코드 분석은 다음을 수행할 수 있습니다.

- 언어 구문 강조
- 풍부한 타입 분석을 기반으로 코드 완성
- 타입 선언으로 이동

  - **Go** <span aria-label="그리고">></span> **Go to Definition**으로 이동합니다.
  - <kbd>F12</kbd>를 누를 수도 있습니다.

- 타입 사용법 찾기

  - <kbd>Shift</kbd> + <kbd>F12</kbd>를 누릅니다.

- 모든 현재 소스 코드 문제 보기

  - **View** <span aria-label="그리고">></span> **Problems**로 이동합니다.
  - <kbd>Ctrl</kbd> / <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>M</kbd>을 누를 수도 있습니다.
  - 문제 창에는 모든 분석 문제가 표시됩니다.<br>
    ![문제 창](/assets/images/docs/tools/vs-code/problems.png){:.mw-100 .pt-1}

## 실행 및 디버깅 {:#running-and-debugging}

:::note
앱을 디버깅하는 방법은 여러 가지가 있습니다.

- 브라우저에서 실행되는 디버깅 및 프로파일링 도구 모음인 [DevTools][] 사용
- 중단점 설정과 같은, VS Code의 빌트인 디버깅 기능 사용

아래 지침에서는 VS Code에서 사용할 수 있는 기능을 설명합니다.
DevTools 시작 및 사용에 대한 자세한 내용은 [DevTools][] 문서의 [VS Code에서 DevTools 실행][Running DevTools from VS Code]을 참조하세요.
:::

IDE 창에서 **Run > Start Debugging**을 클릭하거나, <kbd>F5</kbd>를 눌러 디버깅을 시작합니다.

### 대상 장치 선택 {:#selecting-a-target-device}

VS Code에서 Flutter 프로젝트를 열면, 
상태 표시줄에 Flutter SDK 버전과 장치 이름(또는 **No Devices** 메시지)을 포함한 
Flutter 관련 항목 세트가 표시되어야 합니다.<br>
![VS Code status bar][]{:.mw-100 .pt-1}

:::note
- Flutter 버전 번호나 기기 정보가 보이지 않으면, 프로젝트가 Flutter 프로젝트로 감지되지 않았을 수 있습니다. 
  `pubspec.yaml`이 포함된 폴더가 VS Code **Workspace Folder** 안에 있는지 확인하세요.
- 상태 표시줄에 **No Devices**이라고 표시되면, 
  Flutter가 연결된 iOS 또는 Android 기기나 시뮬레이터를 발견하지 못한 것입니다. 
  계속하려면, 기기를 연결하거나 시뮬레이터나 에뮬레이터를 시작해야 합니다.
:::

Flutter 확장 프로그램은 자동으로 마지막으로 연결된 기기를 선택합니다. 
그러나, 여러 기기/시뮬레이터가 연결된 경우, 상태 표시줄에서 **device**를 클릭하여, 
화면 상단에 선택 리스트를 확인합니다. 
실행 또는 디버깅에 사용할 기기를 선택합니다.

:::secondary
**Visual Studio Code Remote를 사용하여 macOS 또는 iOS를 원격으로 개발하고 있습니까?** 
그렇다면, 키체인을 수동으로 잠금 해제해야 할 수 있습니다. 
자세한 내용은 이 [StackExchange의 질문][question on StackExchange]을 참조하세요.
:::

[question on StackExchange]: https://superuser.com/questions/270095/when-i-ssh-into-os-x-i-dont-have-my-keychain-when-i-use-terminal-i-do/363840#363840

### 중단점 없이 앱 실행 {:#run-app-without-breakpoints}

**Run** > **Start Without Debugging**으로 이동합니다.

<kbd>Ctrl</kbd> + <kbd>F5</kbd>를 누를 수도 있습니다.

### 중단점을 사용하여 앱 실행 {:#run-app-with-breakpoints} 

1. 원하는 경우, 소스 코드에 중단점을 설정합니다.
2. **Run** <span aria-label="and then">></span> **Start Debugging**을 클릭합니다.
   <kbd>F5</kbd>를 누를 수도 있습니다.
   상태 표시줄이 주황색으로 바뀌어, 디버그 세션에 있음을 나타냅니다.<br>
   ![디버그 콘솔](/assets/images/docs/tools/vs-code/debug_console.png){:.mw-100 .pt-1}

   - 왼쪽 **Debug Sidebar**에는 스택 프레임과 변수가 표시됩니다.
   - 아래쪽 **Debug Console** 창에는 자세한 로깅 출력이 표시됩니다.
   - 디버깅은 기본 실행 구성을 기반으로 합니다. 
     커스터마이즈하려면, **Debug Sidebar** 상단의 톱니바퀴를 클릭하여, `launch.json` 파일을 만듭니다. 
     그런 다음 값을 수정할 수 있습니다.

### 디버그, 프로필 또는 릴리스 모드에서 앱 실행 {:#run-app-in-debug-profile-or-release-mode}

Flutter는 앱을 실행하기 위한 다양한 빌드 모드를 제공합니다.
자세한 내용은 [Flutter의 빌드 모드][Flutter's build modes]에서 확인할 수 있습니다.

1. VS Code에서 `launch.json` 파일을 엽니다.

`launch.json` 파일이 없는 경우:

   {: type="a"}
   1. **View** <span aria-label="and then">></span> **Run**으로 이동합니다.

      <kbd>Ctrl</kbd> / <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>D</kbd>를 누를 수도 있습니다.

      **Run and Debug** 패널이 표시됩니다.

   2. **create a launch.json file**을 클릭합니다.

1. `configurations` 섹션에서, `flutterMode` 속성을 대상으로 삼고 싶은 빌드 모드로 변경합니다.

   예를 들어, 디버그 모드에서 실행하려면 `launch.json`이 다음과 같을 수 있습니다.

    ```json
    "configurations": [
      {
        "name": "Flutter",
        "request": "launch",
        "type": "dart",
        "flutterMode": "debug"
      }
    ]
    ```

2. **Run** 패널을 통해 앱을 실행합니다.

## 빠른 편집 및 개발 주기 새로 고침 {:#fast-edit-and-refresh-development-cycle}

Flutter는 _Stateful Hot Reload_ 기능으로 변경 사항의 효과를 거의 즉시 확인할 수 있는, 
동급 최고의 개발자 주기를 제공합니다. 
자세한 내용은 [Hot reload][]를 확인하세요.

## 고급 디버깅 {:#advanced-debugging}

다음의 고급 디버깅 팁이 유용할 수 있습니다.

### 시각적 레이아웃 문제 디버깅 {:#debugging-visual-layout-issues}

디버그 세션 동안, 여러 추가 디버깅 명령이 [Command Palette][] 및 [Flutter inspector][]에 추가됩니다. 
공간이 제한되면, 아이콘이 레이블의 시각적 버전으로 사용됩니다.

**베이스라인 페인팅 토글** ![Baseline painting icon](/assets/images/docs/tools/devtools/paint-baselines-icon.png){:width="20px"}
: 각 RenderBox가 각 베이스라인에 선을 그리도록 합니다.

**리페인트 레인보우 토글** ![Repaint rainbow icon](/assets/images/docs/tools/devtools/repaint-rainbow-icon.png){:width="20px"}
: 다시 칠할 때(리페인트) 레이어의 색상을 회전하여 표시합니다.

**느린 애니메이션 토글** ![Slow animations icon](/assets/images/docs/tools/devtools/slow-animations-icon.png){:width="20px"}
: 시각적으로 검사할 수 있도록 애니메이션 속도를 늦춥니다.

**디버그 모드 배너 토글** ![Debug mode banner icon](/assets/images/docs/tools/devtools/debug-mode-banner-icon.png){:width="20px"}
: 디버그 빌드를 실행하는 동안에도 디버그 모드 배너를 숨깁니다.

### 외부 라이브러리 디버깅 {:#debugging-external-libraries}

기본적으로, Flutter 확장 프로그램에서 외부 라이브러리 디버깅은 비활성화되어 있습니다. 활성화하려면:

1. **Settings > Extensions > Dart Configuration**을 선택합니다.
2. `Debug External Libraries` 옵션을 선택합니다.

## Flutter 코드 편집 팁 {:#editing-tips-for-flutter-code}

추가로 공유하고 싶은 팁이 있다면, [알려주세요][let us know]!

### 지원 및 빠른 수정 {:#assists-quick-fixes}

지원은 특정 코드 식별자와 관련된 코드 변경입니다. 
노란색 전구 아이콘으로 표시된 대로, Flutter 위젯 식별자에 커서를 놓으면, 이러한 지원 중 일부를 사용할 수 있습니다. 
지원을 호출하려면, 다음 스크린샷에 표시된 대로 전구를 클릭합니다.

![Code assists](/assets/images/docs/tools/vs-code/assists.png){:width="467px"}

<kbd>Ctrl</kbd> / <kbd>Cmd</kbd> + <kbd>.</kbd>를 누를 수도 있습니다.

빠른 수정은 비슷하지만, 오류가 있는 코드 조각과 함께 표시되고, 이를 수정하는 데 도움이 될 수 있습니다.

**새로운 위젯 지원(widget assist)으로 래핑**
: 주변 위젯에 래핑하려는 위젯이 있는 경우, 
  예를 들어 위젯을 `Row` 또는 `Column`에 래핑하려는 경우 사용할 수 있습니다.

**새로운 위젯 지원으로 위젯 리스트 래핑**
: 위의 지원과 유사하지만, 개별 위젯이 아닌 기존 위젯 리스트를 래핑합니다.

**child에서 children으로 변환 지원**
: child 인수를 children 인수로 변경하고, 인수 값을 리스트로 래핑합니다.

**StatelessWidget에서 StatefulWidget 지원으로 변환**
: `State` 클래스를 생성하고 코드를 그곳으로 이동하여, 
  `StatelessWidget`의 구현을 `StatefulWidget`의 구현으로 변경합니다.

### 스니펫 {:#snippets}

스니펫은 일반적인 코드 구조 입력 속도를 높이는 데 사용할 수 있습니다. 
스니펫은 접두사를 입력한 다음, 코드 완성 창에서 선택하여 호출합니다.

![Snippets](/assets/images/docs/tools/vs-code/snippets.png){:width="100%"}

Flutter 확장 프로그램에는 다음 스니펫이 포함되어 있습니다.

- 접두사 `stless`: `StatelessWidget`의 새 하위 클래스를 만듭니다.
- 접두사 `stful`: `StatefulWidget`의 새 하위 클래스와 연관된 State 하위 클래스를 만듭니다.
- 접두사 `stanim`: `StatefulWidget`의 새 하위 클래스와 연관된 State 하위 클래스를 만듭니다. 
  여기에는 `AnimationController`로 초기화된 필드가 포함됩니다.

[Command Palette][]에서 **Configure User Snippets**를 실행하여, 커스텀 스니펫을 정의할 수도 있습니다.

### 키보드 단축키 {:#keyboard-shortcuts}

**핫 리로드**
: 디버그 세션 중에 핫 리로드를 수행하려면, **Debug Toolbar**에서 **Hot Reload**를 클릭합니다.

  <kbd>Ctrl</kbd> + <kbd>F5</kbd>(macOS에서는 <kbd>Cmd</kbd> + <kbd>F5</kbd>)를 누를 수도 있습니다.

  키보드 매핑은 [Command Palette][]에서 **Open Keyboard Shortcuts** 명령을 실행하여 변경할 수 있습니다.

### 핫 리로드 vs 핫 리스타트 {:#hot-reload-vs-hot-restart}

핫 리로드는 업데이트된 소스 코드 파일을 실행 중인 Dart VM(가상 머신)에 주입하여 작동합니다. 
여기에는 새 클래스를 추가하는 것뿐만 아니라, 기존 클래스에 메서드와 필드를 추가하고 기존 함수를 변경하는 것도 포함됩니다. 
그러나 몇 가지 유형의 코드 변경은 핫 리로드할 수 없습니다.

- 전역 변수 초기화자 (Global variable initializers)
- 정적 필드 초기화자 (Static field initializers)
- 앱의 `main()` 메서드

이러한 변경의 경우, 디버깅 세션을 종료하지 않고 앱을 다시 시작합니다. 
핫 리스타트를 수행하려면, [Command Palette][]에서 **Flutter: Hot Restart** 명령을 실행합니다.

<kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>F5</kbd> 또는 
macOS에서는 <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>F5</kbd>를 누를 수도 있습니다.

## 문제 해결 {:#troubleshooting}

### 알려진 문제 및 피드백 {:#known-issues-and-feedback}

알려진 모든 버그는 이슈 트래커에서 추적됩니다: 
[Dart 및 Flutter 확장 GitHub 이슈 트래커][issue tracker]. 
버그/이슈와 기능 요청에 대한 피드백을 환영합니다.

새로운 이슈를 제출하기 전에:

- 이슈 트래커에서 빠르게 검색하여, 이슈가 이미 추적되고 있는지 확인합니다.
- 플러그인의 최신 버전으로 [업데이트](#updating)되어 있는지 확인합니다.

새로운 이슈를 제출할 때, [flutter doctor][] 출력을 포함합니다.

[Command Palette]: https://code.visualstudio.com/docs/getstarted/userinterface#_command-palette
[DevTools]: /tools/devtools
[flutter doctor]: /resources/bug-reports/#provide-some-flutter-diagnostics
[Flutter inspector]: /tools/devtools/inspector
[Flutter's build modes]: /testing/build-modes
[Hot reload]: /tools/hot-reload
[let us know]: {{site.repo.this}}/issues/new
[issue tracker]: {{site.github}}/Dart-Code/Dart-Code/issues
[Running DevTools from VS Code]: /tools/devtools/vscode
[Set up an editor]: /get-started/editor?tab=vscode
[VS Code status bar]: /assets/images/docs/tools/vs-code/device_status_bar.png
