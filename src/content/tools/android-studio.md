---
# title: Android Studio and IntelliJ
title: Android Studio 및 IntelliJ
# description: >
#   How to develop Flutter apps in Android Studio or other IntelliJ products.
description: >
  Android Studio 또는 기타 IntelliJ 제품에서 Flutter 앱을 개발하는 방법.
---

<ul class="nav nav-tabs" id="ide" role="tablist">
  <li class="nav-item">
    <a class="nav-link active" role="tab" aria-selected="true">Android Studio 및 IntelliJ</a>
  </li>
  <li class="nav-item">
    <a class="nav-link" href="/tools/vs-code" role="tab" aria-selected="false">Visual Studio Code</a>
  </li>
</ul>

## 초기화 및 셋업 {:#installation-and-setup}

[편집기 설정](/get-started/editor?tab=androidstudio) 지침에 따라, 
Dart 및 Flutter 플러그인을 설치하세요.

### 플러그인 업데이트 {:#updating}

플러그인 업데이트는 정기적으로 제공됩니다. 업데이트가 제공되면 IDE에서 메시지가 표시됩니다.

수동으로 업데이트를 확인하려면:

1. 환경 설정을 엽니다. 
   (macOS에서는 **Android Studio > Check for Updates**, Linux에서는 **Help > Check for Updates**)
2. `dart` 또는 `flutter`가 나열되어 있으면 업데이트합니다.

## 프로젝트 생성 {:#creating-projects}

여러 가지 방법으로 새 ​​프로젝트를 만들 수 있습니다.

### 새로운 프로젝트 만들기 {:#creating-a-new-project}

Flutter 시작 앱 템플릿에서 새 Flutter 프로젝트를 만드는 방법은 Android Studio와 IntelliJ에서 다릅니다.

**Android Studio에서:**

1. IDE에서 **Welcome** 창에서 **New Flutter Project**를 클릭하거나, 
   메인 IDE 창에서 **File > New > New Flutter Project**를 클릭합니다.
2. **Flutter SDK path**를 지정하고, **Next**를 클릭합니다.
3. 원하는 **Project name**, **Description**, **Project location**을 입력합니다.
4. 이 앱을 게시할 경우, [회사 도메인을 설정합니다](#set-the-company-domain).
5. **Finish**를 클릭합니다.

**IntelliJ에서:**

1. IDE에서 **Welcome** 창에서 **New Project**를 클릭하거나, 
   메인 IDE 창에서 **File > New > Project**를 클릭합니다.
2. 왼쪽 패널의 **Generators** 리스트에서 **Flutter**를 선택합니다.
3. **Flutter SDK path**를 지정하고, **Next**를 클릭합니다.
4. 원하는 **Project name**, **Description**, **Project location**을 입력합니다.
5. 이 앱을 게시할 경우, [회사 도메인을 설정합니다](#set-the-company-domain).
6. **Finish**를 클릭합니다.

#### 회사 도메인 설정 {:#set-the-company-domain}

새로운 앱을 만들 때, 일부 Flutter IDE 플러그인은 도메인 순서의 역순으로 조직 이름을 요구합니다. 
예를 들어 `com.example`과 같습니다. 
앱 이름과 함께 Android의 패키지 이름으로 사용되고, 앱이 출시될 때 iOS의 번들 ID로 사용됩니다. 
이 앱을 출시할 가능성이 있다고 생각되면 지금 지정하는 것이 좋습니다. 
앱이 출시되면 변경할 수 없습니다. 조직 이름은 고유해야 합니다.

### 기존 소스 코드에서 프로젝트 열기 {:#opening-a-project-from-existing-source-code}

기존 Flutter 프로젝트를 여는 방법:

1. IDE에서, **Welcome** 창에서 **Open**를 클릭하거나, 메인 IDE 창에서 **File > Open**를 클릭합니다.
1. 기존 Flutter 소스 코드 파일이 있는 디렉터리로 이동합니다.
1. **Open**를 클릭합니다.
   
    :::important
    Flutter 프로젝트에 **New > Project from existing sources** 옵션을 사용하지 *마십시오*.
    :::

## 코드 편집 및 문제 보기 {:#editing-code-and-viewing-issues}

Flutter 플러그인은 다음을 가능하게 하는 코드 분석을 수행합니다.

* 구문 강조 표시.
* 풍부한 타입 분석을 기반으로 한 코드 완성.
* 타입 선언으로 이동(**Navigate > Declaration**) 및 타입 사용 찾기(**Edit > Find > Find Usages**).
* 모든 현재 소스 코드 문제 보기(**View > Tool Windows > Dart Analysis**). 
  모든 분석 문제는 Dart Analysis 창에 표시됩니다.<br>
  ![Dart Analysis pane](/assets/images/docs/tools/android-studio/dart-analysis.png){:width="90%"}

## 실행 및 디버깅 {:#running-and-debugging}

:::note
앱을 디버깅하는 방법은 여러 가지가 있습니다.

* 브라우저에서 실행되고 _Flutter 인스펙터를 포함하는_ 디버깅 및 프로파일링 도구 모음인 [DevTools][]를 사용합니다.
* 중단점을 설정하는 기능과 같은 Android Studio(또는 IntelliJ)의 기본 제공 디버깅 기능을 사용합니다.
* Android Studio 및 IntelliJ에서 바로 사용할 수 있는 Flutter 인스펙터를 사용합니다.

아래 지침에서는 Android Studio 및 IntelliJ에서 사용할 수 있는 기능을 설명합니다. 
DevTools를 시작하는 방법에 대한 자세한 내용은, 
[DevTools][] 문서의 [Android Studio에서 DevTools 실행][Running DevTools from Android Studio]을 참조하세요.
:::

실행 및 디버깅은 메인 도구 모음에서 제어됩니다.

![Main IntelliJ toolbar](/assets/images/docs/tools/android-studio/main-toolbar.png){:width="90%"}

### 타겟 선택 {:#selecting-a-target}

IDE에서 Flutter 프로젝트를 열면, 도구 모음 오른쪽에 Flutter 관련 버튼 세트가 표시됩니다.

:::note
실행 및 디버그 버튼이 비활성화되고, 대상이 나열되지 않으면, 
Flutter가 연결된 iOS 또는 Android 기기나 시뮬레이터를 발견하지 못한 것입니다. 
계속하려면 기기를 연결하거나 시뮬레이터를 시작해야 합니다.
:::

1. **Flutter Target Selector** 드롭다운 버튼을 찾습니다. 
   여기에는 사용 가능한 대상 리스트가 표시됩니다.
2. 앱을 시작할 대상을 선택합니다. 
   기기를 연결하거나 시뮬레이터를 시작하면 추가 항목이 나타납니다.

### 중단점 없이 앱 실행 {:#run-app-without-breakpoints}

1. 툴바에서 **Play icon**을 클릭하거나, **Run > Run**을 호출합니다. 
   하단의 **Run** 창에 로그 출력이 표시됩니다.

### 중단점을 사용하여 앱 실행 {:#run-app-with-breakpoints}

1. 원하는 경우, 소스 코드에 중단점을 설정합니다.
1. 도구 모음에서 **Debug icon**을 클릭하거나, **Run > Debug**를 호출합니다.
   * 하단 **Debugger** 창에는 스택 프레임과 변수가 표시됩니다.
   * 하단 **Console** 창에는 자세한 로그 출력이 표시됩니다.
   * 디버깅은 기본 실행 구성을 기반으로 합니다. 
     이를 커스터마이즈 하려면, 장치 선택기 오른쪽에 있는 드롭다운 버튼을 클릭하고, 
     **Edit configuration**을 선택합니다.

## 편집 및 새로 고침으로 빠른 개발 주기 {:#fast-edit-and-refresh-development-cycle}

Flutter는 _Stateful Hot Reload_ 기능으로, 
변경 사항의 효과를 거의 즉시 확인할 수 있는 동급 최고의 개발자 주기를 제공합니다. 
자세한 내용은 [Hot reload][]를 확인하세요.

### 성능 데이터 표시 {:#show-performance-data}

:::note
Flutter에서 성능 문제를 조사하려면, [타임라인 뷰][Timeline view]를 참조하세요.
:::

위젯 재구축 정보를 포함한 성능 데이터를 보려면, 
앱을 **Debug** 모드에서 시작한 다음, 
**View > Tool Windows > Flutter Performance**을 사용하여 성능 도구 창을 엽니다.

![Flutter performance window](/assets/images/docs/tools/android-studio/widget-rebuild-info.png){:width="90%"}

어떤 위젯이 얼마나 자주 재구축되고 있는지에 대한 통계를 보려면, 
**Performance** 창에서 **Show widget rebuild information**를 클릭합니다. 
이 프레임의 정확한 재구축 횟수는 오른쪽에서 두 번째 열에 표시됩니다. 
재구축 횟수가 많으면, 노란색 회전 원이 표시됩니다. 
가장 오른쪽 열은 현재 화면에 들어온 이후 위젯이 재구축된 횟수를 보여줍니다. 
재구축되지 않은 위젯의 경우, 단색 회색 원이 표시됩니다. 
그렇지 않으면 회색 회전 원이 표시됩니다.

:::secondary
이 스크린샷에 표시된 앱은 성능이 좋지 않도록 설계되었으며, 
재구축 프로파일러는 프레임에서 성능이 좋지 않을 수 있는 일이 무엇인지에 대한 단서를 제공합니다. 
위젯 재구축 프로파일러 자체는 성능이 좋지 않은 것에 대한 진단 도구가 아닙니다.
:::

이 기능의 목적은 위젯이 재구축될 때 사용자에게 알리는 것입니다. 
코드를 볼 때는 이런 일이 일어나고 있다는 것을 깨닫지 못할 수도 있습니다. 
예상치 못한 위젯이 재구축되는 경우, 
대규모 빌드 메서드를 여러 위젯으로 나누어 코드를 리팩토링해야 한다는 신호일 수 있습니다.

이 도구는 최소한 네 가지 일반적인 성능 문제를 디버깅하는 데 도움이 될 수 있습니다.

1. 전체 화면(또는 큰 화면 부분)이 단일 StatefulWidget에 의해 빌드되어, 불필요한 UI 빌드가 발생합니다. 
   UI를 더 작은 `build()` 함수로 더 작은 위젯으로 분할합니다.

2. 오프스크린 위젯이 다시 빌드됩니다. 
   예를 들어, ListView가 오프스크린으로 확장되는 긴 Column에 중첩되어 있는 경우 발생할 수 있습니다. 
   또는 오프스크린으로 확장되는 리스트에 대해 RepaintBoundary가 설정되지 않아, 
   전체 리스트가 다시 그려지는 경우입니다.

3. AnimatedBuilder의 `build()` 함수는 애니메이션이 필요하지 않은 하위 트리를 그려, 
   정적 객체의 불필요한 다시 빌드를 발생시킵니다.

4. Opacity 위젯이 위젯 트리에서 불필요하게 높은 위치에 배치됩니다. 
   또는 Opacity 위젯의 opacity 속성을 직접 조작하여, 
   Opacity 애니메이션을 만들어 위젯 자체와 하위 트리가 다시 빌드됩니다.

테이블의 줄을 클릭하면 위젯이 생성된 소스의 줄로 이동할 수 있습니다. 
코드가 실행되면, 회전하는 아이콘도 코드 창에 표시되어, 
어떤 재구축이 발생하고 있는지 시각화하는 데 도움이 됩니다.

여러 번 재구축한다고 해서 반드시 문제가 있는 것은 아닙니다. 
일반적으로 프로필 모드에서 앱을 이미 실행하고, 
성능이 원하는 수준이 아님을 확인한 경우에만, 
과도한 재구축에 대해 걱정해야 합니다.

그리고 _위젯 재구축 정보는 디버그 빌드에서만 사용할 수 있습니다_. 
프로필 빌드에서 실제 기기에서 앱의 성능을 테스트하지만, 
디버그 빌드에서 성능 문제를 디버그합니다.

## Flutter 코드 편집 팁 {:#editing-tips-for-flutter-code}

추가로 공유하고 싶은 팁이 있다면, [알려주세요][let us know]!

### 지원 및 빠른 수정 {:#assists-quick-fixes}

지원(Assists)은 특정 코드 식별자와 관련된 코드 변경입니다. 
이 중 다수는 노란색 전구 아이콘으로 표시된 Flutter 위젯 식별자에 커서를 놓았을 때 사용할 수 있습니다. 
전구를 클릭하거나, 키보드 단축키(Linux 및 Windows에서는 `Alt`+`Enter`, macOS에서는 `Option`+`Return`)를 사용하여, 여기에서 설명한 대로 지원을 호출할 수 있습니다.

![IntelliJ editing assists](/assets/images/docs/tools/android-studio/assists.gif){:width="100%"}

빠른 수정은 비슷하지만, 코드에 오류가 있고 이를 수정하는 데 도움이 될 수 있는 코드 조각과 함께 표시됩니다. 
빨간색 전구로 표시됩니다.

#### 새로운 위젯으로 래핑 지원 {:#wrap-with-new-widget-assist}

이 기능은 주변 위젯으로 위젯을 래핑하려는 경우, 
예를 들어 위젯을 `Row` 또는 `Column`로 래핑하려는 경우에 사용할 수 있습니다.

#### 새로운 위젯으로 위젯 리스트 래핑 지원 {:#wrap-widget-list-with-new-widget-assist}

위의 지원과 비슷하지만, 개별 위젯이 아닌 기존 위젯 리스트를 래핑하는 데 사용됩니다.

#### child를 children로 전환 지원 {:#convert-child-to-children-assist}

child 인수를 children 인수로 변경하고, 인수 값을 리스트로 묶습니다.

### 라이브 템플릿 {:#live-templates}

라이브 템플릿은 일반적인 코드 구조 입력 속도를 높이는 데 사용할 수 있습니다. 
접두사를 입력한 다음, 코드 완성 창에서 선택하여 호출합니다.

![IntelliJ live templates](/assets/images/docs/tools/android-studio/templates.gif){:width="100%"}

Flutter 플러그인에는 다음 템플릿이 포함되어 있습니다.

* 접두사 `stless`: `StatelessWidget`의 새 하위 클래스를 만듭니다.
* 접두사 `stful`: `StatefulWidget`의 새 하위 클래스와 연관된 State 하위 클래스를 만듭니다.
* 접두사 `stanim`: `AnimationController`로 초기화된 필드를 포함하여, `StatefulWidget`의 새 하위 클래스와 
  연관된 State 하위 클래스를 만듭니다.

**Settings > Editor > Live Templates**에서 커스텀 템플릿을 정의할 수도 있습니다.

### 키보드 단축키 {:#keyboard-shortcuts}

**핫 리로드**

Linux(키맵 _Default for XWin_)와 Windows에서 키보드 단축키는 `Control`+`Alt`+`;`와 `Control`+`Backslash`입니다.

macOS(키맵 _Mac OS X 10.5+ copy_)에서 키보드 단축키는 `Command`+`Option`와 `Command`+`Backslash`입니다.

키보드 매핑은 IDE 환경 설정/설정에서 변경할 수 있습니다. 
*Keymap*을 선택한 다음 오른쪽 상단 모서리에 있는 검색 상자에 _flutter_ 를 입력합니다. 
변경하려는 바인딩을 마우스 오른쪽 버튼으로 클릭하고 _Add Keyboard Shortcut_ 를 클릭합니다.

![IntelliJ settings keymap](/assets/images/docs/tools/android-studio/keymap-settings-flutter-plugin.png){:width="100%"}

### 핫 리로드 vs. 핫 리스타트 {:#hot-reload-vs-hot-restart}

핫 리로드는 업데이트된 소스 코드 파일을 실행 중인 Dart VM(가상 머신)에 주입하여 작동합니다. 
여기에는 새 클래스를 추가하는 것뿐만 아니라, 
기존 클래스에 메서드와 필드를 추가하고 기존 함수를 변경하는 것도 포함됩니다. 
그러나 몇 가지 타입의 코드 변경은 핫 리로드할 수 없습니다.

* 전역 변수 initializer
* 정적 필드 initializer
* 앱의 `main()` 메서드

이러한 변경의 경우 디버깅 세션을 종료하지 않고도, 애플리케이션을 완전히 다시 시작할 수 있습니다. 
핫 리로드를 수행하려면, 중지 버튼을 클릭하지 말고, 
실행 버튼(실행 세션에 있는 경우) 또는 디버그 버튼(디버그 세션에 있는 경우)을 다시 클릭하거나, 
Shift 키를 누른 채 '핫 리로드' 버튼을 클릭합니다.

## IDE 전체 지원을 통해 Android Studio에서 Android 코드 편집 {:#android-ide}

Flutter 프로젝트의 루트 디렉토리를 열면, 모든 Android 파일이 IDE에 노출되지 않습니다. 
Flutter 앱에는 `android`라는 하위 디렉토리가 있습니다. 
Android Studio에서 이 하위 디렉토리를 별도의 프로젝트로 열면, 
IDE에서 모든 Android 파일(Gradle 스크립트 등)의 편집 및 리팩토링을 완벽하게 지원할 수 있습니다.

Android Studio에서 전체 프로젝트를 Flutter 앱으로 이미 열었다면, 
IDE에서 편집하기 위해 Android 파일을 직접 여는 두 가지 동등한 방법이 있습니다. 
이 작업을 시도하기 전에 Android Studio와 Flutter 플러그인의 최신 버전을 사용하고 있는지 확인하세요.

* ["project view"][]에서, flutter 앱 루트 바로 아래에 `android`라는 하위 디렉토리가 보일 것입니다. 
  여기서 마우스 오른쪽 버튼을 클릭한 다음, 
  **Flutter > Open Android module in Android Studio**를 선택합니다.
* 또는 `android` 하위 디렉토리에 있는 파일을 편집을 위해 열 수 있습니다. 
  그러면 편집기 상단에 **Open for Editing in Android Studio**라는 링크가 있는 
  "Flutter commands" 배너가 보일 것입니다. 해당 링크를 클릭합니다.

두 옵션 모두 Android Studio에서 두 번째 프로젝트를 열 때 별도의 창을 사용하거나, 
기존 창을 새 프로젝트로 바꿀 수 있는 옵션을 제공합니다. 어느 옵션이든 괜찮습니다.

Android Studio에서 아직 Flutter 프로젝트를 열지 않은 경우, 
처음부터 Android 파일을 자체 프로젝트로 열 수 있습니다.

1. 시작 시작 화면에서 **Open an existing Android Studio Project**를 클릭하거나,
   Android Studio가 이미 열려 있는 경우, **File > Open**를 클릭합니다.
2. Flutter 앱 루트 바로 아래에 있는 `android` 하위 디렉터리를 엽니다. 
   예를 들어, 프로젝트 이름이 `flutter_app`인 경우 `flutter_app/android`를 엽니다.

Flutter 앱을 아직 실행하지 않은 경우 `android` 프로젝트를 열 때, 
Android Studio에서 빌드 오류를 보고할 수 있습니다. 
앱의 루트 디렉터리에서 `flutter pub get`을 실행하고, 
**Build > Make**를 선택하여 프로젝트를 다시 빌드하여 수정합니다.

## IntelliJ IDEA에서 Android 코드 편집 {:#edit-android-code}

IntelliJ IDEA에서 Android 코드 편집을 활성화하려면, Android SDK의 위치를 ​​구성해야 합니다.

1. **Preferences > Plugins**에서 아직 활성화하지 않았다면, **Android Support**를 활성화합니다.
2. Project 뷰에서 **android** 폴더를 마우스 오른쪽 버튼으로 클릭하고, **Open Module Settings**를 선택합니다.
3. **Sources** 탭에서 **Language level** 필드를 찾아, 레벨 8 이상을 선택합니다.
4. **Dependencies** 탭에서 **Module SDK** 필드를 찾아, Android SDK를 선택합니다. 
   SDK가 나열되지 않으면 **New**를 클릭하고, Android SDK의 위치를 ​​지정합니다. 
   Flutter에서 사용하는 것과 일치하는 Android SDK를 선택해야 합니다. (`flutter doctor`에서 보고한 대로)
5. **OK**를 클릭합니다.

## 문제 해결 {:#troubleshooting}

### 알려진 문제 및 피드백 {:#known-issues-and-feedback}

경험에 영향을 줄 수 있는 중요한 알려진 문제는 [Flutter 플러그인 README][Flutter plugin README] 파일에 기록되어 있습니다.

알려진 모든 버그는 이슈 트래커에서 추적됩니다.

* Flutter 플러그인: [GitHub 이슈 트래커][GitHub issue tracker]
* Dart 플러그인: [JetBrains YouTrack][JetBrains YouTrack]

버그/문제와 기능 요청에 대한 피드백을 환영합니다. 새로운 이슈를 제출하기 전에:

* 이슈 트래커에서 빠르게 검색하여 문제가 이미 추적되고 있는지 확인합니다.
* 플러그인의 최신 버전으로 [업데이트](#updating)했는지 확인합니다.

새로운 이슈를 제출할 때 [`flutter doctor`][]의 출력을 포함합니다.

[DevTools]: /tools/devtools
[GitHub issue tracker]: {{site.repo.flutter}}-intellij/issues
[JetBrains YouTrack]: https://youtrack.jetbrains.com/issues?q=%23dart%20%23Unresolved
[`flutter doctor`]: /resources/bug-reports#provide-some-flutter-diagnostics
[Debugging Flutter apps]: /testing/debugging
[Flutter plugin README]: {{site.repo.flutter}}-intellij/blob/master/README.md
["project view"]: {{site.android-dev}}/studio/projects/#ProjectView
[let us know]: {{site.repo.this}}/issues/new
[Running DevTools from Android Studio]: /tools/devtools/android-studio
[Hot reload]: /tools/hot-reload
[Timeline view]: /tools/devtools/performance
