---
title: FAQ
# description: Frequently asked questions and answers about Flutter.
description: Flutter에 대해 자주 묻는 질문과 답변. 
---

## 소개 {:#introduction}

이 페이지는 Flutter에 대해 자주 묻는 몇 가지 질문을 모아놓았습니다. 다음의 전문 FAQ도 확인해 보세요.

* [웹 FAQ][Web FAQ]
* [성능 FAQ][Performance FAQ]

[Web FAQ]: /platform-integration/web/faq
[Performance FAQ]: /perf/faq

### Flutter란 무엇인가요? {:#what-is-flutter}

Flutter는 모바일, 웹, 데스크톱을 위한 아름답고 네이티브로 컴파일된 애플리케이션을, 
단일 코드베이스에서 제작하기 위한 Google의 휴대용 UI 툴킷입니다. 
Flutter는 기존 코드와 함께 작동하며, 전 세계의 개발자와 조직에서 사용되며, 무료 오픈 소스입니다.

### Flutter는 누구를 위한 것인가요? {:#who-is-flutter-for}

사용자에게, Flutter는 아름다운 앱을 현실로 만듭니다.

개발자에게, Flutter는 앱 구축의 진입 장벽을 낮춥니다. 
앱 개발 속도를 높이고 플랫폼 간 앱 제작 비용과 복잡성을 줄입니다.

디자이너에게, Flutter는 고급 사용자 경험을 위한 캔버스를 제공합니다. 
Fast Company는 Flutter를 [10년 동안 최고의 디자인 아이디어 중 하나][one of the top design ideas of the decade]라고 설명했는데, 
일반적인 프레임워크에서 부과하는 타협 없이 개념을 프로덕션 코드로 전환할 수 있는 능력 때문입니다. 
또한 [FlutterFlow][]와 같은 드래그 앤 드롭 도구와, 
[Zapp!][]와 같은 웹 기반 IDE를 사용하여, 생산적인 프로토타입 도구 역할을 합니다.

엔지니어링 관리자와 기업의 경우, Flutter는 앱 개발자를 단일 _모바일, 웹 및 데스크톱 앱 팀_ 으로 통합하여, 
단일 코드베이스에서 여러 플랫폼에 대한 브랜드 앱을 구축할 수 있습니다. 
Flutter는 기능 개발 속도를 높이고 전체 고객 기반에서 릴리스 일정을 동기화합니다.

[FlutterFlow]: https://flutterflow.io/
[Zapp!]: https://zapp.run/
[one of the top design ideas of the decade]: https://www.fastcompany.com/90442092/the-14-most-important-design-ideas-of-the-decade-according-to-the-experts

### Flutter를 사용하려면 얼마나 많은 개발 경험이 필요합니까? {:#how-much-development-experience-do-i-need-to-use-flutter}

Flutter는 객체 지향 개념(클래스, 메서드, 변수 등)과 
명령형 프로그래밍 개념(루프, 조건문 등)에 익숙한 프로그래머에게 접근하기 쉽습니다.

프로그래밍 경험이 거의 없는 사람들이 Flutter를 배우고 프로토타입 제작과 앱 개발을 위해 사용하는 것을 보았습니다.

### Flutter로 어떤 종류의 앱을 만들 수 있나요? {:#what-kinds-of-apps-can-i-build-with-flutter}

Flutter는 Android와 iOS에서 실행되는 모바일 앱과 웹 페이지나 데스크톱에서 실행하려는 상호 작용 앱을 지원하도록 설계되었습니다.

브랜드가 잘 표현된 디자인을 제공해야 하는 앱은 Flutter에 특히 적합합니다. 
그러나, Flutter를 사용하면 Android와 iOS 디자인 언어와 일치하는 픽셀 단위로 완벽한 경험을 만들 수도 있습니다.

Flutter의 [패키지 에코시스템][package ecosystem]은 다양한 하드웨어(예: 카메라, GPS, 네트워크, 스토리지)와 
서비스(예: 결제, 클라우드 스토리지, 인증, [광고][ads])를 지원합니다.

[ads]: {{site.main-url}}/monetization
[package ecosystem]: {{site.pub}}/flutter

### Flutter는 누가 만들었나요? {:#who-makes-flutter}

Flutter는 Google을 비롯한 여러 회사와 개인이 기여한 오픈 소스 프로젝트입니다.

### 누가 Flutter를 사용하나요? {:#who-uses-flutter}

Google 내부 및 외부 개발자는 Flutter를 사용하여 iOS 및 Android용 아름다운 네이티브 컴파일 앱을 빌드합니다. 
이러한 앱에 대해 알아보려면 [showcase][]를 방문하세요.

[showcase]: {{site.main-url}}/showcase

### 어떤 점이 Flutter를 특별하게 하나요? {:#what-makes-flutter-unique}

Flutter는 웹 브라우저 기술이나 각 기기와 함께 제공되는 위젯 세트에 의존하지 않기 때문에, 
모바일 앱을 구축하는 다른 대부분의 옵션과 다릅니다. 
대신, Flutter는 자체 고성능 렌더링 엔진을 사용하여 위젯을 그립니다.

또한, Flutter는 얇은 C/C++ 코드 레이어만 있기 때문에 다릅니다. 
Flutter는 대부분의 시스템(구성(compositing), 제스처, 애니메이션, 프레임워크, 위젯 등)을 
[Dart][] (현대적이고, 간결하며, 객체 지향 언어)로 구현하여, 개발자가 쉽게 읽고, 변경하고, 대체하거나 제거할 수 있습니다. 
이를 통해 개발자는 시스템을 엄청나게 제어할 수 있고, 대부분의 시스템에 대한 접근성에 대한 기준을 상당히 낮출 수 있습니다.

[Dart]: {{site.dart-site}}/

### 다음 프로덕션 앱을 Flutter로 만들어야 할까요? {:#should-i-build-my-next-production-app-with-flutter}

* [Flutter 1][]은 2018년 12월 4일에 출시되었고, 
* [Flutter 2][]는 2021년 3월 3일에 출시되었으며, 
* [Flutter 3][]은 2023년 5월 10일에 출시되었습니다. 

2023년 5월 현재, _100만 개_ 가 넘는 앱이 수억 대의 기기에 Flutter를 사용하여 출시되었습니다. 
[showcase][]에서 일부 샘플 앱을 확인하세요.

Flutter는, 안정성과 성능을 개선하고 일반적으로 요청되는 사용자 기능을 해결하여, 대략 분기별 주기로 업데이트를 제공합니다.

[Flutter 1]: {{site.google-blog}}/2018/12/flutter-10-googles-portable-ui-toolkit.html
[Flutter 2]: {{site.google-blog}}/2021/03/announcing-flutter-2.html
[Flutter 3]: {{site.google-blog}}/flutter/introducing-flutter-3-5eb69151622f

## Flutter는 무엇을 제공하나요? {:#what-does-flutter-provide}

### Flutter SDK에는 무엇이 들어있나요? {:#what-is-inside-the-flutter-sdk}

Flutter에는 다음이 포함됩니다.

* 텍스트에 대한 뛰어난 지원을 제공하는 고도로 최적화된, 모바일 우선 2D 렌더링 엔진
* 현대적인 React 스타일 프레임워크
* Material Design과 iOS 스타일을 구현하는 풍부한 위젯 세트
* 유닛 및 통합 테스트를 위한 API
* 시스템 및 타사 SDK에 연결하기 위한 Interop 및 플러그인 API
* Windows, Linux 및 Mac에서 테스트를 실행하기 위한 헤드리스 테스트 러너
* 앱을 테스트, 디버깅 및 프로파일링하기 위한 [Flutter DevTools][] (Dart DevTools라고도 함)
* 앱을 만들고, 빌드하고, 테스트하고, 컴파일하기 위한 명령줄 도구

### Flutter는 모든 편집기나 IDE와 호환되나요? {:#does-flutter-work-with-any-editors-or-ides}

우리는 [VS Code][], [Android Studio][], [IntelliJ IDEA][]용 플러그인을 제공합니다. 
설정 세부 정보는 [에디터 구성][editor configuration]을 참조하고, 
플러그인 사용 방법에 대한 팁은 [VS Code][] 및 [Android Studio/IntelliJ][]를 참조하세요.

현재 베타 버전인, [Project IDX][]는, 클라우드에서 풀스택, 멀티플랫폼 앱 개발을 위한 AI 지원 작업 공간입니다. 
IDX는 Dart와 Flutter를 지원합니다. 
자세한 내용은 [Project IDX 시작하기][Project IDX Getting Started] 가이드를 확인하세요.

[Project IDX]: https://idx.dev/
[Project IDX Getting Started]: https://developers.google.com/idx/guides/get-started

또는, [Dart 편집][editing Dart]을 지원하는 여러 편집기 중 하나와 함께, 터미널에서 `flutter` 명령을 사용할 수 있습니다.

[Android Studio]: {{site.android-dev}}/studio
[Android Studio/IntelliJ]: /tools/android-studio
[editing Dart]: {{site.dart-site}}/tools
[editor configuration]: /get-started/editor
[IntelliJ IDEA]: https://www.jetbrains.com/idea/
[VS Code]: https://code.visualstudio.com/

### Flutter에는 프레임워크가 포함되어 있나요? {:#does-flutter-come-with-a-framework}

네! Flutter는 현대적인 React 스타일 프레임워크와 함께 제공됩니다. 
Flutter의 프레임워크는 레이어화되고 커스터마이즈가 가능하도록 (선택 사항) 설계되었습니다. 
개발자는 프레임워크의 일부만 사용하거나, 프레임워크의 상위 레이어를 완전히 대체할 수도 있습니다.

### Flutter에는 위젯이 포함되어 있나요? {:#does-flutter-come-with-widgets}

네! Flutter는 [고품질 Material Design 및 Cupertino(iOS 스타일) 위젯][widgets], 
레이아웃 및 테마 세트와 함께 제공됩니다. 
물론, 이러한 위젯은 시작점일 뿐입니다. 
Flutter는 사용자 고유의 위젯을 쉽게 만들거나, 기존 위젯을 커스터마이즈 할 수 있도록 설계되었습니다.

[widgets]: /ui/widgets

### Flutter는 Material 디자인을 지원하나요? {:#does-flutter-support-material-design}

네! Flutter와 Material 팀은 긴밀히 협력하고 있으며, Material은 완벽하게 지원됩니다. 
자세한 내용은 [위젯 카탈로그][widget catalog]에서 Material 2 및 Material 3 위젯을 확인하세요.

[widget catalog]: /ui/widgets/material

### Flutter에는 테스트 프레임워크가 포함되어 있나요? {:#does-flutter-come-with-a-testing-framework}

네, Flutter는 유닛 및 통합 테스트를 작성하기 위한 API를 제공합니다. 
[Flutter로 테스트하기][testing with Flutter]에 대해 자세히 알아보세요.

저희는 자체 테스트 기능을 사용하여 SDK를 테스트하고, 모든 커밋에서 [테스트 커버리지][test coverage]를 측정합니다.

[test coverage]: https://coveralls.io/github/flutter/flutter?branch=master
[testing with Flutter]: /testing/overview

### Flutter에는 디버깅 도구가 포함되어 있나요? {:#does-flutter-come-with-debugging-tools}

예, Flutter에는 [Flutter DevTools][] (Dart DevTools라고도 함)가 함께 제공됩니다. 
자세한 내용은 [Flutter로 디버깅][Debugging with Flutter] 및 [Flutter DevTools][] 문서를 참조하세요.

[Debugging with Flutter]: /testing/debugging
[Flutter DevTools]: /tools/devtools

### Flutter에는 종속성 주입 프레임워크가 포함되어 있나요? {:#does-flutter-come-with-a-dependency-injection-framework}

우리는 의견이 있는 솔루션을 제공하지 않지만, 
[injectable][], [get_it][], [kiwi][], [riverpod][]와 같이, 
종속성 주입 및 서비스 위치를 제공하는 다양한 패키지가 있습니다.

[get_it]: {{site.pub}}/packages/get_it
[injectable]: {{site.pub}}/packages/injectable
[kiwi]: {{site.pub}}/packages/kiwi
[riverpod]: {{site.pub}}/packages/riverpod

## 기술 {:#technology}

### Flutter는 어떤 기술로 만들어졌나요? {:#what-technology-is-flutter-built-with}

Flutter는 C, C++, Dart, Skia (2D 렌더링 엔진), [Impeller][] (iOS의 기본 렌더링 엔진)로 구축되었습니다. 
주요 구성 요소에 대한 더 나은 그림은 이 [아키텍처 다이어그램][architecture diagram]을 참조하세요. 
Flutter의 레이어화된 아키텍처에 대한 더 자세한 설명은 [아키텍처 개요][architectural overview]를 읽어보세요.

[architectural overview]: /resources/architectural-overview
[architecture diagram]: https://docs.google.com/presentation/d/1cw7A4HbvM_Abv320rVgPVGiUP2msVs7tfGbkgdrTy0I/edit#slide=id.gbb3c3233b_0_162
[Impeller]: /perf/impeller

### Flutter는 어떻게 Android에서 내 코드를 실행하나요? {:#run-android}

엔진의 C 및 C++ 코드는 Android의 NDK로 컴파일됩니다. 
Dart 코드(SDK와 사용자 코드 모두)는 네이티브, ARM 및 x86-64 라이브러리로 사전 컴파일(AOT, ahead-of-time)됩니다.
이러한 라이브러리는 "러너" Android 프로젝트에 포함되며, 전체가 `.apk`에 내장됩니다. 
앱이 실행되면, Flutter 라이브러리가 로드됩니다. 
모든 렌더링, 입력 또는 이벤트 처리 등은, 컴파일된 Flutter 및 앱 코드에 위임됩니다. 
이는 많은 게임 엔진이 작동하는 방식과 유사합니다.

디버그 모드에서, Flutter는 가상 머신(VM)을 사용하여 코드를 실행하여, stateful 핫 리로드를 활성화합니다. 
이 기능을 사용하면, 재컴파일 없이 실행 중인 코드를 변경할 수 있습니다. 
이 모드에서 실행할 때, 앱의 오른쪽 상단 모서리에 "debug" 배너가 표시되어, 성능이 완성된 릴리스 앱의 특징이 아님을 상기시켜줍니다.

### Flutter는 어떻게 iOS에서 내 코드를 실행하나요? {:#run-ios}

엔진의 C 및 C++ 코드는 LLVM으로 컴파일됩니다. 
Dart 코드(SDK와 사용자 코드 모두)는 사전(AOT, ahead-of-time) 컴파일되어 네이티브, ARM 라이브러리로 제공됩니다. 
해당 라이브러리는 "runner" iOS 프로젝트에 포함되고, 전체가 `.ipa`에 내장됩니다. 
앱이 실행되면 Flutter 라이브러리가 로드됩니다. 
모든 렌더링, 입력 또는 이벤트 처리 등은 컴파일된 Flutter 및 앱 코드에 위임됩니다. 
이는 많은 게임 엔진이 작동하는 방식과 유사합니다.

디버그 모드에서, Flutter는 가상 머신(VM)을 사용하여 코드를 실행하여, stateful 핫 리로드를 활성화합니다. 
이 기능을 사용하면, 재컴파일 없이 실행 중인 코드를 변경할 수 있습니다. 
이 모드에서 실행할 때, 앱의 오른쪽 상단 모서리에 "debug" 배너가 표시되어, 성능이 완성된 릴리스 앱의 특징이 아님을 상기시켜줍니다.

### 플러터는 내 운영체제에 내장된 플랫폼 위젯을 사용하나요? {:#does-flutter-use-my-operating-systems-built-in-platform-widgets}

아니요. 대신, Flutter는 Flutter의 프레임워크와 엔진에서 관리하고 렌더링하는, 
위젯 세트(Material Design 및 Cupertino(iOS 스타일) 위젯 포함)를 제공합니다. 
[Flutter 위젯 카탈로그][catalog of Flutter's widgets]를 탐색할 수 있습니다.

최종 결과는 더 높은 품질의 앱이라고 믿습니다. 
내장 플랫폼 위젯을 재사용하면, Flutter 앱의 품질과 성능은 해당 위젯의 유연성과 품질에 따라 제한됩니다.

예를 들어, Android에는, 하드코딩된 제스처 세트와 이를 구별하기 위한 고정된 규칙이 있습니다. 
Flutter에서는, [제스처 시스템][gesture system]에서 일류 참여자(first class participant)인 자체 제스처 인식기를 작성할 수 있습니다. 
게다가, 다른 사람이 작성한 두 위젯을 조정하여 제스처를 구별할 수 있습니다.

최신 앱 디자인 트렌드는 디자이너와 사용자가 모션이 풍부한 UI와 브랜드 우선 디자인을 원한다는 것을 보여줍니다. 
이러한 레벨의 커스터마이즈되고, 아름다운 디자인을 달성하기 위해, Flutter는 빌트인 위젯 대신 픽셀을 구동하도록 설계되었습니다.

동일한 렌더러, 프레임워크 및 위젯 세트를 사용하면, 다양한 기능 세트와 API 특성을 정렬하기 위해, 
신중하고 비용이 많이 드는 계획을 세우지 않고도, 
동일한 코드베이스에서 여러 플랫폼에 게시하기가 더 쉽습니다.

모든 코드에 단일 언어, 단일 프레임워크 및 단일 라이브러리 세트를 사용함으로써(각 플랫폼에서 UI가 다르든 아니든), 
앱 개발 및 유지 관리 비용을 낮추는 데 도움이 됩니다.

[catalog of Flutter's widgets]: /ui/widgets
[gesture system]: /ui/interactivity/gestures

### 모바일 OS가 업데이트되어 새로운 위젯이 도입되면 어떻게 되나요? {:#what-happens-when-my-mobile-os-updates-and-introduces-new-widgets}

Flutter 팀은 iOS 및 Android에서 새로운 모바일 위젯의 채택과 수요를 주시하고 있으며, 
커뮤니티와 협력하여 새로운 위젯에 대한 지원을 구축하고자 합니다. 
이 작업은 낮은 레벨 프레임워크 기능, 새로운 구성 가능한 위젯 또는 새로운 위젯 구현의 형태로 제공될 수 있습니다.

Flutter의 레이어화된 아키텍처는 수많은 위젯 라이브러리를 지원하도록 설계되었으며, 
커뮤니티가 위젯 라이브러리를 구축하고 유지 관리하도록 장려하고 지원합니다.

### 모바일 OS가 업데이트되어 새로운 플랫폼 기능이 도입되면 어떻게 되나요? {:#what-happens-when-my-mobile-os-updates-and-introduces-new-platform-capabilities}

Flutter의 상호 운용성 및 플러그인 시스템은 개발자가 새로운 모바일 OS 기능과 역량에 즉시 액세스할 수 있도록 설계되었습니다. 
개발자는 Flutter 팀이 새로운 모바일 OS 역량을 공개할 때까지 기다릴 필요가 없습니다.

### Flutter 앱을 만들려면 어떤 운영 체제를 사용해야 하나요? {:#what-operating-systems-can-i-use-to-build-a-flutter-app}

Flutter는 Linux, macOS, ChromeOS, Windows를 사용한 개발을 지원합니다.

### Flutter는 어떤 언어로 작성되었나요? {:#what-language-is-flutter-written-in}

[Dart][]는 클라이언트 앱에 최적화된 빠르게 성장하는 최신 언어입니다. 
기본 그래픽 프레임워크와 Dart 가상 머신은 C/C++로 구현됩니다.

### Flutter가 Dart를 사용하기로 결정한 이유는 무엇입니까? {:#why-did-flutter-choose-to-use-dart}

초기 개발 단계에서, Flutter 팀은 많은 언어와 런타임을 살펴보았고, 궁극적으로 프레임워크와 위젯에 Dart를 채택했습니다. Flutter는 평가를 위해 4가지 주요 차원을 사용했으며, 프레임워크 작성자, 개발자, 최종 사용자의 요구 사항을 고려했습니다. 
많은 언어가 일부 요구 사항을 충족하는 것으로 나타났지만, 
Dart는 모든 평가 차원에서 높은 점수를 받았고, 모든 요구 사항과 기준을 충족했습니다.

Dart 런타임과 컴파일러는 Flutter의 두 가지 중요한 기능, 즉, 
(1) 타입이 있는 언어에서 모양 변경 및 stateful 핫 리로드를 허용하는 JIT 기반 빠른 개발 주기와 
(2) 효율적인 ARM 코드를 생성하여 프로덕션 배포의 빠른 시작과 예측 가능한 성능을 제공하는 Ahead-of-Time 컴파일러의 조합을 지원합니다.

또한, 우리는 Dart 커뮤니티와 긴밀히 협력할 기회가 있으며, 
이 커뮤니티는 Flutter에서 Dart를 개선하는 데 적극적으로 리소스를 투자하고 있습니다. 
예를 들어, Dart를 채택했을 때, 이 언어에는 예측 가능한 고성능을 달성하는 데 중요한, 
네이티브 바이너리를 생성하기 위한 사전(ahead-of-time) 툴체인이 없었지만, 
Dart 팀이 Flutter를 위해 구축했기 때문에 이제 이 언어에는 있습니다. 
마찬가지로, Dart VM은 이전에 처리량(throughput)에 최적화되었지만, 
이제 팀은 Flutter의 워크로드에 더 중요한 지연 시간(latency)에 대해 VM을 최적화하고 있습니다.

Dart는 다음과 같은 주요 기준에서 높은 점수를 받았습니다.

_개발자 생산성_
: Flutter의 주요 가치 제안 중 하나는 개발자가 동일한 코드베이스로 iOS와 Android용 앱을 만들 수 있도록 하여, 
엔지니어링 리소스를 절약한다는 것입니다. 생산성이 높은 언어를 사용하면 개발자의 속도가 더욱 빨라지고, 
Flutter가 더 매력적으로 보입니다. 이는 프레임워크 팀과 개발자 모두에게 매우 중요했습니다. 
Flutter의 대부분은 사용자에게 제공하는 것과 동일한 언어로 빌드되므로, 
개발자를 위한 프레임워크와 위젯의 접근성이나 가독성을 희생하지 않고도, 
100,000줄의 코드에서 생산성을 유지해야 합니다.

_객체 지향_
: Flutter의 경우, Flutter의 문제 도메인에 적합한 언어가 필요합니다. 시각적 사용자 경험을 만드는 것입니다. 
업계는 객체 지향 언어로 사용자 인터페이스 프레임워크를 구축한 수십 년의 경험을 가지고 있습니다. 
객체 지향이 아닌 언어를 사용할 수도 있지만, 
이는 여러 가지 어려운 문제를 해결하기 위해 바퀴를 새로 발명해야 한다는 것을 의미합니다. 
게다가, 대부분의 개발자는 객체 지향 개발 경험이 있어, Flutter로 개발하는 방법을 더 쉽게 배울 수 있습니다.

_예측 가능하고, 고성능_
: Flutter를 통해, 개발자가 빠르고 유동적인 사용자 경험을 만들 수 있도록 지원하고자 합니다. 
이를 위해서는, 모든 애니메이션 프레임에서 상당한 양의 최종 개발자 코드를 실행할 수 있어야 합니다. 
즉, 프레임이 드롭되는 주기적 일시 중지 없이, 고성능과 예측 가능한 성능을 모두 제공하는 언어가 필요합니다.

_빠른 할당_
: Flutter 프레임워크는, 작고 수명이 짧은 할당을 효율적으로 처리하는, 
기본 메모리 할당자에 크게 의존하는 함수형 스타일 흐름을 사용합니다. 
이 스타일은 이 속성이 있는 언어에서 개발되었으며, 이 기능이 없는 언어에서는 효율적으로 작동하지 않습니다.

### Flutter는 모든 Dart 코드를 실행할 수 있나요? Can Flutter run any Dart code? {:#can-flutter-run-any-dart-code}

Flutter는 `dart:mirrors` 또는 `dart:html`을 
직접 또는 전이적으로(transitively) import 하지 않는 Dart 코드를 실행할 수 있습니다.

### Flutter 엔진은 얼마나 큰가요? {:#how-big-is-the-flutter-engine}

2021년 3월에, 우리는 [최소한의 Flutter 앱][minimal Flutter app] (Material 컴포넌트 없음, 단일 `Center` 위젯만 있고, `flutter build apk --split-per-abi`로 빌드됨)의 다운로드 크기를 측정하여, 
릴리스 APK로 번들링하고 압축한 결과, ARM32의 경우 약 4.3MB, ARM64의 경우 4.8MB였습니다.

ARM32에서, 코어 엔진은 약 3.4MB(압축), 프레임워크 + 앱 코드는 약 765KB(압축), LICENSE 파일은 58KB(압축), 
필요한 Java 코드(`classes.dex`)는 120KB(압축)입니다.

ARM64에서, 코어 엔진은 약 4.0MB(압축)이고, 프레임워크 + 앱 코드는 약 659KB(압축)이고, LICENSE 파일은 58KB(압축)이고, 
필요한 Java 코드(`classes.dex`)는 120KB(압축)입니다.

이 숫자는 [Android Studio][built into Android Studio]에 내장된, 
[apkanalyzer][apkanalyzer]를 사용하여 측정되었습니다.

iOS에서, 동일한 앱의 릴리스 IPA는 Apple의 App Store Connect에서 보고한 대로, 
iPhone X에서 10.9MB의 다운로드 크기를 가집니다. 
IPA는 APK보다 큰데, 그 이유는 주로 Apple이 IPA 내의 바이너리를 암호화하여, 압축 효율을 떨어뜨리기 때문입니다.
(Apple의 [QA1795][]의 [iOS 앱 스토어별 고려 사항][iOS App Store Specific Considerations] 섹션 참조)

:::note
릴리스 엔진 바이너리는 LLVM IR(비트코드)을 포함하곤 했습니다. 
하지만 Apple이 [Xcode 14에서 비트코드를 deprecated][deprecated bitcode in Xcode 14]하고, 지원을 중단했기 때문에, 
Flutter 3.7 릴리스에서 제거되었습니다.
:::

물론, 우리는 당신이 당신의 앱을 직접 측정하는 것을 권장합니다. 
그렇게 하려면, [앱의 크기 측정][Measuring your app's size]을 참조하십시오.

[apkanalyzer]: {{site.android-dev}}/studio/command-line/apkanalyzer
[built into Android Studio]: {{site.android-dev}}/studio/build/apk-analyzer
[deprecated bitcode in Xcode 14]: {{site.apple-dev}}/documentation/xcode-release-notes/xcode-14-release-notes
[iOS App Store Specific Considerations]: {{site.apple-dev}}/library/archive/qa/qa1795/_index.html#//apple_ref/doc/uid/DTS40014195-CH1-APP_STORE_CONSIDERATIONS
[Measuring your app's size]: /perf/app-size
[minimal Flutter app]: {{site.repo.flutter}}/tree/75228a59dacc24f617272f7759677e242bbf74ec/examples/hello_world
[QA1795]: {{site.apple-dev}}/library/archive/qa/qa1795/_index.html

### Flutter에서는 픽셀을 어떻게 정의하나요? {:#how-does-flutter-define-a-pixel}

Flutter는 논리적 픽셀을 사용하고, 종종 이를 단순히 "픽셀"이라고 부릅니다. 
Flutter의 [`devicePixelRatio`][]는 물리적 픽셀과 논리적 CSS 픽셀 간의 비율을 표현합니다.

[`devicePixelRatio`]: {{site.api}}/flutter/dart-html/Window/devicePixelRatio.html

## 할 수 있는 것 {:#capabilities}

### 어떤 종류의 앱 성능을 기대할 수 있나요? {:#what-kind-of-app-performance-can-i-expect}

뛰어난 성능을 기대할 수 있습니다. 
Flutter는 개발자가 쉽게 일정한 60fps를 달성할 수 있도록 설계되었습니다. 
Flutter 앱은 네이티브 컴파일된 코드를 사용하여 실행되며, 인터프리터가 관여하지 않습니다. 
즉, Flutter 앱이 빠르게 시작됩니다.

### 어떤 종류의 개발자 주기를 기대할 수 있나요? 편집과 새로 고침 사이에 얼마나 걸리나요? {:#hot-reload}

Flutter는 _핫 리로드_ 개발자 주기를 구현합니다. 
기기나 에뮬레이터/시뮬레이터에서, 1초 미만의 리로드 시간을 기대할 수 있습니다.

Flutter의 핫 리로드는 _stateful_ 이므로, 리로드 후에도 앱 상태가 유지됩니다. 
즉, 리로드할 때마다 홈 화면에서 시작하지 않고도, 앱에 깊이 중첩된 화면에서 빠르게 반복할 수 있습니다.

### _핫 리로드_ 는 _핫 리스타트_ 와 어떻게 다릅니까? {:#how-is-hot-reload-different-from-hot-restart}

핫 리로드는 업데이트된 소스 코드 파일을 실행 중인 Dart VM(가상 머신)에 주입하여 작동합니다. 
이는 새로운 클래스를 추가할 뿐만 아니라, 기존 클래스에 메서드와 필드를 추가하고, 기존 함수를 변경합니다. 

핫 리스타트는 상태를 앱의 초기 상태로 재설정합니다.

자세한 내용은 [핫 리로드][Hot reload]를 참조하세요.

[Hot reload]: /tools/hot-reload

### Flutter 앱을 어디에 배포할 수 있나요? {:#where-can-i-deploy-my-flutter-app}

Flutter 앱을 iOS, Android, [웹][web], [데스크톱][desktop]에 컴파일하고 배포할 수 있습니다.

[desktop]: /platform-integration/desktop
[web]: /platform-integration/web

### Flutter는 어떤 기기와 OS 버전에서 실행되나요? {:#what-devices-and-os-versions-does-flutter-run-on}

* 저희는 다양한 로우엔드에서 하이엔드 플랫폼에서 Flutter를 실행하도록 지원하고 테스트합니다. 
  저희가 테스트하는 플랫폼의 자세한 리스트는, [지원 플랫폼][supported platforms] 리스트를 참조하세요.

* Flutter는 `x86-64`, `armeabi-v7a`, `arm64-v8a`에 대한 
  사전 컴파일(AOT, ahead-of-time) 라이브러리 빌드를 지원합니다.

* ARMv7 또는 ARM64용으로 빌드된 앱은 많은 x86-64 Android 기기에서 정상적으로 실행됩니다. (ARM 에뮬레이션 사용)

* 저희는 다양한 플랫폼에서 Flutter 앱을 개발하도록 지원합니다. 
  각 [개발 운영 체제][install]에 나열된 시스템 요구 사항을 참조하세요.

[install]: /get-started/install
[supported platforms]: /reference/supported-platforms

### Flutter는 웹에서 실행되나요? {:#does-flutter-run-on-the-web}

네, stable 채널에서 웹 지원을 이용할 수 있습니다. 자세한 내용은 [웹 지침][web instructions]을 확인하세요.

[web instructions]: /platform-integration/web/building

### Flutter를 사용하여 데스크톱 앱을 만들 수 있나요? {:#can-i-use-flutter-to-build-desktop-apps}

네, Windows, macOS, Linux에서는 데스크톱 지원이 안정적으로 제공됩니다.

### 기존 네이티브 앱 내에서 Flutter를 사용할 수 있나요? {:#can-i-use-flutter-inside-of-my-existing-native-app}

네, 자세한 내용은 저희 웹사이트의 [앱에 추가][add-to-app] 섹션에서 확인하세요.

[add-to-app]: /add-to-app

### 플랫폼 서비스와 센서, 로컬 스토리지와 같은 API에 액세스할 수 있나요? {:#can-i-access-platform-services-and-apis-like-sensors-and-local-storage}

네. Flutter는 개발자에게 _일부_ 플랫폼별 서비스와 운영 체제의 API에 대한 기본 제공 액세스를 제공합니다. 
그러나, 대부분의 크로스 플랫폼 API에서 발생하는 "최소 공통 분모(lowest common denominator)" 문제를 피하고자 하므로, 
모든 네이티브 서비스와 API에 대한 크로스 플랫폼 API를 빌드할 생각은 없습니다.

여러 플랫폼 서비스와 API는 pub.dev에서 [기성 패키지][ready-made packages]를 사용할 수 있습니다. 
기존 패키지를 사용하는 것은 [쉽습니다][is easy].

마지막으로, 개발자는 Flutter의 비동기 메시지 전달 시스템을 사용하여, 
[플랫폼 및 타사 API][platform and third-party APIs]와 고유한 통합을 만들 것을 권장합니다. 
개발자는 필요한 만큼 플랫폼 API를 노출하고, 프로젝트에 가장 적합한 추상화 레이어를 빌드할 수 있습니다.

[is easy]: /packages-and-plugins/using-packages
[platform and third-party APIs]: /platform-integration/platform-channels
[ready-made packages]: {{site.pub}}/flutter/

### 번들로 제공되는 위젯을 확장하고 커스터마이즈 할 수 있나요? {:#can-i-extend-and-customize-the-bundled-widgets}

물론입니다. Flutter의 위젯 시스템은 쉽게 커스터마이즈 할 수 있도록 설계되었습니다.

각 위젯이 많은 수의 매개변수를 제공하는 대신, Flutter는 구성(composition)을 채택합니다. 
위젯은, 재사용하고 새로운 방식으로 결합하여 커스텀 위젯을 만들 수 있는, 더 작은 위젯으로 구성됩니다. 
예를 들어, 일반적인 버튼 위젯을 하위 클래스화하는 대신, 
`ElevatedButton`은 Material 위젯과 `GestureDetector` 위젯을 결합합니다. 
Material 위젯은 시각적 디자인을 제공하고 `GestureDetector` 위젯은 상호 작용 디자인을 제공합니다.

커스텀 시각적 디자인이 있는 버튼을 만들려면, 
시각적 디자인을 구현하는 위젯을, 상호 작용 디자인을 제공하는 `GestureDetector`와 결합할 수 있습니다. 
예를 들어, `CupertinoButton`은 이 접근 방식을 따르는데, 
이는 `GestureDetector`를 시각적 디자인을 구현하는 여러 다른 위젯과 결합합니다.

구성(Composition)을 사용하면 위젯의 시각적 및 상호 작용 디자인을 최대한 제어하는 ​​동시에, 
많은 양의 코드를 재사용할 수 있습니다. 
프레임워크에서, 우리는 복잡한 위젯을 시각적, 상호작용적, 모션 디자인을 개별적으로 구현하는 조각으로 분해했습니다. 
이러한 위젯을 원하는 대로 리믹스하여, 표현 범위가 완전한 커스텀 위젯을 만들 수 있습니다.

### iOS와 Android에서 레이아웃 코드를 공유하고 싶은 이유는 무엇인가요? {:#why-would-i-want-to-share-layout-code-across-ios-and-android}

iOS 및 Android에 대해 서로 다른 앱 레이아웃을 구현하도록 선택할 수 있습니다. 
개발자는 런타임에 모바일 OS를 확인하고 서로 다른 레이아웃을 렌더링할 수 있지만, 이러한 관행은 드물다는 것을 알게 되었습니다.

모바일 앱 레이아웃과 디자인이 플랫폼 간에 브랜드 중심적이고 통합되도록 진화하는 것을 점점 더 많이 보게 됩니다. 
이는 iOS 및 Android에서 레이아웃과 UI 코드를 공유하려는 강력한 동기를 의미합니다.

앱의 미적 디자인에 대한 브랜드 정체성과 커스터마이즈는 이제 기존 플랫폼 미학을 엄격히 고수하는 것보다 더 중요해지고 있습니다. 
예를 들어, 앱 디자인은 브랜드 정체성을 명확하게 전달하기 위해, 종종 커스텀 글꼴, 색상, 모양, 동작 등이 필요합니다.

또한 iOS 및 Android에서 공통적인 레이아웃 패턴이 배포되는 것을 볼 수 있습니다. 
예를 들어, "하단 탐색 모음(bottom nav bar)" 패턴은 이제 iOS 및 Android에서 자연스럽게 찾을 수 있습니다. 
모바일 플랫폼 간에 디자인 아이디어가 융합되는 것 같습니다.

### 모바일 플랫폼의 기본 프로그래밍 언어와 상호 운용할 수 있나요? {:#can-i-interop-with-my-mobile-platforms-default-programming-language}

네, Flutter는 Android에서 Java 또는 Kotlin 코드와 통합하고 iOS에서 Swift 또는 Objective-C 코드와 통합하는 것을 포함하여, 
플랫폼으로의 호출을 지원합니다. 
이는 Flutter 앱이 [`BasicMessageChannel`][]을 사용하여 모바일 플랫폼에 메시지를 보내고 받을 수 있는, 
유연한 메시지 전달 스타일을 통해 가능합니다.

[platform channels][]를 사용하여 Flutter에서 플랫폼 및 타사 서비스에 액세스하는 방법에 대해 자세히 알아보세요.

iOS 및 Android에서 플랫폼 채널을 사용하여, 
배터리 상태 정보에 액세스하는 방법을 보여주는 [예제 프로젝트][example project]가 있습니다.

[`BasicMessageChannel`]: {{site.api}}/flutter/services/BasicMessageChannel-class.html
[example project]: {{site.repo.flutter}}/tree/main/examples/platform_channel
[platform channels]: /platform-integration/platform-channels

### Flutter에는 reflection / mirrors 시스템이 있나요? {:#does-flutter-come-with-a-reflection-mirrors-system}

아니요. Dart에는 타입 리플렉션을 제공하는 `dart:mirrors`가 포함되어 있습니다. 
하지만 Flutter 앱은 프로덕션을 위해 사전 컴파일(pre-compiled)되고, 
이진 크기는 모바일 앱의 경우 항상 문제가 되므로, 이 라이브러리는 Flutter 앱에서 사용할 수 없습니다.

static 분석을 사용하면 사용되지 않는 모든 것을 제거할 수 있습니다. ("tree shaking") 
방대한 Dart 라이브러리를 import 하지만, 자체 포함 2줄 메서드만 사용하는 경우, 
해당 Dart 라이브러리 자체가 수십 개의 다른 라이브러리를 가져오더라도 2줄 메서드의 비용만 지불하면 됩니다. 
이 보장은 Dart가 컴파일 시에 코드 경로를 식별할 수 있는 경우에만 안전합니다. 
지금까지, 코드 생성과 같이, 더 나은 균형을 제공하는 특정 요구 사항에 대한 다른 접근 방식을 찾았습니다.

### Flutter에서 국제화(i18n), 지역화(l10n), 접근성(a11y)을 어떻게 구현하나요? {:#how-do-i-do-internationalization-i18n-localization-l10n-and-accessibility-a11y-in-flutter}

[국제화 튜토리얼][internationalization tutorial]에서 i18n과 l10n에 대해 자세히 알아보세요.

[접근성 문서][accessibility documentation]에서 a11y에 대해 자세히 알아보세요.

[accessibility documentation]: /ui/accessibility-and-internationalization/accessibility
[internationalization tutorial]: /ui/accessibility-and-internationalization/internationalization

### Flutter에서 parallel 및/또는 concurrent 앱을 작성하려면 어떻게 해야 하나요? {:#how-do-i-write-parallel-andor-concurrent-apps-for-flutter}

Flutter는 격리(isolates)를 지원합니다. 
격리는 Flutter VM의 별도 힙이며, 병렬로 실행할 수 있습니다. (일반적으로 별도 스레드로 구현됨) 
격리는 비동기 메시지를 보내고 받음으로써 통신합니다.

[Flutter에서 격리를 사용하는 예][example of using isolates with Flutter]를 확인하세요.

[example of using isolates with Flutter]: {{site.repo.flutter}}/blob/master/examples/layers/services/isolate.dart

### Flutter 앱의 백그라운드에서 Dart 코드를 실행할 수 있나요?{:#can-i-run-dart-code-in-the-background-of-a-flutter-app}

네, iOS와 Android 모두에서 백그라운드 프로세스에서 Dart 코드를 실행할 수 있습니다. 
자세한 내용은 무료 Medium 문서 [Flutter 플러그인과 Geofencing을 사용하여 백그라운드에서 Dart 실행][backgnd]을 참조하세요.

[backgnd]: {{site.flutter-medium}}/executing-dart-in-the-background-with-flutter-plugins-and-geofencing-2b3e40a1a124

### Flutter에서 JSON/XML/<wbr>protobuffers 등을 사용할 수 있나요?{:#can-i-use-jsonxmlprotobuffers-and-so-on-with-flutter}

물론입니다. [pub.dev][]에는 JSON, XML, protobufs 및 기타 여러 유틸리티와 형식에 대한 라이브러리가 있습니다.

Flutter에서 JSON을 사용하는 것에 대한 자세한 설명은, [JSON 튜토리얼][JSON tutorial]을 확인하세요.

[JSON tutorial]: /data-and-backend/serialization/json
[pub.dev]: {{site.pub}}

### Flutter로 3D(OpenGL) 앱을 만들 수 있나요? {:#can-i-build-3d-opengl-apps-with-flutter}

오늘날 우리는 OpenGL ES 또는 이와 유사한 것을 사용하여 3D를 지원하지 않습니다. 
우리는 최적화된 3D API를 공개하려는 장기 계획이 있지만, 지금은 2D에 집중하고 있습니다.

### 내 APK 또는 IPA가 왜 이렇게 큰가요? {:#why-is-my-apk-or-ipa-so-big}

일반적으로 이미지, 사운드 파일, 글꼴 등을 포함한 에셋은 APK 또는 IPA의 대부분입니다. 
Android 및 iOS 생태계의 다양한 도구를 사용하면 APK 또는 IPA 내부에 무엇이 있는지 이해하는 데 도움이 될 수 있습니다.

또한, Flutter 도구를 사용하여 APK 또는 IPA의 _릴리스 빌드_ 를 만드십시오. 
릴리스 빌드는 일반적으로 _디버그 빌드_ 보다 _훨씬_ 작습니다.

[Android 앱의 릴리스 빌드][release build of your Android app] 및 [iOS 앱의 릴리스 빌드][release build of your iOS app]를 만드는 방법에 대해 자세히 알아보십시오. 
또한, [앱 크기 측정][Measuring your app's size]을 확인하십시오.

[release build of your Android app]: /deployment/android
[release build of your iOS app]: /deployment/ios

### Flutter 앱은 Chromebook에서 실행되나요? {:#do-flutter-apps-run-on-chromebooks}

우리는 Flutter 앱이 일부 Chromebook에서 실행되는 것을 보았습니다. 
우리는 [Chromebook에서 Flutter 실행과 관련된 문제][issues related to running Flutter on Chromebooks]를 추적하고 있습니다.

[issues related to running Flutter on Chromebooks]: {{site.repo.flutter}}/labels/platform-arc

### Flutter는 ABI와 호환되나요? {:#is-flutter-abi-compatible}

Flutter와 Dart는 애플리케이션 바이너리 인터페이스(ABI, application binary interface) 호환성을 제공하지 않습니다. 
ABI 호환성을 제공하는 것은 Flutter나 Dart의 현재 목표가 아닙니다.

## 프레임워크 {:#framework}

### 왜 build() 메서드는 StatefulWidget이 아닌 State에 있나요? {:#why-is-the-build-method-on-state-rather-than-statefulwidget}

`Widget build(BuildContext context)` 메서드를 `State`에 두는 것이, 
`Widget build(BuildContext context, State state)` 메서드를 `StatefulWidget`에 두는 것보다, 개발자에게 `StatefulWidget`을 서브클래싱할 때 더 많은 유연성을 제공합니다. 
[`State.build`에 대한 API 문서에서 더 자세한 논의][detailed discussion on the API docs for `State.build`]를 읽어보세요.

### Flutter의 마크업 언어는 어디에 있나요? Flutter에 마크업 구문이 없는 이유는 무엇인가요? {:#where-is-flutters-markup-language-why-doesnt-flutter-have-a-markup-syntax}

Flutter UI는 명령형, 객체 지향 언어(Dart, Flutter 프레임워크를 빌드하는 데 사용된 언어와 동일)로 빌드됩니다. 
Flutter는 선언적 마크업으로 제공되지 않습니다.

우리는 코드로 동적으로 빌드된 UI가 더 많은 유연성을 허용한다는 것을 발견했습니다. 
예를 들어, 우리는 엄격한 마크업 시스템이 맞춤형 동작을 가진 맞춤형 위젯을 표현하고 생성하는 데 어려움을 겪었습니다.

우리는 또한 "코드 우선" 접근 방식이 핫 리로드 및 동적 환경 적응과 같은 기능을 더 잘 허용한다는 것을 발견했습니다.

즉석에서 위젯으로 변환되는 커스텀 언어를 만들 수 있습니다. 
빌드 메서드는 "단순히 코드"이기 때문에, 마크업을 해석하고 위젯으로 변환하는 것을 포함하여, 무엇이든 할 수 있습니다.

### 내 앱에는 오른쪽 상단에 디버그 배너/리본이 있습니다. 왜 이게 보이나요? {:#my-app-has-a-debug-bannerribbon-in-the-upper-right-why-am-i-seeing-that}

기본적으로, `flutter run` 명령은 디버그 빌드 구성을 사용합니다.

디버그 구성은 Dart 코드를 VM(가상 머신)에서 실행하여, 
[핫 리로드][hot reload]로 빠른 개발 주기를 가능하게 합니다. 
(릴리스 빌드는 표준 [Android][] 및 [iOS][] 툴체인을 사용하여 컴파일됨)

디버그 구성은 또한 모든 어설션을 확인하여, 
개발 중에 조기에 오류를 포착하는 데 도움이 되지만 런타임 비용이 부과됩니다. 
"Debug" 배너는 이러한 확인이 활성화되었음을 나타냅니다.
`--profile` 또는 `--release` 플래그를 `flutter run`에 사용하여 이러한 확인 없이 앱을 실행할 수 있습니다.

IDE에서 Flutter 플러그인을 사용하는 경우, 
프로필 또는 릴리스 모드에서 앱을 시작할 수 있습니다. 
VS Code의 경우, **Run > Start debugging** 또는 **Run > Run without debugging** 메뉴 항목을 사용합니다. 
IntelliJ의 경우, **Run > Flutter Run in Profile Mode** 또는 **Release Mode** 메뉴 항목을 사용합니다.

[Android]: #run-android
[hot reload]: #hot-reload
[iOS]: #run-ios

### Flutter 프레임워크는 어떤 프로그래밍 패러다임을 사용하나요? {:#what-programming-paradigm-does-flutters-framework-use}

Flutter는 다중 패러다임 프로그래밍 환경입니다. 
지난 수십 년 동안 개발된 많은 프로그래밍 기술이 Flutter에서 사용됩니다. 
우리는 기술의 강점이 특히 적합하다고 생각되는 각 기술을 사용합니다. 특별한 순서는 없습니다.

**구성 (Composition)**
: Flutter에서 사용하는 주요 패러다임은 동작 범위가 좁은 작은 객체를 사용하여, 
  더 복잡한 효과를 얻기 위해 함께 구성하는 것입니다. 
  이를 _공격적 구성(aggressive composition)_ 이라고도 합니다. 
  Flutter 위젯 라이브러리의 대부분 위젯은 이런 방식으로 빌드됩니다. 

  예를 들어, 
  
  Material [`TextButton`][] 클래스는 [`IconTheme`][], [`InkWell`][], [`Padding`][], [`Center`][], [`Material`][], [`AnimatedDefaultTextStyle`][], [`ConstrainedBox`][]를 사용하여 빌드됩니다. 
  
  [`InkWell`][]은 [`GestureDetector`][]를 사용하여 빌드됩니다. 
  
  [`Material`][]은 [`AnimatedDefaultTextStyle`][], [`NotificationListener`][], [`AnimatedPhysicalModel`][]을 사용하여 빌드됩니다. 
  
  이런 식으로 계속됩니다. 위젯은 맨 아래까지 이어집니다.

**함수형 프로그래밍 (Functional programming)**
: 전체 애플리케이션은 [`StatelessWidget`][]만으로 빌드할 수 있습니다. 
  [`StatelessWidget`][]은 기본적으로 인수가 다른 함수로 map 하는 것을 표현하는 함수이며, 
  레이아웃을 계산하거나 그래픽을 그리는 기본 요소에서 끝납니다. 
  (이러한 애플리케이션은 상태를 쉽게 가질 수 없으므로, 일반적으로 상호 작용이 아닙니다.) 
  예를 들어, [`Icon`][] 위젯은 기본적으로 인수([`color`][], [`icon`][], [`size`][])를 레이아웃 기본 요소에 map 하는 함수입니다. 
  
  또한, 전체 [`Widget`][] 클래스 계층과 [`Rect`][], [`TextStyle`][]과 같은 수많은 지원 클래스를 포함하여, 변경 불가능한(immutable) 데이터 구조를 많이 사용합니다. 
  
  더 작은 규모로 보면, 함수형 스타일(map, reduce, where 등)을 많이 사용하는, Dart의 [`Iterable`][] API는, 프레임워크에서 값 리스트를 처리하는 데 자주 사용됩니다.

**이벤트 기반 프로그래밍 (Event-driven programming)**
: 사용자 상호작용은 이벤트 핸들러에 등록된 콜백으로 전송되는 이벤트 객체로 표현됩니다. 

  화면 업데이트는 유사한 콜백 메커니즘에 의해 트리거됩니다. 
  
  애니메이션 시스템의 기반으로 사용되는 [`Listenable`][] 클래스는, 
  여러 리스너가 있는 이벤트에 대한 구독 모델을 공식화합니다.

**클래스 기반 객체 지향 프로그래밍 (Class-based object-oriented programming)**
: 프레임워크의 대부분 API는 상속이 있는 클래스를 사용하여 빌드됩니다. 
  우리는 기본 클래스에서 매우 높은 레벨의 API를 정의한 다음, 
  하위 클래스에서 반복적으로 특수화하는 접근 방식을 사용합니다. 
  
  예를 들어, 렌더 객체에는 좌표계와 관련하여 독립적인 베이스 클래스([`RenderObject`][])가 있고, 
  지오메트리가 데카르트 좌표계(x/width 및 y/height)를 기반으로 해야 한다는 의견을 도입하는 
  하위 클래스([`RenderBox`][])가 있습니다.

**프로토타입 기반 객체 지향 프로그래밍 (Prototype-based object-oriented programming)**
: [`ScrollPhysics`][] 클래스는 인스턴스를 체인으로 연결하여, 
  런타임에 동적으로 스크롤링하는 데 적용되는 물리를 구성합니다. 
  
  이를 통해. 시스템은 컴파일 시에 플랫폼을 선택하지 않고도, 
  플랫폼별 물리를 사용하여 페이징 물리를 구성할 수 있습니다.

**명령형 프로그래밍 (Imperative programming)**
: 일반적으로 객체 내에 캡슐화된 상태와 함께 사용되는, 간단한 명령형 프로그래밍은, 
  가장 직관적인 솔루션을 제공하는 경우에 사용됩니다. 
  
  예를 들어, 테스트는 명령형 스타일로 작성되어, 
  먼저 테스트 상황을 설명한 다음, 
  테스트가 일치해야 하는 불변식을 나열한 다음, 
  테스트에 필요한 경우 클록을 진행하거나 이벤트를 삽입합니다.

**반응형 프로그래밍 (Reactive programming)**
: 위젯과 요소 트리는 때때로 반응형이라고 설명되는데, 
  위젯 생성자에서 제공된 새로운 입력은 위젯의 빌드 메서드에 의해 낮은 레벨 위젯에게 변경 사항으로 즉시 전파되고,
  하위 위젯에서 변경된 사항(예: 사용자 입력에 대한 응답)은 이벤트 핸들러를 사용하여 트리 위로 다시 전파되기 때문입니다. 
  
  위젯의 요구 사항에 따라, 프레임워크에 함수적 반응형(functional-reactive)과 명령형 반응형(imperative-reactive)의 측면이 모두 존재합니다. 
  
  (1) 위젯이 구성의 변경에 어떻게 반응하는지 설명하는 표현식만으로 구성된 빌드 메서드가 있는 위젯은, 
  함수적 반응형 위젯입니다. (예: Material [`Divider`][] 클래스)
  
  (2) 위젯이 구성의 변경에 어떻게 반응하는지 설명하는 여러 구문에 걸친 자식 리스트를 구성하는 빌드 메서드가 있는 위젯은, 
  명령형 반응형 위젯입니다. (예: [`Chip`][] 클래스)

**선언적 프로그래밍 (Declarative programming)**
: 위젯의 빌드 메서드는, 종종 Dart의 엄격하게 선언적인 하위 집합을 사용하여 작성된, 
  다중 레벨의 중첩된 생성자가 있는 단일 표현식입니다. 
  이러한 중첩된 표현식은 적절히 표현력이 있는 마크업 언어로 기계적으로 변환되거나, 해당 언어에서 변환될 수 있습니다. 
  예를 들어, [`UserAccountsDrawerHeader`][] 위젯에는, 단일 중첩된 표현식으로 구성된, 
  긴 빌드 메서드(20줄 이상)가 있습니다. 
  이를 명령형 스타일과 결합하여, 순수 선언적 접근 방식으로 설명하기 어려운 UI를 빌드할 수도 있습니다.

**제네릭 프로그래밍 (Generic programming)**
: 타입은 개발자가 프로그래밍 오류를 일찍 포착하는 데 도움이 될 수 있습니다. 
  Flutter 프레임워크는 이와 관련하여 제네릭 프로그래밍을 사용하여 도움을 줍니다. 
  예를 들어, [`State`][] 클래스는 연관된 위젯의 타입 측면에서 매개변수화되므로, 
  Dart 분석기가 상태와 위젯의 불일치를 포착할 수 있습니다. 
  마찬가지로, [`GlobalKey`][] 클래스는 타입 매개변수를 취하여, 
  타입 안전한 방식으로 (런타임 검사를 사용하여) 원격 위젯의 상태에 액세스할 수 있고, 
  [`Route`][] 인터페이스는 [popped][] 할 때, 사용할 것으로 예상되는 타입으로 매개변수화되고, 
  [`List`][], [`Map`][], [`Set`][]과 같은 컬렉션은 모두 매개변수화되어, 
  불일치하는 요소를 분석 중 또는 디버깅 중 런타임에 일찍 포착할 수 있습니다.

**동시성 프로그래밍 (Concurrent programming)**
: Flutter는 [`Future`][]와 다른 비동기 API를 많이 사용합니다. 
  예를 들어, 애니메이션 시스템은 future를 완료하여, 애니메이션이 완료될 때 보고합니다. 
  이미지 로딩 시스템도 마찬가지로 future를 사용하여, 로드가 완료될 때 보고합니다.

**제약 프로그래밍 (Constraint programming)**
: Flutter의 레이아웃 시스템은 약한 형태의 제약 프로그래밍을 사용하여 장면의 지오메트리를 결정합니다. 
  제약(예: 데카르트 상자의 경우 최소 및 최대 너비와 최소 및 최대 높이)은 부모에서 자식으로 전달되고, 
  자식은 이러한 제약을 충족하는 결과 지오메트리(예: 데카르트 상자의 경우 크기, 특히 너비와 높이)를 선택합니다. 
  이 기술을 사용하면, Flutter는 일반적으로 단일 패스로 전체 장면을 레이아웃할 수 있습니다.

[`AnimatedDefaultTextStyle`]: {{site.api}}/flutter/widgets/AnimatedDefaultTextStyle-class.html
[`AnimatedPhysicalModel`]: {{site.api}}/flutter/widgets/AnimatedPhysicalModel-class.html
[`Center`]: {{site.api}}/flutter/widgets/Center-class.html
[`Chip`]: {{site.api}}/flutter/material/Chip-class.html
[`color`]: {{site.api}}/flutter/widgets/Icon/color.html
[`ConstrainedBox`]: {{site.api}}/flutter/widgets/ConstrainedBox-class.html
[`Divider`]: {{site.api}}/flutter/material/Divider-class.html
[`Future`]: {{site.api}}/flutter/dart-async/Future-class.html
[`GestureDetector`]: {{site.api}}/flutter/widgets/GestureDetector-class.html
[`GlobalKey`]: {{site.api}}/flutter/widgets/GlobalKey-class.html
[`icon`]: {{site.api}}/flutter/widgets/Icon/icon.html
[`Icon`]: {{site.api}}/flutter/widgets/Icon-class.html
[`IconTheme`]: {{site.api}}/flutter/widgets/IconTheme-class.html
[`InkWell`]: {{site.api}}/flutter/material/InkWell-class.html
[`Iterable`]: {{site.api}}/flutter/dart-core/Iterable-class.html
[`List`]: {{site.api}}/flutter/dart-core/List-class.html
[`Listenable`]: {{site.api}}/flutter/foundation/Listenable-class.html
[`Map`]: {{site.api}}/flutter/dart-core/Map-class.html
[`Material`]: {{site.api}}/flutter/material/Material-class.html
[`NotificationListener`]: {{site.api}}/flutter/widgets/NotificationListener-class.html
[`Padding`]: {{site.api}}/flutter/widgets/Padding-class.html
[popped]: {{site.api}}/flutter/widgets/Navigator/pop.html
[`Rect`]: {{site.api}}/flutter/dart-ui/Rect-class.html
[`RenderBox`]: {{site.api}}/flutter/rendering/RenderBox-class.html
[`RenderObject`]: {{site.api}}/flutter/rendering/RenderObject-class.html
[`Route`]: {{site.api}}/flutter/widgets/Route-class.html
[`ScrollPhysics`]: {{site.api}}/flutter/widgets/ScrollPhysics-class.html
[`Set`]: {{site.api}}/flutter/dart-core/Set-class.html
[`size`]: {{site.api}}/flutter/widgets/Icon/size.html
[`State`]: {{site.api}}/flutter/widgets/State-class.html
[`StatelessWidget`]: {{site.api}}/flutter/widgets/StatelessWidget-class.html
[`TextButton`]: {{site.api}}/flutter/material/TextButton-class.html
[`TextStyle`]: {{site.api}}/flutter/painting/TextStyle-class.html
[`UserAccountsDrawerHeader`]: {{site.api}}/flutter/material/UserAccountsDrawerHeader-class.html
[`Widget`]: {{site.api}}/flutter/widgets/Widget-class.html

## 프로젝트 {:#project}

### 어디서 지원을 받을 수 있나요? {:#where-can-i-get-support}

버그가 발생한 것 같으면, [문제 추적기][issue tracker]에 신고하세요. 
"HOWTO" 타입의 질문에는 [Stack Overflow][]를 사용할 수도 있습니다. 
토론을 위해, [{{site.email}}][]에서 메일링 목록에 가입하거나, [Discord][]에서 저희를 찾으세요.

자세한 내용은 [커뮤니티][Community] 페이지를 참조하세요.

[Community]: {{site.main-url}}/community
[Discord]: https://discord.com/invite/rflutterdev
[issue tracker]: {{site.repo.flutter}}/issues
[{{site.email}}]: mailto:{{site.email}}
[Stack Overflow]: {{site.so}}/tags/flutter

### 어떻게 참여할 수 있나요? {:#how-do-i-get-involved}

Flutter는 오픈 소스이며, 기여를 장려합니다. 
기능 요청 및 버그에 대한 이슈를 [문제 추적기][issue tracker]에서 간단히 제출하는 것으로 시작할 수 있습니다.

[{{site.email}}][]에서 메일링 리스트에 가입하여 Flutter를 어떻게 사용하고 있는지, 
Flutter로 무엇을 하고 싶은지 알려주시기 바랍니다.

코드 기여에 관심이 있다면, [기여 가이드][Contributing guide]를 읽고, 
[쉬운 시작 이슈][easy starter issues] 리스트를 확인하세요.

마지막으로 유용한 Flutter 커뮤니티에 연결할 수 있습니다. 자세한 내용은 [커뮤니티][Community] 페이지를 참조하세요.

Flutter [Discord][]에서 다른 개발자와 교류할 수도 있습니다.

[Contributing guide]: {{site.repo.flutter}}/blob/master/CONTRIBUTING.md
[easy starter issues]: {{site.repo.flutter}}/issues?q=is%3Aopen+is%3Aissue+label%3A%22easy+fix%22

### Flutter는 오픈 소스인가요? {:#is-flutter-open-source}

네, Flutter는 오픈 소스 기술입니다. [GitHub][]에서 프로젝트를 찾을 수 있습니다.

[GitHub]: {{site.repo.flutter}}

### Flutter와 그에 따른 종속성에 어떤 소프트웨어 라이선스가 적용됩니까? {:#which-software-licenses-apply-to-flutter-and-its-dependencies}

Flutter에는 두 가지 구성 요소가 포함되어 있습니다. 
(1) 동적으로 링크된 바이너리로 제공되는 엔진과 (2) 엔진이 로드하는 별도의 바이너리인 Dart 프레임워크입니다. 
엔진은 많은 종속성이 있는 여러 소프트웨어 구성 요소를 사용합니다. 
[라이센스 파일][license file]에서 전체 리스트를 확인하세요.

프레임워크는 완전히 독립적이며, [단 하나의 라이선스][only one license]만 필요합니다.

또한, 사용하는 모든 Dart 패키지에는 자체 라이선스 요구 사항이 있을 수 있습니다.

[license file]: https://raw.githubusercontent.com/flutter/engine/master/sky/packages/sky_engine/LICENSE
[only one license]: {{site.repo.flutter}}/blob/master/LICENSE

### 내 Flutter 애플리케이션에 표시해야 하는 라이선스를 어떻게 확인할 수 있나요? {:#how-can-i-determine-the-licenses-my-flutter-application-needs-to-show}

표시해야 하는 라이선스 목록을 찾는 API가 있습니다.

* 애플리케이션에 [`Drawer`][]가 있는 경우, [`AboutListTile`][]을 추가합니다.

* 애플리케이션에 Drawer가 없지만 Material Components 라이브러리를 사용하는 경우, 
  [`showAboutDialog`][] 또는 [`showLicensePage`][]를 호출합니다.

* 더 많은 커스텀 방식의 경우, [`LicenseRegistry`][]에서 raw 라이선스를 가져올 수 있습니다.

[`AboutListTile`]: {{site.api}}/flutter/material/AboutListTile-class.html
[`Drawer`]: {{site.api}}/flutter/material/Drawer-class.html
[`LicenseRegistry`]: {{site.api}}/flutter/foundation/LicenseRegistry-class.html
[`showAboutDialog`]: {{site.api}}/flutter/material/showAboutDialog.html
[`showLicensePage`]: {{site.api}}/flutter/material/showLicensePage.html

### Flutter에서는 누가 일하나요? {:#who-works-on-flutter}

우리 모두 그렇습니다! Flutter는 오픈 소스 프로젝트입니다. 
현재, 대부분의 개발은 Google의 엔지니어가 수행합니다. 
Flutter에 관심이 있다면, 커뮤니티에 가입하여 [Flutter에 기여][contribute to Flutter]하세요!

[contribute to Flutter]: {{site.repo.flutter}}/blob/master/CONTRIBUTING.md

### Flutter의 기본 원칙은 무엇인가요? {:#what-are-flutters-guiding-principles}

우리는 다음을 믿습니다.

* 모든 잠재 사용자에게 도달하기 위해, 개발자는 여러 모바일 플랫폼을 타겟으로 삼아야 합니다.
* 현재의 HTML과 WebView는, 자동 동작(스크롤, 레이아웃)과 레거시 지원으로 인해, 
  지속적으로 높은 프레임 속도를 달성하고 고품질 경험을 제공하기 어렵게 만듭니다.
* 오늘날, 동일한 앱을 여러 번 빌드하는 데는 비용이 너무 많이 듭니다.
  다른 팀, 다른 코드 기반, 다른 워크플로, 다른 도구 등이 필요합니다.
* 개발자는 단일 코드 기반을 사용하여 여러 타겟 플랫폼에 대한 모바일 앱을 빌드하는, 
  더 쉽고 더 나은 방법을 원하며, 
  품질, 제어 또는 성능을 희생하고 싶어하지 않습니다.

우리는 세 가지에 집중합니다.

_제어 (Control)_
: 개발자는 시스템의 모든 레이어에 대한 액세스와 제어를 받을 자격이 있습니다. 
  이는 다음과 같습니다.

_성능 (Performance)_
: 사용자는 완벽하게 유동적이고, 반응성이 뛰어나며, 끊김 없는(jank-free) 앱을 받을 자격이 있습니다. 
  이는 다음과 같습니다.

_충실도 (Fidelity)_:
: 모든 사람은 정확하고, 아름답고, 즐거운 앱 경험을 받을 자격이 있습니다.

### Apple이 내 Flutter 앱을 거부할까요? {:#will-apple-reject-my-flutter-app}

Apple에 대해서는 말할 수 없지만, 
그들의 App Store에는 Flutter와 같은 프레임워크 기술로 빌드된 많은 앱이 있습니다. 
실제로, Flutter는 Apple 스토어에서 가장 인기 있는 게임 중 많은 것을 구동하는 엔진인, 
Unity와 동일한 기본 아키텍처 모델을 사용합니다.

Apple은 [Hamilton][Hamilton for iOS] 및 [Reflectly][]를 포함하여, 
Flutter로 빌드된 잘 디자인된 앱을 자주 소개했습니다.

Apple 스토어에 제출된 모든 앱과 마찬가지로, 
Flutter로 빌드된 앱은 App Store 제출을 위한 Apple의 [지침][guidelines]을 따라야 합니다.

[guidelines]: {{site.apple-dev}}/app-store/review/guidelines/
[Hamilton for iOS]: https://itunes.apple.com/us/app/hamilton-the-official-app/id1255231054?mt=8
[Reflectly]: https://apps.apple.com/us/app/reflectly-journal-ai-diary/id1241229134
