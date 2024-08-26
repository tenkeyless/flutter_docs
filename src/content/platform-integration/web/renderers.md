---
# title: Web renderers
title: 웹 렌더러
# description: How to choose a web renderer for running and building a web app.
description: 웹 앱을 실행하고 구축하기 위한 웹 렌더러를 선택하는 방법.
---

웹용 앱을 실행하고 빌드할 때, 두 가지 다른 렌더러 중에서 선택할 수 있습니다. 
이 페이지에서는 두 렌더러와 필요에 가장 적합한 렌더러를 선택하는 방법을 설명합니다. 
두 렌더러는 다음과 같습니다.

**CanvasKit 렌더러**
: 이 렌더러는 Flutter 모바일 및 데스크톱과 완벽하게 일치하며, 
  더 높은 위젯 밀도로 더 빠른 성능을 제공하지만, 다운로드 크기가 약 1.5MB 추가됩니다. 
  [CanvasKit][canvaskit]은 WebGL을 사용하여 Skia 페인트 명령을 렌더링합니다.

**HTML 렌더러**
: CanvasKit 렌더러보다 다운로드 크기가 작은 이 렌더러는, 
  HTML 요소, CSS, Canvas 요소 및 SVG 요소를 조합하여 사용합니다.

## 명령줄 옵션 {:#command-line-options}

The `--web-renderer` command line option takes one of three values:
`canvaskit`, `html`, or `auto`.

* `canvaskit` (default) - always use the CanvasKit renderer
* `html` - always use the HTML renderer
* `auto` - automatically chooses which renderer to use. This option
    chooses the HTML renderer when the app is running in a mobile browser, and
    CanvasKit renderer when the app is running in a desktop browser.

This flag can be used with the `run` or `build` subcommands. For example:

```console
flutter run -d chrome --web-renderer html
```

```console
flutter build web --web-renderer canvaskit
```

This flag is ignored when a non-browser (mobile or desktop) device
target is selected.

## 런타임 구성 {:#runtime-configuration}

To override the web renderer at runtime:

 1. Build the app with the `auto` option.
 1. Set up custom web app initialization
    as described in [Write a custom `flutter_bootstrap.js`][custom-bootstrap].
 1. Prepare a configuration object with the `renderer` property set to
    `"canvaskit"` or `"html"`.
 1. Pass your prepared config object as the `config` property of
    a new object to the `_flutter.loader.load` method that is
    provided by the earlier injected code.

```html highlightLines=9-14
<body>
  <script>
    {% raw %}{{flutter_js}}{% endraw %}
    {% raw %}{{flutter_build_config}}{% endraw %}

    // TODO: Replace this with your own code to determine which renderer to use.  
    const useHtml = true;
  
    const config = {
      renderer: useHtml ? "html" : "canvaskit",
    };
    _flutter.loader.load({
      config: config,
    });
  </script>
</body>
```

The web renderer can't be changed after the Flutter engine startup process
begins in `main.dart.js`.

:::version-note
The method of specifying the web renderer was changed in Flutter 3.22.
To learn how to configure the renderer in earlier Flutter versions,
check out [Legacy web app initialization][web-init-legacy].
:::

[custom-bootstrap]: /platform-integration/web/initialization#custom-bootstrap-js
[customizing-web-init]: /platform-integration/web/initialization
[web-init-legacy]: /platform-integration/web/initialization-legacy

## 사용할 옵션 선택 {:#choosing-which-option-to-use}

Choose the `canvaskit` option (default) if you are prioritizing performance and
pixel-perfect consistency on both desktop and mobile browsers.

Choose the `html` option if you are optimizing download size over performance on
both desktop and mobile browsers.

Choose the `auto` option if you are optimizing for download size on
mobile browsers and optimizing for performance on desktop browsers.

## 예제 {:#examples}

Run in Chrome using the default renderer option (`canvaskit`):

```console
flutter run -d chrome
```

Build your app in release mode, using the default (`canvaskit`) option:

```console
flutter build web --release
```

Build your app in release mode, using the `auto` renderer option:

```console
flutter build web --web-renderer auto --release
```

Run your app in profile mode using the HTML renderer:

```console
flutter run -d chrome --web-renderer html --profile
```

[canvaskit]: https://skia.org/docs/user/modules/canvaskit/
[file an issue]: {{site.repo.flutter}}/issues/new?title=[web]:+%3Cdescribe+issue+here%3E&labels=%E2%98%B8+platform-web&body=Describe+your+issue+and+include+the+command+you%27re+running,+flutter_web%20version,+browser+version
