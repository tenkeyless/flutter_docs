---
# title: Embedding web content into a Flutter web app
title: Flutter 웹 앱에 웹 콘텐츠 임베드하기
# short-title: Web content in Flutter
short-title: Flutter의 웹 콘텐츠
# description: Learn how to load and display images on the web.
description: 웹에 이미지를 로드하고 표시하는 방법을 알아보세요.
---

어떤 경우에는, Flutter 웹 애플리케이션이 Flutter에서 렌더링되지 않은 웹 콘텐츠를 임베드해야 합니다. 
예를 들어, `google_maps_flutter` 뷰(Google Maps JavaScript SDK 사용) 또는 
`video_player`(표준 `video` 요소 사용)를 임베드합니다.

Flutter 웹은 `Widget`의 경계 내에서 임의의 웹 콘텐츠를 렌더링할 수 있으며, 
이전에 언급한 예제 패키지를 구현하는 데 사용된 primitives는, 
모든 Flutter 웹 애플리케이션에서 사용할 수 있습니다.

## `HtmlElementView` {:#htmlelementview}

`HtmlElementView` Flutter 위젯은 레이아웃에 공간을 예약하여 HTML Element로 채웁니다. 
여기에는 두 개의 생성자가 있습니다.

* `HtmlElementView.fromTagName`.
* `HtmlElementView` 및 `registerViewFactory`.

### `HtmlElementView.fromTagName` {:#htmlelementview-fromtagname}

[`HtmlElementView.fromTagName` 생성자][`HtmlElementView.fromTagName` constructor]는 `tagName`에서 HTML 요소를 생성하고, 
DOM에 삽입되기 전에 해당 요소를 구성하는 `onElementCreated` 메서드를 제공합니다.

```dart
// `video` 태그를 만들고, `src`와 일부 `style` 속성을 설정합니다.
HtmlElementView.fromTag('video', onElementCreated: (Object video) {
  video as web.HTMLVideoElement;
  video.src = 'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4';
  video.style.width = '100%';
  video.style.height = '100%';
  // 해당 요소에 대한 다른 커스터마이즈...
});
```

DOM API와 상호 작용하는 방법에 대해 자세히 알아보려면, 
[`package:web`][]의 [`HTMLVideoElement` 클래스][`HTMLVideoElement` class]를 확인하세요.

`web.HTMLVideoElement`로 캐스팅된 비디오 `Object`에 대해 자세히 알아보려면, 
Dart의 [JS Interoperability][JS Interoperability] 문서를 확인하세요.

[`HtmlElementView.fromTagName` constructor]: {{site.api}}/flutter/widgets/HtmlElementView/HtmlElementView.fromTagName.html
[`HTMLVideoElement` class]: {{site.pub}}/documentation/web/latest/web/HTMLVideoElement-extension-type.html
[`package:web`]: {{site.pub-pkg}}/web

### `HtmlElementView` and `registerViewFactory` {:#htmlelementview-and-registerviewfactory}

주입하는 HTML 코드를 생성하는 데 더 많은 제어가 필요한 경우, 
Flutter가 `fromTagName` 생성자를 구현하는 데 사용하는 primitives를 사용할 수 있습니다. 
이 시나리오에서는, 앱에 추가해야 하는 각 타입의 HTML 콘텐츠에 대해 고유한 HTML 요소 팩토리를 등록합니다.

결과 코드는 더 자세(verbose)하고, 플랫폼 뷰 타입당 두 단계가 있습니다.

1. `dart:ui_web`에서 제공하는 `platformViewRegistry.registerViewFactory`를 사용하여, 
   HTML 요소 팩토리를 등록합니다.
2. 앱의 위젯 트리에 `HtmlElementView('viewType')`를 사용하여, 
   원하는 `viewType`을 가진 위젯을 배치합니다.

이 접근 방식에 대한 자세한 내용은, [`HtmlElementView` 위젯][`HtmlElementView` widget] 문서를 확인하세요.

[`HtmlElementView` widget]: {{site.api}}/flutter/widgets/HtmlElementView-class.html

## `package:webview_flutter` {:#package-webview_flutter}

Flutter 앱에 전체 HTML 페이지를 내장하는 것은 매우 일반적인 기능이므로, 
Flutter 팀은 이를 수행하는 플러그인을 제공합니다.

* [`package:webview_flutter`][]

**not endorsed** 플러그인의 웹 구현인 [`package:webview_flutter_web`][]은, 
위에 설명된 동일한 primitives와 Dart의 [JS Interoperability][] API를 사용하여 구현됩니다.

[JS Interoperability]: {{site.dart-site}}/interop/js-interop
[`package:webview_flutter`]: {{site.pub}}/packages/webview_flutter
[`package:webview_flutter_web`]: {{site.pub}}/packages/webview_flutter_web
