---
# title: Integration testing concepts
title: 통합 테스트 개념
# description: Learn about integration testing in Flutter.
description: Flutter의 통합 테스트에 대해 알아보세요.
# short-title: Introduction
short-title: 소개
---

<?code-excerpt path-base="cookbook/testing/integration/introduction/"?>

유닛 테스트와 위젯 테스트는 개별 클래스, 함수 또는 위젯을 검증합니다. 
개별 조각이 전체적으로 어떻게 함께 작동하는지 검증하거나, 실제 장치에서 실행되는 앱의 성능을 포착하지 않습니다. 
이러한 작업을 수행하려면, *통합 테스트(integration tests)* 를 사용하세요.

통합 테스트는 전체 앱의 동작을 검증합니다. 
이 테스트는 엔드투엔드 테스트 또는 GUI 테스트라고도 합니다.

Flutter SDK에는 [integration_test][] 패키지가 포함되어 있습니다.

## 용어 {:#terminology}

**호스트 머신 (host machine)**
: 데스크톱 컴퓨터처럼, 당신이 앱을 개발하는 시스템입니다.

**타겟 장치 (target device)**
: Flutter 앱을 실행하는 모바일 기기, 브라우저 또는 데스크톱 애플리케이션.

  웹 브라우저나 데스크톱 애플리케이션에서 앱을 실행하는 경우, 호스트 머신과 대상 기기는 동일합니다.

## 종속 패키지 {:#dependent-package}

통합 테스트를 실행하려면, `integration_test` 패키지를 Flutter 앱 테스트 파일에 대한 종속성으로 추가합니다.

`flutter_driver`를 사용하는 기존 프로젝트를 마이그레이션하려면, [flutter_driver에서 마이그레이션][Migrating from flutter_driver] 가이드를 참조하세요.

`integration_test` 패키지로 작성된 테스트는 다음 작업을 수행할 수 있습니다.

* 대상 기기에서 실행합니다. 여러 Android 또는 iOS 기기를 테스트하려면, Firebase Test Lab을 사용합니다.
* `flutter test integration_test`로 호스트 머신에서 실행합니다.
* `flutter_test` API를 사용합니다. 이렇게 하면 통합 테스트가 [위젯 테스트][widget tests]를 작성하는 것과 유사해집니다.

## 통합 테스트의 사용 사례 {:#use-cases-for-integration-testing}

이 섹션의 다른 가이드에서는 통합 테스트를 사용하여 [기능][functionality] 및 [성능][performance]을 검증하는 방법을 설명합니다.

[functionality]: /testing/integration-tests/
[performance]: /cookbook/testing/integration/profiling/
[integration_test]: {{site.repo.flutter}}/tree/main/packages/integration_test
[Migrating from flutter_driver]:
    /release/breaking-changes/flutter-driver-migration
[widget tests]: /testing/overview#widget-tests
