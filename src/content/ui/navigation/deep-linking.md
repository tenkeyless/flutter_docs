---
# title: Deep linking
title: 딥 링크
# description: Navigate to routes when the app receives a new URL.
description: 앱이 새 URL을 받으면 경로로 이동합니다.
---
딥 링크(Deep links)는 앱을 여는 링크일 뿐만 아니라, 사용자를 앱 내부의 "깊은" 특정 위치로 안내합니다. 
예를 들어, 운동화 한 켤레에 대한 광고의 딥 링크는, 쇼핑 앱을 열고 해당 신발의 제품 페이지를 표시할 수 있습니다.

Flutter는 iOS, Android 및 웹에서 딥 링크를 지원합니다. 
URL을 열면, 앱에 해당 화면이 표시됩니다. 
다음 단계를 통해, 명명된 경로(named routes, [`routes`][routes] 매개변수 또는 [`onGenerateRoute`][onGenerateRoute] 사용)를 사용하거나. [`Router`][Router] 위젯을 사용하여, 경로를 시작하고 표시할 수 있습니다.

:::note
명명된 경로(Named routes)는 더 이상 대부분의 애플리케이션에 권장되지 않습니다. 
자세한 내용은, [탐색 개요][navigation overview] 페이지의 [제한 사항][Limitations]을 참조하세요.
:::

[Limitations]: /ui/navigation#limitations
[navigation overview]: /ui/navigation

웹 브라우저에서 앱을 실행하는 경우, 추가 설정이 필요하지 않습니다. 
Route paths는 iOS 또는 Android 딥 링크와 동일한 방식으로 처리됩니다. 
기본적으로, 웹 앱은 `/#/path/to/app/screen` 패턴을 사용하여, URL 조각에서 딥 링크 경로를 읽지만, 
앱에 대한 [URL 전략 구성][configuring the URL strategy]을 통해 이를 변경할 수 있습니다.

시각적 학습자라면, 다음 비디오를 확인하세요.

{% ytEmbed 'KNAb2XL7k2g', 'Deep linking in Flutter' %}

## 시작하기 {:#get-started}

시작하려면, Android 및 iOS용 쿡북을 참조하세요.

<div class="card-grid">
  <a class="card" href="/cookbook/navigation/set-up-app-links">
    <div class="card-body">
      <header class="card-title text-center">
        Android
      </header>
    </div>
  </a>
  <a class="card" href="/cookbook/navigation/set-up-universal-links">
    <div class="card-body">
      <header class="card-title text-center">
        iOS
      </header>
    </div>
  </a>
</div>

## 플러그인 기반 딥 링크에서 마이그레이션 {:#migrating-from-plugin-based-deep-linking}

[딥 링크와 Flutter 애플리케이션][plugin-linking] (Medium의 무료 기사)에서 설명한 대로 딥 링크를 처리하는 플러그인을 작성했다면, 
`Info.plist`에 `FlutterDeepLinkingEnabled`를 추가하거나, 
`AndroidManifest.xml`에 `flutter_deeplinking_enabled`를 추가하여, 이 동작을 옵트인할 때까지 계속 작동합니다.

## 동작 {:#behavior}

동작은 플랫폼과 앱이 시작되어 실행 중인지 여부에 따라 약간씩 다릅니다.

| 플랫폼 / 시나리오      | Navigator 사용                                                     | Router 사용                                                                                                                                                                                               |
|--------------------------|---------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| iOS (실행안됨)       | 앱은 initialRoute("/")를 가져오고, 잠시 후 pushRoute를 가져옵니다. | 앱은 initialRoute("/")를 가져오고, 잠시 후 RouteInformationParser를 사용하여 route를 파싱하고, RouterDelegate.setNewRoutePath를 호출합니다. 이를 통해 Navigator가 해당 Page에 구성됩니다. |
| Android (실행안됨) | 앱은 경로("/deeplink")를 포함하는 initialRoute를 가져옵니다.            | 앱은 initialRoute("/deeplink")를 가져와, RouteInformationParser에 전달하여 route를 파싱하고, RouterDelegate.setNewRoutePath를 호출합니다. 이를 통해 Navigator가 해당 Page에 구성됩니다.   |
| iOS (실행됨)           | pushRoute가 호출됩니다.                                               | Path가 파싱되고, Navigator가 새로운 Page 세트로 구성됩니다.                                                                                                                                   |
| Android (실행됨)       | pushRoute가 호출됩니다.                                                 | Path가 파싱되고, Navigator가 새로운 Page 세트로 구성됩니다.                                                                                                                                   |

{:.table .table-striped}

[`라우터`][Router] 위젯을 사용하면, 앱이 실행되는 동안 새로운 딥 링크가 열리면, 앱이 현재 페이지 세트를 바꿀 수 있습니다.

## 더 알아보기 {:#to-learn-more}

* [Flutter의 새로운 네비게이션 및 라우팅 시스템 학습][Learning Flutter's new navigation and routing system]은
Router 시스템에 대한 소개를 제공합니다.
* [Flutter 딥 링크에 대한 심층 분석][io-dl] Google I/O 2023 비디오
* [Flutter 딥 링크: 완벽한 가이드][Flutter Deep Linking: The Ultimate Guide],
Flutter에서 딥 링크를 구현하는 방법을 보여주는 단계별 튜토리얼입니다.

[io-dl]: {{site.yt.watch}}?v=6RxuDcs6jVw&t=3s
[Learning Flutter's new navigation and routing system]: {{site.flutter-medium}}/learning-flutters-new-navigation-and-routing-system-7c9068155ade
[routes]: {{site.api}}/flutter/material/MaterialApp/routes.html
[onGenerateRoute]: {{site.api}}/flutter/material/MaterialApp/onGenerateRoute.html
[Router]: {{site.api}}/flutter/widgets/Router-class.html
[plugin-linking]: {{site.medium}}/flutter-community/deep-links-and-flutter-applications-how-to-handle-them-properly-8c9865af9283
[Flutter Deep Linking: The Ultimate Guide]: https://codewithandrea.com/articles/flutter-deep-links/

[configuring the URL strategy]: /ui/navigation/url-strategies
