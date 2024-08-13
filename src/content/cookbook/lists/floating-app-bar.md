---
# title: Place a floating app bar above a list
title: 리스트 위에 떠 있는 앱 바 배치
# description: How to place a floating app bar above a list.
description: 리스트 위에 떠 있는 앱 바를 배치하는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/lists/floating_app_bar/"?>

사용자가 아이템 리스트를 더 쉽게 볼 수 있도록 하기 위해, 사용자가 리스트를 아래로 스크롤할 때 앱 바를 숨기고 싶을 수 있습니다.
특히 앱에서 많은 수직 공간을 차지하는 "높은" 앱 바를 표시하는 경우에 그렇습니다.

일반적으로, `Scaffold` 위젯에 `appBar` 속성을 제공하여 앱 바를 만듭니다. 
이렇게 하면 항상 `Scaffold`의 `body` 위에 있는 고정된 앱 바가 만들어집니다.

앱 바를 `Scaffold` 위젯에서 [`CustomScrollView`][]로 이동하면 
`CustomScrollView`에 포함된 아이템 리스트를 스크롤할 때 화면에서 벗어나는 앱 바를 만들 수 있습니다.

이 레시피는 다음 단계를 사용하여 `CustomScrollView`를 사용하여 사용자가 리스트를 아래로 스크롤할 때
화면에서 벗어나는 앱 바가 있는 아이템 리스트를 표시하는 방법을 보여줍니다.

1. `CustomScrollView`를 만듭니다.
2. `SliverAppBar`를 사용하여 떠 있는 앱 바를 추가합니다.
3. `SliverList`를 사용하여 아이템 리스트를 추가합니다.

## 1. `CustomScrollView` 생성 {:#1-create-a-customscrollview}

떠다니는 앱 바를 만들려면, 앱 바를 아이템 리스트가 포함된 `CustomScrollView` 안에 배치합니다. 
이렇게 하면, 앱 바의 스크롤 위치와 아이템 리스트가 동기화됩니다. 
`CustomScrollView` 위젯을 다양한 타입의 스크롤 가능한 리스트와 위젯을 함께 혼합하고 매치할 수 있는 
`ListView`로 생각할 수 있습니다.

`CustomScrollView`에 제공된 스크롤 가능한 리스트와 위젯을 _슬리버(slivers)_ 라고 합니다. 
`SliverList`, `SliverGrid`, `SliverAppBar` 등 여러 유형의 슬리버(slivers)가 있습니다. 
사실, `ListView`와 `GridView` 위젯은 `SliverList`와 `SliverGrid` 위젯을 사용하여 스크롤을 구현합니다.

이 예에서는, `SliverAppBar`와 `SliverList`를 포함하는 `CustomScrollView`를 만듭니다. 
또한, `Scaffold` 위젯에 제공한 모든 앱 바를 제거합니다.

<?code-excerpt "lib/starter.dart (CustomScrollView)" replace="/^return //g"?>
```dart
Scaffold(
  // appBar 속성이 제공되지 않고, body만 제공됩니다.
  body: CustomScrollView(
      // 다음 단계에서는 앱 바와 아이템 리스트를 슬리버로 추가합니다. 
      slivers: <Widget>[]),
);
```

## 2. `SliverAppBar`를 사용하여 떠 있는 앱 바 추가{:#2-use-sliverappbar-to-add-a-floating-app-bar}

다음으로, [`CustomScrollView`][]에 앱 바를 추가합니다. 
Flutter는 일반적인 `AppBar` 위젯과 매우 유사한 [`SliverAppBar`][] 위젯을 제공하는데, 
이 위젯은 `SliverAppBar`를 사용하여 제목, 탭, 이미지 등을 표시합니다.

그러나, `SliverAppBar`는 사용자가 리스트를 아래로 스크롤할 때,
화면에서 스크롤되는 "플로팅" 앱 바를 만들 수 있는 기능도 제공합니다. 
또한, 사용자가 스크롤할 때 `SliverAppBar`가 축소되거나 확장되도록 구성할 수 있습니다.

이 효과를 만들려면:

   1. 제목만 표시하는 앱 바로 시작합니다.
   2. `floating` 속성을 `true`로 설정합니다. 
      이렇게 하면 사용자가 리스트를 위로 스크롤할 때, 앱 바를 빠르게 표시할 수 있습니다.
   3. 사용 가능한 `expandedHeight`를 채우는 `flexibleSpace` 위젯을 추가합니다.

<?code-excerpt "lib/step2.dart (SliverAppBar)" replace="/^body: //g;/^\),$/)/g"?>
```dart
CustomScrollView(
  slivers: [
    // CustomScrollView에 앱 바를 추가합니다.
    const SliverAppBar(
      // 표준 제목을 제공합니다.
      title: Text(title),
      // 사용자가 아이템 리스트를 뒤로(위쪽으로) 스크롤하기 시작하면, 앱 바를 표시할 수 있도록 허용합니다.
      floating: true,
      // 줄어드는 크기를 시각화하기 위해 플레이스홀더 위젯을 표시합니다.
      flexibleSpace: Placeholder(),
      // SliverAppBar의 초기 높이를 일반보다 크게 만듭니다.
      expandedHeight: 200,
    ),
  ],
)
```

:::tip
[`SliverAppBar` 위젯에 전달할 수 있는 다양한 속성][various properties you can pass to the `SliverAppBar` widget]을 가지고 놀고, 핫 리로드를 사용하여 결과를 확인하세요. 
예를 들어, `flexibleSpace` 속성에 `Image` 위젯을 사용하여, 화면에서 스크롤할 때 크기가 줄어드는 배경 이미지를 만듭니다.
:::


## 3. `SliverList`를 사용하여 아이템 리스트 추가{:#3-add-a-list-of-items-using-a-sliverlist}

이제 앱 바를 배치했으니, `CustomScrollView`에 아이템 리스트를 추가합니다. 
두 가지 옵션이 있습니다. [`SliverList`][] 또는 [`SliverGrid`][]. 
아이템 리스트를 차례로 표시해야 하는 경우, `SliverList` 위젯을 사용합니다. 
그리드 리스트를 표시해야 하는 경우, `SliverGrid` 위젯을 사용합니다.

`SliverList` 및 `SliverGrid` 위젯은 필수 매개변수인 [`SliverChildDelegate`][]를 사용합니다. 
이 매개변수는 `SliverList` 또는 `SliverGrid`에 위젯 리스트를 제공합니다. 
예를 들어, [`SliverChildBuilderDelegate`][]를 사용하면, 
`ListView.builder` 위젯처럼, 스크롤할 때 지연해서(lazily) 작성되는 아이템 리스트를 만들 수 있습니다.

<?code-excerpt "lib/main.dart (SliverList)" replace="/^\),$/)/g"?>
```dart
// 다음으로, SliverList를 만듭니다.
SliverList(
  // 화면에서 스크롤될 때 아이템을 빌드하려면 대리자(delegate)를 사용합니다.
  delegate: SliverChildBuilderDelegate(
    // 빌더 함수는 현재 아이템의 인덱스를 표시하는, 제목이 있는 ListTile을 반환합니다.
    (context, index) => ListTile(title: Text('Item #$index')),
    // 1000개의 ListTiles를 빌드합니다.
    childCount: 1000,
  ),
)
```

## 대화형 예제 {:#interactive-example}

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter Floating AppBar hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Floating App Bar';

    return MaterialApp(
      title: title,
      home: Scaffold(
        // Scaffold에 앱 바가 제공되지 않고, CustomScrollView가 있는 body만 제공됩니다.
        body: CustomScrollView(
          slivers: [
            // CustomScrollView에 앱 바를 추가합니다.
            const SliverAppBar(
              // 표준 제목을 제공합니다.
              title: Text(title),
              // 사용자가 아이템 리스트를 뒤로(위쪽으로) 스크롤하기 시작하면, 앱 바를 표시할 수 있도록 허용합니다.
              floating: true,
              // 줄어드는 크기를 시각화하기 위해 플레이스홀더 위젯을 표시합니다.
              flexibleSpace: Placeholder(),
              // SliverAppBar의 초기 높이를 일반보다 크게 만듭니다.
              expandedHeight: 200,
            ),
            // 다음으로, SliverList를 만듭니다.
            SliverList(
              // 화면에서 스크롤될 때 아이템을 빌드하려면 대리자(delegate)를 사용합니다.
              delegate: SliverChildBuilderDelegate(
                // 빌더 함수는 현재 아이템의 인덱스를 표시하는, 제목이 있는 ListTile을 반환합니다.
                (context, index) => ListTile(title: Text('Item #$index')),
                // 1000개의 ListTiles를 빌드합니다.
                childCount: 1000,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/floating-app-bar.gif" alt="Use list demo" class="site-mobile-screenshot"/> 
</noscript>


[`CustomScrollView`]: {{site.api}}/flutter/widgets/CustomScrollView-class.html
[`SliverAppBar`]: {{site.api}}/flutter/material/SliverAppBar-class.html
[`SliverChildBuilderDelegate`]: {{site.api}}/flutter/widgets/SliverChildBuilderDelegate-class.html
[`SliverChildDelegate`]: {{site.api}}/flutter/widgets/SliverChildDelegate-class.html
[`SliverGrid`]: {{site.api}}/flutter/widgets/SliverGrid-class.html
[`SliverList`]: {{site.api}}/flutter/widgets/SliverList-class.html
[various properties you can pass to the `SliverAppBar` widget]: {{site.api}}/flutter/material/SliverAppBar/SliverAppBar.html
