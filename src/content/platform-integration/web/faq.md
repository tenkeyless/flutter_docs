---
# title: Web FAQ
title: 웹 FAQ
# description: Some gotchas and differences when writing or running web apps in Flutter.
description: Flutter에서 웹 앱을 작성하거나 실행할 때의 몇 가지 문제점과 차이점.
---

## 질문 {:#questions}

### 웹에서 Flutter를 사용하기에 이상적인 시나리오는 무엇입니까? {:#what-scenarios-are-ideal-for-flutter-on-the-web}

모든 웹 페이지가 Flutter에서 의미가 있는 것은 아니지만, 
Flutter는 앱 중심 경험에 특히 적합하다고 생각합니다.

* Progressive 웹 앱
* 단일 페이지 앱
* 기존 Flutter 모바일 앱

현재, Flutter는 텍스트가 풍부한(text-rich) 흐름 기반(flow-based) 콘텐츠가 있는 정적 웹사이트에 적합하지 않습니다. 
예를 들어, 블로그 글은 Flutter와 같은 UI 프레임워크가 제공할 수 있는 앱 중심 서비스(app-centric services)가 아닌, 
웹이 구축된 문서 중심 모델(document-centric model)의 이점을 얻습니다. 
그러나, Flutter를 사용하여 이러한 웹사이트에 상호 작용 경험을 _임베드할 수_ 있습니다.

웹에서 Flutter를 사용하는 방법에 대한 자세한 내용은 [Flutter에 대한 웹 지원][Web support for Flutter]을 참조하세요.

### 검색 엔진 최적화 (SEO, Search Engine Optimization) {:#search-engine-optimization-seo}

일반적으로, Flutter는 동적 애플리케이션 경험을 지향합니다. 
Flutter의 웹 지원도 예외는 아닙니다. 
Flutter 웹은 성능(performance), 충실도(fidelity), 일관성(consistency)을 우선시합니다. 
즉, 애플리케이션 출력은 검색 엔진이 적절하게 인덱싱하는 데 필요한 것과 일치하지 않습니다. 
정적이거나 문서와 같은 웹 콘텐츠의 경우, [flutter.dev]({{site.main-url}}), [dart.dev]({{site.dart-site}}), [pub.dev]({{site.pub}})에서와 마찬가지로 HTML을 사용하는 것이 좋습니다. 
또한, Flutter에서 만든 기본 애플리케이션 경험을 검색 엔진 최적화 HTML을 사용하여, 
만든 랜딩 페이지, 마케팅 콘텐츠, 도움말 콘텐츠와 분리하는 것도 고려해야 합니다.

[로드맵][roadmap]에서 언급했듯이, 
Flutter 팀은 Flutter 웹의 검색 엔진 인덱싱 가능성을 조사할 계획입니다. 
이를 위해 [하와이 테마의 우주 스토리][space_hawaii]가 포함된 작은 웹사이트를 구축하여, 
검색 엔진이 이 사이트를 찾아 인덱싱하기를 바랐습니다.

### 웹에서도 실행되는 앱을 어떻게 만들 수 있나요? {:#how-do-i-create-an-app-that-also-runs-on-the-web}

[Flutter로 웹 앱 만들기][building a web app with Flutter]를 참조하세요.

### 웹 앱에서도 핫 리로드가 작동하나요? {:#does-hot-reload-work-with-a-web-app}

아니요, 하지만 핫 리스타트를 사용할 수 있습니다. 
핫 리스타트는 웹 앱을 다시 시작하고 컴파일 및 로드될 때까지 기다릴 필요 없이 변경 사항을 빠르게 볼 수 있는 방법입니다. 
이는 Flutter 모바일 개발을 위한 핫 리로드 기능과 비슷하게 작동합니다. 
유일한 차이점은 핫 리로드가 상태를 기억하는 반면, 핫 리스타트는 그렇지 않다는 것입니다.

### 브라우저에서 실행 중인 앱을 다시 시작하려면 어떻게 해야 하나요?{:#how-do-i-restart-the-app-running-in-the-browser}

브라우저의 새로 고침 버튼을 이용할 수도 있고, 
"flutter run -d chrome"이 실행 중인 콘솔에 "R"을 입력할 수도 있습니다.

### Flutter는 어떤 웹 브라우저를 지원하나요? {:#which-web-browsers-are-supported-by-flutter}

Flutter 웹 앱은 다음 브라우저에서 실행할 수 있습니다.

* Chrome(모바일 및 데스크톱)
* Safari(모바일 및 데스크톱)
* Edge(모바일 및 데스크톱)
* Firefox(모바일 및 데스크톱)

개발 중에 Chrome(macOS, Windows 및 Linux)과 Edge(Windows)가 앱 디버깅을 위한 기본 브라우저로 지원됩니다.

### 어떤 IDE에서든 웹 앱을 빌드, 실행, 배포할 수 있나요? {:#can-i-build-run-and-deploy-web-apps-in-any-of-the-ides}

Android Studio/IntelliJ 및 VS Code에서 대상 기기로 **Chrome** 또는 **Edge**를 선택할 수 있습니다.

이제 기기 풀다운에 모든 채널에 대한 **Chrome(웹)** 옵션이 포함되어야 합니다.

### 웹용 반응형 앱을 어떻게 만들 수 있나요? {:#how-do-i-build-a-responsive-app-for-the-web}

[반응형 앱 만들기][Creating responsive apps]를 참조하세요.

### 웹 앱에서 `dart:io`를 사용할 수 있나요? {:#can-i-use-dart-io-with-a-web-app}

아니요. 파일 시스템은 브라우저에서 접근할 수 없습니다. 
네트워크 기능을 위해 [`http`][] 패키지를 사용하세요. 
브라우저(앱이 아님)가 HTTP 요청의 헤더를 제어하기 때문에, 보안이 다소 다르게 작동한다는 점에 유의하세요.

### 웹 관련 import를 어떻게 처리하나요? {:#how-do-i-handle-web-specific-imports}

일부 플러그인은 플랫폼별 imports를 필요로 하며, 
특히 브라우저에서 액세스할 수 없는 파일 시스템을 사용하는 경우 더욱 그렇습니다. 
앱에서 이러한 플러그인을 사용하려면, 
[dart.dev]({{site.dart-site}})의 [조건부 imports 문서][documentation for conditional imports]를 ​​참조하세요.

### Flutter 웹은 동시성을 지원하나요? {:#does-flutter-web-support-concurrency}

Dart의 [isolates][]를 통한 동시성 지원은 현재 Flutter 웹에서 지원되지 않습니다.

Flutter 웹 앱은 [web workers][]를 사용하여 이를 해결할 수 있지만, 이러한 지원은 내장되어 있지 않습니다.

### 웹 페이지에 Flutter 웹앱을 어떻게 임베드하나요? {:#how-do-i-embed-a-flutter-web-app-in-a-web-page}

[Flutter 웹 임베딩][Embedding Flutter web]을 참조하세요.

### Flutter 웹앱에 웹 콘텐츠를 어떻게 임베드하나요? {:#how-do-i-embed-web-content-in-a-flutter-web-app}

[Flutter의 웹 콘텐츠][Web content in Flutter]를 참조하세요.

### 웹앱을 디버깅하려면 어떻게 해야 하나요? {:#how-do-i-debug-a-web-app}

다음 작업에 [Flutter DevTools][]를 사용하세요.

* [디버깅][Debugging]
* [로깅][Logging]
* [Flutter 검사기 실행][Running Flutter inspector]

다음 작업에 [Chrome DevTools][]를 사용하세요.

* [이벤트 타임라인 생성][Generating event timeline]
* [성능 분석][Analyzing performance]&mdash;프로필 빌드를 사용해야 합니다.

### 웹앱을 어떻게 테스트하나요? {:#how-do-i-test-a-web-app}

[위젯 테스트][widget tests] 또는 통합 테스트를 사용하세요. 
브라우저에서 통합 테스트를 실행하는 방법에 대해 자세히 알아보려면, [통합 테스트][Integration testing] 페이지를 참조하세요.

### 웹앱을 어떻게 배포하나요? {:#how-do-i-deploy-a-web-app}

[웹 앱 릴리스 준비][Preparing a web app for release]를 참조하세요.

### `Platform.is`는 웹에서 작동하나요? {:#does-platform-is-work-on-the-web}

현재는 아닙니다.

[Analyzing performance]: {{site.developers}}/web/tools/chrome-devtools/evaluate-performance
[building a web app with Flutter]: /platform-integration/web/building
[Chrome DevTools]: {{site.developers}}/web/tools/chrome-devtools
[Creating responsive apps]: /ui/adaptive-responsive
[Debugging]: /tools/devtools/debugger
[documentation for conditional imports]: {{site.dart-site}}/guides/libraries/create-library-packages#conditionally-importing-and-exporting-library-files
[Embedding Flutter web]: /platform-integration/web/embedding-flutter-web
[file an issue]: {{site.repo.flutter}}/issues/new?title=[web]:+%3Cdescribe+issue+here%3E&labels=%E2%98%B8+platform-web&body=Describe+your+issue+and+include+the+command+you%27re+running,+flutter_web%20version,+browser+version
[Flutter DevTools]: /tools/devtools
[Generating event timeline]: {{site.developers}}/web/tools/chrome-devtools/evaluate-performance/performance-reference
[`http`]: {{site.pub}}/packages/http
[`iframe`]: https://html.com/tags/iframe/
[Integration testing]: /testing/integration-tests#test-in-a-web-browser
[isolates]: {{site.dart-site}}/guides/language/concurrency
[Issue 32248]: {{site.repo.flutter}}/issues/32248
[Logging]: /tools/devtools/logging
[Preparing a web app for release]: /deployment/web
[roadmap]: {{site.github}}/flutter/flutter/blob/master/docs/roadmap/Roadmap.md#web-platform
[run your web apps in any supported browser]: /platform-integration/web/building#create-and-run
[Running Flutter inspector]: /tools/devtools/inspector
[space_hawaii]: https://alien-hawaii-2024.web.app/
[Web content in Flutter]: /platform-integration/web/web-content-in-flutter
[Web support for Flutter]: /platform-integration/web
[web workers]: https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Using_web_workers
[widget tests]: /testing/overview#widget-tests
