---
# title: Testing Flutter apps
title: Flutter 앱 테스트
# description: 
#   Learn more about the different types of testing and how to write them.
description: 
  다양한 타입의 테스트와 테스트 작성 방법에 대해 자세히 알아보세요.
---

앱의 기능이 많을수록, 수동으로 테스트하기가 더 어렵습니다. 
자동화된 테스트는 기능과 버그 수정 속도를 유지하면서, 
앱을 게시하기 전에 앱이 올바르게 작동하는지 확인하는 데 도움이 됩니다.

:::note
Flutter 앱 테스트를 직접 연습하려면, [Flutter 앱 테스트 방법][How to test a Flutter app] 코드랩을 참조하세요.
:::

자동화된 테스트는 몇 가지 카테고리로 나뉩니다.

* [_유닛 테스트_](#unit-tests)는 단일 함수, 메서드 또는 클래스를 테스트합니다.
* [_위젯 테스트_](#widget-tests)(다른 UI 프레임워크에서는 _구성 요소 테스트_ 라고 함)는 단일 위젯을 테스트합니다.
* [_통합 테스트_](#integration-tests)는 전체 앱 또는 앱의 큰 부분을 테스트합니다.

일반적으로, 잘 테스트된 앱에는 [코드 커버리지][code coverage]로 추적되는, 
많은 유닛 및 위젯 테스트와 모든 중요한 사용 사례를 포괄할 만큼 충분한 통합 테스트가 있습니다. 
이 조언은 아래에서 볼 수 있듯이, 다양한 종류의 테스트 간에 상충 관계(trade-offs)가 있다는 사실에 근거합니다.

| 트레이드 오프             | 유닛   | 위젯 | 통합 |
|----------------------|--------|--------|-------------|
| **신뢰도(Confidence)** | 낮음 | 높음 | 가장 높음 |
| **유지 관리 비용(Maintenance cost)** | 낮음 | 높음 | 가장 높음 |
| **종속성(Dependencies)** | 적음 | 많음 | 가장 많음 |
| **실행 속도(Execution speed)** | 빠름 | 빠름 | 느림 |


{:.table .table-striped}

## 유닛 테스트 {:#unit-tests}

_유닛 테스트_ 는 단일 함수, 메서드 또는 클래스를 테스트합니다. 
유닛 테스트의 목적은 다양한 조건에서 로직 유닛의 정확성을 확인하는 것입니다. 
테스트 중인 유닛의 외부 종속성은 일반적으로 [Mock](/cookbook/testing/unit/mocking)됩니다. 
유닛 테스트는 일반적으로 디스크에서 읽거나 쓰거나, 화면에 렌더링하거나, 
테스트를 실행하는 프로세스 외부에서 사용자 작업을 수신하지 않습니다. 
유닛 테스트에 대한 자세한 내용은 다음 레시피를 보거나 터미널에서 `flutter test --help`를 실행할 수 있습니다.

:::note
플러그인을 사용하는 코드에 대한 유닛 테스트를 작성하고 충돌을 피하고 싶다면, 
[Flutter 테스트의 플러그인][Plugins in Flutter tests]을 확인하세요. 
Flutter 플러그인을 테스트하고 싶다면 [플러그인 테스트][Testing plugins]를 확인하세요.
:::

[Plugins in Flutter tests]: /testing/plugins-in-tests
[Testing plugins]: /testing/testing-plugins

### 레시피 {:#recipes .no_toc}

{% include docs/testing-toc.md type='unit' %}

## 위젯 테스트 {:#widget-tests}

_위젯 테스트_ (다른 UI 프레임워크에서는 _컴포넌트 테스트_ 라고 함)는 단일 위젯을 테스트합니다. 
위젯 테스트의 목표는 위젯의 UI가 예상대로 보이고, 상호 작용하는지 확인하는 것입니다. 
위젯 테스트에는 여러 클래스가 포함되며, 적절한 위젯 라이프사이클 컨텍스트를 제공하는 테스트 환경이 필요합니다.

예를 들어, 테스트되는 위젯은 사용자 작업 및 이벤트를 수신하고 응답하고, 레이아웃을 수행하고, 
자식 위젯을 인스턴스화할 수 있어야 합니다. 
따라서 위젯 테스트는 유닛 테스트보다 포괄적입니다. 
그러나, 유닛 테스트와 마찬가지로 위젯 테스트의 환경은 본격적인 UI 시스템보다 훨씬 간단한 구현으로 대체됩니다.

### 레시피 {:#recipes-1 .no_toc}

{% include docs/testing-toc.md type='widget' %}

## 통합 테스트 {:#integration-tests}

_통합 테스트_ 는 전체 앱 또는 앱의 큰 부분을 테스트합니다. 
통합 테스트의 목표는 테스트 중인 모든 위젯과 서비스가 예상대로 함께 작동하는지 확인하는 것입니다. 
또한 통합 테스트를 사용하여 앱의 성능을 확인할 수 있습니다.

일반적으로 _통합 테스트_ 는 iOS 시뮬레이터나 Android 에뮬레이터와 같은 실제 기기나 OS 에뮬레이터에서 실행됩니다. 
테스트 중인 앱은 일반적으로 결과를 왜곡하지 않도록 테스트 드라이버 코드에서 분리됩니다.

통합 테스트를 작성하는 방법에 대한 자세한 내용은 [통합 테스트 페이지][integration testing page]를 참조하세요.

### 레시피 {:#recipes-2 .no_toc}

{% include docs/testing-toc.md type='integration' %}

## 지속적인 통합 서비스 (Continuous integration services) {:#continuous-integration-services}

CI(Continuous Integration) 서비스를 사용하면 새 코드 변경 사항을 푸시할 때 자동으로 테스트를 실행할 수 있습니다. 
이를 통해, 코드 변경 사항이 예상대로 작동하고 버그가 발생하지 않는지에 대한 적시 피드백을 제공합니다.

다양한 지속적 통합 서비스에서 테스트를 실행하는 방법에 대한 자세한 내용은 다음을 참조하세요.

* [Flutter와 함께 fastlane을 사용한 지속적 배포][Continuous delivery using fastlane with Flutter]
* [Appcircle에서 Flutter 앱 테스트][Test Flutter apps on Appcircle]
* [Travis에서 Flutter 앱 테스트][Test Flutter apps on Travis]
* [Cirrus에서 Flutter 앱 테스트][Test Flutter apps on Cirrus]
* [Flutter용 Codemagic CI/CD][Codemagic CI/CD for Flutter]
* [Bitrise를 사용한 Flutter CI/CD][Flutter CI/CD with Bitrise]


[code coverage]: https://en.wikipedia.org/wiki/Code_coverage
[Codemagic CI/CD for Flutter]: https://blog.codemagic.io/getting-started-with-codemagic/
[Continuous delivery using fastlane with Flutter]: /deployment/cd#fastlane
[Flutter CI/CD with Bitrise]: https://devcenter.bitrise.io/en/getting-started/quick-start-guides/getting-started-with-flutter-apps
[How to test a Flutter app]: {{site.codelabs}}/codelabs/flutter-app-testing
[Test Flutter apps on Appcircle]: https://blog.appcircle.io/article/flutter-ci-cd-github-ios-android-web#
[Test Flutter apps on Cirrus]: https://cirrus-ci.org/examples/#flutter
[Test Flutter apps on Travis]: {{site.flutter-medium}}/test-flutter-apps-on-travis-3fd5142ecd8c
[integration testing page]: /testing/integration-tests
