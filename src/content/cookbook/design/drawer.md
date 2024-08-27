---
# title: Add a drawer to a screen
title: 화면에 Drawer 추가
# description: How to implement a Material Drawer.
description: Material Drawer을 구현하는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/design/drawer"?>

Material Design을 사용하는 앱에서는, 네비게이션을 위한 두 가지 주요 옵션이 있습니다. 
탭과 Drawer입니다. 탭을 지원할 공간이 충분하지 않은 경우, Drawer은 편리한 대안을 제공합니다.

Flutter에서, [`Drawer`][] 위젯을 [`Scaffold`][]와 함께 사용하여, 
Material Design Drawer이 있는 레이아웃을 만듭니다. 
이 레시피는 다음 단계를 사용합니다.

1. `Scaffold`를 만듭니다.
2. Drawer를 추가합니다.
3. Drawer에 아이템을 채웁니다.
4. Drawer를 프로그래밍 방식으로 닫습니다.

## 1. `Scaffold` 생성 {:#1-create-a-scaffold}

앱에 Drawer를 추가하려면 [`Scaffold`][] 위젯으로 래핑합니다. 
`Scaffold` 위젯은 Material Design 가이드라인을 따르는 앱에 일관된 시각적 구조를 제공합니다. 
또한 Drawers, AppBars, SnackBars와 같은 특수한 Material Design 구성 요소도 지원합니다.

이 예제에서는, `drawer`가 있는 `Scaffold`를 만듭니다.

<?code-excerpt "lib/drawer.dart (DrawerStart)" replace="/null, //g"?>
```dart
Scaffold(
  appBar: AppBar(
    title: const Text('AppBar without hamburger button'),
  ),
  drawer: // 다음 단계에서는 여기에 Drawer를 추가합니다.
);
```

## 2. Drawer 추가 {:#2-add-a-drawer}

이제 `Scaffold`에 Drawer를 추가합니다. 
Drawer는 어떤 위젯이든 될 수 있지만, 종종 [material library][]의 `Drawer` 위젯을 사용하는 것이 가장 좋습니다. 
이 위젯은 Material Design 사양을 준수합니다.

<?code-excerpt "lib/drawer.dart (DrawerEmpty)" replace="/null, //g"?>
```dart
Scaffold(
  appBar: AppBar(
    title: const Text('AppBar with hamburger button'),
  ),
  drawer: Drawer(
    child: // 다음 단계에서는 Drawer를 채웁니다.
  ),
);
```

## 3. Drawer에 아이템 채우기 {:#3-populate-the-drawer-with-items}

`Drawer`가 제 위치에 있으므로, 이제 여기에 콘텐츠를 추가합니다. 
이 예제에서는, [`ListView`][]를 사용합니다. 
`Column` 위젯을 사용할 수 있지만, 
`ListView`는 콘텐츠가 화면에서 지원하는 것보다 더 많은 공간을 차지하는 경우
사용자가 Drawer를 스크롤할 수 있기 때문에 편리합니다.

`ListView`를 [`DrawerHeader`][]와 두 개의 [`ListTile`][] 위젯으로 채웁니다. 
Lists로 작업하는 것에 대한 자세한 내용은 [리스트 레시피][list recipes]를 참조하세요.

<?code-excerpt "lib/drawer.dart (DrawerListView)"?>
```dart
Drawer(
  // Drawer에 ListView를 추가합니다. 
  // 이렇게 하면 모든 것을 담을 수 있는 vertical 공간이 충분하지 않을 때, 
  // 사용자가 Drawer의 옵션들을 스크롤할 수 있습니다.
  child: ListView(
    // 중요: ListView에서 패딩을 제거하세요.
    padding: EdgeInsets.zero,
    children: [
      const DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Text('Drawer Header'),
      ),
      ListTile(
        title: const Text('Item 1'),
        onTap: () {
          // 앱 상태를 업데이트합니다.
          // ...
        },
      ),
      ListTile(
        title: const Text('Item 2'),
        onTap: () {
          // 앱 상태를 업데이트합니다.
          // ...
        },
      ),
    ],
  ),
);
```

## 4. Drawer를 프로그래밍 방식으로 열기 {:#4-open-the-drawer-programmatically}

일반적으로, `drawer`를 여는 데 코드를 쓸 필요가 없습니다. 
왜냐하면 `leading` 위젯이 null일 때, `AppBar`의 기본 구현은 `DrawerButton`이기 때문입니다.

하지만 `drawer`를 자유롭게 제어하고 싶다면, 
`Builder`를 사용해 `Scaffold.of(context).openDrawer()`을 호출하면 됩니다.

<?code-excerpt "lib/drawer.dart (DrawerOpen)" replace="/null, //g"?>
```dart
Scaffold(
  appBar: AppBar(
    title: const Text('AppBar with hamburger button'),
    leading: Builder(
      builder: (context) {
        return IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        );
      },
    ),
  ),
  drawer: Drawer(
    child: // 마지막 단계로 여기에 Drawer를 채웁니다.
  ),
);
```

## 5. Drawer를 프로그래밍 방식으로 닫기 {:#5-close-the-drawer-programmatically}

사용자가 아이템을 탭한 후, 당신은 Drawer를 닫게 하고 싶을 수 있습니다. 
[`Navigator`][]를 사용하여 이를 수행할 수 있습니다.

사용자가 Drawer를 열면, Flutter는 Drawer를 네비게이션 스택에 추가합니다. 
따라서, Drawer를 닫으려면, `Navigator.pop(context)`를 호출합니다.

<?code-excerpt "lib/drawer.dart (CloseDrawer)"?>
```dart
ListTile(
  title: const Text('Item 1'),
  onTap: () {
    // 앱 상태 업데이트
    // ...
    // 그런 다음 Drawer를 닫습니다.
    Navigator.pop(context);
  },
),
```

## 상호 작용 예제 {:#interactive-example}

이 예제에서는 [`Scaffold`][] 위젯 내에서 사용되는 [`Drawer`][]를 보여줍니다. 
[`Drawer`][]에는 세 개의 [`ListTile`][] 아이템이 있습니다. 
`_onItemTapped` 함수는 선택한 아이템의 인덱스를 변경하고, `Scaffold` 중앙에 해당 텍스트를 표시합니다.

:::note
네비게이션 구현에 대한 자세한 내용은
쿡북의 [네비게이션][Navigation] 섹션을 확인하세요.
:::

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter drawer hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const appTitle = 'Drawer Demo';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      drawer: Drawer(
        // Drawer에 ListView를 추가합니다. 
        // 이렇게 하면 모든 것을 담을 수 있는 vertical 공간이 충분하지 않을 때, 
        // 사용자가 Drawer의 옵션들을 스크롤할 수 있습니다.
        child: ListView(
          // 중요: ListView에서 패딩을 제거하세요.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Home'),
              selected: _selectedIndex == 0,
              onTap: () {
                // 앱 상태를 업데이트합니다.
                _onItemTapped(0);
                // 그런 다음 Drawer를 닫습니다.
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Business'),
              selected: _selectedIndex == 1,
              onTap: () {
                // 앱 상태를 업데이트합니다.
                _onItemTapped(1);
                // 그런 다음 Drawer를 닫습니다.
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('School'),
              selected: _selectedIndex == 2,
              onTap: () {
                // 앱 상태를 업데이트합니다.
                _onItemTapped(2);
                // 그런 다음 Drawer를 닫습니다.
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/drawer.png" alt="Drawer Demo" class="site-mobile-screenshot" />
</noscript>


[`Drawer`]: {{site.api}}/flutter/material/Drawer-class.html
[`DrawerHeader`]: {{site.api}}/flutter/material/DrawerHeader-class.html
[list recipes]: /cookbook#lists
[`ListTile`]: {{site.api}}/flutter/material/ListTile-class.html
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
[material library]: {{site.api}}/flutter/material/material-library.html
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`Scaffold`]: {{site.api}}/flutter/material/Scaffold-class.html
[Navigation]: /cookbook#navigation
