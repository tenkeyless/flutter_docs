---
# title: Using packages
title: 패키지 사용
# description: How to use packages in your Flutter app.
description: Flutter 앱에서 패키지를 사용하는 방법.
---

<?code-excerpt path-base="platform_integration/plugin_api_migration"?>

Flutter는 다른 개발자가 Flutter 및 Dart 생태계에 기여한 공유 패키지를 사용하는 것을 지원합니다. 
이를 통해 모든 것을 처음부터 개발하지 않고도 앱을 빠르게 빌드할 수 있습니다.

:::note 패키지와 플러그인의 차이점
플러그인은 패키지의 _타입_ 입니다. 전체 명칭은 _플러그인 패키지_ 이며, 일반적으로 _플러그인_ 으로 줄여서 부릅니다.

**패키지 (Packages)**
: 최소한, Dart 패키지는 `pubspec.yaml` 파일을 포함하는 디렉토리입니다. 
  또한, 패키지에는 종속성(pubspec에 나열됨), Dart 라이브러리, 앱, 리소스, 테스트, 이미지, 글꼴 및 예제가 포함될 수 있습니다. 
  [pub.dev][] 사이트에는 Google 엔지니어와 Flutter 및 Dart 커뮤니티의 관대한 구성원이 개발한 많은 패키지가 나열되어 있으며, 앱에서 사용할 수 있습니다.

**플러그인 (Plugins)**
: 플러그인 패키지는 플랫폼 기능을 앱에 제공하는 특별한 종류의 패키지입니다. 
  플러그인 패키지는 Android(Kotlin 또는 Java 사용), iOS(Swift 또는 Objective-C 사용), 웹, macOS, Windows, Linux 또는 이들의 조합으로 작성할 수 있습니다. 
  예를 들어, 플러그인은 Flutter 앱에 기기의 카메라를 사용할 수 있는 기능을 제공할 수 있습니다.

{% ytEmbed 'Y9WifT8aN6o', '패키지 vs 플러그인 | Decoding Flutter' %}
:::

기존 패키지는 네트워크 요청([`http`][]), 네비게이션/route 처리([`go_router`][]), 기기 API와의 통합([`url_launcher`][] 및 [`battery_plus`][]), Firebase와 같은 타사 플랫폼 SDK 사용([FlutterFire][]) 등 다양한 사용 사례를 지원합니다.

새 패키지를 작성하려면, [패키지 개발][developing packages]을 참조하세요. 
파일이나 패키지에 저장된 assets, 이미지 또는 글꼴을 추가하려면 [assets 및 이미지 추가][Adding assets and images]를 참조하세요.

[Adding assets and images]: /ui/assets/assets-and-images
[`battery_plus`]: {{site.pub-pkg}}/battery_plus
[developing packages]: /packages-and-plugins/developing-packages
[FlutterFire]: {{site.github}}/firebase/flutterfire

[`go_router`]: {{site.pub-pkg}}/go_router
[`http`]: /cookbook/networking/fetch-data
[pub.dev]: {{site.pub}}
[`url_launcher`]: {{site.pub-pkg}}/url_launcher

## 패키지 사용 {:#using-packages}

다음 섹션에서는 기존에 게시된 패키지를 사용하는 방법을 설명합니다.

### 패키지 검색 {:#searching-for-packages}

패키지는 [pub.dev][]에 게시됩니다.

pub.dev의 [Flutter 랜딩 페이지][Flutter landing page]는 Flutter와 호환되는 상위 패키지(일반적으로 Flutter와 호환되는 종속성을 선언하는 패키지)를 표시하고, 게시된 모든 패키지에서 검색을 지원합니다.

pub.dev의 [Flutter Favorites][] 페이지에는 앱을 작성할 때 먼저 고려해야 할 패키지로 식별된 플러그인과 패키지가 나열되어 있습니다. Flutter Favorite가 되는 것에 대한 자세한 내용은, [Flutter Favorites 프로그램][Flutter Favorites program]을 참조하세요.

[Android][], [iOS][], [web][], [Linux][], [Windows][], [macOS][] 또는 이들의 조합을 필터링하여 pub.dev에서 패키지를 찾아볼 수도 있습니다.

[Android]: {{site.pub-pkg}}?q=sdk%3Aflutter+platform%3Aandroid
[Flutter Favorites]: {{site.pub}}/flutter/favorites
[Flutter Favorites program]: /packages-and-plugins/favorites
[Flutter landing page]: {{site.pub}}/flutter
[Linux]: {{site.pub-pkgs}}?q=sdk%3Aflutter+platform%3Alinux
[iOS]: {{site.pub-pkg}}?q=sdk%3Aflutter+platform%3Aios
[macOS]: {{site.pub-pkg}}?q=sdk%3Aflutter+platform%3Amacos
[web]: {{site.pub-pkg}}?q=sdk%3Aflutter+platform%3Aweb
[Windows]: {{site.pub-pkg}}?q=sdk%3Aflutter+platform%3Awindows

### 앱에 패키지 종속성 추가 {:#adding-a-package-dependency-to-an-app}

앱에 패키지 `css_colors`를 추가하려면:

1. 의존성 추가
   * 앱 폴더 내부에 있는 `pubspec.yaml` 파일을 열고, 
     `dependencies` 아래에 `css_colors:`를 추가합니다.

2. 설치하기
   * 터미널에서: `flutter pub get`을 실행합니다.<br/>
   **또는**
   * VS Code에서: `pubspec.yaml` 상단의 작업 리본 오른쪽에 있는, 
     다운로드 아이콘으로 표시된 **Get Packages**를 클릭합니다.
   * Android Studio/IntelliJ에서: `pubspec.yaml` 상단의 작업 리본에서, 
     **Pub get**을 클릭합니다.

3. 가져오기
   * Dart 코드에 해당하는 `import` 문을 추가합니다.

4. 필요한 경우 앱을 중지했다가 다시 시작합니다.
   * 패키지가 플랫폼별 코드(Android의 경우 Kotlin/Java, iOS의 경우 Swift/Objective-C)를 가져오는 경우, 해당 코드를 앱에 빌드해야 합니다. 
   * 핫 리로드와 핫 리스타트는 Dart 코드만 업데이트하므로, 패키지를 사용할 때 `MissingPluginException`과 같은 오류를 방지하려면, 앱을 완전히 다시 시작해야 할 수도 있습니다.


### `flutter pub add`를 사용하여 앱에 패키지 종속성 추가 {:#adding-a-package-dependency-to-an-app-using-flutter-pub-add}

앱에 패키지 `css_colors`를 추가하려면:

1. 프로젝트 디렉토리 내부에 있는 동안 명령을 실행합니다.
   * `flutter pub add css_colors`

2. import 합니다.
   * Dart 코드에 해당하는 `import` 문을 추가합니다.

3. 필요한 경우 앱을 중지했다가, 다시 시작합니다.
   * 패키지가 플랫폼별 코드(Android의 경우 Kotlin/Java, iOS의 경우 Swift/Objective-C)를 가져오는 경우, 
     해당 코드를 앱에 빌드해야 합니다. 
     핫 리로드와 핫 리스타트는 Dart 코드만 업데이트하므로, 
     패키지를 사용할 때 `MissingPluginException`과 같은 오류를 방지하기 위해 앱을 완전히 다시 시작해야 할 수 있습니다.

### `flutter pub remove`를 사용하여 앱의 패키지 종속성 제거 {:#removing-a-package-dependency-to-an-app-using-flutter-pub-remove}

패키지 `css_colors`를 앱에 제거하려면:

1. 프로젝트 디렉토리 내부에 있는 동안 명령을 실행합니다.
   * `flutter pub remove css_colors`

pub.dev의 모든 패키지 페이지에서 사용할 수 있는 [Installing 탭][Installing tab]은 이러한 단계에 대한 편리한 참조입니다.

전체 예제는 아래의 [css_colors 예제][css_colors example]를 참조하세요.

[css_colors example]: #css-example
[Installing tab]: {{site.pub-pkg}}/css_colors/install

### 충돌 해결 {:#conflict-resolution}

앱에서 `some_package`와 `another_package`를 사용하고자 하며, 
둘 다 `url_launcher`에 의존하지만 버전이 다르다고 가정해 보겠습니다. 
그러면 잠재적인 충돌이 발생합니다. 
이를 피하는 가장 좋은 방법은, 패키지 작성자가 종속성을 지정할 때, 
특정 버전 대신 [버전 범위][version ranges]를 사용하는 것입니다.

```yaml
dependencies:
  url_launcher: ^5.4.0    # 좋습니다. 5.4.0 이상, 6.0.0 미만인 모든 버전
  image_picker: '5.4.3'   # 별로 좋지 않습니다. 5.4.3 버전만 작동합니다.
```

`some_package`가 위의 종속성을 선언하고, `another_package`가 `'5.4.6'` 또는 `^5.5.0`과 같은 호환되는 `url_launcher` 종속성을 선언하는 경우, pub은 자동으로 문제를 해결합니다. 
[Gradle modules][] 및/또는 [CocoaPods][]에 대한 플랫폼별 종속성은 비슷한 방식으로 해결됩니다.

`some_package`와 `another_package`가 `url_launcher`에 대해 호환되지 않는 버전을 선언하더라도, 
실제로는 호환되는 방식으로 `url_launcher`를 사용할 수 있습니다. 
이 상황에서는, 앱의 `pubspec.yaml` 파일에 종속성 재정의 선언을 추가하여, 
특정 버전을 사용하도록 강제하여 충돌을 해결할 수 있습니다.

예를 들어, `url_launcher` 버전 `5.4.0`을 사용하도록 강제하려면, 앱의 `pubspec.yaml` 파일을 다음과 같이 변경합니다.

```yaml
dependencies:
  some_package:
  another_package:
dependency_overrides:
  url_launcher: '5.4.0'
```

충돌하는 종속성이 패키지 자체가 아니라, `guava`와 같은 Android 전용 라이브러리인 경우, 
종속성 재정의 선언을 대신 Gradle 빌드 로직에 추가해야 합니다.

`guava` 버전 `28.0`을 강제로 사용하려면, 앱의 `android/build.gradle` 파일을 다음과 같이 변경합니다.

```groovy
configurations.all {
    resolutionStrategy {
        force 'com.google.guava:guava:28.0-android'
    }
}
```

CocoaPods는 현재 종속성 재정의 기능을 제공하지 않습니다.

[CocoaPods]: https://guides.cocoapods.org/syntax/podspec.html#dependency
[Gradle modules]: https://docs.gradle.org/current/userguide/declaring_dependencies.html
[version ranges]: {{site.dart-site}}/tools/pub/dependencies#version-constraints

## 새로운 패키지 개발 {:#developing-new-packages}

특정 사용 사례에 맞는 패키지가 없는 경우, [커스텀 패키지를 작성][write a custom package]할 수 있습니다.

[write a custom package]: /packages-and-plugins/developing-packages

## 패키지 종속성 및 버전 관리 {:#managing-package-dependencies-and-versions}

버전 충돌 위험을 최소화하려면, `pubspec.yaml` 파일에 버전 범위를 지정하세요.

### 패키지 버전 {:#package-versions}

모든 패키지에는 패키지의 `pubspec.yaml` 파일에 지정된, 버전 번호가 있습니다. 
패키지의 현재 버전은 이름 옆에 표시됩니다. (예: [`url_launcher`][] 패키지 참조) 
또한, 모든 이전 버전 리스트도 표시됩니다. ([`url_launcher` 버전][`url_launcher` versions] 참조)

패키지를 업데이트할 때 앱이 중단되지 않도록 하려면, 다음 형식 중 하나를 사용하여 버전 범위를 지정합니다.

* **범위 제약 (Ranged constraints):** 최소 및 최대 버전을 지정합니다.

  ```yaml
  dependencies:
    url_launcher: '>=5.4.0 <6.0.0'
  ```

* **[캐럿(caret) 구문][caret syntax]을 사용한 범위 제약:**
  포괄적인 최소 버전으로 사용되는 버전을 지정합니다.
  이는 해당 버전에서 다음 major 버전까지의 모든 버전을 포함합니다.

  ```yaml
  dependencies:
    collection: '^5.4.0'
  ```

  이 구문은 첫 번째 항목에서 언급한 것과 같은 의미입니다.

자세한 내용은, [패키지 버전 관리 가이드][package versioning guide]를 확인하세요.

[caret syntax]: {{site.dart-site}}/tools/pub/dependencies#caret-syntax
[package versioning guide]: {{site.dart-site}}/tools/pub/versioning
[`url_launcher` versions]: {{site.pub-pkg}}/url_launcher/versions

### 패키지 종속성 업데이트 {:#updating-package-dependencies}

패키지를 추가한 후 처음으로 `flutter pub get`을 실행할 때, 
Flutter는 `pubspec.lock` [lockfile][]에서 찾은 구체적인 패키지 버전을 저장합니다. 
이렇게 하면 본인 또는 팀의 다른 개발자가 `flutter pub get`을 실행하더라도, 동일한 버전을 다시 얻을 수 있습니다.

예를 들어 해당 패키지의 새 기능을 사용하기 위해, 패키지의 새 버전으로 업그레이드하려면, 
`flutter pub upgrade`를 실행하여, `pubspec.yaml`에 지정된 버전 제약 조건으로, 
허용되는 패키지의 가장 높은 사용 가능한 버전을 검색합니다. 
이 명령은 Flutter 자체를 업데이트하는 `flutter upgrade` 또는 `flutter update-packages`와는 다른 명령입니다.

[lockfile]: {{site.dart-site}}/tools/pub/glossary#lockfile

### 게시되지 않은 패키지에 대한 종속성 {:#dependencies-on-unpublished-packages}

패키지는 pub.dev에 게시되지 않은 경우에도 사용할 수 있습니다. 
비공개 패키지 또는 게시할 준비가 되지 않은 패키지의 경우, 추가 종속성 옵션을 사용할 수 있습니다.

**경로 종속성**
: Flutter 앱은 파일 시스템 `path:` 종속성을 사용하여 패키지에 종속될 수 있습니다. 
  경로는 상대 경로 또는 절대 경로일 수 있습니다. 
  상대 경로는 `pubspec.yaml`이 포함된 디렉터리를 기준으로 평가됩니다. 예를 들어, app 옆 디렉터리에 있는 패키지 packageA에 종속되려면 다음 구문을 사용합니다.

  ```yaml
    dependencies:
    packageA:
      path: ../packageA/
  
  ```

**Git 종속성**
: Git 저장소에 저장된 패키지에 의존할 수도 있습니다. 패키지가 저장소 루트에 있는 경우 다음 구문을 사용합니다.

  ```yaml
    dependencies:
      packageA:
        git:
          url: https://github.com/flutter/packageA.git
  ```

**SSH를 사용한 Git 종속성**
: 저장소가 private이고 SSH를 사용하여 연결할 수 있는 경우, 저장소의 SSH url을 사용하여 패키지에 종속:

  ```yaml
    dependencies:
      packageA:
        git:
          url: git@github.com:flutter/packageA.git
  ```

**폴더에 있는 패키지에 대한 Git 종속성**
: Pub은 패키지가 Git 저장소의 루트에 있다고 가정합니다. 그렇지 않은 경우, `path` 인수로 위치를 지정합니다. 예를 들어:

  ```yaml
  dependencies:
    packageA:
      git:
        url: https://github.com/flutter/packages.git
        path: packages/packageA
  ```

  마지막으로, `ref` 인수를 사용하여 종속성을 특정 git 커밋, 브랜치 또는 태그에 고정합니다. 
  자세한 내용은 [패키지 종속성][Package dependencies]을 참조하세요.

[Package dependencies]: {{site.dart-site}}/tools/pub/dependencies

## 예제 {:#examples}

다음 예제에서는 패키지 사용에 필요한 단계를 안내합니다.

### 예제: css_colors 패키지 사용 {:#css-example}

[`css_colors`][] 패키지는 CSS 색상에 대한 색상 상수를 정의하므로, 
Flutter 프레임워크가 `Color` 타입을 예상하는 모든 곳에서 상수를 사용합니다.

이 패키지를 사용하려면:

1. `cssdemo`라는 새 프로젝트를 만듭니다.

2. `pubspec.yaml`을 열고 `css-colors` 종속성을 추가합니다.

   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     css_colors: ^1.0.0
   ```

3. 터미널에서 `flutter pub get`을 실행하거나, VS Code에서 **Get Packages**를 클릭합니다.

4. `lib/main.dart`를 열고, 전체 내용을 다음으로 바꿉니다.
   
    <?code-excerpt "lib/css_colors.dart (css-colors)"?>
    ```dart
    import 'package:css_colors/css_colors.dart';
    import 'package:flutter/material.dart';
    
    void main() {
      runApp(const MyApp());
    }
    
    class MyApp extends StatelessWidget {
      const MyApp({super.key});
    
      @override
      Widget build(BuildContext context) {
        return const MaterialApp(
          home: DemoPage(),
        );
      }
    }
    
    class DemoPage extends StatelessWidget {
      const DemoPage({super.key});
    
      @override
      Widget build(BuildContext context) {
        return Scaffold(body: Container(color: CSSColors.orange));
      }
    }
    ```

  [`css_colors`]: {{site.pub-pkg}}/css_colors

5. 앱을 실행합니다. 앱의 배경은 이제 주황색이어야 합니다.

### 예제: url_launcher 패키지를 사용하여 브라우저 실행 {:#url-example}

[`url_launcher`][] 플러그인 패키지를 사용하면, 모바일 플랫폼에서 기본 브라우저를 열어 주어진 URL을 표시할 수 있으며, 
Android, iOS, 웹, Windows, Linux, macOS에서 지원됩니다. 
이 패키지는 _플러그인 패키지_ (또는 _플러그인_)라고 하는 특수 Dart 패키지로, 플랫폼별 코드가 포함되어 있습니다.

이 플러그인을 사용하려면:

1. `launchdemo`라는 새 프로젝트를 만듭니다.

2. `pubspec.yaml`을 열고 `url_launcher` 종속성을 추가합니다. 

   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     url_launcher: ^5.4.0
   ```

3. 터미널에서 `flutter pub get`을 실행하거나, VS Code에서 **Get Packages get**을 클릭합니다.

4. `lib/main.dart`를 열고, 전체 내용을 다음으로 바꿉니다.

    <?code-excerpt "lib/url_launcher.dart (url-launcher)"?>
    ```dart
    import 'package:flutter/material.dart';
    import 'package:path/path.dart' as p;
    import 'package:url_launcher/url_launcher.dart';
    
    void main() {
      runApp(const MyApp());
    }
    
    class MyApp extends StatelessWidget {
      const MyApp({super.key});
    
      @override
      Widget build(BuildContext context) {
        return const MaterialApp(
          home: DemoPage(),
        );
      }
    }
    
    class DemoPage extends StatelessWidget {
      const DemoPage({super.key});
    
      void launchURL() {
        launchUrl(p.toUri('https://flutter.dev'));
      }
    
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: launchURL,
              child: const Text('Show Flutter homepage'),
            ),
          ),
        );
      }
    }
    ```

5. 앱을 실행합니다. (또는 플러그인을 추가하기 전에 이미 실행 중이었다면, 중지했다가 다시 시작합니다) 
   **Show Flutter homepage**를 클릭합니다. 
   기기에서 기본 브라우저가 열려, flutter.dev의 홈페이지가 표시됩니다.
