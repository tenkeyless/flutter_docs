---
# title: Multiple Flutter screens or views
title: 여러 개의 Flutter 화면 또는 뷰
# short-title: Add multiple Flutters
short-title: 여러 개의 Flutter 추가
# description: >
#   How to integrate multiple instances of 
#   Flutter engine, screens, or views to your application.
description: >
  여러 Flutter 엔진, 화면 또는 뷰 인스턴스를 애플리케이션에 통합하는 방법입니다.
---

## 시나리오 {:#scenarios}

기존 앱에 Flutter를 통합하거나, 기존 앱을 점진적으로 마이그레이션하여 Flutter를 사용하는 경우, 
동일한 프로젝트에 여러 Flutter 인스턴스를 추가하고 싶을 수 있습니다. 
특히, 다음 시나리오에서 유용할 수 있습니다.

* 통합된 Flutter 화면이 네비게이션 그래프의 리프 노드가 아니고, 
  네비게이션 스택이 네이티브 -> Flutter -> 네이티브 -> Flutter의 하이브리드 혼합일 수 있는 애플리케이션.
* 여러 부분 화면 Flutter 뷰가 통합되어 한 번에 표시될 수 있는 화면.

여러 개의 Flutter 인스턴스를 사용하는 이점은, 
각 인스턴스가 독립적이고 자체 내부 네비게이션 스택, UI 및 애플리케이션 상태를 유지한다는 것입니다. 
이를 통해 전체 애플리케이션 코드의 상태 유지 책임이 간소화되고 모듈성이 향상됩니다. 
여러 개의 Flutter 사용을 촉진하는 시나리오에 대한 자세한 내용은, 
[flutter.dev/go/multiple-flutters][]에서 확인할 수 있습니다.

Flutter는 이 시나리오에 최적화되어 있으며, 
추가 Flutter 인스턴스를 추가하는 데 필요한 증분 메모리 비용(~180kB)이 낮습니다. 
이 고정 비용 감소를 통해, 
여러 개의 Flutter 인스턴스 패턴을 앱 추가 통합에 보다 자유롭게 사용할 수 있습니다.

## 컴포넌트 {:#components}

Android와 iOS에서 여러 Flutter 인스턴스를 추가하기 위한 기본 API는, 
이전에 사용된 `FlutterEngine` 생성자가 아닌 `FlutterEngine`을 구성하는, 
새로운 `FlutterEngineGroup` 클래스([Android API][], [iOS API][])를 기반으로 합니다.

`FlutterEngine` API는 직접적이고 사용하기 쉬웠지만, 
동일한 `FlutterEngineGroup`에서 생성된 `FlutterEngine`은 
GPU 컨텍스트, 글꼴 메트릭, 격리 그룹 스냅샷과 같은 많은 공통적이고 재사용 가능한 리소스를 공유하여, 
초기 렌더링 지연 시간을 단축하고 메모리 사용량을 줄이는 성능 이점이 있습니다.

* `FlutterEngineGroup`에서 생성된 `FlutterEngine`은 
  일반적으로 구성된 캐시된 `FlutterEngine`과 같은 방식으로, 
  ([`FlutterActivity`][] 또는 [`FlutterViewController`][]와 같은) 
  UI 클래스에 연결하는 데 사용할 수 있습니다.

* `FlutterEngineGroup`에서 생성된 첫 번째 `FlutterEngine`은, 
  항상 적어도 1개의 살아있는 `FlutterEngine`이 있는 한, 
  후속 `FlutterEngine`이 리소스를 공유하기 위해 계속 생존할 필요가 없습니다.

* `FlutterEngineGroup`에서 첫 번째 `FlutterEngine`을 만드는 것은, 
  이전에 생성자를 사용하여 `FlutterEngine`을 구성하는 것과 동일한 [성능 특성][performance characteristics]을 갖습니다.

* `FlutterEngineGroup`에서 모든 `FlutterEngine`이 파괴되면, 
  생성된 다음 `FlutterEngine`은 첫 번째 엔진과 동일한 성능 특성을 갖습니다.

* `FlutterEngineGroup` 자체는 생성된 모든 엔진을 넘어 생존할 필요가 없습니다. 
  `FlutterEngineGroup`을 삭제해도 기존에 생성된 `FlutterEngine`에는 영향을 미치지 않지만, 
  기존에 생성된 엔진과 리소스를 공유하는 추가 `FlutterEngine`을 생성하는 기능은 삭제됩니다.

## 커뮤니케이션 {:#communication}

Flutter 인스턴스 간 통신은 호스트 플랫폼을 통해, 
[platform channels][](또는 [Pigeon][])를 사용하여 처리됩니다. 
통신에 대한 로드맵이나 여러 Flutter 인스턴스를 향상시키기 위한 다른 계획된 작업을 보려면, 
[Issue 72009][]를 확인하세요.

## 샘플 {:#samples}

Android와 iOS에서 모두 `FlutterEngineGroup`을 사용하는 방법을 보여주는 샘플은, 
[GitHub][]에서 찾을 수 있습니다.

{% render docs/app-figure.md, image:"development/add-to-app/multiple-flutters-sample.gif", alt:"A sample demonstrating multiple-Flutters" %}

[GitHub]: {{site.repo.samples}}/tree/main/add_to_app/multiple_flutters
[`FlutterActivity`]: {{site.api}}/javadoc/io/flutter/embedding/android/FlutterActivity.html
[`FlutterViewController`]: {{site.api}}/ios-embedder/interface_flutter_view_controller.html
[performance characteristics]: /add-to-app/performance
[flutter.dev/go/multiple-flutters]: /go/multiple-flutters
[Issue 72009]: {{site.repo.flutter}}/issues/72009
[Pigeon]: {{site.pub}}/packages/pigeon
[platform channels]: /platform-integration/platform-channels
[Android API]: https://cs.opensource.google/flutter/engine/+/master:shell/platform/android/io/flutter/embedding/engine/FlutterEngineGroup.java
[iOS API]: https://cs.opensource.google/flutter/engine/+/master:shell/platform/darwin/ios/framework/Headers/FlutterEngineGroup.h
