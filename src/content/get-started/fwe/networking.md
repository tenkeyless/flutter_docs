---
# title: Networking and data
title: 네트워킹 및 데이터
# description: Learn how to network your Flutter app.
description: Flutter 앱을 네트워크로 연결하는 방법을 알아보세요.
prev:
  # title: Handling user input
  title: 사용자 입력 처리
  path: /get-started/fwe/user-input
next:
  # title: Local data and caching
  title: 로컬 데이터 및 캐싱
  path: /get-started/fwe/local-caching
---

"사람은 섬이 아니다"라는 말이 있지만, 네트워킹 기능이 없는 Flutter 앱은 약간 단절된 느낌을 줄 수 있습니다. 
이 페이지에서는 Flutter 앱에 네트워킹 기능을 추가하는 방법을 다룹니다. 
앱은 데이터를 검색하고, JSON을 메모리에서 사용 가능한 표현으로 구문 분석한 다음, 데이터를 다시 보냅니다.

## 네트워크를 통한 데이터 검색 소개 {:#introduction-to-retrieving-data-over-the-network}

다음 두 튜토리얼은 (Android, iOS, 웹 브라우저 내부 또는 Windows, macOS 또는 Linux에서 실행하든) 
앱이 [HTTP][] 요청을 쉽게 할 수 있도록 해주는 [`http`][] 패키지를 소개합니다. 
첫 번째 튜토리얼은 웹사이트에 인증되지 않은 `GET` 요청을 하는 방법, 검색된 데이터를 `JSON`으로 구문 분석한 다음, 
결과 데이터를 표시하는 방법을 보여줍니다. 
두 번째 튜토리얼은 인증 헤더를 추가하여, 첫 번째 튜토리얼을 기반으로 하여 권한이 필요한 웹 서버에 액세스할 수 있도록 합니다. Mozilla Developer Network(MDN)의 글은 웹에서 권한이 작동하는 방식에 대한 자세한 배경 정보를 제공합니다.

* 튜토리얼: [인터넷에서 데이터 가져오기][Fetch data from the internet]
* 튜토리얼: [인증된 요청 만들기][Make authenticated requests]
* 글: [웹사이트 권한 부여에 대한 MDN 글][MDN's article on Authorization for websites]

## 네트워크에서 검색된 데이터를 유용하게 만들기 {:#making-data-retrieved-from-the-network-useful}

네트워크에서 데이터를 검색하면, 네트워크의 데이터를 Dart에서 쉽게 작업할 수 있는 것으로 변환하는 방법이 필요합니다. 
이전 섹션의 튜토리얼에서는 Dart를 수동으로 사용하여, 네트워크 데이터를 메모리 내 표현으로 변환했습니다. 
이 섹션에서는, 이 변환을 처리하기 위한 다른 옵션을 살펴보겠습니다. 
첫 번째 링크는 [`freezed` 패키지][]에 대한 개요를 보여주는 YouTube 비디오로 연결됩니다. 
두 번째 링크는 JSON 구문 분석 사례 연구를 사용하여 패턴과 레코드를 다루는 코드랩으로 연결됩니다.

* YouTube 비디오: [Freezed(주간 패키지)][Freezed (Package of the Week)]
* 코드랩: [Dart의 패턴과 레코드 살펴보기][Dive into Dart's patterns and records]

## 양방향으로 이동하면서, 다시 데이터 가져오기 {:#going-both-ways-getting-data-out-again}

이제 데이터 검색 기술을 익혔으니, 이제 데이터를 푸시하는 방법을 살펴볼 차례입니다. 
이 정보는 네트워크로 데이터를 보내는 것으로 시작하지만, 그다음 비동기성으로 넘어갑니다. 
사실, 네트워크를 통해 대화를 나누면, 물리적으로 멀리 떨어진 웹 서버가 응답하는 데 시간이 걸릴 수 있고, 
패킷이 왕복할 때까지 화면 렌더링을 멈출 수 없다는 사실을 처리해야 합니다. 
Dart는 Flutter와 마찬가지로 비동기성을 훌륭하게 지원합니다. 
튜토리얼에서 Dart 지원에 대해 자세히 알아보고, Widget of the Week 비디오에서 Flutter의 기능을 다룹니다. 
이를 완료하면, DevTool의 네트워크 뷰를 사용하여 네트워크 트래픽을 디버깅하는 방법을 배우게 됩니다.

* 튜토리얼: [인터넷에 데이터 보내기][Send data to the internet]
* 튜토리얼: [비동기 프로그래밍: futures, async, await][Asynchronous programming: futures, async, await]
* YouTube 비디오: [FutureBuilder(주간 위젯)][FutureBuilder (Widget of the Week)]
* 글: [네트워크 뷰 사용하기][Using the Network View]

## 확장 자료 {:#extension-material}

이제 Flutter의 네트워킹 API를 사용하는 방법을 마스터했으므로, 
Flutter의 네트워크 사용을 컨텍스트에서 보는 것이 도움이 됩니다. 
첫 번째 코드랩(표면적으로는 Flutter에서 적응형 앱을 만드는 것)은, 
Dart로 작성된 웹 서버를 사용하여 웹 브라우저의 [Cross-Origin Resource Sharing(CORS) 제한][Cross-Origin Resource Sharing (CORS) restrictions]을 해결합니다.

:::note
이미 [layout][] 페이지에서 이 코드랩을 진행했다면, 이 단계를 건너뛰어도 됩니다.
:::

[layout]: /get-started/fwe/layout

다음으로, Flutter DevRel 동문인 Fitz가 Flutter 앱에 데이터 위치가 중요한 이유에 대해 설명하는, 
긴 형식의 YouTube 동영상입니다. 
마지막으로, Flutter GDE Anna (Domashych) Leushchenko가 
Flutter의 고급 네트워킹을 다루는 정말 유용한 일련의 글입니다.

* 코드랩: [Flutter의 적응형 앱][Adaptive apps in Flutter]
* 비디오: [로컬 유지: Flutter 앱의 데이터 관리][Keeping it local: Managing a Flutter app's data]
* 글 시리즈: [Dart와 Flutter의 기본 및 고급 네트워킹][Basic and advanced networking in Dart and Flutter]

[Adaptive apps in Flutter]: {{site.codelabs}}/codelabs/flutter-adaptive-app
[Asynchronous programming: futures, async, await]: {{site.dart-site}}/codelabs/async-await
[Basic and advanced networking in Dart and Flutter]: {{site.medium}}/tide-engineering-team/basic-and-advanced-networking-in-dart-and-flutter-the-tide-way-part-0-introduction-33ac040a4a1c
[Cross-Origin Resource Sharing (CORS) restrictions]: https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS
[Dive into Dart's patterns and records]: {{site.codelabs}}/codelabs/dart-patterns-records
[Fetch data from the internet]: /cookbook/networking/fetch-data
[Freezed (Package of the Week)]: {{site.youtube-site}}/watch?v=RaThk0fiphA
[`freezed` package]: {{site.pub-pkg}}/freezed
[FutureBuilder (Widget of the Week)]: {{site.youtube-site}}/watch?v=zEdw_1B7JHY
[`http`]: {{site.pub-pkg}}/http
[HTTP]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview
[Keeping it local: Managing a Flutter app's data]: {{site.youtube-site}}/watch?v=uCbHxLA9t9E
[Make authenticated requests]: /cookbook/networking/authenticated-requests
[MDN's article on Authorization for websites]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Authorization
[Using the Network View]: /tools/devtools/network
[Send data to the internet]: /cookbook/networking/send-data

## 피드백 {:#feedback}

이 웹사이트의 이 섹션이 발전하기 때문에, 우리는 [당신의 피드백을 환영합니다][welcome your feedback]!

[welcome your feedback]: https://google.qualtrics.com/jfe/form/SV_6A9KxXR7XmMrNsy?page="networking"
