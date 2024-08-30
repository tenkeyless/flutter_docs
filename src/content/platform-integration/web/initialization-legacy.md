---
# title: Customizing web app initialization
title: 웹 앱 초기화 커스터마이즈
# description: Customize how Flutter apps are initialized on the web.
description: Flutter 앱이 웹에서 초기화되는 방식을 커스터마이즈합니다.
---

:::note
이 페이지에서는 Flutter 3.21 또는 이전 버전에서 사용 가능한 API를 설명합니다. 
Flutter 3.22 이상에서 웹 앱 초기화를 구성하려면, 새로운 [Flutter 웹 앱 초기화][Flutter web app initialization] 문서를 확인하세요.
:::

[`stable`]: {{site.github}}/flutter/flutter/blob/master/docs/releases/Flutter-build-release-channels.md#stable
[Flutter web app initialization]: /platform-integration/web/initialization

`flutter.js`에서 제공하는 `_flutter.loader` JavaScript API를 사용하여, 
웹에서 Flutter 앱이 초기화되는 방식을 커스터마이즈할 수 있습니다. 
이 API는 CSS에서 로딩 표시기를 표시하거나, 조건에 따라 앱이 로드되는 것을 방지하거나, 
사용자가 버튼을 누를 때까지 기다렸다가 앱을 표시하는 데 사용할 수 있습니다.

초기화 프로세스는 다음 단계로 나뉩니다.

**진입점 스토리 로딩**
: `main.dart.js` 스크립트를 가져오고, 서비스 워커를 초기화합니다.

**Flutter 엔진 초기화**
: assets, 글꼴, CanvasKit과 같은 필수 리소스를 다운로드하여, Flutter 웹 엔진을 초기화합니다.

**앱 실행**
: Flutter 앱의 DOM을 준비하고 실행합니다.

이 페이지에서는 초기화 프로세스의 각 단계에서 동작을 커스터마이즈 하는 방법을 보여줍니다.

## 시작하기 {:#getting-started}

기본적으로, `flutter create` 명령으로 생성된 `index.html` 파일에는 `flutter.js` 파일에서 
`loadEntrypoint`를 호출하는 스크립트 태그가 포함되어 있습니다.

```html
<html>
  <head>
    <!-- ... -->
    <script src="flutter.js" defer></script>
  </head>
  <body>
    <script>
      window.addEventListener('load', function (ev) {
        // main.dart.js 다운로드
        _flutter.loader.loadEntrypoint({
          serviceWorker: {
            serviceWorkerVersion: serviceWorkerVersion,
          },
          onEntrypointLoaded: async function(engineInitializer) {
            // Flutter 엔진 초기화
            let appRunner = await engineInitializer.initializeEngine();
            // 앱 실행
            await appRunner.runApp();
          }
        });
      });
    </script>
  </body>
</html>
```

:::note
Flutter 2.10 이하에서는 이 스크립트가 커스터마이즈를 지원하지 않습니다. 
`index.html` 파일을 최신 버전으로 업그레이드하려면, 
[이전 프로젝트 업그레이드](#upgrading-an-older-project)를 참조하세요.
:::

`loadEntrypoint` 함수는 Service Worker가 초기화되고 `main.dart.js` 진입점이 다운로드되어 브라우저에서 실행되면 `onEntrypointLoaded` 콜백을 호출합니다. 
Flutter는 또한 개발 중에 핫 재시작할 때마다, `onEntrypointLoaded`를 호출합니다.

`onEntrypointLoaded` 콜백은 유일한 매개변수로 **engine initializer** 객체를 받습니다. 
엔진 초기화자를 사용하여, 런타임 구성을 설정하고 Flutter 웹 엔진을 시작합니다.

`initializeEngine()` 함수는 **app runner** 객체로 해결되는 [`Promise`][js-promise]를 반환합니다. 
앱 러너에는 Flutter 앱을 실행하는 단일 메서드인 `runApp()`가 있습니다.

[js-promise]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise

## 웹 앱 초기화 커스터마이즈 {:#customizing-web-app-initialization}

이 섹션에서는, 앱 초기화의 각 단계를 커스터마이즈 하는 방법을 알아봅니다.

### 진입점 로딩 {:#loading-the-entrypoint}

`loadEntrypoint` 메서드는 다음과 같은 매개변수를 허용합니다.

| 이름 | 설명 | JS&nbsp;타입 |
|-|-|-|
|`entrypointUrl`| Flutter 앱의 진입점 URL입니다. 기본값은 `"main.dart.js"`입니다. |`String`|
|`onEntrypointLoaded`| 엔진이 초기화될 준비가 되면 호출되는 함수입니다. 유일한 매개변수로 `engineInitializer` 객체를 받습니다.  |`Function`|
|`serviceWorker`| `flutter_service_worker.js` 로더에 대한 구성입니다. (설정하지 않으면 서비스 워커가 사용되지 않습니다.)  |`Object`|

{:.table}

`serviceWorker` JavaScript 객체는 다음 속성을 허용합니다.

| 이름 | 설명 | JS&nbsp;타입 |
|-|-|-|
|`serviceWorkerUrl`| Service Worker JS 파일의 URL입니다. `serviceWorkerVersion`이 URL에 추가됩니다. 기본값은 `"flutter_service_worker.js?v="`입니다.  |`String`|
|`serviceWorkerVersion`| 빌드 프로세스에서 설정한 *`serviceWorkerVersion` 변수*를 **`index.html`** 파일에 전달합니다. |`String`|
|`timeoutMillis`| 서비스 워커 로드에 대한 타임아웃 값입니다. 기본값은 `4000`입니다. |`Number`|

{:.table}

### 엔진 초기화 {:#initializing-the-engine}

_Flutter 3.7.0_ 부터 `initializeEngine` 메서드를 사용하여, 
일반 JavaScript 객체를 통해 Flutter 웹 엔진의 여러 런타임 옵션을 구성할 수 있습니다.

다음 선택적 매개변수를 추가할 수 있습니다.

| 이름 | 설명 | Dart&nbsp;타입 |
|-|-|-|
|`assetBase`| 앱의 `assets` 디렉토리의 베이스 URL입니다. Flutter가 실제 웹 앱과 다른 도메인이나 하위 디렉토리에서 로드될 때 이것을 추가합니다. Flutter 웹을 다른 앱에 임베드하거나 자산을 CDN에 배포할 때 이것이 필요할 수 있습니다.  |`String`|
|`canvasKitBaseUrl`| `canvaskit.wasm`이 다운로드되는 베이스 URL입니다. |`String`|
|`canvasKitVariant`| 다운로드할 CanvasKit 변형. 옵션은 다음과 같습니다.<br><br>1. `auto`: 브라우저에 가장 적합한 변형을 다운로드합니다. 이 옵션은 기본적으로 이 값으로 설정됩니다.<br>2. `full`: 모든 브라우저에서 작동하는 CanvasKit의 전체 변형을 다운로드합니다.<br>3. `chromium`: Chromium 호환 API를 사용하는 더 작은 CanvasKit 변형을 다운로드합니다. **_경고_**: Chromium 기반 브라우저만 사용할 계획이 아니라면 `chromium` 옵션을 사용하지 마세요. |`String`|
|`canvasKitForceCpuOnly`| `true`로 설정하면 CanvasKit에서 CPU만 사용하여 렌더링합니다. (엔진은 WebGL을 사용하지 않습니다) |`bool`|
|`canvasKitMaximumSurfaces`| CanvasKit 렌더러가 사용할 수 있는 오버레이 표면의 최대 수입니다. |`double`|
|`debugShowSemanticNodes`| `true`이면 Flutter는 디버깅을 위해 의미 트리를 화면에 시각적으로 렌더링합니다.  |`bool`|
|`hostElement`| Flutter가 앱을 렌더링하는 HTML 요소입니다. 설정하지 않으면 Flutter 웹이 전체 페이지를 차지합니다. |`HtmlElement`|
|`renderer`| 현재 Flutter 애플리케이션의 [웹 렌더러][web-renderers]를 `"canvaskit"` 또는 `"skwasm"`로 지정합니다. |`String`|

{:.table}

[jsflutterconfig-source]: {{site.repo.engine}}/blob/main/lib/web_ui/lib/src/engine/configuration.dart#L247-L259
[web-renderers]: /platform-integration/web/renderers

:::note
위에서 설명한 일부 매개변수는 이전 릴리스에서 `window` 객체의 속성을 사용하여 재정의되었을 수 있습니다. 
이 접근 방식은 여전히 ​​지원되지만, **Flutter 3.7.0**부터 JS 콘솔에 **deprecation 알림**이 표시됩니다.
:::

#### 엔진 구성 예제 {:#engine-configuration-example}

`initializeEngine` 메서드를 사용하면, 위에서 설명한 구성 매개변수를 Flutter 앱에 전달할 수 있습니다.

다음 예를 고려해 보세요.

Flutter 앱은 `id="flutter_app"`를 사용하여 HTML 요소를 대상으로 하고, 
`canvaskit` 렌더러를 사용해야 합니다. 
결과 JavaScript 코드는 다음과 유사합니다.

```js
onEntrypointLoaded: async function(engineInitializer) {
  let appRunner = await engineInitializer.initializeEngine({
    hostElement: document.querySelector("#flutter_app"),
    renderer: "canvaskit"
  });
  appRunner.runApp();
}
```

각 매개변수에 대한 더 자세한 설명은, 
웹 엔진의 [`configuration.dart`][config-dart] 파일의 **"Runtime parameters"** 문서 섹션을 참조하세요.

[config-dart]: {{site.repo.engine}}/blob/main/lib/web_ui/lib/src/engine/configuration.dart#L174

#### 이 단계 건너뛰기 {:#skipping-this-step}

엔진 initializer에서 `initializeEngine()`를 호출한 다음, 
애플리케이션 실행기에서 `runApp()`를 호출하는 대신, 
`autoStart()`를 호출하여 기본 구성으로 엔진을 초기화한 다음, 
초기화가 완료된 직후에 앱을 시작할 수 있습니다.

```js
_flutter.loader.loadEntrypoint({
  serviceWorker: {
    serviceWorkerVersion: serviceWorkerVersion,
  },
  onEntrypointLoaded: async function(engineInitializer) {
    await engineInitializer.autoStart();
  }
});
```

## 예제: 진행률 표시기 표시 {:#example-display-a-progress-indicator}

초기화 프로세스 중에 애플리케이션 사용자에게 피드백을 제공하려면, 
각 단계에 제공된 후크를 사용하여 DOM을 업데이트하세요.

```html
<html>
  <head>
    <!-- ... -->
    <script src="flutter.js" defer></script>
  </head>
  <body>
    <div id="loading"></div>
    <script>
      window.addEventListener('load', function(ev) {
        var loading = document.querySelector('#loading');
        loading.textContent = "Loading entrypoint...";
        _flutter.loader.loadEntrypoint({
          serviceWorker: {
            serviceWorkerVersion: serviceWorkerVersion,
          },
          onEntrypointLoaded: async function(engineInitializer) {
            loading.textContent = "Initializing engine...";
            let appRunner = await engineInitializer.initializeEngine();

            loading.textContent = "Running app...";
            await appRunner.runApp();
          }
        });
      });
    </script>
  </body>
</html>
```

CSS 애니메이션을 사용한 보다 실용적인 예를 보려면, 
Flutter Gallery의 [초기화 코드][gallery-init]를 참조하세요.

[gallery-init]: {{site.repo.gallery-archive}}/blob/main/web/index.html

## 이전 프로젝트 업그레이드 {:#upgrading-an-older-project}

프로젝트가 Flutter 2.10 또는 이전 버전에서 생성된 경우, 
다음과 같이 `flutter create`를 실행하여, 
최신 초기화 템플릿으로 새 `index.html` 파일을 만들 수 있습니다.

먼저 `/web` 디렉터리에서 파일을 제거합니다.

그런 다음 프로젝트 디렉터리에서 다음을 실행합니다.

```console
$ flutter create . --platforms=web
```
