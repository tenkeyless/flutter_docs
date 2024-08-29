---
# title: Embedded support for Flutter
title: Flutter에 대한 임베디드 지원
# description: >
#   Details of how Flutter supports the creation of embedded experiences.
description: >
  Flutter가 임베디드 경험 생성을 지원하는 방법에 대한 자세한 내용입니다.
---

자동차, 냉장고, 온도 조절기에 Flutter 엔진을 내장하고 싶다면... 가능합니다! 
예를 들어, 다음과 같은 상황에서 Flutter를 내장할 수 있습니다.

* 일반적으로 스마트 디스플레이, 온도 조절기 등과 같은 저전력 하드웨어 장치인 "임베디드 장치"에서 Flutter 사용.
* 새로운 모바일 플랫폼이나 새로운 운영 체제와 같이 새로운 운영 체제나 환경에 Flutter 내장.

Flutter를 내장하는 기능은 안정적이지만, 낮은 레벨 API를 사용하며 초보자에게는 _적합하지 않습니다_. 
아래에 나열된 리소스 외에도 Flutter 개발자(Google 엔지니어 포함)가 
Flutter의 다양한 측면을 논의하는 [Discord][]에 가입하는 것을 고려할 수 있습니다. 
Flutter [커뮤니티][community] 페이지에는 더 많은 커뮤니티 리소스에 대한 정보가 있습니다.

* Flutter 위키의 [커스텀 Flutter 엔진 임베더][Custom Flutter Engine Embedders].
* GitHub의 [Flutter 엔진 `embedder.h` 파일][Flutter engine `embedder.h` file]에 있는 문서 주석.
* docs.flutter.dev의 [Flutter 아키텍처 개요][Flutter architectural overview].
* Flutter 엔진 GitHub 리포지토리의 작고 독립적인 [Flutter 임베더 엔진 GLFW 예제][Flutter Embedder Engine GLFW example].
* Flutter의 커스텀 임베더 API를 구현하여 [터미널에 Flutter 내장][embedding Flutter in a terminal]에 대한 탐색.
* [문제 31043][Issue 31043]: _플러터 엔진을 새로운 OS로 이식하기 위한 질문_ 도 도움이 될 수 있습니다.

[community]: {{site.main-url}}/community
[Discord]: https://discord.com/invite/N7Yshp4
[Custom Flutter Engine Embedders]: {{site.repo.engine}}/blob/main/docs/Custom-Flutter-Engine-Embedders.md
[Flutter architectural overview]: /resources/architectural-overview
[Flutter engine `embedder.h` file]: {{site.repo.engine}}/blob/main/shell/platform/embedder/embedder.h
[Flutter Embedder Engine GLFW example]: {{site.repo.engine}}/tree/main/examples/glfw#flutter-embedder-engine-glfw-example
[embedding Flutter in a terminal]: https://github.com/jiahaog/flt
[Issue 31043]: {{site.repo.flutter}}/issues/31043


