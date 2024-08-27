---
# title: Automatic platform adaptations
title: 자동 플랫폼 적응
# description: Learn more about Flutter's platform adaptiveness.
description: Flutter의 플랫폼 적응성에 대해 자세히 알아보세요.
---

## 적응 철학 {:#adaptation-philosophy}

일반적으로, 플랫폼 적응성에는 두 가지 경우가 있습니다.

1. OS 환경의 동작(예: 텍스트 편집 및 스크롤)이며, 다른 동작이 발생하면 '잘못된' 것입니다.
2. OEM의 SDK를 사용하여 앱에서 기존에 구현된 것입니다.
   (예: iOS에서 병렬 탭 사용 또는 Android에서 [`android.app.AlertDialog`][] 표시).

이 글에서는, 주로 Android와 iOS에서 Flutter가 제공하는 케이스 1의 자동 적응에 대해 다룹니다.

케이스 2의 경우, Flutter는 플랫폼 규칙의 적절한 효과를 생성하는 수단을 번들로 제공하지만, 
앱 디자인 선택이 필요할 때 자동으로 적응하지 않습니다. 
논의는 [문제 #8410][issue #8410] 및 [Material/Cupertino 적응형 위젯 문제 정의][Material/Cupertino adaptive widget problem definition]를 참조하세요.

Android 및 iOS에서 서로 다른 정보 아키텍처 구조를 사용하지만 동일한 콘텐츠 코드를 공유하는 앱의 예는 [platform_design 코드 샘플][platform_design code samples]을 참조하세요.

:::secondary
케이스 2를 다루는 예비 가이드(Preliminary guides)가 UI 컴포넌트 섹션에 추가되고 있습니다. 
[문제 #8427][8427]에 코멘트를 달아 추가 가이드를 요청할 수 있습니다.
:::

[`android.app.AlertDialog`]: {{site.android-dev}}/reference/android/app/AlertDialog.html
[issue #8410]: {{site.repo.flutter}}/issues/8410#issuecomment-468034023
[Material/Cupertino adaptive widget problem definition]: https://bit.ly/flutter-adaptive-widget-problem
[platform_design code samples]: {{site.repo.samples}}/tree/main/platform_design

## 페이지 네비게이션 {:#page-navigation}

Flutter는 안드로이드와 iOS에서 볼 수 있는 네비게이션 패턴을 제공하고, 
네비게이션 애니메이션을 현재 플랫폼에 맞게 자동으로 조정합니다.

### 네비게이션 전환 {:#navigation-transitions}

**Android**에서, 기본 [`Navigator.push()`][] 전환은, 
일반적으로 bottom-up 애니메이션 변형이 하나인, [`startActivity()`][]를 모델로 합니다.

**iOS**에서:

* 기본 [`Navigator.push()`][] API는 로케일의 RTL 설정에 따라 끝에서 시작까지(end-to-start) 애니메이션을 적용하는,
  iOS Show/Push 스타일 전환을 생성합니다. 
  새 경로 뒤에 있는 페이지도 iOS와 같은 방향으로 패럴랙스 슬라이드합니다.
* [`PageRoute.fullscreenDialog`][]가 true인 페이지 경로를 푸시할 때, 
  별도의 bottom-up 전환 스타일이 있습니다. 
  이는 iOS의 Present/Modal 스타일 전환을 나타내며, 일반적으로 전체 화면 모달 페이지에서 사용됩니다.

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img style="border-radius: 12px;" src="/assets/images/docs/platform-adaptations/navigation-android.gif" class="figure-img img-fluid" alt="An animation of the bottom-up page transition on Android" />
        <figcaption class="figure-caption">
          안드로이드 페이지 전환
        </figcaption>
      </figure>
    </div>
    <div class="col-sm text-center">
      <figure class="figure">
        <img style="border-radius: 22px;" src="/assets/images/docs/platform-adaptations/navigation-ios.gif" class="figure-img img-fluid" alt="An animation of the end-start style push page transition on iOS" />
        <figcaption class="figure-caption">
          iOS 푸시 전환
        </figcaption>
      </figure>
    </div>
    <div class="col-sm text-center">
      <figure class="figure">
        <img style="border-radius: 22px;" src="/assets/images/docs/platform-adaptations/navigation-ios-modal.gif" class="figure-img img-fluid" alt="An animation of the bottom-up style present page transition on iOS" />
        <figcaption class="figure-caption">
          iOS present 전환
        </figcaption>
      </figure>
    </div>
  </div>
</div>

[`Navigator.push()`]: {{site.api}}/flutter/widgets/Navigator/push.html
[`startActivity()`]: {{site.android-dev}}/reference/kotlin/android/app/Activity#startactivity
[`PageRoute.fullscreenDialog`]: {{site.api}}/flutter/widgets/PageRoute-class.html

### 플랫폼별 전환 세부 정보 {:#platform-specific-transition-details}

**Android**에서, Flutter는 [`ZoomPageTransitionsBuilder`][] 애니메이션을 사용합니다. 
사용자가 항목을 탭하면, UI가 해당 항목이 있는 화면으로 확대됩니다. 
사용자가 탭하여 뒤로 돌아가면, UI가 이전 화면으로 축소됩니다.

**iOS**에서, 푸시 스타일 전환을 사용하면, 
Flutter의 번들 [`CupertinoNavigationBar`][] 및 [`CupertinoSliverNavigationBar`][] 네비게이션 바가 
각 하위 컴포넌트를 다음 또는 이전 페이지의 `CupertinoNavigationBar` 또는 `CupertinoSliverNavigationBar`에 있는
해당 하위 컴포넌트로 자동으로 애니메이션화합니다.

<div class="container">
  <div class="row">
    <div class="col-sm">
      <figure class="figure text-center">
      <img style="border-radius: 12px; height: 400px;" class="figure-img img-fluid" height="400" width="185" alt="An animation of the page transition on Android" src="/assets/images/docs/platform-adaptations/android-zoom-animation.png" />
        <figcaption class="figure-caption">
          Android
        </figcaption>
      </figure>
    </div>
    <div class="col-sm">
      <figure class="figure text-center">
        <img style="border-radius: 22px;" src="/assets/images/docs/platform-adaptations/navigation-ios-nav-bar.gif" class="figure-img img-fluid" alt="An animation of the nav bar transitions during a page transition on iOS" />
        <figcaption class="figure-caption">
          iOS 네비게이션 바
        </figcaption>
      </figure>
    </div>
  </div>
</div>

[`ZoomPageTransitionsBuilder`]: {{site.api}}/flutter/material/ZoomPageTransitionsBuilder-class.html
[`CupertinoNavigationBar`]: {{site.api}}/flutter/cupertino/CupertinoNavigationBar-class.html
[`CupertinoSliverNavigationBar`]: {{site.api}}/flutter/cupertino/CupertinoSliverNavigationBar-class.html

### 뒤로 네비게이션 {:#back-navigation}

**Android**에서, OS 뒤로 가기 버튼은, 기본적으로, Flutter로 전송되고 [`WidgetsApp`][]의 Navigator의 상단 경로를 팝합니다.

**iOS**에서, 가장자리 스와이프 제스처를 사용하여 상단 경로를 팝할 수 있습니다.

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img style="border-radius: 12px;" src="/assets/images/docs/platform-adaptations/navigation-android-back.gif" class="figure-img img-fluid" alt="A page transition triggered by the Android back button" />
        <figcaption class="figure-caption">
          Android 뒤로 가기 버튼
        </figcaption>
      </figure>
    </div>
    <div class="col-sm">
      <figure class="figure text-center">
        <img style="border-radius: 22px;" src="/assets/images/docs/platform-adaptations/navigation-ios-back.gif" class="figure-img img-fluid" alt="A page transition triggered by an iOS back swipe gesture" />
        <figcaption class="figure-caption">
          iOS 뒤로 스와이프 제스처
        </figcaption>
      </figure>
    </div>
  </div>
</div>

[`WidgetsApp`]: {{site.api}}/flutter/widgets/WidgetsApp-class.html

## 스크롤 {:#scrolling}

스크롤링은 플랫폼의 모양과 느낌에서 중요한 부분이며, Flutter는 현재 플랫폼에 맞게 스크롤링 동작을 자동으로 조정합니다.

### 물리 시뮬레이션 {:#physics-simulation}

Android와 iOS는 모두 말로 설명하기 어려운 복잡한 스크롤링 물리 시뮬레이션을 가지고 있습니다. 
일반적으로, iOS의 scrollable은 무게와 dynamic 마찰이 더 크지만, Android는 static 마찰이 더 큽니다. 
따라서, iOS는 더 점진적으로 고속으로 움직이지만 덜 갑자기 멈추고 느린 속도에서는 더 미끄럽습니다.

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img src="/assets/images/docs/platform-adaptations/scroll-soft.gif" class="figure-img img-fluid rounded" alt="A soft fling where the iOS scrollable slid longer at lower speed than Android" />
        <figcaption class="figure-caption">
          소프트 플링(Soft fling) 비교
        </figcaption>
      </figure>
    </div>
    <div class="col-sm">
      <figure class="figure text-center">
        <img src="/assets/images/docs/platform-adaptations/scroll-medium.gif" class="figure-img img-fluid rounded" alt="A medium force fling where the Android scrollable reached speed faster and stopped more abruptly after reaching a longer distance" />
        <figcaption class="figure-caption">
          중간 플링 비교
        </figcaption>
      </figure>
    </div>
    <div class="col-sm">
      <figure class="figure text-center">
        <img src="/assets/images/docs/platform-adaptations/scroll-strong.gif" class="figure-img img-fluid rounded" alt="A strong fling where the Android scrollable reach speed faster and reached significantly more distance" />
        <figcaption class="figure-caption">
          강한 플링 비교
        </figcaption>
      </figure>
    </div>
  </div>
</div>

### 오버스크롤 동작 {:#overscroll-behavior}

**Android**에서, scrollable의 가장자리를 지나 스크롤하면, [오버스크롤 글로우 표시기][overscroll glow indicator]가 표시됩니다. (현재 Material 테마의 색상에 따라 다름)

**iOS**에서, scrollable의 가장자리를 지나 스크롤하면, 저항이 증가하면서 [오버스크롤][overscrolls]되고 다시 되돌아갑니다.

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img src="/assets/images/docs/platform-adaptations/scroll-overscroll.gif" class="figure-img img-fluid rounded" alt="Android and iOS scrollables being flung past their edge and exhibiting platform specific overscroll behavior" />
        <figcaption class="figure-caption">
          동적(Dynamic) 오버스크롤 비교
        </figcaption>
      </figure>
    </div>
    <div class="col-sm text-center">
      <figure class="figure">
        <img src="/assets/images/docs/platform-adaptations/scroll-static-overscroll.gif" class="figure-img img-fluid rounded" alt="Android and iOS scrollables being overscrolled from a resting position and exhibiting platform specific overscroll behavior" />
        <figcaption class="figure-caption">
          정적(Static) 오버스크롤 비교
        </figcaption>
      </figure>
    </div>
  </div>
</div>

[overscroll glow indicator]: {{site.api}}/flutter/widgets/GlowingOverscrollIndicator-class.html
[overscrolls]: {{site.api}}/flutter/widgets/BouncingScrollPhysics-class.html

### 모멘텀 {:#momentum}

**iOS**에서, 같은 방향으로 반복적으로 플링을 하면 모멘텀이 쌓이고, 연속적으로 플링을 할 때마다 속도가 더 빨라집니다. 
Android에는 이와 동일한 동작이 없습니다.

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img src="/assets/images/docs/platform-adaptations/scroll-momentum-ios.gif" class="figure-img img-fluid rounded" alt="Repeated scroll flings building momentum on iOS" />
        <figcaption class="figure-caption">
          iOS 스크롤 모멘텀
        </figcaption>
      </figure>
    </div>
  </div>
</div>

### 맨 위로 돌아가기 {:#return-to-top}

**iOS**에서, OS 상태 표시줄을 탭하면 primary 스크롤 컨트롤러가 맨 위 위치로 스크롤됩니다. 
Android에는 동일한 동작이 없습니다.

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img style="border-radius: 22px;" src="/assets/images/docs/platform-adaptations/scroll-tap-to-top-ios.gif" class="figure-img img-fluid" alt="Tapping the status bar scrolls the primary scrollable back to the top" />
        <figcaption class="figure-caption">
          iOS 상태 표시줄을 탭하여 맨 위로 이동
        </figcaption>
      </figure>
    </div>
  </div>
</div>

## 타이포그래피 {:#typography}

Material 패키지를 사용할 때, 타이포그래피는 플랫폼에 적합한 글꼴 패밀리로 자동 기본 설정됩니다. 
Android는 Roboto 글꼴을 사용합니다. iOS는 San Francisco 글꼴을 사용합니다.

Cupertino 패키지를 사용할 때, [기본 테마][default theme]는 San Francisco 글꼴을 사용합니다.

San Francisco 글꼴 라이선스는 iOS, macOS 또는 tvOS에서 실행되는 소프트웨어로 사용이 제한됩니다. 
따라서, 플랫폼이 iOS로 디버그 재정의되거나 기본 Cupertino 테마가 사용되는 경우, 
Android에서 실행할 때 대체 글꼴이 사용됩니다.

Material 위젯의 텍스트 스타일을 iOS의 기본 텍스트 스타일과 일치하도록 조정할 수 있습니다. 
위젯별 예는 [UI 컴포넌트 섹션](#ui-components)에서 확인할 수 있습니다.

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img src="/assets/images/docs/platform-adaptations/typography-android.png" class="figure-img img-fluid rounded" alt="Roboto font on Android" />
        <figcaption class="figure-caption">
          Android에서의 Roboto
        </figcaption>
      </figure>
    </div>
    <div class="col-sm">
      <figure class="figure text-center">
        <img src="/assets/images/docs/platform-adaptations/typography-ios.png" class="figure-img img-fluid rounded" alt="San Francisco font on iOS" />
        <figcaption class="figure-caption">
          iOS에서의 San Francisco
        </figcaption>
      </figure>
    </div>
  </div>
</div>

[default theme]: {{site.repo.flutter}}/blob/main/packages/flutter/lib/src/cupertino/text_theme.dart

## Iconography {:#iconography}

Material 패키지를 사용할 때, 특정 아이콘은 플랫폼에 따라 자동으로 다른 그래픽을 표시합니다. 
예를 들어, 오버플로 버튼의 세 개의 점은, iOS에서는 수평이고 Android에서는 수직입니다. 
뒤로 가기 버튼은 iOS에서는 단순한 chevron이고, Android에서는 stem/shaft 입니다.

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img src="/assets/images/docs/platform-adaptations/iconography-android.png" class="figure-img img-fluid rounded" alt="Android appropriate icons" />
        <figcaption class="figure-caption">
          Android에서의 아이콘
        </figcaption>
      </figure>
    </div>
    <div class="col-sm">
      <figure class="figure text-center">
        <img src="/assets/images/docs/platform-adaptations/iconography-ios.png" class="figure-img img-fluid rounded" alt="iOS appropriate icons" />
        <figcaption class="figure-caption">
          iOS에서의 아이콘
        </figcaption>
      </figure>
    </div>
  </div>
</div>

또한 material 라이브러리는 [`Icons.adaptive`][]를 통해, 플랫폼-적응형 아이콘 세트를 제공합니다.

[`Icons.adaptive`]: {{site.api}}/flutter/material/PlatformAdaptiveIcons-class.html

## 햅틱 피드백 {:#haptic-feedback}

Material 및 Cupertino 패키지는 특정 시나리오에서 플랫폼에 적합한 햅틱 피드백을 자동으로 트리거합니다.

예를 들어, 텍스트 필드를 길게 눌러 단어를 선택하면, Android에서는 'buzz' 진동이 트리거되지만, iOS에서는 그렇지 않습니다.

iOS에서 피커 항목을 스크롤하면, 'light impact'이 발생하고, Android에서는 피드백이 없습니다.

## 텍스트 편집 {:#text-editing}

Material과 Cupertino Text Input 필드는 모두 철자 검사를 지원하고, 
플랫폼에 맞는 적절한 철자 검사 구성과 적절한 철자 검사 메뉴 및 강조 색상을 사용하도록 조정합니다.

Flutter는 또한 현재 플랫폼과 일치하도록 텍스트 필드의 콘텐츠를 편집하는 동안 아래의 조정을 수행합니다.

### 키보드 제스처 네비게이션 {:#keyboard-gesture-navigation}

**Android**에서는 소프트 키보드의 <kbd>스페이스</kbd> 키에서 수평 스와이프를 하면, 
Material 및 Cupertino 텍스트 필드에서 커서를 이동할 수 있습니다.

3D Touch 기능이 있는 **iOS** 기기에서는, 소프트 키보드에서 force-누름-드래그 제스처를 하면, 
플로팅 커서를 통해 2D에서 커서를 이동할 수 있습니다. 
이는 Material 및 Cupertino 텍스트 필드에서 모두 작동합니다.

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img src="/assets/images/docs/platform-adaptations/text-keyboard-move-android.gif" class="figure-img img-fluid rounded" alt="Moving the cursor via the space key on Android" />
        <figcaption class="figure-caption">
          Android 스페이스 키 커서 이동
        </figcaption>
      </figure>
    </div>
    <div class="col-sm">
      <figure class="figure text-center">
        <img src="/assets/images/docs/platform-adaptations/text-keyboard-move-ios.gif" class="figure-img img-fluid rounded" alt="Moving the cursor via 3D Touch drag on the keyboard on iOS" />
        <figcaption class="figure-caption">
          iOS 3D 터치 드래그 커서 이동
        </figcaption>
      </figure>
    </div>
  </div>
</div>

### 텍스트 선택 툴바 {:#text-selection-toolbar}

**Android의 Material**을 사용하면, 텍스트 필드에서 텍스트를 선택하면 Android 스타일 선택 툴바가 표시됩니다.

**iOS의 Material**을 사용하거나 **Cupertino**를 사용하는 경우, 텍스트 필드에서 텍스트를 선택하면 iOS 스타일 선택 툴바가 표시됩니다.

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img src="/assets/images/docs/platform-adaptations/text-toolbar-android.png" class="figure-img img-fluid rounded" alt="Android appropriate text toolbar" />
        <figcaption class="figure-caption">
          Android 텍스트 선택 툴바
        </figcaption>
      </figure>
    </div>
    <div class="col-sm">
      <figure class="figure text-center">
        <img src="/assets/images/docs/platform-adaptations/text-toolbar-ios.png" class="figure-img img-fluid rounded" alt="iOS appropriate text toolbar" />
        <figcaption class="figure-caption">
          iOS 텍스트 선택 툴바
        </figcaption>
      </figure>
    </div>
  </div>
</div>

### 단일 탭 제스처 {:#single-tap-gesture}

**Android의 Material**을 사용하면, 텍스트 필드를 한 번 탭하면 커서가 탭한 위치에 놓입니다.

축소된 텍스트 선택 영역에는 드래그 가능한 핸들이 표시되어, 커서를 나중에 이동할 수 있습니다.

**iOS의 Material**을 사용하거나 **Cupertino**를 사용하는 경우, 
텍스트 필드를 한 번 탭하면 커서가 탭한 단어의 가장 가까운 가장자리에 놓입니다.

축소된 텍스트 선택 영역에는 iOS에서 드래그 가능한 핸들이 없습니다.

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img src="/assets/images/docs/platform-adaptations/text-single-tap-android.gif" class="figure-img img-fluid rounded" alt="Moving the cursor to the tapped position on Android" />
        <figcaption class="figure-caption">
          Android 탭
        </figcaption>
      </figure>
    </div>
    <div class="col-sm">
      <figure class="figure text-center">
        <img src="/assets/images/docs/platform-adaptations/text-single-tap-ios.gif" class="figure-img img-fluid rounded" alt="Moving the cursor to the nearest edge of the tapped word on iOS" />
        <figcaption class="figure-caption">
          iOS 탭
        </figcaption>
      </figure>
    </div>
  </div>
</div>

### 길게 누르기 제스처 {:#long-press-gesture}

**Android의 Material**을 사용하면, 길게 누르면 길게 누른 단어가 선택됩니다. 
놓으면 선택 툴바가 표시됩니다.

**iOS의 Material** 또는 **Cupertino**를 사용하는 경우, 길게 누르면 커서가 길게 누른 위치에 놓입니다. 
놓으면 선택 툴바가 표시됩니다.

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img src="/assets/images/docs/platform-adaptations/text-long-press-android.gif" class="figure-img img-fluid rounded" alt="Selecting a word via long press on Android" />
        <figcaption class="figure-caption">
          Android 길게 누르기
        </figcaption>
      </figure>
    </div>
    <div class="col-sm">
      <figure class="figure text-center">
        <img src="/assets/images/docs/platform-adaptations/text-long-press-ios.gif" class="figure-img img-fluid rounded" alt="Selecting a position via long press on iOS" />
        <figcaption class="figure-caption">
          iOS 길게 누르기
        </figcaption>
      </figure>
    </div>
  </div>
</div>

### 길게 누르고 드래그 제스처 {:#long-press-drag-gesture}

**Android의 Material**을 사용하면, 길게 누른 채로 드래그하면 선택한 단어가 확장됩니다.

**iOS의 Material**을 사용하거나 **Cupertino**를 사용하는 경우, 길게 누른 채로 드래그하면 커서가 이동합니다.

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img src="/assets/images/docs/platform-adaptations/text-long-press-drag-android.gif" class="figure-img img-fluid rounded" alt="Expanding word selection via long press drag on Android" />
        <figcaption class="figure-caption">
          Android 길게 누르고 드래그
        </figcaption>
      </figure>
    </div>
    <div class="col-sm">
      <figure class="figure text-center">
        <img src="/assets/images/docs/platform-adaptations/text-long-press-drag-ios.gif" class="figure-img img-fluid rounded" alt="Moving the cursor via long press drag on iOS" />
        <figcaption class="figure-caption">
          iOS 길게 누르고 드래그
        </figcaption>
      </figure>
    </div>
  </div>
</div>

### 더블 탭 제스처 {:#double-tap-gesture}

Android와 iOS 모두에서, 두 번 탭하면 두 번 탭한 단어가 선택되고 선택 도구 모음이 표시됩니다.

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img src="/assets/images/docs/platform-adaptations/text-double-tap-android.gif" class="figure-img img-fluid rounded" alt="Selecting a word via double tap on Android" />
        <figcaption class="figure-caption">
          Android 더블 탭
        </figcaption>
      </figure>
    </div>
    <div class="col-sm">
      <figure class="figure text-center">
        <img src="/assets/images/docs/platform-adaptations/text-double-tap-ios.gif" class="figure-img img-fluid rounded" alt="Selecting a word via double tap on iOS" />
        <figcaption class="figure-caption">
          iOS 더블 탭
        </figcaption>
      </figure>
    </div>
  </div>
</div>

## UI 컴포넌트 {:#ui-components}

이 섹션에는 iOS에서 자연스럽고 매력적인 경험을 제공하기 위해, 
Material 위젯을 조정하는 방법에 대한 예비(preliminary) 권장 사항이 포함되어 있습니다. 
[문제 #8427][8427]에 대한 피드백을 환영합니다.

[8427]: {{site.repo.this}}/issues/8427

### .adaptive() 생성자가 있는 위젯 {:#widgets-with-adaptive-constructors}

여러 위젯은 `.adaptive()` 생성자를 지원합니다. 
다음 표에는 이러한 위젯이 나와 있습니다. 
적응형 생성자는 앱이 iOS 기기에서 실행될 때, 해당 Cupertino 컴포넌트를 대체합니다.

다음 표의 위젯은 주로(primarily) 입력, 선택 및 시스템 정보 표시에 사용됩니다. 
이러한 컨트롤은 운영 체제와 긴밀하게 통합되어 있기 때문에, 사용자는 이를 인식하고 응답하도록 훈련되었습니다. 
따라서, 플랫폼 규칙을 따르는 것이 좋습니다.

| Material 위젯 | Cupertino 위젯 | 적응형 생성자 |
|---|---|---|
|<img width=160 src="/assets/images/docs/platform-adaptations/m3-switch.png" class="figure-img img-fluid rounded" alt="Switch in Material 3" /><br/>`Switch`|<img src="/assets/images/docs/platform-adaptations/hig-switch.png" class="figure-img img-fluid rounded" alt="Switch in HIG" /><br/>`CupertinoSwitch`|[`Switch.adaptive()`][]|
|<img src="/assets/images/docs/platform-adaptations/m3-slider.png" width =160 class="figure-img img-fluid rounded" alt="Slider in Material 3" /><br/>`Slider`|<img src="/assets/images/docs/platform-adaptations/hig-slider.png"  width =160  class="figure-img img-fluid rounded" alt="Slider in HIG" /><br/>`CupertinoSlider`|[`Slider.adaptive()`][]|
|<img src="/assets/images/docs/platform-adaptations/m3-progress.png" width = 100 class="figure-img img-fluid rounded" alt="Circular progress indicator in Material 3" /><br/>`CircularProgressIndicator`|<img src="/assets/images/docs/platform-adaptations/hig-progress.png" class="figure-img img-fluid rounded" alt="Activity indicator in HIG" /><br/>`CupertinoActivityIndicator`|[`CircularProgressIndicator.adaptive()`][]|
| <img src="/assets/images/docs/platform-adaptations/m3-checkbox.png" class="figure-img img-fluid rounded" alt=" Checkbox in Material 3" /> <br/>`Checkbox`| <img src="/assets/images/docs/platform-adaptations/hig-checkbox.png" class="figure-img img-fluid rounded" alt="Checkbox in HIG" /> <br/> `CupertinoCheckbox`|[`Checkbox.adaptive()`][]|
|<img src="/assets/images/docs/platform-adaptations/m3-radio.png" class="figure-img img-fluid rounded" alt="Radio in Material 3" /> <br/>`Radio`|<img src="/assets/images/docs/platform-adaptations/hig-radio.png" class="figure-img img-fluid rounded" alt="Radio in HIG" /><br/>`CupertinoRadio`|[`Radio.adaptive()`][]|
|<img src="/assets/images/docs/platform-adaptations/m3-alert.png" class="figure-img img-fluid rounded" alt="AlertDialog in Material 3" /> <br/>`AlertDialog`|<img src="/assets/images/docs/platform-adaptations/cupertino-alert.png" class="figure-img img-fluid rounded" alt="AlertDialog in HIG" /><br/>`CupertinoAlertDialog`|[`AlertDialog.adaptive()`][]|

[`AlertDialog.adaptive()`]: {{site.api}}/flutter/material/AlertDialog/AlertDialog.adaptive.html
[`Checkbox.adaptive()`]: {{site.api}}/flutter/material/Checkbox/Checkbox.adaptive.html
[`Radio.adaptive()`]: {{site.api}}/flutter/material/Radio/Radio.adaptive.html
[`Switch.adaptive()`]: {{site.api}}/flutter/material/Switch/Switch.adaptive.html
[`Slider.adaptive()`]: {{site.api}}/flutter/material/Slider/Slider.adaptive.html
[`CircularProgressIndicator.adaptive()`]: {{site.api}}/flutter/material/CircularProgressIndicator/CircularProgressIndicator.adaptive.html

### 상단 앱 바 및 네비게이션 바 {:#top-app-bar-and-navigation-bar}

Android 12부터, 상단 앱 바의 기본 UI는 [Material 3][mat-appbar]에 정의된 디자인 가이드라인을 따릅니다. 
iOS에서는 "네비게이션 바"라는 동등한 구성 요소가 [Apple의 인간 인터페이스 가이드라인][hig-appbar](HIG)에 정의되어 있습니다.

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img src="/assets/images/docs/platform-adaptations/mat-appbar.png" 
        class="figure-img img-fluid rounded" alt=" Top App Bar in Material 3 " />
        <figcaption class="figure-caption">
          Material 3의 상단 앱 바
        </figcaption>
      </figure>
    </div>
    <div class="col-sm">
      <figure class="figure text-center">
        <img src="/assets/images/docs/platform-adaptations/hig-appbar.png" 
        class="figure-img img-fluid rounded" alt="Navigation Bar in Human Interface Guidelines" />
        <figcaption class="figure-caption">
          Human Interface Guidelines에서 네비게이션 바
        </figcaption>
      </figure>
    </div>
  </div>
</div>

Flutter 앱의 앱 바의 특정 속성은, 시스템 아이콘과 페이지 전환과 같이, 조정되어야 합니다. 
이러한 속성은 Material `AppBar` 및 `SliverAppBar` 위젯을 사용할 때, 이미 자동으로 조정됩니다. 
아래에 표시된 것처럼, 이러한 위젯의 속성을 추가로 커스터마이즈하여, iOS 플랫폼 스타일과 더 잘 일치시킬 수도 있습니다.

```dart
// 텍스트 테마를 iOS 스타일로 매핑
TextTheme cupertinoTextTheme = TextTheme(
    headlineMedium: CupertinoThemeData()
        .textTheme
        .navLargeTitleTextStyle
         // 간격에 대한 작은 버그를 수정합니다.
        .copyWith(letterSpacing: -1.5),
    titleLarge: CupertinoThemeData().textTheme.navTitleTextStyle)
...

// iOS 기기에서 iOS 텍스트 테마 사용
ThemeData(
      textTheme: Platform.isIOS ? cupertinoTextTheme : null,
      ...
)
...

// AppBar 속성 수정
AppBar(
        surfaceTintColor: Platform.isIOS ? Colors.transparent : null,
        shadowColor: Platform.isIOS ? CupertinoColors.darkBackgroundGray : null,
        scrolledUnderElevation: Platform.isIOS ? .1 : null,
        toolbarHeight: Platform.isIOS ? 44 : null,
        ...
      ),
```

하지만, 앱 바는 페이지의 다른 콘텐츠와 함께 표시되므로, 나머지 애플리케이션과 일관성(cohesive)이 있는 한 스타일을 조정하는 것이 좋습니다. 
[앱 바 조정에 대한 GitHub 토론][appbar-post]에서 추가 코드 샘플과 추가 설명을 볼 수 있습니다.

[mat-appbar]: {{site.material}}/components/top-app-bar/overview
[hig-appbar]: {{site.apple-dev}}/design/human-interface-guidelines/components/navigation-and-search/navigation-bars/
[appbar-post]: {{site.repo.uxr}}/discussions/93

### 하단 네비게이션 바 {:#bottom-navigation-bars}

Android 12부터, 하단 네비게이션 바의 기본 UI는 [Material 3][mat-navbar]에 정의된 디자인 가이드라인을 따릅니다. 
iOS에서는, "탭 바"이라는 동등한 구성 요소가 [Apple의 Human Interface Guidelines][hig-tabbar](HIG)에 정의되어 있습니다.

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img src="/assets/images/docs/platform-adaptations/mat-navbar.png" 
        class="figure-img img-fluid rounded" alt="Bottom Navigation Bar in Material 3 " />
        <figcaption class="figure-caption">
          Material 3의 하단 네비게이션 바
        </figcaption>
      </figure>
    </div>
    <div class="col-sm">
      <figure class="figure text-center">
        <img src="/assets/images/docs/platform-adaptations/hig-tabbar.png" 
        class="figure-img img-fluid rounded" alt="Tab Bar in Human Interface Guidelines" />
        <figcaption class="figure-caption">
         Human Interface Guidelines의 탭 바
        </figcaption>
      </figure>
    </div>
  </div>
</div>

탭 바는 앱 전체에서 지속되므로 자체 브랜딩과 일치해야 합니다. 
그러나, Android에서 Material의 기본 스타일을 사용하기로 선택한 경우, 기본 iOS 탭 바에 적응하는 것을 고려할 수 있습니다.

플랫폼별 하단 네비게이션 바를 구현하려면, 
Android에서 Flutter의 `NavigationBar` 위젯을 사용하고, 
iOS에서 `CupertinoTabBar` 위젯을 사용할 수 있습니다. 
아래는 플랫폼별 탐색 바를 표시하도록 적응할 수 있는 코드 스니펫입니다.

```dart
final Map<String, Icon> _navigationItems = {
    'Menu': Platform.isIOS ? Icon(CupertinoIcons.house_fill) : Icon(Icons.home),
    'Order': Icon(Icons.adaptive.share),
  };

...

Scaffold(
  body: _currentWidget,
  bottomNavigationBar: Platform.isIOS
          ? CupertinoTabBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() => _currentIndex = index);
                _loadScreen();
              },
              items: _navigationItems.entries
                  .map<BottomNavigationBarItem>(
                      (entry) => BottomNavigationBarItem(
                            icon: entry.value,
                            label: entry.key,
                          ))
                  .toList(),
            )
          : NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: (index) {
                setState(() => _currentIndex = index);
                _loadScreen();
              },
              destinations: _navigationItems.entries
                  .map<Widget>((entry) => NavigationDestination(
                        icon: entry.value,
                        label: entry.key,
                      ))
                  .toList(),
            ));
```

[mat-navbar]: {{site.material}}/components/navigation-bar/overview
[hig-tabbar]: {{site.apple-dev}}/design/human-interface-guidelines/components/navigation-and-search/tab-bars/

### 텍스트 필드 {:#text-fields}

Android 12부터, 텍스트 필드는 [Material 3][m3-text-field] (M3) 디자인 가이드라인을 따릅니다. 
iOS에서는, Apple의 [Human Interface Guidelines][hig-text-field] (HIG)가 동등한 구성 요소를 정의합니다.

<div class="container">
  <div class="row">
    <div class="col-sm text-center">
      <figure class="figure">
        <img src="/assets/images/docs/platform-adaptations/m3-text-field.png" 
        class="figure-img img-fluid rounded" alt="Text Field in Material 3" />
        <figcaption class="figure-caption">
          Material 3에서 텍스트 필드
        </figcaption>
      </figure>
    </div>
    <div class="col-sm">
      <figure class="figure text-center">
        <img src="/assets/images/docs/platform-adaptations/hig-text-field.png" 
        class="figure-img img-fluid rounded" alt="Text Field in Human Interface Guidelines" />
        <figcaption class="figure-caption">
          HIG에서 텍스트 필드
        </figcaption>
      </figure>
    </div>
  </div>
</div>

텍스트 필드에는 사용자 입력이 필요하므로, 해당 디자인은 플랫폼 규칙을 따라야 합니다.

Flutter에서 플랫폼별 `TextField`를 구현하려면, Material `TextField`의 스타일을 조정할 수 있습니다.

```dart
Widget _createAdaptiveTextField() {
  final _border = OutlineInputBorder(
    borderSide: BorderSide(color: CupertinoColors.lightBackgroundGray),
  );

  final iOSDecoration = InputDecoration(
    border: _border,
    enabledBorder: _border,
    focusedBorder: _border,
    filled: true,
    fillColor: CupertinoColors.white,
    hoverColor: CupertinoColors.white,
    contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
  );

  return Platform.isIOS
      ? SizedBox(
          height: 36.0,
          child: TextField(
            decoration: iOSDecoration,
          ),
        )
      : TextField();
}
```

텍스트 필드 조정에 대해 자세히 알아보려면, [텍스트 필드에 대한 GitHub 토론][text-field-post]를 확인하세요. 
토론에서 피드백을 남기거나 질문을 할 수 있습니다.

[text-field-post]: {{site.repo.uxr}}/discussions/95
[m3-text-field]: {{site.material}}/components/text-fields/overview
[hig-text-field]: {{site.apple-dev}}/design/human-interface-guidelines/text-fields
