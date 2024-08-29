---
# title: Support for WebAssembly (Wasm)
title: WebAssembly(Wasm) 지원
# description: >-
#   Current status of Flutter's experimental support for WebAssembly (Wasm).
description: >-
  Flutter의 WebAssembly(Wasm) 실험적 지원의 현재 상태입니다.
short-title: Wasm
last-update: May 14, 2024
---

**_Last updated {{last-update}}_**

Flutter와 Dart 팀은 웹 애플리케이션을 빌드할 때, 
[WebAssembly](https://webassembly.org/)를 컴파일 대상으로 추가하게 되어 기쁘게 생각합니다.

:::note
**Wasm 지원이 이제 stable입니다!**
: Flutter 웹에 대한 WebAssembly 지원은 Flutter [`stable`][] 채널에서 제공됩니다.

**Dart의 차세대 웹 상호 운용성(interop)이 이제 stable입니다!**
: 패키지를 [`package:web`][] 및 [`dart:js_interop`][]로 마이그레이션하여 Wasm과 호환되도록 하세요. 
  자세한 내용은 [Requires JS-interop](#js-interop-wasm) 섹션을 참조하세요.
:::

[`stable`]: {{site.github}}/flutter/flutter/blob/master/docs/releases/Flutter-build-release-channels.md#stable
[`package:web`]: {{site.pub-pkg}}/web
[`dart:js_interop`]: {{site.dart.api}}/{{site.dart.sdk.channel}}/dart-js_interop

## 백그라운드 {:#background}

Wasm으로 컴파일된 Flutter 앱을 실행하려면, [WasmGC][]를 지원하는 브라우저가 필요합니다.

[Chromium 및 V8][Chromium and V8]은 Chromium 119에서 WasmGC에 대한 stable 지원을 출시했습니다. 
iOS의 Chrome은 아직 [WasmGC][]를 지원하지 않는 WebKit을 사용합니다. 
Firefox는 Firefox 120에서 WasmGC에 대한 stable 지원을 발표했지만, 
현재는 [알려진 제한](#known-limitations)으로 인해 작동하지 않습니다.

[WasmGC]: {{site.github}}/WebAssembly/gc/tree/main/proposals/gc
[Chromium and V8]: https://chromestatus.com/feature/6062715726462976
[support WasmGC]: https://bugs.webkit.org/show_bug.cgi?id=247394
[issue]: https://bugzilla.mozilla.org/show_bug.cgi?id=1788206

## 시도해보세요 {:#try-it-out}

Wasm을 사용하여 미리 빌드된 Flutter 웹 앱을 시도하려면, 
[Wonderous 데모 앱](https://wonderous.app/web/)을 확인하세요.

자신의 앱에서 Wasm을 실험하려면 다음 단계를 따르세요.

### Flutter 3.22 안정판 이상으로 전환{:#switch-to-the-flutter-3-22-stable-or-newer}

최신 버전을 실행하고 있는지 확인하려면, `flutter upgrade`를 실행하세요.

Flutter 설치가 Wasm을 지원하는지 확인하려면, `flutter build web --help`를 실행하세요.

출력 하단에 다음과 같은 실험적 Wasm 옵션이 있습니다.

```console
Experimental options
    --wasm                       Compile to WebAssembly (with fallback to JavaScript).
                                 See https://flutter.dev/wasm for more information.
    --[no-]strip-wasm            Whether to strip the resulting wasm file of static symbol names.
                                 (defaults to on)
```

### (간단한) Flutter 웹 애플리케이션을 선택 {:#choose-a-simple-flutter-web-application}

기본 템플릿 [샘플 앱][sample app]을 사용해 보거나, 
[Wasm과 호환되도록](#js-interop-wasm) 마이그레이션된 Flutter 애플리케이션을 선택하세요.

[sample app]: /get-started/test-drive

### `index.html` 수정 {:#modify-index-html}

Flutter 3.22 이상에 대한 최신 [Flutter 웹앱 초기화][Flutter web app initialization]로, 
앱의 `web/index.html`이 업데이트되었는지 확인하세요.

[Flutter web app initialization]: /platform-integration/web/initialization

### `flutter build web --wasm` 실행 {:#run-flutter-build-web-wasm}

Wasm으로 웹 애플리케이션을 빌드하려면, 기존의 `flutter build web` 명령에 `--wasm` 플래그를 추가합니다.

```console
flutter build web --wasm
```

이 명령은 `flutter build web`과 마찬가지로, 패키지 루트를 기준으로 `build/web` 디렉토리에 출력을 생성합니다.

:::note
`--wasm` 플래그가 있어도, `flutter build web`은 여전히 ​​애플리케이션을 JavaScript로 컴파일합니다. 
WasmGC 지원이 런타임에 감지되지 않으면, JavaScript 출력이 사용되므로 애플리케이션은 브라우저 간에 계속 작동합니다.
:::

### HTTP 서버로 출력을 Serve {:#serve-the-output-with-an-http-server}

Flutter 웹 WebAssembly는 여러 스레드를 사용하여 애플리케이션을 더 빠르게 렌더링하고, jank가 줄어듭니다. 
이를 위해, 특정 HTTP 응답 헤더가 필요한 고급 브라우저 기능이 사용됩니다.

:::warning
서버가 특정 HTTP 헤더를 전송하도록 구성되어 있지 않으면, 
Flutter 웹 애플리케이션은 WebAssembly로 실행되지 않습니다.
:::

| 이름 | 값 |
|-|-|
| `Cross-Origin-Embedder-Policy` | `credentialless` <br> 또는 <br> `require-corp` |
| `Cross-Origin-Opener-Policy` | `same-origin` |

{:.table}

이러한 헤더에 대해 자세히 알아보려면, 
[COEP를 사용하여 CORP 헤더 없이 교차 출처 리소스 로드: 자격 증명 없음][coep]를 확인하세요.

[coep]: https://developer.chrome.com/blog/coep-credentialless-origin-trial

### Wasm을 지역적으로 서비스 {:#serving-wasm-locally}

로컬 HTTP 서버가 설치되어 있지 않으면, [`dhttpd` 패키지]({{site.pub-pkg}}/dhttpd)를 사용할 수 있습니다.

```console
flutter pub global activate dhttpd
```

그런 다음 `build/web` 디렉토리로 변경하고, 특수 헤더를 사용하여 서버를 실행합니다.

```console
$ cd build/web
$ dhttpd '--headers=Cross-Origin-Embedder-Policy=credentialless;Cross-Origin-Opener-Policy=same-origin'
Server started on port 8080
```

### 브라우저에 로드 {:#load-it-in-a-browser}

{{last-update}} 기준으로, [오직 **Chromium 기반 브라우저**](#chrome-119-or-later) (버전 119 이상)만 Flutter/Wasm 콘텐츠를 실행할 수 있습니다.

구성된 브라우저가 요구 사항을 충족하는 경우, 
브라우저에서 [`localhost:8080`](http://localhost:8080)을 열어 앱을 확인합니다.

애플리케이션이 로드되지 않는 경우:

1. 개발자 콘솔에서 오류를 확인합니다.
1. 일반적인 JavaScript 출력으로 성공적인 빌드를 확인합니다.

## 알려진 제한 사항 {:#known-limitations}

Wasm 지원에는 현재 몇 가지 제한이 있습니다. 다음 목록은 몇 가지 일반적인 문제를 다룹니다.

### 크롬 119 이상 {:#chrome-119-or-later}

[브라우저에서 로드](#load-it-in-a-browser)에서 언급했듯이, 
Wasm으로 컴파일된 Flutter 웹 앱을 실행하려면 _Chrome 119 이상_ 을 사용하세요.

일부 이전 버전은 특정 플래그를 활성화한 WasmGC를 지원했지만, WasmGC 인코딩은 기능이 안정화된 후 변경되었습니다. 
호환성을 보장하려면, 최신 버전의 Flutter `main` 채널과 최신 버전의 Chrome을 실행하세요.

- **왜 Firefox가 아닌가요?**
  Firefox 버전 120 이상은 이전에 Flutter/Wasm을 실행할 수 있었지만, 
  현재 Flutter의 Wasm 렌더러와의 호환성을 차단하는 [버그][currently experiencing a bug]가 발생하고 있습니다.
- **왜 Safari가 아닌가요?**
  Safari는 아직 WasmGC를 지원하지 않습니다. [이 버그][this bug]는 구현 노력을 추적합니다.

:::warning
Wasm으로 컴파일된 Flutter는 어떤 브라우저의 iOS 버전에서도 실행할 수 없습니다. 
iOS의 모든 브라우저는 WebKit을 사용해야 하며, 자체 브라우저 엔진을 사용할 수 없습니다.
:::

[currently experiencing a bug]: https://bugzilla.mozilla.org/show_bug.cgi?id=1788206
[this bug]: https://bugs.webkit.org/show_bug.cgi?id=247394

### 브라우저 및 JS API에 액세스하려면 JS-interop이 필요합니다. {:#js-interop-wasm}

Wasm으로 컴파일을 지원하기 위해, 브라우저 및 JavaScript API와의 상호 운용성을 활성화하는 방법으로, [Dart를 전환했습니다][JS interop]. 이 전환으로 인해 `dart:html` 또는 `package:js`를 사용하는 Dart 코드는 Wasm으로 컴파일되지 않습니다.

대신, Dart는 이제 정적 JS interop을 기반으로 구축된, 새롭고 가벼운 interop 솔루션을 제공합니다.

- `dart:html`(및 기타 웹 라이브러리)을 대체하는 [`package:web`][]
- `package:js` 및 `dart:js`를 대체하는 [`dart:js_interop`][]

Dart 및 Flutter 팀은 [`package:url_launcher`][]와 같이, 
Flutter에서 Wasm을 지원하도록 대부분의 패키지를 마이그레이션했습니다. 
Wasm과 호환되는 패키지를 찾으려면 [pub.dev][]에서 [`wasm-ready`][] 필터를 사용하세요.


패키지와 애플리케이션을 새 솔루션으로 마이그레이션하는 방법을 알아보려면, 
[JS interop][] 문서와 [`package:web` 마이그레이션 가이드][`package:web` migration guide]를 확인하세요.

Wasm 빌드가 호환되지 않는 API로 인해 실패했는지 확인하려면 오류 출력을 검토하세요. 
이러한 오류는 종종 빌드 호출 직후에 반환됩니다. 
API 관련 오류는 다음과 유사해야 합니다.

```plaintext
Target dart2wasm failed: Exception: ../../../../.pub-cache/hosted/pub.dev/url_launcher_web-2.0.16/lib/url_launcher_web.dart:6:8: Error: Dart library 'dart:html' is not available on this platform.
import 'dart:html' as html;
       ^
Context: The unavailable library 'dart:html' is imported through these packages:

    web_plugin_registrant.dart => package:url_launcher_web => dart:html
    web_plugin_registrant.dart => package:url_launcher_web => package:flutter_web_plugins => dart:html
    web_plugin_registrant.dart => package:flutter_web_plugins => dart:html
```

[`package:url_launcher`]: {{site.pub-pkg}}/url_launcher
[`package:web` migration guide]: {{site.dart-site}}/interop/js-interop/package-web
[JS interop]: {{site.dart-site}}/interop/js-interop
[`wasm-ready`]: {{site.pub-pkg}}?q=is%3Awasm-ready
[pub.dev]: {{site.pub}}

### 빌드만 지원합니다. {:#only-build-support}

`flutter run`도 [DevTools](/tools/devtools)도 Flutter 3.22에서 Wasm을 지원하지 않습니다. 
하지만, 이 기능은 구현되었고, 다음 stable 릴리스에서 사용할 수 있을 것입니다.
