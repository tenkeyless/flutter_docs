---
# title: Add Flutter to an existing app
title: 기존 앱에 Flutter 추가
# short-title: Add to app
short-title: 앱에 추가 (add-to-app)
# description: Adding Flutter as a library to an existing Android or iOS app.
description: 기존 Android 또는 iOS 앱에 Flutter를 라이브러리로 추가합니다.
---

## 앱에 추가 (add-to-app) {:#add-to-app}

새 애플리케이션을 처음부터 작성하는 경우, Flutter를 사용하여 [시작][get started]하기 쉽습니다. 
하지만, Flutter로 작성되지 않은 앱이 이미 있고, 처음부터 시작하는 것이 비현실적이라면 어떻게 해야 할까요?

이러한 상황에서, Flutter는 모듈로 기존 애플리케이션에 조각조각 통합될 수 있습니다. 
이 기능은 "앱에 추가(add-to-app)"라고 합니다. 
모듈을 기존 앱으로 import하여, Flutter를 사용하여 앱의 일부를 렌더링하는 동안, 
나머지는 기존 기술을 사용하여 렌더링할 수 있습니다. 
이 방법은 Dart의 이식성과 다른 언어와의 상호 운용성을 활용하여, 
공유된 비 UI 로직을 실행하는 데에도 사용할 수 있습니다.

앱에 추가는 현재 Android, iOS 및 웹에서 지원됩니다.

Flutter는 두 가지 플레이버의 앱에 추가를 지원합니다.

- **다중 엔진**: Android 및 iOS에서 지원되며, 호스트 애플리케이션에 내장된 위젯을 렌더링하는, 
  Flutter 인스턴스를 하나 이상 실행할 수 있습니다. 
  각 인스턴스는 다른 프로그램과 격리되어 실행되는 별도의 Dart 프로그램입니다. 
  여러 Flutter 인스턴스가 있으면, 각 인스턴스가 최소한의 메모리 리소스를 사용하면서, 
  독립적인 애플리케이션과 UI 상태를 유지할 수 있습니다. 
  [다중 Flutter][multiple Flutters] 페이지에서 자세히 알아보세요.
- **다중 뷰**: 웹에서 지원되며, 호스트 애플리케이션에 내장된 위젯을 렌더링하는, 
  여러 [FlutterView][]를 만들 수 있습니다. 
  이 모드에서는 Dart 프로그램이 하나뿐이며, 모든 뷰와 위젯이 객체를 공유할 수 있습니다.

앱에 추가는 모든 크기의 여러 Flutter 뷰를 통합하여 다양한 사용 사례를 지원합니다. 
가장 일반적인 사용 사례 두 가지는 다음과 같습니다.

* **하이브리드 네비게이션 스택**: 앱은 여러 화면으로 구성되며, 그 중 일부는 Flutter에서 렌더링되고, 
  다른 일부는 다른 프레임워크에서 렌더링됩니다. 
  사용자는 화면을 렌더링하는 데 사용된 프레임워크와 관계없이, 
  한 화면에서 다른 화면으로 자유롭게 탐색할 수 있습니다.
* **부분 화면 뷰**: 앱의 화면은 여러 위젯을 렌더링하며, 
  그 중 일부는 Flutter에서 렌더링되고 다른 일부는 다른 프레임워크에서 렌더링됩니다. 
  사용자는 위젯을 렌더링하는 데 사용된 프레임워크와 관계없이, 
  모든 위젯을 자유롭게 스크롤하고 상호 작용할 수 있습니다.

## 지원되는 기능 {:#supported-features}

### Android 애플리케이션에 추가 {:#add-to-android-applications}

{% render docs/app-figure.md, image:"development/add-to-app/android-overview.gif", alt:"Add-to-app steps on Android" %}

* Gradle 스크립트에 Flutter SDK 후크를 추가하여, Flutter 모듈을 자동으로 빌드하고 import 합니다.
* Flutter 모듈을 일반적인 [Android Archive (AAR)][]로 빌드하여, 
  자체 빌드 시스템에 통합하고, Jetifier가 AndroidX와 더 잘 상호 운용되도록 합니다.
* [`FlutterActivity`][]/[`FlutterFragment`][] 등을 연결하지 않고도, 
  Flutter 환경을 독립적으로 시작하고 유지하기 위한 [`FlutterEngine`][java-engine] API
* Android Studio Android/Flutter 공동 편집 및 모듈 생성/import 마법사.
* Java 및 Kotlin 호스트 앱이 지원됩니다.
* Flutter 모듈은 [Flutter 플러그인][Flutter plugins]을 사용하여, 플랫폼과 상호 작용할 수 있습니다.
* IDE 또는 명령줄에서 `flutter attach`를 사용하여, 
  Flutter가 포함된 앱에 연결하여 Flutter 디버깅 및 상태 저장 핫 리로드를 지원합니다.

### iOS 애플리케이션에 추가 {:#add-to-ios-applications}

{% render docs/app-figure.md, image:"development/add-to-app/ios-overview.gif", alt:"Add-to-app steps on iOS" %}

* CocoaPods와 Xcode 빌드 단계에 Flutter SDK 후크를 추가하여, 
  Flutter 모듈을 자동으로 빌드하고 import 합니다.
* Flutter 모듈을 일반 [iOS Framework][]에 빌드하여, 자체 빌드 시스템에 통합합니다.
* [`FlutterViewController`][]를 연결하지 않고도, 
  Flutter 환경을 시작하고 지속하기 위한 [`FlutterEngine`][ios-engine] API
* Objective-C 및 Swift 호스트 앱이 지원됩니다.
* Flutter 모듈은 [Flutter 플러그인][Flutter plugins]을 사용하여 플랫폼과 상호 작용할 수 있습니다.
* IDE 또는 명령줄에서 `flutter attach`를 사용하여, 
  Flutter 디버깅 및 상태 저장 핫 리로드를 지원하여 Flutter가 포함된 앱에 연결합니다.

UI용 Flutter 모듈을 가져오는 Android 및 iOS의 샘플 프로젝트는
[add-to-app GitHub 샘플 리포지토리][add-to-app GitHub Samples repository]를 참조하세요.

### 웹 애플리케이션에 추가 {:#add-to-web-applications}

Flutter는 모든 클라이언트 측 Dart 웹 프레임워크([jaspr][], [ngdart][], [over_react][] 등), 
모든 클라이언트 측 JS 프레임워크([React][], [Angular][], [Vue.js][] 등), 
모든 서버 측 렌더링 프레임워크([Django][], [Ruby on Rails][], [Apache Struts][] 등) 또는 
프레임워크가 전혀 없어도(애칭으로 "[VanillaJS][]"라고 함) 기존 HTML DOM 기반 웹 앱에 추가할 수 있습니다. 
최소 요구 사항은 기존 애플리케이션과 해당 프레임워크가 JavaScript 라이브러리 가져오기와 
Flutter가 렌더링할 HTML 요소 생성을 지원한다는 것입니다.

기존 앱에 Flutter를 추가하려면 정상적으로 빌드한 다음, 
[임베딩 지침][embedding instructions]에 따라 Flutter 뷰를 페이지에 배치합니다.

[jaspr]: https://pub.dev/packages/jaspr
[ngdart]: https://pub.dev/packages/ngdart
[over_react]: https://pub.dev/packages/over_react
[React]: https://react.dev/
[Angular]: https://angular.dev/
[Vue.js]: https://vuejs.org/
[Django]: https://www.djangoproject.com/
[Ruby on Rails]: https://rubyonrails.org/
[Apache Struts]: https://struts.apache.org/
[VanillaJS]: http://vanilla-js.com/
[embedding instructions]: {{site.docs}}/platform-integration/web/embedding-flutter-web#embedded-mode

## 시작하기 {:#get-started}

시작하려면 Android 및 iOS용 프로젝트 통합 가이드를 참조하세요.

<div class="card-grid">
  <a class="card" href="/add-to-app/android/project-setup">
    <div class="card-body">
      <header class="card-title text-center">
        Android
      </header>
    </div>
  </a>
  <a class="card" href="/add-to-app/ios/project-setup">
    <div class="card-body">
      <header class="card-title text-center">
        iOS
      </header>
    </div>
  </a>
  <a class="card" href="/platform-integration/web/embedding-flutter-web#embedded-mode">
    <div class="card-body">
      <header class="card-title text-center">
        Web
      </header>
    </div>
  </a>
</div>

## API 사용 {:#api-usage}

Flutter가 프로젝트에 통합되면, 다음 링크에서 API 사용 가이드를 참조하세요.

<div class="card-grid">
  <a class="card" href="/add-to-app/android/add-flutter-screen">
    <div class="card-body">
      <header class="card-title text-center">
        Android
      </header>
    </div>
  </a>
  <a class="card" href="/add-to-app/ios/add-flutter-screen">
    <div class="card-body">
      <header class="card-title text-center">
        iOS
      </header>
    </div>
  </a>
  <a class="card" href="/platform-integration/web/embedding-flutter-web#manage-flutter-views-from-js">
    <div class="card-body">
      <header class="card-title text-center">
        Web
      </header>
    </div>
  </a>
</div>

## 제한 사항 {:#limitations}

모바일 제한 사항:

* 다중 뷰 모드는 지원되지 않습니다. (다중 엔진만 해당)
* 여러 Flutter 라이브러리를 애플리케이션에 패키징하는 것은 지원되지 않습니다.
* `FlutterPlugin`을 지원하지 않는 플러그인은, 
  앱에 추가에서 유지할 수 없는 가정(예: Flutter `Activity`가 항상 존재한다고 가정)을 하는 경우, 
  예상치 못한 동작이 발생할 수 있습니다.
* Android에서, Flutter 모듈은 AndroidX 애플리케이션만 지원합니다.

웹 제한 사항:

* 다중 엔진 모드는 지원되지 않습니다. (다중 뷰만 해당)
* Flutter 엔진을 완전히 "종료"할 방법은 없습니다. 
  앱은 모든 [FlutterView][] 객체를 제거하고, 일반적인 Dart 개념을 사용하여, 
  모든 데이터가 가비지 수집되도록 할 수 있습니다. 
  그러나, 아무것도 렌더링하지 않더라도 엔진은 워밍업 상태를 유지합니다.

[get started]: /get-started/codelab
[add-to-app GitHub Samples repository]: {{site.repo.samples}}/tree/main/add_to_app
[Android Archive (AAR)]: {{site.android-dev}}/studio/projects/android-library
[Flutter plugins]: {{site.pub}}/flutter
[`FlutterActivity`]: {{site.api}}/javadoc/io/flutter/embedding/android/FlutterActivity.html
[java-engine]: {{site.api}}/javadoc/io/flutter/embedding/engine/FlutterEngine.html
[ios-engine]: {{site.api}}/ios-embedder/interface_flutter_engine.html
[FlutterFire]: {{site.github}}/firebase/flutterfire/tree/master/packages
[`FlutterFragment`]: {{site.api}}/javadoc/io/flutter/embedding/android/FlutterFragment.html
[`FlutterPlugin`]: {{site.api}}/javadoc/io/flutter/embedding/engine/plugins/FlutterPlugin.html
[`FlutterViewController`]: {{site.api}}/ios-embedder/interface_flutter_view_controller.html
[iOS Framework]: {{site.apple-dev}}/library/archive/documentation/MacOSX/Conceptual/BPFrameworks/Concepts/WhatAreFrameworks.html
[maintained by the Flutter team]: {{site.repo.packages}}/tree/main/packages
[multiple Flutters]: /add-to-app/multiple-flutters
[FlutterView]: https://api.flutter.dev/flutter/dart-ui/FlutterView-class.html
