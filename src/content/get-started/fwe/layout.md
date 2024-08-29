---
# title: Layouts
title: 레이아웃
# description: Learn how to create layouts in Flutter.
description: Flutter에서 레이아웃을 만드는 방법을 알아보세요.
prev:
  # title: Flutter fundamentals
  title: Flutter 기본 사항
  path: /get-started/fwe/fundamentals
next:
    # title: State management
    title: 상태 관리
    path: /get-started/fwe/state-management
---

Flutter가 UI 툴킷이기 때문에, Flutter 위젯으로 레이아웃을 만드는 데 많은 시간을 할애하게 될 것입니다. 
이 섹션에서는 가장 일반적인 레이아웃 위젯 중 일부를 사용하여 레이아웃을 빌드하는 방법을 알아봅니다. 
Flutter DevTools(Dart DevTools라고도 함)를 사용하여 Flutter가 레이아웃을 만드는 방식을 이해합니다. 
마지막으로, Flutter의 가장 일반적인 레이아웃 오류 중 하나인, 
두려운 "무한한 제약 조건(unbounded constraints)" 오류를 발견하고 디버깅합니다.

## Flutter에서 레이아웃 이해하기 {:#understanding-layout-in-flutter}

Flutter 레이아웃 메커니즘의 핵심은 위젯입니다. 
Flutter에서는 거의 모든 것이 위젯입니다. 심지어 레이아웃 모델도 위젯입니다. 
Flutter 앱에서 보이는 이미지, 아이콘, 텍스트는 모두 위젯입니다. 
보이지 않는 것도 위젯입니다. 
예를 들어, 보이는 위젯을 배열, 제한, 정렬하는 행, 열, 그리드가 있습니다.

위젯을 구성(composing)하여, 더 복잡한 위젯을 빌드하여 레이아웃을 만듭니다. 
예를 들어, 아래 다이어그램은 각각 아래에 레이블이 있는 3개의 아이콘과 해당 위젯 트리를 보여줍니다.

<img src='/assets/images/docs/fwe/layout/simple_row_column_widget_tree.png' alt="A diagram that shows widget composition with a series of lines and nodes.">

이 예에서는 3개의 열로 구성된 행이 있는데, 각 열에는 아이콘과 레이블이 들어 있습니다. 
아무리 복잡하더라도 모든 레이아웃은 이러한 레이아웃 위젯을 구성하여 만들어집니다.

### 제약 조건 {:#constraints}

Flutter에서 제약 조건을 이해하는 것은 Flutter에서 레이아웃이 작동하는 방식을 이해하는 데 중요한 부분입니다.

일반적으로 레이아웃은 위젯의 크기와 화면에서의 위치를 ​​말합니다. 
주어진 위젯의 크기와 위치는 부모에 의해 제한됩니다. 
원하는 크기를 가질 수 없으며, 화면에서 자신의 위치를 ​​결정하지 않습니다. 
대신, 크기와 위치는 위젯과 부모 간의 대화에 의해 결정됩니다.

가장 간단한 예로, 레이아웃 대화는 다음과 같습니다.

1. 위젯은 부모로부터 제약 조건을 받습니다.
2. 제약 조건은 최소 및 최대 너비와 최소 및 최대 높이의 4개 double 세트일 뿐입니다.
3. 위젯은 해당 제약 조건 내에서 어떤 크기가 되어야 하는지 결정하고, 너비와 높이를 부모에게 다시 전달합니다.
4. 부모는 원하는 크기와 정렬 방법을 보고, 위젯의 위치를 ​​그에 따라 설정합니다. 
   정렬은 `Center`와 같은 다양한 위젯과 `Row` 및 `Column`의 정렬 속성을 사용하여, 
   명시적으로 설정할 수 있습니다.

Flutter에서 이 레이아웃 대화는 종종 다음의 간단한 문구로 표현됩니다.

"제약 조건은 아래로 갑니다. 크기는 위로 갑니다. 부모가 위치를 설정합니다."

### 박스 타입 {:#box-types}

Flutter에서, 위젯은 기본 [`RenderBox`][] 객체에 의해 렌더링됩니다. 
이러한 객체는 전달된 제약 조건을 처리하는 방법을 결정합니다.

일반적으로, 세 가지 종류의 상자가 있습니다.

* 가능한 한 크게 만들려는 상자. 예를 들어, [`Center`][] 및 [`ListView`][]에서 사용하는 상자.
* 자식과 같은 크기가 되려는 상자. 예를 들어, [`Transform`][] 및 [`Opacity`][]에서 사용하는 상자.
* 특정 크기가 되려는 상자. 예를 들어, [`Image`][] 및 [`Text`][]에서 사용하는 상자.

일부 위젯(예: [`Container`][])은, 생성자 인수에 따라 타입마다 다릅니다. 
`Container` 생성자는 기본적으로 가능한 한 크게 만들려고 하지만, 
예를 들어, 너비를 지정하면 이를 존중하고, 해당 특정 크기가 되려고 합니다.

다른 위젯(예: [`Row`][] 및 [`Column`][](flex 상자))은 지정된 제약 조건에 따라 다릅니다. 
[제약 조건 이해하기 글][Understanding Constraints article]에서 flex 상자와 제약 조건에 대해 자세히 알아보세요.

## 단일 위젯 레이아웃 {:#lay-out-a-single-widget}

Flutter에서 단일 위젯을 레이아웃하려면, 
`Text`나 `Image`와 같이 표시되는 위젯을, 
`Center` 위젯과 같이 화면에서 위치를 변경할 수 있는 위젯으로 래핑합니다.

:::note 참고
페이지의 예제는 `BorderedImage`라는 위젯을 사용합니다. 
이것은 커스텀 위젯이며, 여기서는 (이 주제와 관련이 없는) 코드를 숨기는 데 사용됩니다.
:::

```dart
Widget build(BuildContext context) {
  return Center(
    child: BorderedImage(),
  );
}
```

다음 그림에서, 왼쪽 그림은 정렬되지 않은 위젯과, 오른쪽 그림은 가운데 정렬된 위젯을 보여줍니다.

<img src='/assets/images/docs/fwe/layout/center.png' alt="A screenshot of a centered widget and a screenshot of a widget that hasn't been centered.">

모든 레이아웃 위젯에는 다음 중 하나가 있습니다.

* 단일 자식을 취하는 경우, `child` 속성. (예: `Center`, `Container` 또는 `Padding`)
* 위젯 리스트를 취하는 경우, `children` 속성. (예: `Row`, `Column`, `ListView` 또는 `Stack`)

### Container {:#container}

`Container`는 레이아웃, 페인팅, 위치 지정 및 크기를 담당하는 여러 위젯으로 구성된 편의 위젯입니다. 
레이아웃과 관련하여, 위젯에 패딩과 여백을 추가하는 데 사용할 수 있습니다. 
여기에서 동일한 효과를 위해 사용할 수 있는 `Padding` 위젯도 있습니다. 
다음 예에서는 `Container`를 사용합니다.

```dart
Widget build(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(16.0),
    child: BorderedImage(),
  );
}
```

다음 그림에서, 왼쪽 그림은 패딩이 없는 위젯, 오른쪽 그림은 패딩이 있는 위젯을 보여줍니다.

<img src='/assets/images/docs/fwe/layout/padding.png' alt="A screenshot of a widget with padding and a screenshot of a widget without padding.">

Flutter에서 더 복잡한 레이아웃을 만들려면, 여러 위젯을 구성할 수 있습니다. 
예를 들어, `Container`와 `Center`를 결합할 수 있습니다.

```dart
Widget build(BuildContext context) {
  return Center(
    Container(
      padding: EdgeInsets.all(16.0),
      child: BorderedImage(),
    ),
  );
}
```

## 여러 위젯을 수직 또는 수평으로 레이아웃 {:#layout-multiple-widgets-vertically-or-horizontally}

가장 일반적인 레이아웃 패턴 중 하나는 위젯을 수직 또는 수평으로 배열하는 것입니다. 
`Row` 위젯을 사용하여 위젯을 수평으로 배열하고, 
`Column` 위젯을 사용하여 위젯을 수직으로 배열할 수 있습니다. 
이 페이지의 첫 번째 그림은 둘 다 사용했습니다.

이것은 `Row` 위젯을 사용하는 가장 기본적인 예입니다.

{% render docs/code-and-image.md, 
image:"fwe/layout/row.png", 
caption: "이 그림은 세 개의 children이 있는 row 위젯을 보여줍니다."
alt: "A screenshot of a row widget with three children"
code:"
```dart
Widget build(BuildContext context) {
  return Row(
    children: [
      BorderedImage(),
      BorderedImage(),
      BorderedImage(),
    ],
  );
}
```
" %}

`Row` 또는 `Column`의 각 child는 행과 열 자체가 될 수 있으며, 
결합하여 복잡한 레이아웃을 만들 수 있습니다. 
예를 들어, 위의 예에서 열을 사용하여, 각 이미지에 레이블을 추가할 수 있습니다.

{% render docs/code-and-image.md,
image:"fwe/layout/nested_row_column.png",
caption: "이 그림은 세 개의 children을 갖는 row 위젯을 보여주는데, 각각은 column 입니다."
alt: "A screenshot of a row of three widgets, each of which has a label underneath it."
code:"
```dart
Widget build(BuildContext context) {
  return Row(
    children: [
      Column(
        children: [
          BorderedImage(),
          Text('Dash 1'),
        ],
      ),
      Column(
        children: [
          BorderedImage(),
          Text('Dash 2'),
        ],
      ),
      Column(
        children: [
          BorderedImage(),
          Text('Dash 3'),
        ],
      ),
    ],
  );
}
```
" %}


### 행과 열 내에서 위젯 정렬 {:#align-widgets-within-rows-and-columns}

다음 예에서, 위젯은 각각 200픽셀 너비이고, 뷰포트는 700픽셀 너비입니다. 
따라서, 위젯은 왼쪽에 하나씩 정렬되고, 모든 추가 공간은 오른쪽에 있습니다.

<img src='/assets/images/docs/fwe/layout/left_alignment.png' alt="A diagram that shows three widgets laid out in a row. Each child widget is labeled as 200px wide, and the blank space on the right is labeled as 100px wide.">

`mainAxisAlignment` 및 `crossAxisAlignment` 속성을 사용하여, 
행 또는 열이 자식을 정렬하는 방식을 제어합니다. 
행의 경우, main 축은 수평으로, cross 축은 수직으로 실행됩니다. 
열의 경우, main 축은 수직으로, cross 축은 수평으로 실행됩니다.

<img src='/assets/images/docs/fwe/layout/axes_diagram.png' alt="A diagram that shows the direction of the main axis and cross axis in both rows and columns">

main 축 정렬을 `spaceEvenly`로 설정하면, 
여유 수평 공간이 각 이미지 사이, 이전, 이후에 균등하게 나뉩니다.

{% render docs/code-and-image.md,
image:"fwe/layout/space_evenly.png",
caption: "이 그림은 crossAxisAlignment.spaceEvenly 상수에 맞춰, 정렬된 세 개의 자식이 있는 행 위젯을 보여줍니다."
alt: "A screenshot of three widgets, spaced evenly from each other."
code:"
```dart
Widget build(BuildContext context) {
  return Row(
    [!mainAxisAlignment: MainAxisAlignment.spaceEvenly!],
    children: [
      BorderedImage(),
      BorderedImage(),
      BorderedImage(),
    ],
  );
}
```
" %}

열은 행과 같은 방식으로 작동합니다. 
다음 예는 각각 100픽셀 높이의 3개 이미지의 열을 보여줍니다. 
렌더 박스의 높이(이 경우 전체 화면)는 300픽셀 이상이므로, 
main 축 정렬을 `spaceEvenly`로 설정하면, 
각 이미지 사이, 위, 아래에 자유 수직 공간이 균등하게 나뉩니다.

<img src='/assets/images/docs/fwe/layout/col_space_evenly.png' alt="A screenshot of a three widgets laid out vertically, using a column widget.">

[`MainAxisAlignment`][] 및 [`CrossAxisAlignment`][] 열거형은, 
정렬을 제어하기 위한 다양한 상수를 제공합니다.

Flutter에는 정렬에 사용할 수 있는 다른 위젯이 포함되어 있으며, 
특히 `Align` 위젯이 있습니다.

### 행과 열 내에서 위젯 크기 조정 {:#sizing-widgets-within-rows-and-columns}

레이아웃이 장치에 맞지 않을 만큼 큰 경우,
영향을 받는 가장자리를 따라 노란색과 검은색 줄무늬 패턴이 나타납니다. 
이 예에서 뷰포트는 400픽셀 너비이고, 각 자식은 150픽셀 너비입니다.

<img src='/assets/images/docs/fwe/layout/overflowing_row.png' alt="A screenshot of a row of widgets that are wider than their viewport.">

위젯은 `Expanded` 위젯을 사용하여, 행이나 열에 맞게 크기를 조정할 수 있습니다. 
이미지 행이 렌더 상자에 비해 너무 넓은 이전 예를 수정하려면, 
각 이미지를 [`Expanded`][] 위젯으로 래핑합니다.

{% render docs/code-and-image.md,
image:"fwe/layout/expanded_row.png",
caption: "이 그림은 `Expanded` 위젯으로 래핑된 세 개의 자식이 있는 행 위젯을 보여줍니다."
alt: "A screenshot of three widgets, which take up exactly the amount of space available on the main axis. All three widgets are equal width."
code:"
```dart
Widget build(BuildContext context) {
  return const Row(
    children: [
      [!Expanded!](
        child: BorderedImage(width: 150, height: 150),
      ),
      [!Expanded!](
        child: BorderedImage(width: 150, height: 150),
      ),
      [!Expanded!](
        child: BorderedImage(width: 150, height: 150),
      ),
    ],
  );
}
```
" %}

`Expanded` 위젯은 위젯이 형제 위젯에 비해 얼마나 많은 공간을 차지해야 하는지 지시할 수도 있습니다. 
예를 들어, 위젯이 형제 위젯보다 두 배 많은 공간을 차지하도록 하고 싶을 수 있습니다. 
이를 위해 `Expanded` 위젯의 `flex` 속성을 사용합니다. 
이 속성은 위젯의 flex 계수를 결정하는 정수입니다. 
기본 flex 계수는 1입니다. 다음 코드는 가운데 이미지의 flex 계수를 2로 설정합니다.

{% render docs/code-and-image.md,
image:"fwe/layout/flex_2_row.png",
caption: "이 그림은 `Expanded` 위젯으로 래핑된 세 개의 자식이 있는 행 위젯을 보여줍니다. 가운데 자식은 `flex` 속성이 2로 설정되어 있습니다."
alt: "A screenshot of three widgets, which take up exactly the amount of space available on the main axis. The widget in the center is twice as wide as the widgets on the left and right."
code:"
```dart
Widget build(BuildContext context) {
  return const Row(
    children: [
      Expanded(
        child: BorderedImage(width: 150, height: 150),
      ),
      Expanded(
        [!flex: 2!],
        child: BorderedImage(width: 150, height: 150),
      ),
      Expanded(
        child: BorderedImage(width: 150, height: 150),
      ),
    ],
  );
}
```
" %}

## DevTools 및 디버깅 레이아웃 {:#devtools-and-debugging-layout}

특정 상황에서, 상자의 제약 조건은 무제한(unbounded)이거나 무한(infinite)합니다. 
즉, 최대 너비 또는 최대 높이가 [`double.infinity`][]로 설정됩니다. 
가능한 한 크게 만들려는 상자는 무제한(unbounded) 제약 조건이 주어지면 유용하게 작동하지 않으며, 
디버그 모드에서 예외가 발생합니다.

렌더 상자가 무제한(unbounded) 제약 조건으로 끝나는 가장 일반적인 경우는, 
flex 상자([`Row`][] 또는 [`Column`][]) 내부와 
scrollable 영역(예: [`ListView`][] 및 기타 [`ScrollView`][] 하위 클래스) 내부입니다. 
예를 들어, `ListView`는 교차 방향(cross-direction)으로 사용 가능한 공간에 맞게 확장하려고 합니다.
(수직 스크롤 블록이고 부모만큼 넓으려고 할 수 있음) 
수직 스크롤 `ListView`를 수평 스크롤 `ListView` 안에 중첩하면, 
안쪽 리스트는 가능한 한 넓게 만들려고 하는데, 
바깥쪽 리스트는 그 방향으로 스크롤할 수 있기 때문에 무한히 넓어집니다.

Flutter 애플리케이션을 빌드하는 동안 가장 흔히 발생하는 오류는, 
레이아웃 위젯을 잘못 사용하여 발생하는 오류로, "무제한 제약 조건(unbounded constraints)" 오류라고 합니다.

Flutter 앱을 처음 빌드할 때 마주칠 준비가 되어 있어야 할 유형 오류가 하나 있다면, 바로 이 오류입니다.

{% ytEmbed 'jckqXR5CrPI', 'Flutter 디코딩: Unbounded된 높이와 너비' %}

:::note 위젯 검사기
Flutter에는 Flutter 개발의 모든 측면을 다루는 데 도움이 되는 강력한 DevTools 모음이 있습니다. 
"Widget Inspector" 도구는 레이아웃을 빌드하고 디버깅할 때(그리고 일반적으로 위젯을 다룰 때) 특히 유용합니다.

[Flutter 검사기에 대해 자세히 알아보기][Learn more about the Flutter inspector].
:::

## 스크롤 위젯 {:#scrolling-widgets}

Flutter에는 자동으로 스크롤하는 내장 위젯이 많이 있으며, 
특정 스크롤 동작을 만들기 위해 사용자 정의할 수 있는 다양한 위젯도 제공합니다. 
이 페이지에서는, 어떤 페이지이든 scrollable로 만드는 가장 일반적인 위젯과, 
scrollable 리스트를 만드는 위젯을 사용하는 방법을 살펴보겠습니다.

### ListView {:#listview}

`ListView`는 콘텐츠가 렌더 상자보다 길 때 자동으로 스크롤을 제공하는 열과 같은 위젯(column-like widget)입니다. 
`ListView`를 사용하는 가장 기본적인 방법은 `Column` 또는 `Row`를 사용하는 것과 매우 유사합니다. 
열이나 행과 달리, `ListView`는 아래 예에서 볼 수 있듯이, 
children이 교차(cross) 축에서 사용 가능한 모든 공간을 차지해야 합니다.

{% render docs/code-and-image.md,
image:"fwe/layout/basic_listview.png",
caption: "이 그림은 세 개의 자식이 있는 ListView 위젯을 보여줍니다."
alt: "A screenshot of three widgets laid out vertically. They have expanded to take up all available space on the cross axis."
code:"
```dart
Widget build(BuildContext context) {
  return [!ListView!](
    children: const [
      BorderedImage(),
      BorderedImage(),
      BorderedImage(),
    ],
  );
}
```
" %}

`ListView`는 일반적으로 알려지지 않았거나, 
매우 큰(또는 무한한) 리스트 아이템이 있는 경우 사용됩니다. 
이 경우, `ListView.builder` 생성자를 사용하는 것이 가장 좋습니다. 
빌더 생성자는 현재 화면에 표시되는 자식만 빌드합니다.

다음 예에서, `ListView`는 to-do 아이템 리스트를 표시합니다. 
to-do 아이템은 리포지토리에서 가져오므로, to-do의 수는 알 수 없습니다.


{% render docs/code-and-image.md,
image:"fwe/layout/listview_builder.png",
caption: "이 그림은 알 수 없는 개수의 자식을 표시하는 ListView.builder 생성자를 보여줍니다."
alt: "A screenshot of several widgets laid out vertically. They have expanded to take up all available space on the cross axis."
code:"
```dart
final List<ToDo> items = Repository.fetchTodos();

Widget build(BuildContext context) {
  return ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, idx) {
      var item = items[idx];
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(item.description),
            Text(item.isComplete),
          ],
        ),
      );
    },
  );
}
```
" %}

## 적응형 레이아웃 {:#adaptive-layouts}

Flutter는 모바일, 태블릿, 데스크톱, _및_ 웹 앱을 만드는 데 사용되므로, 
화면 크기나 입력 장치와 같은 것에 따라 다르게 동작하도록 애플리케이션을 조정해야 할 가능성이 높습니다. 
이를 앱을 _적응형(adaptive)_ 및 _반응형(responsive)_ 으로 만드는 것으로 합니다.

적응형 레이아웃을 만드는 데 가장 유용한 위젯 중 하나는 [`LayoutBuilder`][] 위젯입니다. 
`LayoutBuilder`는 Flutter에서 "빌더" 패턴을 사용하는 많은 위젯 중 하나입니다.

### 빌더 패턴 {:#the-builder-pattern}

Flutter에서는 이름이나 생성자에 "builder"라는 단어를 사용하는 위젯이 여러 개 있습니다. 
다음 리스트가 전부는 아닙니다.

* [`ListView.builder`][]
* [`Gridview.builder`][]
* [`Builder`][]
* [`LayoutBuilder`][]
* [`FutureBuilder`][]

이러한 다양한 "빌더"는 다양한 문제를 해결하는 데 유용합니다. 
예를 들어, `ListView.builder` 생성자는 주로 리스트의 아이템을 지연(lazily) 렌더링하는 데 사용되는 반면, 
`Builder` 위젯은 심층적인 위젯 코드에서 `BuildContext`에 액세스하는 데 유용합니다.

사용 사례가 다르지만, 이러한 빌더는 작동 방식이 통합되어 있습니다. 
빌더 위젯과 빌더 생성자는 모두 `builder`(또는 `ListView.builder`의 경우 `itemBuilder`와 같은 유사한 이름)라는 인수를 갖고 있으며, 
빌더 인수는 항상 콜백을 허용합니다. 
이 콜백은 __빌더 함수(builder function)__ 입니다. 
빌더 함수는 부모 위젯에 데이터를 전달하는 콜백이며, 
부모 위젯은 이러한 인수를 사용하여 자식 위젯을 빌드하고 반환합니다. 
빌더 함수는 항상 최소한 하나의 인수(build context)와 일반적으로 최소한 하나의 다른 인수를 전달합니다.

예를 들어, `LayoutBuilder` 위젯은 뷰포트의 크기에 따라 반응형 레이아웃을 만드는 데 사용됩니다. 
빌더 콜백 본문에는 부모로부터 받은 [`BoxConstraints`][]와 위젯 'BuildContext'가 함께 전달됩니다. 
이러한 제약 조건을 사용하면, 사용 가능한 공간에 따라 다른 위젯을 반환할 수 있습니다.

{% ytEmbed 'IYDVcriKjsw', 'LayoutBuilder (Flutter Widget of the Week)' %}

다음 예제에서, `LayoutBuilder`가 반환하는 위젯은, 
뷰포트가 600픽셀 이하인지, 600픽셀보다 큰지에 따라 변경됩니다.

{% render docs/code-and-image.md,
image:"fwe/layout/layout_builder.png",
caption: "이 그림은 자식 요소들을 수직으로 배치하는 좁은 레이아웃과, 자식 요소들을 그리드로 배치하는 넓은 레이아웃을 보여줍니다."
alt: "Two screenshots, in which one shows a narrow layout and the other shows a wide layout."
code:"
```dart
Widget build(BuildContext context) {
  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      [!if (constraints.maxWidth <= 600)!] {
        return _MobileLayout();
      } else {
        return _DesktopLayout();
      }
    },
  );
}
```
" %}

한편, `ListView.builder` 생성자의 `itemBuilder` 콜백은 빌드 컨텍스트와 `int`를 전달받습니다. 
이 콜백은 리스트의 모든 아이템에 대해 한 번씩 호출되고, int 인수는 리스트 아이템의 인덱스를 나타냅니다. 
Flutter가 UI를 빌드할 때 itemBuilder 콜백이 처음 호출될 때, 
함수에 전달된 int는 0이고, 두 번째에는 1이 되는 식입니다.

이를 통해 인덱스에 따라 특정 구성을 제공할 수 있습니다. 
`ListView.builder` 생성자를 사용하는 위의 예를 떠올려 보세요.

```dart
final List<ToDo> items = Repository.fetchTodos();

Widget build(BuildContext context) {
  return ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, idx) {
      var item = items[idx];
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(item.description),
            Text(item.isComplete),
          ],
        ),
      );
    },
  );
}
```

이 예제 코드는 빌더에 전달된 인덱스를 사용하여 아이템 리스트에서, 
올바른 todo를 가져온 다음 빌더에서 반환된 위젯에 해당 todo의 데이터를 표시합니다.

이를 예시하기 위해, 다음 예제는 다른 모든 리스트 아이템의 배경색을 변경합니다.

{% render docs/code-and-image.md,
image:"fwe/layout/alternating_list_items.png"
caption:"이 그림은 `ListView`를 보여줍니다. 여기서 자식은 번갈아 가며 배경색을 갖습니다. 배경색은 `ListView` 내의 자식 인덱스를 기반으로 프로그래밍 방식으로 결정되었습니다."
code:"
```dart
final List<ToDo> items = Repository.fetchTodos();

Widget build(BuildContext context) {
  return ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, idx) {
      var item = items[idx];
      return Container(
        [!color: idx % 2 == 0 ? Colors.lightBlue : Colors.transparent!],
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(item.description),
            Text(item.isComplete),
          ],
        ),
      );
    },
  );
}
```
" %}

## 추가 리소스 {:#additional-resources}

* 일반적인 레이아웃 위젯 및 개념
  * 비디오: [OverlayPortal—주간 Flutter 위젯][OverlayPortal—Flutter Widget of the Week]
  * 비디오: [Stack—주간 Flutter 위젯][Stack—Flutter Widget of the Week]
  * 튜토리얼: [Flutter의 레이아웃][Layouts in Flutter]
  * 문서: [Stack 문서][Stack documentation]
* 위젯 크기 조정 및 위치 지정
  * 비디오: [Expanded—주간 Flutter 위젯][Expanded—Flutter Widget of the Week]
  * 비디오: [Flexible—주간 Flutter 위젯][Flexible—Flutter Widget of the Week]
  * 비디오: [Intrinsic 위젯—Flutter 디코딩][Intrinsic widgets—Decoding Flutter]
* Scrollable 위젯
  * 예제 코드: [긴 리스트로 작업][Work with long lists]
  * 예제 코드: [수평 리스트 만들기][Create a horizontal list]
  * 예제 코드: [그리드 리스트 만들기][Create a grid list]
  * 비디오: [ListView—주간 Flutter 위젯][ListView—Flutter Widget of the Week]
* 적응형 앱
  * 튜토리얼: [적응형 앱 코드랩][Adaptive Apps codelab]
  * 비디오: [MediaQuery—주간 Flutter 위젯][MediaQuery—Flutter Widget of the Week]
  * 비디오: [적응형 플랫폼 구축 앱][Building platform adaptive apps]
  * 비디오: [Builder—주간 Flutter 위젯][Builder—Flutter Widget of the Week]

### API 참조 {:#api-reference}

다음 리소스에서는 개별 API를 설명합니다.

* [`Builder`][]
* [`Row`][]
* [`Column`][]
* [`Expanded`][]
* [`Flexible`][]
* [`ListView`][]
* [`Stack`][]
* [`Positioned`][]
* [`MediaQuery`][]
* [`LayoutBuilder`][]

[Layouts in Flutter]: /ui/layout
[Understanding constraints article]: /ui/layout/constraints
[`RenderBox`]: {{site.api}}/flutter/rendering/RenderBox-class.html
[Expanded—Flutter Widget of the Week]: {{site.youtube-site}}/watch?v=_rnZaagadyo
[Flexible—Flutter Widget of the Week]: {{site.youtube-site}}/watch?v=CI7x0mAZiY0
[Intrinsic widgets—Decoding Flutter]: {{site.youtube-site}}/watch?v=Si5XJ_IocEs
[Build a Flutter Layout]: /ui/layout/tutorial
[Basic scrolling]: /ui/layout/scrolling#basic-scrolling
[Builder—Flutter Widget of the Week]: {{site.youtube-site}}/watch?v=xXNOkIuSYuA
[ListView—Flutter Widget of the Week]: {{site.youtube-site}}/watch?v=KJpkjHGiI5A
[Work with long lists]: /cookbook/lists/long-lists
[Create a horizontal list]: /cookbook/lists/horizontal-list
[Create a grid list]: /cookbook/lists/grid-lists
[PageView—Flutter Widget of the Week]: {{site.youtube-site}}/watch?v=J1gE9xvph-A
[Stack—Flutter Widget of the Week]: {{site.youtube-site}}/watch?v=liEGSeD3Zt8
[Stack documentation]: /ui/layout#stack
[OverlayPortal—Flutter Widget of the Week]: {{site.youtube-site}}/watch?v=S0Ylpa44OAQ
[LayoutBuilder—Flutter Widget of the Week]: {{site.youtube-site}}/watch?v=IYDVcriKjsw
[MediaQuery—Flutter Widget of the Week]: {{site.youtube-site}}/watch?v=A3WrA4zAaPw
[Adaptive apps codelab]: {{site.codelabs}}/codelabs/flutter-adaptive-app
[Building platform adaptive apps]: {{site.youtube-site}}/watch?v=RCdeSKVt7LI
[Learn more about the Flutter inspector]: /tools/devtools/inspector
[Unbounded height and width—Decoding Flutter]: {{site.youtube-site}}/watch?v=jckqXR5CrPI
[2D Scrolling]: {{site.youtube-site}}/watch?v=ppEdTo-VGcg
[`Builder`]: {{site.api}}/flutter/widgets/Builder-class.html
[`Row`]: {{site.api}}/flutter/widgets/Row-class.html
[`Column`]: {{site.api}}/flutter/widgets/Column-class.html
[`Expanded`]: {{site.api}}/flutter/widgets/Expanded-class.html
[`Flexible`]: {{site.api}}/flutter/widgets/Flexible-class.html
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
[`Stack`]: {{site.api}}/flutter/widgets/Stack-class.html
[`Positioned`]: {{site.api}}/flutter/widgets/Positioned-class.html
[`MediaQuery`]: {{site.api}}/flutter/widgets/MediaQuery-class.html
[`Transform`]:{{site.api}}/flutter/widgets/Transform-class.html
[`Opacity`]:{{site.api}}/flutter/widgets/Opacity-class.html
[`Center`]:{{site.api}}/flutter/widgets/Center-class.html
[`ListView`]:{{site.api}}/flutter/widgets/Listview-class.html
[`Image`]:{{site.api}}/flutter/widgets/Image-class.html
[`Text`]:{{site.api}}/flutter/widgets/Text-class.html
[`MainAxisAlignment`]: {{site.api}}/flutter/rendering/MainAxisAlignment.html
[`CrossAxisAlignment`]: {{site.api}}/flutter/rendering/CrossAxisAlignment.html
[`double.infinity`]:{{site.api}}/flutter/dart-core/double/infinity-constant.html
[`ListView.builder`]: {{site.api}}/flutter/widgets/ListView/ListView.builder.html
[`Gridview.builder`]: {{site.api}}/flutter/widgets/GridView/Gridview.builder.html
[`Builder`]: {{site.api}}/flutter/widgets/Builder-class.html
[`ScrollView`]: {{site.api}}/flutter/widgets/Scrollview-class.html
[`LayoutBuilder`]: {{site.api}}/flutter/widgets/LayoutBuilder-class.html
[`BoxConstraints`]:{{site.api}}/flutter/rendering/BoxConstraints-class.html 
[`LayoutBuilder`]: {{site.api}}/flutter/widgets/LayoutBuilder-class.html
[`FutureBuilder`]: {{site.api}}/flutter/widgets/FutureBuilder-class.html
[`Container`]:{{site.api}}/flutter/widgets/Container-class.html
[`Column`]:{{site.api}}/flutter/widgets/Column-class.html
[`Row`]:{{site.api}}/flutter/widgets/Row-class.html
[`Expanded`]: {{site.api}}/flutter/widgets/Expanded-class.html

## 피드백 {:#feedback}

이 웹사이트의 이 섹션이 발전할 수 있기 때문에, 우리는 [당신의 피드백을 환영합니다][welcome your feedback]!

[welcome your feedback]: https://google.qualtrics.com/jfe/form/SV_6A9KxXR7XmMrNsy?page="layout"
