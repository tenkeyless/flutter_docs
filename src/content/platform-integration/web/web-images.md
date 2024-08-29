---
# title: Display images on the web
title: 웹에 이미지 표시
# short-title: Web images
short-title: 웹 이미지
# description: Learn how to load and display images on the web.
description: 웹에 이미지를 로드하고 표시하는 방법을 알아보세요.
---

웹은 이미지를 표시하기 위한 표준 [`Image`][] 위젯을 지원합니다. 
그러나, 웹 브라우저는 신뢰할 수 없는 코드를 안전하게 실행하도록 만들어졌기 때문에, 
모바일 및 데스크톱 플랫폼과 비교했을 때 이미지로 할 수 있는 작업에 특정 제한이 있습니다. 
이 페이지에서는 이러한 제한을 설명하고 이를 해결하는 방법을 제공합니다.

[`Image`]: {{site.api}}/flutter/widgets/Image-class.html

:::note
웹 로딩 속도를 최적화하는 방법에 대한 자세한 내용은, 
Medium의 (무료) 글인 [Flutter 웹 로딩 속도 최적화 모범 사례][article]를 확인하세요.

[article]: {{site.flutter-medium}}/best-practices-for-optimizing-flutter-web-loading-speed-7cc0df14ce5c
:::

## 백그라운드 {:#background}

이 섹션에서는 아래 솔루션의 기반이 되는 Flutter와 웹에서 사용 가능한 기술을 요약합니다.

### Flutter의 이미지 {:#images-in-flutter}

Flutter는 이미지를 렌더링하기 위한 낮은 레벨 [`dart:ui/Image`][] 클래스와 함께 [`Image`][] 위젯을 제공합니다. 
`Image` 위젯은 대부분의 사용 사례에 충분한 기능을 제공합니다. 
`dart:ui/Image` 클래스는 이미지의 세밀한 제어가 필요한 고급 상황에서 사용할 수 있습니다.

[`dart:ui/Image`]: {{site.api}}/flutter/dart-ui/Image-class.html

### 웹상의 이미지 {:#images-on-the-web}

웹은 이미지를 표시하는 여러 가지 방법을 제공합니다. 다음은 일반적인 방법 중 일부입니다.

- 내장된 [`<img>`][] 및 [`<picture>`][] HTML 요소.
- [`<canvas>`][] 요소의 [`drawImage`][] 메서드.
- WebGL 캔버스에 렌더링하는 커스텀 이미지 코덱.

각 옵션에는 고유한 장단점이 있습니다. 
예를 들어, 내장된 요소는 다른 HTML 요소와 잘 어울리며 브라우저 캐싱, 내장된 이미지 최적화 및 메모리 관리를 자동으로 활용합니다. 
이를 통해 임의의 소스에서 이미지를 안전하게 표시할 수 있습니다. (아래 CORS 섹션에서 보다 자세히 설명) 

`drawImage`는 `<canvas>` 요소를 사용하여 렌더링된 다른 콘텐츠에 이미지가 맞아야(fit) 할 때 유용합니다. 
또한 이미지 크기를 제어할 수 있으며, CORS 정책에서 허용하는 경우, 추가 처리를 위해 이미지의 픽셀을 다시 읽습니다. 

마지막으로, WebGL은 이미지에 대한 최고 수준의 제어를 제공합니다. 
픽셀을 읽고 커스텀 이미지 알고리즘을 적용할 수 있을 뿐만 아니라, 하드웨어 가속을 위해 GLSL을 사용할 수도 있습니다.

[`<img>`]: https://developer.mozilla.org/docs/Web/HTML/Element/img
[`<picture>`]: https://developer.mozilla.org/docs/Web/HTML/Element/picture
[`drawImage`]: https://developer.mozilla.org/docs/Web/API/CanvasRenderingContext2D/drawImage
[`<canvas>`]: https://developer.mozilla.org/docs/Web/HTML/Element/canvas

### 교차 출처 리소스 공유(CORS, Cross-Origin Resource Sharing) {:#cross-origin-resource-sharing-cors}

[CORS][]는 브라우저가 한 사이트가 다른 사이트의 리소스에 액세스하는 방식을 제어하는 ​​데 사용하는 메커니즘입니다. 
기본적으로 한 웹사이트가 [XHR][] 또는 [`fetch`][]를 사용하여, 
다른 사이트에 HTTP 요청을 할 수 없도록 설계되었습니다. 
이렇게 하면 다른 사이트의 스크립트가 사용자를 대신하여 작동하고, 
허가 없이 다른 사이트의 리소스에 액세스하는 것을 방지할 수 있습니다.

`<img>`, `<picture>` 또는 `<canvas>`를 사용할 때, 
브라우저는 이미지가 다른 사이트에서 온 것이고, 
CORS 정책이 데이터에 대한 액세스를 허용하지 않는 경우, 
픽셀에 대한 액세스를 자동으로 차단합니다.

WebGL은 이미지를 렌더링하기 위해 이미지 데이터에 대한 액세스가 필요합니다. 
따라서, WebGL을 사용하여 렌더링할 이미지는, 
애플리케이션을 제공하는 도메인에서 작동하도록 구성된 CORS 정책이 있는 서버에서만 가져와야 합니다.

[CORS]: https://developer.mozilla.org/docs/Web/HTTP/CORS
[XHR]: https://developer.mozilla.org/docs/Web/API/XMLHttpRequest
[`fetch`]: https://developer.mozilla.org/docs/Web/API/Fetch_API/Using_Fetch

### 웹상의 Flutter 렌더러 {:#flutter-renderers-on-the-web}

Flutter는 웹에서 두 가지 렌더러를 제공합니다.

**CanvasKit**
: WebGL을 사용하여 UI를 렌더링하므로, 이미지 픽셀에 액세스해야 합니다.

**HTML**
: HTML, CSS, Canvas 2D 및 SVG를 조합하여 UI를 렌더링합니다. 
  `<img>` 요소를 사용하여 이미지를 렌더링합니다.

HTML 렌더러는 `<img>` 요소를 사용하므로 임의의 소스에서 이미지를 표시할 수 있습니다. 
그러나, 이렇게 하면 이미지로 할 수 있는 작업에 다음과 같은 제한이 있습니다.

* [`Image.toByteData`][]에 대한 제한적 지원.
* [`OffsetLayer.toImage`][] 및 [`Scene.toImage`][]에 대한 지원 없음.
* 애니메이션 이미지의 프레임 데이터에 대한 액세스 없음.
  ([`Codec.getNextFrame`][], `frameCount`는 항상 1이고, `repetitionCount`는 항상 0임)
* `ImageShader`에 대한 지원 없음.
* 이미지에 적용할 수 있는 셰이더 효과에 대한 제한적 지원.
* 이미지 메모리에 대한 제어 없음. (`Image.dispose`는 효과가 없음)
  메모리는 behind-the-scenes에서 브라우저가 관리합니다.

CanvasKit 렌더러는 Flutter의 이미지 API를 완벽하게 구현합니다. 
그러나, 이를 위해 이미지 픽셀에 대한 액세스가 필요하므로 CORS 정책의 적용을 받습니다.

[`Image.toByteData`]: {{site.api}}/flutter/dart-ui/Image/toByteData.html
[`OffsetLayer.toImage`]: {{site.api}}/flutter/rendering/OffsetLayer/toImage.html
[`Scene.toImage`]: {{site.api}}/flutter/dart-ui/Scene/toImage.html
[`Codec.getNextFrame`]: {{site.api}}/flutter/dart-ui/Codec/getNextFrame.html

## 솔루션 {:#solutions}

### 메모리 내, asset 및 동일 출처 네트워크 이미지 {:#in-memory-asset-and-same-origin-network-images}

앱에 인코딩된 이미지의 바이트가 메모리에 있고, 
[asset][]으로 제공되거나 애플리케이션을 제공하는 동일한 서버에 저장되어 있는 경우(_same-origin_ 이라고도 함), 
별도의 작업이 필요하지 않습니다. 
이미지는 HTML 및 CanvasKit 모드에서 [`Image.memory`][], [`Image.asset`][], 
및 [`Image.network`][]를 사용하여 표시할 수 있습니다.

[asset]: /ui/assets/assets-and-images
[`Image.memory`]: {{site.api}}/flutter/widgets/Image/Image.memory.html
[`Image.asset`]: {{site.api}}/flutter/widgets/Image/Image.asset.html
[`Image.network`]: {{site.api}}/flutter/widgets/Image/Image.network.html

### 교차 출처(Cross-origin) 이미지 {:#cross-origin-images}

HTML 렌더러는 추가 구성 없이 교차 출처 이미지를 로드할 수 있습니다.

CanvasKit은 앱이 인코딩된 이미지의 바이트를 가져와야 합니다. 
이를 수행하는 방법에는 여러 가지가 있으며, 아래에서 설명합니다.

#### CORS가 활성화된 CDN에 이미지를 호스팅하세요. {:#host-your-images-in-a-cors-enabled-cdn}

일반적으로 콘텐츠 전송 네트워크(CDN)는 어떤 도메인이 콘텐츠에 액세스할 수 있는지 커스터마이즈하도록 구성할 수 있습니다. 
예를 들어, Firebase 사이트 호스팅은 `firebase.json` 파일에서, 
[커스텀][custom-header] `Access-Control-Allow-Origin` 헤더를 허용합니다.

[custom-header]: {{site.firebase}}/docs/hosting/full-config#headers

#### 이미지 서버에 대한 제어가 부족합니까? CORS 프록시를 사용하세요. {:#lack-control-over-the-image-server-use-a-cors-proxy}

이미지 서버가 애플리케이션에서 CORS 요청을 허용하도록 구성할 수 없는 경우, 
다른 서버를 통해 요청을 프록시하여 이미지를 로드할 수 있습니다. 
이를 위해서는 중간 서버에 이미지를 로드할 수 있는 충분한 액세스 권한이 있어야 합니다.

이 방법은 원래 이미지 서버가 이미지를 공개적으로 제공하지만, 
올바른 CORS 헤더로 구성되지 않은 상황에서 사용할 수 있습니다.

예:

* [CloudFlare Workers][] 사용.
* [Firebase Functions][] 사용.

[CloudFlare Workers]: https://developers.cloudflare.com/workers/examples/cors-header-proxy
[Firebase Functions]: {{site.github}}/7kfpun/cors-proxy

#### 플랫폼 뷰에서는 `<img>`를 사용합니다. {:#use-img-in-a-platform-view}

Flutter는 [`HtmlElementView`][]를 사용하여 앱 내부에 HTML을 임베드하는 것을 지원합니다. 
이를 사용하여 다른 도메인의 이미지를 렌더링하기 위한 `<img>` 요소를 만듭니다. 
그러나 [웹의 Flutter 렌더러][Flutter renderers on the web]에서 설명한 제한 사항이 있다는 점을 명심하세요.

[`HtmlElementView`]: {{site.api}}/flutter/widgets/HtmlElementView-class.html
[Flutter renderers on the web]: #flutter-renderers-on-the-web
