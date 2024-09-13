---
# title: Flutter web app initialization
title: Flutter 웹 앱 초기화
# description: Customize how Flutter apps are initialized on the web.
description: Flutter 앱이 웹에서 초기화되는 방식을 커스터마이즈합니다.
---

:::note
이 페이지에서는 Flutter 3.22 이상에서 사용 가능한 API를 설명합니다. 
Flutter 3.21 이하에서 웹 앱 초기화를 커스터마이즈하려면, 
이전 [웹 앱 초기화 커스터마이즈][Customizing web app initialization] 문서를 확인하세요.
:::

[Customizing web app initialization]: /platform-integration/web/initialization-legacy

이 페이지에서는 Flutter 웹 앱의 초기화 프로세스와 이 프로세스를 커스터마이즈하는 방법을 자세히 설명합니다.

## `flutter_bootstrap.js` {:#flutter_bootstrap-js}

Flutter 앱을 빌드할 때, `flutter build web` 명령은 빌드 출력 디렉토리(`build/web`)에 
`flutter_bootstrap.js`라는 스크립트를 생성합니다. 
이 파일에는 Flutter 앱을 초기화하고 실행하는 데 필요한 JavaScript 코드가 들어 있습니다. 
Flutter 앱의 `web` 하위 디렉토리에 있는 `index.html` 파일에, 
async-script 태그를 배치하여 이 스크립트를 사용할 수 있습니다.

```html highlightLines=3
<html>
  <body>
    <script src="flutter_bootstrap.js" async></script>
  </body>
</html>
```

또는, `index.html` 파일에 템플릿 토큰 `{% raw %}{{flutter_bootstrap_js}}{% endraw %}`를 삽입하여, 
`flutter_bootstrap.js` 파일의 전체 내용을 인라인으로 추가할 수 있습니다.

```html highlightLines=4
<html>
  <body>
    <script>
      {% raw %}{{flutter_bootstrap_js}}{% endraw %}
    </script>
  </body>
</html>
```

빌드 단계에서 `index.html` 파일이 출력 디렉토리(`build/web`)에 복사되면, 
`{% raw %}{{flutter_bootstrap_js}}{% endraw %}` 토큰이 
`flutter_bootstrap.js` 파일의 내용으로 대체됩니다.

<a id="customizing-initialization" aria-hidden="true"></a>

## 초기화 커스터마이즈 {:#customize-initialization}

기본적으로, `flutter build web`은 Flutter 앱을 간단하게 초기화하는 `flutter_bootstrap.js` 파일을 생성합니다. 
그러나, 일부 시나리오에서는, 다음과 같이 이 초기화 프로세스를 커스터마이즈 해야 할 수 있습니다.

* 앱에 대한 커스텀 Flutter 구성 설정.
* Flutter 서비스 워커에 대한 설정 변경.
* 시작 프로세스의 여러 단계에서 실행될 커스텀 JavaScript 코드 작성.

빌드 단계에서 생성된 기본 스크립트를 사용하는 대신, 커스텀 부트스트래핑 로직을 작성하려면, 
프로젝트의 `web` 하위 디렉터리에 `flutter_bootstrap.js` 파일을 배치하면 됩니다. 
이 파일은 복사되어 빌드에서 생성된 기본 스크립트 대신 사용됩니다. 
이 파일도 템플릿화되어 있으며, `flutter_bootstrap.js` 파일을 출력 디렉터리에 복사할 때, 
빌드 단계에서 대체하는 여러 특수 토큰을 삽입할 수 있습니다. 
다음 표에는 빌드 단계에서 `flutter_bootstrap.js` 또는 `index.html` 파일에서 대체하는 토큰이 나와 있습니다.

| 토큰 | 다음으로 대체 |
|---|---|
| `{% raw %}{{flutter_js}}{% endraw %}` | `_flutter.loader` 전역 변수에서 `FlutterLoader` 객체를 사용할 수 있게 하는 JavaScript 코드입니다. (자세한 내용은 아래의 `_flutter.loader.load() API` 섹션을 참조하세요.) |
| `{% raw %}{{flutter_build_config}}{% endraw %}` | `FlutterLoader`에 애플리케이션을 올바르게 부트스트랩하는 데 필요한 정보를 제공하는 빌드 프로세스에서 생성된 메타데이터를 설정하는 JavaScript 명령문입니다. |
| `{% raw %}{{flutter_service_worker_version}}{% endraw %}` | 서비스 워커의 빌드 버전을 나타내는 고유 번호입니다. 서비스 워커 구성의 일부로 전달될 수 있습니다. (아래의 "서비스 워커 설정" 표 참조) |
| `{% raw %}{{flutter_bootstrap_js}}{% endraw %}` | 위에서 언급했듯이, 이것은 `flutter_bootstrap.js` 파일의 내용을 `index.html` 파일에 직접 인라인합니다. 이 토큰은 `index.html`에서만 사용할 수 있으며, `flutter_bootstrap.js` 파일 자체에서는 사용할 수 없습니다. |

{:.table}

<a id="write-a-custom-flutter_bootstrap-js" aria-hidden="true"></a>

## 커스텀 `flutter_bootstrap.js` 작성 {:#custom-bootstrap-js}

모든 커스텀 `flutter_bootstrap.js` 스크립트는 Flutter 앱을 성공적으로 시작하기 위해, 
세 가지 구성 요소가 있어야 합니다.

* `_flutter.loader`를 사용할 수 있도록 하는 `{% raw %}{{flutter_js}}{% endraw %}` 토큰.
* 앱을 시작하는 데 필요한 `FlutterLoader`에 빌드에 대한 정보를 제공하는 `{% raw %}{{flutter_build_config}}{% endraw %}` 토큰.
* 실제로 앱을 시작하는 `_flutter.loader.load()` 호출.

가장 기본적인 `flutter_bootstrap.js` 파일은 다음과 같습니다.

```js
{% raw %}{{flutter_js}}{% endraw %}
{% raw %}{{flutter_build_config}}{% endraw %}

_flutter.loader.load();
```

## `_flutter.loader.load()` API {:#the-_flutter-loader-load-api}

`_flutter.loader.load()` JavaScript API는 선택적 인수와 함께 호출하여, 
초기화 동작을 커스터마이즈 할 수 있습니다.

| 이름                    | 설명                                                                                                                   | JS&nbsp;타입 |
|-------------------------|-------------------------------------------------------------------------------------------------------------------------------|--------------|
| `config`                | 앱의 Flutter 구성.                                                                                        | `Object`     |
| `onEntrypointLoaded`    | 엔진이 초기화될 준비가 되면 호출되는 함수입니다. 유일한 매개변수로 `engineInitializer` 객체를 받습니다. | `Function`   |
| `serviceWorkerSettings` | `flutter_service_worker.js` 로더에 대한 구성입니다. (설정하지 않으면 서비스 워커가 사용되지 않습니다.)                   | `Object`     |

{:.table}

`config` 인수는 다음과 같은 선택적 필드를 가질 수 있는 객체입니다.

| 이름 | 설명 | Dart&nbsp;타입 |
|---|---|---|
|`assetBase`| 앱의 `assets` 디렉토리의 기본 URL입니다. Flutter가 실제 웹 앱과 다른 도메인이나 하위 디렉토리에서 로드될 때 이것을 추가합니다. Flutter 웹을 다른 앱에 임베드하거나, assets을 CDN에 배포할 때 이것이 필요할 수 있습니다. |`String`|
|`canvasKitBaseUrl`| `canvaskit.wasm`이 다운로드되는 베이스 URL입니다. |`String`|
|`canvasKitVariant`| 다운로드할 CanvasKit 변형. 옵션은 다음과 같습니다.<br><br>1. `auto`: 브라우저에 가장 적합한 변형을 다운로드합니다. 이 옵션은 기본적으로 이 값으로 설정됩니다.<br>2. `full`: 모든 브라우저에서 작동하는 CanvasKit의 전체 변형을 다운로드합니다.<br>3. `chromium`: Chromium 호환 API를 사용하는 더 작은 CanvasKit 변형을 다운로드합니다. **_경고_**: Chromium 기반 브라우저만 사용할 계획이 아니라면, `chromium` 옵션을 사용하지 마세요. |`String`|
|`canvasKitForceCpuOnly`| `true`로 설정하면, CanvasKit에서 CPU만 사용하여 렌더링합니다. (엔진은 WebGL을 사용하지 않습니다) |`bool`|
|`canvasKitMaximumSurfaces`| CanvasKit 렌더러가 사용할 수 있는 오버레이 표면의 최대 수입니다. |`double`|
|`debugShowSemanticNodes`| `true`이면 Flutter는 (디버깅을 위해) 시맨틱 트리를 화면에 시각적으로 렌더링합니다.  |`bool`|
|`entryPointBaseUrl`| Flutter 앱의 진입점의 베이스 URL입니다. 기본값은 "/"입니다. |`String`|
|`hostElement`| Flutter가 앱을 렌더링하는 HTML 요소입니다. 설정하지 않으면 Flutter 웹이 전체 페이지를 차지합니다. |`HtmlElement`|
|`renderer`| 현재 Flutter 애플리케이션의 [웹 렌더러][web-renderers]를 `"canvaskit"` 또는 `"skwasm"`로 지정합니다. |`String`|

{:.table}

[web-renderers]: /platform-integration/web/renderers

`serviceWorkerSettings` 인수에는 다음과 같은 선택적 필드가 있습니다.

| 이름                   | 설명    | JS&nbsp;타입 |
|------------------------|-----------------------------------------------------------------------------------------------------------------------------------------|--------------|
| `serviceWorkerUrl`     | Service Worker JS 파일의 URL입니다. `serviceWorkerVersion`이 URL에 추가됩니다. 기본값은 `"flutter_service_worker.js?v="`입니다. | `String`     |
| `serviceWorkerVersion` | 빌드 프로세스에서 설정한 *`serviceWorkerVersion` 변수*를 **`index.html`** 파일에 전달합니다. | `String`     |
| `timeoutMillis`        | 서비스 워커 로드에 대한 타임아웃 값입니다. 기본값은 `4000`입니다. | `Number`     |

{:.table}

## 예: URL 쿼리 매개변수를 기반으로 Flutter 구성 커스터마이즈 {:#example-customizing-flutter-configuration-based-on-url-query-parameters}

다음 예제는 사용자가 웹사이트 URL에 `?renderer=skwasm`과 같은 `renderer` 쿼리 매개변수를 제공하여 렌더러를 선택할 수 있도록 하는 커스텀 `flutter_bootstrap.js`를 보여줍니다.

```js
{% raw %}{{flutter_js}}{% endraw %}
{% raw %}{{flutter_build_config}}{% endraw %}

const searchParams = new URLSearchParams(window.location.search);
const renderer = searchParams.get('renderer');
const userConfig = renderer ? {'renderer': renderer} : {};
_flutter.loader.load({
  config: userConfig,
  serviceWorkerSettings: {
    serviceWorkerVersion: {% raw %}{{flutter_service_worker_version}}{% endraw %},
  },
});
```

이 스크립트는 페이지의 `URLSearchParams`를 평가하여, 
사용자가 `renderer` 쿼리 매개변수를 전달했는지 확인한 다음, 
Flutter 앱의 사용자 구성을 변경합니다. 
또한 서비스 워커 버전과 함께 Flutter 서비스 워커를 사용하도록, 서비스 워커 설정을 전달합니다.

## `onEntrypointLoaded` 콜백 {:#the-onentrypointloaded-callback}

초기화 프로세스의 다른 부분에서 커스텀 로직을 수행하기 위해, 
`onEntrypointLoaded` 콜백을 `load` API에 전달할 수도 있습니다. 
초기화 프로세스는 다음 단계로 나뉩니다.

**진입점 스크립트 로드**
: `load` 함수는 서비스 워커가 초기화되고, `main.dart.js` 진입점이 다운로드되어, 
  브라우저에서 실행되면 `onEntrypointLoaded` 콜백을 호출합니다. 
  Flutter는 또한 개발 중에 핫 재시작할 때마다 `onEntrypointLoaded`를 호출합니다.

**Flutter 엔진 초기화**
: `onEntrypointLoaded` 콜백은 유일한 매개변수로 **engine initializer** 객체를 받습니다. 
  엔진 초기화자 `initializeEngine()` 함수를 사용하여, 
  `multiViewEnabled: true`와 같은 런타임 구성을 설정하고 Flutter 웹 엔진을 시작합니다.

**앱 실행**
: `initializeEngine()` 함수는 **app runner** 객체로 해결되는 [`Promise`][js-promise]를 반환합니다. 
  앱 러너에는 Flutter 앱을 실행하는 단일 메서드인 `runApp()`가 있습니다.

**앱에 뷰 추가(또는 뷰 제거)**
: `runApp()` 메서드는 **Flutter 앱** 객체를 반환합니다. 
  다중 뷰 모드에서 `addView` 및 `removeView` 메서드를 사용하여, 
  호스트 앱에서 앱 뷰를 관리할 수 있습니다. 
  자세한 내용은 [임베디드 모드][embedded-mode]를 확인하세요.

[embedded-mode]: {{site.docs}}/platform-integration/web/embedding-flutter-web/#embedded-mode
[js-promise]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise

## 예: 진행률 표시기 표시 {:#example-display-a-progress-indicator}

초기화 프로세스 중에 애플리케이션 사용자에게 피드백을 제공하려면, 
각 단계에 제공된 후크를 사용하여 DOM을 업데이트하세요.

```js
{% raw %}{{flutter_js}}{% endraw %}
{% raw %}{{flutter_build_config}}{% endraw %}

const loading = document.createElement('div');
document.body.appendChild(loading);
loading.textContent = "Loading Entrypoint...";
_flutter.loader.load({
  onEntrypointLoaded: async function(engineInitializer) {
    loading.textContent = "Initializing engine...";
    const appRunner = await engineInitializer.initializeEngine();

    loading.textContent = "Running app...";
    await appRunner.runApp();
  }
});
```

## 이전 프로젝트 업그레이드 {:#upgrade-an-older-project}

프로젝트가 Flutter 3.21 또는 이전 버전에서 생성된 경우, 
다음과 같이 `flutter create`를 실행하여, 
최신 초기화 템플릿으로 새 `index.html` 파일을 만들 수 있습니다.

먼저 `/web` 디렉터리에서 파일을 제거합니다.

그런 다음 프로젝트 디렉터리에서 다음을 실행합니다.

```console
$ flutter create . --platforms=web
```
