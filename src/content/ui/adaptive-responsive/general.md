---
# title: General approach to adaptive apps
title: 적응형 앱에 대한 일반적인 접근 방식
# description: >-
  # General advice on how to approach making your Flutter app adaptive.
description: >-
  Flutter 앱을 적응형으로 만드는 방법에 대한 일반적인 조언입니다.
# short-title: General approach
short-title: 일반적인 접근 방식
---

<?code-excerpt path-base="ui/adaptive_app_demos"?>

그렇다면, 기존 모바일 기기에 맞게 디자인된 앱을, 다양한 기기에서 아름답게 만들려면 _어떻게_ 접근해야 할까요? 
어떤 단계가 필요할까요?

대형 앱에서 이런 작업을 해본 경험이 있는 Google 엔지니어는, 다음의 3단계 접근 방식을 권장합니다.

## 스텝 1: 추상화 {:#step-1-abstract}

![Step 1: Abstract info common to any UI widget](/assets/images/docs/ui/adaptive-responsive/abstract.png)

먼저, 동적으로 만들려는 위젯을 식별합니다. 해당 위젯의 생성자를 분석하고, 공유할 수 있는 데이터를 추상화합니다.

적응성이 필요한 일반적인 위젯은 다음과 같습니다.

* 대화 상자(Dialogs) - 전체 화면 및 모달 모두
* 네비게이션 UI - 레일 및 하단 바 모두
* 커스텀 레이아웃 - "UI 영역이 더 높거나 더 넓습니까?"와 같은

예를 들어, `Dialog` 위젯에서 대화 상자의 _내용(content)_ 이 포함된 정보를 공유할 수 있습니다.

또는, 앱 창이 작을 때는 `NavigationBar`를 사용하고, 앱 창이 클 때는 `NavigationRail`을 사용하도록, 
서로 간에 스위치하게 하고 싶을 수도 있습니다. 
이러한 위젯은 탐색 가능한(navigable) 목적지 리스트를 공유할 가능성이 높습니다. 
이 경우, 이 정보를 보관하기 위해 `Destination` 위젯을 만들고, 
`Destination`에 아이콘과 텍스트 레이블을 모두 지정하면 됩니다.

다음으로, 화면 크기를 평가하여 UI를 표시하는 방법을 결정합니다.

## 스텝 2: 측정 {:#step-2-measure}

![Step 2: How to measure screen size](/assets/images/docs/ui/adaptive-responsive/measure.png)

디스플레이 영역의 크기를 결정하는 방법에는 `MediaQuery`와 `LayoutBuilder` 두 가지가 있습니다.

### MediaQuery

과거에는, `MediaQuery.of`를 사용하여 기기 화면 크기를 확인했을 수 있습니다. 
그러나, 오늘날 기기는 다양한 크기와 모양의 화면을 특징으로 하며, 이 테스트는 잘못된 결과가 나올 수 있습니다.

예를 들어, 앱이 현재 대형 화면에서 작은 창을 차지하고 있을 수 있습니다. 
`MediaQuery.of` 메서드를 사용하여 화면이 작다고 결론을 내리고(사실은 앱이 대형 화면에서 작은 창에 표시됨), 
앱을 세로 모드로 잠근 경우, 앱 창이 화면 중앙에 잠기고 검은색으로 둘러싸여 있습니다. 
이는 대형 화면에서 이상적인 UI가 아닙니다.

:::note
Material Guidelines에서는 앱을 (가로 모드를 비활성화해서) _세로 잠금_ 하지 말라고 권장합니다. 
하지만, 꼭 해야 한다고 생각되면, 적어도 세로 모드가 top-down 모드와 bottom-up 모드에서 모두 작동하도록 정의하세요.
:::

`MediaQuery.sizeOf`는 단일 위젯이 아니라, 앱 전체 화면의 현재 크기를 반환한다는 점을 명심하세요.

화면 공간을 측정하는 방법은 두 가지가 있습니다. 
전체 앱 창의 크기를 원하는지, 아니면 더 로컬한 크기를 원하는지에 따라, 
`MediaQuery.sizeOf` 또는 `LayoutBuilder`를 사용할 수 있습니다.

앱 창이 작더라도 위젯을 전체 화면으로 표시하려면, 
`MediaQuery.sizeOf`를 사용하여, 앱 창 자체의 크기에 따라 UI를 선택할 수 있습니다. 
이전 섹션에서는, 전체 앱 창에 따라 크기 조정 동작을 기반으로 하려고 하므로, `MediaQuery.sizeOf`를 사용합니다.

:::secondary `MediaQuery.of` 대신 `MediaQuery.sizeOf`를 사용하는 이유는 무엇입니까?
이전 조언에서는 `MediaQuery`의 `of` 메서드를 사용하여 앱 창의 크기를 가져오는 것이 좋다고 하였습니다. 
이 조언이 변경된 이유는 무엇입니까? 간단히 말해서 **성능상의 이유입니다.**

`MediaQuery`에는 많은 데이터가 포함되어 있지만, 크기 속성에만 관심이 있는 경우, 
`sizeOf` 메서드를 사용하는 것이 더 효율적입니다. 
두 메서드 모두 앱 창의 크기를 논리적 픽셀( _밀도 독립 픽셀(density independent pixels)_ 이라고도 함)로 반환합니다. 
논리적 픽셀 크기는 일반적으로 모든 기기에서 거의 동일한 시각적 크기이므로 가장 잘 작동합니다. 
`MediaQuery` 클래스에는 같은 이유로 각 개별 속성에 대한 다른 특수 함수가 있습니다.
:::

(`MediaQuery.sizeOf(context)` 처럼) `build` 메서드 내부에서 앱 창의 크기를 요청하면, 
크기 속성이 변경될 때마다 지정된 `BuildContext`가 다시 빌드됩니다.

### LayoutBuilder

`LayoutBuilder`는 `MediaQuery.sizeOf`와 비슷한 목표를 달성하지만, 몇 가지 차이점이 있습니다.

앱 창의 크기를 제공하는 대신, `LayoutBuilder`는 부모 `Widget`의 레이아웃 제약 조건을 제공합니다. 
즉, `LayoutBuilder`를 추가한 위젯 트리의 특정 지점을 기반으로, 크기 정보를 얻을 수 있습니다. 
또한, `LayoutBuilder`는 `Size` 객체 대신 `BoxConstraints` 객체를 반환하므로, 
고정된 크기가 아닌, 콘텐츠의 유효한 너비와 높이 범위(최소 및 최대)가 제공됩니다. 
이는 커스텀 위젯에 유용할 수 있습니다.

예를 들어, 일반적으로 앱 창 전체가 아닌 해당 위젯에 특별히 제공된 공간을 기반으로 크기를 조정하려는, 커스텀 위젯을 상상해 보세요. 
이 시나리오에서는, `LayoutBuilder`를 사용합니다.

## 스텝 3: 브랜치 {:#step-3-branch}

![Step 3: Branch the code based on the desired UI](/assets/images/docs/ui/adaptive-responsive/branch.png)

이 시점에서, 표시할 UI 버전을 선택할 때 사용할 크기 조정 중단점(sizing breakpoints)을 결정해야 합니다. 
예를 들어, [Material 레이아웃][Material layout] 가이드라인은, 
너비가 600 논리 픽셀 미만인 창에는 하단 네비게이션 바(bottom nav bar)를 사용하고, 
너비가 600 픽셀 이상인 창에는 네비게이션 레일(nav rail)을 사용하도록 제안합니다. 
다시 말하지만, 선택은 장치의 _타입_ 이 아니라, 장치의 사용 가능한 창 크기에 따라 달라야 합니다.

[Material layout]: https://m3.material.io/foundations/layout/applying-layout/window-size-classes

`NavigationRail`과 `NavigationBar` 사이를 전환하는 예제를 살펴보려면, 
[Material 3을 사용하여 애니메이션이 적용된 반응형 앱 레이아웃 구축][codelab]을 확인하세요.

[codelab]: {{site.codelabs}}/codelabs/flutter-animated-responsive-layout

다음 페이지에서는 앱이 대형 화면과 폴더블 폰에서 가장 멋지게 보이도록 하는 방법을 설명합니다.
