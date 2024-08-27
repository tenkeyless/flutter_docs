---
# title: Set up universal links for iOS
title: iOS 용 유니버설 링크 설정
# description: How set up universal links for an iOS application built with Flutter
description: Flutter로 구축된 iOS 애플리케이션에 대한 유니버설 링크를 설정하는 방법
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="codelabs/deeplink_cookbook"?>

딥 링크를 사용하면 앱 사용자가 URI로 앱을 시작할 수 있습니다. 
이 URI에는 스킴(scheme), 호스트(host), 경로(path)가 포함되어 있으며 앱을 특정 화면으로 엽니다.

:::note
Flutter DevTools가 Android용 딥 링크 검증 도구를 제공한다는 걸 알고 계셨나요? 
이 도구의 iOS 버전이 개발 중입니다. 
[딥 링크 검증][Validate deep links]에서 자세한 내용을 알아보고 데모를 확인하세요.
:::

[Validate deep links]: /tools/devtools/deep-links

iOS 기기에만 있는 딥 링크 타입인 _유니버설 링크(universal link)_ 는 `http` 또는 `https` 프로토콜만 사용합니다.

유니버설 링크를 설정하려면, 웹 도메인을 소유해야 합니다. 
임시 해결책으로, [Firebase 호스팅][Firebase Hosting] 또는 [GitHub 페이지][GitHub Pages]를 사용하는 것을 고려하세요.

## Flutter 앱 만들기 또는 수정하기 {:#create-or-modify-a-flutter-app}

들어오는 URL을 처리할 수 있는 Flutter 앱을 작성하세요.

이 예제에서는 [go_router][] 패키지를 사용하여 라우팅을 처리합니다. 
Flutter 팀은 `go_router` 패키지를 유지 관리합니다. 
이 패키지는 복잡한 라우팅 시나리오를 처리하기 위한 간단한 API를 제공합니다.

1. 새로운 애플리케이션을 만들려면, `flutter create <앱 이름>`을 입력합니다.

    ```shell
    $ flutter create deeplink_cookbook
    ```

2. `go_router` 패키지를 종속성으로 포함하려면, `flutter pub add`를 실행합니다.

    ```console
    $ flutter pub add go_router
    ```

3. 라우팅을 처리하려면, `main.dart` 파일에 `GoRouter` 객체를 만듭니다.

    <?code-excerpt "lib/main.dart"?>
    ```dartpad title="Flutter GoRouter hands-on example in DartPad" run="true"
    import 'package:flutter/material.dart';
    import 'package:go_router/go_router.dart';
    
    void main() => runApp(MaterialApp.router(routerConfig: router));
    
    /// This handles '/' and '/details'.
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

## iOS 빌드 설정 조정 {:#adjust-ios-build-settings}

1. Xcode를 실행합니다.

2. Flutter 프로젝트의 `ios` 폴더 안에 있는 `ios/Runner.xcworkspace` 파일을 엽니다.

### FlutterDeepLinkingEnabled 키 값 쌍 추가 {:#add-the-flutterdeeplinkingenabled-key-value-pair}

1. Xcode Navigator에서, **Runner**를 확장한 다음 **Info**를 클릭합니다.

   <img
       src="/assets/images/docs/cookbook/set-up-universal-links-info-plist.png"
       alt="Xcode info.Plist screenshot"
       width="100%" />

1. Editor에서, <kbd>Ctrl</kbd> + 클릭하고, 컨텍스트 메뉴에서 **Raw Keys and Values**를 선택합니다.

1. Editor에서, <kbd>Ctrl</kbd> + 클릭하고, 컨텍스트 메뉴에서 **Add Row**를 선택합니다.

   새 **Key**가 표시됩니다.

1. 새 키 속성을 변경하여 다음을 충족합니다.

   * **Key**를 `FlutterDeepLinkingEnabled`로 변경합니다.
   * **Type**을 `Boolean`으로 변경합니다.
   * **Value**를 `YES`로 변경합니다.

   <img
      src="/assets/images/docs/cookbook/set-up-universal-links-flutterdeeplinkingenabled.png"
      alt="flutter deeplinking enabled screenshot"
      width="100%" />

   :::note
   `FlutterDeepLinkingEnabled` 속성은 Flutter의 기본 딥링크 핸들러를 활성화합니다. 
   [uni_links][]와 같은 타사 플러그인을 사용하는 경우, 이 속성을 설정하면 타사 플러그인이 중단됩니다. 
   타사 플러그인을 사용하는 것을 선호하는 경우 이 단계를 건너뜁니다.
   :::

### 연관된 도메인 추가 {:#add-associated-domains}

:::warning
개인 개발 팀은 Associated Domains 기능을 지원하지 않습니다. 
연관된 도메인을 추가하려면, IDE 탭을 선택하세요.
:::

{% tabs %}
{% tab "Xcode" %}

1. 필요한 경우 Xcode를 실행합니다.

2. 최상위 **Runner**를 클릭합니다.

3. Editor에서, **Runner** 타겟을 클릭합니다.

4. **Signing & Capabilities**를 클릭합니다.

5. 새 도메인을 추가하려면, **Signing & Capabilities**에서 **+ Capability**를 클릭합니다.

6. **Associated Domains**를 클릭합니다.

   <img
      src="/assets/images/docs/cookbook/set-up-universal-links-associated-domains.png"
      alt="Xcode associated domains screenshot"
      width="100%" />

7. **Associated Domains** 섹션에서, **+**를 클릭합니다.

8. `applinks:<web domain>`을 입력합니다. `<web domain>`을 자신의 도메인 이름으로 바꿉니다.

   <img
      src="/assets/images/docs/cookbook/set-up-universal-links-add-associated-domains.png"
      alt="Xcode add associated domains screenshot"
      width="100%" />

{% endtab %}
{% tab "다른 에디터" %}

1. 선호하는 IDE에서 `ios/Runner/Runner.entitlements` XML 파일을 엽니다.

2. `<dict>` 태그 안에 연관된 도메인을 추가합니다.

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
     [!<key>com.apple.developer.associated-domains</key>!]
     [!<array>!]
       [!<string>applinks:example.com</string>!]
     [!</array>!]
   </dict>
   </plist>
   ```

3. `ios/Runner/Runner.entitlements` 파일을 저장합니다.

생성한 연관된 ​​도메인을 사용할 수 있는지 확인하려면, 다음 단계를 수행합니다.

1. 필요한 경우 Xcode를 시작합니다.

1. 최상위 **Runner**를 클릭합니다.

1. 편집기에서, **Runner** 대상을 클릭합니다.

1. **Signing & Capabilities**를 클릭합니다. 도메인이 **Associated Domains** 섹션에 표시되어야 합니다.

   <img
      src="/assets/images/docs/cookbook/set-up-universal-links-add-associated-domains.png"
      alt="Xcode add associated domains screenshot"
      width="100%" />

{% endtab %}
{% endtabs %}

딥 링크를 위한 애플리케이션 구성을 완료했습니다.

## 앱을 웹 도메인과 연결 {:#associate-your-app-with-your-web-domain}

웹 도메인에 `apple-app-site-association` 파일을 호스팅해야 합니다. 
이 파일은 모바일 브라우저에 브라우저 대신 어떤 iOS 애플리케이션을 열 것인지 알려줍니다. 
파일을 만들려면, 이전 섹션에서 만든 Flutter 앱의 `appID`를 찾으세요.

### `appID`의 구성 요소 위치시키기 {:#locate-components-of-the-appid}

Apple은 `appID`를 `<팀 ID>.<번들 ID>`로 포맷합니다.

* Xcode 프로젝트에서 번들 ID를 찾습니다.
* [개발자 계정][developer account]에서 팀 ID를 찾습니다.

**예:** 팀 ID가 `S8QB4VV633`이고 번들 ID가 `com.example.deeplinkCookbook`인 경우, 
`appID` 항목으로 `S8QB4VV633.com.example.deeplinkCookbook`을 입력합니다.

### `apple-app-site-association` JSON 파일 생성 및 호스팅 {:#create-and-host-apple-app-site-association-json-file}

이 파일은 JSON 형식을 사용합니다. 
이 파일을 저장할 때 `.json` 파일 확장자를 포함하지 마십시오. 
[Apple 문서][apple-app-site-assoc]에 따르면, 이 파일은 다음 내용과 유사해야 합니다.

```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appIDs": [
          "S8QB4VV633.com.example.deeplinkCookbook"
        ],
        "paths": [
          "*"
        ],
        "components": [
          {
            "/": "/*"
          }
        ]
      }
    ]
  },
  "webcredentials": {
    "apps": [
      "S8QB4VV633.com.example.deeplinkCookbook"
    ]
  }
}
```

1. `appIDs` 배열의 한 값을 `<team id>.<bundle id>`로 설정합니다.

2. `paths` 배열을 `["*"]`로 설정합니다. `paths` 배열은 허용되는 유니버설 링크를 지정합니다. 
   별표를 사용하여, `*`는 모든 경로를 Flutter 앱으로 리디렉션합니다. 
   필요한 경우, `paths` 배열 값을 앱에 더 적합한 설정으로 변경합니다.

3. 다음 구조와 유사한 URL에서 파일을 호스팅합니다.

   `<webdomain>/.well-known/apple-app-site-association`

4. 브라우저가 이 파일에 액세스할 수 있는지 확인합니다.

:::note
두 개 이상의 스키마/플레이버가 있는 경우, appIDs 필드에 두 개 이상의 appID를 추가할 수 있습니다.
:::

## 유니버설 링크 테스트 {:#test-the-universal-link}

실제 iOS 기기나 시뮬레이터를 사용하여 유니버설 링크를 테스트합니다.

:::note
Apple의 [콘텐츠 전송 네트워크](https://en.wikipedia.org/wiki/Content_delivery_network)(CDN, Content Delivery Network)가 웹 도메인에서 `apple-app-site-association`(AASA) 파일을 요청하는 데 최대 24시간이 걸릴 수 있습니다. 
CDN이 파일을 요청할 때까지, 유니버설 링크는 작동하지 않습니다. 
Apple의 CDN을 우회하려면, [대체 모드 섹션][alternate mode section]을 확인하세요.
:::

1. 테스트하기 전에, iOS 기기나 시뮬레이터에 Flutter 앱을 설치하고, 원하는 기기에서 `flutter run`을 사용하세요.

   <img
       src="/assets/images/docs/cookbook/set-up-universal-links-simulator.png"
       alt="Simulator screenshot"
       width="50%" />

   완료되면, Flutter 앱이 iOS 기기나 시뮬레이터의 홈 화면에 표시됩니다.

2. 시뮬레이터를 사용하여 테스트하는 경우, Xcode CLI를 사용하세요.

   ```console
   $ xcrun simctl openurl booted https://<web domain>/details
   ```

3. 실제 iOS 기기로 테스트하는 경우:

   1. **Note** 앱을 실행합니다.
   2. **Note** 앱에 URL을 입력합니다.
   3. 결과 링크를 클릭합니다.

   성공하면, Flutter 앱이 실행되고 세부 정보 화면이 표시됩니다.
 
   <img
      src="/assets/images/docs/cookbook/set-up-universal-links-simulator-deeplinked.png"
      alt="Deeplinked Simulator screenshot"
      width="50%" />

## 소스 코드 찾기 {:#find-the-source-code}

[deeplink_cookbook][] 레시피의 소스 코드는 GitHub 저장소에서 찾을 수 있습니다.

[apple-app-site-assoc]: {{site.apple-dev}}/documentation/xcode/supporting-associated-domains
[alternate mode section]: {{site.apple-dev}}/documentation/bundleresources/entitlements/com_apple_developer_associated-domains?language=objc
[deeplink_cookbook]: {{site.repo.organization}}/codelabs/tree/main/deeplink_cookbook
[developer account]: {{site.apple-dev}}/account
[Firebase Hosting]: {{site.firebase}}/docs/hosting
[go_router]: {{site.pub-pkg}}/go_router
[GitHub Pages]: https://pages.github.com
[uni_links]: {{site.pub-pkg}}/uni_links
