---
# title: Developing packages & plugins
title: 패키지 및 플러그인 개발
# short-title: Developing
short-title: 개발
# description: How to write packages and plugins for Flutter.
description: Flutter용 패키지와 플러그인을 작성하는 방법.
---

## 패키지 소개 {:#package-introduction}

패키지는 쉽게 공유할 수 있는 모듈식 코드를 생성할 수 있도록 합니다. 최소 패키지는 다음으로 구성됩니다.

**`pubspec.yaml`**
: 패키지 이름, 버전, 작성자 등을 선언하는 메타데이터 파일입니다.

**`lib`**
: `lib` 디렉터리에는 패키지의 공개 코드가 들어 있으며, 최소한 단일 `<package-name>.dart` 파일입니다.

:::note
효과적인 플러그인을 작성할 때 해야 할 일과 하지 말아야 할 일 리스트는, 
Mehmet Fidanboylu의 Medium 글 [좋은 플러그인 작성][Writing a good plugin]을 참조하세요.
:::

### 패키지 타입 {:#types}

패키지에는 여러 종류의 콘텐츠가 포함될 수 있습니다.

**Dart 패키지**
: Dart로 작성된 일반 패키지, 예를 들어 [`path`][] 패키지. 
  이 중 일부는 Flutter 특정 기능을 포함할 수 있으므로, Flutter 프레임워크에 종속되어 Flutter에서만 사용할 수 있습니다. 
  예를 들어 [`fluro`][] 패키지.

**플러그인 패키지**
: Dart 코드로 작성된 API와 하나 이상의 플랫폼별 구현을 결합한 특수 Dart 패키지.

  플러그인 패키지는 Android(Kotlin 또는 Java 사용), iOS(Swift 또는 Objective-C 사용), 웹, macOS, 
  Windows 또는 Linux 또는 이들의 조합으로 작성할 수 있습니다.

  구체적인 예로 [`url_launcher`][] 플러그인 패키지가 있습니다. 
  `url_launcher` 패키지를 사용하는 방법과 웹 지원을 구현하기 위해 확장된 방법을 알아보려면, 
  Harry Terkelsen의 Medium 글, [Flutter 웹 플러그인 작성 방법, 1부][How to Write a Flutter Web Plugin, Part 1]를 참조하세요.

**FFI 플러그인 패키지**
: Dart 코드로 작성된 API와 Dart FFI([Android][Android], [iOS][iOS], [macOS][macOS])를 사용하는 
  하나 이상의 플랫폼별 구현을 결합한 특수 Dart 패키지입니다.

## Dart 패키지 개발 {:#dart}

다음 지침에서는 Flutter 패키지를 작성하는 방법을 설명합니다.

### 1단계: 패키지 생성 {:#step-1-create-the-package}

Flutter 스타터 패키지를 만들려면, `flutter create` 명령에 `--template=package` 플래그를 사용합니다.

```console
$ flutter create --template=package hello
```

이렇게 하면 `hello` 폴더에 다음 내용이 포함된 패키지 프로젝트가 생성됩니다.

**LICENSE**
: (대부분) 빈 라이선스 텍스트 파일.

**test/hello_test.dart**
: 패키지의 [유닛 테스트][unit tests].

**hello.iml**
: IntelliJ IDE에서 사용하는 구성 파일.

**.gitignore**
: 프로젝트에서 무시할 파일이나 폴더를 Git에 알려주는 숨겨진 파일.

**.metadata**
: IDE에서 Flutter 프로젝트의 속성을 추적하는 데 사용하는 숨겨진 파일.

**pubspec.yaml**
: 패키지의 종속성을 지정하는 메타데이터가 포함된 yaml 파일. pub 도구에서 사용.

**README.md**
: 패키지의 목적을 간략하게 설명하는 시작 마크다운 파일.

**lib/hello.dart**
: 패키지의 Dart 코드가 포함된 시작 앱.

**.idea/modules.xml**, **.idea/workspace.xml**
: IntelliJ IDE의 구성 파일이 들어 있는 숨겨진 폴더.

**CHANGELOG.md**
: 패키지의 버전 변경을 추적하기 위한 (대부분) 빈 마크다운 파일.

### 2단계: 패키지 구현 {:#step-2-implement-the-package}

순수한 Dart 패키지의 경우, 단순히 메인 `lib/<패키지 이름>.dart` 파일 내부나, 
`lib` 디렉토리의 여러 파일에 기능을 추가하면 됩니다.

패키지를 테스트하려면, `test` 디렉토리에 [유닛 테스트][unit tests]를 추가합니다.

패키지 내용을 구성하는 방법에 대한 자세한 내용은 [Dart 라이브러리 패키지][Dart library package] 문서를 참조하세요.

## 플러그인 패키지 개발 {:#plugin}

플랫폼별 API를 호출하는 패키지를 개발하려면, 플러그인 패키지를 개발해야 합니다.

API는 [플랫폼 채널][platform channel]을 사용하여 플랫폼별 구현에 연결됩니다.

### 연합(Federated) 플러그인 {:#federated-plugins}

페더레이션 플러그인은 다양한 플랫폼에 대한 지원을 별도의 패키지로 분할하는 방법입니다. 
따라서, 페더레이션 플러그인은 iOS용 패키지 하나, Android용 패키지 하나, 웹용 패키지 하나, 자동차용 패키지 하나(IoT 기기의 예)를 사용할 수 있습니다. 
이 접근 방식의 다른 이점 중 하나는, 도메인 전문가가 기존 플러그인을 확장하여 자신이 가장 잘 아는 플랫폼에서 작동하도록 할 수 있다는 것입니다.

페더레이션 플러그인에는 다음 패키지가 필요합니다.

**앱 지향 패키지 (app-facing package)**
: 플러그인 사용자가 플러그인을 사용하기 위해 의존하는 패키지입니다. 
  이 패키지는 Flutter 앱에서 사용하는 API를 지정합니다.

**플랫폼 패키지 (platform package(s))**
: 플랫폼별 구현 코드가 포함된 하나 이상의 패키지입니다. 
  앱 지향 패키지는 이러한 패키지를 호출합니다. - 최종 사용자가 액세스할 수 있는 플랫폼별 기능이 포함되지 않는 한, 앱에 포함되지 않습니다.

**플랫폼 인터페이스 패키지 (platform interface package)**
: 앱 지향 패키지를 플랫폼 패키지에 연결하는 패키지입니다. 
  이 패키지는 어떤 플랫폼 패키지라도 앱 지향 패키지를 지원하기 위해 구현해야 하는 인터페이스를 선언합니다. 
  이 인터페이스를 정의하는 단일 패키지가 있으면, 모든 플랫폼 패키지가 동일한 기능을 균일한 방식으로 구현합니다.

#### 승인된(endorsed) 페더레이션 플러그인 {:#endorsed-federated-plugin}

이상적으로, 페더레이션 플러그인에 플랫폼 구현을 추가할 때, 패키지 작성자와 협력하여 구현을 포함시킵니다. 
이런 방식으로, 원본 작성자는 구현을 _지지(endorses)_ 합니다.

예를 들어, (가상의) `foobar` 플러그인에 대한 `foobar_windows` 구현을 작성한다고 가정합니다. 
지지된(endorsed) 플러그인에서, 원본 `foobar` 작성자는 앱 지향 패키지에 대한 pubspec에서 종속성으로, 
Windows 구현을 추가합니다. 
그런 다음, 개발자가 Flutter 앱에 `foobar` 플러그인을 포함하면, 
Windows 구현과 다른 지지된(endorsed) 구현을 앱에서 자동으로 사용할 수 있습니다.

#### 비승인된(non-endorsed) 페더레이션 플러그인 {:#non-endorsed-federated-plugin}

어떤 이유로든, 원본 플러그인 작성자가 구현을 추가하도록 할 수 없다면, 당신의 플러그인은 승인(endorsed)되지 _않습니다._ 
개발자는 여전히 당신의 구현을 사용할 수 있지만, 플러그인을 앱의 pubspec 파일에 수동으로 추가해야 합니다. 
따라서, 개발자는 전체 기능을 구현하기 위해 `foobar` 종속성 _및_ `foobar_windows` 종속성을 모두 포함해야 합니다.

페더레이션 플러그인에 대한 자세한 내용, 유용한 이유, 구현 방법은, 
Harry Terkelsen의 Medium 글 [Flutter 웹 플러그인을 작성하는 방법, 2부][How To Write a Flutter Web Plugin, Part 2]를 참조하세요.

### 플러그인의 지원 플랫폼 지정 {:#plugin-platforms}

플러그인은 `pubspec.yaml` 파일의 `platforms` 맵에 키를 추가하여 지원하는 플랫폼을 지정할 수 있습니다.
예를 들어, 다음 pubspec 파일은 iOS와 Android만 지원하는, 
`hello` 플러그인의 `flutter:` 맵을 보여줍니다.

```yaml
flutter:
  plugin:
    platforms:
      android:
        package: com.example.hello
        pluginClass: HelloPlugin
      ios:
        pluginClass: HelloPlugin
```

더 많은 플랫폼에 플러그인 구현을 추가할 때, 
`platforms` 맵은 그에 따라 업데이트되어야 합니다. 
예를 들어, macOS와 웹에 대한 지원을 추가하기 위해 업데이트된, 
`hello` 플러그인의 pubspec 파일에 있는 맵은 다음과 같습니다.

```yaml
flutter:
  plugin:
    platforms:
      android:
        package: com.example.hello
        pluginClass: HelloPlugin
      ios:
        pluginClass: HelloPlugin
      macos:
        pluginClass: HelloPlugin
      web:
        pluginClass: HelloPlugin
        fileName: hello_web.dart
```

#### 연합(Federated) 플랫폼 패키지 {:#federated-platform-packages}

A platform package uses the same format,
but includes an `implements` entry indicating
which app-facing package it implements. For example,
a `hello_windows` plugin containing the Windows
implementation for `hello`
would have the following `flutter:` map:

```yaml
flutter:
  plugin:
    implements: hello
    platforms:
      windows:
        pluginClass: HelloPlugin
```

#### 승인된(Endorsed) 구현 {:#endorsed-implementations}

앱 지향 패키지는 종속성을 추가하고 `platforms:` 맵에서 `default_package`로 포함하여, 
플랫폼 패키지를 승인(endorse)할 수 있습니다. 
위의 `hello` 플러그인이 `hello_windows`를 승인(endorsed)하는 경우, 
다음과 같습니다.

```yaml
flutter:
  plugin:
    platforms:
      android:
        package: com.example.hello
        pluginClass: HelloPlugin
      ios:
        pluginClass: HelloPlugin
      windows:
        default_package: hello_windows

dependencies:
  hello_windows: ^1.0.0
```

여기서 표시된 대로, 
앱 대상 패키지에는 패키지 내에 일부 플랫폼이 구현되어 있을 수 있고, 
다른 플랫폼은 승인된 연합 구현(endorsed federated implementations)으로 구현될 수 있습니다.

#### iOS 및 macOS 구현 공유 {:#shared-ios-and-macos-implementations}

많은 프레임워크는 동일하거나 거의 동일한 API로 iOS와 macOS를 모두 지원하므로, 
동일한 코드베이스로 iOS와 macOS에 대한 일부 플러그인을 구현할 수 있습니다. 
일반적으로, 각 플랫폼의 구현은 자체 폴더에 있지만, 
`sharedDarwinSource` 옵션을 사용하면 iOS와 macOS가 대신 동일한 폴더를 사용할 수 있습니다.


```yaml
flutter:
  plugin:
    platforms:
      ios:
        pluginClass: HelloPlugin
        sharedDarwinSource: true
      macos:
        pluginClass: HelloPlugin
        sharedDarwinSource: true

environment:
  sdk: ^3.0.0
  # Flutter 3.7 이전 버전에서는 sharedDarwinSource 옵션을 지원하지 않았습니다.
  flutter: ">=3.7.0"
```

`sharedDarwinSource`가 활성화된 경우, 
iOS의 `ios` 디렉토리와 macOS의 `macos` 디렉토리 대신, 
두 플랫폼 모두 모든 코드와 리소스에 공유 `darwin` 디렉토리를 사용합니다. 
이 옵션을 활성화하는 경우, 
`ios`와 `macos`의 기존 파일을 공유 디렉토리로 이동해야 합니다. 
또한 podspec 파일을 업데이트하여 두 플랫폼 모두에 대한 종속성과 배포 대상을 설정해야 합니다. 예:

```ruby
  s.ios.dependency 'Flutter'
  s.osx.dependency 'FlutterMacOS'
  s.ios.deployment_target = '11.0'
  s.osx.deployment_target = '10.14'
```

### 1단계: 패키지 생성 {:#step-1-create-the-package-1}

플러그인 패키지를 만들려면, 
`--template=plugin` 플래그를 `flutter create`와 함께 사용합니다.

`--platforms=` 옵션 뒤에 쉼표로 구분된 리스트를 사용하여 플러그인이 지원하는 플랫폼을 지정합니다. 
사용 가능한 플랫폼은 `android`, `ios`, `web`, `linux`, `macos`, `windows`입니다. 
플랫폼을 지정하지 않으면, 결과 프로젝트는 어떤 플랫폼도 지원하지 않습니다.

`--org` 옵션을 사용하여, 역방향 도메인 이름 표기법을 사용하여, 조직을 지정합니다. 
이 값은 생성된 플러그인 코드의 다양한 패키지 및 번들 식별자에서 사용됩니다.

`-a` 옵션을 사용하여 android 언어를 지정하거나, 
`-i` 옵션을 사용하여 ios 언어를 지정합니다. 
다음 중 **하나**를 선택하세요.

```console
$ flutter create --org com.example --template=plugin --platforms=android,ios,linux,macos,windows -a kotlin hello
```
```console
$ flutter create --org com.example --template=plugin --platforms=android,ios,linux,macos,windows -a java hello
```
```console
$ flutter create --org com.example --template=plugin --platforms=android,ios,linux,macos,windows -i objc hello
```
```console
$ flutter create --org com.example --template=plugin --platforms=android,ios,linux,macos,windows -i swift hello
```

이렇게 하면 `hello` 폴더에 다음과 같은 특수 콘텐츠가 있는 플러그인 프로젝트가 생성됩니다.

**`lib/hello.dart`**
: 플러그인의 Dart API.

**`android/src/main/java/com/example/hello/HelloPlugin.kt`**
: Kotlin에서 플러그인 API의 Android 플랫폼별 구현.

**`ios/Classes/HelloPlugin.m`**
: Objective-C에서 플러그인 API의 iOS 플랫폼별 구현.

**`example/`**
: 플러그인에 종속된 Flutter 앱이며, 플러그인을 사용하는 방법을 보여줍니다.

기본적으로, 플러그인 프로젝트는 iOS 코드에는 Swift를 사용하고, 
Android 코드에는 Kotlin을 사용합니다. 
Objective-C 또는 Java를 선호하는 경우, 
`-i`를 사용하여 iOS 언어를 지정하고,
`-a`를 사용하여 Android 언어를 지정할 수 있습니다. 예를 들어:

```console
$ flutter create --template=plugin --platforms=android,ios -i objc hello
```
```console
$ flutter create --template=plugin --platforms=android,ios -a java hello
```

### 2단계: 패키지 구현 {:#edit-plugin-package}

플러그인 패키지에는 여러 프로그래밍 언어로 작성된 여러 플랫폼에 대한 코드가 포함되어 있으므로, 원활한 환경을 보장하려면 몇 가지 특정 단계가 필요합니다.

#### 스텝 2a: 패키지 API 정의 (.dart) {:#step-2a-define-the-package-api-dart}

플러그인 패키지의 API는 Dart 코드에 정의되어 있습니다. 
좋아하는 [Flutter 편집기][Flutter editor]에서 메인 `hello/` 폴더를 엽니다. 
`lib/hello.dart` 파일을 찾습니다.

#### 스텝 2b: Android 플랫폼 코드 추가 (.kt/.java) {:#step-2b-add-android-platform-code-kt-java}

Android Studio를 사용하여 Android 코드를 편집하는 것이 좋습니다.

Android Studio에서 Android 플랫폼 코드를 편집하기 전에, 
먼저 코드가 최소한 한 번은 빌드되었는지 확인하세요.
(즉, IDE/편집기에서 예제 앱을 실행하거나, 
터미널에서 `cd hello/example; flutter build apk --config-only`를 실행하세요.)

그런 다음 다음 단계를 따르세요.

1. Android Studio를 실행합니다.
2. **Welcome to Android Studio** 대화 상자에서 **Open an existing Android Studio Project**를 선택하거나 메뉴에서 **File > Open**를 선택하고 `hello/example/android/build.gradle` 파일을 선택합니다.
3. **Gradle Sync** 대화 상자에서, **OK**를 선택합니다.
4. **Android Gradle Plugin Update** 대화 상자에서 **Don't remind me again for this project**을 선택합니다.

플러그인의 Android 플랫폼 코드는 `hello/java/com.example.hello/HelloPlugin`에 있습니다.

실행(&#9654;) 버튼을 눌러 Android Studio에서 예제 앱을 실행할 수 있습니다.

#### 스텝 2c: iOS 플랫폼 코드 추가 (.swift/.h+.m) {:#step-2c-add-ios-platform-code-swift-h-m}

Xcode를 사용하여 iOS 코드를 편집하는 것이 좋습니다.

Xcode에서 iOS 플랫폼 코드를 편집하기 전에, 
먼저 코드가 최소한 한 번은 빌드되었는지 확인하세요. 
(즉, IDE/편집기에서 예제 앱을 실행하거나, 터미널에서 `cd hello/example; flutter build ios --no-codesign --config-only`를 실행하세요.)

그런 다음 다음 단계를 따르세요.

1. Xcode를 시작합니다.
2. **File > Open**를 선택하고, 
   `hello/example/ios/Runner.xcworkspace` 파일을 선택합니다.

플러그인의 iOS 플랫폼 코드는 Project Navigator의 `Pods/Development Pods/hello/../../example/ios/.symlinks/plugins/hello/ios/Classes`에 있습니다. 
(`sharedDarwinSource`를 사용하는 경우, 경로는 `hello/darwin/Classes`로 끝납니다.)

실행(&#9654;) 버튼을 눌러 예제 앱을 실행할 수 있습니다.

##### CocoaPod 종속성 추가 {:#add-cocoapod-dependencies}

:::warning
Flutter는 iOS 및 macOS 네이티브 종속성을 관리하기 위해 [Swift Package Manager][]로 마이그레이션하고 있습니다. Flutter의 Swift Package Manager 지원은 개발 중입니다. 구현은 향후 변경될 수 있습니다. Swift Package Manager 지원은 Flutter의 [`main` channel][]에서만 제공됩니다. Flutter는 CocoaPods를 계속 지원합니다.
:::

[Swift Package Manager]: https://www.swift.org/documentation/package-manager/
[`main` channel]: /release/upgrade#switching-flutter-channels

다음 지침에 따라 `HelloPod`를 `0.0.1` 버전으로 추가하세요.

1. `ios/hello.podspec`의 끝에 종속성을 지정합니다.

   ```ruby
   s.dependency 'HelloPod', '0.0.1'
   ```

   private pods의 경우, 
   리포지토리 액세스를 보장하려면 [Private CocoaPods][]를 참조하세요.

   ```ruby
   s.source = {
       # GitHub에 호스팅된 Pod의 경우
       :git => "https://github.com/path/to/HelloPod.git",
       # 또는, 로컬로 호스팅된 Pod의 경우
       # :path => "file:///path/to/private/repo",
       :tag => s.version.to_s
     }`
   ```

   [Private CocoaPods]: https://guides.cocoapods.org/making/private-cocoapods.html

1. 플러그인 설치
   - 프로젝트의 `pubspec.yaml` 종속성에 플러그인을 추가합니다.
   - `flutter pub get`을 실행합니다.
   - 프로젝트의 `ios/` 디렉토리에서 `pod install`을 실행합니다.

pod는 설치 요약에 나타나야 합니다.

플러그인에 개인 정보 보호 매니페스트가 필요한 경우,
(예: **required reason APIs**를 사용하는 경우) 
`PrivacyInfo.xcprivacy` 파일을 업데이트하여, 
플러그인의 개인 정보 보호 영향을 설명하고, 
podspec 파일의 맨 아래에 다음을 추가합니다.

```ruby
s.resource_bundles = {'your_plugin_privacy' => ['your_plugin/Sources/your_plugin/Resources/PrivacyInfo.xcprivacy']}
```

자세한 내용은 Apple 개발자 사이트에서 [개인 정보 매니페스트 파일][Privacy manifest files]을 확인하세요.

[Privacy manifest files]: {{site.apple-dev}}/documentation/bundleresources/privacy_manifest_files

#### 스텝 2d: Linux 플랫폼 코드 추가 (.h+.cc) {:#step-2d-add-linux-platform-code-h-cc}

C++ 통합 IDE를 사용하여 Linux 코드를 편집하는 것이 좋습니다. 
아래 지침은 "C/C++" 및 "CMake" 확장 프로그램이 설치된, 
Visual Studio Code에 대한 것이지만, 다른 IDE에 맞게 조정할 수 있습니다.

IDE에서 Linux 플랫폼 코드를 편집하기 전에, 
먼저 코드가 최소한 한 번 빌드되었는지 확인하세요.
(즉, Flutter IDE/편집기에서 예제 앱을 실행하거나, 
터미널에서 `cd hello/example; flutter build linux`를 실행하세요)

그런 다음 다음 단계를 따르세요.

1. Visual Studio Code를 실행합니다.
2. `hello/example/linux/` 디렉토리를 엽니다.
3. `Would you like to configure project "linux"?`라는 프롬프트에서 **Yes**를 선택합니다. 
   이렇게 하면 C++ 자동 완성이 작동합니다.

플러그인의 Linux 플랫폼 코드는 `flutter/ephemeral/.plugin_symlinks/hello/linux/`에 있습니다.

`flutter run`을 사용하여 예제 앱을 실행할 수 있습니다. 

**참고:** Linux에서 실행 가능한 Flutter 애플리케이션을 만들려면, 
`flutter` tool의 일부인 단계가 필요하므로, 
편집기에서 CMake 통합을 제공하더라도 해당 방식으로 빌드하고 실행하면 제대로 작동하지 않습니다.

#### 스텝 2e: macOS 플랫폼 코드 추가 (.swift) {:#step-2e-add-macos-platform-code-swift}

Xcode를 사용하여 macOS 코드를 편집하는 것이 좋습니다.

Xcode에서 macOS 플랫폼 코드를 편집하기 전에, 
먼저 코드가 최소한 한 번은 빌드되었는지 확인하세요.
(즉, IDE/편집기에서 예제 앱을 실행하거나,
터미널에서 `cd hello/example; flutter build macos --config-only`를 실행하세요)

그런 다음 다음 단계를 따르세요.

1. Xcode를 시작합니다.
1. **File > Open**를 선택하고,
   `hello/example/macos/Runner.xcworkspace` 파일을 선택합니다.

플러그인의 macOS 플랫폼 코드는 Project Navigator의 `Pods/Development Pods/hello/../../example/macos/Flutter/ephemeral/.symlinks/plugins/hello/macos/Classes`에 있습니다. 
(`sharedDarwinSource`를 사용하는 경우, 
경로는 `hello/darwin/Classes`로 끝납니다.)

실행(&#9654;) 버튼을 눌러 예제 앱을 실행할 수 있습니다.

#### 스텝 2f: Windows 플랫폼 코드 추가 (.h+.cpp) {:#step-2f-add-windows-platform-code-h-cpp}

Visual Studio를 사용하여 Windows 코드를 편집하는 것이 좋습니다.

Visual Studio에서 Windows 플랫폼 코드를 편집하기 전에, 
먼저 코드가 최소한 한 번 빌드되었는지 확인하세요.
(즉, IDE/편집기에서 예제 앱을 실행하거나, 
터미널에서 `cd hello/example; flutter build windows`를 실행)

그런 다음 다음 단계를 따르세요.

1. Visual Studio를 시작합니다.
2. **Open a project or solution**를 선택하고,
   `hello/example/build/windows/hello_example.sln` 파일을 선택합니다.

플러그인의 Windows 플랫폼 코드는 솔루션 탐색기(Solution Explorer)의 `hello_plugin/Source Files` 및 `hello_plugin/Header Files`에 있습니다.

솔루션 탐색기에서 `hello_example`을 마우스 오른쪽 버튼으로 클릭하고, 
**Set as Startup Project**을 선택한 다음, 
실행(&#9654;) 버튼을 눌러 예제 앱을 실행할 수 있습니다. 

**중요:** 플러그인 코드를 변경한 후에는 다시 실행하기 전에 **Build > Build Solution**를 선택해야 합니다. 그렇지 않으면, 변경 사항이 포함된 최신 버전 대신 빌드된 플러그인의 오래된 사본이 실행됩니다.

#### 스텝 2g: API와 플랫폼 코드를 연결 {:#step-2g-connect-the-api-and-the-platform-code}

마지막으로, Dart 코드로 작성된 API를 플랫폼별 구현과 연결해야 합니다. 
이는 [플랫폼 채널][platform channel]을 사용하거나, 
플랫폼 인터페이스 패키지에 정의된 인터페이스를 통해 수행됩니다.

### 기존 플러그인 프로젝트에 플랫폼 지원 추가 {:#add-support-for-platforms-in-an-existing-plugin-project}

기존 플러그인 프로젝트에 특정 플랫폼에 대한 지원을 추가하려면, 
프로젝트 디렉토리에서 `--template=plugin` 플래그를 사용하여, 
`flutter create`를 다시 실행합니다. 
예를 들어, 기존 플러그인에 웹 지원을 추가하려면 다음을 실행합니다.

```console
$ flutter create --template=plugin --platforms=web .
```

이 명령으로 `pubspec.yaml` 파일을 업데이트한다는 메시지가 표시되면, 
제공된 지침을 따르세요.

### Dart 플랫폼 구현 {:#dart-platform-implementations}

많은 경우, 웹이 아닌(non-web) 플랫폼 구현은 위에 표시된 것처럼 플랫폼별 구현 언어만 사용합니다. 
그러나, 플랫폼 구현은 플랫폼별 Dart도 사용할 수 있습니다.

:::note
아래 예시는 웹이 아닌 플랫폼에만 적용됩니다. 
웹 플러그인 구현은 항상 Dart로 작성되며, 
위에 표시된 대로 Dart 구현에 `pluginClass`와 `fileName`을 사용합니다.
:::

#### Dart 전용 플랫폼 구현 {:#dart-only-platform-implementations}

어떤 경우에는, 일부 플랫폼은 Dart로만 구현할 수 있습니다. (예: FFI 사용)
웹이 아닌 플랫폼에서 Dart 전용 플랫폼을 구현하는 경우, 
pubspec.yaml의 `pluginClass`를 `dartPluginClass`로 바꾸세요. 
위의 `hello_windows` 예제를 Dart 전용 구현에 맞게 수정한 예는 다음과 같습니다.

```yaml
flutter:
  plugin:
    implements: hello
    platforms:
      windows:
        dartPluginClass: HelloPluginWindows
```

이 버전에서는 C++ Windows 코드가 없고, 
대신 `hello` 플러그인의 Dart 플랫폼 인터페이스 클래스를, 
static ​​`registerWith()` 메서드를 포함하는 `HelloPluginWindows` 클래스로 서브클래싱합니다. 
이 메서드는 시작 중에 호출되며, Dart 구현을 등록하는 데 사용할 수 있습니다.

```dart
class HelloPluginWindows extends HelloPluginPlatform {
  /// 이 클래스를 [HelloPluginPlatform]의 기본 인스턴스로 등록합니다.
  static void registerWith() {
    HelloPluginPlatform.instance = HelloPluginWindows();
  }
```

#### 하이브리드 플랫폼 구현 {:#hybrid-platform-implementations}

플랫폼 구현은 Dart와 플랫폼별 언어를 모두 사용할 수도 있습니다. 
예를 들어, 플러그인은 각 플랫폼에 대해 다른 플랫폼 채널을 사용하여, 
플랫폼별로 채널을 커스터마이즈할 수 있습니다.

하이브리드 구현은 위에서 설명한 두 등록 시스템을 모두 사용합니다. 
하이브리드 구현을 위해 수정된 위의 `hello_windows` 예는 다음과 같습니다.

```yaml
flutter:
  plugin:
    implements: hello
    platforms:
      windows:
        dartPluginClass: HelloPluginWindows
        pluginClass: HelloPlugin
```

Dart의 `HelloPluginWindows` 클래스는, 
Dart 전용 구현에 대해 위에 표시된 `registerWith()`를 사용하는 반면, 
C++의 `HelloPlugin` 클래스는 C++ 전용 구현과 동일합니다.

### 플러그인 테스트 {:#testing-your-plugin}

플러그인을 자동화된 테스트로 테스트하여 코드를 변경할 때, 
기능이 퇴보하지 않는지 확인하는 것이 좋습니다.

플러그인 테스트에 대해 자세히 알아보려면, 
[플러그인 테스트][Testing plugins]를 확인하세요. 
Flutter 앱에 대한 테스트를 작성하고 플러그인이 충돌을 일으키는 경우, 
[플러그인 테스트의 Flutter][Flutter in plugin tests]를 확인하세요.

[Flutter in plugin tests]: /testing/plugins-in-tests
[Testing plugins]: /testing/testing-plugins

## FFI 플러그인 패키지 개발 {:#plugin-ffi}

Dart의 FFI를 사용하여 네이티브 API를 호출하는 패키지를 개발하려면, 
FFI 플러그인 패키지를 개발해야 합니다.

FFI 플러그인 패키지와 비 FFI 플러그인 패키지 모두 네이티브 코드 번들링을 지원합니다. 
그러나, FFI 플러그인 패키지는 메서드 채널을 지원하지 않지만, 
메서드 채널 등록 코드(method channel registration code)는 _지원합니다._
메서드 채널 _및_ FFI를 모두 사용하는 플러그인을 구현하려면, 
비 FFI 플러그인을 사용합니다. 
각 플랫폼은 FFI 또는 비 FFI 플랫폼을 사용할 수 있습니다.

### 1단계: 패키지 생성 {:#step-1-create-the-package-2}

시작 FFI 플러그인 패키지를 만들려면, 
`flutter create` 명령에 `--template=plugin_ffi` 플래그를 사용합니다.

```console
$ flutter create --template=plugin_ffi hello
```

이렇게 하면 `hello` 폴더에 다음과 같은 특수 콘텐츠가 있는 FFI 플러그인 프로젝트가 생성됩니다.

**lib**: 플러그인의 API를 정의하고, `dart:ffi`를 사용하여 네이티브 코드를 호출하는, Dart 코드입니다.

**src**: 네이티브 소스 코드와 해당 소스 코드를 동적 라이브러리로 빌드하기 위한 `CMakeLists.txt` 파일입니다.

**platform folders** (`android`, `ios`, `windows` 등): 네이티브 코드 라이브러리를 빌드하고 플랫폼 애플리케이션과 번들링하기 위한 빌드 파일입니다.


### 2단계: 네이티브 코드 빌드 및 번들링 {:#step-2-building-and-bundling-native-code}

`pubspec.yaml`은 FFI 플러그인을 다음과 같이 지정합니다.

```yaml
  plugin:
    platforms:
      some_platform:
        ffiPlugin: true
```

이 구성은 다양한 대상 플랫폼에 대한 네이티브 빌드를 호출하고, 
이러한 FFI 플러그인을 사용하여 Flutter 애플리케이션의 바이너리를 번들로 묶습니다.

이것은 `dartPluginClass`와 결합될 수 있습니다. 
예를 들어, FFI가 페더레이션 플러그인에서 하나의 플랫폼을 구현하는 데 사용되는 경우입니다.

```yaml
  plugin:
    implements: some_other_plugin
    platforms:
      some_platform:
        dartPluginClass: SomeClass
        ffiPlugin: true
```

플러그인은 FFI와 메서드 채널을 모두 가질 수 있습니다.

```yaml
  plugin:
    platforms:
      some_platform:
        pluginClass: SomeName
        ffiPlugin: true
```

FFI(및 메서드 채널) 플러그인에서 호출하는 네이티브 빌드 시스템은 다음과 같습니다.

* Android의 경우: 네이티브 빌드를 위해 Android NDK를 호출하는 Gradle.
  * `android/build.gradle`에서 문서를 참조하세요.
* iOS 및 macOS의 경우: CocoaPods를 사용하는 Xcode.
  * `ios/hello.podspec`에서 문서를 참조하세요.
  * `macos/hello.podspec`에서 문서를 참조하세요.
* Linux 및 Windows의 경우: CMake.
  * `linux/CMakeLists.txt`에서 문서를 참조하세요.
  * `windows/CMakeLists.txt`에서 문서를 참조하세요.

### 3단계: 네이티브 코드에 바인딩 {:#step-3-binding-to-native-code}

네이티브 코드를 사용하려면, Dart에서 바인딩이 필요합니다.

직접 작성하는 것을 피하기 위해, [`package:ffigen`][]에서 헤더 파일(`src/hello.h`)에서 바인딩을 생성합니다. 
이 패키지를 설치하는 방법에 대한 정보는 [ffigen 문서][ffigen docs]를 참조하세요.

다음을 실행하여 바인딩을 다시 생성합니다.

```console
$  dart run ffigen --config ffigen.yaml
```

### 4단계: 네이티브 코드 호출 {:#step-4-invoking-native-code}

매우 짧은 실행 시간의 네이티브 함수는 모든 isolate에서 직접 호출할 수 있습니다. 
예를 들어, `lib/hello.dart`의 `sum`을 참조하세요.

Flutter 애플리케이션에서 프레임이 드롭되는 것을 방지하기 위해, 
더 오래 실행되는 함수는 [helper isolate][]에서 호출해야 합니다. 
예를 들어 `lib/hello.dart`의 `sumAsync`를 참조하세요.

## 문서 추가 {:#adding-documentation}

모든 패키지에 다음 문서를 추가하는 것이 좋습니다.

1. 패키지를 소개하는 `README.md` 파일
1. 각 버전의 변경 사항을 설명하는 `CHANGELOG.md` 파일
1. 패키지 라이선스 조건을 포함하는 [`LICENSE`] 파일
1. 모든 공개 API에 대한 API 문서(자세한 내용은 아래 참조)

### API 문서 {:#api-documentation}

패키지를 게시하면, API 문서가 자동으로 생성되어 pub.dev/documentation에 게시됩니다. 
예를 들어 [`device_info`][]에 대한 문서를 참조하세요.

개발 머신에서 로컬로 API 문서를 생성하려면, 다음 명령을 사용하세요.

<ol>
<li>

패키지 위치로 디렉토리를 변경하세요:

```console
cd ~/dev/mypackage
```

</li>

<li>

Flutter SDK가 있는 위치를 문서 도구에 알려주세요.
(다음 명령을 변경하여 배치한 위치를 반영하세요):

```console
   export FLUTTER_ROOT=~/dev/flutter  # macOS 또는 Linux에서

   set FLUTTER_ROOT=~/dev/flutter     # Windows에서
```
</li>

<li>

다음과 같이 `dart doc` 도구(Flutter SDK의 일부로 포함됨)를 실행합니다.

```console
   $FLUTTER_ROOT/bin/cache/dart-sdk/bin/dart doc   # on macOS or Linux

   %FLUTTER_ROOT%\bin\cache\dart-sdk\bin\dart doc  # on Windows
```
</li>
</ol>

API 문서를 작성하는 방법에 대한 팁은, [효과적인 Dart 문서][Effective Dart Documentation]를 ​​참조하세요.

### LICENSE 파일에 라이센스 추가 {:#adding-licenses-to-the-license-file}

각 LICENSE 파일 내의 개별 라이선스는 한 줄에 80개의 하이픈으로 구분해야 합니다.

LICENSE 파일에 두 개 이상의 구성 요소 라이선스가 포함된 경우, 
각 구성 요소 라이선스는 구성 요소 라이선스가 적용되는 패키지의 이름으로 시작해야 하며, 
각 패키지 이름은 한 줄에 있어야 하며, 
패키지 이름 리스트는 실제 라이선스 텍스트와 빈 줄로 구분해야 합니다. 
(패키지는 pub 패키지의 이름과 일치할 필요가 없습니다. 
예를 들어, 패키지 자체에 여러 타사 소스의 코드가 포함되어 있을 수 있으며, 
각각에 대한 라이선스를 포함해야 할 수 있습니다.)

다음 예는 잘 구성된 라이선스 파일을 보여줍니다.

```plaintext
package_1

<some license text>

--------------------------------------------------------------------------------
package_2

<some license text>
```

잘 정리된 라이선스 파일의 또 다른 예는 다음과 같습니다.

```plaintext
package_1

<some license text>

--------------------------------------------------------------------------------
package_1
package_2

<some license text>
```

다음은 제대로 구성되지 않은 라이센스 파일의 예입니다.

```plaintext
<some license text>

--------------------------------------------------------------------------------
<some license text>
```

제대로 구성되지 않은 라이센스 파일의 또 다른 예:

```plaintext
package_1

<some license text>
--------------------------------------------------------------------------------
<some license text>
```

## 패키지 게시 {:#publish}

:::tip
pub.dev의 일부 패키지와 플러그인이 [Flutter Favorites][]로 지정되어 있는 것을 알아차리셨나요? 
이는 검증된 개발자가 게시한 패키지이며, 앱을 작성할 때 먼저 고려해야 할 패키지와 플러그인으로 식별됩니다. 
자세한 내용은 [Flutter Favorites 프로그램][Flutter Favorites program]을 참조하세요.
:::

패키지를 구현한 후에는, [pub.dev][]에 게시하여, 다른 개발자가 쉽게 사용할 수 있도록 할 수 있습니다.

게시하기 전에 `pubspec.yaml`, `README.md`, `CHANGELOG.md` 파일을 검토하여 콘텐츠가 완전하고 올바른지 확인하세요. 
또한, 패키지의 품질과 사용성을 개선하고, Flutter Favorite 상태에 도달할 가능성을 높이기 위해, 다음 항목을 포함하는 것을 고려하세요.

* 다양한 코드 사용 예
* 스크린샷, 애니메이션 GIF 또는 비디오
* 해당 코드 저장소에 대한 링크

다음으로, `dry-run` 모드에서 publish 명령을 실행하여, 
모든 것이 분석을 통과하는지 확인하세요.

```console
$ flutter pub publish --dry-run
```

다음 단계는 pub.dev에 게시하는 것입니다. 
하지만, [게시가 영원하기][publishing is forever] 때문에, 준비가 되어 있는지 확인하세요.

```console
$ flutter pub publish
```

For more details on publishing, see the
[publishing docs][] on dart.dev.

## 패키지 상호 종속성 처리 {:#dependencies}

다른 패키지에서 노출된 Dart API에 종속된 패키지 `hello`를 개발하는 경우, 
해당 패키지를 `pubspec.yaml` 파일의 `dependencies` 섹션에 추가해야 합니다. 
아래 코드는 `url_launcher` 플러그인의 Dart API를 `hello`에서 사용할 수 있도록 합니다.

```yaml
dependencies:
  url_launcher: ^5.0.0
```

이제 `hello`의 Dart 코드에서 `import 'package:url_launcher/url_launcher.dart'`와 `launch(someUrl)`를 사용할 수 있습니다.

이는 Flutter 앱이나 다른 Dart 프로젝트에 패키지를 포함하는 방법과 다르지 않습니다.

하지만 `hello`가 플랫폼별 코드가 `url_launcher`에서 노출된 플랫폼별 API에 액세스해야 하는 _플러그인_ 패키지인 경우, 
아래에 표시된 것처럼, 플랫폼별 빌드 파일에 적절한 종속성 선언을 추가해야 합니다.

### Android {:#android}

다음 예제에서는 `hello/android/build.gradle`에서 `url_launcher`에 대한 종속성을 설정합니다.

```groovy
android {
    // 줄 생략됨
    dependencies {
        compileOnly rootProject.findProject(":url_launcher")
    }
}
```

이제 `import io.flutter.plugins.urllauncher.UrlLauncherPlugin`을 사용하여, 
`hello/android/src` 소스 코드에서 `UrlLauncherPlugin` 클래스에 액세스할 수 있습니다.

`build.gradle` 파일에 대한 자세한 내용은, 빌드 스크립트에 대한 [Gradle 문서][Gradle Documentation]를 ​​참조하세요.

### iOS {:#ios}

다음 예제에서는 `hello/ios/hello.podspec`에서 `url_launcher`에 대한 종속성을 설정합니다.

```ruby
Pod::Spec.new do |s|
  # lines skipped
  s.dependency 'url_launcher'
```

이제 `#import "UrlLauncherPlugin.h"`를 사용하여 `hello/ios/Classes`의 소스 코드에서 `UrlLauncherPlugin` 클래스에 액세스할 수 있습니다.

`.podspec` 파일에 대한 추가 세부 정보는 [CocoaPods 문서][CocoaPods Documentation]를 ​​참조하세요.

### Web {:#web}

다른 Dart 패키지와 마찬가지로, 
모든 웹 종속성은 `pubspec.yaml` 파일에 의해 처리됩니다.

{% comment %}
<!-- Remove until we have better text. -->
### MacOS

PENDING
{% endcomment %}

[CocoaPods Documentation]: https://guides.cocoapods.org/syntax/podspec.html
[Dart library package]: {{site.dart-site}}/guides/libraries/create-library-packages
[`device_info`]: {{site.pub-api}}/device_info/latest
[Effective Dart Documentation]: {{site.dart-site}}/guides/language/effective-dart/documentation
[federated plugins]: #federated-plugins
[ffigen docs]: {{site.pub-pkg}}/ffigen/install
[Android]: /platform-integration/android/c-interop
[iOS]: /platform-integration/ios/c-interop
[macOS]: /platform-integration/macos/c-interop
[`fluro`]: {{site.pub}}/packages/fluro
[Flutter editor]: /get-started/editor
[Flutter Favorites]: {{site.pub}}/flutter/favorites
[Flutter Favorites program]: /packages-and-plugins/favorites
[Gradle Documentation]: https://docs.gradle.org/current/userguide/tutorial_using_tasks.html
[helper isolate]: {{site.dart-site}}/guides/language/concurrency#background-workers
[How to Write a Flutter Web Plugin, Part 1]: {{site.flutter-medium}}/how-to-write-a-flutter-web-plugin-5e26c689ea1
[How To Write a Flutter Web Plugin, Part 2]: {{site.flutter-medium}}/how-to-write-a-flutter-web-plugin-part-2-afdddb69ece6
[issue #33302]: {{site.repo.flutter}}/issues/33302
[`LICENSE`]: #adding-licenses-to-the-license-file
[`path`]: {{site.pub}}/packages/path
[`package:ffigen`]: {{site.pub}}/packages/ffigen
[platform channel]: /platform-integration/platform-channels
[pub.dev]: {{site.pub}}
[publishing docs]: {{site.dart-site}}/tools/pub/publishing
[publishing is forever]: {{site.dart-site}}/tools/pub/publishing#publishing-is-forever
[supported-platforms]: #plugin-platforms
[test your plugin]: #testing-your-plugin
[unit tests]: /testing/overview#unit-tests
[`url_launcher`]: {{site.pub}}/packages/url_launcher
[Writing a good plugin]: {{site.flutter-medium}}/writing-a-good-flutter-plugin-1a561b986c9c
