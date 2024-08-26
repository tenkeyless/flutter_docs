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

This section summarizes the technologies available
across Flutter and the web,
on which the solutions below are based on.

### Flutter의 이미지 {:#images-in-flutter}

Flutter offers the [`Image`][] widget as well as the low-level
[`dart:ui/Image`][] class for rendering images.
The `Image` widget has enough functionality for most use-cases.
The `dart:ui/Image` class can be used in
advanced situations where fine-grained control
of the image is needed.

[`dart:ui/Image`]: {{site.api}}/flutter/dart-ui/Image-class.html

### 웹상의 이미지 {:#images-on-the-web}

The web offers several methods for displaying images.
Below are some of the common ones:

- The built-in [`<img>`][] and [`<picture>`][] HTML elements.
- The [`drawImage`][] method on the [`<canvas>`][] element.
- Custom image codec that renders to a WebGL canvas.

Each option has its own benefits and drawbacks.
For example, the built-in elements fit nicely among
other HTML elements, and they automatically take
advantage of browser caching, and built-in image
optimization and memory management.
They allow you to safely display images from arbitrary sources
(more on than in the CORS section below).
`drawImage` is great when the image must fit within
other content rendered using the `<canvas>` element.
You also gain control over image sizing and,
when the CORS policy allows it, read the pixels
of the image back for further processing.
Finally, WebGL gives you the highest degree of
control over the image. Not only can you read the pixels and
apply custom image algorithms, but you can also use GLSL for
hardware-acceleration.

[`<img>`]: https://developer.mozilla.org/docs/Web/HTML/Element/img
[`<picture>`]: https://developer.mozilla.org/docs/Web/HTML/Element/picture
[`drawImage`]: https://developer.mozilla.org/docs/Web/API/CanvasRenderingContext2D/drawImage
[`<canvas>`]: https://developer.mozilla.org/docs/Web/HTML/Element/canvas

### 교차 출처 리소스 공유(CORS, Cross-Origin Resource Sharing) {:#cross-origin-resource-sharing-cors}

[CORS][] is a mechanism that browsers use to control
how one site accesses the resources of another site.
It is designed such that, by default, one web-site
is not allowed to make HTTP requests to another site
using [XHR][] or [`fetch`][].
This prevents scripts on another site from acting on behalf
of the user and from gaining access to another
site's resources without permission.

When using `<img>`, `<picture>`, or `<canvas>`,
the browser automatically blocks access to pixels
when it knows that an image is coming from another site
and the CORS policy disallows access to data.

WebGL requires access to the image data in order
to be able to render the image. Therefore,
images to be rendered using WebGL must only come from servers
that have a CORS policy configured to work with
the domain that serves your application.

[CORS]: https://developer.mozilla.org/docs/Web/HTTP/CORS
[XHR]: https://developer.mozilla.org/docs/Web/API/XMLHttpRequest
[`fetch`]: https://developer.mozilla.org/docs/Web/API/Fetch_API/Using_Fetch

### 웹상의 Flutter 렌더러 {:#flutter-renderers-on-the-web}

Flutter offers a choice of two renderers on the web:

**CanvasKit**
: Uses WebGL to render UI, and therefore
  requires access to the pixels of the image.

**HTML**
: Uses a combination of HTML, CSS, Canvas 2D, and SVG to render UI.
  It uses the `<img>` element to render images.

Because the HTML renderer uses the `<img>`
element it can display images from
arbitrary sources. However,
this places the following limitations on what you
can do with them:

* Limited support for [`Image.toByteData`][].
* No support for [`OffsetLayer.toImage`][] and
  [`Scene.toImage`][].
* No access to frame data in animated images
  ([`Codec.getNextFrame`][],
  `frameCount` is always 1, `repetitionCount` is always 0).
* No support for `ImageShader`.
* Limited support for shader effects that can be applied to images.
* No control over image memory (`Image.dispose` has no effect).
  The memory is managed by the browser behind-the-scenes.

The CanvasKit renderer implements Flutter's image API fully.
However, it requires access to image pixels to do so,
and is therefore subject to the CORS policy.

[`Image.toByteData`]: {{site.api}}/flutter/dart-ui/Image/toByteData.html
[`OffsetLayer.toImage`]: {{site.api}}/flutter/rendering/OffsetLayer/toImage.html
[`Scene.toImage`]: {{site.api}}/flutter/dart-ui/Scene/toImage.html
[`Codec.getNextFrame`]: {{site.api}}/flutter/dart-ui/Codec/getNextFrame.html

## 솔루션 {:#solutions}

### 메모리 내, asset 및 동일 출처 네트워크 이미지 {:#in-memory-asset-and-same-origin-network-images}

If the app has the bytes of the encoded image in memory,
provided as an [asset][], or stored on the
same server that serves the application
(also known as _same-origin_), no extra effort is necessary.
The image can be displayed using
[`Image.memory`][], [`Image.asset`][], and [`Image.network`][]
in both HTML and CanvasKit modes.

[asset]: /ui/assets/assets-and-images
[`Image.memory`]: {{site.api}}/flutter/widgets/Image/Image.memory.html
[`Image.asset`]: {{site.api}}/flutter/widgets/Image/Image.asset.html
[`Image.network`]: {{site.api}}/flutter/widgets/Image/Image.network.html

### 교차 출처(Cross-origin) 이미지 {:#cross-origin-images}

The HTML renderer can load cross-origin images
without extra configuration.

CanvasKit requires that the app gets the bytes of the encoded image.
There are several ways to do this, discussed below.

#### CORS가 활성화된 CDN에 이미지를 호스팅하세요. {:#host-your-images-in-a-cors-enabled-cdn}

Typically, content delivery networks (CDN)
can be configured to customize what domains
are allowed to access your content.
For example, Firebase site hosting allows
[specifying a custom][custom-header] `Access-Control-Allow-Origin`
header in the `firebase.json` file.

[custom-header]: {{site.firebase}}/docs/hosting/full-config#headers

#### 이미지 서버에 대한 제어가 부족합니까? CORS 프록시를 사용하세요. {:#lack-control-over-the-image-server-use-a-cors-proxy}

If the image server cannot be configured to allow CORS
requests from your application,
you might still be able to load images by proxying
the requests through another server. This requires that the
intermediate server has sufficient access to load the images.

This method can be used in situations when the original
image server serves images publicly,
but is not configured with the correct CORS headers.

Examples:

* Using [CloudFlare Workers][].
* Using [Firebase Functions][].

[CloudFlare Workers]: https://developers.cloudflare.com/workers/examples/cors-header-proxy
[Firebase Functions]: {{site.github}}/7kfpun/cors-proxy

#### 플랫폼 뷰에서는 `<img>`를 사용합니다. {:#use-img-in-a-platform-view}

Flutter supports embedding HTML inside the app using
[`HtmlElementView`][].  Use it to create an `<img>`
element to render the image from another domain.
However, do keep in mind that this comes with the
limitations explained in [Flutter renderers on the web][].

[`HtmlElementView`]: {{site.api}}/flutter/widgets/HtmlElementView-class.html
[Flutter renderers on the web]: #flutter-renderers-on-the-web
