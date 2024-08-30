---
# title: Flutter documentation
title: Flutter 문서
# short-title: Docs
short-title: 문서
# description: Get started with Flutter. Widgets, examples, updates, and API docs to help you write your first Flutter app.
description: Flutter를 시작하세요. 첫 번째 Flutter 앱을 작성하는 데 도움이 되는 위젯, 예제, 업데이트 및 API 문서.
---

<div class="card-grid">
{% for card in docs_cards -%}
    <a class="card" href="{{card.url}}">
      <div class="card-body">
        <header class="card-title">{{card.name}}</header>
        <p class="card-text">{{card.description}}</p>
      </div>
    </a>
{% endfor %}
</div>

**마지막 릴리스 이후 사이트의 변경 사항을 보려면, [새로운 기능][What's new]을 참조하세요.**

[What's new]: /release/whats-new

---

## 번역 사이트 개요 {:#translated}

[Flutter 문서 사이트](https://docs.flutter.dev/)의 한글 번역입니다.

|       |      |
|:-----:|:----|
| Flutter 버전 | 3.24.0 |
| 최종 업데이트 | 2024-08-31 |
| 웹사이트 주소 | [flutter-docs-kr.web.app](https://flutter-docs-kr.web.app/) |
| GitHub 주소 | <https://github.com/tenkeyless/flutter_docs/tree/develop> |

{:.table .table-striped}

- Github 사이트에서 태그가 달린 버전 및 날짜에 해당하는 문서를 Docker 통해 구동할 수 있습니다.
- 애플 실리콘의 Docker를 통해서 구동할 수도 있습니다.
- 주기적으로, [flutter docs Github](https://github.com/flutter/website)에서 문서를 fork 및 업데이트하여, 최신으로 유지할 예정입니다.
- 몇몇 내용은 번역되지 않은 부분이 있을 수 있습니다. 이후, 추가로 번역이 진행될 예정입니다.
  - [Flutter for 파트](/get-started/flutter-for/)
  - [Flutter 중요한 변경사항](/release/breaking-changes/)
  - [Flutter 역대 릴리즈 노트](/release/release-notes/)
  - [Flutter DevTools 릴리즈 노트](/tools/devtools/release-notes/)

---


## Flutter를 처음 사용하시나요? {:#new-to-flutter}

[시작하기][Get started]와 
[첫 번째 Flutter 앱 작성하기][Write your first Flutter app]를 마치면 다음 단계는 다음과 같습니다.

[Write your first Flutter app]: /get-started/codelab

### 문서 {:#docs}

다른 플랫폼에서 오셨나요? 
다음을 위한 Flutter를 확인해 보세요: 
[Android][], [SwiftUI][], [UIKit][], [React Native][], [Xamarin.Forms][] 개발자를 위한 Flutter.

[레이아웃 빌드][Building layouts]
: 모든 것이 위젯인 Flutter에서, 레이아웃을 만드는 방법을 알아보세요.

[제약 조건 이해][Understanding constraints]
: "제약 조건은 아래로 흐릅니다. 크기는 위로 흐릅니다. 부모는 위치를 설정합니다"라는 것을 이해하면, 
  Flutter의 레이아웃 모델을 이해하는 데 큰 도움이 됩니다.

[Flutter 앱에 상호 작용 추가][interactivity]
: 앱에 stateful 위젯을 추가하는 방법을 알아보세요.

[FAQ][]
: 자주 묻는 질문에 대한 답변을 확인하세요.

[Android]: /get-started/flutter-for/android-devs
[Building layouts]: /ui/layout
[FAQ]: /resources/faq
[Get started]: /get-started/install
[interactivity]: /ui/interactivity
[SwiftUI]: /get-started/flutter-for/swiftui-devs
[UIKit]: /get-started/flutter-for/uikit-devs
[React Native]: /get-started/flutter-for/react-native-devs
[Understanding constraints]: /ui/layout/constraints
[Xamarin.Forms]: /get-started/flutter-for/xamarin-forms-devs

### 비디오 {:#videos}

Flutter 소개 시리즈를 확인하세요. 
[첫 번째 Flutter 앱을 만드는 방법][first-app]과 같은 Flutter 기본 사항을 알아보세요. 
Flutter에서는 "모든 것이 위젯입니다"! 
[State란 무엇인가][What is State?]에서, `Stateless` 및 `Stateful` 위젯에 대해 자세히 알아보세요.

<div class="card-grid">
    <div class="card">
        <div class="card-body">
            {% ytEmbed 'xWV71C2kp38', 'Create your first Flutter app', true, true %}
        </div>
    </div>
    <div class="card">
        <div class="card-body">
            {% ytEmbed 'QlwiL_yLh6E', 'What is state?', true, true %}
        </div>
    </div>
</div>

[first-app]: {{site.yt.watch}}?v=xWV71C2kp38
[What is State?]: {{site.yt.watch}}?v=QlwiL_yLh6E

{% videoWrapper '60초 밖에 없나요? Flutter 앱을 빌드하고 배포하는 방법을 알아보세요!' %}
{% ytEmbed 'ZnufaryH43s', 'How to build and deploy a Flutter app in 60 seconds!', true %}
{% endvideoWrapper %}

## 기술을 향상시키고 싶나요? {:#want-to-skill-up}

Flutter가 후드 아래에서 어떻게 작동하는지 더 자세히 알아보세요! 
[헬퍼 메서드를 사용하는 대신 독립형 위젯을 작성하는 이유][standalone-widgets] 또는 
["BuildContext"란 무엇이고 어떻게 사용합니까][buildcontext]를 알아보세요.

<div class="card-grid">
    <div class="card">
        <div class="card-body">
            {% ytEmbed 'IOyq-eTRhvo', 'Widgets vs helper methods | Decoding Flutter', true, true %}
        </div>
    </div>
    <div class="card">
        <div class="card-body">
            {% ytEmbed 'rIaaH87z1-g', 'BuildContext?! | Decoding Flutter', true, true %}
        </div>
    </div>
</div>

[standalone-widgets]: {{site.yt.watch}}?v=IOyq-eTRhvo
[buildcontext]: {{site.yt.watch}}?v=rIaaH87z1-g

모든 Flutter 비디오 시리즈에 대해 알아보려면, [videos][] 페이지를 참조하세요.

Flutter YouTube 채널에서 거의 매주 새로운 비디오를 공개합니다.

<a class="btn btn-primary" target="_blank" href="https://www.youtube.com/@flutterdev">더 많은 Flutter 비디오 탐색</a>

[videos]: /resources/videos
