---
# title: Best practices for adaptive design
title: 적응형 디자인을 위한 모범 사례
# description: >-
#   Summary of some of the best practices for adaptive design.
description: >-
  적응형 설계의 모범 사례 중 일부를 요약한 것입니다.
# short-title: Best practices
short-title: 모범 사례
---

적응형 설계를 위한 권장 모범 사례는 다음과 같습니다.

## 디자인 고려 사항 {:#design-considerations}

### 위젯 분해하기 {:#break-down-your-widgets}

앱을 디자인할 때, 크고 복잡한 위젯을 더 작고 간단한 위젯으로 분해해 보세요.

위젯을 리팩토링하면 핵심 코드를 공유하여 적응형 UI를 도입하는 복잡성을 줄일 수 있습니다. 다른 이점도 있습니다.

* 성능 측면에서, 작은 `const` 위젯을 많이 사용하면, 크고 복잡한 위젯을 사용하는 것보다 재구축 시간이 단축됩니다.
* Flutter는 `const` 위젯 인스턴스를 재사용할 수 있지만, 더 크고 복잡한 위젯은 모든 재구축에 대해 설정해야 합니다.
* 코드 상태 관점에서, UI를 더 작은 한입 크기 조각으로 구성하면 각 `Widget`의 복잡성을 낮추는 데 도움이 됩니다. 
  덜 복잡한 `Widget`은 더 읽기 쉽고, 리팩토링하기 쉽고, 깜짝 놀라는 동작이 발생할 가능성이 적습니다.

자세한 내용은 [일반적인 접근 방식][General approach]에서 적응형 디자인의 3단계를 확인하세요.

[General approach]: /ui/adaptive-responsive/general

### 각 폼 팩터의 장점을 최대한 활용한 디자인 {:#design-to-the-strengths-of-each-form-factor}

화면 크기 외에도, 다양한 폼 팩터의 고유한 강점과 약점을 고려하는 데 시간을 투자해야 합니다. 
멀티플랫폼 앱이 모든 곳에서 동일한 기능을 제공하는 것이 항상 이상적인 것은 아닙니다. 
특정 기능에 집중하거나, 일부 기기 범주에서 특정 기능을 제거하는 것이 합리적인지 고려하세요.

예를 들어, 모바일 기기는 휴대성이 뛰어나고 카메라가 있지만, 세부적인 창의적 작업에는 적합하지 않습니다. 
이를 염두에 두고, 모바일 UI의 경우 콘텐츠를 캡처하고 위치 데이터로 태그를 지정하는 데 더 집중하지만, 
태블릿이나 데스크톱 UI의 경우 해당 콘텐츠를 구성하거나 조작하는 데 집중할 수 있습니다.

또 다른 예는 공유에 대한 웹의 극히 낮은 장벽을 활용하는 것입니다. 
웹 앱을 배포하는 경우, 지원할 [딥 링크][deep links]를 결정하고, 이를 염두에 두고 탐색 경로를 설계하세요.

여기서 중요한 요점은 각 플랫폼이 가장 잘하는 것이 무엇인지 생각하고 활용할 수 있는 고유한 기능이 있는지 확인하는 것입니다.

[deep links]: /ui/navigation/deep-linking

### 터치를 먼저 해결하기 {:#solve-touch-first}

훌륭한 터치 UI를 구축하는 것은 종종 오른쪽 클릭, 스크롤 휠 또는 키보드 단축키와 같은 입력 가속기가 부족하기 때문에, 
기존 데스크톱 UI보다 더 어려울 수 있습니다.

이 과제에 접근하는 한 가지 방법은 처음에 훌륭한 터치 지향 UI에 집중하는 것입니다. 
반복 속도를 위해 데스크톱 대상을 사용하여 대부분의 테스트를 수행할 수 있습니다. 
그러나 모든 것이 제대로 느껴지는지 확인하기 위해 자주 모바일 기기로 전환하는 것을 기억하세요.

터치 인터페이스를 다듬은 후, 마우스 사용자를 위해 시각적 밀도를 조정한 다음, 모든 추가 입력을 레이어로 적용할 수 있습니다. 
이러한 다른 입력을 가속기로 접근하세요. 이는 작업을 더 빠르게 만드는 대안입니다. 
고려해야 할 중요한 사항은 사용자가 특정 입력 장치를 사용할 때 무엇을 기대하는지이며, 이를 앱에 반영하기 위해 노력합니다.

## 세부사항 구현 {:#implementation-details}

### 앱의 방향을 잠그지 말기 {:#dont-lock-the-orientation-of-your-app}

적응형 앱은 다양한 크기와 모양의 창에서 보기 좋게 보여야 합니다. 
휴대전화에서 앱을 세로 모드로 잠그면 최소 실행 가능 제품의 범위를 좁히는 데 도움이 되지만, 
나중에 앱을 적응형으로 만드는 데 필요한 노력이 늘어날 수 있습니다.

예를 들어, 휴대전화가 앱을 전체 화면 세로 모드로만 렌더링한다는 가정은 보장되지 않습니다. 
멀티 윈도우 앱 지원이 일반화되고 있으며, 폴더블은 여러 앱을 나란히 실행하는 데 가장 적합한 사용 사례가 많습니다.

반드시 세로 모드로 앱을 잠가야 하는 경우 (하지만 하지마세요), 
`MediaQuery`와 같은 API 대신 `Display` API를 사용하여 화면의 실제 크기를 가져옵니다.

요약:

  * 잠긴 화면은 일부 사용자에게 [접근성 문제][an accessibility issue]가 될 수 있습니다.
  * Android 대형 포맷 계층은 [가장 낮은 레벨][lowest level]에서 세로 및 가로 지원이 필요합니다.
  * Android 기기는 [잠긴 화면을 재정의][override a locked screen]할 수 있습니다.
  * Apple 가이드라인은 [두 방향 모두 지원하는 것을 목표로 한다][aim to support both orientations]라고 명시합니다.

[an accessibility issue]: https://www.w3.org/WAI/WCAG21/Understanding/orientation.html
[aim to support both orientations]: https://www.w3.org/WAI/WCAG21/Understanding/orientation.html
[lowest level]:  {{site.android-dev}}/docs/quality-guidelines/large-screen-app-quality#T3-8
[override a locked screen]: {{site.android-dev}}/guide/topics/large-screens/large-screen-compatibility-mode#per-app_overrides

### 방향 기반 레이아웃 피하기 {:#avoid-orientation-based-layouts}

다양한 앱 레이아웃 간에 전환하기 위해, `MediaQuery`의 orientation 필드나 `OrientationBuilder`를 사용하지 마세요. 
이는 화면 크기를 결정하기 위해 기기 타입을 확인하지 않는 지침과 유사합니다. 
기기의 방향은 반드시 앱 창의 공간을 알려주지는 않습니다.

대신, [일반적인 접근 방식][General approach] 페이지에서 설명한 대로, 
`MediaQuery`의 `sizeOf` 또는 `LayoutBuilder`를 사용하세요. 
그런 다음 [Material][]에서 권장하는 것과 같은 적응형 중단점을 사용하세요.

[General approach]: /ui/adaptive-responsive/general#
[Material]: https://m3.material.io/foundations/layout/applying-layout/window-size-classes

### 수평 공간을 모두 차지하지 말기 {:#dont-gobble-up-all-of-the-horizontal-space}

창의 전체 너비를 사용하여 상자나 텍스트 필드를 표시하는 앱은 대형 화면에서 실행하면 제대로 작동하지 않습니다.

이를 방지하는 방법을 알아보려면, [GridView로 레이아웃][Layout with GridView]을 확인하세요.

[Layout with GridView]: /ui/adaptive-responsive/large-screens#layout-with-gridview

### 하드웨어 체크 확인 피하기 {:#avoid-checking-for-hardware-types}

레이아웃 결정을 내릴 때 실행 중인 기기가 "휴대폰"인지 "태블릿"인지 또는 다른 타입의 기기인지 확인하는 코드를 작성하지 마세요.

앱이 실제로 렌더링할 공간이 항상 기기의 전체 화면 크기에 연결되어 있는 것은 아닙니다. 
Flutter는 여러 플랫폼에서 실행될 수 있으며, 
앱은 ChromeOS에서 크기 조절 가능한 창에서 실행되거나, 
태블릿에서 멀티 윈도우 모드로 다른 앱과 나란히 실행되거나, 
심지어 휴대전화에서 화면 속 화면 모드로 실행될 수 있습니다. 
따라서, 기기 타입과 앱 창 크기는 실제로 강력하게 연결되어 있지 않습니다.

대신, `MediaQuery`를 사용하여 현재 앱이 실행 중인 창의 크기를 가져옵니다.

이것은 UI 코드에만 유용한 것이 아닙니다. 
기기 기능을 추상화하는 것이 비즈니스 로직 코드에 어떻게 도움이 될 수 있는지 알아보려면, 
2022 Google I/O 토크, [federated 플러그인 개발을 위한 Flutter 레슨][Flutter lessons for federated plugin development]를 확인하세요.
 
[Flutter lessons for federated plugin development]: {{site.youtube-site}}/watch?v=GAnSNplNpCA

### 다양한 입력 장치 지원 {:#support-a-variety-of-input-devices}

앱은 기본 마우스, 트랙패드, 키보드 단축키를 지원해야 합니다. 
가장 일반적인 사용자 흐름은 접근성을 보장하기 위해 키보드 탐색을 지원해야 합니다. 
특히, 앱은 대형 기기의 키보드에 대한 접근성 모범 사례를 따릅니다.

Material 라이브러리는 터치, 마우스, 키보드 상호 작용에 대한 뛰어난 기본 동작을 위젯에 제공합니다.

이 지원을 커스텀 위젯에 추가하는 방법을 알아보려면, [사용자 입력 및 접근성][User input & accessibility]을 확인하세요.

[User input & accessibility]: /ui/adaptive-responsive/input

### 리스트 상태 복원 {:#restore-list-state}

{% comment %}
<b>PENDING: Reid, I think you suggested renaming/removing this item? I can't, for the life of me, find that comment in the PR</b>
{% endcomment %}

기기의 방향이 변경될 때 레이아웃이 변경되지 않는 리스트에서 스크롤 위치를 유지하려면, 
[`PageStorageKey`][] 클래스를 사용합니다. 
[`PageStorageKey`][]는 위젯이 파괴된 후, 저장소에 위젯 상태를 유지하고 다시 생성되면 상태를 복원합니다.

[Wonderous 앱][Wonderous app]에서 이에 대한 예를 볼 수 있습니다. 
여기서는 리스트의 상태를 `SingleChildScrollView` 위젯에 저장합니다.

기기의 방향이 변경될 때 `List` 위젯의 레이아웃이 변경되면, 
화면 회전 시 스크롤 위치를 변경하기 위해 약간의 수학([예][example])을 해야 할 수도 있습니다.

[example]: {{site.github}}/gskinnerTeam/flutter-wonderous-app/blob/34e49a08084fbbe69ed67be948ab00ef23819313/lib/ui/screens/collection/widgets/_collection_list.dart#L39
[`PageStorageKey`]: {{site.api}}/flutter/widgets/PageStorageKey-class.html
[Wonderous app]: {{site.github}}/gskinnerTeam/flutter-wonderous-app/blob/8a29d6709668980340b1b59c3d3588f123edd4d8/lib/ui/screens/wonder_events/widgets/_events_list.dart#L64

## 앱 상태 저장 {:#save-app-state}

앱은 기기가 회전하거나, 창 크기가 변경되거나, 접히고 펼쳐질 때 [앱 상태][app state]를 유지하거나 복원해야 합니다. 
기본적으로, 앱은 상태를 유지해야 합니다.

기기 구성 중에 앱이 상태를 잃는 경우, 
앱에서 사용하는 플러그인과 네이티브 확장 프로그램이 (대형 화면과 같은) 기기 타입을 지원하는지 확인하세요. 
일부 네이티브 확장 프로그램은 기기 위치가 변경될 때 상태를 잃을 수 있습니다.

이런 일이 발생한 실제 사례에 대한 자세한 내용은, 
Medium의 무료 글인 [앱 대형 화면을 위한 개발 Flutter][article]의 [문제: 폴딩/언폴딩으로 인한 상태 손실][state-loss]을 확인하세요.

[app state]: {{site.android-dev}}/jetpack/compose/state#store-state
[article]: {{site.flutter-medium}}/developing-flutter-apps-for-large-screens-53b7b0e17f10
[state-loss]: {{site.flutter-medium}}/developing-flutter-apps-for-large-screens-53b7b0e17f10#:~:text=Problem%3A%20Folding/Unfolding%20causes%20state%2Dloss
