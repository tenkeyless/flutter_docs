---
# title: Layouts in Flutter
title: Flutter의 레이아웃
# short-title: Layout
short-title: 레이아웃
# description: Learn how Flutter's layout mechanism works and how to build a layout.
description: Flutter의 레이아웃 메커니즘이 작동하는 방식과 레이아웃을 구축하는 방법을 알아보세요.
---

{% assign api = site.api | append: '/flutter' -%}
{% capture examples -%} {{site.repo.this}}/tree/{{site.branch}}/examples {%- endcapture -%}

<?code-excerpt path-base=""?>

<style>dl, dd { margin-bottom: 0; }</style>

:::secondary 요점은 무엇인가요?
* 위젯은 UI를 빌드하는 데 사용되는 클래스입니다.
* 위젯은 레이아웃과 UI 요소 모두에 사용됩니다.
* 간단한 위젯을 구성하여, 복잡한 위젯을 빌드합니다.
:::

Flutter 레이아웃 메커니즘의 핵심은 위젯입니다. 
Flutter에서는, 거의 모든 것이 위젯입니다. (심지어 레이아웃 모델도 위젯입니다.) 
Flutter 앱에서 보이는 이미지, 아이콘, 텍스트는 모두 위젯입니다. 
하지만 보이지 않는 것도 위젯입니다. 
예를 들어, 행, 열, (보이는 위젯을 배치하고 제한하며, 정렬하는) 그리드가 있습니다.

위젯을 구성하여, 더 복잡한 위젯을 빌드하여 레이아웃을 만듭니다. 
예를 들어, 아래 첫 번째 스크린샷은 각각 아래에 레이블이 있는 3개의 아이콘을 보여줍니다.

<div class="row mb-4">
  <div class="col-12 text-center">
    <img src='/assets/images/docs/ui/layout/lakes-icons.png' class="border mt-1 mb-1 mw-100" alt="Sample layout">
    <img src='/assets/images/docs/ui/layout/lakes-icons-visual.png' class="border mt-1 mb-1 mw-100" alt="Sample layout with visual debugging">
  </div>
</div>

두 번째 스크린샷은 시각적 레이아웃을 보여줍니다. 
각 열에 아이콘과 레이블이 포함된 3개 열의 행이 표시됩니다.

:::note
이 튜토리얼의 스크린샷 대부분은 `debugPaintSizeEnabled`를 `true`로 설정하여 표시되므로, 시각적 레이아웃을 볼 수 있습니다. 자세한 내용은, [Flutter 인스펙터 사용][Using the Flutter inspector]의 섹션인 [시각적으로 레이아웃 이슈 디버깅][Debugging layout issues visually]을 참조하세요.
:::

이 UI의 위젯 트리 다이어그램은 다음과 같습니다.

<img src='/assets/images/docs/ui/layout/sample-flutter-layout.png' class="mw-100 text-center" alt="Node tree">

대부분은 예상대로 보일 것이지만, 컨테이너(분홍색으로 표시)에 대해 궁금할 수 있습니다. 
[`Container`][]는 자식 위젯을 커스터마이즈 할 수 있는 위젯 클래스입니다. 
패딩, 여백, 테두리 또는 배경색을 추가하려는 경우, `Container`를 사용하여, 일부 기능을 지정할 수 있습니다.

이 예에서, 각 [`Text`][] 위젯은 여백을 추가하기 위해 `Container`에 배치됩니다. 
전체 [`Row`][]도 행 주위에 패딩을 추가하기 위해 `Container`에 배치됩니다.

이 예에서 나머지 UI는 속성으로 제어됩니다. 
`color` 속성을 사용하여 [`Icon`][]의 색상을 설정합니다. 
`Text.style` 속성을 사용하여 글꼴, 색상, 두께 등을 설정합니다. 
열과 행에는 자식이 수직 또는 수평으로 정렬되는 방식과, 자식이 차지해야 하는 공간의 양을 지정할 수 있는 속성이 있습니다.

## 위젯 레이아웃 {:#lay-out-a-widget}

Flutter에서 단일 위젯을 어떻게 배치하나요? 
이 섹션에서는 간단한 위젯을 만들고 표시하는 방법을 보여줍니다. 
또한 간단한 Hello World 앱의 전체 코드도 보여줍니다.

Flutter에서는, 몇 단계만 거치면 텍스트, 아이콘 또는 이미지를 화면에 배치할 수 있습니다.

### 1. 레이아웃 위젯 선택 {:#1-select-a-layout-widget}

표시되는 위젯을 정렬하거나 제한하는 방법에 따라 다양한 [레이아웃 위젯][layout widgets] 중에서 선택하세요. 
이러한 특성은 일반적으로 포함된 위젯으로 전달됩니다.

이 예에서는 [`Center`][]를 사용하여 콘텐츠를 수평 및 수직으로 가운데에 배치합니다.

### 2. 눈에 보이는 위젯 만들기 {:#2-create-a-visible-widget}

예를 들어, [`Text`][] 위젯을 만듭니다.

<?code-excerpt "layout/base/lib/main.dart (text)" replace="/child: //g"?>
```dart
Text('Hello World'),
```

[`Image`][] 위젯을 만듭니다.

<?code-excerpt "layout/lakes/step5/lib/main.dart (image-asset)" remove="/width|height/"?>
```dart
return Image.asset(
  image,
  fit: BoxFit.cover,
);
```

[`Icon`][] 위젯을 만듭니다.

<?code-excerpt "layout/lakes/step5/lib/main.dart (icon)"?>
```dart
Icon(
  Icons.star,
  color: Colors.red[500],
),
```

### 3. 레이아웃 위젯에 보이는 위젯 추가 {:#3-add-the-visible-widget-to-the-layout-widget}

<?code-excerpt path-base="layout/base"?>

모든 레이아웃 위젯에는 다음 중 하나가 있습니다.

* 단일 자식을 취하는 경우, `child` 속성 (예: `Center` 또는 `Container`)
* 위젯 리스트를 취하는 경우, `children` 속성 (예: `Row`, `Column`, `ListView` 또는 `Stack`)

`Text` 위젯을 `Center` 위젯에 추가합니다.

<?code-excerpt "lib/main.dart (centered-text)" replace="/body: //g"?>
```dart
const Center(
  child: Text('Hello World'),
),
```

### 4. 페이지에 레이아웃 위젯 추가 {:#4-add-the-layout-widget-to-the-page}

Flutter 앱 자체가 위젯이고, 대부분의 위젯에는 [`build()`][] 메서드가 있습니다. 
앱의 `build()` 메서드에서 위젯을 인스턴스화하고 반환하면 위젯이 표시됩니다.

#### Material 앱 {:#material-apps}

`Material` 앱의 경우, [`Scaffold`][] 위젯을 사용할 수 있습니다. 
여기에는 기본 배너, 배경색을 제공하고, drawers, 스낵바, 바텀 시트를 추가하기 위한 API가 있습니다. 
그런 다음, `Center` 위젯을 홈 페이지의 `body` 속성에 직접 추가할 수 있습니다.

<?code-excerpt path-base="layout/base"?>
<?code-excerpt "lib/main.dart (my-app)"?>
```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Flutter layout demo';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
```

:::note
[Material 라이브러리][Material library]는 [Material Design][] 원칙을 따르는 위젯을 구현합니다. 
UI를 디자인할 때, 
표준 [위젯 라이브러리][widgets library]의 위젯만 사용하거나, Material 라이브러리의 위젯을 사용할 수 있습니다. 
두 라이브러리의 위젯을 혼합하거나, 기존 위젯을 커스터마이즈하거나 커스텀 위젯 세트를 직접 빌드할 수 있습니다.
:::

#### Cupertino 앱 {:#cupertino-apps}

`Cupertino` 앱을 만들려면, `CupertinoApp` 및 [`CupertinoPageScaffold`][] 위젯을 사용하세요.

`Material`과 달리, 기본 배너나 배경색을 제공하지 않습니다. 직접 설정해야 합니다.

* 기본 색상을 설정하려면, 구성된 [`CupertinoThemeData`][]를 앱의 `theme` 속성에 전달합니다.
* 앱 상단에 iOS 스타일의 네비게이션 바를 추가하려면, 
  [`CupertinoNavigationBar`][] 위젯을 scaffold의 `navigationBar` 속성에 추가합니다. 
  [`CupertinoColors`][]가 제공하는 색상을 사용하여 위젯을 iOS 디자인과 일치하도록 구성할 수 있습니다.
* 앱의 body를 레이아웃 하려면, 
  scaffold의 `child` 속성을 `Center` 또는 `Column`과 같이 원하는 위젯을 값으로 설정합니다.

추가할 수 있는 다른 UI 구성 요소를 알아보려면, [Cupertino 라이브러리][Cupertino library]를 확인하세요.

<?code-excerpt "lib/cupertino.dart (my-app)"?>
```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Flutter layout demo',
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CupertinoColors.systemBlue,
      ),
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: CupertinoColors.systemGrey,
          middle: Text('Flutter layout demo'),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Hello World'),
            ],
          ),
        ),
      ),
    );
  }
}
```

:::note
[Cupertino 라이브러리][Cupertino library]는 [iOS용 Apple의 휴먼 인터페이스 가이드라인][Apple's Human Interface Guidelines for iOS]을 따르는 위젯을 구현합니다. 
UI를 디자인할 때, 표준 [위젯 라이브러리][widgets library] 또는 Cupertino 라이브러리의 위젯을 사용할 수 있습니다. 
두 라이브러리의 위젯을 혼합하거나 기존 위젯을 커스터마이즈하거나, 커스텀 위젯 세트를 직접 빌드할 수 있습니다.
:::

[`CupertinoColors`]: {{api}}/cupertino/CupertinoColors-class.html
[`CupertinoThemeData`]: {{api}}/cupertino/CupertinoThemeData-class.html
[`CupertinoNavigationBar`]: {{api}}/cupertino/CupertinoNavigationBar-class.html
[Apple's Human Interface Guidelines for iOS]: {{site.apple-dev}}/design/human-interface-guidelines/designing-for-ios

#### Non-Material 앱 {:#non-material-apps}

Material이 아닌 앱의 경우, 앱의 `build()` 메서드에 `Center` 위젯을 추가할 수 있습니다.

<?code-excerpt path-base="layout/non_material"?>
<?code-excerpt "lib/main.dart (my-app)"?>
```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: const Center(
        child: Text(
          'Hello World',
          textDirection: TextDirection.ltr,
          style: TextStyle(
            fontSize: 32,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
```

기본적으로 non-Material 앱에는 `AppBar`, 제목 또는 배경색이 포함되지 않습니다. 
non-Material 앱에서 이러한 기능을 원하면 직접 빌드해야 합니다. 
이 앱은 Material 앱을 모방하기 위해 배경색을 흰색으로, 텍스트를 진한 회색으로 변경합니다.

<div class="row">
<div class="col-md-6">

  그게 다입니다! 앱을 실행하면 _Hello World_ 가 표시되어야 합니다.

  앱 소스 코드:

  * [Material 앱]({{examples}}/layout/base)
  * [Non-Material 앱]({{examples}}/layout/non_material)

</div>
<div class="col-md-6">
  {% render docs/app-figure.md, img-class:"site-mobile-screenshot border w-75", image:"ui/layout/hello-world.png", alt:"Hello World" %}
</div>
</div>

<hr>

## 여러 위젯을 수직 및 수평으로 레이아웃 {:#lay-out-multiple-widgets-vertically-and-horizontally}

<?code-excerpt path-base=""?>

가장 일반적인 레이아웃 패턴 중 하나는 위젯을 수직 또는 수평으로 배열하는 것입니다. 
`Row` 위젯을 사용하여 위젯을 수평으로 배열하고, 
`Column` 위젯을 사용하여 위젯을 수직으로 배열할 수 있습니다.

:::secondary 요점은 무엇인가요?
* `Row`와 `Column`은 가장 일반적으로 사용되는 두 가지 레이아웃 패턴입니다.
* `Row`와 `Column`은 각각 자식 위젯 리스트를 취합니다.
* 자식 위젯 자체는 `Row`, `Column` 또는 기타 복잡한 위젯이 될 수 있습니다.
* `Row` 또는 `Column`이 자식을, 수직 및 수평으로, 정렬하는 방법을 지정할 수 있습니다.
* 특정 자식 위젯을 늘리거나(stretch) 제한(constrain)할 수 있습니다.
* 자식 위젯이 `Row` 또는 `Column`의 사용 가능한 공간을 사용하는 방법을 지정할 수 있습니다.
:::

Flutter에서 행이나 열을 만들려면, 
[`Row`][] 또는 [`Column`][] 위젯에 자식 위젯 리스트를 추가합니다. 
그러면, 각 자식이 행이나 열이 될 수 있습니다. 
다음 예에서는 행이나 열 안에 행이나 열을 중첩하는 방법을 보여줍니다.

이 레이아웃은 `Row`로 구성됩니다. 
행에는 두 개의 자식이 있습니다. : 왼쪽에 열이 있고 오른쪽에 이미지가 있습니다.

<img src='/assets/images/docs/ui/layout/pavlova-diagram.png' class="mw-100"
    alt="Screenshot with callouts showing the row containing two children">

왼쪽 열의 위젯 트리는 행과 열을 중첩합니다.

<img src='/assets/images/docs/ui/layout/pavlova-left-column-diagram.png' class="mw-100"
    alt="Diagram showing a left column broken down to its sub-rows and sub-columns">

[행과 열 중첩](#nesting-rows-and-columns)에서 Pavlova의 레이아웃 코드 중 일부를 구현해 보겠습니다.

:::note
`Row`와 `Column`은 가로 및 세로 레이아웃을 위한 기본적인 primitive 위젯입니다. 
이러한 낮은 레벨 위젯은 최대한의 커스터마이즈를 허용합니다. 

Flutter는 또한 귀하의 요구 사항에 충분할 수 있는 전문화된 높은 레벨 위젯을 제공합니다. 

예를 들어, 

* `Row` 대신 (leading 및 trailing 아이콘과 최대 3줄의 텍스트에 대한 속성이 있는 사용하기 쉬운 위젯인) [`ListTile`][]을 선호할 수 있습니다. 
* `Column` 대신 (콘텐츠가 사용 가능한 공간에 맞지 않을 때 자동으로 스크롤되는 컬럼과 비슷한 레이아웃인) [`ListView`][]를 선호할 수 있습니다. 

자세한 내용은 [일반적인 레이아웃 위젯][Common layout widgets]을 참조하세요.
:::

### 위젯 정렬 {:#aligning-widgets}

`mainAxisAlignment` 및 `crossAxisAlignment` 속성을 사용하여, 
행 또는 열이 자식을 정렬하는 방식을 제어합니다. 
행(Row)의 경우, 메인 축은 수평으로, 교차 축은 수직으로 실행됩니다. 
열(Column)의 경우, 메인 축은 수직으로, 교차 축은 수평으로 실행됩니다.

<div class="mb-2 text-center">
  <img src='/assets/images/docs/ui/layout/row-diagram.png' class="mb-2 mw-100"
      alt="Diagram showing the main axis and cross axis for a row">
  <img src='/assets/images/docs/ui/layout/column-diagram.png' class="mb-2 mr-2 ml-2 mw-100"
      alt="Diagram showing the main axis and cross axis for a column">
</div>

[`MainAxisAlignment`][] 및 [`CrossAxisAlignment`][] 열거형은 정렬을 제어하기 위한 다양한 상수를 제공합니다.

:::note
프로젝트에 이미지를 추가할 때는, `pubspec.yaml` 파일을 업데이트하여 액세스해야 합니다. 
이 예에서는, `Image.asset`을 사용하여 이미지를 표시합니다. 

자세한 내용은 이 예의 [`pubspec.yaml` 파일][`pubspec.yaml` file] 또는 [assets 및 이미지 추가][Adding assets and images]를 참조하세요. 

`Image.network`를 사용하여 온라인 이미지를 참조하는 경우 이 작업을 수행할 필요가 없습니다.
:::

다음 예에서, 3개 이미지의 각각은 100픽셀 너비입니다. 
렌더 박스(이 경우, 전체 화면)는 300픽셀 너비가 넘으므로, 
메인 축 정렬을 `spaceEvenly`로 설정하면, 각 이미지 사이, 이전, 이후에 비어 있는 수평 공간이 균등하게 나뉩니다.

<div class="row">
<div class="col-lg-8">

  <?code-excerpt "layout/row_column/lib/main.dart (row)" replace="/Row/[!$&!]/g"?>
  ```dart
  [!Row!](
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Image.asset('images/pic1.jpg'),
      Image.asset('images/pic2.jpg'),
      Image.asset('images/pic3.jpg'),
    ],
  );
  ```

</div>
<div class="col-lg-4">
  <img src='/assets/images/docs/ui/layout/row-spaceevenly-visual.png' class="mw-100" alt="Row with 3 evenly spaced images">

  **App source:** [row_column]({{examples}}/layout/row_column)
</div>
</div>

열은 행과 같은 방식으로 작동합니다. 
다음 예는 각각 100픽셀 높이의 3개 이미지의 열을 보여줍니다. 
렌더 박스의 높이(이 경우 전체 화면)는 300픽셀 이상이므로, 
메인 축 정렬을 `spaceEvenly`로 설정하면, 각 이미지 사이, 위, 아래에 비어있는 수직 공간이 균등하게 나뉩니다.

<div class="row">
<div class="col-lg-8">

  <?code-excerpt "layout/row_column/lib/main.dart (column)" replace="/Column/[!$&!]/g"?>
  ```dart
  [!Column!](
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Image.asset('images/pic1.jpg'),
      Image.asset('images/pic2.jpg'),
      Image.asset('images/pic3.jpg'),
    ],
  );
  ```

  **앱 소스:** [row_column]({{examples}}/layout/row_column)

</div>
<div class="col-lg-4 text-center">
  <img src='/assets/images/docs/ui/layout/column-visual.png' class="mb-4" height="250px"
      alt="Column showing 3 images spaced evenly">
</div>
</div>

### 위젯 크기 조정 {:#sizing-widgets}

레이아웃이 장치에 맞지 않을 만큼 너무 큰 경우, 
영향을 받는 가장자리를 따라 노란색과 검은색 줄무늬 패턴이 나타납니다. 
너무 넓은 행의 [예][sizing]는 다음과 같습니다.

<img src='/assets/images/docs/ui/layout/layout-too-large.png' class="mw-100 text-center" alt="Overly-wide row">

위젯은 [`Expanded`][] 위젯을 사용하여, 행이나 열에 맞게 크기를 조정될 수 있습니다. 
이미지 행이 렌더 상자에 비해 너무 넓은 이전 예를 수정하려면, 각 이미지를 `Expanded` 위젯으로 래핑합니다.

<div class="row">
<div class="col-lg-8">

  <?code-excerpt "layout/sizing/lib/main.dart (expanded-images)" replace="/Expanded/[!$&!]/g"?>
  ```dart
  Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      [!Expanded!](
        child: Image.asset('images/pic1.jpg'),
      ),
      [!Expanded!](
        child: Image.asset('images/pic2.jpg'),
      ),
      [!Expanded!](
        child: Image.asset('images/pic3.jpg'),
      ),
    ],
  );
  ```

</div>
<div class="col-lg-4">
  <img src='/assets/images/docs/ui/layout/row-expanded-2-visual.png' class="mw-100"
      alt="Row of 3 images that are too wide, but each is constrained to take only 1/3 of the space">

  **앱 소스:** [sizing]({{examples}}/layout/sizing)
</div>
</div>

위젯이 형제 위젯보다 두 배나 많은 공간을 차지하기를 원할 수도 있습니다. 
이를 위해, `Expanded` 위젯 `flex` 속성을 사용합니다. 
이 속성은 위젯의 flex 계수를 결정하는 정수입니다. 기본 flex 계수는 1입니다. 
다음 코드는 가운데 이미지의 flex 계수를 2로 설정합니다.

<div class="row">
<div class="col-lg-8">

  <?code-excerpt "layout/sizing/lib/main.dart (expanded-images-with-flex)" replace="/flex.*/[!$&!]/g"?>
  ```dart
  Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        child: Image.asset('images/pic1.jpg'),
      ),
      Expanded(
        [!flex: 2,!]
        child: Image.asset('images/pic2.jpg'),
      ),
      Expanded(
        child: Image.asset('images/pic3.jpg'),
      ),
    ],
  );
  ```

</div>
<div class="col-lg-4">
  <img src='/assets/images/docs/ui/layout/row-expanded-visual.png' class="mw-100"
      alt="Row of 3 images with the middle image twice as wide as the others">

  **앱 소스:** [sizing]({{examples}}/layout/sizing)
</div>
</div>

[sizing]: {{examples}}/layout/sizing

### 위젯 포장 {:#packing-widgets}

기본적으로, 행이나 열은 메인 축을 따라 가능한 한 많은 공간을 차지하지만, 
자식을 서로 가깝게 패킹하려면 `mainAxisSize`를 `MainAxisSize.min`으로 설정합니다. 
다음 예에서는 이 속성을 사용하여 별 아이콘을 함께 패킹합니다.

<div class="row">
<div class="col-lg-8">

  <?code-excerpt "layout/pavlova/lib/main.dart (stars)" replace="/mainAxisSize.*/[!$&!]/g; /\w+ \w+ = //g; /;//g"?>
  ```dart
  Row(
    [!mainAxisSize: MainAxisSize.min,!]
    children: [
      Icon(Icons.star, color: Colors.green[500]),
      Icon(Icons.star, color: Colors.green[500]),
      Icon(Icons.star, color: Colors.green[500]),
      const Icon(Icons.star, color: Colors.black),
      const Icon(Icons.star, color: Colors.black),
    ],
  )
  ```

</div>
<div class="col-lg-4">
  <img src='/assets/images/docs/ui/layout/packed.png' class="border mw-100"
      alt="Row of 5 stars, packed together in the middle of the row">

  **앱 소스:** [pavlova]({{examples}}/layout/pavlova)
</div>
</div>

### 행과 열 중첩 {:#nesting-rows-and-columns}

레이아웃 프레임워크를 사용하면 행과 열을 필요한 만큼 깊이로 행과 열 안에 중첩할 수 있습니다. 
다음 레이아웃의 윤곽이 그려진 섹션에 대한 코드를 살펴보겠습니다.

<img src='/assets/images/docs/ui/layout/pavlova-large-annotated.png' class="border mw-100 text-center"
    alt="Screenshot of the pavlova app, with the ratings and icon rows outlined in red">

개요 섹션은 두 행으로 구현됩니다. 
평점 행에는 별 5개와 리뷰 수가 포함됩니다. 
아이콘 행에는 아이콘과 텍스트의 세 열이 포함됩니다.

평점 행의 위젯 트리:

<img src='/assets/images/docs/ui/layout/widget-tree-pavlova-rating-row.png' class="mw-100 text-center" alt="Ratings row widget tree">

`ratings` 변수는 5개 별 아이콘과 텍스트로 구성된 작은 행을 생성합니다.

<?code-excerpt "layout/pavlova/lib/main.dart (ratings)" replace="/ratings/[!$&!]/g"?>
```dart
final stars = Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    Icon(Icons.star, color: Colors.green[500]),
    Icon(Icons.star, color: Colors.green[500]),
    Icon(Icons.star, color: Colors.green[500]),
    const Icon(Icons.star, color: Colors.black),
    const Icon(Icons.star, color: Colors.black),
  ],
);

final [!ratings!] = Container(
  padding: const EdgeInsets.all(20),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      stars,
      const Text(
        '170 Reviews',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w800,
          fontFamily: 'Roboto',
          letterSpacing: 0.5,
          fontSize: 20,
        ),
      ),
    ],
  ),
);
```

:::tip
중첩된 레이아웃 코드로 인해 발생할 수 있는 시각적 혼란을 최소화하려면, UI 부분을 변수와 함수로 구현하세요.
:::

평가 행 아래의 아이콘 행에는 3개의 열이 있습니다. 
각 열에는 아이콘과 두 줄의 텍스트가 포함되어 있습니다. 위젯 트리에서 확인할 수 있습니다.

<img src='/assets/images/docs/ui/layout/widget-tree-pavlova-icon-row.png' class="mw-100 text-center" alt="Icon widget tree">

`iconList` 변수는 아이콘 행을 정의합니다.

<?code-excerpt "layout/pavlova/lib/main.dart (icon-list)" replace="/iconList/[!$&!]/g"?>
```dart
const descTextStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w800,
  fontFamily: 'Roboto',
  letterSpacing: 0.5,
  fontSize: 18,
  height: 2,
);

// DefaultTextStyle.merge()를 사용하면, 
// 자식과 그 이후의 모든 자식에게 상속되는 기본 텍스트 스타일을 만들 수 있습니다.
final [!iconList!] = DefaultTextStyle.merge(
  style: descTextStyle,
  child: Container(
    padding: const EdgeInsets.all(20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Icon(Icons.kitchen, color: Colors.green[500]),
            const Text('PREP:'),
            const Text('25 min'),
          ],
        ),
        Column(
          children: [
            Icon(Icons.timer, color: Colors.green[500]),
            const Text('COOK:'),
            const Text('1 hr'),
          ],
        ),
        Column(
          children: [
            Icon(Icons.restaurant, color: Colors.green[500]),
            const Text('FEEDS:'),
            const Text('4-6'),
          ],
        ),
      ],
    ),
  ),
);
```

`leftColumn` 변수에는 평점과 아이콘 행, 그리고 Pavlova를 설명하는 제목과 텍스트가 포함되어 있습니다.

<?code-excerpt "layout/pavlova/lib/main.dart (left-column)" replace="/leftColumn/[!$&!]/g"?>
```dart
final [!leftColumn!] = Container(
  padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
  child: Column(
    children: [
      titleText,
      subTitle,
      ratings,
      iconList,
    ],
  ),
);
```

왼쪽 열은 너비를 제한하기 위해 `SizedBox`에 배치됩니다. 
마지막으로, UI는 `Card` 안에 전체 행(왼쪽 열과 이미지 포함)으로 구성됩니다.

[Pavlova 이미지][Pavlova image]는 [Pixabay][]에서 가져왔습니다. 
`Image.network()`를 사용하여 네트에서 이미지를 임베드할 수 있지만, 
이 예에서는 이미지가 프로젝트의 이미지 디렉토리에 저장되고, 
[pubspec 파일][pubspec file]에 추가되고, `Images.asset()`을 사용하여 액세스됩니다. 
자세한 내용은 [assets자산 및 이미지 추가][Adding assets and images]를 참조하세요.

<?code-excerpt "layout/pavlova/lib/main.dart (body)"?>
```dart
body: Center(
  child: Container(
    margin: const EdgeInsets.fromLTRB(0, 40, 0, 30),
    height: 600,
    child: Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 440,
            child: leftColumn,
          ),
          mainImage,
        ],
      ),
    ),
  ),
),
```

:::tip
Pavlova 예제는, 태블릿과 같은, 넓은 기기에서 수평으로 실행하는 것이 가장 좋습니다. 
iOS 시뮬레이터에서 이 예제를 실행하는 경우, **Hardware > Device** 메뉴를 사용하여 다른 기기를 선택할 수 있습니다. 
이 예제에서는, iPad Pro를 권장합니다. **Hardware > Rotate**을 사용하여 가로 모드로 방향을 변경할 수 있습니다. 
**Window > Scale**을 사용하여, 시뮬레이터 창의 크기를 변경할 수도 있습니다. (논리적 픽셀 수는 변경하지 않음)
:::

**앱 소스:** [pavlova]({{examples}}/layout/pavlova)

[Pavlova image]: https://pixabay.com/en/photos/pavlova
[Pixabay]: https://pixabay.com/en/photos/pavlova

<hr>

## 일반적인 레이아웃 위젯 {:#common-layout-widgets}

Flutter에는 풍부한 레이아웃 위젯 라이브러리가 있습니다. 
가장 일반적으로 사용되는 몇 가지를 소개합니다. 
전체 리스트로 사용자를 압도하는 것보다 가능한 한 빨리 시작하고 실행하도록 하는 것이 목적입니다. 
사용 가능한 다른 위젯에 대한 정보는, 
[위젯 카탈로그][Widget catalog]를 참조하거나 [API 참조 문서][API reference docs]의 검색 상자를 사용하세요. 
또한, API 문서의 위젯 페이지에서는 종종 사용자의 요구 사항에 더 잘 맞는 유사한 위젯에 대한 제안을 제공합니다.

다음 위젯은 (1) [위젯 라이브러리][widgets library]의 표준 위젯과 (2) [Material 라이브러리][Material library]의 특수 위젯의 두 가지 카테고리로 나뉩니다. 
모든 앱은 위젯 라이브러리를 사용할 수 있지만, Material 앱만 Material Components 라이브러리를 사용할 수 있습니다.

### 표준 위젯 {:#standard-widgets}

* [`Container`](#container): 위젯에 패딩, 여백, 테두리, 배경색 또는 기타 장식을 추가합니다.
* [`GridView`](#gridview): 위젯을 scrollable 그리드로 배치합니다.
* [`ListView`](#listview): 위젯을 scrollable 리스트로 배치합니다.
* [`Stack`](#stack): 위젯을 다른 위젯 위에 겹칩니다.

### Material 위젯 {:#material-widgets}

* [`Card`](#card): 둥근 모서리와 드롭 섀도우가 있는 상자에 관련 정보를 조직합니다.
* [`ListTile`](#listtile): 최대 3줄의 텍스트와 선택 사항으로 leading 및 trailing 아이콘을 행으로 조직합니다.

### Container {:#container}

많은 레이아웃은 패딩을 사용하여, 위젯을 분리하거나 테두리나 여백을 추가하기 위해, [`Container`][]를 자유롭게 사용합니다. 
전체 레이아웃을 `Container`에 넣고, 배경색이나 이미지를 변경하여, 장치의 배경을 변경할 수 있습니다.

<div class="row">
<div class="col-lg-6">
  <h4>요약 (Container)</h4>

* 패딩, 여백, 테두리 추가
* 배경색 또는 이미지 변경
* 단일 자식 위젯을 포함하지만, 해당 자식은 행, 열 또는 위젯 트리의 루트일 수 있음

</div>
<div class="col-lg-6 text-center">
  <img src='/assets/images/docs/ui/layout/margin-padding-border.png' class="mb-4 mw-100"
      width="230px"
      alt="Diagram showing: margin, border, padding, and content">
</div>
</div>

#### 예제 (Container) {:#examples-container}

이 레이아웃은 두 개의 행이 있는 열로 구성되며, 각 행에는 두 개의 이미지가 들어 있습니다. 
[`Container`][]는 열의 배경색을 더 밝은 회색으로 변경하는 데 사용됩니다.

<div class="row">
<div class="col-lg-7">

  <?code-excerpt "layout/container/lib/main.dart (column)" replace="/\bContainer/[!$&!]/g;"?>
  ```dart
  Widget _buildImageColumn() {
    return [!Container!](
      decoration: const BoxDecoration(
        color: Colors.black26,
      ),
      child: Column(
        children: [
          _buildImageRow(1),
          _buildImageRow(3),
        ],
      ),
    );
  }
  ```

</div>
<div class="col-lg-5 text-center">
  <img src='/assets/images/docs/ui/layout/container.png' class="mb-4 mw-100" width="230px"
      alt="Screenshot showing 2 rows, each containing 2 images">
</div>
</div>

`Container`는 각 이미지에 둥근 테두리와 여백을 추가하는 데에도 사용됩니다.

<?code-excerpt "layout/container/lib/main.dart (row)" replace="/\bContainer/[!$&!]/g;"?>
```dart
Widget _buildDecoratedImage(int imageIndex) => Expanded(
      child: [!Container!](
        decoration: BoxDecoration(
          border: Border.all(width: 10, color: Colors.black38),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        margin: const EdgeInsets.all(4),
        child: Image.asset('images/pic$imageIndex.jpg'),
      ),
    );

Widget _buildImageRow(int imageIndex) => Row(
      children: [
        _buildDecoratedImage(imageIndex),
        _buildDecoratedImage(imageIndex + 1),
      ],
    );
```

더 많은 `Container` 예제는 [튜토리얼][tutorial]에서 확인할 수 있습니다.

**앱 소스:** [container]({{examples}}/layout/container)

<hr>

### GridView {:#gridview}

위젯을 2차원 리스토로 배치하려면, [`GridView`][]를 사용합니다. 
`GridView`는 두 개의 사전 제작된 리스트를 제공하거나, 커스텀 그리드를 직접 빌드할 수 있습니다. 
`GridView`가 콘텐츠가 렌더 상자에 맞지 않을 만큼 길다는 것을 감지하면, 자동으로 스크롤합니다.

#### 요약 (GridView) {:#summary-gridview}

* 그리드에 위젯을 배치합니다.
* 열 내용이 렌더 상자를 초과하면 감지하고 자동으로 스크롤을 제공합니다.
* 커스텀 그리드를 빌드하거나, 제공된 그리드 중 하나를 사용합니다.
  * `GridView.count`를 사용하면 열 수를 지정할 수 있습니다.
  * `GridView.extent`를 사용하면 타일의 최대 픽셀 너비를 지정할 수 있습니다.
{% comment %}
* `MediaQuery.of(context).orientation`을 사용하여, 
  기기가 가로 모드인지 세로 모드인지에 따라 레이아웃이 변경되는 그리드를 만듭니다.
{% endcomment %}

:::note
셀이 어느 행과 열을 차지하는지 중요한 2차원 리스트를 표시하는 경우,
(예: "아보카도" 행의 경우 "칼로리" 열의 항목), 
[`Table`][] 또는 [`DataTable`][]을 사용합니다.
:::

#### 예제 (GridView) {:#examples-gridview}

<div class="row">
<div class="col-lg-6">
  <img src='/assets/images/docs/ui/layout/gridview-extent.png' class="mw-100 text-center" alt="A 3-column grid of photos">

  `GridView.extent`를 사용하여 최대 150픽셀 너비의 타일로 구성된 그리드를 만듭니다.

  **앱 소스:** [grid_and_list]({{examples}}/layout/grid_and_list)
</div>
<div class="col-lg-6">
  <img src='/assets/images/docs/ui/layout/gridview-count-flutter-gallery.png' class="mw-100 text-center"
      alt="A 2 column grid with footers">

  `GridView.count`를 사용하여 세로 모드에서는 2타일, 가로 모드에서는 3타일 너비의 그리드를 만듭니다. 
  제목은 각 [`GridTile`][]에 대해 `footer` 속성을 설정하여 만듭니다.

  **Dart 코드:** 
  [`grid_list_demo.dart`]({{examples}}/layout/gallery/lib/grid_list_demo.dart)
</div>
</div>

<?code-excerpt "layout/grid_and_list/lib/main.dart (grid)" replace="/\GridView/[!$&!]/g;"?>
```dart
Widget _buildGrid() => [!GridView!].extent(
    maxCrossAxisExtent: 150,
    padding: const EdgeInsets.all(4),
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    children: _buildGridTileList(30));

// 이미지는 pic0.jpg, pic1.jpg...pic29.jpg 라는 이름으로 저장됩니다. 
// List.generate() 생성자는 객체에 예측 가능한 명명 패턴이 있을 때, 
// 리스트를 쉽게 만들 수 있는 방법을 제공합니다.
List<Container> _buildGridTileList(int count) => List.generate(
    count, (i) => Container(child: Image.asset('images/pic$i.jpg')));
```

<hr>

### ListView {:#listview}

열 형태의 위젯인, [`ListView`][]는, 렌더 상자에 비해 콘텐츠가 너무 길면 자동으로 스크롤 기능을 제공합니다.

#### 요약 (ListView) {:#summary-listview}

* 상자 리스트를 구성하기 위한 특수화된 [`Column`][]
* 가로 또는 세로로 배치 가능
* 콘텐츠가 맞지 않을 때 감지하고 스크롤 제공
* `Column`보다 구성이 덜 가능하지만, 사용하기 쉽고 스크롤 지원

#### 예제 (ListView) {:#examples-listview}

<div class="row">
<div class="col-lg-6">
  <img src='/assets/images/docs/ui/layout/listview.png' class="border mw-100 text-center"
      alt="ListView containing movie theaters and restaurants">

  `ListView`를 사용하여 `ListTile`들을 사용하여 사업체 리스트를 표시합니다. 
  `Divider`는 극장과 레스토랑을 구분합니다.

  **앱 소스:** [grid_and_list]({{examples}}/layout/grid_and_list)
</div>
<div class="col-lg-6">
  <img src='/assets/images/docs/ui/layout/listview-color-gallery.png' class="border mw-100 text-center"
      alt="ListView containing shades of blue">

  `ListView`를 사용하여 특정 색상 패밀리에 대한 [Material 2 Design 팔레트][Material 2 Design palette]의 [`Colors`][]를 표시합니다.

  **Dart 코드:**
  [`colors_demo.dart`]({{examples}}/layout/gallery/lib/colors_demo.dart)
</div>
</div>

<?code-excerpt "layout/grid_and_list/lib/main.dart (list)" replace="/\ListView/[!$&!]/g;"?>
```dart
Widget _buildList() {
  return [!ListView!](
    children: [
      _tile('CineArts at the Empire', '85 W Portal Ave', Icons.theaters),
      _tile('The Castro Theater', '429 Castro St', Icons.theaters),
      _tile('Alamo Drafthouse Cinema', '2550 Mission St', Icons.theaters),
      _tile('Roxie Theater', '3117 16th St', Icons.theaters),
      _tile('United Artists Stonestown Twin', '501 Buckingham Way',
          Icons.theaters),
      _tile('AMC Metreon 16', '135 4th St #3000', Icons.theaters),
      const Divider(),
      _tile('K\'s Kitchen', '757 Monterey Blvd', Icons.restaurant),
      _tile('Emmy\'s Restaurant', '1923 Ocean Ave', Icons.restaurant),
      _tile('Chaiya Thai Restaurant', '272 Claremont Blvd', Icons.restaurant),
      _tile('La Ciccia', '291 30th St', Icons.restaurant),
    ],
  );
}

ListTile _tile(String title, String subtitle, IconData icon) {
  return ListTile(
    title: Text(title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        )),
    subtitle: Text(subtitle),
    leading: Icon(
      icon,
      color: Colors.blue[500],
    ),
  );
}
```

<hr>

### Stack {:#stack}

[`Stack`][]을 사용하여 기본 위젯(종종 이미지) 위에 위젯을 배열합니다. 
위젯은 기본 위젯과 완전히 또는 부분적으로 겹칠 수 있습니다.

#### 요약 (Stack) {:#summary-stack}

* 다른 위젯과 겹치는 위젯에 사용
* 자식 리스트에서 첫 번째 위젯은 베이스 위젯입니다. 이후 자식은 해당 기본 위젯 위에 겹쳐집니다.
* `Stack`의 콘텐츠는 스크롤할 수 없습니다.
* 렌더 상자를 초과하는 자식을 clip 할 수 있습니다.

#### 예제 (Stack) {:#examples-stack}

<div class="row">
<div class="col-lg-7">
  <img src='/assets/images/docs/ui/layout/stack.png' class="mw-100 text-center" width="200px" alt="Circular avatar image with a label">

  `Stack`을 사용하여 `Container`(반투명한 검은색 배경에 `Text`를 표시함)를 `CircleAvatar` 위에 오버레이합니다.
  `Stack`은 `alignment` 속성과 `Alignment`를 사용하여 텍스트를 오프셋합니다.

  **앱 소스:** [card_and_stack]({{examples}}/layout/card_and_stack)
</div>
<div class="col-lg-5">
  <img src='/assets/images/docs/ui/layout/stack-flutter-gallery.png' class="mw-100 text-center" alt="An image with a icon overlaid on top">

  `Stack`을 사용하여 이미지 위에 아이콘을 오버레이합니다.

  **Dart 코드:**
  [`bottom_navigation_demo.dart`]({{examples}}/layout/gallery/lib/bottom_navigation_demo.dart)
</div>
</div>

<?code-excerpt "layout/card_and_stack/lib/main.dart (stack)" replace="/\bStack/[!$&!]/g;"?>
```dart
Widget _buildStack() {
  return [!Stack!](
    alignment: const Alignment(0.6, 0.6),
    children: [
      const CircleAvatar(
        backgroundImage: AssetImage('images/pic.jpg'),
        radius: 100,
      ),
      Container(
        decoration: const BoxDecoration(
          color: Colors.black45,
        ),
        child: const Text(
          'Mia B',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ],
  );
}
```

<hr>

### Card {:#card}

[Material 라이브러리][Material library]의 [`Card`][]에는, 관련 정보가 들어 있으며 거의 ​​모든 위젯에서 구성할 수 있지만, 종종 [`ListTile`][]과 함께 사용됩니다. 
`Card`에는 자식이 하나 있지만, 자식은 열, 행, 리스트, 그리드 또는 여러 자식을 지원하는 다른 위젯일 수 있습니다. 
기본적으로 `Card`는 크기를 0x0픽셀로 줄입니다. 
[`SizedBox`][]를 사용하여 카드의 크기를 제한할 수 있습니다.

Flutter에서, `Card`는 약간 둥근 모서리와 그림자가 있어 3D 효과를 줍니다. 
`Card`의 `elevation` 속성을 변경하면, 그림자 효과를 제어할 수 있습니다. 
예를 들어, 높이를 24로 설정하면, `Card`가 표면에서 더 멀리 들리고 그림자가 더 분산됩니다. 
지원되는 높이 값 리스트는 [Material 가이드라인][Material Design]의 [Elevation][]을 참조하세요. 
지원되지 않는 값을 지정하면 그림자 기능이 완전히 비활성화됩니다.

#### 요약 (Card) {:#summary-card}

* [Material card][] 구현
* 관련 정보 덩어리를 표시하는 데 사용
* 단일 자식을 허용하지만, 해당 자식은 `Row`, `Column` 또는 자식 리스트를 보유하는 다른 위젯일 수 있음
* 모서리를 둥글게(rounded corners) 하고 그림자(drop shadow)를 드리워 표시 
* `Card`의 콘텐츠는 스크롤할 수 없음
* [Material 라이브러리][Material library]에서 옴

#### 예제 (Card) {:#examples-card}

<div class="row">
<div class="col-lg-6">
  <img src='/assets/images/docs/ui/layout/card.png' class="mw-100 text-center" alt="Card containing 3 ListTiles">

  3개의 ListTiles를 포함하고 `SizedBox`로 감싸서 크기를 조정한 `Card`. 
  `Divider`는 첫 번째와 두 번째 `ListTiles`를 구분합니다.

  **앱 소스:** [card_and_stack]({{examples}}/layout/card_and_stack)
</div>
<div class="col-lg-6">
  <img src='/assets/images/docs/ui/layout/card-flutter-gallery.png' class="mw-100 text-center"
      alt="Tappable card containing an image and multiple forms of text">

  이미지와 텍스트가 담긴 `Card`.

  **Dart 코드:**
  [`cards_demo.dart`]({{examples}}/layout/gallery/lib/cards_demo.dart)
</div>
</div>

<?code-excerpt "layout/card_and_stack/lib/main.dart (card)" replace="/\bCard/[!$&!]/g;"?>
```dart
Widget _buildCard() {
  return SizedBox(
    height: 210,
    child: [!Card!](
      child: Column(
        children: [
          ListTile(
            title: const Text(
              '1625 Main Street',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('My City, CA 99984'),
            leading: Icon(
              Icons.restaurant_menu,
              color: Colors.blue[500],
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text(
              '(408) 555-1212',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            leading: Icon(
              Icons.contact_phone,
              color: Colors.blue[500],
            ),
          ),
          ListTile(
            title: const Text('costa@example.com'),
            leading: Icon(
              Icons.contact_mail,
              color: Colors.blue[500],
            ),
          ),
        ],
      ),
    ),
  );
}
```

<hr>

### ListTile {:#listtile}

[Material 라이브러리][Material library]의 특수 행 위젯인 [`ListTile`][]을 사용하면, 
최대 3줄의 텍스트와 선택적으로 leading 및 trailing 아이콘을 포함하는 행을 쉽게 만들 수 있습니다. 
`ListTile`은 [`Card`][] 또는 [`ListView`][]에서 가장 일반적으로 사용되지만, 다른 곳에서도 사용할 수 있습니다.

#### 요약 (ListTile) {:#summary-listtile}

* 최대 3줄의 텍스트와 선택적인 아이콘을 포함하는 특수 행
* `Row`보다 구성이 덜 가능하지만, 사용하기 더 쉬움
* [Material 라이브러리][Material library]에서 옴

#### 예제 (ListTile) {:#examples-listtile}

<div class="row">
<div class="col-lg-6">
  <img src='/assets/images/docs/ui/layout/card.png' class="mw-100 text-center" alt="Card containing 3 ListTiles">

  3개의 `ListTile`을 포함하는 `Card`.

  **앱 소스:** [card_and_stack]({{examples}}/layout/card_and_stack)
</div>
<div class="col-lg-6">
  <img src='/assets/images/docs/ui/layout/listtile-flutter-gallery.png' class="border mw-100 text-center" height="200px"
      alt="4 ListTiles, each containing a leading avatar">

  leading 위젯과 함께 `ListTile`을 사용합니다.

  **Dart 코드:**
  [`list_demo.dart`]({{examples}}/layout/gallery/lib/list_demo.dart)
</div>
</div>

<hr>

## 제약 {:#constraints}

Flutter의 레이아웃 시스템을 완전히 이해하려면, 
Flutter가 레이아웃에서 구성 요소를 어떻게 배치하고 크기를 지정하는지 알아야 합니다. 
자세한 내용은 [제약 조건 이해][Understanding constraints]를 참조하세요.

## 비디오 {:#videos}

다음 비디오는 [Flutter in Focus][] 시리즈의 일부로, `Stateless` 및 `Stateful` 위젯을 설명합니다.

{% ytEmbed 'wE7khGHVkYY', 'How to create stateless widgets', true %}

{% ytEmbed 'AqCMFXEmf3w', 'How and when stateful widgets are best used', true %}

[Flutter in Focus 플레이리스트]({{site.yt.playlist}}PLjxrf2q8roU2HdJQDjJzOeO6J3FoFLWr2)

---

[Widget of the Week 시리즈]({{site.yt.playlist}}PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG)의 각 에피소드는 위젯에 초점을 맞춥니다. 
그 중 몇몇은 레이아웃 위젯을 포함합니다.

{% ytEmbed 'b_sQ9bMltGU', 'Introducing widget of the week', true %}

[Flutter Widget of the Week 플레이리스트]({{site.yt.playlist}}PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG)

## 기타 리소스 {:#other-resources}

다음 리소스는 레이아웃 코드를 작성할 때 도움이 될 수 있습니다.

[레이아웃 튜토리얼][Layout tutorial]
: 레이아웃을 빌드하는 방법을 알아보세요.

[위젯 카탈로그][Widget catalog]
: Flutter에서 사용할 수 있는 많은 위젯을 설명합니다.

[Flutter의 HTML/CSS 아날로그][HTML/CSS Analogs in Flutter]
: 웹 프로그래밍에 익숙한 사람들을 위해, 이 페이지는 HTML/CSS 기능을 Flutter 기능에 매핑합니다.

[API 참조 문서][API reference docs]
: 모든 Flutter 라이브러리에 대한 참조 문서.

[assets 및 이미지 추가][Adding assets and images]
: 앱 패키지에 이미지 및 기타 assets을 추가하는 방법을 설명합니다.

[Flutter로 Zero to One][Zero to One with Flutter]
: 첫 번째 Flutter 앱을 작성한 한 사람의 경험.

[Cupertino library]: {{api}}/cupertino/cupertino-library.html
[`CupertinoPageScaffold`]: {{api}}/cupertino/CupertinoPageScaffold-class.html
[Adding assets and images]: /ui/assets/assets-and-images
[API reference docs]: {{api}}
[`build()`]: {{api}}/widgets/StatelessWidget/build.html
[`Card`]: {{api}}/material/Card-class.html
[`Center`]: {{api}}/widgets/Center-class.html
[`Column`]: {{api}}/widgets/Column-class.html
[Common layout widgets]: #common-layout-widgets
[`Colors`]: {{api}}/material/Colors-class.html
[`Container`]: {{api}}/widgets/Container-class.html
[`CrossAxisAlignment`]: {{api}}/rendering/CrossAxisAlignment.html
[`DataTable`]: {{api}}/material/DataTable-class.html
[Elevation]: {{site.material}}/styles/elevation
[`Expanded`]: {{api}}/widgets/Expanded-class.html
[Flutter in Focus]: {{site.yt.watch}}?v=wgTBLj7rMPM&list=PLjxrf2q8roU2HdJQDjJzOeO6J3FoFLWr2
[`GridView`]: {{api}}/widgets/GridView-class.html
[`GridTile`]: {{api}}/material/GridTile-class.html
[HTML/CSS Analogs in Flutter]: /get-started/flutter-for/web-devs
[`Icon`]: {{api}}/material/Icons-class.html
[`Image`]: {{api}}/widgets/Image-class.html
[Layout tutorial]: /ui/layout/tutorial
[layout widgets]: /ui/widgets/layout
[`ListTile`]: {{api}}/material/ListTile-class.html
[`ListView`]: {{api}}/widgets/ListView-class.html
[`MainAxisAlignment`]: {{api}}/rendering/MainAxisAlignment.html
[Material card]: {{site.material}}/components/cards
[Material Design]: {{site.material}}/styles
[Material 2 Design palette]: {{site.material2}}/design/color/the-color-system.html#tools-for-picking-colors
[Material library]: {{api}}/material/material-library.html
[pubspec file]: {{examples}}/layout/pavlova/pubspec.yaml
[`pubspec.yaml` file]: {{examples}}/layout/row_column/pubspec.yaml
[`Row`]: {{api}}/widgets/Row-class.html
[`Scaffold`]: {{api}}/material/Scaffold-class.html
[`SizedBox`]: {{api}}/widgets/SizedBox-class.html
[`Stack`]: {{api}}/widgets/Stack-class.html
[`Table`]: {{api}}/widgets/Table-class.html
[`Text`]: {{api}}/widgets/Text-class.html
[tutorial]: /ui/layout/tutorial
[widgets library]: {{api}}/widgets/widgets-library.html
[Widget catalog]: /ui/widgets
[Debugging layout issues visually]: /tools/devtools/inspector#debugging-layout-issues-visually
[Understanding constraints]: /ui/layout/constraints
[Using the Flutter inspector]: /tools/devtools/inspector
[Zero to One with Flutter]: {{site.medium}}/@mravn/zero-to-one-with-flutter-43b13fd7b354
