---
# title: Configuring the URL strategy on the web
title: 웹에서 URL 전략 구성
# description: Use hash or path URL strategies on the web
description: 웹에서 해시 또는 path URL 전략을 사용하세요
---

Flutter 웹 앱은 웹에서 URL 기반 네비게이션을 구성하는 두 가지 방법을 지원합니다.

**해시 (Hash. 기본값)**
: 경로는 [해시 조각][hash fragment]에 읽고 씁니다. 예를 들어, `flutterexample.dev/#/path/to/screen`.

**경로 (Path)**
: 경로는 해시 없이 읽고 씁니다. 예를 들어, `flutterexample.dev/path/to/screen`.

## URL 전략 구성 {:#configuring-the-url-strategy}

대신 경로를 사용하도록 Flutter를 구성하려면, 
SDK의 [flutter_web_plugins][] 라이브러리에서 제공하는 [usePathUrlStrategy][] 함수를 사용하세요.

```dart
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  usePathUrlStrategy();
  runApp(ExampleApp());
}
```

## 웹 서버 구성 {:#configuring-your-web-server}

PathUrlStrategy는, 웹 서버에 대한 추가 구성이 필요한, [History API][]를 사용합니다.

PathUrlStrategy를 지원하도록 웹 서버를 구성하려면, 웹 서버 문서를 확인하여 요청을 `index.html`로 다시 작성합니다. 
단일 페이지 앱을 구성하는 방법에 대한 자세한 내용은 웹 서버 문서를 확인하세요.

Firebase 호스팅을 사용하는 경우, 프로젝트를 초기화할 때 "단일 페이지 앱으로 구성" 옵션을 선택합니다. 
자세한 내용은 Firebase의 [Configure rewrites][] 문서를 참조하세요.

`flutter run -d chrome`을 실행하여 만든 로컬 개발 서버는 모든 경로를 우아하게 처리하고, 
앱의 `index.html` 파일로 폴백하도록 구성됩니다.

## 루트가 아닌 위치에서 Flutter 앱 호스팅 {:#hosting-a-flutter-app-at-a-non-root-location}

`web/index.html`의 `<base href="/">` 태그를 앱이 호스팅되는 경로로 업데이트합니다. 
예를 들어, `my_app.dev/flutter_app`에서 Flutter 앱을 호스팅하려면, 이 태그를 `<base href="/flutter_app/">`로 변경합니다.

[hash fragment]: https://en.wikipedia.org/wiki/Uniform_Resource_Locator#Syntax
[`HashUrlStrategy`]: {{site.api}}/flutter/flutter_web_plugins/HashUrlStrategy-class.html
[`PathUrlStrategy`]: {{site.api}}/flutter/flutter_web_plugins/PathUrlStrategy-class.html
[`setUrlStrategy`]: {{site.api}}/flutter/flutter_web_plugins/setUrlStrategy.html
[`url_strategy`]: {{site.pub-pkg}}/url_strategy
[usePathUrlStrategy]: {{site.api}}/flutter/flutter_web_plugins/usePathUrlStrategy.html
[flutter_web_plugins]: {{site.api}}/flutter/flutter_web_plugins/flutter_web_plugins-library.html
[History API]: https://developer.mozilla.org/en-US/docs/Web/API/History_API
[Configure rewrites]: {{site.firebase}}/docs/hosting/full-config#rewrites
