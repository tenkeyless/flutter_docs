---
# title: Load sequence, performance, and memory
title: 로드 순서, 성능 및 메모리
# description: What are the steps involved when showing a Flutter UI.
description: Flutter UI를 보여줄 때 필요한 단계는 무엇인가요?
---

이 페이지에서는 Flutter UI를 보여주는 데 필요한 단계의 세부 내용을 설명합니다. 
이를 알면, 언제 Flutter 엔진을 사전 워밍업(pre-warm)해야 하는지, 
어떤 작업이 어떤 단계에서 가능한지, 
해당 작업의 대기 시간(latency)과 메모리 비용에 대해 더 나은지, 
더 정보에 입각한 결정을 내릴 수 있습니다.

## Flutter 로딩 {:#loading-flutter}

Android 및 iOS 앱(기존 앱과 통합할 수 있는 두 가지 지원 플랫폼), 
전체 Flutter 앱 및 앱에 추가(add-to-app) 패턴은 Flutter UI를 표시할 때, 
개념적 로딩 단계 순서가 비슷합니다.

### Flutter 리소스 찾기 {:#finding-the-flutter-resources}

Flutter의 엔진 런타임과 애플리케이션의 컴파일된 Dart 코드는 모두 Android와 iOS에서 공유 라이브러리로 번들로 제공됩니다. 
Flutter를 로드하는 첫 번째 단계는 .apk/.ipa/.app에서 해당 리소스를 찾는 것입니다.
(해당되는 경우 이미지, 글꼴, JIT 코드와 같은 다른 Flutter assets과 함께)

이는 **[Android][android-engine]** 및 **[iOS][ios-engine]** API에서 처음으로 `FlutterEngine`을 구성할 때 발생합니다.

:::note
일부 패키지에서는 네이티브 애플리케이션에서 Flutter 화면으로 이미지와 글꼴을 공유할 수 있습니다. 
예를 들어:
* [native_font]({{site.pub-pkg}}/native_font)
* [ios_platform_images]({{site.pub-pkg}}/ios_platform_images)
:::

### Flutter 라이브러리 로딩 {:#loading-the-flutter-library}

발견되면, 엔진의 공유 라이브러리는 프로세스당 한 번씩 메모리에 로드됩니다.

**Android**에서는 JNI 커넥터가 Flutter C++ 라이브러리를 참조해야 하기 때문에, [`FlutterEngine`][android-engine]이 생성될 때도 이런 일이 발생합니다. 
**iOS**에서는 [`FlutterEngine`][ios-engine]이 처음 실행될 때(예: [`runWithEntrypoint:`][] 실행), 이런 일이 발생합니다.

### Dart VM 시작 {:#starting-the-dart-vm}

Dart 런타임은 Dart 코드의 Dart 메모리와 동시성을 관리하는 역할을 합니다. 
JIT 모드에서는 런타임 중에 Dart 소스 코드를 머신 코드로 컴파일하는 역할도 합니다.

Android와 iOS에서는 애플리케이션 세션당 하나의 Dart 런타임이 존재합니다.

**Android**에서 처음으로 [`FlutterEngine`][android-engine]을 구성할 때와, 
**iOS**에서 처음으로 [Dart 진입점][ios-engine]을 실행할 때, 
한 번의 Dart VM 시작이 수행됩니다.

이 시점에서 Dart 코드의 [스냅샷][snapshot]도 애플리케이션 파일에서 메모리로 로드됩니다.

이는 Flutter 엔진 없이 [Dart SDK][]를 직접 사용한 경우에도 발생하는 일반적인 프로세스입니다.

Dart VM은 시작된 후에는 절대 종료되지 않습니다.

### Dart Isolate 생성 및 실행 {:#creating-and-running-a-dart-isolate}

Dart 런타임이 초기화되면, Flutter 엔진에서 Dart 런타임을 사용하는 것이 다음 단계입니다.

이는 Dart 런타임에서 [Dart `Isolate`][]를 시작하여 수행됩니다. 
Isolate은 메모리와 스레드를 위한 Dart의 컨테이너입니다. 
호스트 플랫폼에서 여러 개의 [보조 스레드][auxiliary threads]도 이 시점에서 생성되어, 
GPU 처리를 오프로드하기 위한 스레드와 이미지 디코딩을 위한 스레드와 같이 Isolate을 지원합니다.

`FlutterEngine` 인스턴스당 하나의 Isolate이 존재하고, 
여러 Isolate을 동일한 Dart VM에서 호스팅할 수 있습니다.

**Android**에서, 이는 `FlutterEngine` 인스턴스에서 [`DartExecutor.executeDartEntrypoint()`][]를 호출할 때 발생합니다.

**iOS**에서, 이는 `FlutterEngine`에서 [`runWithEntrypoint:`][]를 호출할 때 발생합니다.

이 시점에서, Dart 코드의 선택된 진입점(기본적으로, Dart 라이브러리의 `main.dart` 파일에 있는 `main()` 함수)이 실행됩니다. 
`main()` 함수에서 Flutter 함수 [`runApp()`][]를 호출한 경우, 
Flutter 앱이나 라이브러리의 위젯 트리도 생성되고 빌드됩니다. 
Flutter 코드에서 특정 기능이 실행되는 것을 방지해야 하는 경우, 
`AppLifecycleState.detached` 열거형 값은 `FlutterEngine`이 iOS의 `FlutterViewController` 또는 Android의 `FlutterActivity`와 같은 UI 구성 요소에 연결되지 않았음을 나타냅니다.

### Flutter 엔진에 UI 연결 {:#attaching-a-ui-to-the-flutter-engine}

표준적인 전체 Flutter 앱은 앱이 시작되자마자 이 상태에 도달합니다.

앱에 추가 시나리오에서, 
이는 **Android**에서 [`FlutterActivity.withCachedEngine()`][]을 사용하여 빌드된 [`Intent`][]로 [`startActivity()`][]를 호출하는 것과 같이, UI 구성 요소에 `FlutterEngine`을 연결할 때 발생합니다. 
또는 **iOS**에서 [`initWithEngine: nibName: bundle:`][]을 사용하여 초기화된 [`FlutterViewController`][]를 제공합니다.

이는 Flutter UI 구성 요소가 **Android**에서 [`FlutterActivity.createDefaultIntent()`][]를 사용하거나, 
**iOS**에서 [`FlutterViewController initWithProject: nibName: bundle:`][]를 사용하여, `FlutterEngine`을 미리 예열하지 않고 시작된 경우에도 해당합니다. 
이러한 경우 암묵적인 `FlutterEngine`이 생성됩니다.

Behind the scene에서, 
두 플랫폼의 UI 구성 요소는 `FlutterEngine`에 **Android**의 [`Surface`][] 또는 **iOS**의 [CAEAGLLayer][] 또는 [CAMetalLayer][]와 같은 렌더링 표면을 제공합니다.

이 시점에서, 프레임당 Flutter 프로그램에서 생성된 [`Layer`][] 트리는, 
OpenGL(또는 Vulkan 또는 Metal) GPU 명령어로 변환됩니다.

## 메모리 및 대기 시간 (latency) {:#memory-and-latency}

Flutter UI를 보여주는 데는 사소한 지연 비용(latency cost)이 발생합니다. 
이 비용은 Flutter 엔진을 미리 시작(ahead of time)하면, 줄일 수 있습니다.

앱 추가(add-to-app) 시나리오에 가장 적합한 선택은 `FlutterEngine`을 미리 로드할 시기
(즉, Flutter 라이브러리를 로드하고, Dart VM을 시작하고 격리된 곳에서 진입점을 실행할 때)와 
사전 워밍의 메모리 및 지연 비용이 얼마인지 결정하는 것입니다. 
또한 사전 워밍이 UI 구성 요소가 이후에 `FlutterEngine`에 연결될 때 첫 번째 Flutter 프레임을 렌더링하는 데 드는 메모리 및 지연 비용에 어떤 영향을 미치는지도 알아야 합니다.

Flutter v1.10.3부터, 릴리스 AOT 모드에서 low-end 2015년형 기기에서 테스트한 결과, 
`FlutterEngine`을 사전 워밍하는 데 드는 비용은 다음과 같습니다.

* **Android**에서 사전 워밍하는 데 42MB와 1530ms가 필요합니다.
  그 중 330ms는 메인 스레드에서 차단 호출입니다.
* **iOS**에서 사전 워밍하는 데 22MB, 860ms.
  그 중 260ms는 메인 스레드에서 차단 호출입니다.

Flutter UI는 사전 워밍 중에 첨부할 수 있습니다. 
남은 시간은 첫 번째 프레임 대기 시간(time-to-first-frame)까지 걸리는 시간에 결합됩니다.

메모리 측면에서, 비용 샘플(사용 사례에 따라 가변적)은 다음과 같습니다.

* pthread를 만드는 데 사용되는 OS의 메모리 사용량 ~4MB
* GPU 드라이버 메모리 ~10MB
* Dart 런타임 관리 메모리에 대해 ~1MB
* Dart 로드된 글꼴 맵에 대해 ~5MB

대기 시간 측면에서 비용 샘플(사용 사례에 따라 가변적)은 다음과 같습니다.

* 애플리케이션 패키지에서 Flutter assets을 수집하는 데 ~20ms
* Flutter 엔진 라이브러리를 dlopen하는 데 ~15ms
* Dart VM을 만들고 AOT 스냅샷을 로드하는 데 ~200ms
* Flutter 종속 글꼴 및 assets을 로드하는 데 ~200ms
* 진입점을 실행하고 첫 번째 위젯 트리를 만들고, 필요한 GPU 셰이더 프로그램을 컴파일하는 데 ~400ms

`FlutterEngine`은 필요한 메모리 소비를 지연시키기에 충분히 늦게 사전 워밍업해야 하지만, 
Flutter 엔진 시작 시간과 Flutter를 보여주는 첫 번째 프레임 지연을 결합하지 않기에, 
충분히 일찍 사전 워밍업해야 합니다.

정확한 타이밍은 앱의 구조와 휴리스틱에 따라 달라집니다. 
예를 들어, Flutter가 화면을 그리기 전에 Flutter 엔진을 화면에 로드하는 것입니다.

엔진이 사전 워밍업된 경우, UI 연결의 첫 번째 프레임 비용은 다음과 같습니다.

* **Android**에서 320ms 및 추가 12MB
  (화면의 물리적 픽셀 크기에 따라 크게 다름).
* **iOS**에서 200ms 및 추가 16MB
  (화면의 물리적 픽셀 크기에 따라 크게 다름).

메모리 측면에서, 비용은 주로 렌더링에 사용되는 그래픽 메모리 버퍼이며 화면 크기에 따라 달라집니다.

지연 측면에서, 비용은 주로 OS 콜백이 Flutter에 렌더링 표면을 제공하기를 기다리고, 
사전에 예측할 수 없는 나머지 셰이더 프로그램을 컴파일하는 것입니다. 이는 일회성 비용입니다.

Flutter UI 구성 요소가 릴리스되면 UI 관련 메모리가 해제됩니다. 
이는 `FlutterEngine`에 있는 Flutter 상태에는 영향을 미치지 않습니다. 
(`FlutterEngine`도 릴리스되지 않는 한)

두 개 이상의 `FlutterEngine`을 만드는 것에 대한 성능 세부 정보는 [여러 Flutter][multiple Flutters]를 참조하세요.

[android-engine]: {{site.api}}/javadoc/io/flutter/embedding/engine/FlutterEngine.html
[auxiliary threads]: {{site.repo.flutter}}/blob/master/docs/about/The-Engine-architecture.md#threading
[CAEAGLLayer]: {{site.apple-dev}}/documentation/quartzcore/caeagllayer
[CAMetalLayer]: {{site.apple-dev}}/documentation/quartzcore/cametallayer
[Dart `Isolate`]: {{site.dart.api}}/stable/dart-isolate/Isolate-class.html
[Dart SDK]: {{site.dart-site}}/tools/sdk
[`DartExecutor.executeDartEntrypoint()`]: {{site.api}}/javadoc/io/flutter/embedding/engine/dart/DartExecutor.html#executeDartEntrypoint-io.flutter.embedding.engine.dart.DartExecutor.DartEntrypoint-
[`FlutterActivity.createDefaultIntent()`]: {{site.api}}/javadoc/io/flutter/embedding/android/FlutterActivity.html#createDefaultIntent-android.content.Context-
[`FlutterActivity.withCachedEngine()`]: {{site.api}}/javadoc/io/flutter/embedding/android/FlutterActivity.html#withCachedEngine-java.lang.String-
[`FlutterViewController`]: {{site.api}}/ios-embedder/interface_flutter_view_controller.html
[`FlutterViewController initWithProject: nibName: bundle:`]: {{site.api}}/ios-embedder/interface_flutter_view_controller.html#aa3aabfb89e958602ce6a6690c919f655
[`initWithEngine: nibName: bundle:`]: {{site.api}}/ios-embedder/interface_flutter_view_controller.html#a0aeea9525c569d5efbd359e2d95a7b31
[`Intent`]: {{site.android-dev}}/reference/android/content/Intent.html
[ios-engine]: {{site.api}}/ios-embedder/interface_flutter_engine.html
[`Layer`]: {{site.api}}/flutter/rendering/Layer-class.html
[multiple Flutters]: /add-to-app/multiple-flutters
[`runApp()`]: {{site.api}}/flutter/widgets/runApp.html
[`runWithEntrypoint:`]: {{site.api}}/ios-embedder/interface_flutter_engine.html#a019d6b3037eff6cfd584fb2eb8e9035e
[snapshot]: {{site.github}}/dart-lang/sdk/wiki/Snapshots
[`startActivity()`]: {{site.android-dev}}/reference/android/content/Context#startActivity(android.content.Intent)
[`Surface`]: {{site.android-dev}}/reference/android/view/Surface
