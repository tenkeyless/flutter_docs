---
# title: Flutter's build modes
title: Flutter 빌드 모드
# description: Describes Flutter's build modes and when you should use debug, release, or profile mode.
description: Flutter의 빌드 모드를 설명하고 디버그, 릴리스 또는 프로파일 모드를 사용해야 하는 경우를 설명합니다.
---

Flutter 툴링은 앱을 컴파일할 때 세 가지 모드를 지원하고, 테스트를 위해 헤드리스 모드를 지원합니다. 
개발 주기의 어느 단계에 있는지에 따라 컴파일 모드를 선택합니다. 
코드를 디버깅하고 있습니까? 프로파일링 정보가 필요합니까? 앱을 배포할 준비가 되었습니까?

어떤 모드를 사용해야 하는지에 대한 간단한 요약은 다음과 같습니다.

* [핫 리로드][hot reload]를 사용하고 싶을 때, 개발 중에 [디버그](#debug) 모드를 사용합니다.
* 성능을 분석하고 싶을 때, [프로필](#profile) 모드를 사용합니다.
* 앱을 릴리스할 준비가 되었을 때, [릴리스](#release) 모드를 사용합니다.

나머지 페이지에서는 이러한 모드에 대해 자세히 설명합니다.

* 헤드리스 테스트 모드에 대해 알아보려면, 엔진 위키의 [Flutter의 빌드 모드][Flutter's build modes]에 대한 문서를 참조하세요.
* 빌드 모드를 감지하는 방법을 알아보려면, [Flutter 앱에서 디버그/릴리스 모드 확인][Check for Debug/Release Mode in Flutter Apps] 블로그 게시물을 확인하세요.

[Check for Debug/Release Mode in Flutter Apps]: https://retroportalstudio.medium.com/check-for-debug-release-mode-in-flutter-apps-d8d545f20da3

## Debug {:#debug}

_디버그 모드_ 에서, 앱은 물리적 장치, 에뮬레이터 또는 시뮬레이터에서 디버깅하도록 설정됩니다.

모바일 앱의 디버그 모드는 다음을 의미합니다.

* [어설션][Assertions]이 활성화됩니다.
* 서비스 확장이 활성화됩니다.
* 컴파일은 빠른 개발 및 실행 주기에 최적화됩니다. (실행 속도, 바이너리 크기 또는 배포에는 최적화되지 않음)
* 디버깅이 활성화되고, 소스 레벨 디버깅을 지원하는 도구(예: [DevTools][])가 프로세스에 연결할 수 있습니다.

웹 앱의 디버그 모드는 다음을 의미합니다.

* 빌드가 _축소되지 않고_, 트리 셰이킹이 _수행되지_ 않습니다.
* 앱이 더 쉬운 디버깅을 위해 [dartdevc][] 컴파일러로 컴파일됩니다.

기본적으로, `flutter run`은 디버그 모드로 컴파일됩니다. IDE에서 이 모드를 지원합니다. 
예를 들어, Android Studio는 **Run > Debug...** 메뉴 옵션과, 
프로젝트 페이지에 작은 삼각형이 겹쳐진 녹색 버그 아이콘을 제공합니다.

:::note
* 핫 리로드는 _디버그 모드에서만_ 작동합니다.
* 에뮬레이터와 시뮬레이터는 _디버그 모드에서만_ 실행됩니다.
* 애플리케이션 성능은 디버그 모드에서 janky 할 수 있습니다. 실제 기기에서 [profile](#profile) 모드에서 성능을 측정하세요.
:::

## Release {:#release}

앱을 배포할 때 최대 최적화와 최소 풋프린트 크기를 원할 때, _릴리스 모드_ 를 사용하세요. 
모바일의 경우, 릴리스 모드(시뮬레이터나 에뮬레이터에서 지원되지 않음)는 다음을 의미합니다.

* 어설션이 비활성화됩니다.
* 디버깅 정보가 제거됩니다.
* 디버깅이 비활성화됩니다.
* 컴파일은 빠른 시작, 빠른 실행 및 작은 패키지 크기에 최적화됩니다.
* 서비스 확장이 비활성화됩니다.

웹 앱의 릴리스 모드는 다음을 의미합니다.

* 빌드가 최소화되고 트리 셰이킹이 수행됩니다.
* 앱은 최상의 성능을 위해 [dart2js][] 컴파일러로 컴파일됩니다.

`flutter run --release` 명령은 릴리스 모드로 컴파일합니다. IDE는 이 모드를 지원합니다. 
예를 들어, Android Studio는 **Run > Run...** 메뉴 옵션과, 
프로젝트 페이지에 삼각형 녹색 실행 버튼 아이콘을 제공합니다. 
`flutter build <target>`를 사용하여 특정 대상에 대한 릴리스 모드로 컴파일할 수 있습니다. 
지원되는 대상 리스트는 `flutter help build`를 사용하세요.

자세한 내용은 [iOS][] 및 [Android][] 앱 출시에 대한 문서를 참조하세요.

## Profile {:#profile}

_프로필 모드_ 에서는, (앱의 성능을 프로파일링하기에 충분한) 일부 디버깅 기능이 유지됩니다. 
에뮬레이터와 시뮬레이터에서는 프로필 모드가 비활성화되어 있습니다. 실제 성능을 나타내지 않기 때문입니다. 
모바일에서, 프로필 모드는 릴리스 모드와 유사하지만, 다음과 같은 차이점이 있습니다.

* 성능 오버레이를 활성화하는 것과 같은, 일부 서비스 확장이 활성화됩니다.
* 추적이 활성화되고, 소스 레벨 디버깅을 지원하는 도구(예: [DevTools][])가 프로세스에 연결할 수 있습니다.

웹 앱의 프로필 모드는 다음을 의미합니다.

* 빌드가 축소되지는 _않지만_ 트리 셰이킹이 수행됩니다.
* 앱이 [dart2js][] 컴파일러로 컴파일되었습니다.
* DevTools는 프로필 모드에서 실행되는 Flutter 웹 앱에 연결할 수 없습니다. 
  Chrome DevTools를 사용하여 웹 앱의 [타임라인 이벤트 생성][generate timeline events]을 수행합니다.

IDE가 이 모드를 지원합니다. 
예를 들어, Android Studio는 **Run > Profile...** 메뉴 옵션을 제공합니다. 
`flutter run --profile` 명령은 프로파일 모드로 컴파일합니다.

:::note
[DevTools][] 제품군을 사용하여 앱의 성능을 프로파일링하세요.
:::

빌드 모드에 대한 자세한 내용은 [Flutter의 빌드 모드][Flutter's build modes]를 참조하세요.


[Android]: /deployment/android
[Assertions]: {{site.dart-site}}/language/error-handling#assert
[dart2js]: {{site.dart-site}}/tools/dart2js
[dartdevc]: {{site.dart-site}}/tools/dartdevc
[DevTools]: /tools/devtools
[Flutter's build modes]: {{site.repo.engine}}/blob/main/docs/Flutter's-modes.md
[generate timeline events]: {{site.developers}}/web/tools/chrome-devtools/evaluate-performance/performance-reference
[hot reload]: /tools/hot-reload
[iOS]: /deployment/ios
