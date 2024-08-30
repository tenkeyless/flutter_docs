---
# title: "Binding to native Android code using dart:ffi"
title: "dart:ffi를 사용하여 네이티브 Android 코드에 바인딩"
# description: "To use C code in your Flutter program, use the dart:ffi library."
description: "Flutter 프로그램에서 C 코드를 사용하려면, dart:ffi 라이브러리를 사용하세요."
---

<?code-excerpt path-base="platform_integration"?>

Flutter 모바일 및 데스크톱 앱은 [dart:ffi][] 라이브러리를 사용하여, 네이티브 C API를 호출할 수 있습니다. 
_FFI_ 는 [_외부 함수 인터페이스 (foreign function interface)_][FFI]의 약자입니다. 
유사한 기능에 대한 다른 용어로는 _네이티브 인터페이스(native interface)_ 및 _언어 바인딩(language bindings)_ 이 있습니다.

:::note
이 페이지에서는 Android 앱에서 `dart:ffi` 라이브러리를 사용하는 방법을 설명합니다. 
iOS에 대한 정보는, [dart:ffi를 사용하여 네이티브 iOS 코드에 바인딩][ios-ffi]를 참조하세요. 
macOS에 대한 정보는, [dart:ffi를 사용하여 네이티브 macOS 코드에 바인딩][macos-ffi]를 참조하세요. 
이 기능은 아직 웹 플러그인에서 지원되지 않습니다.
:::

[ios-ffi]: /platform-integration/ios/c-interop
[dart:ffi]: {{site.dart.api}}/dev/dart-ffi/dart-ffi-library.html
[macos-ffi]: /platform-integration/macos/c-interop
[FFI]: https://en.wikipedia.org/wiki/Foreign_function_interface

라이브러리나 프로그램이 FFI 라이브러리를 사용하여 네이티브 코드에 바인딩하려면, 
네이티브 코드가 로드되고 해당 심볼이 Dart에서 볼 수 있는지 확인해야 합니다. 
이 페이지는 Flutter 플러그인이나 앱 내에서 Android 네이티브 코드를 컴파일, 패키징, 로드하는 데 중점을 둡니다.

이 튜토리얼은 Flutter 플러그인에서 C/C++ 소스를 번들로 묶고, 
Android와 iOS에서 Dart FFI 라이브러리를 사용하여 바인딩하는 방법을 보여줍니다. 
이 연습에서는 32비트 추가를 구현한 다음 "native_add"라는 Dart 플러그인을 통해 노출하는 C 함수를 만듭니다.

## Dynamic vs static 링크 {:#dynamic-vs-static-linking}

네이티브 라이브러리는 동적으로 또는 정적으로 앱에 링크될 수 있습니다. 
정적으로 링크된 라이브러리는 앱의 실행 파일 이미지에 내장되고, 앱이 시작될 때 로드됩니다.

정적으로 링크된 라이브러리의 심볼은 
[`DynamicLibrary.executable`][] 또는 [`DynamicLibrary.process`][]를 사용하여 로드할 수 있습니다.

반면, 동적으로 링크된 라이브러리는 앱 내의 별도 파일이나 폴더에 배포되고 필요에 따라 로드됩니다. 
Android에서 동적으로 링크된 라이브러리는 각 아키텍처에 대해 하나씩 `.so`(ELF) 파일 세트로 배포됩니다.

동적으로 링크된 라이브러리는 [`DynamicLibrary.open`][]을 통해 Dart에 로드할 수 있습니다.

API 문서는 Dart 개발 채널에서 제공됩니다: [Dart API 참조 문서][Dart API reference documentation].

Android에서는 동적 라이브러리만 지원됩니다. (메인 실행 파일이 정적으로 링크하지 않는 JVM이기 때문)

[Dart API reference documentation]: {{site.dart.api}}/dev/
[`DynamicLibrary.executable`]: {{site.dart.api}}/dev/dart-ffi/DynamicLibrary/DynamicLibrary.executable.html
[`DynamicLibrary.open`]: {{site.dart.api}}/dev/dart-ffi/DynamicLibrary/DynamicLibrary.open.html
[`DynamicLibrary.process`]: {{site.dart.api}}/dev/dart-ffi/DynamicLibrary/DynamicLibrary.process.html

## FFI 플러그인 생성 {:#create-an-ffi-plugin}

"native_add"라는 FFI 플러그인을 만들려면, 다음을 수행하세요.

```console
$ flutter create --platforms=android,ios,macos,windows,linux --template=plugin_ffi native_add
$ cd native_add
```

:::note
빌드하고 싶지 않은 플랫폼을 `--platforms`에서 제외할 수 있습니다. 
그러나 테스트하는 기기의 플랫폼을 포함해야 합니다.
:::

이렇게 하면 `native_add/src`에 C/C++ 소스가 있는 플러그인이 생성됩니다. 
이러한 소스는 다양한 os 빌드 폴더의 네이티브 빌드 파일에 의해 빌드됩니다.

FFI 라이브러리는 C 심볼에 대해서만 바인딩할 수 있으므로, C++에서 이러한 심볼은 `extern "C"`로 표시됩니다.

또한 심볼이 Dart에서 참조된다는 것을 나타내는 속성을 추가하여, 
링커가 링크 타임 최적화 중에 심볼을 삭제하지 못하도록 해야 합니다. 
`__attribute__((visibility("default"))) __attribute__((used))`.

Android에서 `native_add/android/build.gradle`은 코드를 연결합니다.

네이티브 코드는 `lib/native_add_bindings_generated.dart`에서 dart에서 호출됩니다.

바인딩은 [package:ffigen]({{site.pub-pkg}}/ffigen)으로 생성됩니다.

## 다른 사용 사례 {:#other-use-cases}

### Platform 라이브러리 {:#platform-library}

플랫폼 라이브러리에 링크하려면, 다음 지침을 따르세요.

1. Android 문서의 [Android NDK Native APIs][] 리스트에서 원하는 라이브러리를 찾으세요. 
   여기에는 안정적인 네이티브 API가 나열되어 있습니다.
2. [`DynamicLibrary.open`][]을 사용하여 라이브러리를 로드합니다. 
   예를 들어, OpenGL ES(v3)를 로드하려면 다음과 같이 합니다.

    ```dart
    DynamicLibrary.open('libGLES_v3.so');
    ```

문서에 명시된 경우, 앱이나 플러그인의 Android 매니페스트 파일을 업데이트해야 할 수도 있습니다.

[Android NDK Native APIs]: {{site.android-dev}}/ndk/guides/stable_apis

#### 퍼스트파티 라이브러리 {:#first-party-library}

네이티브 코드를 소스 코드나 바이너리 형태로 포함하는 프로세스는 앱이나 플러그인의 경우와 동일합니다.

#### 오픈소스 서드파티 {:#open-source-third-party}

Android 문서의 [프로젝트에 C 및 C++ 코드 추가][Add C and C++ code to your project] 지침에 따라, 
네이티브 코드를 추가하고 네이티브 코드 툴체인(CMake 또는 `ndk-build`)을 지원합니다.

[Add C and C++ code to your project]: {{site.android-dev}}/studio/projects/add-native-code

#### 폐쇄형 소스 서드파티 라이브러리 {:#closed-source-third-party-library}

Dart 소스 코드를 포함하지만, C/C++ 라이브러리를 바이너리 형태로 배포하는, 
Flutter 플러그인을 만들려면 다음 지침을 따르세요.

1. 프로젝트의 `android/build.gradle` 파일을 엽니다.
1. AAR 아티팩트를 종속성으로 추가합니다. 
   **Flutter 패키지에 아티팩트를 포함하지 마세요**. 
   대신, JCenter와 같은 리포지토리에서 다운로드해야 합니다.

## Android APK 크기(공유 객체 압축) {:#android-apk-size-shared-object-compression}

[Android 가이드라인][Android guidelines]은 일반적으로 압축되지 않은 네이티브 공유 객체를 배포하는 것을 권장합니다. 
이는 실제로 장치 공간을 절약하기 때문입니다. 
공유 객체는 임시 위치에 장치에서 압축을 푼 다음 로드하는 대신 APK에서 직접 로드할 수 있습니다. 
APK는 또한 전송 중에도 압축되므로 다운로드 크기를 살펴봐야 합니다.

기본적으로 Flutter APK는 이러한 가이드라인을 따르지 않고, `libflutter.so` 및 `libapp.so`를 압축합니다. 
이로 인해, APK 크기는 작아지지만 장치 크기는 커집니다.

타사의 공유 객체는 `AndroidManifest.xml`에서 `android:extractNativeLibs="true"`로 이 기본 설정을 변경하고, 
`libflutter.so`, `libapp.so` 및 사용자가 추가한 모든 공유 객체의 압축을 중지할 수 있습니다. 
압축을 다시 활성화하려면, 
다음과 같이 `your_app_name/android/app/src/main/AndroidManifest.xml`의 설정을 재정의합니다.

```xml diff
  <manifest xmlns:android="http://schemas.android.com/apk/res/android"
-     package="com.example.your_app_name">
+     xmlns:tools="http://schemas.android.com/tools"
+     package="com.example.your_app_name" >
      <!-- io.flutter.app.FlutterApplication은 onCreate 메서드에서 
           FlutterMain.startInitialization(this);를 호출하는 
           android.app.Application입니다. 
           대부분의 경우, 그대로 둘 수 있지만, 추가 기능을 제공하려면, 
           FlutterApplication을 서브클래싱하거나 다시 구현하여, 
           여기에 커스텀 클래스를 넣어도 됩니다. -->

      <application
          android:name="io.flutter.app.FlutterApplication"
          android:label="your_app_name"
-         android:icon="@mipmap/ic_launcher">
+         android:icon="@mipmap/ic_launcher"
+         android:extractNativeLibs="true"
+         tools:replace="android:extractNativeLibs">
```

[Android guidelines]: {{site.android-dev}}/topic/performance/reduce-apk-size#extract-false

{% include docs/resource-links/ffi-video-resources.md %}