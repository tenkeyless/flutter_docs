---
# title: Migrate to Material 3
title: Material 3로 마이그레이션
# description: >-
#   Learn how to migrate your Flutter app's UI from Material 2 to Material 3.
description: >-
  Flutter 앱의 UI를 Material 2에서 Material 3로 마이그레이션하는 방법을 알아보세요.
---

## 요약 {:#summary}

Material 라이브러리가 Material 3 Design 사양과 일치하도록 업데이트되었습니다. 
변경 사항에는 새로운 컴포넌트와 컴포넌트 테마, 업데이트된 컴포넌트 비주얼 등이 있습니다. 
이러한 업데이트 중 다수는 매끄럽습니다. 
3.16 (또는 이후) 릴리스에 대해 앱을 다시 컴파일하면, 영향을 받는 위젯의 새 버전이 표시됩니다. 
그러나, 마이그레이션을 완료하려면 수동 작업도 필요합니다.

## 마이그레이션 가이드 {:#migration-guide}

3.16 릴리스 이전에는 `useMaterial3` 플래그를 true로 설정하여, Material 3 변경 사항을 선택할 수 있었습니다. 
Flutter 3.16 릴리스(2023년 11월)부터 `useMaterial3`는 기본적으로 true입니다.

그런데, `useMaterial3`를 `false`로 설정하여 앱에서 Material 2 동작으로 _되돌릴 수_ 있습니다. 
그러나, 이것은 일시적인 해결책일 뿐입니다. 
`useMaterial3` 플래그 _및_ Material 2 구현은 결국 Flutter의 지원 중단 정책의 일부로 제거될 것입니다.

### 컬러 {:#colors}

Code before migration:

`ThemeData.colorScheme`의 기본값은 Material 3 Design 사양과 일치하도록 업데이트되었습니다.

`ColorScheme.fromSeed` 생성자는 주어진 `seedColor`에서 파생된 `ColorScheme`을 생성합니다. 
이 생성자가 생성한 색상은 서로 잘 어울리도록 설계되었으며, 
Material 3 Design 시스템에서 접근성을 위한 대비 요구 사항을 충족합니다.

3.16 릴리스로 업데이트할 때, 올바른 `ColorScheme`이 없으면 UI가 약간 이상해 보일 수 있습니다. 
이를 수정하려면, `ColorScheme.fromSeed` 생성자에서 생성된 `ColorScheme`으로 마이그레이션합니다.

마이그레이션 전 코드:

```dart
theme: ThemeData(
  colorScheme: ColorScheme.light(primary: Colors.blue),
),
```

마이그레이션 후 코드:

```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
),
```

콘텐츠 기반 동적 색상 구성표를 생성하려면, `ColorScheme.fromImageProvider` static 메서드를 사용합니다. 
색상 구성표를 생성하는 예는 [네트워크 이미지로부터의 `ColorScheme`][`ColorScheme` from a network image] 샘플을 확인하세요.

[`ColorScheme` from a network image]: {{site.api}}/flutter/material/ColorScheme/fromImageProvider.html

Flutter Material 3의 변경 사항에는 새로운 배경색이 포함됩니다. 
`ColorScheme.surfaceTint`는 elevated 위젯을 나타냅니다. 일부 위젯은 다른 색상을 사용합니다.

앱의 UI를 이전 동작으로 되돌리려면 (권장하지 않음):

* `Colors.grey[50]!`를 `ColorScheme.background`로 설정합니다. (테마가 `Brightness.light`인 경우)
* `Colors.grey[850]!`를 `ColorScheme.background`로 설정합니다. (테마가 `Brightness.dark`인 경우)

마이그레이션 전 코드:

```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
),
```

마이그레이션 후 코드:

```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(
    background: Colors.grey[50]!,
  ),
),
```

```dart
darkTheme: ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    brightness: Brightness.dark,
  ).copyWith(background: Colors.grey[850]!),
),
```

`ColorScheme.surfaceTint` 값은 Material 3에서 컴포넌트의 elevation을 나타냅니다. 
일부 위젯은 elevation을 나타내기 위해 `surfaceTint`와 `shadowColor`를 모두 사용할 수 있고, (예: `Card`와 `ElevatedButton`)
다른 위젯은 elevation을 나타내기 위해 `surfaceTint`만 사용할 수 있습니다. (예: `AppBar`)

위젯의 이전 동작으로 돌아가려면, 테마에서 `Colors.transparent`를 `ColorScheme.surfaceTint`로 설정합니다. 
위젯의 그림자를 콘텐츠와 구분하려면(그림자가 없는 경우), 
위젯 테마에서 기본 그림자 색상 없이 `ColorScheme.shadow` 색상을 `shadowColor` 속성으로 설정합니다.

마이그레이션 전 코드:

```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
),
```

마이그레이션 후 코드:

```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(
    surfaceTint: Colors.transparent,
  ),
  appBarTheme: AppBarTheme(
   elevation: 4.0,
   shadowColor: Theme.of(context).colorScheme.shadow,
 ),
),
```

`ElevatedButton`은 이제 새로운 색상 조합으로 자체 스타일을 지정합니다. 
이전에는, `useMaterial3` 플래그가 false로 설정되었을 때, 
`ElevatedButton`은 배경에 `ColorScheme.primary`를 사용하고 전경에 `ColorScheme.onPrimary`를 사용하여, 
자체 스타일을 지정했습니다. 
동일한 비주얼을 얻으려면, elevation 변경이나 그림자가 없는 새로운 `FilledButton` 위젯으로 전환합니다.

마이그레이션 전 코드:

```dart
ElevatedButton(
  onPressed: () {},
  child: const Text('Button'),
),
```

마이그레이션 후 코드:

```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Theme.of(context).colorScheme.onPrimary,
  ),
  onPressed: () {},
  child: const Text('Button'),
),
```

### 타이포그래피 {:#typography}

`ThemeData.textTheme`의 기본값은 Material 3 기본값과 일치하도록 업데이트되었습니다. 
변경 사항에는 글꼴 크기, 글꼴 굵기, 문자 간격 및 줄 높이가 업데이트되었습니다. 
자세한 내용은, [`TextTheme`][] 문서를 확인하세요.

다음 예에서 볼 수 있듯이, 3.16 릴리스 이전에는, 
`TextTheme.bodyLarge`를 사용하여 제한된 레이아웃에서 긴 문자열이 있는 `Text` 위젯이 텍스트를 두 줄로 줄바꿈했습니다. 
그러나, 3.16 릴리스에서는 텍스트를 세 줄로 줄바꿈합니다. 
이전 동작을 달성해야 하는 경우, 텍스트 스타일을 조정하고, 필요한 경우, 문자 간격을 조정하세요.

마이그레이션 전 코드:

```dart
ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: 200),
    child: Text(
      'This is a very long text that should wrap to multiple lines.',
      style: Theme.of(context).textTheme.bodyLarge,
  ),
),
```

마이그레이션 후 코드:

```dart
ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: 200),
    child: Text(
      'This is a very long text that should wrap to multiple lines.',
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
        letterSpacing: 0.0,
      ),
  ),
),
```

[`TextTheme`]: {{site.api}}/flutter/material/TextTheme-class.html

### 컴포넌트 {:#components}

일부 컴포넌트는 Material 3 Design 사양에 맞게 업데이트할 수 없을 뿐만 아니라 완전히 새로운 구현이 필요했습니다. 
이러한 컴포넌트는 Flutter SDK가 정확히 무엇을 원하는지 알지 못하기 때문에 수동 마이그레이션이 필요합니다.

Material 2 스타일 [`BottomNavigationBar`][] 위젯을 새 [`NavigationBar`][] 위젯으로 바꾸세요. 
약간 더 높고, 알약 모양의 네비게이션 표시기가 포함되어 있으며, 새로운 색상 매핑을 사용합니다.

마이그레이션 전 코드:

```dart
BottomNavigationBar(
  items: const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.business),
      label: 'Business',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.school),
      label: 'School',
    ),
  ],
),
```

마이그레이션 후 코드:

```dart
NavigationBar(
  destinations: const <Widget>[
    NavigationDestination(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.business),
      label: 'Business',
    ),
    NavigationDestination(
      icon: Icon(Icons.school),
      label: 'School',
    ),
  ],
),
```

[`BottomNavigationBar`에서 `NavigationBar`로 마이그레이션][migrating from `BottomNavigationBar` to `NavigationBar`]에 대한 전체 샘플을 확인하세요.

[`Drawer`][] 위젯을 알약 모양의 네비게이션 표시기, 둥근 모서리, 새로운 색상 매핑을 제공하는 [`NavigationDrawer`][]로 바꾸세요.

마이그레이션 전 코드:

```dart
Drawer(
  child: ListView(
    children: <Widget>[
      DrawerHeader(
        child: Text(
          'Drawer Header',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      ListTile(
        leading: const Icon(Icons.message),
        title: const Text('Messages'),
        onTap: () { },
      ),
      ListTile(
        leading: const Icon(Icons.account_circle),
        title: const Text('Profile'),
        onTap: () {},
      ),
      ListTile(
        leading: const Icon(Icons.settings),
        title: const Text('Settings'),
        onTap: () { },
      ),
    ],
  ),
),
```

마이그레이션 후 코드:

```dart
NavigationDrawer(
  children: <Widget>[
    DrawerHeader(
      child: Text(
        'Drawer Header',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    ),
    const NavigationDrawerDestination(
      icon: Icon(Icons.message),
      label: Text('Messages'),
    ),
    const NavigationDrawerDestination(
      icon: Icon(Icons.account_circle),
      label: Text('Profile'),
    ),
    const NavigationDrawerDestination(
      icon: Icon(Icons.settings),
      label: Text('Settings'),
    ),
  ],
),
```

[`Drawer`에서 `NavigationDrawer`로 마이그레이션][migrating from `Drawer` to `NavigationDrawer`]에 대한 전체 샘플을 확인하세요.

Material 3은 스크롤하기 전에 더 큰 헤드라인을 표시하는 중간 및 큰 앱 바를 도입합니다. 
드롭섀도 대신, `ColorScheme.surfaceTint` 색상을 사용하여 스크롤할 때 콘텐츠와 분리합니다.

다음 코드는 중간 앱 바를 구현하는 방법을 보여줍니다.

```dart
CustomScrollView(
  slivers: <Widget>[
    const SliverAppBar.medium(
      title: Text('Title'),
    ),
    SliverToBoxAdapter(
      child: Card(
        child: SizedBox(
          height: 1200,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 100, 8, 100),
            child: Text(
              'Here be scrolling content...',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
      ),
    ),
  ],
),
```

이제 [`TabBar`][] 위젯에는 기본(primary) 및 보조(secondary)의 두 가지 타입이 있습니다. 
보조 탭은 콘텐츠 영역 내에서 관련 콘텐츠를 추가로 구분하고 계층 구조를 설정하는 데 사용됩니다. 
[`TabBar.secondary`][] 예제를 확인하세요.

새로운 [`TabBar.tabAlignment`][] 속성은 탭의 수평 정렬을 지정합니다.

다음 샘플은 스크롤 가능한 `TabBar`에서 탭 정렬을 수정하는 방법을 보여줍니다.

```dart
AppBar(
  title: const Text('Title'),
  bottom: const TabBar(
    tabAlignment: TabAlignment.start,
    isScrollable: true,
    tabs: <Widget>[
      Tab(
        icon: Icon(Icons.cloud_outlined),
      ),
      Tab(
        icon: Icon(Icons.beach_access_sharp),
      ),
      Tab(
        icon: Icon(Icons.brightness_5_sharp),
      ),
    ],
  ),
),
```

[`SegmentedButton`][]은 [`ToggleButtons`][]의 업데이트된 버전으로, 
완전히 둥근 모서리를 사용하고, 레이아웃 높이와 크기가 다르며, 
Dart `Set`을 사용하여 선택된 아이템을 결정합니다.

마이그레이션 전 코드:

```dart
enum Weather { cloudy, rainy, sunny }

ToggleButtons(
  isSelected: const [false, true, false],
  onPressed: (int newSelection) { },
  children: const <Widget>[
    Icon(Icons.cloud_outlined),
    Icon(Icons.beach_access_sharp),
    Icon(Icons.brightness_5_sharp),
  ],
),
```

마이그레이션 후 코드:

```dart
enum Weather { cloudy, rainy, sunny }

SegmentedButton<Weather>(
  selected: const <Weather>{Weather.rainy},
  onSelectionChanged: (Set<Weather> newSelection) { },
  segments: const <ButtonSegment<Weather>>[
    ButtonSegment(
      icon: Icon(Icons.cloud_outlined),
      value: Weather.cloudy,
    ),
    ButtonSegment(
      icon: Icon(Icons.beach_access_sharp),
      value: Weather.rainy,
    ),
    ButtonSegment(
      icon: Icon(Icons.brightness_5_sharp),
      value: Weather.sunny,
    ),
  ],
),
```

[`ToggleButtons`에서 `SegmentedButton`으로 마이그레이션][migrating from `ToggleButtons` to `SegmentedButton`]하는 것에 대한 전체 샘플을 확인하세요.

[migrating from `BottomNavigationBar` to `NavigationBar`]: {{site.api}}/flutter/material/BottomNavigationBar-class.html#material.BottomNavigationBar.2
[migrating from `Drawer` to `NavigationDrawer`]: {{site.api}}/flutter/material/Drawer-class.html#material.Drawer.2
[migrating from `ToggleButtons` to `SegmentedButton`]: {{site.api}}/flutter/material/ToggleButtons-class.html#material.ToggleButtons.1

#### 새로운 컴포넌트 {:#new-components}

* "메뉴 막대와 계단식(cascading) 메뉴"는 마우스나 키보드로 완전히 이동할 수 있는 데스크톱 스타일 메뉴 시스템을 제공합니다.
  메뉴는 [`MenuBar`][] 또는 [`MenuAnchor`][]로 고정됩니다. 
  새 메뉴 시스템은 기존 애플리케이션이 마이그레이션해야 하는 것은 아니지만, 
  웹이나 데스크톱 플랫폼에 배포된 애플리케이션은 `PopupMenuButton`(및 관련) 클래스 대신 이를 사용하는 것을 고려해야 합니다.
* [`DropdownMenu`][]는 텍스트 필드와 메뉴를 결합하여 _콤보 상자(combo box)_ 라고도 하는 것을 생성합니다. 
  사용자는 일치하는 문자열을 입력하거나 터치, 마우스 또는 키보드로 메뉴와 상호 작용하여, 
  잠재적으로 큰 리스트에서 메뉴 아이템을 선택할 수 있습니다. 
  이것은 `DropdownButton` 위젯을 대체하기에 적합하지만, 반드시 필요한 것은 아닙니다.
* [`SearchBar`][] 및 [`SearchAnchor`][]는 사용자가 검색어를 입력하고 앱이 일치하는 응답 리스트를 계산한 다음, 
  사용자가 하나를 선택하거나 쿼리를 조정하는 상호작용을 위한 것입니다.
* [`Badge`][]는 몇 글자로 구성된 작은 레이블로 자식을 장식합니다. '+1'과 같습니다. 
  배지는 일반적으로 `NavigationDestination`, `NavigationRailDestination`, 
  `NavigationDrawerDestination` 또는 버튼 아이콘(예: `TextButton.icon`) 내의 아이콘을 장식하는 데 사용됩니다.
* [`FilledButton`][] 및 [`FilledButton.tonal`][]은 elevation 변경 및 그림자가 없는 `ElevatedButton`과 매우 유사합니다.
* [`FilterChip.elevated`][], [`ChoiceChip.elevated`][], 및 [`ActionChip.elevated`][]는 드롭 섀도우와 채우기 색상이 있는 동일한 칩의 elevated 변형입니다.
* [`Dialog.fullscreen`][]은 전체 화면을 채우고, 일반적으로 제목, 작업 버튼, 상단에 닫기 버튼이 포함됩니다.

[`BottomNavigationBar`]: {{site.api}}/flutter/material/BottomNavigationBar-class.html
[`NavigationBar`]: {{site.api}}/flutter/material/NavigationBar-class.html
[`Drawer`]: {{site.api}}/flutter/material/Drawer-class.html
[`NavigationDrawer`]: {{site.api}}/flutter/material/NavigationDrawer-class.html
[`TabBar`]: {{site.api}}/flutter/material/TabBar-class.html
[`TabBar.secondary`]: {{site.api}}/flutter/material/TabBar/TabBar.secondary.html
[`TabBar.tabAlignment`]: {{site.api}}/flutter/material/TabBar/tabAlignment.html
[`SegmentedButton`]: {{site.api}}/flutter/material/SegmentedButton-class.html
[`ToggleButtons`]: {{site.api}}/flutter/material/ToggleButtons-class.html
[`MenuBar`]: {{site.api}}/flutter/material/MenuBar-class.html
[`MenuAnchor`]: {{site.api}}/flutter/material/MenuAnchor-class.html
[`DropdownMenu`]: {{site.api}}/flutter/material/DropdownMenu-class.html
[`SearchBar`]: {{site.api}}/flutter/material/SearchBar-class.html
[`SearchAnchor`]: {{site.api}}/flutter/material/SearchAnchor-class.html
[`Badge`]: {{site.api}}/flutter/material/Badge-class.html
[`FilledButton`]: {{site.api}}/flutter/material/FilledButton-class.html
[`FilledButton.tonal`]: {{site.api}}/flutter/material/FilledButton/FilledButton.tonal.html
[`FilterChip.elevated`]: {{site.api}}/flutter/material/FilterChip/FilterChip.elevated.html
[`ChoiceChip.elevated`]: {{site.api}}/flutter/material/ChoiceChip/ChoiceChip.elevated.html
[`ActionChip.elevated`]: {{site.api}}/flutter/material/ActionChip/ActionChip.elevated.html
[`Dialog.fullscreen`]: {{site.api}}/flutter/material/Dialog/Dialog.fullscreen.html

## 타임라인 {:#timeline}

stable 릴리즈: 3.16

## 참조 {:#references}

문서:

* [Flutter용 Material Design][Material Design for Flutter]

API 문서:

* [`ThemeData.useMaterial3`][]

관련 이슈:

* [Material 3 엄브렐라 이슈][Material 3 umbrella issue]

관련 PR:

* [`ThemeData.useMaterial3`의 기본값을 true로 변경][Change the default for `ThemeData.useMaterial3` to true]
* [`ThemeData.useMaterial3` API 문서 업데이트, 기본값은 true][Updated `ThemeData.useMaterial3` API doc, default is true]

[Material 3 umbrella issue]: {{site.repo.flutter}}/issues/91605
[Material Design for Flutter]: /ui/design/material
[`ThemeData.useMaterial3`]: {{site.api}}/flutter/material/ThemeData/useMaterial3.html
[Change the default for `ThemeData.useMaterial3` to true]: {{site.repo.flutter}}/pull/129724
[Updated `ThemeData.useMaterial3` API doc, default is true]: {{site.repo.flutter}}/pull/130764
