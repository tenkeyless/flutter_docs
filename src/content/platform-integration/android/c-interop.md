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

A native library can be linked into an app either
dynamically or statically. A statically linked library
is embedded into the app's executable image,
and is loaded when the app starts.

Symbols from a statically linked library can be
loaded using [`DynamicLibrary.executable`][] or
[`DynamicLibrary.process`][].

A dynamically linked library, by contrast, is distributed
in a separate file or folder within the app,
and loaded on-demand. On Android, a dynamically
linked library is distributed as a set of `.so` (ELF)
files, one for each architecture.

A dynamically linked library can be loaded into
Dart via [`DynamicLibrary.open`][].

API documentation is available from the Dart dev channel:
[Dart API reference documentation][].

On Android, only dynamic libraries are supported
(because the main executable is the JVM,
which we don't link to statically).


[Dart API reference documentation]: {{site.dart.api}}/dev/
[`DynamicLibrary.executable`]: {{site.dart.api}}/dev/dart-ffi/DynamicLibrary/DynamicLibrary.executable.html
[`DynamicLibrary.open`]: {{site.dart.api}}/dev/dart-ffi/DynamicLibrary/DynamicLibrary.open.html
[`DynamicLibrary.process`]: {{site.dart.api}}/dev/dart-ffi/DynamicLibrary/DynamicLibrary.process.html

## FFI 플러그인 생성 {:#create-an-ffi-plugin}

To create an FFI plugin called "native_add",
do the following:

```console
$ flutter create --platforms=android,ios,macos,windows,linux --template=plugin_ffi native_add
$ cd native_add
```

:::note
You can exclude platforms from `--platforms` that you don't want
to build to. However, you need to include the platform of 
the device you are testing on.
:::

This will create a plugin with C/C++ sources in `native_add/src`.
These sources are built by the native build files in the various
os build folders.

The FFI library can only bind against C symbols,
so in C++ these symbols are marked `extern "C"`.

You should also add attributes to indicate that the
symbols are referenced from Dart,
to prevent the linker from discarding the symbols
during link-time optimization.
`__attribute__((visibility("default"))) __attribute__((used))`.

On Android, the `native_add/android/build.gradle` links the code.

The native code is invoked from dart in `lib/native_add_bindings_generated.dart`.

The bindings are generated with [package:ffigen]({{site.pub-pkg}}/ffigen).

## 다른 사용 사례 {:#other-use-cases}

### Platform 라이브러리 {:#platform-library}

To link against a platform library,
use the following instructions:

 1. Find the desired library in the [Android NDK Native APIs][]
    list in the Android docs. This lists stable native APIs.
 1. Load the library using [`DynamicLibrary.open`][].
    For example, to load OpenGL ES (v3):

    ```dart
    DynamicLibrary.open('libGLES_v3.so');
    ```

You might need to update the Android manifest
file of the app or plugin if indicated by
the documentation.


[Android NDK Native APIs]: {{site.android-dev}}/ndk/guides/stable_apis

#### 퍼스트파티 라이브러리 {:#first-party-library}

The process for including native code in source
code or binary form is the same for an app or
plugin.

#### 오픈소스 서드파티 {:#open-source-third-party}

Follow the [Add C and C++ code to your project][]
instructions in the Android docs to
add native code and support for the native
code toolchain (either CMake or `ndk-build`).


[Add C and C++ code to your project]: {{site.android-dev}}/studio/projects/add-native-code

#### 폐쇄형 소스 서드파티 라이브러리 {:#closed-source-third-party-library}

To create a Flutter plugin that includes Dart
source code, but distribute the C/C++ library
in binary form, use the following instructions:

1. Open the `android/build.gradle` file for your
   project.
1. Add the AAR artifact as a dependency.
   **Don't** include the artifact in your
   Flutter package. Instead, it should be
   downloaded from a repository, such as
   JCenter.


## Android APK 크기(공유 객체 압축) {:#android-apk-size-shared-object-compression}

[Android guidelines][] in general recommend
distributing native shared objects uncompressed
because that actually saves on device space.
Shared objects can be directly loaded from the APK
instead of unpacking them on device into a
temporary location and then loading.
APKs are additionally packed in transit&mdash;that's
why you should be looking at download size.

Flutter APKs by default don't follow these guidelines
and compress `libflutter.so` and `libapp.so`&mdash;this
leads to smaller APK size but larger on device size.

Shared objects from third parties can change this default
setting with `android:extractNativeLibs="true"` in their
`AndroidManifest.xml` and stop the compression of `libflutter.so`,
`libapp.so`, and any user-added shared objects.
To re-enable compression, override the setting in
`your_app_name/android/app/src/main/AndroidManifest.xml`
in the following way.

```xml diff
  <manifest xmlns:android="http://schemas.android.com/apk/res/android"
-     package="com.example.your_app_name">
+     xmlns:tools="http://schemas.android.com/tools"
+     package="com.example.your_app_name" >
      <!-- io.flutter.app.FlutterApplication is an android.app.Application that
           calls FlutterMain.startInitialization(this); in its onCreate method.
           In most cases you can leave this as-is, but you if you want to provide
           additional functionality it is fine to subclass or reimplement
           FlutterApplication and put your custom class here. -->

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