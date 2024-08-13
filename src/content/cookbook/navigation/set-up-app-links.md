---
# title: Set up app links for Android
title: Android 용 앱 링크 설정
# description: How set up universal links for an iOS application built with Flutter
description: Flutter로 구축된 iOS 애플리케이션에 대한 유니버설 링크를 설정하는 방법
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="codelabs/deeplink_cookbook"?>

딥 링크는 URI로 앱을 시작하는 메커니즘입니다. 
이 URI는 스킴(scheme), 호스트(host), 경로(path)를 포함하고, 앱을 특정 화면으로 엽니다.

:::note
Flutter DevTools가 Android용 딥 링크 검증 도구를 제공한다는 걸 알고 계셨나요? 
이 도구의 iOS 버전이 개발 중입니다. 
[딥 링크 검증][Validate deep links]에서 자세한 내용을 알아보고 데모를 확인하세요.
:::

[Validate deep links]: /tools/devtools/deep-links

_앱 링크(app link)_ 는 `http` 또는 `https`를 사용하는 딥 링크 타입이며, Android 기기에만 적용됩니다.

앱 링크를 설정하려면 웹 도메인을 소유해야 합니다. 
그렇지 않으면, [Firebase 호스팅][Firebase Hosting] 또는 [GitHub 페이지][GitHub Pages]를 
임시 솔루션으로 사용하는 것을 고려하세요.

## 1. Flutter 애플리케이션 커스터마이즈 {:#1-customize-a-flutter-application}

들어오는 URL을 처리할 수 있는 Flutter 앱을 작성하세요. 
이 예제에서는 [go_router][] 패키지를 사용하여 라우팅을 처리합니다. 
Flutter 팀은 `go_router` 패키지를 유지 관리합니다. 
이 패키지는 복잡한 라우팅 시나리오를 처리하기 위한 간단한 API를 제공합니다.

1. 새로운 애플리케이션을 만들려면 `flutter create <앱 이름>`을 입력하세요.

    ```shell
    $ flutter create deeplink_cookbook
    ```

2. 앱에 `go_router` 패키지를 포함하려면, 프로젝트에 `go_router`에 대한 종속성을 추가합니다.

   `go_router` 패키지를 종속성으로 추가하려면, `flutter pub add`를 실행합니다.

    ```console
    $ flutter pub add go_router
    ```

3. 라우팅을 처리하려면, `main.dart` 파일에 `GoRouter` 객체를 만듭니다.

    <?code-excerpt "lib/main.dart"?>
    ```dartpad title="Flutter GoRouter hands-on example in DartPad" run="true"
    import 'package:flutter/material.dart';
    import 'package:go_router/go_router.dart';
    
    void main() => runApp(MaterialApp.router(routerConfig: router));
    
    /// 여기서는 '/'와 '/details'를 처리합니다.
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => Scaffold(
            appBar: AppBar(title: const Text('Home Screen')),
          ),
          routes: [
            GoRoute(
              path: 'details',
              builder: (_, __) => Scaffold(
                appBar: AppBar(title: const Text('Details Screen')),
              ),
            ),
          ],
        ),
      ],
    );
    ```

## 2. AndroidManifest.xml 수정 {:#2-modify-androidmanifest-xml}

1. VS Code 또는 Android Studio로 Flutter 프로젝트를 엽니다.
2. `android/app/src/main/AndroidManifest.xml` 파일로 이동합니다.
3. `<activity>` 태그 안에 다음 메타데이터 태그(metadata tag)와 
   인텐트 필터(intent filter)를 `.MainActivity`로 추가합니다.

   `example.com`을 자신의 웹 도메인으로 변경하세요.

    ```xml
    <meta-data android:name="flutter_deeplinking_enabled" android:value="true" />
    <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="http" android:host="example.com" />
        <data android:scheme="https" />
    </intent-filter>
    ```
   
   :::note
   메타데이터 태그 flutter_deeplinking_enabled opts는 Flutter의 기본 딥링크 핸들러를 선택합니다. 
   [uni_links][]와 같은, 타사 플러그인을 사용하는 경우, 이 메타데이터 태그를 설정하면 이러한 플러그인이 중단됩니다. 
   타사 플러그인을 사용하려는 경우, 이 메타데이터 태그를 생략합니다.
   :::

## 3. assetlinks.json 파일 호스팅 {:#3-hosting-assetlinks-json-file}

자신이 소유한 도메인이 있는 웹 서버를 사용하여 `assetlinks.json` 파일을 호스팅합니다. 
이 파일은 모바일 브라우저에 브라우저 대신 어떤 Android 애플리케이션을 열 것인지 알려줍니다. 
파일을 만들려면, 이전 단계에서 만든 Flutter 앱의 패키지 이름과 APK를 빌드하는 데 사용할 서명 키의 sha256 지문을 가져옵니다.

### 패키지 이름 {:#package-name}

`AndroidManifest.xml`에서 패키지 이름을 찾고, 
`<manifest>` 태그 아래의 `package` 속성을 찾습니다. 
패키지 이름은 일반적으로 `com.example.*` 형식입니다.

### sha256 지문 {:#sha256-fingerprint}

apk가 어떻게 서명되었는지에 따라 프로세스가 다를 수 있습니다.

#### Google Play 앱 서명 사용 {:#using-google-play-app-signing}

sha256 지문은 Play Developer Console에서 직접 찾을 수 있습니다. 
Play Console에서, **Release> Setup > App Integrity> App Signing tab**에서 앱을 엽니다.

<img src="/assets/images/docs/cookbook/set-up-app-links-pdc-signing-key.png" alt="Screenshot of sha256 fingerprint in play developer console" width="50%" />

#### 로컬 키스토어 사용 {:#using-local-keystore}

키를 로컬에 저장하는 경우, 다음 명령을 사용하여 sha256을 생성할 수 있습니다.

```console
keytool -list -v -keystore <path-to-keystore>
```

### assetlinks.json {:#assetlinks-json}

호스팅된 파일은 다음과 유사해야 합니다.

```json
[{
  "relation": ["delegate_permission/common.handle_all_urls"],
  "target": {
    "namespace": "android_app",
    "package_name": "com.example.deeplink_cookbook",
    "sha256_cert_fingerprints":
    ["FF:2A:CF:7B:DD:CC:F1:03:3E:E8:B2:27:7C:A2:E3:3C:DE:13:DB:AC:8E:EB:3A:B9:72:A1:0E:26:8A:F5:EC:AF"]
  }
}]
```

1. `package_name` 값을 Android 애플리케이션 ID로 설정합니다.

2. sha256_cert_fingerprints를 이전 단계에서 얻은 값으로 설정합니다.

3. 다음과 유사한 URL에서 파일을 호스팅합니다.
   `<webdomain>/.well-known/assetlinks.json`

4. 브라우저가 이 파일에 액세스할 수 있는지 확인합니다.

:::note
여러 가지 플레이버가 있는 경우, 
sha256_cert_fingerprints 필드에 여러 sha256_cert_fingerprint 값을 가질 수 있습니다. 
sha256_cert_fingerprints 리스트에 추가하기만 하면 됩니다.
:::

## 테스트 {:#testing}

실제 기기나 에뮬레이터를 사용하여 앱 링크를 테스트할 수 있지만, 
먼저 기기에서 `flutter run`을 최소한 한 번 실행했는지 확인하세요. 
이렇게 하면 Flutter 애플리케이션이 설치되었는지 확인할 수 있습니다.

<img src="/assets/images/docs/cookbook/set-up-app-links-emulator-installed.png" alt="Emulator screenshot" width="50%" />

**앱 설정만** 테스트하려면, adb 명령을 사용하세요.

```console
adb shell 'am start -a android.intent.action.VIEW \
    -c android.intent.category.BROWSABLE \
    -d "http://<web-domain>/details"' \
    <package name>
```

:::note
이 명령은 웹 파일이 올바르게 호스팅되는지 여부를 테스트하지 않으며, 웹 파일이 표시되지 않더라도 앱을 실행합니다.
:::

**웹과 앱 설정을 모두** 테스트하려면, 웹 브라우저나 다른 앱을 통해 직접 링크를 클릭해야 합니다. 
한 가지 방법은 Google Doc을 만들고, 링크를 추가한 다음 탭하는 것입니다.

모든 것이 올바르게 설정되면, Flutter 애플리케이션이 시작되고 세부 정보 화면이 표시됩니다.

<img src="/assets/images/docs/cookbook/set-up-app-links-emulator-deeplinked.png" alt="Deeplinked Emulator screenshot" width="50%" />

## 부록 {:#appendix}

소스코드: [deeplink_cookbook][]

[deeplink_cookbook]: {{site.github}}/flutter/codelabs/tree/main/deeplink_cookbook
[Firebase Hosting]: {{site.firebase}}/docs/hosting
[go_router]: {{site.pub}}/packages/go_router
[GitHub Pages]: https://pages.github.com
[uni_links]: {{site.pub}}/packages/uni_links
[Signing the app]: /deployment/android#signing-the-app
