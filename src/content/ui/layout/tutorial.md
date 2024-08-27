---
# title: Build a Flutter layout
title: Flutter 레이아웃으로 빌드하기
# short-title: Layout tutorial
short-title: 레이아웃 튜토리얼
# description: Learn how to build a layout in Flutter.
description: Flutter에서 레이아웃을 만드는 방법을 알아보세요.
---

{% assign examples = site.repo.this | append: "/tree/" | append: site.branch | append: "/examples" -%}

<style>dl, dd { margin-bottom: 0; }</style>

:::secondary 학습할 내용
* 위젯을 나란히 배치하는 방법.
* 위젯 사이에 공백을 추가하는 방법.
* Flutter 레이아웃에서 위젯을 추가하고 중첩하는 방법.
:::

이 튜토리얼은 Flutter에서 레이아웃을 디자인하고 빌드하는 방법을 설명합니다.

제공된 예제 코드를 사용하면, 다음 앱을 빌드할 수 있습니다.

{% render docs/app-figure.md, img-class:"site-mobile-screenshot border", image:"ui/layout/layout-demo-app.png", caption:"완성된 앱.", width:"50%" %}

<figcaption class="figure-caption">

[Unsplash][]에서 가져온 [Dino Reichmuth][ch-photo]의 사진. [Switzerland Tourism][]의 텍스트.

</figcaption>

레이아웃 메커니즘에 대한 더 나은 개요를 얻으려면, [Flutter의 레이아웃 접근 방식][Flutter's approach to layout]부터 시작하세요.

[Switzerland Tourism]: https://www.myswitzerland.com/en-us/destinations/lake-oeschinen
[Flutter's approach to layout]: /ui/layout

## 레이아웃을 다이어그램으로 표시 {:#diagram-the-layout}

이 섹션에서는, 앱 사용자에게 어떤 타입의 사용자 경험을 원하는지 고려하세요.

사용자 인터페이스의 구성 요소를 배치하는 방법을 고려하세요. 
레이아웃은 이러한 배치의 전체 최종 결과로 구성됩니다. 
코딩 속도를 높이기 위해 레이아웃을 계획하는 것을 고려하세요. 
시각적 단서를 사용하여, 화면에서 어떤 것이 어디에 있는지 아는 것은 큰 도움이 될 수 있습니다.

인터페이스 디자인 도구나 연필과 종이와 같이, 선호하는 방법을 사용하세요. 
코드를 작성하기 전에 화면에 요소를 배치할 위치를 파악하세요. 
"두 번 측정하고 한 번 자르세요. (Measure twice, cut once.)"라는 속담의 프로그래밍 버전입니다.

<ol>
<li>

레이아웃을 기본 요소로 분류하려면 다음 질문을 하세요.

* 행과 열을 식별할 수 있나요?
* 레이아웃에 그리드가 포함되어 있나요?
* 겹치는 요소가 있나요?
* UI에 탭이 필요한가요?
* 정렬, 패딩 또는 테두리 중 필요한 것은 무엇인가요?

</li>

<li>

더 큰 요소를 식별합니다. 
이 예에서, 이미지, 제목, 버튼, 설명을 열로 정렬합니다.

{% render docs/app-figure.md, img-class:"site-mobile-screenshot border", image:"ui/layout/layout-sketch-intro.svg", caption:"레이아웃의 주요 요소: 이미지, 행, 행 및 텍스트 블록", width:"50%" %}

</li>
<li>

각 행을 다이어그램으로 표시하세요.

<ol type="a">

<li>

행 1, **Title** 섹션에는 세 개의 자식이 있습니다. 
텍스트 열, star 아이콘, 숫자입니다. 
첫 번째 자식인 열에는 두 줄의 텍스트가 있습니다. 첫 번째 열에는 공간이 더 필요할 수 있습니다.

{% render docs/app-figure.md, image:"ui/layout/layout-sketch-title-block.svg", caption:"텍스트 블록과 아이콘이 있는 Title 섹션" -%}

</li>

<li>

행 2, **Button** 섹션에는, 세 개의 자식이 있습니다. 각 자식에는 아이콘과 텍스트가 포함된 열이 있습니다.

{% render docs/app-figure.md, image:"ui/layout/layout-sketch-button-block.svg", caption:"3개의 레이블이 지정된 버튼이 있는 Button 섹션", width:"50%" %}

  </li>

</ol>

</li>
</ol>

레이아웃을 다이어그램으로 그린 ​​후, 어떻게 코딩할지 고려하세요.

모든 코드를 하나의 클래스에 작성하시겠습니까?
아니면, 레이아웃의 각 부분에 대해 하나의 클래스를 만드시겠습니까?

Flutter 모범 사례를 따르려면, 레이아웃의 각 부분을 포함하는 하나의 클래스 또는 위젯을 만드세요. 
Flutter가 UI의 일부를 다시 렌더링해야 할 때, 변경되는 가장 작은 부분을 업데이트합니다. 
이것이 Flutter가 "모든 것을 위젯"으로 만드는 이유입니다. 
`Text` 위젯에서 텍스트만 변경되는 경우, Flutter는 해당 텍스트만 다시 그립니다. 
Flutter는 사용자 입력에 따라 가능한 한 최소한의 UI만 변경합니다.

이 튜토리얼에서는, 식별한 각 요소를 별도의 위젯으로 작성합니다.

## 앱 베이스 코드 생성 {:#create-the-app-base-code}

이 섹션에서는, Flutter 앱의 기본 코드를 작성하여 앱을 시작합니다.

<?code-excerpt path-base="layout/base"?>

1. [Flutter 환경 설정을 설정][Set up your Flutter environment]합니다.

1. [새로운 Flutter 앱을 만듭][new-flutter-app]니다.

1. `lib/main.dart`의 내용을 다음 코드로 바꾸세요. 
   이 앱은 앱 제목과 앱의 `appBar`에 표시되는 제목에 대한 매개변수를 사용합니다. 이 결정은 코드를 단순화합니다.

   <?code-excerpt "lib/main.dart (all)"?>
   ```dart
   import 'package:flutter/material.dart';
   
   void main() => runApp(const MyApp());
   
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

[Set up your Flutter environment]: /get-started/install
[new-flutter-app]: /get-started/test-drive

## 제목 섹션 추가 {:#add-the-title-section}

이 섹션에서는, 다음 레이아웃과 비슷한 `TitleSection` 위젯을 만듭니다.

<?code-excerpt path-base="layout/lakes"?>

{% render docs/app-figure.md, image:"ui/layout/layout-sketch-title-block-unlabeled.svg", caption:"스케치 및 프로토타입 UI로서의 제목 섹션" %}

### `TitleSection` 위젯 추가 {:#add-the-titlesection-widget}

`MyApp` 클래스 뒤에 다음 코드를 추가합니다.

<?code-excerpt "step2/lib/main.dart (title-section)"?>
```dart
class TitleSection extends StatelessWidget {
  const TitleSection({
    super.key,
    required this.name,
    required this.location,
  });

  final String name;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  location,
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          /*3*/
          Icon(
            Icons.star,
            color: Colors.red[500],
          ),
          const Text('41'),
        ],
      ),
    );
  }
}
```

{:.numbered-code-notes}

1. 행의 남은 모든 여유 공간을 사용하려면, `Expanded` 위젯을 사용하여 `Column` 위젯을 늘립니다. 
   열을 행의 시작 부분에 배치하려면, `crossAxisAlignment` 속성을 `CrossAxisAlignment.start`로 설정합니다.
2. 텍스트 행 사이에 공백을 추가하려면, 해당 행을 `Padding` 위젯에 넣으세요.
3. 제목 행은 빨간색 별 아이콘과 텍스트 `41`로 끝납니다. 
   전체 행은 `Padding` 위젯 내부에 있으며, 각 모서리를 32픽셀로 패딩합니다.

### 앱 body를 스크롤 뷰로 변경 {:#change-the-app-body-to-a-scrolling-view}

`body` 속성에서, `Center` 위젯을 `SingleChildScrollView` 위젯으로 바꿉니다. 
[`SingleChildScrollView`][] 위젯 내에서, `Text` 위젯을 `Column` 위젯으로 바꿉니다.

```dart diff
- body: const Center(
-   child: Text('Hello World'),
+ body: const SingleChildScrollView(
+   child: Column(
+     children: [
```

이러한 코드 업데이트는 다음과 같은 방식으로 앱을 변경합니다.

* `SingleChildScrollView` 위젯은 스크롤할 수 있습니다. 
  이를 통해 현재 화면에 맞지 않는 요소를 표시할 수 있습니다.
* `Column` 위젯은 `children` 속성 내의 모든 요소를 ​​나열된 순서대로 표시합니다. 
  `children` 리스트에 나열된 첫 번째 요소는 리스트 맨 위에 표시됩니다. 
  `children` 리스트에 있는 요소는 화면에서 위에서 아래로 배열 순서대로 표시됩니다.

[`SingleChildScrollView`]: {{site.api}}/flutter/widgets/SingleChildScrollView-class.html

### 앱을 업데이트하여 제목 섹션 표시 {:#update-the-app-to-display-the-title-section}

`TitleSection` 위젯을 `children` 리스트의 첫 번째 요소로 추가합니다. 
그러면 화면 맨 위에 배치됩니다. 
제공된 이름과 위치를 `TitleSection` 생성자에 전달합니다.

```dart diff
+ children: [
+   TitleSection(
+     name: 'Oeschinen Lake Campground',
+     location: 'Kandersteg, Switzerland',
+   ),
+ ],
```

:::tip
* 앱에 코드를 붙여넣을 때, 들여쓰기가 비뚤어질 수 있습니다. 
  Flutter 편집기에서 이를 수정하려면, [자동 reformatting 지원][automatic reformatting support]을 사용하세요.
* 개발을 가속화하려면, Flutter의 [핫 리로드][hot reload] 기능을 사용하세요.
* 문제가 있으면, 코드를 [`lib/main.dart`][]와 비교하세요.
:::

[automatic reformatting support]: /tools/formatting
[hot reload]: /tools/hot-reload
[`lib/main.dart`]: {{examples}}/layout/lakes/step2/lib/main.dart

## 버튼 섹션 추가 {:#add-the-button-section}

이 섹션에서는, 앱의 기능을 추가할 버튼을 추가합니다.

<?code-excerpt path-base="layout/lakes/step3"?>

**Button** 섹션에는 동일한 레이아웃을 사용하는 세 개의 열이 있습니다. 즉, 텍스트 행 위에 아이콘이 있습니다.

{% render docs/app-figure.md, image:"ui/layout/layout-sketch-button-block-unlabeled.svg", caption:"스케치 및 프로토타입 UI로서의 Button 섹션" %}

이러한 열을 한 행에 분배하여, 각각이 같은 양의 공간을 차지하도록 계획합니다. 
모든 텍스트와 아이콘을 primary 색상으로 칠합니다.

### `ButtonSection` 위젯 추가 {:#add-the-buttonsection-widget}

`TitleSection` 위젯 뒤에 다음 코드를 추가하여, 버튼 행을 구성하는 코드를 포함합니다.

<?code-excerpt "lib/main.dart (button-start)"?>
```dart
class ButtonSection extends StatelessWidget {
  const ButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).primaryColor;
    // ···
  }
}
```

### 버튼을 만들기 위한 위젯 생성 {:#create-a-widget-to-make-buttons}

각 열의 코드는 동일한 구문을 사용할 수 있으므로, `ButtonWithText`라는 위젯을 만듭니다. 
위젯의 생성자는 색상, 아이콘 데이터 및 버튼의 레이블을 허용합니다. 
이러한 값을 사용하여, 위젯은 `Icon`과 스타일이 적용된 `Text` 위젯을 자식으로 갖는 `Column`을 빌드합니다. 
이러한 자식을 분리하기 위해, `Padding` 위젯인 `Text` 위젯은 `Padding` 위젯으로 래핑됩니다.

`ButtonSection` 클래스 뒤에 다음 코드를 추가합니다.

<?code-excerpt "lib/main.dart (button-with-text)"?>
```dart
class ButtonSection extends StatelessWidget {
  const ButtonSection({super.key});
// ···
}

class ButtonWithText extends StatelessWidget {
  const ButtonWithText({
    super.key,
    required this.color,
    required this.icon,
    required this.label,
  });

  final Color color;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
```

### `Row` 위젯으로 버튼 위치 지정 {:#position-the-buttons-with-a-row-widget}

다음 코드를 `ButtonSection` 위젯에 추가합니다.

1. 각 버튼에 대해 한 번씩 `ButtonWithText` 위젯의, 세 인스턴스를 추가합니다.
1. 해당 특정 버튼의 색상, `Icon` 및 텍스트를 전달합니다.
1. `MainAxisAlignment.spaceEvenly` 값으로 메인 축을 따라 열을 정렬합니다. 
   `Row` 위젯의 메인 축은 수평이고, `Column` 위젯의 메인 축은 수직입니다. 
   그런 다음, 이 값은 Flutter에 `Row`를 따라 각 열 앞, 사이, 뒤에 동일한 양의 여유 공간을 정렬하도록 지시합니다.

<?code-excerpt "lib/main.dart (button-section)"?>
```dart
class ButtonSection extends StatelessWidget {
  const ButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).primaryColor;
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ButtonWithText(
            color: color,
            icon: Icons.call,
            label: 'CALL',
          ),
          ButtonWithText(
            color: color,
            icon: Icons.near_me,
            label: 'ROUTE',
          ),
          ButtonWithText(
            color: color,
            icon: Icons.share,
            label: 'SHARE',
          ),
        ],
      ),
    );
  }
}

class ButtonWithText extends StatelessWidget {
  const ButtonWithText({
    super.key,
    required this.color,
    required this.icon,
    required this.label,
  });

  final Color color;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
// ···
    );
  }
}
```

### 버튼 섹션을 표시하도록 앱 업데이트 {:#update-the-app-to-display-the-button-section}

`children` 리스트에 버튼 섹션을 추가합니다.

<?code-excerpt path-base="layout/lakes"?>

```dart diff
    TitleSection(
      name: 'Oeschinen Lake Campground',
      location: 'Kandersteg, Switzerland',
    ),
+   ButtonSection(),
  ],
```

## 텍스트 섹션 추가 {:#add-the-text-section}

이 섹션에서는, 이 앱에 대한 텍스트 설명을 추가합니다.

{% render docs/app-figure.md, image:"ui/layout/layout-sketch-add-text-block.svg", caption:"스케치 및 프로토타입 UI로서의 텍스트 블록" %}

<?code-excerpt path-base="layout/lakes"?>

### `TextSection` 위젯 추가 {:#add-the-textsection-widget}

`ButtonSection` 위젯 뒤에 다음 코드를 별도의 위젯으로 추가합니다.

<?code-excerpt "step4/lib/main.dart (text-section)"?>
```dart
class TextSection extends StatelessWidget {
  const TextSection({
    super.key,
    required this.description,
  });

  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Text(
        description,
        softWrap: true,
      ),
    );
  }
}
```

[`softWrap`][]을 `true`로 설정하면, 텍스트 줄이 단어 경계에서 줄바꿈되기 전에 열 너비를 채웁니다.

[`softWrap`]: {{site.api}}/flutter/widgets/Text/softWrap.html

### 앱을 업데이트하여 텍스트 섹션 표시 {:#update-the-app-to-display-the-text-section}

`ButtonSection` 뒤에 자식으로 새 `TextSection` 위젯을 추가합니다. 
`TextSection` 위젯을 추가할 때, `description` 속성을 위치 설명의 텍스트로 설정합니다.

```dart diff
      location: 'Kandersteg, Switzerland',
    ),
    ButtonSection(),
+   TextSection(
+     description:
+         'Lake Oeschinen lies at the foot of the Blüemlisalp in the '
+         'Bernese Alps. Situated 1,578 meters above sea level, it '
+         'is one of the larger Alpine Lakes. A gondola ride from '
+         'Kandersteg, followed by a half-hour walk through pastures '
+         'and pine forest, leads you to the lake, which warms to 20 '
+         'degrees Celsius in the summer. Activities enjoyed here '
+         'include rowing, and riding the summer toboggan run.',
+   ),
  ], 
```

## 이미지 섹션 추가 {:#add-the-image-section}

이 섹션에서는, 이미지 파일을 추가하여 레이아웃을 완성합니다.

### 제공된 이미지를 사용하도록 앱 구성 {:#configure-your-app-to-use-supplied-images}

앱이 이미지를 참조하도록 구성하려면, `pubspec.yaml` 파일을 수정합니다.

1. 프로젝트 맨 위에 `images` 디렉토리를 만듭니다.

1. [`lake.jpg`][] 이미지를 다운로드하여, 새 `images` 디렉토리에 추가합니다.

   :::note
   `wget`을 사용하여 이 바이너리 파일을 저장할 수 없습니다.
   [Unsplash][]에서 Unsplash License에 따라 [image][ch-photo]를 다운로드할 수 있습니다. 
   작은 크기는 94.4kB입니다.
   :::

2. 이미지를 포함하려면, 앱의 루트 디렉토리에 있는 `pubspec.yaml` 파일에 `assets` 태그를 추가합니다.
   `assets`를 추가하면, 코드에서 사용할 수 있는 이미지에 대한 포인터 세트 역할을 합니다.

   ```yaml title="pubspec.yaml" diff
    flutter:
      uses-material-design: true
   +  assets:
   +    - images/lake.jpg
   ```

:::tip
`pubspec.yaml`의 텍스트는 공백과 대소문자를 존중합니다.
이전 예제에서 주어진 대로 파일에 변경 사항을 작성합니다.

이 변경 사항을 적용하려면 이미지를 표시하기 위해 실행 중인 프로그램을 다시 시작해야 할 수 있습니다.
:::

[`lake.jpg`]: https://raw.githubusercontent.com/flutter/website/main/examples/layout/lakes/step5/images/lake.jpg

### `ImageSection` 위젯 만들기 {:#create-the-imagesection-widget}

다른 선언 뒤에 다음의 `ImageSection` 위젯을 정의합니다.

<?code-excerpt "step5/lib/main.dart (image-section)"?>
```dart
class ImageSection extends StatelessWidget {
  const ImageSection({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      width: 600,
      height: 240,
      fit: BoxFit.cover,
    );
  }
}
```

`BoxFit.cover` 값은 Flutter에게 두 가지 제약 조건으로 이미지를 표시하라고 알려줍니다. 

1. 첫째, 이미지를 가능한 한 작게 표시합니다. 
2. 둘째, 레이아웃이 할당한 모든 공간, 즉 렌더 박스를 덮습니다.

### 이미지 섹션을 표시하도록 앱 업데이트 {:#update-the-app-to-display-the-image-section}

`ImageSection` 위젯을 `children` 리스트의 첫 번째 자식으로 추가합니다. 
`image` 속성을 [제공된 이미지를 사용하도록 앱 구성](#configure-your-app-to-use-supplied-images)에서 추가한 이미지 경로로 설정합니다.

```dart diff
  children: [
+   ImageSection(
+     image: 'images/lake.jpg',
+   ),
    TitleSection(
      name: 'Oeschinen Lake Campground',
      location: 'Kandersteg, Switzerland',
```

## 축하해요 {:#congratulations}

그게 다예요! 앱을 핫 리로드하면, 앱이 이렇게 보여야 합니다.

{% render docs/app-figure.md, img-class:"site-mobile-screenshot border", image:"ui/layout/layout-demo-app.png", caption:"완성된 앱", width:"50%" %}

## 리소스 {:#resources}

이 튜토리얼에서 사용된 리소스는 다음 위치에서 액세스할 수 있습니다.

**Dart 코드:** [`main.dart`][]<br>
**이미지:** [ch-photo][]<br>
**Pubspec:** [`pubspec.yaml`][]<br>

[`main.dart`]: {{examples}}/layout/lakes/step6/lib/main.dart
[ch-photo]: https://unsplash.com/photos/red-and-gray-tents-in-grass-covered-mountain-5Rhl-kSRydQ
[`pubspec.yaml`]: {{examples}}/layout/lakes/step6/pubspec.yaml

## 다음 스텝 {:#next-steps}

이 레이아웃에 상호 작용 기능을 추가하려면, [상호작용 기능 튜토리얼][Adding Interactivity to Your Flutter App]를 따르세요.

[Adding Interactivity to Your Flutter App]: /ui/interactivity
[Unsplash]: https://unsplash.com
