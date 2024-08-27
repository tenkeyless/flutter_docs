---
# title: Build and release an Android app
title: Android 앱 빌드 및 릴리스
# description: How to prepare for and release an Android app to the Play store.
description: Android 앱을 Play 스토어에 출시하기 위해 준비하는 방법.
short-title: Android
---

앱을 테스트하려면, 명령줄에서 `flutter run`을 사용하거나, IDE에서 **Run** 및 **Debug** 옵션을 사용할 수 있습니다.

앱의 _release_ 버전을 준비할 준비가 되면(예: [Google Play Store에 게시][play]), 이 페이지가 도움이 될 수 있습니다. 
게시하기 전에, 앱에 마무리 작업을 하는 것이 좋습니다. 
이 가이드에서는 다음 작업을 수행하는 방법을 설명합니다.

* [런처 아이콘 추가](#add-a-launcher-icon)
* [Material 컴포넌트 활성화](#enable-material-components)
* [앱 서명](#signing-the-app)
* [R8로 코드 축소](#shrink-your-code-with-r8)
* [multidex 지원 활성화](#enable-multidex-support)
* [앱 manifest 검토](#review-the-app-manifest)
* [빌드 구성 검토](#review-the-gradle-build-configuration)
* [릴리스를 위한 앱 빌드](#build-the-app-for-release)
* [Google Play 스토어에 게시](#publish-to-the-google-play-store)
* [앱 버전 번호 업데이트](#update-the-apps-version-number)
* [Android 릴리스 FAQ](#안드로이드-릴리스-faq)

:::note
이 페이지 전체에서, `[project]`는 애플리케이션이 있는 디렉토리를 나타냅니다. 
이 지침을 따르는 동안, `[project]`를 앱의 디렉토리로 바꾸세요.
:::

## 런처 아이콘 추가 {:#add-a-launcher-icon}

새로운 Flutter 앱을 만들면, 기본 런처 아이콘이 있습니다. 
이 아이콘을 커스터마이즈 하려면, [flutter_launcher_icons][] 패키지를 확인하세요.

또는, 다음 단계를 사용하여 수동으로 수행할 수 있습니다.

1. 아이콘 디자인에 대한 [Material Design 제품 아이콘][launchericons] 가이드라인을 검토합니다.

2. `[project]/android/app/src/main/res/` 디렉토리에서, 
   [configuration qualifiers][]를 사용하여 이름이 지정된 폴더에 아이콘 파일을 넣습니다. 
   기본 `mipmap-` 폴더는 올바른 명명 규칙을 보여줍니다.

3. `AndroidManifest.xml`에서, 이전 단계의 아이콘을 참조하도록 [`application`][applicationtag] 태그의 
   `android:icon` 속성을 업데이트합니다. (예: `<application android:icon="@mipmap/ic_launcher" ...`)

4. 아이콘이 대체되었는지 확인하려면, 앱을 실행하고 런처에서 앱 아이콘을 검사합니다.

## Material 컴포넌트 활성화 {:#enable-material-components}

앱에서 [플랫폼 뷰][Platform Views]를 사용하는 경우, [Android 시작 가이드][Getting Started guide for Android]에 설명된 단계에 따라, Material 구성 요소를 활성화할 수 있습니다.

예:

1. `<my-app>/android/app/build.gradle`에 Android의 Material에 대한 종속성을 추가합니다.

```kotlin
dependencies {
    // ...
    implementation("com.google.android.material:material:<version>")
    // ...
}
```

최신 버전을 알아보려면, [Google Maven][]을 방문하세요.

1. `<my-app>/android/app/src/main/res/values/styles.xml`에서 밝은 테마를 설정합니다.

   ```xml diff
   - <style name="NormalTheme" parent="@android:style/Theme.Light.NoTitleBar">
   + <style name="NormalTheme" parent="Theme.MaterialComponents.Light.NoActionBar">
   ```

1. `<my-app>/android/app/src/main/res/values-night/styles.xml`에서 다크 테마를 설정합니다.

   ```xml diff
   - <style name="NormalTheme" parent="@android:style/Theme.Black.NoTitleBar">
   + <style name="NormalTheme" parent="Theme.MaterialComponents.DayNight.NoActionBar">
   ```

<a id="signing-the-app"></a>
## 앱 서명 {:#sign-the-app}

Play 스토어에 게시하려면, 디지털 인증서(digital certificate)로 앱에 서명해야 합니다.

Android는 _upload_ 와 _app signature_ 라는 두 가지 서명 키를 사용합니다.

* 개발자는 _upload key_ 로 서명된 `.aab` 또는 `.apk` 파일을 Play 스토어에 업로드합니다.
* 최종 사용자는 _app signature key_ 로 서명된 `.apk` 파일을 다운로드합니다.

앱 서명 키를 만들려면, [공식 Play 스토어 문서][official Play Store documentation]에 설명된 대로 Play App Signing을 사용합니다.

앱에 서명하려면, 다음 지침을 따르세요.

### 업로드 키스토어 생성 {:#create-an-upload-keystore}

기존 키스토어가 있는 경우, 다음 단계로 건너뜁니다. 없는 경우, 다음 방법 중 하나를 사용하여 키스토어를 만듭니다.

1. [Android Studio 키 생성 단계]({{site.android-dev}}/studio/publish/app-signing#generate-key)를 따릅니다.
1. 명령줄에서 다음 명령을 실행합니다.

   macOS 또는 Linux에서는 다음 명령을 사용합니다.

   ```console
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA \
           -keysize 2048 -validity 10000 -alias upload
   ```

   Windows에서는 PowerShell에서 다음 명령을 사용합니다.

   ```powershell
   keytool -genkey -v -keystore $env:USERPROFILE\upload-keystore.jks `
           -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 `
           -alias upload
   ```

   이 명령은 홈 디렉토리에 `upload-keystore.jks` 파일을 저장합니다. 
   다른 곳에 저장하려면, `-keystore` 매개변수에 전달하는 인수를 변경합니다. 
   **그러나 `keystore` 파일은 비공개로 유지하세요. 공개 소스 제어에 체크인하지 마세요!**

   :::note
   * `keytool` 명령이 경로에 없을 수 있습니다. 
     * 이는 Android Studio의 일부로 설치된 Java의 일부입니다. 
     * 구체적인 경로의 경우 `flutter doctor -v`를 실행하고, 'Java binary at:' 뒤에 인쇄된 경로를 찾습니다.
     * 그런 다음, `java`(끝에 있음)를 `keytool`로 바꿔서 해당 정규화된 경로를 사용합니다. 
     * 경로에 `Program Files`와 같이 공백으로 구분된 이름이 포함된 경우, 이름에 플랫폼에 적합한 표기법을 사용합니다. 
       * 예를 들어 
         * Mac/Linux에서는 `Program\ Files`를 사용하고, 
         * Windows에서는 `"Program Files"`를 사용합니다.

   * `-storetype JKS` 태그는 Java 9 이상에서만 필요합니다. 
     * Java 9 릴리스부터, 키 저장소 타입은 기본적으로 PKS12입니다.
   :::

### 앱에서 키스토어 참조 {:#reference-the-keystore-from-the-app}

`[project]/android/key.properties`라는 이름의 파일을 만들고, 키스토어에 대한 참조를 포함합니다. 
꺾쇠괄호(`< >`)는 포함하지 마세요. 
이는 텍스트가 값의 플레이스홀더 역할을 한다는 것을 나타냅니다.

```properties
storePassword=<password-from-previous-step>
keyPassword=<password-from-previous-step>
keyAlias=upload
storeFile=<keystore-file-location>
```

`storeFile`은 macOS에서는 `/Users/<user name>/upload-keystore.jks`에 있고, 
Windows에서는 `C:\\Users\\<user name>\\upload-keystore.jks`에 있습니다.

:::warning
`key.properties` 파일을 비공개로 유지하세요. 공개 소스 제어에 체크인하지 마세요.
:::

### Gradle에서 서명 구성 {:#configure-signing-in-gradle}

릴리스 모드에서 앱을 빌드할 때, 업로드 키를 사용하도록 Gradle을 구성합니다. 
Gradle을 구성하려면, `<project>/android/app/build.gradle` 파일을 편집합니다.

1. `android` 속성 블록 앞에 키스토어 속성 파일을 정의하고 로드합니다.

1. `keystoreProperties` 객체를 설정하여, `key.properties` 파일을 로드합니다.

   ```kotlin diff title="[project]/android/app/build.gradle"
   + def keystoreProperties = new Properties()
   + def keystorePropertiesFile = rootProject.file('key.properties')
   + if (keystorePropertiesFile.exists()) {
   +     keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
   + }
   +
     android {
        ...
     }
   ```

2. `android` 속성 블록 안에 있는 `buildTypes` 속성 블록 앞에 서명 구성을 추가합니다.

   ```kotlin diff title="[project]/android/app/build.gradle"
     android {
         // ...

   +     signingConfigs {
   +         release {
   +             keyAlias = keystoreProperties['keyAlias']
   +             keyPassword = keystoreProperties['keyPassword']
   +             storeFile = keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
   +             storePassword = keystoreProperties['storePassword']
   +         }
   +     }
         buildTypes {
             release {
                 // TODO: 릴리스 빌드에 대한 자체 서명 구성을 추가합니다. 
                 // 지금은 디버그 키로 서명하므로, `flutter run --release`가 작동합니다.
   -             signingConfig = signingConfigs.debug
   +             signingConfig = signingConfigs.release
             }
         }
     ...
     }
   ```

이제 Flutter가 모든 릴리스 빌드에 서명합니다.

:::note
Gradle 파일을 변경한 후 `flutter clean`을 실행해야 할 수도 있습니다.
이렇게 하면 캐시된 빌드가 서명 프로세스에 영향을 미치지 않습니다.
:::

앱 서명에 대한 자세한 내용은, developer.android.com의 [앱 서명][Sign your app]을 확인하세요.

## R8로 코드 축소 {:#shrink-your-code-with-r8}

[R8][]은 Google의 새로운 코드 축소기입니다. 
릴리스 APK 또는 AAB를 빌드할 때 기본적으로 활성화됩니다. 
R8을 비활성화하려면, `--no-shrink` 플래그를 
`flutter build apk` 또는 `flutter build appbundle`에 전달합니다.

:::note
난독화(Obfuscation)와 축소(minification)는 Android 애플리케이션의 컴파일 시간을 상당히 늘릴 수 있습니다.

`--[no-]shrink` 플래그는 효과가 없습니다. 코드 축소는 릴리스 빌드에서 항상 활성화됩니다.
자세한 내용은 [앱 축소, 난독화 및 최적화]({{site.android-dev}}/studio/build/shrink-code)를 확인하세요.
:::

## multidex 지원 활성화 {:#enable-multidex-support}

대규모 앱을 작성하거나 대규모 플러그인을 사용할 때, 최소 API 20 이하를 타겟팅할 때, 
Android의 dex 제한인 64k 메서드에 직면할 수 있습니다. 
이는 축소가 활성화되지 않은 `flutter run`을 사용하여, 앱의 디버그 버전을 실행할 때도 발생할 수 있습니다.

Flutter 도구는 multidex를 쉽게 활성화할 수 있도록 지원합니다. 
가장 간단한 방법은 메시지가 표시될 때 multidex 지원을 옵트인하는 것입니다. 
이 도구는 multidex 빌드 오류를 감지하고, Android 프로젝트를 변경하기 전에 묻습니다. 
옵트인하면, Flutter가 `androidx.multidex:multidex`에 자동으로 의존하고, 
생성된 `FlutterMultiDexApplication`을 프로젝트의 애플리케이션으로 사용할 수 있습니다.

IDE에서 **Run** 및 **Debug** 옵션으로 앱을 빌드하고 실행하려고 하면, 
다음 메시지와 함께 빌드가 실패할 수 있습니다.

<img src='/assets/images/docs/deployment/android/ide-build-failure-multidex.png' width="100%" alt='Build failure because Multidex support is required'>

명령줄에서 multidex를 활성화하려면, 
`flutter run --debug`를 실행하고 Android 기기를 선택하세요.

<img src='/assets/images/docs/deployment/android/cli-select-device.png' width="100%" alt='Selecting an Android device with the flutter CLI.'>

메시지가 표시되면, `y`를 입력합니다. 
Flutter 도구는 multidex 지원을 활성화하고 빌드를 다시 시도합니다.

<img src='/assets/images/docs/deployment/android/cli-multidex-added-build.png' width="100%" alt='The output of a successful build after adding multidex.'>

:::note
Multidex 지원은 Android SDK 21 이상을 타겟팅할 때 기본적으로 포함됩니다. 
그러나, multidex 문제를 해결하기 위해 API 21 이상을 타겟팅하는 것은 권장하지 않습니다. 
이는 이전 기기를 사용하는 사용자를 실수로 제외할 수 있기 때문입니다.
:::

Android 가이드를 따르고 프로젝트의 Android 디렉토리 구성을 수정하여, 
multidex를 수동으로 지원하도록 선택할 수도 있습니다. 
[multidex keep file][multidex-keep]에는 다음을 포함하도록 지정해야 합니다.

```plaintext
io/flutter/embedding/engine/loader/FlutterLoader.class
io/flutter/util/PathUtils.class
```

또한, 앱 시작에 사용되는 다른 클래스를 포함합니다. 
multidex 지원을 수동으로 추가하는 것에 대한 자세한 지침은, 공식 [Android 문서][multidex-docs]를 확인하세요.

## 앱 manifest 검토 {:#review-the-app-manifest}

기본 [앱 매니페스트][manifest] 파일을 검토합니다.

```xml title="[project]/android/app/src/main/AndroidManifest.xml"
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        [!android:label="[project]"!]
        ...
    </application>
    ...
    [!<uses-permission android:name="android.permission.INTERNET"/>!]
</manifest>
```

다음 값을 확인하세요.

| 태그                                | 속성 | 값                                                                                                   |
|------------------------------------|-----------|-----------------------------------------------------------------------------------------------------------|
| [`application`][applicationtag]    | [`application`][applicationtag] 태그에서 `android:label`을 편집하여 앱의 최종 이름을 반영합니다. |
| [`uses-permission`][permissiontag] | 앱에 인터넷 액세스가 필요한 경우, `android.permission.INTERNET` [permission][permissiontag] 값을 `android:name` 속성에 추가합니다. 표준 템플릿에는 이 태그가 포함되지 않지만, 개발 중에 인터넷 액세스를 허용하여, Flutter 도구와 실행 중인 앱 간의 통신을 가능하게 합니다. |

{:.table .table-striped}

## Gradle 빌드 구성을 검토하거나 변경 {:#review-the-gradle-build-configuration}

Android 빌드 구성을 확인하려면, 기본 [Gradle 빌드 스크립트][gradlebuild]에서 `android` 블록을 검토하세요. 
기본 Gradle 빌드 스크립트는 `[project]/android/app/build.gradle`에서 찾을 수 있습니다. 
이러한 속성의 값을 변경할 수 있습니다.

```kotlin title="[project]/android/app/build.gradle"
android {
    namespace = "com.example.[project]"
    // "flutter."로 시작하는 모든 값은 Flutter Gradle 플러그인에서 값을 가져옵니다.
    // 이러한 기본값을 변경하려면, 이 파일에서 변경하세요.
    [!compileSdk = flutter.compileSdkVersion!]
    ndkVersion = flutter.ndkVersion

    ...

    defaultConfig {
        // TODO: unique 애플리케이션 ID를 지정하세요 (https://developer.android.com/studio/build/application-id.html).
        [!applicationId = "com.example.[project]"!]
        // 당신의 애플리케이션 요구 사항에 맞게 다음 값을 업데이트할 수 있습니다.
        [!minSdk = flutter.minSdkVersion!]
        [!targetSdk = flutter.targetSdkVersion!]
        // 이 두 속성은 이 파일의 다른 곳에서 정의된 값을 사용합니다.
        // 속성 선언에서 이러한 값을 설정하거나 변수를 사용할 수 있습니다.
        [!versionCode = flutterVersionCode.toInteger()!]
        [!versionName = flutterVersionName!]
    }

    buildTypes {
        ...
    }
}
```

### build.gradle에서 조정할 속성 {:#properties-to-adjust-in-build-gradle}

| 속성             | 목적                                                                                                                                                                                                                                                     | 디폴트 값              |
|----------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------|
| `compileSdk`         | 앱이 컴파일되는 Android API 레벨입니다. 이는 사용 가능한 가장 높은 버전이어야 합니다. 이 속성을 `31`로 설정하면, 앱이 `31`에 특정한 API를 사용하지 않는 한, API `30` 또는 이전 버전을 실행하는 기기에서 앱을 실행합니다. | |
| `defaultConfig`      |  |  |
| `.applicationId`     | 앱을 식별하는 final, unique [애플리케이션 ID][application ID]입니다. |                            |
| `.minSdk`            | The [minimum Android API level][] for which you designed your app to run.                                                                                                                                                                                   | `flutter.minSdkVersion`    |
| `.targetSdk`         | 앱 실행을 테스트한 Android API 레벨입니다. 앱은 이 레벨까지의 모든 Android API 레벨에서 실행되어야 합니다.  | `flutter.targetSdkVersion` |
| `.versionCode`       | [내부 버전 번호][internal version number]를 설정하는 양의 정수입니다. 이 숫자는 어느 버전이 다른 버전보다 최신인지만 판별합니다. 숫자가 클수록 최신 버전을 나타냅니다. 앱 사용자는 이 값을 절대 볼 수 없습니다.   |                            |
| `.versionName`       | 앱이 버전 번호로 표시하는 문자열입니다. 이 속성을 raw 문자열 또는 문자열 리소스에 대한 참조로 설정합니다.     |                            |
| `.buildToolsVersion` | Gradle 플러그인은 프로젝트에서 사용하는 Android 빌드 도구의 기본 버전을 지정합니다. 빌드 도구의 다른 버전을 지정하려면 이 값을 변경합니다.       |

{:.table .table-striped}

Gradle에 대해 자세히 알아보려면, [Gradle 빌드 파일][gradlebuild]의 모듈 레벨 빌드 섹션을 확인하세요.

:::note
최신 버전의 Android SDK를 사용하는 경우, 
`compileSdkVersion`, `minSdkVersion` 또는 `targetSdkVersion`에 대한 사용 중단 경고가 표시될 수 있습니다. 
이러한 속성의 이름을 각각 `compileSdk`, `minSdk` 및 `targetSdk`로 바꿀 수 있습니다.
:::
  
## 릴리스를 위한 앱 빌드 {:#build-the-app-for-release}

Play Store에 게시할 때 두 가지 가능한 릴리스 형식이 있습니다.

* App bundle (권장)
* APK

:::note
Google Play Store는 앱 번들 형식을 선호합니다. 
자세한 내용은 [Android 앱 번들에 관하여][bundle]를 확인하세요.
:::

### 앱 번들 빌드 {:#build-an-app-bundle}

이 섹션에서는 릴리스 앱 번들을 빌드하는 방법을 설명합니다. 
서명 단계를 완료했다면, 앱 번들이 서명됩니다. 
이 시점에서 리버스 엔지니어링을 더 어렵게 만들기 위해, [Dart 코드 난독화][obfuscating your Dart code]를 고려할 수 있습니다. 
코드 난독화에는 빌드 명령에 몇 가지 플래그를 추가하고, 스택 추적의 난독화를 해제하기 위한 추가 파일을 유지하는 것이 포함됩니다.

명령줄에서:

1. `cd [project]`를 입력합니다.<br>
2. `flutter build appbundle`를 실행합니다.<br> 
   (`flutter build`를 실행하면, 기본적으로 릴리스 빌드가 됩니다.)

앱의 릴리스 번들은 `[project]/build/app/outputs/bundle/release/app.aab`에 생성됩니다.

기본적으로, 앱 번들에는 [armeabi-v7a][] (ARM 32비트), [arm64-v8a][] (ARM 64비트), 
[x86-64][] (x86 64비트)용으로 컴파일된 Dart 코드와 Flutter 런타임이 포함되어 있습니다.

### 앱 번들 테스트 {:#test-the-app-bundle}

앱 번들은 여러 가지 방법으로 테스트할 수 있습니다. 이 섹션에서는 두 가지를 설명합니다.

#### (1) 번들 도구를 사용하여 오프라인으로 {:#offline-using-the-bundle-tool}

1. 아직 다운로드하지 않았다면, [GitHub 저장소][GitHub repository]에서 `bundletool`을 다운로드하세요.
1. 앱 번들에서 [APK 세트 생성][apk-set]
1. 연결된 기기에 [APK 배포][apk-deploy]

#### (2) Google Play를 사용하여 온라인으로 {:#online-using-google-play}

1. 번들을 Google Play에 업로드하여 테스트합니다. 
   프로덕션에서 출시하기 전에, 내부 테스트 트랙이나 알파 또는 베타 채널을 사용하여, 번들을 테스트할 수 있습니다.
2. Play 스토어에 [번들을 업로드하는 단계][upload-bundle]를 따르세요.

### APK 빌드 {:#build-an-apk}

APK보다 앱 번들이 선호되지만, 아직 앱 번들을 지원하지 않는 스토어가 있습니다. 
이 경우, 각 대상 ABI(Application Binary Interface)에 대한 릴리스 APK를 빌드합니다.

서명 단계를 완료했다면 APK가 서명됩니다. 
이 시점에서, 리버스 엔지니어링을 어렵게 만들기 위해 [Dart 코드 난독화][obfuscating your Dart code]를 고려할 수 있습니다. 
코드 난독화에는 빌드 명령에 몇 가지 플래그를 추가하는 것이 포함됩니다.

명령줄에서:

1. `cd [project]`를 입력합니다.

2. `flutter build apk --split-per-abi`를 실행합니다. 
   (`flutter build` 명령은 기본적으로 `--release`로 설정됩니다.)

이 명령은 세 개의 APK 파일을 생성합니다.

* `[project]/build/app/outputs/apk/release/app-armeabi-v7a-release.apk`
* `[project]/build/app/outputs/apk/release/app-arm64-v8a-release.apk`
* `[project]/build/app/outputs/apk/release/app-x86_64-release.apk`

`--split-per-abi` 플래그를 제거하면, _모든_ 대상 ABI에 대해 컴파일된 코드가 포함된 fat APK가 생성됩니다. 
이러한 APK는 분할된 APK보다 크기가 더 크기 때문에, 
사용자는 기기 아키텍처에 적용되지 않는 네이티브 바이너리를 다운로드하게 됩니다.

### 장치에 APK 설치 {:#install-an-apk-on-a-device}

연결된 Android 기기에 APK를 설치하려면 다음 단계를 따르세요.

명령줄에서:

1. USB 케이블로 Android 기기를 컴퓨터에 연결합니다.
2. `cd [project]`를 입력합니다.
3. `flutter install`을 실행합니다.

## Google Play 스토어에 게시 {:#publish-to-the-google-play-store}

Google Play 스토어에 앱을 게시하는 방법에 대한 자세한 지침은, 
[Google Play 출시][play] 문서를 확인하세요.

## 앱 버전 번호 업데이트 {:#update-the-apps-version-number}

앱의 기본 버전 번호는 `1.0.0`입니다. 
이를 업데이트하려면, `pubspec.yaml` 파일로 이동하여 다음 줄을 업데이트하세요.

`version: 1.0.0+1`

버전 번호는 위의 예에서 `1.0.0`과 같이 점으로 구분된 세 개의 숫자이며, 
그 뒤에 `1`과 같이 선택적 빌드 번호가 `+`로 구분되어 있습니다.

버전과 빌드 번호는 모두 `--build-name`과 `--build-number`를 각각 지정하여, 
Flutter 빌드에서 재정의할 수 있습니다.

Android에서, 
`build-name`은 `versionName`으로 사용되고, 
`build-number`는 `versionCode`로 사용됩니다. 
자세한 내용은 Android 설명서의 [앱 버전 지정][Version your app]을 확인하세요.

Android용 앱을 다시 빌드할 때, 
pubspec 파일의 버전 번호가 업데이트되면, 
`local.properties` 파일의 `versionName`과 `versionCode`가 업데이트됩니다.

## Android 릴리스 FAQ {:#android-release-faq}

Android 앱 배포와 관련하여 자주 묻는 질문은 다음과 같습니다.

### 언제 앱 번들과 APK를 빌드해야 하나요? {:#when-should-i-build-app-bundles-versus-apks}

Google Play Store는 사용자에게 앱을 보다 효율적으로 제공할 수 있기 때문에, 
APK 대신 앱 번들을 배포할 것을 권장합니다. 
그러나 Play Store가 아닌 다른 방법으로 앱을 배포하는 경우, APK가 유일한 옵션일 수 있습니다.

### Fat APK란 무엇인가요? {:#what-is-a-fat-apk}

[fat APK][]는 여러 ABI에 대한 바이너리가 포함된 단일 APK입니다. 
이는 단일 APK가 여러 아키텍처에서 실행되어 더 광범위한 호환성을 제공한다는 이점이 있지만, 
파일 크기가 훨씬 더 커서 사용자가 애플리케이션을 설치할 때 더 많은 바이트를 다운로드하고 저장해야 한다는 단점이 있습니다. 
앱 번들 대신 APK를 빌드할 때는 `--split-per-abi` 플래그를 사용하여, 
[APK 빌드](#build-an-apk)에 설명된 대로 분할 APK를 빌드하는 것이 좋습니다.

### 지원되는 대상 아키텍처는 무엇입니까? {:#what-are-the-supported-target-architectures}

릴리스 모드에서 애플리케이션을 빌드할 때, 
Flutter 앱은 [armeabi-v7a][] (ARM 32비트), [arm64-v8a][] (ARM 64비트), 
[x86-64][] (x86 64비트)로 컴파일될 수 있습니다.

### `flutter build appbundle`로 생성된 앱 번들에 어떻게 서명하나요? {:#how-do-i-sign-the-app-bundle-created-by-flutter-build-appbundle}

[앱 서명](#signing-the-app)을 참조하세요.

### Android Studio에서 릴리스를 빌드하려면 어떻게 해야 하나요? {:#how-do-i-build-a-release-from-within-android-studio}

Android Studio에서, 앱 폴더 아래에 있는 기존 `android/` 폴더를 엽니다. 
그런 다음, 프로젝트 패널에서 **build.gradle (Module: app)**을 선택합니다.

<img src='/assets/images/docs/deployment/android/gradle-script-menu.png' width="100%" alt='The Gradle build script menu in Android Studio.'>

다음으로, 빌드 변형(build variant)을 선택합니다. 
메인 메뉴에서 **Build > Select Build Variant**을 클릭합니다. 
**Build Variants** 패널에서 변형을 선택합니다. (debug가 기본값입니다)

<img src='/assets/images/docs/deployment/android/build-variant-menu.png' width="100%" alt='The build variant menu in Android Studio with Release selected.'>

결과 앱 번들 또는 APK 파일은 앱 내의 `build/app/outputs`에 있습니다.

{% comment %}
### 앱에 추가 시(add-to-app) 특별히 고려해야 할 사항이 있나요?
{% endcomment %}

[apk-deploy]: {{site.android-dev}}/studio/command-line/bundletool#deploy_with_bundletool
[apk-set]: {{site.android-dev}}/studio/command-line/bundletool#generate_apks
[application ID]: {{site.android-dev}}/studio/build/application-id
[applicationtag]: {{site.android-dev}}/guide/topics/manifest/application-element
[arm64-v8a]: {{site.android-dev}}/ndk/guides/abis#arm64-v8a
[armeabi-v7a]: {{site.android-dev}}/ndk/guides/abis#v7a
[bundle]: {{site.android-dev}}/guide/app-bundle
[configuration qualifiers]: {{site.android-dev}}/guide/topics/resources/providing-resources#AlternativeResources
[fat APK]: https://en.wikipedia.org/wiki/Fat_binary
[flutter_launcher_icons]: {{site.pub}}/packages/flutter_launcher_icons
[Getting Started guide for Android]: {{site.material}}/develop/android/mdc-android
[GitHub repository]: {{site.github}}/google/bundletool/releases/latest
[Google Maven]: https://maven.google.com/web/index.html#com.google.android.material:material
[gradlebuild]: {{site.android-dev}}/studio/build/#module-level
[internal version number]: {{site.android-dev}}/studio/publish/versioning
[launchericons]: {{site.material}}/styles/icons
[manifest]: {{site.android-dev}}/guide/topics/manifest/manifest-intro
[minimum Android API level]: {{site.android-dev}}/studio/publish/versioning#minsdk
[multidex-docs]: {{site.android-dev}}/studio/build/multidex
[multidex-keep]: {{site.android-dev}}/studio/build/multidex#keep
[obfuscating your Dart code]: /deployment/obfuscate
[official Play Store documentation]: https://support.google.com/googleplay/android-developer/answer/7384423?hl=en
[permissiontag]: {{site.android-dev}}/guide/topics/manifest/uses-permission-element
[Platform Views]: /platform-integration/android/platform-views
[play]: {{site.android-dev}}/distribute
[R8]: {{site.android-dev}}/studio/build/shrink-code
[Sign your app]: {{site.android-dev}}/studio/publish/app-signing.html#generate-key
[upload-bundle]: {{site.android-dev}}/studio/publish/upload-bundle
[Version your app]: {{site.android-dev}}/studio/publish/versioning
[x86-64]: {{site.android-dev}}/ndk/guides/abis#86-64
