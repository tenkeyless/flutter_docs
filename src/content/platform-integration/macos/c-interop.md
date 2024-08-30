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

네이티브 라이브러리는 동적으로 또는 정적으로 앱에 링크될 수 있습니다. 
정적으로 링크된 라이브러리는 앱의 실행 가능 이미지에 내장되고 앱이 시작될 때 로드됩니다.

정적으로 링크된 라이브러리의 심볼은 `DynamicLibrary.executable` 또는 
`DynamicLibrary.process`를 사용하여 로드할 수 있습니다.

반면, 동적으로 링크된 라이브러리는 앱 내의 별도 파일이나 폴더에 배포되고 필요에 따라 로드됩니다. 
macOS에서 동적으로 링크된 라이브러리는 `.framework` 폴더로 배포됩니다.

동적으로 링크된 라이브러리는 `DynamicLibrary.open`을 사용하여 Dart에 로드할 수 있습니다.

API 문서는 Dart 개발 채널에서 제공됩니다: [Dart API 참조 문서][Dart API reference documentation].

[Dart API reference documentation]: {{site.dart.api}}/dev/

## FFI 플러그인 만들기 {:#create-an-ffi-plugin}

이미 플러그인이 있는 경우, 이 단계를 건너뜁니다.

"native_add"라는 플러그인을 만들려면 다음을 수행합니다.

```console
$ flutter create --platforms=macos --template=plugin_ffi native_add
$ cd native_add
```

:::note
빌드하고 싶지 않은 플랫폼을 `--platforms`에서 제외할 수 있습니다. 
그러나 테스트하는 기기의 플랫폼을 포함해야 합니다.
:::

이렇게 하면 `native_add/src`에 C/C++ 소스가 있는 플러그인이 생성됩니다. 
이러한 소스는 다양한 os 빌드 폴더의 네이티브 빌드 파일에 의해 빌드됩니다.

FFI 라이브러리는 C 심볼에 대해서만 바인딩할 수 있으므로, 
C++에서 이러한 심볼은 `extern "C"`로 표시됩니다.

또한 심볼이 Dart에서 참조된다는 것을 나타내는 속성을 추가하여, 
링커가 링크 타임 최적화 중에 심볼을 삭제하지 못하도록 해야 합니다. 
`__attribute__((visibility("default"))) __attribute__((used))`.

iOS에서 `native_add/macos/native_add.podspec`은 코드를 연결합니다.

네이티브 코드는 `lib/native_add_bindings_generated.dart`에서 dart에서 호출됩니다.

바인딩은 [package:ffigen]({{site.pub-pkg}}/ffigen)으로 생성됩니다.

## 다른 사용 사례 {:#other-use-cases}

### iOS 및 macOS {:#ios-and-macos}

동적으로 링크된 라이브러리는 앱이 시작될 때 동적 링커에 의해 자동으로 로드됩니다. 
구성 심볼은 [`DynamicLibrary.process`][]를 사용하여 해결할 수 있습니다. 
또한 [`DynamicLibrary.open`][]을 사용하여, 라이브러리에 대한 핸들을 가져와, 
심볼 해결 범위를 제한할 수 있지만, Apple의 검토 프로세스가 이를 어떻게 처리하는지는 불분명합니다.

애플리케이션 바이너리에 정적으로 링크된 심볼은, 
[`DynamicLibrary.executable`][] 또는 [`DynamicLibrary.process`][]를 사용하여 해결할 수 있습니다.

[`DynamicLibrary.executable`]: {{site.dart.api}}/dev/dart-ffi/DynamicLibrary/DynamicLibrary.executable.html
[`DynamicLibrary.open`]: {{site.dart.api}}/dev/dart-ffi/DynamicLibrary/DynamicLibrary.open.html
[`DynamicLibrary.process`]: {{site.dart.api}}/dev/dart-ffi/DynamicLibrary/DynamicLibrary.process.html

#### Platform 라이브러리 {:#platform-library}

플랫폼 라이브러리에 연결하려면, 다음 지침을 따르세요.

1. Xcode에서 `Runner.xcworkspace`를 엽니다.
2. 대상 플랫폼을 선택합니다.
3. **Linked Frameworks and Libraries** 섹션에서 **+**를 클릭합니다.
4. 연결할 시스템 라이브러리를 선택합니다.

#### 퍼스트파티 라이브러리 {:#first-party-library}

퍼스트파티 네이티브 라이브러리는 소스 또는 (서명된) `.framework` 파일로 포함될 수 있습니다. 
정적으로 링크된 아카이브도 포함할 수 있지만 테스트가 필요합니다.

#### 소스 코드 {:#source-code}

소스 코드에 직접 링크하려면, 다음 지침을 따르세요.

1. Xcode에서 `Runner.xcworkspace`를 엽니다.
2. C/C++/Objective-C/Swift 소스 파일을 Xcode 프로젝트에 추가합니다.
3. Dart에서 볼 수 있도록 내보낸 심볼 선언에 다음 접두사를 추가합니다.

    **C/C++/Objective-C**

    ```objc
    extern "C" /* <= C++ only */ __attribute__((visibility("default"))) __attribute__((used))
    ```

    **Swift**

    ```swift
    @_cdecl("myFunctionName")
    ```

#### 컴파일된(dynamic) 라이브러리 {:#compiled-dynamic-library}

컴파일된 동적 라이브러리에 링크하려면, 다음 지침을 따르세요.

1. 적절하게 서명된 `Framework` 파일이 있는 경우, `Runner.xcworkspace`를 엽니다.
1. 프레임워크 파일을 **Embedded Binaries** 섹션에 추가합니다.
1. 또한 Xcode에서 대상의 **Linked Frameworks & Libraries** 섹션에도 추가합니다.

#### 컴파일된(dynamic) 라이브러리 (macOS) {:#compiled-dynamic-library-macos}

[Flutter macOS Desktop][] 앱에, closed 소스 라이브러리를 추가하려면, 다음 지침을 따르세요.

1. Flutter 데스크톱에 대한 지침에 따라 Flutter 데스크톱 앱을 만듭니다.
1. Xcode에서 `yourapp/macos/Runner.xcworkspace`를 엽니다.
   1. 사전 컴파일된 라이브러리(`libyourlibrary.dylib`)를 `Runner/Frameworks`로 드래그합니다.
   2. `Runner`를 클릭하고 `Build Phases` 탭으로 이동합니다.
      1. `libyourlibrary.dylib`를 `Copy Bundle Resources` 목록으로 드래그합니다.
      2. `Embed Libraries`에서 `Code Sign on Copy`를 선택합니다.
      3. `Link Binary With Libraries`에서 상태를 `Optional`로 설정합니다. 
         (동적 링크를 사용하므로 정적으로 링크할 필요가 없습니다.)
   3. `Runner`를 클릭하고 `General` 탭으로 이동합니다.
      1. `libyourlibrary.dylib`를 **Frameworks, Libraries and Embedded Content** 리스트로 
         끌어다 놓습니다.
      2. **Embed & Sign**을 선택합니다.
   4. **Runner**를 클릭하고, **Build Settings** 탭으로 이동합니다.
      1. **Search Paths** 섹션에서 `libyourlibrary.dylib`가 있는 경로를 포함하도록, 
         **Library Search Paths**를 구성합니다.
2. `lib/main.dart`를 편집합니다.
   1. `DynamicLibrary.open('libyourlibrary.dylib')`를 사용하여 심볼에 동적으로 연결합니다.
   2. 위젯의 어딘가에서 네이티브 함수를 호출합니다.
3. `flutter run`을 실행하고, 네이티브 함수가 호출되는지 확인합니다.
4. `flutter build macos`를 실행하여, 앱의 독립형 릴리스 버전을 빌드합니다.

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
