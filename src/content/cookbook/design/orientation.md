---
# title: Update the UI based on orientation
title: 방향(orientation)에 따라 UI 업데이트
# description: Respond to a change in the screen's orientation.
description: 화면 방향의 변화에 ​​대응합니다.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/design/orientation"?>

어떤 상황에서는, 사용자가 화면을 세로 모드(portrait)에서 가로 모드(landscape)로 돌릴 때
앱의 디스플레이를 업데이트하고 싶을 수 있습니다. 
예를 들어, 앱은 세로 모드에서 한 아이템을 다음 아이템 뒤에 표시하지만, 
가로 모드에서는 같은 아이템을 나란히 표시할 수 있습니다.

Flutter에서는, 주어진 [`Orientation`][]에 따라 다른 레이아웃을 빌드할 수 있습니다. 
이 예에서는, 다음 단계를 사용하여 세로 모드에서 두 개의 열과 가로 모드에서 세 개의 열을 표시하는 리스트를 빌드합니다.

  1. 두 개의 열이 있는 `GridView`를 빌드합니다.
  2. `OrientationBuilder`를 사용하여 열의 수를 변경합니다.

## 1. 두 개의 열이 있는 `GridView` 빌드 {:#1-build-a-gridview-with-two-columns}

먼저, 작업할 아이템 리스트를 만듭니다. 
일반 리스트를 사용하는 대신, 그리드에 아이템을 표시하는 리스트를 만듭니다. 
지금은, 두 개의 열이 있는 그리드를 만듭니다.

<?code-excerpt "lib/partials.dart (GridViewCount)"?>
```dart
return GridView.count(
  // 2개의 열이 있는 리스트
  crossAxisCount: 2,
  // ...
);
```

`GridViews` 작업에 대해 자세히 알아보려면, 
[그리드 리스트 만들기][Creating a grid list] 레시피를 참조하세요.

## 2. `OrientationBuilder`를 사용하여 열 수를 변경 {:#2-use-an-orientationbuilder-to-change-the-number-of-columns}

앱의 현재 `Orientation`을 확인하려면, [`OrientationBuilder`][] 위젯을 사용합니다. 
`OrientationBuilder`는 부모 위젯에서 사용 가능한 너비와 높이를 비교하여 현재 `Orientation`을 계산하고, 
부모 위젯의 크기가 변경되면 다시 빌드합니다.

`Orientation`을 사용하여, 세로 모드에서 두 개의 열 또는 가로 모드에서 세 개의 열을 표시하는 리스트를 빌드합니다.

<?code-excerpt "lib/partials.dart (OrientationBuilder)"?>
```dart
body: OrientationBuilder(
  builder: (context, orientation) {
    return GridView.count(
      // 세로 모드에서는 2열의 그리드를 만들고, 가로 모드에서는 3열의 그리드를 만듭니다.
      crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
    );
  },
),
```

:::note
부모 위젯에서 사용 가능한 공간의 양이 아닌, 화면 방향(orientation)에 관심이 있는 경우, 
`OrientationBuilder` 위젯 대신 `MediaQuery.of(context).orientation`을 사용하세요.
:::

## 상호 작용 예제 {:#interactive-example}

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter app orientation hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Orientation Demo';

    return const MaterialApp(
      title: appTitle,
      home: OrientationList(
        title: appTitle,
      ),
    );
  }
}

class OrientationList extends StatelessWidget {
  final String title;

  const OrientationList({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return GridView.count(
            // 세로 모드에서는 2열의 그리드를 만들고, 가로 모드에서는 3열의 그리드를 만듭니다.
            crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
            // 리스트에 인덱스를 표시하는 100개의 위젯을 생성합니다.
            children: List.generate(100, (index) {
              return Center(
                child: Text(
                  'Item $index',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/orientation.gif" alt="Orientation Demo" class="site-mobile-screenshot" />
</noscript>

## 장치 방향 고정 {:#locking-device-orientation}

이전 섹션에서는, 앱 UI를 기기 방향 변경에 맞게 조정하는 방법을 알아보았습니다.

Flutter에서는 [`DeviceOrientation`] 값을 사용하여 앱이 지원하는 방향을 지정할 수도 있습니다. 
다음 중 하나를 선택할 수 있습니다.

- 앱을 단일 방향으로 잠그기(예: `portraitUp` 위치만) 또는...
- `portraitUp`과 `portraitDown` 둘 다와 같이 여러 방향을 허용하지만, 가로 모드는 허용하지 않기

애플리케이션 `main()` 메서드에서, 
앱이 지원하는 기본 방향 리스트와 함께 [`SystemChrome.setPreferredOrientations()`]를 호출합니다.

기기를 단일 방향으로 잠그려면, 단일 아이템이 있는 리스트를 전달할 수 있습니다.

가능한 모든 값 리스트는 [`DeviceOrientation`]을 확인하세요.

<?code-excerpt "lib/orientation.dart (PreferredOrientations)"?>
```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}
```


[Creating a grid list]: /cookbook/lists/grid-lists
[`DeviceOrientation`]: {{site.api}}/flutter/services/DeviceOrientation.html
[`OrientationBuilder`]: {{site.api}}/flutter/widgets/OrientationBuilder-class.html
[`Orientation`]: {{site.api}}/flutter/widgets/Orientation.html
[`SystemChrome.setPreferredOrientations()`]: {{site.api}}/flutter/services/SystemChrome/setPreferredOrientations.html
