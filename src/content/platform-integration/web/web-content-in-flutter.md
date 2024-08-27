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

The `HtmlElementView` Flutter widget reserves a space in the layout to be
filled with any HTML Element. It has two constructors:

* `HtmlElementView.fromTagName`.
* `HtmlElementView` and `registerViewFactory`.

### `HtmlElementView.fromTagName` {:#htmlelementview-fromtagname}

The [`HtmlElementView.fromTagName` constructor][] creates an HTML Element from
its `tagName`, and provides an `onElementCreated` method to configure that
element before it's injected into the DOM:

```dart
// Create a `video` tag, and set its `src` and some `style` properties...
HtmlElementView.fromTag('video', onElementCreated: (Object video) {
  video as web.HTMLVideoElement;
  video.src = 'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4';
  video.style.width = '100%';
  video.style.height = '100%';
  // other customizations to the element...
});
```

To learn more about the way to interact with DOM APIs,
check out the [`HTMLVideoElement` class] in [`package:web`][].

To learn more about the video `Object` that is cast to `web.HTMLVideoElement`,
check out Dart's [JS Interoperability][] documentation.

[`HtmlElementView.fromTagName` constructor]: {{site.api}}/flutter/widgets/HtmlElementView/HtmlElementView.fromTagName.html
[`HTMLVideoElement` class]: {{site.pub}}/documentation/web/latest/web/HTMLVideoElement-extension-type.html
[`package:web`]: {{site.pub-pkg}}/web

### `HtmlElementView` and `registerViewFactory` {:#htmlelementview-and-registerviewfactory}

If you need more control over generating the HTML code you inject, you can use
the primitives that Flutter uses to implement the `fromTagName` constructor. In
this scenario, register your own HTML Element factory for each type of HTML
content that needs to be added to your app.

The resulting code is more verbose, and has two steps per platform view type:

1. Register the HTML Element Factory using
`platformViewRegistry.registerViewFactory` provided by `dart:ui_web.`  
2. Place the widget with the desired `viewType`  with
`HtmlElementView('viewType')` in your app's widget tree.

For more details about this approach, check out
[`HtmlElementView` widget][] docs.

[`HtmlElementView` widget]: {{site.api}}/flutter/widgets/HtmlElementView-class.html

## `package:webview_flutter` {:#package-webview_flutter}

Embedding a full HTML page inside a Flutter app is such a common feature, that
the Flutter team offers a plugin to do so:

* [`package:webview_flutter`][]

The **not endorsed** web implementation of the plugin,
[`package:webview_flutter_web`][], is implemented with the same primitives
described above, and Dart's [JS Interoperability][] APIs.

[JS Interoperability]: {{site.dart-site}}/interop/js-interop
[`package:webview_flutter`]: {{site.pub}}/packages/webview_flutter
[`package:webview_flutter_web`]: {{site.pub}}/packages/webview_flutter_web
