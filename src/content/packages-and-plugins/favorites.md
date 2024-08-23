---
# title: Flutter Favorite program
title: Flutter Favorite 프로그램
# description: Guidelines for identifying a plugin or package as a Flutter Favorite.
description: 플러그인이나 패키지를 Flutter Favorite로 식별하기 위한 지침입니다.
---

![The Flutter Favorite program logo](/assets/images/docs/development/packages-and-plugins/FlutterFavoriteLogo.png){:width="20%"}

**Flutter Favorite** 프로그램의 목적은 앱을 빌드할 때 먼저 고려해야 할 패키지와 플러그인을 식별하는 것입니다. 
이는 특정 상황에 대한 품질이나 적합성을 보장하지 않습니다. 
항상 프로젝트에 대한 패키지와 플러그인을 직접 평가해야 합니다.

pub.dev에서 [Flutter Favorite 패키지][Flutter Favorite packages]의 전체 리스트를 볼 수 있습니다.

:::note
여러분이 Happy Paths 추천을 찾으려고 여기에 왔다면, 
우리는 Flutter Favorites를 선호하면서 해당 프로젝트를 중단했습니다.
:::

## 메트릭 {:#metrics}

Flutter Favorite 패키지는 다음 지표를 사용하여 고품질 표준을 통과시킵니다.

* [전체 패키지 점수][Overall package score]
* **허용 라이선스**, Apache, Artistic, BSD, CC BY, MIT, MS-PL 및 W3C를 포함하되, 이에 국한되지 않음
* GitHub **버전 태그**는 pub.dev의 현재 버전과 일치하도록 하여, 패키지에 어떤 소스가 있는지 정확히 볼 수 있도록 합니다.
* 기능 **완전성**&mdash;미완료로 표시되지 않음(예: "베타" 또는 "건설 중"과 같은 레이블)
* [검증된 게시자][Verified publisher]
* 개요, 문서, 샘플/예시 코드 및 API 품질과 관련하여 일반적인 **사용성**
* CPU 및 메모리 사용 측면에서 우수한 **런타임 동작**
* 고품질 **종속성**

## Flutter Ecosystem Committee {:#flutter-ecosystem-committee}

Flutter Ecosystem Committee는 Flutter 팀원과 Flutter 커뮤니티 구성원으로 구성되어 있으며, 
Flutter Ecosystem Committee는 Flutter Favorite가 되기 위한 품질 기준을
패키지가 충족했는지 여부를 결정하는 역할을 합니다.

현재 위원회 구성원(성(last name)의 알파벳순)은 다음과 같습니다.

* Pooja Bhaumik
* Hillel Coren
* Simon Lightfoot
* Lara Martín
* John Ryan
* Diego Velasquez
* Ander Dobo

패키지나 플러그인을 잠재적인 미래의 Flutter Favorite로 지명하거나 다른 문제를 위원회에 알리고 싶다면, 
[위원회에 보내기][send the committee] 이메일을 보내세요.

## Flutter Favorite 사용 가이드라인 {:#flutter-favorite-usage-guidelines}

Flutter Favorite 패키지는 Flutter 팀에서 pub.dev에 그렇게 표시합니다. 
Flutter Favorite로 지정된 패키지를 소유하고 있다면, 다음 지침을 준수해야 합니다.

* Flutter Favorite 패키지 작성자는 
  패키지의 GitHub README, 패키지의 pub.dev **개요** 탭, 
  해당 패키지에 대한 게시물과 관련하여, 소셜 미디어에 Flutter Favorite 로고를 배치할 수 있습니다.
* 소셜 미디어에서 **#FlutterFavorite** 해시태그를 사용하는 것이 좋습니다.
* Flutter Favorite 로고를 사용할 때, 
  작성자는 (이) Flutter Favorite 랜딩 페이지에 링크하여, 지정에 대한 맥락을 제공해야 합니다.
* Flutter Favorite 패키지가 Flutter Favorite 상태를 잃으면, 작성자에게 알림이 전송되고, 
  이때 작성자는 영향을 받는 패키지에서 "Flutter Favorite"와 Flutter Favorite 로고의 모든 사용을 즉시 제거해야 합니다.
* Flutter Favorite 로고를 어떤 식으로든 변경, 왜곡 또는 수정하지 마세요. 
  여기에는 색상 변형이나 승인되지 않은 시각적 요소가 있는 로고를 표시하는 것도 포함됩니다.
* Flutter Favorite 로고를 오해의 소지가 있거나, 불공평하거나, 명예 훼손적이거나, 
  침해적이거나, 중상 모략적이거나, 비방적이거나, 음란하거나, 
  그 밖에 Google에 불쾌감을 주는 방식으로 표시하지 마세요.

## 다음은 무엇인가요? {:#whats-next}

생태계가 계속 발전함에 따라 Flutter Favorite 패키지 리스트가 성장하고 변경될 것으로 예상해야 합니다. 
위원회는 패키지 작성자와 협력하여 품질을 높이고 도구, 컨설팅 회사, 다작하는 Flutter 기여자와 같이, 
Flutter Favorite 프로그램의 혜택을 볼 수 있는 생태계의 다른 영역을 고려할 것입니다.

Flutter 생태계가 성장함에 따라, 다음을 포함할 수 있는 메트릭 세트를 확장하는 것을 고려할 것입니다.

* 플러그인이 지원하는 플랫폼을 명확하게 나타내는 [pubspec.yaml 형식][pubspec.yaml format] 사용.
* 최신 안정 버전의 Flutter 지원.
* AndroidX 지원.
* 웹, macOS, Windows, Linux 등 여러 플랫폼 지원.
* 통합 및 유닛 테스트 커버리지.

## Flutter Favorites {:#flutter-favorites}

[Flutter Favorite 패키지][Flutter Favorite packages]의 전체 리스트는 pub.dev에서 확인할 수 있습니다.


[send the committee]: mailto:flutter-committee@googlegroups.com
[Flutter Favorite packages]: {{site.pub}}/flutter/favorites
[Overall package score]: {{site.pub}}/help
[pubspec.yaml format]: /packages-and-plugins/developing-packages#plugin-platforms
[Verified publisher]: {{site.dart-site}}/tools/pub/verified-publishers
