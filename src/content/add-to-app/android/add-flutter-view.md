---
# title: Add a Flutter View to an Android app
title: Android 앱에 Flutter View 추가
# short-title: Integrate via FlutterView
short-title: FlutterView를 통한 통합
# description: Learn how to perform advanced integrations via Flutter Views.
description: Flutter Views를 통해 고급 통합을 수행하는 방법을 알아보세요.
---

:::warning
[FlutterView]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html)를 통한 통합은 고급 사용 방법이며, 커스텀, 애플리케이션별 바인딩을 수동으로 생성해야 합니다.
:::

[FlutterView]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html)를 통한 통합은 이전에 설명한 FlutterActivity 및 FlutterFragment를 통한 것보다 약간 더 많은 작업이 필요합니다.

근본적으로, Dart 측의 Flutter 프레임워크는 작동하기 위해 다양한 activity-level 이벤트 및 라이프사이클에 액세스해야 합니다. 
FlutterView([android.view.View]({{site.android-dev}}/reference/android/view/View.html))는 개발자 애플리케이션이 소유한 모든 activity에 추가할 수 있고, 
FlutterView는 activity 레벨 이벤트에 액세스할 수 없으므로, 
개발자는 이러한 연결을 [FlutterEngine]({{site.api}}/javadoc/io/flutter/embedding/engine/FlutterEngine.html)에 수동으로 연결해야 합니다.

FlutterView에 애플리케이션의 activity 이벤트를 공급하는 방법은 애플리케이션에 따라 달라집니다.

## 샘플 {:#a-sample}

<img src='/assets/images/docs/development/add-to-app/android/add-flutter-view/add-view-sample.gif'
class="mw-100" alt="Add Flutter View sample video">

FlutterActivity 및 FlutterFragment에 대한 가이드와 달리, 
FlutterView 통합은 샘플 프로젝트로 더 잘 설명할 수 있습니다.

샘플 프로젝트는 [https://github.com/flutter/samples/tree/main/add_to_app/android_view]({{site.repo.samples}}/tree/main/add_to_app/android_view)에 있으며, 
위의 gif에서 볼 수 있듯이, 카드의 RecycleView 리스트에 있는 일부 셀에, 
FlutterView를 사용하는 간단한 FlutterView 통합을 문서화합니다.

## 일반적인 접근 방식 {:#general-approach}

FlutterView 레벨 통합의 일반적인 요지는 [FlutterActivityAndFragmentDelegate](https://cs.opensource.google/flutter/engine/+/master:shell/platform/android/io/flutter/embedding/android/FlutterActivityAndFragmentDelegate.java)에 있는 Activity, [FlutterView]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html) 및 [FlutterEngine]({{site.api}}/javadoc/io/flutter/embedding/engine/FlutterEngine.html) 간의 다양한 상호작용을 사용자 애플리케이션의 코드에서 다시 생성해야 한다는 것입니다. 
[FlutterActivityAndFragmentDelegate](https://cs.opensource.google/flutter/engine/+/master:shell/platform/android/io/flutter/embedding/android/FlutterActivityAndFragmentDelegate.java)에서 만들어진 연결은 [FlutterActivity]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterActivity.html) 또는 [FlutterFragment]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterFragment.html)를 사용할 때 자동으로 이루어지지만, 
이 경우 [FlutterView]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html)가 애플리케이션의 Activity 또는 Fragment에 추가되므로, 
연결을 수동으로 다시 만들어야 합니다. 
그렇지 않으면, [FlutterView]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html)는 아무것도 렌더링하지 않거나 다른 누락된 기능이 있습니다.

샘플 [FlutterViewEngine]({{site.repo.samples}}/blob/main/add_to_app/android_view/android_view/app/src/main/java/dev/flutter/example/androidView/FlutterViewEngine.kt) 클래스는 액티비티, [FlutterView]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html) 및 [FlutterEngine]({{site.api}}/javadoc/io/flutter/embedding/engine/FlutterEngine.html) 간의 애플리케이션별 연결에 대한 가능한 구현 중 하나를 보여줍니다.

### 구현할 API {:#apis-to-implement}

Flutter가 무엇이든 그리기 위해 필요한 최소한의 구현은 다음과 같습니다.

- [FlutterView]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html)가 재개된 Activity의 뷰 계층에 추가되고 표시될 때, [attachToFlutterEngine]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html#attachToFlutterEngine-io.flutter.embedding.engine.FlutterEngine-)을 호출합니다. 그리고
- [FlutterView]({{site.api}}/javadoc/io/flutter/embedding/engine/systemchannels/LifecycleChannel.html)를 호스팅하는 Activity가 표시될 때, [FlutterEngine]({{site.api}}/javadoc/io/flutter/embedding/engine/FlutterEngine.html)의 `lifecycleChannel` 필드에서 [appIsResumed]({{site.api}}/javadoc/io/flutter/embedding/engine/systemchannels/LifecycleChannel.html#appIsResumed--)를 호출합니다.

FlutterView 또는 Activity가 더 이상 표시되지 않을 때, 리소스가 누출되지 않도록, 
[LifecycleChannel]({{site.api}}/javadoc/io/flutter/embedding/engine/systemchannels/LifecycleChannel.html) 클래스의 역방향 [detachFromFlutterEngine]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html#detachFromFlutterEngine--) 및 기타 라이프사이클 메서드도 호출해야 합니다.

또한, [FlutterViewEngine]({{site.repo.samples}}/blob/main/add_to_app/android_view/android_view/app/src/main/java/dev/flutter/example/androidView/FlutterViewEngine.kt) 데모 클래스나 [FlutterActivityAndFragmentDelegate](https://cs.opensource.google/flutter/engine/+/master:shell/platform/android/io/flutter/embedding/android/FlutterActivityAndFragmentDelegate.java)에서 나머지 구현을 확인하여, 클립보드, 시스템 UI 오버레이, 플러그인 등과 같은 다른 기능이 올바르게 작동하는지 확인하세요.
