---
# title: Integrate a Flutter module into your Android project
title: Android 프로젝트에 Flutter 모듈 통합
# short-title: Integrate Flutter
short-title: Flutter 통합
# description: Learn how to integrate a Flutter module into your existing Android project.
description: 기존 Android 프로젝트에 Flutter 모듈을 통합하는 방법을 알아보세요.
---

Flutter는 기존 Android 애플리케이션에 조각조각으로 임베드할 수 있으며, 
소스 코드 Gradle subproject 또는 AAR로 임베드할 수 있습니다.

통합 흐름은 [Flutter 플러그인][Flutter plugin]을 사용하여 Android Studio IDE를 사용하거나 수동으로 수행할 수 있습니다.

:::warning
기존 Android 앱은 `mips` 또는 `x86`과 같은 아키텍처를 지원할 수 있습니다. 
Flutter는 현재 `x86_64`, `armeabi-v7a` 및 `arm64-v8a`에 대한 
사전 컴파일(ahead-of-time (AOT))된 라이브러리 빌드만 [지원][only supports]합니다.

APK에서 지원되는 아키텍처를 제한하려면, [`abiFilters`][] Android Gradle 플러그인 API를 사용하는 것을 고려하세요. 
이렇게 하면 `libflutter.so` 런타임 크래시가 누락되는 것을 방지할 수 있습니다. 예를 들어, 다음과 같습니다.

{% tabs "android-build-language" %}
{% tab "Kotlin" %}

```kotlin title="MyApp/app/build.gradle.kts"
android {
    //...
    defaultConfig {
        ndk {
            // Flutter에서 지원하는 아키텍처에 대한 필터
            abiFilters += listOf("armeabi-v7a", "arm64-v8a", "x86_64")
        }
    }
}
```

{% endtab %}
{% tab "Groovy" %}

```groovy title="MyApp/app/build.gradle"
android {
    // ...
    defaultConfig {
        ndk {
            // Flutter에서 지원하는 아키텍처에 대한 필터
            abiFilters "armeabi-v7a", "arm64-v8a", "x86_64"
        }
    }
}
```

{% endtab %}
{% endtabs %}

Flutter 엔진에는 `x86_64` 버전도 있습니다. 
디버그 Just-In-Time(JIT) 모드에서 에뮬레이터를 사용할 때, Flutter 모듈은 여전히 ​​올바르게 실행됩니다.
:::

## Flutter 모듈 통합 {:#integrate-your-flutter-module}

{% tabs %}
{% tab "Android Studio로" %}

### Android Studio로 통합하기 {:#integrate-with-android-studio .no_toc}

Android Studio IDE는 Flutter 모듈을 통합하는 데 도움이 될 수 있습니다. 
Android Studio를 사용하면, 동일한 IDE에서 Android와 Flutter 코드를 모두 편집할 수 있습니다.

Dart 코드 완성, 핫 리로드, 위젯 검사기와 같은, 
IntelliJ Flutter 플러그인 기능을 사용할 수도 있습니다.

앱을 빌드하기 위해, 
Android Studio 플러그인은 Flutter 모듈을 종속성으로 추가하도록 Android 프로젝트를 구성합니다.

1. Android Studio에서 Android 프로젝트를 엽니다.

1. **File** > **New** > **New Project...** 로 이동합니다. 
   **New Project** 대화 상자가 표시됩니다.

2. **Flutter**를 클릭합니다.

3. **Flutter SDK path**를 제공하라는 메시지가 표시되면, 그렇게 하고 **Next**을 클릭합니다.

4. Flutter 모듈의 구성을 완료합니다.

   * 기존 프로젝트가 있는 경우:

        {: type="a"}
        1. 기존 프로젝트를 선택하려면 **Project location** 상자 오른쪽에 있는 **...** 을 클릭합니다.
        2. Flutter 프로젝트 디렉토리로 이동합니다.
        3. **Open**를 클릭합니다.

   * 새 Flutter 프로젝트를 만들어야 하는 경우:

        {: type="a"}
        1. 구성 대화 상자를 완료합니다.
        2. **Project type** 메뉴에서 **Module**을 선택합니다.

5. **Finish**를 클릭합니다.

:::tip
기본적으로, 프로젝트의 Project 창에는 'Android' 뷰가 표시될 수 있습니다. 
Project 창에서 새 Flutter 파일을 볼 수 없는 경우, 
Project 창을 **Project Files**로 설정하세요. 
이렇게 하면 필터링 없이 모든 파일이 표시됩니다.
:::

{% endtab %}
{% tab "Android Studio 없이" %}

### Android Studio 없이 통합하기 {:#integrate-without-android-studio .no_toc}

Flutter의 Android Studio 플러그인을 사용하지 않고, 
Flutter 모듈을 기존 Android 앱과 수동으로 통합하려면 다음 단계를 따르세요.

#### Flutter 모듈 생성 {:#create-a-flutter-module}

`some/path/MyApp`에 기존 Android 앱이 있고, 
Flutter 프로젝트를 형제 프로젝트로 만들고 싶다고 가정해 보겠습니다.

```console
cd some/path/
flutter create -t module --org com.example flutter_module
```

이렇게 하면 Dart 코드로 시작하는 `some/path/flutter_module/` Flutter 모듈 프로젝트와 숨겨진 `.android/` 하위 폴더가 생성됩니다. 
`.android` 폴더에는 `flutter run`을 통해 Flutter 모듈의 베어본 독립 실행형 버전을 실행하는 데 도움이 되는 Android 프로젝트가 포함되어 있으며, 
Flutter 모듈을 임베디드 Android 라이브러리로 부트스트랩하는 데 도움이 되는 래퍼이기도 합니다.

:::note
`.android/`에 있는 모듈이 아니라, 
기존 애플리케이션의 프로젝트나 플러그인에 커스텀 Android 코드를 추가하세요. 
모듈의 `.android/` 디렉토리에서 변경한 내용은, 
모듈을 사용하는 기존 Android 프로젝트에 나타나지 않습니다.

`.android/` 디렉토리는 자동 생성되므로 소스 제어(source control)하지 마세요. 
새 컴퓨터에서 모듈을 빌드하기 전에 먼저 `flutter_module` 디렉토리에서 `flutter pub get`을 실행하여, 
`.android/` 디렉토리를 다시 생성한 다음, 
Flutter 모듈을 사용하여 Android 프로젝트를 빌드하세요.
:::

:::note
Dex 병합 문제를 피하기 위해, 
`flutter.androidPackage`는 호스트 앱의 패키지 이름과 동일해서는 안 됩니다.
:::

#### Java 버전 요구 사항 {:#java-version-requirement}

Flutter는 프로젝트가 Java 11 이상과의 호환성을 선언하도록 요구합니다.

Flutter 모듈 프로젝트를 호스트 Android 앱에 연결하기 전에, 
호스트 Android 앱이 앱의 `build.gradle` 파일에서, 
`android { }` 블록 아래에 다음 소스 호환성을 선언했는지 확인하세요.

```groovy title="MyApp/app/build.gradle"
android {
    // ...
    compileOptions {
        sourceCompatibility = 11 // 최소값
        targetCompatibility = 11 // 최소값
    }
}
```

#### 저장소 설정 중앙화 {:#centralize-repository-settings}

Gradle 7부터 Android는 `build.gradle` 파일의 프로젝트 또는 모듈 수준 선언 대신, 
`settings.gradle`의 중앙 저장소 선언을 사용할 것을 권장합니다.

Flutter 모듈 프로젝트를 호스트 Android 앱에 연결하기 전에 다음과 같이 변경합니다.

1. 앱의 모든 `build.gradle` 파일에서 `repositories` 블록을 제거합니다.

   ```groovy
   // 다음 줄부터 다음 블록을 제거하세요.
       repositories {
           google()
           mavenCentral()
       }
   // ...이전 줄로
   ```

2. 이 단계에서 표시된 `dependencyResolutionManagement`를, 
   `settings.gradle` 파일에 추가합니다.

   ```groovy
   dependencyResolutionManagement {
      repositoriesMode = RepositoriesMode.PREFER_SETTINGS
      repositories {
          google()
          mavenCentral()
      }
   }
   ```

{% endtab %}
{% endtabs %}

## Flutter 모듈을 종속성으로 추가하기 {:#add-the-flutter-module-as-a-dependency}

Gradle에서 기존 앱의 종속성으로 Flutter 모듈을 추가합니다. 두 가지 방법으로 이를 달성할 수 있습니다.

1. **Android 아카이브**
    AAR 메커니즘은 Flutter 모듈을 패키징하는 중개자로 일반 Android AAR을 만듭니다. 
    이는 다운스트림 앱 빌더가 Flutter SDK를 설치하지 않으려는 경우에 좋습니다. 
    하지만 자주 빌드하는 경우 빌드 단계가 하나 더 추가됩니다.

1. **모듈 소스 코드**
    소스 코드 하위 프로젝트 메커니즘은 편리한 원클릭 빌드 프로세스이지만, Flutter SDK가 필요합니다. 
    이는 Android Studio IDE 플러그인에서 사용하는 메커니즘입니다.

{% tabs %}
{% tab "Android 아카이브" %}

### Android Archive(AAR)에 의존 {:#depend-on-the-android-archive-aar .no_toc}

이 옵션은 Flutter 라이브러리를 AAR 및 POM 아티팩트로 구성된 일반 로컬 Maven 저장소로 패키징합니다. 
이 옵션을 사용하면 팀이 Flutter SDK를 설치하지 않고도, 호스트 앱을 빌드할 수 있습니다. 
그런 다음 로컬 또는 원격 저장소에서 아티팩트를 배포할 수 있습니다.

`some/path/flutter_module`에서 Flutter 모듈을 빌드한 다음 다음을 실행한다고 가정해 보겠습니다.

```console
cd some/path/flutter_module
flutter build aar
```

그런 다음, 화면의 지시에 따라 통합하세요.

{% render docs/app-figure.md, image:"development/add-to-app/android/project-setup/build-aar-instructions.png" %}

보다 구체적으로, 
이 명령은 (기본적으로 모든 디버그/프로필/릴리스 모드) 다음 파일을 포함하는 [로컬 저장소][local repository]를 생성합니다.

```plaintext
build/host/outputs/repo
└── com
    └── example
        └── flutter_module
            ├── flutter_release
            │   ├── 1.0
            │   │   ├── flutter_release-1.0.aar
            │   │   ├── flutter_release-1.0.aar.md5
            │   │   ├── flutter_release-1.0.aar.sha1
            │   │   ├── flutter_release-1.0.pom
            │   │   ├── flutter_release-1.0.pom.md5
            │   │   └── flutter_release-1.0.pom.sha1
            │   ├── maven-metadata.xml
            │   ├── maven-metadata.xml.md5
            │   └── maven-metadata.xml.sha1
            ├── flutter_profile
            │   ├── ...
            └── flutter_debug
                └── ...
```

AAR에 의존하려면, 호스트 앱이 이러한 파일을 찾을 수 있어야 합니다.

그러려면, 호스트 앱에서 `settings.gradle`을 편집하여 로컬 저장소와 종속성을 포함시킵니다.

```groovy
dependencyResolutionManagement {
    repositoriesMode = RepositoriesMode.PREFER_SETTINGS
    repositories {
        google()
        mavenCentral()

        // 다음 줄부터 새로운 저장소를 추가합니다...
        maven {
            url = uri("some/path/flutter_module/build/host/outputs/repo")
            // 상대 경로를 사용하는 경우, 이는 build.gradle 파일의 위치를 ​​기준으로 합니다.
        }

        maven {
            url = uri("https://storage.googleapis.com/download.flutter.io")
        }
        // ...이 줄 앞으로
    }
}
```

<br>

### Kotlin DSL 기반 Android 프로젝트 {:#kotlin-dsl-based-android-project}

Kotlin DSL 기반 Android 프로젝트의 `aar` 빌드 후, 
다음 단계에 따라 flutter_module을 추가합니다.

Android 프로젝트의 `app/build.gradle` 파일에 flutter 모듈을 종속성으로 포함합니다.

```kotlin title="MyApp/app/build.gradle.kts"
android {
    buildTypes {
        release {
          ...
        }
        debug {
          ...
        }
        create("profile") {
            initWith(getByName("debug"))
        }
}

dependencies {
  // ...
  debugImplementation("com.example.flutter_module:flutter_debug:1.0")
  releaseImplementation("com.example.flutter_module:flutter_release:1.0")
  add("profileImplementation", "com.example.flutter_module:flutter_profile:1.0")
}
```

`profileImplementation` ID는 호스트 프로젝트의 `app/build.gradle` 파일에 구현되는 커스텀 `configuration`입니다.

```kotlin title="host-project/app/build.gradle.kts"
configurations {
    getByName("profileImplementation") {
    }
}
```

```kotlin title="MyApp/settings.gradle.kts"
include(":app")

dependencyResolutionManagement {
    repositories {
        maven(url = "https://storage.googleapis.com/download.flutter.io")
        maven(url = "some/path/flutter_module_project/build/host/outputs/repo")
    }
}
```

:::important
중국에 있는 경우, `storage.googleapis.com` 도메인 대신 미러 사이트를 사용하세요. 
미러 사이트에 대해 자세히 알아보려면, [중국에서 Flutter 사용하기][Using Flutter in China] 페이지를 확인하세요.
:::

:::tip
Android Studio에서 `Build > Flutter > Build AAR` 메뉴를 사용하여, 
Flutter 모듈용 AAR을 빌드할 수도 있습니다.

{% render docs/app-figure.md, image:"development/add-to-app/android/project-setup/ide-build-aar.png" %}
:::

{% endtab %}
{% tab "모듈 소스 코드" %}

### 모듈 소스 코드에 의존 {:#depend-on-the-modules-source-code .no_toc}

이 옵션은 Android 프로젝트와 Flutter 프로젝트 모두에 대한 원스텝 빌드를 가능하게 합니다. 
이 옵션은 두 부분을 동시에 작업하고 빠르게 반복할 때 편리하지만, 
팀은 호스트 앱을 빌드하기 위해 Flutter SDK를 설치해야 합니다.

:::tip
기본적으로, 호스트 앱은 `:app` Gradle 프로젝트를 제공합니다. 
이 프로젝트의 이름을 변경하려면, 
Flutter 모듈의 `gradle.properties` 파일에 `flutter.hostAppProjectName`을 설정합니다. 
이 프로젝트를 호스트 앱의 `settings.gradle` 파일에 포함합니다.
:::

호스트 앱의 `settings.gradle`에 Flutter 모듈을 하위 프로젝트로 포함합니다. 
이 예에서는 `flutter_module`과 `MyApp`이 같은 디렉토리에 있다고 가정합니다.

```groovy title="MyApp/settings.gradle"
// 호스트 앱 프로젝트를 포함합니다.
include(":app")                                   // 기존 콘텐츠를 가정함
setBinding(new Binding([gradle: this]))                                // new
evaluate(new File(                                                     // new
    settingsDir.parentFile,                                            // new
    'flutter_module/.android/include_flutter.groovy'                   // new
))                                                                     // new
```

바인딩 및 스크립트 평가를 통해, 
Flutter 모듈은 자체(`:flutter`로)와 모듈에서 사용하는 모든 Flutter 플러그인(예: `:package_info` 및 `:video_player`)을 
`settings.gradle`의 평가 컨텍스트에 `include`할 수 있습니다.

앱에서 Flutter 모듈에 `implementation` 종속성을 도입합니다.

```groovy title="MyApp/app/build.gradle"
dependencies {
    implementation(project(":flutter"))
}
```

{% endtab %}
{% endtabs %}

이제 앱에 Flutter 모듈이 종속성으로 포함됩니다.

[Android 앱에 Flutter 화면 추가][Adding a Flutter screen to an Android app] 가이드로 계속 진행하세요.

[`abiFilters`]: {{site.android-dev}}/reference/tools/gradle-api/4.2/com/android/build/api/dsl/Ndk#abiFilters:kotlin.collections.MutableSet
[Adding a Flutter screen to an Android app]: /add-to-app/android/add-flutter-screen
[Flutter plugin]: https://plugins.jetbrains.com/plugin/9212-flutter
[local repository]: https://docs.gradle.org/current/userguide/declaring_repositories.html#sub:maven_local
[only supports]: /resources/faq#what-devices-and-os-versions-does-flutter-run-on
[Using Flutter in China]: /community/china
