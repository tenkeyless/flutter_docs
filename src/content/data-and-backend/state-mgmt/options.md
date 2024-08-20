---
# title: List of state management approaches
title: 상태 관리 접근법 리스트
# description: A list of different approaches to managing state.
description: 상태 관리에 대한 다양한 접근법 리스트입니다.
prev:
  # title: Simple app state management
  title: 간단한 앱 상태 관리
  path: /development/data-and-backend/state-mgmt/simple
---

상태 관리란 복잡한 주제입니다. 
질문 중 일부가 답변되지 않았거나, 이 페이지에 설명된 접근 방식이 사용 사례에 적합하지 않다고 생각된다면, 아마 그럴 것입니다.

Flutter 커뮤니티에서 기여한, 다음 링크에서 자세히 알아보세요.

## 일반 개요 {:#general-overview}

접근 방식을 선택하기 전에 검토해야 할 사항.

* [상태 관리 소개][Introduction to state management], 이 섹션의 시작 부분입니다. 
  (이 _옵션_ 페이지로 바로 왔고, 이전 페이지를 놓친 분들을 위해)
* [Flutter에서의 실용적 상태 관리][Pragmatic State Management in Flutter], Google I/O 2019의 비디오
* [Flutter 아키텍처 샘플][Flutter Architecture Samples], Brian Egan 제공

[Flutter Architecture Samples]: https://fluttersamples.com/
[Introduction to state management]: /data-and-backend/state-mgmt/intro
[Pragmatic State Management in Flutter]: {{site.yt.watch}}?v=d_m5csmrf7I

## Provider {:#provider}

* [간단한 앱 상태 관리][Simple app state management], 이 섹션의 이전 페이지
* [Provider 패키지][Provider package]

[Provider package]: {{site.pub-pkg}}/provider
[Simple app state management]: /data-and-backend/state-mgmt/simple

## Riverpod {:#riverpod}

Riverpod는 Provider와 비슷한 방식으로 작동합니다.
Flutter SDK에 의존하지 않고, 컴파일 안전성과 테스트를 제공합니다.

* [Riverpod][] 홈페이지
* [Riverpod 시작하기][Getting started with Riverpod]

[Getting started with Riverpod]: https://riverpod.dev/docs/introduction/getting_started
[Riverpod]: https://riverpod.dev/

## setState {:#setstate}

위젯별, 일시적(ephemeral) 상태에 사용할 낮은 레벨 접근 방식.

* [Flutter 앱에 상호 작용 추가][Adding interactivity to your Flutter app], Flutter 튜토리얼
* [Google Flutter의 기본 상태 관리][Basic state management in Google Flutter], Agung Surya 지음

[Adding interactivity to your Flutter app]: /ui/interactivity
[Basic state management in Google Flutter]: {{site.medium}}/@agungsurya/basic-state-management-in-google-flutter-6ee73608f96d

## ValueNotifier &amp; InheritedNotifier {:#valuenotifier-inheritednotifier}

Flutter만 사용하는 접근 방식은 상태를 업데이트하고, UI에 변경 사항을 알리는 도구를 제공합니다.

* [ValueNotifier와 InheritedNotifier를 사용한 상태 관리][State Management using ValueNotifier and InheritedNotifier], Tadas Petra 지음

[State Management using ValueNotifier and InheritedNotifier]: https://www.hungrimind.com/articles/flutter-state-management

## InheritedWidget &amp; InheritedModel {:#inheritedwidget-inheritedmodel}

위젯 트리에서 조상과 자식 간의 통신에 사용되는 낮은 레벨 접근 방식입니다. 
이것이 `provider`와 다른 많은 접근 방식이 후드 아래에서(under the hood) 사용하는 것입니다.

다음 강사 주도 비디오 워크숍은 `InheritedWidget`을 사용하는 방법을 다룹니다.

{% ytEmbed 'LFcGPS6cGrY', '상속된 위젯을 사용하여 애플리케이션 상태를 관리하는 방법' %}

다른 유용한 문서는 다음과 같습니다.

* [InheritedWidget 문서][InheritedWidget docs]
* [InheritedWidgets를 사용하여 Flutter 애플리케이션 상태 관리][Managing Flutter Application State With InheritedWidgets], Hans Muller 지음
* [위젯 상속(Inheriting Widgets)][Inheriting Widgets], Mehmet Fidanboylu 지음
* [Flutter 상속 위젯을 효과적으로 사용하기][Using Flutter Inherited Widgets Effectively], Eric Windmill 지음
* [위젯 - 상태 - 컨텍스트 - InheritedWidget][Widget - State - Context - InheritedWidget], Didier Bolelens 지음

[InheritedWidget docs]: {{site.api}}/flutter/widgets/InheritedWidget-class.html
[Inheriting Widgets]: {{site.medium}}/@mehmetf_71205/inheriting-widgets-b7ac56dbbeb1
[Managing Flutter Application State With InheritedWidgets]: {{site.flutter-medium}}/managing-flutter-application-state-with-inheritedwidgets-1140452befe1
[Using Flutter Inherited Widgets Effectively]: https://ericwindmill.com/articles/inherited_widget/
[Widget - State - Context - InheritedWidget]: https://www.didierboelens.com/2018/06/widget---state---context---inheritedwidget/

## June {:#june}

Flutter의 내장 상태 관리와 유사한 패턴을 제공하는 데 중점을 둔 가볍고 현대적인 상태 관리 라이브러리입니다.

* [june 패키지][june package]

[june package]: {{site.pub-pkg}}/june

## Redux {:#redux}

많은 웹 개발자에게 친숙한 상태 컨테이너 접근 방식

* [Redux와 Flutter를 사용한 애니메이션 관리][Animation Management with Redux and Flutter], DartConf 2018의 비디오 [Medium에 있는 동반 글][Accompanying article on Medium]
* [Flutter Redux 패키지][Flutter Redux package]
* [Redux Saga Middleware Dart와 Flutter][Redux Saga Middleware Dart and Flutter], Bilal Uslu
* [Flutter에서 Redux 소개][Introduction to Redux in Flutter], Xavi Rigau
* [Flutter + Redux&mdash;쇼핑 리스트 앱 만드는 방법][Flutter + Redux&mdash;How to make a shopping list app], Hackernoon에서 Paulina Szklarska
* [Redux를 사용하여 Flutter에서 TODO 애플리케이션(CRUD) 빌드&mdash;1부][Building a TODO application (CRUD) in Flutter with Redux&mdash;Part 1], Tensor Programming의 비디오
* [Flutter Redux Thunk, 예제][Flutter Redux Thunk, an example], Jack Wong
* [Redux를 사용하여 (대형) Flutter 앱 빌드][Building a (large) Flutter app with Redux], Hillel Coren
* [Fish-Redux–Redux를 기반으로 조립된 Flutter 애플리케이션 프레임워크][Fish-Redux–An assembled flutter application framework based on Redux], Alibaba
* [Async Redux–Redux 보일러플레이트 없이. 동기식 및 비동기식 리듀서 모두 허용][Async Redux–Redux without boilerplate. Allows for both sync and async reducers], Marcelo Glasberg
* [Flutter meets Redux: Flutter 애플리케이션 상태를 관리하는 Redux 방식][Flutter meets Redux: The Redux way of managing Flutter applications state], Amir Ghezelbash
* [Flutter 앱에서 더 잘 정리된 코드를 위한 Redux 및 에픽][], Nihad Delic
* [Flutter_Redux_Gen - 보일러플레이트 코드를 생성하는 VS 코드 플러그인][Flutter_Redux_Gen - VS Code Plugin to generate boiler plate code], Balamurugan Muthusamy(BalaDhruv)

[Accompanying article on Medium]: {{site.flutter-medium}}/animation-management-with-flutter-and-flux-redux-94729e6585fa
[Animation Management with Redux and Flutter]: {{site.yt.watch}}?v=9ZkLtr0Fbgk
[Async Redux–Redux without boilerplate. Allows for both sync and async reducers]: {{site.pub}}/packages/async_redux
[Building a (large) Flutter app with Redux]: https://hillelcoren.com/2018/06/01/building-a-large-flutter-app-with-redux/
[Building a TODO application (CRUD) in Flutter with Redux&mdash;Part 1]: {{site.yt.watch}}?v=Wj216eSBBWs
[Fish-Redux–An assembled flutter application framework based on Redux]: {{site.github}}/alibaba/fish-redux/
[Flutter Redux Thunk, an example]: {{site.medium}}/flutterpub/flutter-redux-thunk-27c2f2b80a3b
[Flutter meets Redux: The Redux way of managing Flutter applications state]: {{site.medium}}/@thisisamir98/flutter-meets-redux-the-redux-way-of-managing-flutter-applications-state-f60ef693b509
[Flutter Redux package]: {{site.pub-pkg}}/flutter_redux
[Flutter + Redux&mdash;How to make a shopping list app]: https://hackernoon.com/flutter-redux-how-to-make-shopping-list-app-1cd315e79b65
[Introduction to Redux in Flutter]: https://blog.novoda.com/introduction-to-redux-in-flutter/
[Redux and epics for better-organized code in Flutter apps]: {{site.medium}}/upday-devs/reduce-duplication-achieve-flexibility-means-success-for-the-flutter-app-e5e432839e61
[Redux Saga Middleware Dart and Flutter]: {{site.pub-pkg}}/redux_saga
[Flutter_Redux_Gen - VS Code Plugin to generate boiler plate code]: https://marketplace.visualstudio.com/items?itemName=BalaDhruv.flutter-redux-gen

## Fish-Redux {:#fish-redux}

Fish Redux는 Redux 상태 관리를 기반으로 하는 조립형(assembled) Flutter 애플리케이션 프레임워크입니다. 
중대형 애플리케이션을 구축하는 데 적합합니다.

* [Fish-Redux-Library][] 패키지, Alibaba 제공
* [Fish-Redux-Source][], 프로젝트 코드
* [Flutter-Movie][], Fish Redux를 사용하는 방법을 보여주는 간단한 예로, 
  30개 이상의 화면, graphql, 결제 API, 미디어 플레이어가 있습니다.

[Fish-Redux-Library]: {{site.pub-pkg}}/fish_redux
[Fish-Redux-Source]: {{site.github}}/alibaba/fish-redux
[Flutter-Movie]: {{site.github}}/o1298098/Flutter-Movie

## BLoC / Rx {:#bloc-rx}

stream/observable 기반 패턴의 패밀리.

* [BLoC 패턴을 사용하여 Flutter 프로젝트 설계][Architect your Flutter project using BLoC pattern], Sagar Suri 작성
* [BloC 라이브러리][BloC Library], Felix Angelov 작성
* [Reactive 프로그래밍 - Streams - BLoC - 실용적 사용 사례][Reactive Programming - Streams - BLoC - Practical Use Cases], Didier Boelens 작성

[Architect your Flutter project using BLoC pattern]: {{site.medium}}/flutterpub/architecting-your-flutter-project-bd04e144a8f1
[BloC Library]: https://felangel.github.io/bloc
[Reactive Programming - Streams - BLoC - Practical Use Cases]: https://www.didierboelens.com/2018/12/reactive-programming---streams---bloc---practical-use-cases

## GetIt {:#getit}

`BuildContext`가 필요 없는 서비스 로케이터(service locator) 기반 상태 관리 방식입니다.

* [GetIt 패키지][GetIt package], 
  * 서비스 로케이터입니다. 
  * BloC와 함께 사용할 수도 있습니다.
* [GetIt Mixin 패키지][GetIt Mixin package], 
  * `GetIt`을 완전한 상태 관리 솔루션으로 완성하는 믹스인입니다.
* [GetIt Hooks 패키지][GetIt Hooks package], 
  * 이미 `flutter_hooks`를 사용하는 경우 믹스인과 동일합니다.
* [미니멀리스트를 위한 Flutter 상태 관리][Flutter state management for minimalists], Suragch 제공

:::note
자세한 내용을 알아보려면, GetIt 패키지에 대한 이 짧은 주간 패키지 비디오를 시청하세요.

{% ytEmbed 'f9XQD5mf6FY', 'get_it | Flutter package of the week', true %}
:::

[Flutter state management for minimalists]: {{site.medium}}/flutter-community/flutter-state-management-for-minimalists-4c71a2f2f0c1?sk=6f9cedfb550ca9cc7f88317e2e7055a0
[GetIt package]: {{site.pub-pkg}}/get_it
[GetIt Hooks package]: {{site.pub-pkg}}/get_it_hooks
[GetIt Mixin package]: {{site.pub-pkg}}/get_it_mixin

## MobX {:#mobx}

observables과 reactions에 기반한 인기 있는 라이브러리입니다.

* [MobX.dart, Dart 및 Flutter 앱을 위한 번거로움 없는 상태 관리][MobX.dart, Hassle free state-management for your Dart and Flutter apps]
* [MobX.dart로 시작하기][Getting started with MobX.dart]
* [Flutter: Mobx를 사용한 상태 관리][Flutter: State Management with Mobx], Paul Halliday의 비디오

[Flutter: State Management with Mobx]: {{site.yt.watch}}?v=p-MUBLOEkCs
[Getting started with MobX.dart]: https://mobx.netlify.app/getting-started
[MobX.dart, Hassle free state-management for your Dart and Flutter apps]: {{site.github}}/mobxjs/mobx.dart

## Dart Board {:#dart-board}

Flutter용 모듈식 기능 관리 프레임워크. 
Dart Board는 예제/프레임워크, 작은 커널 및 디버깅, 로깅, 인증(auth), redux, 로케이터(locator), 파티클 시스템(particle system) 등과 같은 많은 즉시 사용 가능한(ready-to-use) 분리된 기능을 포함하고, 
기능을 캡슐화하고 분리하도록 설계되었습니다.

* [Dart Board 홈페이지 + 데모](https://dart-board.io/)
* [pub.dev의 Dart Board]({{site.pub-pkg}}/dart_board_core)
* [GitHub의 dart_board]({{site.github}}/ahammer/dart_board)
* [Dart Board로 시작하기]({{site.github}}/ahammer/dart_board/blob/master/GETTING_STARTED.md)

## Flutter Commands {:#flutter-commands}

Command Pattern을 사용하고 `ValueNotifiers`를 기반으로 하는 Reactive 상태 관리. 
[GetIt](#getit)과 함께 사용하는 것이 가장 좋지만, `Provider` 또는 다른 로케이터와도 사용할 수 있습니다.

* [Flutter Command 패키지][Flutter Command package]
* [RxCommand 패키지][RxCommand package], `Stream` 기반 구현.

[Flutter Command package]: {{site.pub-pkg}}/flutter_command
[RxCommand package]: {{site.pub-pkg}}/rx_command

## Binder {:#binder}

`InheritedWidget`을 코어로 사용하는 상태 관리 패키지입니다. 
recoil에서 영감을 받았습니다. 
이 패키지는 관심사 분리를 촉진합니다.

* [Binder 패키지][Binder package]
* [Binder 예제][Binder examples]
* [Binder 스니펫][Binder snippets], vscode 스니펫은 Binder로 더욱 생산적으로 작업할 수 있습니다.

[Binder examples]: {{site.github}}/letsar/binder/tree/main/examples
[Binder package]: {{site.pub-pkg}}/binder
[Binder snippets]: https://marketplace.visualstudio.com/items?itemName=romain-rastel.flutter-binder-snippets

## GetX {:#getx}

간소화된 reactive 상태 관리 솔루션.

* [GetX 패키지][GetX package]
* [GetX Flutter Firebase 인증 예제][GetX Flutter Firebase Auth Example], Jeff McMorris 제공

[GetX package]: {{site.pub-pkg}}/get
[GetX Flutter Firebase Auth Example]: {{site.medium}}/@jeffmcmorris/getx-flutter-firebase-auth-example-b383c1dd1de2


## states_rebuilder {:#states_rebuilder}

상태 관리와 종속성 주입 솔루션, 통합 라우터를 결합한 접근 방식입니다. 
자세한 내용은, 다음 정보를 참조하세요.

* [States Rebuilder][States Rebuilder] 프로젝트 코드
* [States Rebuilder 문서][States Rebuilder documentation]

[States Rebuilder]: {{site.github}}/GIfatahTH/states_rebuilder
[States Rebuilder documentation]: {{site.github}}/GIfatahTH/states_rebuilder/wiki

## Triple Pattern (Segmented State Pattern) {:#triple-pattern-segmented-state-pattern}

Triple은 `Streams` 또는 `ValueNotifier`를 사용하는 상태 관리 패턴입니다. 
이 메커니즘(스트림이 항상 `Error`, `Loading`, `State`의 세 가지 값을 사용하기 때문에 _triple_ 이라는 별명이 붙음)은 [분할된 상태 패턴 (Segmented State pattern)][Segmented State pattern]을 기반으로 합니다.

자세한 내용은 다음 리소스를 참조하세요.

* [Triple 문서][Triple documentation]
* [Flutter Triple 패키지][Flutter Triple package]
* [Triple 패턴: Flutter에서 상태 관리를 위한 새로운 패턴][Triple Pattern: A new pattern for state management in Flutter] (포르투갈어로 작성된 블로그 게시물이지만 자동 번역 가능)
* [비디오: Kevlin Ossada의 Flutter Triple 패턴][VIDEO: Flutter Triple Pattern by Kevlin Ossada](영어로 녹화)

[Triple documentation]: https://triple.flutterando.com.br/
[Flutter Triple package]: {{site.pub-pkg}}/flutter_triple
[Segmented State pattern]: https://triple.flutterando.com.br/docs/intro/overview#-segmented-state-pattern-ssp
[Triple Pattern: A new pattern for state management in Flutter]: https://blog.flutterando.com.br/triple-pattern-um-novo-padr%C3%A3o-para-ger%C3%AAncia-de-estado-no-flutter-2e693a0f4c3e
[VIDEO: Flutter Triple Pattern by Kevlin Ossada]: {{site.yt.watch}}?v=dXc3tR15AoA

## solidart {:#solidart}

SolidJS에서 영감을 받은 간단하지만 강력한 상태 관리 솔루션.

* [공식 문서][Official Documentation]
* [solidart 패키지][solidart package]
* [flutter_solidart 패키지][flutter_solidart package]

[Official Documentation]: https://docs.page/nank1ro/solidart
[solidart package]: {{site.pub-pkg}}/solidart
[flutter_solidart package]: {{site.pub-pkg}}/flutter_solidart

## flutter_reactive_value {:#flutter_reactive_value}

`flutter_reactive_value` 라이브러리는 Flutter에서 상태 관리를 위한 가장 간단한 솔루션을 제공할 수 있습니다. 
Flutter 초보자가, 이전에 설명한 메커니즘의 복잡성 없이, UI에 reactivity을 추가하는 데 도움이 될 수 있습니다. `flutter_reactive_value` 라이브러리는 `ValueNotifier`에서 `reactiveValue(BuildContext)` 확장 메서드를 정의합니다. 
이 확장을 통해, `Widget`은 `ValueNotifier`의 현재 값을 가져오고, 
`Widget`을 `ValueNotifier` 값의 변경 사항에 구독할 수 있습니다. 
`ValueNotifier`의 값이 변경되면, `Widget`이 다시 빌드됩니다.

* [`flutter_reactive_value`][] 소스 및 문서

[`flutter_reactive_value`]: {{site.github}}/lukehutch/flutter_reactive_value
