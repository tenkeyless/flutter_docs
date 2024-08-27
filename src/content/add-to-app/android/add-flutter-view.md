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

Unlike the guides for FlutterActivity and FlutterFragment, the FlutterView
integration could be better demonstrated with a sample project.

A sample project is at [https://github.com/flutter/samples/tree/main/add_to_app/android_view]({{site.repo.samples}}/tree/main/add_to_app/android_view)
to document a simple FlutterView integration where FlutterViews are used
for some of the cells in a RecycleView list of cards as seen in the gif above.

## 일반적인 접근 방식 {:#general-approach}

The general gist of the FlutterView-level integration is that you must recreate
the various interactions between your Activity, the [FlutterView]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html)
and the [FlutterEngine]({{site.api}}/javadoc/io/flutter/embedding/engine/FlutterEngine.html)
present in the [FlutterActivityAndFragmentDelegate](https://cs.opensource.google/flutter/engine/+/master:shell/platform/android/io/flutter/embedding/android/FlutterActivityAndFragmentDelegate.java)
in your own application's code. The connections made in the [FlutterActivityAndFragmentDelegate](https://cs.opensource.google/flutter/engine/+/master:shell/platform/android/io/flutter/embedding/android/FlutterActivityAndFragmentDelegate.java)
are done automatically when using a [FlutterActivity]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterActivity.html)
or a [FlutterFragment]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterFragment.html),
but since the [FlutterView]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html)
in this case is being added to an Activity or Fragment in your application,
you must recreate the connections manually. Otherwise, the [FlutterView]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html)
will not render anything or have other missing functionalities.

A sample [FlutterViewEngine]({{site.repo.samples}}/blob/main/add_to_app/android_view/android_view/app/src/main/java/dev/flutter/example/androidView/FlutterViewEngine.kt)
class shows one such possible implementation of an application-specific
connection between an Activity, a [FlutterView]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html)
and a [FlutterEngine]({{site.api}}/javadoc/io/flutter/embedding/engine/FlutterEngine.html).

### 구현할 API {:#apis-to-implement}

The absolute minimum implementation needed for Flutter to draw anything at all
is to:

- Call [attachToFlutterEngine]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html#attachToFlutterEngine-io.flutter.embedding.engine.FlutterEngine-) when the
  [FlutterView]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html)
  is added to a resumed Activity's view hierarchy and is visible; and
- Call [appIsResumed]({{site.api}}/javadoc/io/flutter/embedding/engine/systemchannels/LifecycleChannel.html#appIsResumed--) on the [FlutterEngine]({{site.api}}/javadoc/io/flutter/embedding/engine/FlutterEngine.html)'s
  `lifecycleChannel` field when the Activity hosting the [FlutterView]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html)
  is visible.

The reverse [detachFromFlutterEngine]({{site.api}}/javadoc/io/flutter/embedding/android/FlutterView.html#detachFromFlutterEngine--) and other lifecycle methods on the [LifecycleChannel]({{site.api}}/javadoc/io/flutter/embedding/engine/systemchannels/LifecycleChannel.html)
class must also be called to not leak resources when the FlutterView or Activity
is no longer visible.

In addition, see the remaining implementation in the [FlutterViewEngine]({{site.repo.samples}}/blob/main/add_to_app/android_view/android_view/app/src/main/java/dev/flutter/example/androidView/FlutterViewEngine.kt)
demo class or in the [FlutterActivityAndFragmentDelegate](https://cs.opensource.google/flutter/engine/+/master:shell/platform/android/io/flutter/embedding/android/FlutterActivityAndFragmentDelegate.java)
to ensure a correct functioning of other features such as clipboards, system
UI overlay, plugins etc.
