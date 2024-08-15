---
# title: What's new in the docs
title: 문서의 새로운 내용
# description: >-
#   A list of what's new on docs.flutter.dev and related documentation sites.
description: >-
  docs.flutter.dev와 관련 문서 사이트의 새로운 내용 리스트입니다.
---

이 페이지에는 Flutter 웹사이트와 블로그의 최신 소식과 최신 공지 사항이 포함되어 있습니다. 
[새로운 소식 아카이브][what's new archive] 페이지에서 이전 새로운 소식 정보를 확인하세요. 
Flutter SDK [릴리스 노트][release notes]도 확인할 수 있습니다.

중요한 변경 사항을 포함한 Flutter 공지 사항을 최신 상태로 유지하려면, 
[flutter-announce][] Google 그룹에 가입하세요.

Dart의 경우, [Dart Announce][] Google 그룹에 가입하고,
[Dart 변경로그][Dart changelog]를 검토할 수 있습니다.

[Dart Announce]: {{site.groups}}/a/dartlang.org/g/announce
[Dart changelog]: {{site.github}}/dart-lang/sdk/blob/main/CHANGELOG.md
[flutter-announce]: {{site.groups}}/forum/#!forum/flutter-announce
[release notes]: /release/release-notes

## 2024/08/07: I/O Connect Beijing 3.24 릴리스 {:#07-august-2024-io-connect-beijing-3-24-release}

Flutter 3.24가 출시되었습니다! 
자세한 내용은 [Flutter 3.24 엄브렐라 블로그 게시물][3.24-umbrella]와 
[Flutter 3.24 기술 블로그 게시물][3.24-tech]를 확인하세요. 
[Dart 3.5 릴리스][Dart 3.5 release] 블로그 게시물도 확인해 보세요.

[3.24-tech]: {{site.flutter-medium}}/whats-new-in-flutter-3-24-6c040f87d1e4
[3.24-umbrella]: {{site.flutter-medium}}/flutter-3-24-dart-3-5-204b7d20c45d
[Dart 3.5 release]: {{site.medium}}/dartlang/dart-3-5-6ca36259fa2f

**3.22 릴리스 이후 업데이트 또는 추가된 문서**

이 웹사이트 릴리스에는 몇 가지 중요한 업데이트가 포함되어 있습니다!

* 업데이트된 위젯 카탈로그:
  * [Cupertino 카탈로그][Cupertino catalog]에 누락된 위젯 37개를 추가하고, 
    업데이트된 `CupertinoActionSheet` 위젯에 대한 새로운 스크린샷을 추가했습니다.
  * 새로운 [`CarouselView`][] 위젯을 추가했습니다.
  * `CupertinoButton`과 `CupertinoTextField`도 동작이 업데이트되었습니다.
* [iOS 플러그인][iOS plugins]과 [iOS 앱][iOS apps]에 
  Swift Package Manager 지원을 추가하는 방법에 대한 새로운 가이드입니다. 
  (앱의 모든 종속성이 마이그레이션될 때까지, Flutter는 CocoaPods를 계속 사용합니다.)
* 업데이트된 웹 문서:
  * [웹에 Flutter 임베딩][Embedding Flutter on the web], 
    다중 보기(multi-view) 모드 활성화 방법 포함
  * [Flutter 앱에 웹 콘텐츠 임베딩][Embedding web content into a Flutter app]
* Android 14 업데이트:
  Android 14에서 실행되는 Android 기기를 사용하는 경우, 
  이제 Android의 [예측 뒤로 제스처(predictive back gesture)][predictive back gesture]를 지원할 수 있습니다.
* iOS 18 업데이트:
  iOS 18 릴리스는 이 릴리스 시점에는 베타 버전입니다. 
  이러한 iOS 18 기능은 이미 Flutter에서 활성화되어 있으며, 이제 문서에 언급되어 있습니다.
  * Flutter 앱에서 [iOS 앱 확장][iOS app extension]을 사용하여, 커스텀 토글을 만듭니다. 
    그러면 사용자가 제어 센터를 커스터마이즈할 때 앱의 토글을 추가할 수 있습니다.
  * [색상이 적용된 앱 아이콘][Tinted app icons]이 지원됩니다.
* [첫 주 경험][First week experience] 페이지 중 두 개가 업데이트되었습니다.
  * [Flutter 기본 사항][Flutter fundamentals]
  * [레이아웃][Layout]
  이 페이지가 새로운 Flutter 개발자에게 도움이 되기를 바랍니다.
* DevTools에도 업데이트가 있습니다. 릴리스 노트를 확인하세요.
  [DevTools 2.35.0][], [DevTools 2.36.0][], [DevTools 2.37.2][].

[`CarouselView`]: {{site.api}}/flutter/material/CarouselView-class.html
[Cupertino catalog]: /ui/widgets/cupertino
[DevTools 2.35.0]: /tools/devtools/release-notes/release-notes-2.35.0
[DevTools 2.36.0]: /tools/devtools/release-notes/release-notes-2.36.0
[DevTools 2.37.2]: /tools/devtools/release-notes/release-notes-2.37.2
[Embedding Flutter on the web]: /platform-integration/web/embedding-flutter-web
[Embedding web content into a Flutter app]: /platform-integration/web/web-content-in-flutter
[First week experience]: /get-started/fwe
[Flutter fundamentals]: /get-started/fwe/fundamentals
[iOS app extension]: /platform-integration/ios/app-extensions
[iOS plugins]: /packages-and-plugins/swift-package-manager/for-plugin-authors
[iOS apps]: /packages-and-plugins/swift-package-manager/for-app-developers
[Layout]: /get-started/fwe/layout
[predictive back gesture]: /platform-integration/android/predictive-back
[Tinted app icons]: /deployment/ios#add-an-app-icon

## 기타 {:#other}
* 새로운 실험적 Flutter GPU API에 관심이 있다면, 
  [Flutter GPU 블로그 게시물][Flutter GPU blog post]을 확인하세요.
* Flutter 위키가 분할되어 관련 GitHub 리포로 이동되어, 해당 정보를 최신 상태로 유지하기가 더 쉬워졌습니다.

[Flutter GPU blog post]: {{site.flutter-medium}}/getting-started-with-flutter-gpu-f33d497b7c11

## 2024/05/14: Google I/O 3.22 릴리즈 {:#14-may-2024-google-io-3-22-release}

Flutter 3.22가 출시되었습니다! 자세한 내용은 [Flutter 3.22 엄브렐라 블로그 게시물][3.22-umbrella]와 [Flutter 3.22 기술 블로그 게시물][3.22-tech]을 확인하세요.

[Dart 3.4 릴리스][Dart 3.4 release] 블로그 게시물도 확인해 보세요. 
특히, Dart는 이제 JSON 데이터를 직렬화하고 역직렬화하기 위한 "내장된" 언어 매크로인 `JsonCodable`을 제공합니다. 
향후(미지정) Dart 릴리스에서는 사용자가 직접 매크로를 만들 수 있습니다. 
자세한 내용은, [dart.dev/go/macros][]를 확인하세요.

[3.22-tech]: {{site.flutter-medium}}/whats-new-in-flutter-3-22-fbde6c164fe3
[3.22-umbrella]: {{site.flutter-medium}}/io24-5e211f708a37
[Dart 3.4 release]: {{site.medium}}/dartlang/dart-3-4-bd8d23b4462a
[dart.dev/go/macros]: http://dart.dev/go/macros

**3.19 릴리스 이후 업데이트되거나 추가된 문서**

* [적응형 및 반응형 디자인][Adaptive and Responsive design]에 대한 새로운 7페이지 섹션. 
  (이것은 이 주제에 대한 이전의 다소 산발적인 문서를 대체합니다.)
* 첫 번째 Flutter 코드랩을 진행한 새로운 Flutter 개발자를 위해, 
  초기 단계를 넘어서는 방법에 대한 "다음 단계" 조언을 추가했습니다. 
  **FWE**라고도 하는 [Flutter의 첫 주 경험(First week experience of Flutter)][First week experience of Flutter]에 대한 문서를 확인하세요.
* [Flutter 설치][Flutter install] 문서가 개편되었습니다.
* 새로운 코드랩 3개와 게임 툴킷에 대한 새로운 가이드가 있습니다. 
  추가된 항목 목록을 보려면 업데이트된 [캐주얼 게임 툴킷][Casual Games Toolkit] 페이지를 확인하세요.
* 플레이버 페이지에 새로운 섹션인, [플레이버에 따라 에셋을 조건부로 번들링][Conditionally bundling assets based on flavor]이 추가되었습니다.
* 웹 어셈블리(Wasm)에 대한 Flutter 지원이 이제 안정화되었습니다. 
  자세한 내용은 업데이트된 [웹 어셈블리(Wasm) 지원][Support for WebAssembly (Wasm)] 페이지를 확인하세요.
* DevTools에는 Android에서 딥 링크를 평가하기 위한 새로운 화면이 있습니다. 
  자세한 내용은 새 페이지인 [딥 링크 검증][Validate deep links]을 확인하세요.
* Flutter SDK 릴리스 3.22 이상을 위한 웹 부트스트래핑을 설명하는 새 페이지가 있습니다. 
  [Flutter 웹 앱 초기화][Flutter web app initialization]를 확인하세요.
* 이제 런타임에 애셋을 다른 형식으로 변환하는 코드를 제공할 수 있습니다. 
  자세한 내용은 [빌드 시 애셋 변환][Transforming assets at build time]을 확인하세요.

**웹사이트 인프라**

* 웹사이트에 기여했다면, 최근 몇 가지 변경 사항을 알아차렸을 것입니다. 
  즉, 웹사이트 인프라가 업데이트되었고 새로운 워크플로가 더 간단해졌습니다. 
  자세한 내용은 [웹사이트 README][website README]를 확인하세요.
* 또한 사이드 내비게이션의 **앱 솔루션** 하위 메뉴에 **AI** 섹션과 향상된 **수익화** 섹션이 추가된 것을 알아차렸을 것입니다.
  이는 몇 가지 변경 사항입니다.

[Adaptive and Responsive design]: /ui/adaptive-responsive
[Casual Games Toolkit]: /resources/games-toolkit
[Conditionally bundling assets based on flavor]: /deployment/flavors#conditionally-bundling-assets-based-on-flavor
[First week experience of Flutter]: /get-started/fwe
[Flutter install]: /get-started/install
[Flutter web app initialization]: /platform-integration/web/initialization
[website README]: {{site.github}}/flutter/website/?tab=readme-ov-file#flutter-documentation-website
[Support for WebAssembly (Wasm)]: /platform-integration/web/wasm
[Transforming assets at build time]: /ui/assets/asset-transformation
[Validate deep links]: /tools/devtools/deep-links

---

For past releases, check out the
[What's new archive][] page.

[What's new archive]: /release/archive-whats-new

