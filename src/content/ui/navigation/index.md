---
# title: Navigation and routing
title: 네비게이션과 라우팅
# description: Overview of Flutter's navigation and routing features
description: Flutter의 네비게이션 및 라우팅 기능 개요
---

Flutter는 화면 간을 탐색하고 딥 링크를 처리하기 위한 완전한 시스템을 제공합니다. 
복잡한 딥 링크가 없는 작은 애플리케이션은 [`Navigator`][]를 사용할 수 있는 반면, 
특정 딥 링크 및 네비게이션 요구 사항이 있는 앱은 [`Router`][]를 사용하여 
Android 및 iOS에서 딥 링크를 올바르게 처리하고, 앱이 웹에서 실행 중일 때 주소 표시줄과 동기화 상태를 유지해야 합니다.

딥링크를 처리하도록 Android 또는 iOS 애플리케이션을 구성하려면, [딥 링크][Deep linking]를 참조하세요.

## 네비게이터 사용 {:#using-the-navigator}

`Navigator` 위젯은 대상 플랫폼에 맞는 올바른 전환 애니메이션을 사용하여 화면을 스택으로 표시합니다. 
새 화면으로 이동하려면, 경로의 `BuildContext`를 통해 `Navigator`에 액세스하고, 
`push()` 또는 `pop()`와 같은 명령형 메서드를 호출합니다.

```dart
onPressed: () {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const SongScreen(song: song),
    ),
  );
},
child: Text(song.name),
```

`Navigator`는 `Route` 객체의 스택(history stack을 나타냄)을 유지하므로, 
`push()` 메서드도 `Route` 객체를 사용합니다. 
`MaterialPageRoute` 객체는 Material Design의 전환 애니메이션을 지정하는 `Route`의 하위 클래스입니다. 
`Navigator` 사용 방법에 대한 더 많은 예를 보려면 
Flutter 쿡북의 [네비게이션 레시피][navigation recipes]를 따르거나 [Navigator API 문서][`Navigator`]를 방문하세요.

## 명명된 경로 사용 {:#using-named-routes}

:::note
대부분의 애플리케이션에 명명된 경로를 사용하는 것은 권장하지 않습니다.
자세한 내용은 아래의 제한 사항 섹션을 참조하세요.
:::

간단한 탐색 및 딥 링크 요구 사항이 있는 애플리케이션은 
탐색을 위해 `Navigator`를 사용하고 
딥 링크를 위해 [`MaterialApp.routes`][] 매개변수를 사용할 수 있습니다.

```dart
@override
Widget build(BuildContext context) {
  return MaterialApp(
    routes: {
      '/': (context) => HomeScreen(),
      '/details': (context) => DetailScreen(),
    },
  );
}
```

여기에 지정된 경로를 _명명된 경로(named routes)_ 라고 합니다. 
전체 예를 보려면, Flutter Cookbook의 [명명된 경로로 탐색][Navigate with named routes] 레시피를 따르세요.

### 제한 사항 {:#limitations}

명명된 경로는 딥 링크를 처리할 수 있지만, 동작은 항상 동일하며 커스터마이즈 할 수 없습니다. 
플랫폼에서 새 딥 링크를 수신하면, Flutter는 현재 사용자가 어디에 있는지와 관계없이 새 `Route`를 Navigator에 푸시합니다.

Flutter는 또한 명명된 경로를 사용하는 애플리케이션에 대한 브라우저 앞으로 버튼을 지원하지 않습니다. 
이러한 이유로, 대부분의 애플리케이션에서 명명된 경로를 사용하지 않는 것이 좋습니다.

## Router 사용 {:#using-the-router}

고급 탐색 및 라우팅 요구 사항이 있는 Flutter 애플리케이션
(예: 각 화면에 직접 링크를 사용하는 웹 앱 또는 여러 개의 `Navigator` 위젯이 있는 앱)은 
앱이 새 딥 링크를 수신할 때마다 경로 경로를 구문 분석하고 `Navigator`를 구성할 수 있는 
[go_router][]와 같은 라우팅 패키지를 사용해야 합니다.

Router를 사용하려면, `MaterialApp` 또는 `CupertinoApp`에서 `router` 생성자로 전환하고 `Router` 구성을 제공합니다.
[go_router][]와 같은 라우팅 패키지는 일반적으로 구성을 제공합니다. 예를 들어, 다음과 같습니다.:

```dart
MaterialApp.router(
  routerConfig: GoRouter(
    // …
  )
);
```

go_router와 같은 패키지는 _선언적(declarative)_ 이기 때문에, 딥 링크를 수신하면 항상 동일한 화면을 표시합니다.


:::note 고급 개발자를 위한 참고사항
라우팅 패키지를 사용하지 않고 앱에서 탐색 및 라우팅을 완벽하게 제어하려면, 
`RouteInformationParser` 및 `RouterDelegate`를 재정의합니다. 
앱의 상태가 변경되면, `Navigator.pages` 매개변수를 사용하여 `Page` 객체 리스트를 제공하여 
화면 스택을 정확하게 제어할 수 있습니다. 
자세한 내용은, `Router` API 문서를 참조하세요.
:::

## 라우터와 네비게이터를 함께 사용하기 {:#using-router-and-navigator-together}

`Router`와 `Navigator`는 함께 작동하도록 설계되었습니다. 
`go_router`와 같은 선언적 라우팅 패키지를 통해 `Router` API를 사용하거나, 
`Navigator`에서 `push()` 및 `pop()`와 같은 명령형 메서드를 호출하여 탐색할 수 있습니다.

`Router` 또는 선언적 라우팅 패키지를 사용하여 탐색할 때, Navigator의 각 경로는 _페이지 백(page-backed)_ 됩니다. 
즉, `Navigator` 생성자의 [`pages`][] 인수를 사용하여 [`Page`][]에서 생성됨을 의미합니다. 
반대로, `Navigator.push` 또는 `showDialog`를 호출하여 생성된 모든 `Route`는 
Navigator에 _페이지 없는(pageless)_ 경로를 추가합니다. 
라우팅 패키지를 사용하는 경우, 
_페이지 백(page-backed)_ 된 경로는 항상 딥링크가 가능하지만, 
_페이지 없는(pageless)_ 경로는 그렇지 않습니다.

`Navigator`에서 _페이지 백(page-backed)_ 된 `Route`가 제거되면, 
그 뒤의 모든 _페이지 없는(pageless)_ 경로도 제거됩니다. 
예를 들어, 딥 링크가 Navigator에서 _페이지 백(page-backed)_ 된 경로를 제거하여 탐색하는 경우, 
그 뒤의 모든 _페이지 없는(pageless)_ 경로(다음 _페이지 백(page-backed)_ 된 경로까지)도 제거됩니다.

:::note
`WillPopScope`를 사용하여 _페이지 백(page-backed)_ 된 화면에서 탐색을 방지할 수 없습니다. 
대신, 라우팅 패키지의 API 문서를 참조해야 합니다.
:::

## 웹 지원 {:#web-support}

`Router` 클래스를 사용하는 앱은 브라우저의 뒤로 및 앞으로 버튼을 사용할 때 일관된 경험을 제공하기 위해 
브라우저 History API와 통합됩니다. 
`Router`를 사용하여 탐색할 때마다, History API 항목이 브라우저의 기록 스택에 추가됩니다. 
**back** 버튼을 누르면, _[역순 시간순 탐색][reverse chronological navigation]_ 이 사용되어, 
사용자가 `Router`를 사용하여 표시된 이전에 방문한 위치로 이동합니다. 
즉, 사용자가 `Navigator`에서 페이지를 팝업한 다음, 
브라우저 **back** 버튼을 누르면 이전 페이지가 스택으로 다시 푸시됩니다.

## 더 많은 정보 {:#more-information}

탐색 및 경로 설정에 대한 자세한 내용은, 다음 리소스를 확인하세요.

* Flutter 쿡북에는 `Navigator`를 사용하는 방법을 보여주는 여러 [탐색 레시피][navigation recipes]가 포함되어 있습니다.
* [`Navigator`][] 및 [`Router`][] API 문서에는 
  라우팅 패키지 없이 선언적 탐색을 설정하는 방법에 대한 세부 정보가 포함되어 있습니다.
* [탐색 이해][Understanding navigation]는 Material Design 문서의 한 페이지로, 
  앱에서 탐색을 디자인하기 위한 개념을 설명하며, 여기에는 앞으로, 위로, 연대순 탐색에 대한 설명이 포함됩니다.
* [Flutter의 새로운 탐색 및 라우팅 시스템 학습][Learning Flutter's new navigation and routing system]은 
  Medium의 글로, 라우팅 패키지 없이, `Router` 위젯을 직접 사용하는 방법을 설명합니다.
* [라우터 디자인 문서][Router design document]에는 `Router` API의 동기와 디자인이 포함되어 있습니다.

[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`Router`]: {{site.api}}/flutter/widgets/Router-class.html
[Deep linking]: /ui/navigation/deep-linking
[navigation recipes]: /cookbook#navigation
[`MaterialApp.routes`]: {{site.api}}/flutter/material/MaterialApp/routes.html
[Navigate with named routes]: /cookbook/navigation/named-routes
[go_router]: {{site.pub}}/packages/go_router
[`Page`]: {{site.api}}/flutter/widgets/Page-class.html
[`pages`]: {{site.api}}/flutter/widgets/Navigator/pages.html
[reverse chronological navigation]: https://material.io/design/navigation/understanding-navigation.html#reverse-navigation
[Understanding navigation]: https://material.io/design/navigation/understanding-navigation.html
[Learning Flutter's new navigation and routing system]: {{site.medium}}/flutter/learning-flutters-new-navigation-and-routing-system-7c9068155ade
[Router design document]: {{site.main-url}}/go/navigator-with-router
