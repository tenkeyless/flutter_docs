---
# title: Embedding Flutter on the web
title: 웹에 Flutter 임베딩
# short-title: Embedding Flutter web
short-title: Flutter 웹 임베딩
# description: Learn the different ways to embed Flutter views into web content.
description: Flutter 뷰를 웹 콘텐츠에 포함하는 다양한 방법을 알아보세요.
---

Flutter 뷰와 웹 콘텐츠를 구성하여 다양한 방식으로 웹 애플리케이션을 생성할 수 있습니다. 
사용 사례에 따라 다음 중 하나를 선택하세요.

* Flutter 뷰는 전체 페이지를 제어합니다. (전체 화면 모드)
* 기존 웹 애플리케이션에 Flutter 뷰 추가. (임베디드 모드)

## 1. 전체 화면 모드 {:#full-screen-mode}

전체 화면 모드에서, Flutter 웹 애플리케이션은 전체 브라우저 창을 제어하고, 렌더링 시 뷰포트를 완전히 덮습니다. 
이는 Flutter의 기본 임베딩 모드이며, 추가 구성이 필요하지 않습니다.

```html highlightLines=6
<!DOCTYPE html>
<html>
  <head>
  </head>
  <body>
    <script src="flutter_bootstrap.js" defer></script>
  </body>
</html>
```

Flutter 웹이 `multiViewEnabled` 또는 `hostElement`를 참조하지 않고, 부트스트랩되면 전체 화면 모드를 사용합니다.

`flutter_bootstrap.js` 파일에 대해 자세히 알아보려면, [앱 초기화 커스터마이즈][Customize app initialization]를 확인하세요.

[Customize app initialization]: {{site.docs}}/platform-integration/web/initialization/

### `iframe` 임베딩 {:#iframe-embedding}

`iframe`에 Flutter 웹 애플리케이션을 임베드할 때는 전체 화면 모드가 권장됩니다. 
`iframe`을 임베드하는 페이지는 필요에 따라 크기를 조정하고 위치를 지정할 수 있으며, Flutter가 완전히 채웁니다.

```html
<iframe src="https://url-to-your-flutter/index.html"></iframe>
```

`iframe`의 장단점에 대해 자세히 알아보려면, MDN의 [인라인 프레임 요소][Inline Frame element] 문서를 확인하세요.

[Inline Frame element]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/iframe

## 2. 임베디드 모드 {:#embedded-mode}

Flutter 웹 애플리케이션은 다른 웹 애플리케이션의 임의의 개수의 요소(일반적으로 `div`)에 콘텐츠를 렌더링할 수도 있습니다. 
이를 "임베디드 모드"(또는 "멀티 뷰")라고 합니다.

이 모드에서:

* Flutter 웹 애플리케이션은 시작할 수 있지만, `addView`로 첫 번째 "뷰"가 추가될 때까지 렌더링하지 않습니다.
* 호스트 애플리케이션은 임베디드 Flutter 웹 애플리케이션에서 뷰를 추가하거나 제거할 수 있습니다.
* Flutter 애플리케이션은 뷰가 추가되거나 제거될 때 알림을 받으므로 위젯을 적절히 조정할 수 있습니다.

### 멀티뷰 모드 활성화 {:#enable-multi-view-mode}

다음과 같이 `initializeEngine` 메서드에서 `multiViewEnabled: true`로 멀티뷰 모드 설정을 활성화합니다.

```js highlightLines=8
// flutter_bootstrap.js
{% raw %}{{flutter_js}}{% endraw %}
{% raw %}{{flutter_build_config}}{% endraw %}

_flutter.loader.load({
  onEntrypointLoaded: async function onEntrypointLoaded(engineInitializer) {
    let engine = await engineInitializer.initializeEngine({
      multiViewEnabled: true, // 임베디드 모드를 활성화합니다.
    });
    let app = await engine.runApp();
    // 이 `app` 객체를 JS 앱에서 사용할 수 있도록 하세요.
  }
});
```

### JS에서 Flutter 뷰 관리 {:#manage-flutter-views-from-js}

뷰를 추가하거나 제거하려면, `runApp` 메서드에서 반환된 `app` 객체를 사용합니다.

```js highlightLines=2-4,7
// 뷰 추가...
let viewId = app.addView({
  hostElement: document.querySelector('#some-element'),
});

// viewId 제거...
let viewConfig = flutterApp.removeView(viewId);
```

### Dart에서 뷰 변경 처리 {:#handling-view-changes-from-dart}

뷰 추가 및 제거는 `WidgetsBinding` 클래스의 [`didChangeMetrics` 메서드][`didChangeMetrics` method]를 통해 Flutter에 표면화됩니다.

Flutter 앱에 연결된 뷰의 전체 리스트는 `WidgetsBinding.instance.platformDispatcher.views` iterable 항목을 통해 사용할 수 있습니다. 이러한 뷰는 [type `FlutterView`][]입니다.

각 `FlutterView`에 콘텐츠를 렌더링하려면, Flutter 앱에서 [`View` 위젯][`View` widget]을 만들어야 합니다.
`View` 위젯은 [`ViewCollection` 위젯][`ViewCollection` widget] 아래에 그룹화할 수 있습니다.

_Multi View Playground_ 의 다음 예제는 앱의 루트 위젯으로 사용할 수 있는 `MultiViewApp` 위젯에 위의 내용을 캡슐화합니다. 
각 `FlutterView`에 대해, [`WidgetBuilder` 함수][`WidgetBuilder` function]가 실행됩니다.

```dart highlightLines=25,39,46-49,56-61,72
// multi_view_app.dart

// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show FlutterView;
import 'package:flutter/widgets.dart';

/// 앱에 추가된 모든 뷰에 대해 [viewBuilder]를 호출하여, 해당 뷰에 렌더링할 위젯을 얻습니다. 
/// 현재 뷰는 [View.of]로 조회할 수 있습니다.
class MultiViewApp extends StatefulWidget {
  const MultiViewApp({super.key, required this.viewBuilder});

  final WidgetBuilder viewBuilder;

  @override
  State<MultiViewApp> createState() => _MultiViewAppState();
}

class _MultiViewAppState extends State<MultiViewApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _updateViews();
  }

  @override
  void didUpdateWidget(MultiViewApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 모든 뷰에 대해 viewBuilder 콜백을 다시 평가해야 합니다.
    _views.clear();
    _updateViews();
  }

  @override
  void didChangeMetrics() {
    _updateViews();
  }

  Map<Object, Widget> _views = <Object, Widget>{};

  void _updateViews() {
    final Map<Object, Widget> newViews = <Object, Widget>{};
    for (final FlutterView view in WidgetsBinding.instance.platformDispatcher.views) {
      final Widget viewWidget = _views[view.viewId] ?? _createViewWidget(view);
      newViews[view.viewId] = viewWidget;
    }
    setState(() {
      _views = newViews;
    });
  }

  Widget _createViewWidget(FlutterView view) {
    return View(
      view: view,
      child: Builder(
        builder: widget.viewBuilder,
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewCollection(views: _views.values.toList(growable: false));
  }
}
```

자세한 내용은 API 문서의 [`WidgetsBinding` mixin][]이나 개발 중에 사용된 [Multi View Playground repo][]를 확인하세요.

[`didChangeMetrics` method]: {{site.api}}/flutter/widgets/WidgetsBindingObserver/didChangeMetrics.html
[Multi View Playground repo]: {{site.github}}/goderbauer/mvp
[type `FlutterView`]: {{site.api}}/flutter/dart-ui/FlutterView-class.html
[`View` widget]: {{site.api}}/flutter/widgets/View-class.html
[`ViewCollection` widget]: {{site.api}}/flutter/widgets/ViewCollection-class.html
[`WidgetsBinding` mixin]: {{site.api}}/flutter/widgets/WidgetsBinding-mixin.html
[`WidgetBuilder` function]: {{site.api}}/flutter/widgets/WidgetBuilder.html

### 뷰 식별 {:#identifying-views}

각 `FlutterView`에는 첨부될 때 Flutter가 할당한 식별자가 있습니다. 
이 `viewId`는 각 뷰를 고유하게 식별하고, 초기 구성을 검색하거나, 
무엇을 렌더링할지 결정하는 데 사용할 수 있습니다.

렌더링된 `FlutterView`의 `viewId`는 다음과 같이 `BuildContext`에서 검색할 수 있습니다.

```dart highlightLines=4-5
class SomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 이 위젯이 빌드되는 `viewId`를 검색합니다.
    final int viewId = View.of(context).viewId;
    // ...
```

[`View.of` 생성자][`View.of` constructor]에 대해 자세히 알아보세요.

[`View.of` constructor]: {{site.api}}/flutter/widgets/View/of.html

### 초기 뷰 구성 {:#initial-view-configuration}

Flutter 뷰는 시작할 때 JS에서 모든 초기화 데이터를 받을 수 있습니다. 
값은 다음과 같이 `addView` 메서드의 `initialData` 속성을 통해 전달됩니다.

```js highlightLines=4-7
// 초기 데이터가 있는 뷰를 추가합니다...
let viewId = app.addView({
  hostElement: someElement,
  initialData: {
    greeting: 'Hello, world!',
    randomValue: Math.floor(Math.random() * 100),
  }
});
```

Dart에서 `initialData`는 `dart:ui_web` 라이브러리의 최상위 `views` 속성을 통해 액세스할 수 있는
`JSAny` 객체로 제공됩니다. 
데이터는 다음과 같이 현재 뷰의 `viewId`를 통해 액세스합니다.

```dart
final initialData = ui_web.views.getInitialData(viewId) as YourJsInteropType;
```

Dart 프로그램에서 JS에서 전달된 `initialData` 객체를 타입 안전하게 매핑하기 위해, 
`YourJsInteropType` 클래스를 정의하는 방법을 알아보려면, 
dart.dev의 [JS 상호 운용성][JS Interoperability]을 확인하세요.

[JS Interoperability]: {{site.dart-site}}/interop/js-interop

### 뷰 제약조건 {:#view-constraints}

기본적으로, 임베디드 Flutter 웹 뷰는 `hostElement`의 크기를 불변(immutable) 속성으로 간주하고, 
레이아웃을 사용 가능한 공간으로 엄격하게 제한합니다.

웹에서, 요소의 내재적 크기가 페이지의 레이아웃에 영향을 미치는 것은 일반적입니다.
(예를 들어, 콘텐츠를 그 주위로 리플로우할 수 있는 `img` 또는 `p` 태그)

Flutter 웹에 뷰를 추가할 때, Flutter에 뷰를 어떻게 배치해야 하는지 알려주는 제약 조건으로 뷰를 구성할 수 있습니다.

```js highlightLines=4-8
// 초기 데이터가 있는 뷰를 추가합니다...
let viewId = app.addView({
  hostElement: someElement,
  viewConstraints: {
    maxWidth: 320,
    minHeight: 0,
    maxHeight: Infinity,
  }
});
```

JS에서 전달된 뷰 제약 조건은 Flutter가 임베드되는 `hostElement`의 CSS 스타일과 호환되어야 합니다. 
예를 들어, Flutter는 CSS에서 `max-height: 100px`를 전달하는 것과 같은 모순되는 상수를 "수정"하려고 하지 않지만,
Flutter에 `maxHeight: Infinity`를 전달하려고 합니다.

자세한 내용은 [`ViewConstraints` 클래스][`ViewConstraints` class] 및 [제약 조건 이해][Understanding constraints]를 확인하세요.

[`ViewConstraints` class]: {{site.api}}/flutter/dart-ui/ViewConstraints-class.html
[Understanding constraints]: {{site.docs}}/ui/layout/constraints

## 커스텀 요소 (`hostElement`) {:#custom-element-hostelement}

_Flutter 3.10과 3.24 사이_<br />
단일 뷰 Flutter 웹 앱을 웹 페이지의 모든 HTML 요소에 임베드할 수 있습니다.

Flutter 웹에 어떤 요소에 렌더링할지 알려주려면, 
`config` 필드가 있는 객체를 `_flutter.loader.load` 함수에 전달하여, 
`HTMLElement`를 `hostElement`로 지정합니다.

```js highlightLines=3
_flutter.loader.load({
  config: {
    hostElement: document.getElementById('flutter_host'),
  }
});
```

다른 구성 옵션에 대해 자세히 알아보려면,
[웹 앱 초기화 커스터마이즈][Customizing web app initialization]를 확인하세요.

:::version-note
`hostElement`를 지정하는 이 방법은 위에서 설명한 **Embedded 모드**로 대체되었습니다. 
**이 모드로 마이그레이션하는 것을 고려해 주세요**. 
이전 Flutter 버전에서 `hostElement`를 구성하는 방법을 알아보려면, [레거시 웹 앱 초기화][Legacy web app initialization]를 참조하세요.
:::

[Customizing web app initialization]: {{site.docs}}/platform-integration/web/initialization
[Legacy web app initialization]: {{site.docs}}/platform-integration/web/initialization-legacy
