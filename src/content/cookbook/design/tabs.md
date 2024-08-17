---
# title: Work with tabs
title: 탭으로 작업하기
# description: How to implement tabs in a layout.
description: 레이아웃에 탭을 구현하는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/design/tabs/"?>

탭으로 작업하기는 Material Design 가이드라인을 따르는 앱에서 일반적인 패턴입니다. 
Flutter에는 [material 라이브러리][material library]의 일부로 탭 레이아웃을 만드는 편리한 방법이 포함되어 있습니다.

이 레시피는 다음 단계를 사용하여 탭 예제를 만듭니다.

  1. `TabController`를 만듭니다.
  2. 탭을 만듭니다.
  3. 각 탭에 대한 콘텐츠를 만듭니다.

## 1. `TabController` 생성 {:#1-create-a-tabcontroller}

탭이 작동하려면, 선택한 탭과 콘텐츠 섹션을 동기화 상태로 유지해야 합니다. 이는 [`TabController`][]의 작업입니다.

`TabController`를 수동으로 만들거나, [`DefaultTabController`][] 위젯을 사용하여 자동으로 만듭니다.

`DefaultTabController`를 사용하는 것이 가장 간단한 옵션인데, 
`TabController`를 만들고 모든 하위 위젯에서 사용할 수 있게 하기 때문입니다.

<?code-excerpt "lib/partials.dart (TabController)"?>
```dart
return MaterialApp(
  home: DefaultTabController(
    length: 3,
    child: Scaffold(),
  ),
);
```

## 2. 탭 만들기 {:#2-create-the-tabs}

탭이 선택되면, 콘텐츠를 표시해야 합니다. 
[`TabBar`][] 위젯을 사용하여 탭을 만들 수 있습니다. 
이 예에서, 세 개의 [`Tab`][] 위젯이 있는 `TabBar`를 만들고, [`AppBar`][] 내에 배치합니다.

<?code-excerpt "lib/partials.dart (Tabs)"?>
```dart
return MaterialApp(
  home: DefaultTabController(
    length: 3,
    child: Scaffold(
      appBar: AppBar(
        bottom: const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.directions_car)),
            Tab(icon: Icon(Icons.directions_transit)),
            Tab(icon: Icon(Icons.directions_bike)),
          ],
        ),
      ),
    ),
  ),
);
```

기본적으로, `TabBar`는 가장 가까운 `DefaultTabController`에 대한 위젯 트리를 찾습니다. 
`TabController`를 수동으로 생성하는 경우, `TabBar`에 전달합니다.

## 3. 각 탭에 대한 콘텐츠 생성 {:#3-create-content-for-each-tab}

이제 탭이 있으므로, 탭이 선택되면 콘텐츠를 표시합니다. 
이를 위해, [`TabBarView`][] 위젯을 사용합니다.

:::note
순서가 중요하며, `TabBar`에 있는 탭의 순서와 일치해야 합니다.
:::

<?code-excerpt "lib/main.dart (TabBarView)"?>
```dart
body: const TabBarView(
  children: [
    Icon(Icons.directions_car),
    Icon(Icons.directions_transit),
    Icon(Icons.directions_bike),
  ],
),
```

## 상호 작용 예제 {:#interactive-example}

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter TabBar DartPad hands-on example" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(const TabBarDemo());
}

class TabBarDemo extends StatelessWidget {
  const TabBarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
            title: const Text('Tabs Demo'),
          ),
          body: const TabBarView(
            children: [
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/tabs.gif" alt="Tabs Demo" class="site-mobile-screenshot" />
</noscript>


[`AppBar`]: {{site.api}}/flutter/material/AppBar-class.html
[`DefaultTabController`]: {{site.api}}/flutter/material/DefaultTabController-class.html
[material library]: {{site.api}}/flutter/material/material-library.html
[`Tab`]: {{site.api}}/flutter/material/Tab-class.html
[`TabBar`]: {{site.api}}/flutter/material/TabBar-class.html
[`TabBarView`]: {{site.api}}/flutter/material/TabBarView-class.html
[`TabController`]: {{site.api}}/flutter/material/TabController-class.html
