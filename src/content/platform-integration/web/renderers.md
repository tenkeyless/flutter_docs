---
# title: Web renderers
title: 웹 렌더러
# description: Choosing build modes and renderers for a Flutter web app.
description: Flutter 웹 앱의 빌드 모드 및 렌더러 선택.
---

Flutter 웹은 두 가지 _빌드 모드_ 와 두 가지 _렌더러_ 를 제공합니다. 
빌드 모드는 앱을 빌드할 때 선택되며, 앱에서 사용할 수 있는 두 가지 렌더러와, 렌더러를 선택하는 방법을 결정합니다. 
렌더러는 앱이 시작될 때 런타임에 선택되며, UI를 렌더링하는 데 사용되는 웹 기술 세트를 결정합니다.

두 가지 빌드 모드는 다음과 같습니다. default 모드와 WebAssembly 모드.

두 가지 렌더러는 다음과 같습니다. `canvaskit`과 `skwasm`.

## Renderers {:renderers}

Flutter에서 UI 렌더링은 위젯과 렌더 객체가 있는 프레임워크에서 시작됩니다. 
처리된 렌더 객체는 레이어로 구성된 `Scene` 객체를 생성합니다. 
그런 다음 장면은 Flutter _엔진_ 으로 전달되어 픽셀로 변환됩니다. 
모든 위젯과 커스텀 앱 코드를 포함한 모든 프레임워크와 엔진의 대부분은 Dart로 작성되었습니다. 
그러나, 엔진의 큰 부분은 Skia와 커스텀 Flutter 엔진 코드를 포함한 C++로 작성되었습니다. 
Dart와 C++를 컴파일하는 방법, UI를 픽셀로 변환하는 데 사용할 그래픽 시스템, 
스레드 간에 작업 부하를 분할하는 방법 등에 대한 여러 옵션이 웹에서 제공됩니다.

Flutter 웹은 가능한 모든 옵션 조합을 제공하지 않습니다. 
대신, 신중하게 선택한 조합의 두 가지 번들만 제공합니다.

### canvaskit

`canvaskit` 렌더러를 사용할 때, Dart 코드는 JavaScript로 컴파일되고, 
UI는 메인 스레드에서 WebGL로 렌더링됩니다. 
모든 최신 브라우저와 호환됩니다. 
여기에는 WebAssembly로 컴파일된 Skia 사본이 포함되어 있어, 다운로드 크기가 약 1.5MB 추가됩니다.

### skwasm

`skwasm`을 사용하면 Dart 코드가 WebAssembly로 컴파일됩니다. 
또한, 호스팅 서버가 [SharedArrayBuffer 보안 요구 사항][SharedArrayBuffer security requirements]을 충족하는 경우, 
Flutter는 전용 [웹 워커][web worker]를 사용하여, 
렌더링 작업 부하의 일부를 별도의 스레드로 오프로드하여 여러 CPU 코어를 활용합니다. 
이 렌더러에는 WebAssembly로 컴파일된 Skia의 더 컴팩트한 버전이 포함되어 있어, 
다운로드 크기가 약 1.1MB 추가됩니다.

## 빌드 모드 {:build-modes}

### 기본 빌드 모드 {:#default-build-mode}

기본 모드는 `flutter run` 및 `flutter build web` 명령이, 
`--wasm`을 전달하지 않고 사용되거나 `--no-wasm`을 전달하여 사용될 때 사용됩니다. 
이 빌드 모드는 `canvaskit` 렌더러만 사용합니다.

### WebAssembly 빌드 모드 {:#webassembly-build-mode}

이 모드는 `--wasm`을 `flutter run` 및 `flutter build web` 명령에 전달하여 활성화됩니다.

이 모드에서는 `skwasm`과 `canvaskit`을 모두 사용할 수 있습니다. 
`skwasm`은 [wasm 가비지 수집][wasm garbage collection]을 필요로 하는데, 아직 모든 최신 브라우저에서 지원되지 않습니다. 
따라서, 런타임에 Flutter는 가비지 수집이 지원되는 경우 `skwasm`을 선택하고, 
지원되지 않는 경우 `canvaskit`으로 대체합니다. 
이를 통해 WebAssembly 모드에서 컴파일된 앱이 모든 최신 브라우저에서 계속 실행될 수 있습니다.

`--wasm` 플래그는 웹이 아닌 플랫폼에서는 지원되지 않습니다.

## 런타임에 렌더러 선택 {:#choosing-a-renderer-at-runtime}

기본적으로 WebAssembly 모드에서 빌드할 때, 
Flutter는 `skwasm`을 사용할 때와 `canvaskit`으로 대체할 때를 결정합니다. 
다음과 같이 로더에 구성 객체를 전달하여 재정의할 수 있습니다.

1. `--wasm` 플래그로 앱을 빌드하여 `skwasm`과 `canvaskit` 렌더러를 모두 앱에서 사용할 수 있도록 합니다.
1. [커스텀 `flutter_bootstrap.js` 작성][custom-bootstrap]에서 설명한 대로, 
   커스텀 웹 앱 초기화를 설정합니다.
2. `renderer` 속성이 `"canvaskit"` 또는 `"skwasm"`으로 설정된 구성 객체를 준비합니다.
3. 준비된 구성 객체를 새 객체의 `config` 속성으로 전달하여, 
   이전에 주입된 코드에서 제공하는 `_flutter.loader.load` 메서드에 전달합니다.

예:

```html highlightLines=9-14
<body>
  <script>
    {% raw %}{{flutter_js}}{% endraw %}
    {% raw %}{{flutter_build_config}}{% endraw %}

    // TODO: 이 코드를 자신의 코드로 바꿔서 사용할 렌더러를 결정하세요.
    const useCanvasKit = true;

    const config = {
      renderer: useCanvasKit ? "canvaskit" : "skwasm",
    };
    _flutter.loader.load({
      config: config,
    });
  </script>
</body>
```

`load` 메서드를 호출한 후에는 웹 렌더러를 변경할 수 없습니다. 
따라서, 어떤 렌더러를 사용할지에 대한 결정은 `_flutter.loader.load`를 호출하기 전에 내려야 합니다.

:::version-note
웹 렌더러를 지정하는 방법은 Flutter 3.22에서 변경되었습니다. 
이전 Flutter 버전에서 렌더러를 구성하는 방법을 알아보려면, 
[레거시 웹 앱 초기화][web-init-legacy]를 확인하세요.
:::

[custom-bootstrap]: /platform-integration/web/initialization#custom-bootstrap-js
[customizing-web-init]: /platform-integration/web/initialization
[web-init-legacy]: /platform-integration/web/initialization-legacy

## 사용할 빌드 모드 선택 {:#choosing-which-build-mode-to-use}

Dart를 WebAssembly로 컴파일하면, 
모든 앱 코드와 앱에서 사용하는 모든 플러그인 및 패키지에서 충족해야 하는 몇 가지 새로운 요구 사항이 있습니다.

- 코드는 새로운 JS 상호 운용 라이브러리 `dart:js_interop`만 사용해야 합니다. 
  이전 스타일의 `dart:js`, `dart:js_util`, `package:js`는 더 이상 지원되지 않습니다.
- 웹 API를 사용하는 코드는 `dart:html` 대신 새로운 `package:web`을 사용해야 합니다.
- WebAssembly는 Dart의 숫자 타입 `int`와 `double`을 Dart VM과 정확히 동일하게 구현합니다. 
  JavaScript에서 이러한 타입은 JS `Number` 타입을 사용하여 에뮬레이트됩니다. 
  코드가 실수로 또는 의도적으로 숫자에 대한 JS 동작에 의존할 수 있습니다. 
  그렇다면 이러한 코드는 Dart VM 동작과 올바르게 동작하도록 업데이트해야 합니다.

일반적인 권장 사항은 다음과 같이 요약할 수 있습니다.

* 앱이 아직 WebAssembly를 지원하지 않는 플러그인과 패키지에 의존하는 경우, 기본 모드를 선택합니다.
* 앱의 코드와 패키지가 WebAssembly와 호환되고 앱 성능이 중요한 경우, WebAssembly 모드를 선택합니다. 
  `skwasm`은 `canvaskit`에 비해 앱 시작 시간과 프레임 성능이 눈에 띄게 더 좋습니다. 
  `skwasm`은 특히 멀티스레드 모드에서 효과적이므로, 
  [SharedArrayBuffer 보안 요구 사항][SharedArrayBuffer security requirements]을 충족하도록 서버를 구성하는 것을 고려하세요.

## 예제 {:#examples}

기본 빌드 모드를 사용하여 Chrome에서 실행합니다.

```console
flutter run -d chrome
```

기본 빌드 모드를 사용하여 릴리스용 앱을 빌드하세요.

```console
flutter build web
```

WebAssembly 모드를 사용하여 릴리스용 앱을 빌드하세요.

```console
flutter build web --wasm
```

기본 빌드 모드를 사용하여 프로파일링을 위해 앱을 실행합니다.

```console
flutter run -d chrome --profile
```

[canvaskit]: https://skia.org/docs/user/modules/canvaskit/
[file an issue]: {{site.repo.flutter}}/issues/new?title=[web]:+%3Cdescribe+issue+here%3E&labels=%E2%98%B8+platform-web&body=Describe+your+issue+and+include+the+command+you%27re+running,+flutter_web%20version,+browser+version
[web worker]: https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API
[wasm garbage collection]: https://developer.chrome.com/blog/wasmgc
[SharedArrayBuffer security requirements]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/SharedArrayBuffer#security_requirements
