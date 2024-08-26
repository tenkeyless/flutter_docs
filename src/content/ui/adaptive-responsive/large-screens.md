---
# title: Large screen devices
title: 대형 화면 장치
# description: >-
#   Things to keep in mind when adapting apps
#   to large screens.
description: >-
  앱을 대형 화면에 맞게 조정할 때 염두에 두어야 할 사항.
# short-title: Large screens
short-title: 대형 화면
---

<?code-excerpt path-base="ui/adaptive_app_demos"?>

이 페이지에서는 대형 화면에서 앱의 동작을 개선하기 위해 앱을 최적화하는 방법에 대한 지침을 제공합니다.

Flutter는 (Android와 마찬가지로) [대형 화면][large screens]을 태블릿, 폴더블, Android를 실행하는 ChromeOS 기기로 정의합니다. 
Flutter는 _또한_ 대형 화면 기기를 웹, 데스크톱, iPad로 정의합니다.

:::secondary 특히, 대형 화면이 중요한 이유는 무엇일까요?
대형 화면에 대한 수요는 계속 증가하고 있습니다. 
2024년 1월 현재, 
[2억 7천만 이상의 활성 대형 화면][large screens] 및 폴더블 기기가 Android로 실행되고, 
[1,490만 이상의 iPad 사용자][14.9 million iPad users]가 실행하고 있습니다.

앱이 대형 화면을 지원하는 경우, 다른 이점도 제공됩니다. 화면을 채우도록 앱을 최적화합니다. 예를 들어:

* 앱의 사용자 참여 지표를 개선합니다.
* Play 스토어에서 앱의 가시성을 높입니다. 
  최근 [Play 스토어 업데이트][Play Store updates]는 기기 타입별 평가를 표시하고, 앱에 대형 화면 지원이 없는 경우를 나타냅니다.
* 앱이 iPadOS 제출 지침을 충족하고 [App Store에서 승인][accepted in the App Store]되었는지 확인합니다.
:::

[14.9 million iPad users]: https://www.statista.com/statistics/299632/tablet-shipments-apple/
[accepted in the App Store]: https://developer.apple.com/ipados/submit/
[large screens]: {{site.android-dev}}/guide/topics/large-screens/get-started-with-large-screens
[Play Store updates]: {{site.android-dev}}/2022/03/helping-users-discover-quality-apps-on.html

## GridView로 레이아웃 {:#layout-with-gridview}

다음 앱 스크린샷을 고려하세요. 앱은 UI를 `ListView`에 표시합니다. 
왼쪽 이미지는 모바일 기기에서 실행되는 앱을 보여줍니다. 
오른쪽 이미지는 _이 페이지의 조언이 적용되기 전에_ 대형 화면 기기에서 실행되는 앱을 보여줍니다.

![Sample of large screen](/assets/images/docs/ui/adaptive-responsive/large-screen.png){:width="90%"}

이는 최적이 아닙니다.

[Android 대형 화면 앱 품질 가이드라인][guidelines]과 [iOS 동등 가이드라인][iOS equivalent]은, 
텍스트나 상자가 전체 화면 너비를 차지해서는 안 된다고 명시하고 있습니다. 
이를 적응형 방식으로 해결하려면 어떻게 해야 할까요?

[guidelines]: https://developer.android.com/docs/quality-guidelines/large-screen-app-quality
[iOS equivalent]: https://developer.apple.com/design/human-interface-guidelines/designing-for-ipados

다음 섹션에 표시된 것처럼, 일반적인 솔루션은 `GridView`를 사용합니다.

### GridView {:#gridview}

`GridView` 위젯을 사용하여 기존 `ListView`를 더 적절한 크기의 아이템으로 변환할 수 있습니다.

`GridView`는 [`ListView`][] 위젯과 비슷하지만, 선형으로 배열된 위젯 리스트만 처리하는 대신, 
`GridView`는 위젯을 2차원 배열로 배열할 수 있습니다.

`GridView`에는 `ListView`와 비슷한 생성자도 있습니다. 
`ListView` 디폴트 생성자는 `GridView.count`에 매핑되고, 
`ListView.builder`는 `GridView.builder`와 비슷합니다.

`GridView`에는 더 많은 커스텀 레이아웃을 위한 추가 생성자가 있습니다. 
자세한 내용은 [`GridView`][] API 페이지를 방문하세요.

[`GridView`]: {{site.api}}/flutter/widgets/GridView-class.html
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html

예를 들어, 원본 앱에서 `ListView.builder`를 사용한 경우, `GridView.builder`로 바꾸세요. 
앱에 많은 아이템이 있는 경우, 이 빌더 생성자를 사용하여 실제로 표시되는 아이템 위젯만 빌드하는 것이 좋습니다.

생성자의 대부분 매개변수는 두 위젯에서 동일하므로, 간단하게 바꿀 수 있습니다. 
그러나, `gridDelegate`에 무엇을 설정해야 할지 알아내야 합니다.

Flutter는 다음과 같이 사용할 수 있는 강력한 사전 제작된 `gridDelegates`를 제공합니다.

[`SliverGridDelegateWith<b>FixedCrossAxisCount</b>`][]
: 그리드에 특정 개수의 열을 할당할 수 있습니다.

[`SliverGridDelegateWith<b>MaxCrossAxisExtent</b>`][]
: 최대 아이템 너비를 정의할 수 있습니다.

[`SliverGridDelegateWith<b>FixedCrossAxisCount</b>`]: {{site.api}}/flutter/rendering/SliverGridDelegateWithFixedCrossAxisCount-class.html 
[`SliverGridDelegateWith<b>MaxCrossAxisExtent</b>`]:  {{site.api}}/flutter/rendering/SliverGridDelegateWithMaxCrossAxisExtent-class.html

:::secondary
이러한 클래스에 grid delegate를 사용하지 마세요. 
grid delegate를 사용하면 열 수를 직접 설정한 다음, 기기가 태블릿인지 여부에 따라, 열 수를 하드코딩할 수 있습니다. 
열 수는 물리적 기기의 크기가 아닌, 창의 크기를 기준으로 해야 합니다.

이러한 구분은 많은 모바일 기기가 멀티 윈도우 모드를 지원하기 때문에 중요합니다. 
멀티 윈도우 모드를 사용하면, 앱이 디스플레이의 물리적 크기보다 작은 공간에 렌더링될 수 있습니다. 
또한, Flutter 앱은 웹과 데스크톱에서 실행될 수 있으며, 크기가 여러 가지로 조정될 수 있습니다. 
**이러한 이유로 `MediaQuery`를 사용하여 물리적 기기 크기가 아닌 앱 창 크기를 가져옵니다.**
:::

### 기타 솔루션 {:#other-solutions}

이러한 상황에 접근하는 또 다른 방법은 `BoxConstraints`의 `maxWidth` 속성을 사용하는 것입니다. 여기에는 다음이 포함됩니다.

* `GridView`를 `ConstrainedBox`로 래핑하고, 최대 너비가 설정된 `BoxConstraints`를 제공합니다.
* (배경색 설정과 같은) 다른 기능이 필요한 경우, `ConstrainedBox` 대신 `Container`를 사용합니다.

최대 너비 값을 선택하려면, [레이아웃 적용][Applying layout] 가이드의 Material 3에서 권장하는 값을 사용하는 것이 좋습니다.

[Applying layout]: https://m3.material.io/foundations/layout/applying-layout/window-size-classes

## 폴더블 {:#foldables}

이전에 언급했듯이, Android와 Flutter는 모두 디자인 가이드에서 화면 방향을 **잠그지 말라고** 권장하지만, 
일부 앱은 화면 방향을 잠급니다. 
이로 인해, 폴더블 기기에서 앱을 실행할 때 문제가 발생할 수 있다는 점에 유의하세요.

폴더블에서 실행할 때, 기기를 접으면 앱이 괜찮아 보일 수 있습니다. 
하지만 펼칠 때, 앱이 레터박스 처리된 것을 볼 수 있습니다.

[SafeArea & MediaQuery][sa-mq] 페이지에 설명된 대로, 
레터박스 처리란 앱의 창이 화면 중앙에 잠기고 창은 검은색으로 둘러싸여 있음을 의미합니다.

[sa-mq]: /ui/adaptive-responsive/safearea-mediaquery

왜 이런 일이 일어날 수 있을까요?

`MediaQuery`를 사용하여 앱의 창 크기를 알아낼 때 이런 일이 일어날 수 있습니다. 
기기를 접으면, 방향이 세로 모드로 제한됩니다. 
내부적으로, `setPreferredOrientations`는 Android가 세로 호환 모드를 사용하고, 앱이 레터박스 상태로 표시되도록 합니다. 
레터박스 상태에서, `MediaQuery`는 UI가 확장될 수 있도록 하는 더 큰 창 크기를 수신하지 않습니다.

다음 두 가지 방법 중 하나로 이 문제를 해결할 수 있습니다.

* 모든 방향을 지원합니다.
* _물리적 디스플레이_ 의 크기를 사용합니다. 
  사실, 이는 물리적 디스플레이 크기를 사용하고, 창 크기를 _사용하지 않는_, _몇 안 되는_ 상황 중 하나입니다.

물리적 화면 크기를 얻는 방법은 무엇인가요?

Flutter 3.13에 도입된 [`Display`][] API를 사용할 수 있습니다. 
여기에는 물리적 장치의 크기, 픽셀 비율 및 새로 고침 빈도가 포함됩니다.

[`Display`]: {{site.api}}/flutter/dart-ui/Display-class.html

다음 샘플 코드는 `Display` 객체를 검색합니다.

```dart
/// AppState 객체.
ui.FlutterView? _view;

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  _view = View.maybeOf(context);
}

void didChangeMetrics() {
  final ui.Display? display = _view?.display;
}
```

중요한 것은 당신이 관심 있는 뷰의 디스플레이를 찾는 것입니다. 
이것은 현재 _그리고_ 미래의 멀티 디스플레이 및 멀티 뷰 장치를 처리해야 하는, 
미래 지향적인 API(forward-looking API)를 만듭니다.

## 적응형 입력 {:#adaptive-input}

더 많은 화면에 대한 지원을 추가한다는 것은, 입력 컨트롤을 확장한다는 것을 의미합니다.

Android 가이드라인은 대형 포맷 장치 지원의 세 가지 티어를 설명합니다.

![3 tiers of large format device support](/assets/images/docs/ui/adaptive-responsive/large-screen-guidelines.png){:width="90%"}

가장 낮은 레벨의 지원인 3단계에는, 마우스와 스타일러스 입력에 대한 지원이 포함됩니다. ([Material 3 가이드라인][m3-guide], [Apple 가이드라인][Apple guidelines])

앱에서 Material 3과 해당 버튼 및 선택기를 사용하는 경우, 
앱에는 다양한 추가 입력 상태에 대한 기본 제공 지원이 이미 있습니다.

하지만, 커스텀 위젯이 있는 경우는 어떨까요? 
[위젯에 대한 입력 지원][input support for widgets]을 추가하는 방법에 대한 지침은 [사용자 입력][User input] 페이지를 확인하세요.

[Apple guidelines]: https://developer.apple.com/design/human-interface-guidelines/designing-for-ipados#Best-practices
[input support for widgets]: /ui/adaptive-responsive/input#custom-widgets
[m3-guide]: {{site.android-dev}}/docs/quality-guidelines/large-screen-app-quality
[User input]: /ui/adaptive-responsive/input

### 네비게이션 {:#navigation}

다양한 크기의 기기에서 작업할 때 네비게이션은 고유한 챌린지를 만들 수 있습니다. 
일반적으로, 사용 가능한 화면 공간에 따라, 
[`BottomNavigationBar`][]와 [`NavigationRail`][] 사이를 전환하고 싶을 것입니다.

자세한 내용 (및 해당 예제 코드)은 [대형 화면을 위한 Flutter 앱 개발][article] 글의 섹션인 [문제: 탐색 레일][Problem: Navigation rail]을 확인하세요.

[article]: {{site.flutter-medium}}/developing-flutter-apps-for-large-screens-53b7b0e17f10
[`BottomNavigationBar`]: {{site.api}}/flutter/material/BottomNavigationBar-class.html
[`NavigationRail`]: {{site.api}}/flutter/material/NavigationRail-class.html
[Problem: Navigation rail]: {{site.flutter-medium}}/developing-flutter-apps-for-large-screens-53b7b0e17f10#:~:text=Problem%3A%20Navigation%20rail1

