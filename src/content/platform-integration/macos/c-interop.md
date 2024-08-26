---
# title: "Binding to native macOS code using dart:ffi"
title: "dart:ffi를 사용하여 네이티브 macOS 코드에 바인딩"
# description: "To use C code in your Flutter program, use the dart:ffi library."
description: "Flutter 프로그램에서 C 코드를 사용하려면 dart:ffi 라이브러리를 사용하세요."
---

<?code-excerpt path-base="platform_integration"?>

Flutter 모바일 및 데스크톱 앱은 [dart:ffi][] 라이브러리를 사용하여, 
네이티브 C API를 호출할 수 있습니다. 
_FFI_는 [_외부 함수 인터페이스(foreign function interface)_][FFI]의 약자입니다. 
유사한 기능에 대한 다른 용어로는 _네이티브 인터페이스(native interface)_ 및 _언어 바인딩(language bindings)_ 이 있습니다.

:::note
이 페이지에서는 macOS 데스크톱 앱에서 `dart:ffi` 라이브러리를 사용하는 방법을 설명합니다. 
Android에 대한 정보는, [dart:ffi를 사용하여 네이티브 Android 코드에 바인딩][android-ffi]를 참조하세요. 
iOS에 대한 정보는, [dart:ffi를 사용하여 네이티브 iOS 코드에 바인딩][ios-ffi]를 참조하세요. 
이 기능은 아직 웹 플러그인에서 지원되지 않습니다.
:::

[android-ffi]: /platform-integration/android/c-interop
[ios-ffi]: /platform-integration/ios/c-interop
[dart:ffi]: {{site.dart.api}}/dev/dart-ffi/dart-ffi-library.html
[FFI]: https://en.wikipedia.org/wiki/Foreign_function_interface

라이브러리나 프로그램이 FFI 라이브러리를 사용하여 네이티브 코드에 바인딩하려면, 
먼저 네이티브 코드가 로드되었고 해당 심볼이 Dart에서 볼 수 있는지 확인해야 합니다. 
이 페이지는 Flutter 플러그인이나 앱 내에서 macOS 네이티브 코드를 컴파일, 패키징, 로드하는 데 중점을 둡니다.

이 튜토리얼은 Flutter 플러그인에서 C/C++ 소스를 번들로 묶고, 
macOS에서 Dart FFI 라이브러리를 사용하여 바인딩하는 방법을 보여줍니다. 
이 연습에서는 32비트 추가를 구현한 다음, 
"native_add"라는 Dart 플러그인을 통해 노출하는 C 함수를 만듭니다.

## Dynamic vs static 링크 {:#dynamic-vs-static-linking}

A native library can be linked into an app either
dynamically or statically. A statically linked library
is embedded into the app's executable image,
and is loaded when the app starts.

Symbols from a statically linked library can be
loaded using `DynamicLibrary.executable` or
`DynamicLibrary.process`.

A dynamically linked library, by contrast, is distributed
in a separate file or folder within the app,
and loaded on-demand. On macOS, the dynamically linked
library is distributed as a `.framework` folder.

A dynamically linked library can be loaded into
Dart using `DynamicLibrary.open`.

API documentation is available from the Dart dev channel:
[Dart API reference documentation][].


[Dart API reference documentation]: {{site.dart.api}}/dev/

## FFI 플러그인 만들기 {:#create-an-ffi-plugin}

If you already have a plugin, skip this step.

To create a plugin called "native_add",
do the following:

```console
$ flutter create --platforms=macos --template=plugin_ffi native_add
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

On iOS, the `native_add/macos/native_add.podspec` links the code.

The native code is invoked from dart in `lib/native_add_bindings_generated.dart`.

The bindings are generated with [package:ffigen]({{site.pub-pkg}}/ffigen).

## 다른 사용 사례 {:#other-use-cases}

### iOS 및 macOS {:#ios-and-macos}

Dynamically linked libraries are automatically loaded by
the dynamic linker when the app starts. Their constituent
symbols can be resolved using [`DynamicLibrary.process`][].
You can also get a handle to the library with
[`DynamicLibrary.open`][] to restrict the scope of
symbol resolution, but it's unclear how Apple's
review process handles this.

Symbols statically linked into the application binary
can be resolved using [`DynamicLibrary.executable`][] or
[`DynamicLibrary.process`][].


[`DynamicLibrary.executable`]: {{site.dart.api}}/dev/dart-ffi/DynamicLibrary/DynamicLibrary.executable.html
[`DynamicLibrary.open`]: {{site.dart.api}}/dev/dart-ffi/DynamicLibrary/DynamicLibrary.open.html
[`DynamicLibrary.process`]: {{site.dart.api}}/dev/dart-ffi/DynamicLibrary/DynamicLibrary.process.html

#### Platform 라이브러리 {:#platform-library}

To link against a platform library,
use the following instructions:

1. In Xcode, open `Runner.xcworkspace`.
1. Select the target platform.
1. Click **+** in the **Linked Frameworks and Libraries**
   section.
1. Select the system library to link against.

#### 퍼스트파티 라이브러리 {:#first-party-library}

A first-party native library can be included either
as source or as a (signed) `.framework` file.
It's probably possible to include statically linked
archives as well, but it requires testing.

#### 소스 코드 {:#source-code}

To link directly to source code,
use the following instructions:

 1. In Xcode, open `Runner.xcworkspace`.
 2. Add the C/C++/Objective-C/Swift
    source files to the Xcode project.
 3. Add the following prefix to the
    exported symbol declarations to ensure they
    are visible to Dart:

    **C/C++/Objective-C**

    ```objc
    extern "C" /* <= C++ only */ __attribute__((visibility("default"))) __attribute__((used))
    ```

    **Swift**

    ```swift
    @_cdecl("myFunctionName")
    ```

#### 컴파일된(dynamic) 라이브러리 {:#compiled-dynamic-library}

To link to a compiled dynamic library,
use the following instructions:

1. If a properly signed `Framework` file is present,
   open `Runner.xcworkspace`.
1. Add the framework file to the **Embedded Binaries**
   section.
1. Also add it to the **Linked Frameworks & Libraries**
   section of the target in Xcode.

#### 컴파일된(dynamic) 라이브러리 (macOS) {:#compiled-dynamic-library-macos}

To add a closed source library to a
[Flutter macOS Desktop][] app,
use the following instructions:

1. Follow the instructions for Flutter desktop to create
   a Flutter desktop app.
1. Open the `yourapp/macos/Runner.xcworkspace` in Xcode.
   1. Drag your precompiled library (`libyourlibrary.dylib`)
      into `Runner/Frameworks`.
   1. Click `Runner` and go to the `Build Phases` tab.
      1. Drag `libyourlibrary.dylib` into the
         `Copy Bundle Resources` list.
      1. Under `Embed Libraries`, check `Code Sign on Copy`.
      1. Under `Link Binary With Libraries`,
         set status to `Optional`. (We use dynamic linking,
         no need to statically link.)
   1. Click `Runner` and go to the `General` tab.
      1. Drag `libyourlibrary.dylib` into the **Frameworks,
         Libraries and Embedded Content** list.
      1. Select **Embed & Sign**.
   1. Click **Runner** and go to the **Build Settings** tab.
      1. In the **Search Paths** section configure the
         **Library Search Paths** to include the path
         where `libyourlibrary.dylib` is located.
1. Edit `lib/main.dart`.
   1. Use `DynamicLibrary.open('libyourlibrary.dylib')`
      to dynamically link to the symbols.
   1. Call your native function somewhere in a widget.
1. Run `flutter run` and check that your native function gets called.
1. Run `flutter build macos` to build a self-contained release
   version of your app.

[Flutter macOS Desktop]: /platform-integration/macos/building

{% comment %}

#### Open-source third-party library

To create a Flutter plugin that includes both
C/C++/Objective-C _and_ Dart code,
use the following instructions:

1. In your plugin project,
   open `macos/<myproject>.podspec`.
1. Add the native code to the `source_files`
   field.

The native code is then statically linked into
the application binary of any app that uses
this plugin.

#### Closed-source third-party library

To create a Flutter plugin that includes Dart
source code, but distribute the C/C++ library
in binary form, use the following instructions:

1. In your plugin project,
   open `macos/<myproject>.podspec`.
1. Add a `vendored_frameworks` field.
   See the [CocoaPods example][].

:::warning
**Do not** upload this plugin
(or any plugin containing binary code) to pub.dev.
Instead, this plugin should be downloaded
from a trusted third-party,
as shown in the CocoaPods example.
:::

[CocoaPods example]: {{site.github}}/CocoaPods/CocoaPods/blob/master/examples/Vendored%20Framework%20Example/Example%20Pods/VendoredFrameworkExample.podspec

## Stripping macOS symbols

When creating a release archive (IPA),
the symbols are stripped by Xcode.

1. In Xcode, go to **Target Runner > Build Settings > Strip Style**.
2. Change from **All Symbols** to **Non-Global Symbols**.

{% endcomment %}

{% include docs/resource-links/ffi-video-resources.md %}
