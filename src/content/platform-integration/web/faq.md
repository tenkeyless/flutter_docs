---
# title: Web FAQ
title: 웹 FAQ
# description: Some gotchas and differences when writing or running web apps in Flutter.
description: Flutter에서 웹 앱을 작성하거나 실행할 때의 몇 가지 문제점과 차이점.
---

## 질문 {:#questions}

### 웹에서 Flutter를 사용하기에 이상적인 시나리오는 무엇입니까? {:#what-scenarios-are-ideal-for-flutter-on-the-web}

Not every web page makes sense in Flutter, but we think Flutter is particularly
suited for app-centric experiences:

* Progressive Web Apps
* Single Page Apps
* Existing Flutter mobile apps

At this time, Flutter is not suitable for static websites with text-rich
flow-based content. For example, blog articles benefit from the document-centric
model that the web is built around, rather than the app-centric services that a
UI framework like Flutter can deliver. However, you _can_ use Flutter to embed
interactive experiences into these websites.

For more information on how you can use Flutter on the web,
see [Web support for Flutter][].

### 검색 엔진 최적화 (SEO, Search Engine Optimization) {:#search-engine-optimization-seo}

In general, Flutter is geared towards dynamic application experiences. Flutter's
web support is no exception. Flutter web prioritizes performance, fidelity, and
consistency. This means application output does not align with what search
engines need to properly index. For web content that is static or document-like,
we recommend using HTML—just like we do on [flutter.dev]({{site.main-url}}),
[dart.dev]({{site.dart-site}}), and [pub.dev]({{site.pub}}). You should also
consider separating your primary application experience—created in Flutter—from
your landing page, marketing content, and help content—created using
search-engine optimized HTML.

That said, as mentioned in the [roadmap][], the Flutter team plans to
investigate search engine indexability of Flutter web. To that end, we built a
small website containing [Hawaii-themed space stories][space_hawaii], hoping
that search engines find and index this site.

### 웹에서도 실행되는 앱을 어떻게 만들 수 있나요? {:#how-do-i-create-an-app-that-also-runs-on-the-web}

See [building a web app with Flutter][].

### 웹 앱에서도 핫 리로드가 작동하나요? {:#does-hot-reload-work-with-a-web-app}

No, but you can use hot restart. Hot restart is a fast way of seeing your
changes without having to relaunch your web app and wait for it to compile and
load. This works similarly to the hot reload feature for Flutter mobile
development. The only difference is that hot reload remembers your state and hot
restart doesn't.

### 브라우저에서 실행 중인 앱을 다시 시작하려면 어떻게 해야 하나요?{:#how-do-i-restart-the-app-running-in-the-browser}

You can either use the browser's refresh button,
or you can enter "R" in the console where
"flutter run -d chrome" is running.

### Flutter는 어떤 웹 브라우저를 지원하나요? {:#which-web-browsers-are-supported-by-flutter}

Flutter web apps can run on the following browsers:

* Chrome (mobile & desktop)
* Safari (mobile & desktop)
* Edge (mobile & desktop)
* Firefox (mobile & desktop)

During development, Chrome (on macOS, Windows, and Linux) and Edge (on Windows)
are supported as the default browsers for debugging your app.

### 어떤 IDE에서든 웹 앱을 빌드, 실행, 배포할 수 있나요? {:#can-i-build-run-and-deploy-web-apps-in-any-of-the-ides}

You can select **Chrome** or **Edge** as the target device in
Android Studio/IntelliJ and VS Code.

The device pulldown should now include the **Chrome (web)**
option for all channels.

### 웹용 반응형 앱을 어떻게 만들 수 있나요? {:#how-do-i-build-a-responsive-app-for-the-web}

See [Creating responsive apps][].

### 웹 앱에서 `dart:io`를 사용할 수 있나요? {:#can-i-use-dart-io-with-a-web-app}

No. The file system is not accessible from the browser.
For network functionality, use the [`http`][]
package. Note that security works somewhat
differently because the browser (and not the app)
controls the headers on an HTTP request.

### 웹 관련 import를 어떻게 처리하나요? {:#how-do-i-handle-web-specific-imports}

Some plugins require platform-specific imports, particularly if they use the
file system, which is not accessible from the browser. To use these plugins
in your app, see the [documentation for conditional imports][]
on [dart.dev]({{site.dart-site}}).

### Flutter 웹은 동시성을 지원하나요? {:#does-flutter-web-support-concurrency}

Dart's concurrency support via [isolates][]
is not currently supported in Flutter web.

Flutter web apps can potentially work around this
by using [web workers][],
although no such support is built in.

### 웹 페이지에 Flutter 웹앱을 어떻게 임베드하나요? {:#how-do-i-embed-a-flutter-web-app-in-a-web-page}

See [Embedding Flutter web][].

### Flutter 웹앱에 웹 콘텐츠를 어떻게 임베드하나요? {:#how-do-i-embed-web-content-in-a-flutter-web-app}

See [Web content in Flutter][].

### 웹앱을 디버깅하려면 어떻게 해야 하나요? {:#how-do-i-debug-a-web-app}

Use [Flutter DevTools][] for the following tasks:

* [Debugging][]
* [Logging][]
* [Running Flutter inspector][]

Use [Chrome DevTools][] for the following tasks:

* [Generating event timeline][]
* [Analyzing performance][]&mdash;make sure to use a
  profile build

### 웹앱을 어떻게 테스트하나요? {:#how-do-i-test-a-web-app}

Use [widget tests][] or integration tests. To learn more about
running integration tests in a browser, see the [Integration testing][] page.

### 웹앱을 어떻게 배포하나요? {:#how-do-i-deploy-a-web-app}

See [Preparing a web app for release][].

### `Platform.is`는 웹에서 작동하나요? {:#does-platform-is-work-on-the-web}

Not currently.

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
