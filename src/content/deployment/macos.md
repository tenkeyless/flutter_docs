---
# title: Build and release a macOS app
title: macOS 앱 빌드 및 릴리스
# description: How to release a Flutter app to the macOS App Store.
description: macOS 앱 스토어에 Flutter 앱을 출시하는 방법.
short-title: macOS
---

이 가이드에서는 Flutter 앱을 [App Store][appstore]에 출시하는 단계별 과정을 설명합니다.

## 예비 사항 {:#preliminaries}

앱 출시 프로세스를 시작하기 전에, 해당 앱이 Apple의 [앱 리뷰 가이드라인][appreview]을 충족하는지 확인하세요.

앱을 App Store에 게시하려면, 먼저 [Apple Developer Program][devprogram]에 등록해야 합니다. 
Apple의 [멤버십 선택][devprogram_membership] 가이드에서 다양한 멤버십 옵션에 대해 자세히 알아볼 수 있습니다.

## App Store Connect에 앱 등록 {:#register-your-app-on-app-store-connect}

[App Store Connect][appstoreconnect_login](이전 iTunes Connect)에서 앱의 수명 주기를 관리하세요. 
앱 이름과 설명을 정의하고, 스크린샷을 추가하고, 가격을 설정하고, App Store와 TestFlight에 대한 릴리스를 관리하세요.

앱을 등록하려면 두 단계가 필요합니다. 
(1) unique 번들 ID를 등록하고, (2) App Store Connect에서 애플리케이션 레코드를 만드는 것입니다.

App Store Connect에 대한 자세한 개요는 [App Store Connect][appstoreconnect_guide] 가이드를 참조하세요.

### (1) 번들 ID 등록 {:#register-a-bundle-id}

모든 macOS 애플리케이션은 Apple에 등록된 unique 식별자인 번들 ID와 연관됩니다. 
앱의 번들 ID를 등록하려면, 다음 단계를 따르세요.

1. 개발자 계정의 [앱 ID][devportal_appids] 페이지를 엽니다.
2. **+**를 클릭하여 새 번들 ID를 만듭니다.
3. 앱 이름을 입력하고, **Explicit App ID**를 선택한 다음 ID를 입력합니다.
4. 앱에서 사용하는 서비스를 선택한 다음, **Continue**을 클릭합니다.
5. 다음 페이지에서, 세부 정보를 확인하고 **Register**을 클릭하여 번들 ID를 등록합니다.

### (2) App Store Connect에서 애플리케이션 레코드 만들기 {:#create-an-application-record-on-app-store-connect}

App Store Connect에 앱을 등록하세요.

1. 브라우저에서 [App Store Connect][appstoreconnect_login]을 엽니다.
1. App Store Connect 랜딩 페이지에서 **My Apps**을 클릭합니다.
1. My Apps 페이지의 왼쪽 상단 모서리에 있는 **+**를 클릭한 다음, **New App**을 선택합니다.
1. 나타나는 양식에 앱 세부 정보를 입력합니다. 
   플랫폼 섹션에서, macOS가 선택되어 있는지 확인합니다. 
   Flutter는 현재 tvOS를 지원하지 않으므로, 해당 확인란을 선택하지 않습니다. **Create**를 클릭합니다.
2. 앱의 애플리케이션 세부 정보로 이동하여, 사이드바에서 **App Information**를 선택합니다.
3. General Information 섹션에서 이전 단계에서 등록한 번들 ID를 선택합니다.

자세한 개요는 [계정에 앱 추가][appstoreconnect_guide_register]를 참조하세요.

## Xcode 프로젝트 설정 검토 {:#review-xcode-project-settings}

이 단계에서는 Xcode workspace에서 가장 중요한 설정을 검토하는 것을 다룹니다. 
자세한 절차와 설명은 [앱 배포 준비][distributionguide_config]를 참조하세요.

Xcode에서 target의 설정으로 이동합니다.

1. Xcode에서 앱의 `macos` 폴더에서 `Runner.xcworkspace`를 엽니다.
2. 앱 설정을 보려면 Xcode 프로젝트 탐색기에서 **Runner** 프로젝트를 선택합니다. 그런 다음 메인 뷰 사이드바에서 **Runner** 대상을 선택합니다.
3. **General** 탭을 선택합니다.

가장 중요한 설정을 확인합니다.

**Identity** 섹션에서:

`App Category`
: 앱이 Mac App Store에 등록될 앱 카테고리입니다. none일 수 없습니다.

`Bundle Identifier` 
: App Store Connect에 등록한 앱 ID입니다.

**Deployment info** 섹션에서:

`Deployment Target`
: 앱이 지원하는 최소 macOS 버전입니다. 
  Flutter는 macOS {{site.targetmin.macos}} 이상에 앱 배포를 지원합니다.

**Signing & Capabilities** 섹션에서:

`Automatically manage signing`
: Xcode가 앱 서명 및 프로비저닝(signing and provisioning)을 자동으로 관리해야 하는지 여부. 
  이는 기본적으로 `true`로 설정되어 있으며, 대부분 앱에 충분해야 합니다. 
  더 복잡한 시나리오의 경우, [코드 서명 가이드][codesigning_guide]를 참조하세요.

`Team`
: 등록된 Apple Developer 계정과 관련된 팀을 선택하세요. 
  필요한 경우 **Add Account...**를 선택한 다음 이 설정을 업데이트하세요.

프로젝트 설정의 **General** 탭은 다음과 유사해야 합니다.

![Xcode Project Settings](/assets/images/docs/releaseguide/macos_xcode_settings.png){:width="100%"}

앱 서명에 대한 자세한 개요는 [서명 인증서(signing certificates) 만들기, 내보내기 및 삭제][appsigning]를 참조하세요.

## 앱 이름, 번들 식별자 및 저작권 구성 {:#configuring-the-apps-name-bundle-identifier-and-copyright}

제품 식별자에 대한 구성은 `macos/Runner/Configs/AppInfo.xcconfig`에 중앙 집중화되어 있습니다. 
앱의 이름에 대해 `PRODUCT_NAME`을 설정하고, 
저작권에 대해 `PRODUCT_COPYRIGHT`를 설정하고, 
마지막으로 앱의 번들 식별자에 대해 `PRODUCT_BUNDLE_IDENTIFIER`를 설정합니다.

## 앱 버전 번호 업데이트 {:#updating-the-apps-version-number}

앱의 기본 버전 번호는 `1.0.0`입니다. 이를 업데이트하려면, `pubspec.yaml` 파일로 이동하여 다음 줄을 업데이트하세요.

`version: 1.0.0+1`

버전 번호는 위의 예에서 `1.0.0`과 같이 점으로 구분된 세 개의 숫자이며, 
그 뒤에 `1`과 같이 위의 예에서와 같이 선택적 빌드 번호가 `+`로 구분되어 있습니다.

버전과 빌드 번호는 모두 `--build-name`과 `--build-number`를 각각 지정하여, 
Flutter 빌드에서 재정의할 수 있습니다.

macOS에서 `build-name`은 `CFBundleShortVersionString`을 사용하는 반면, 
`build-number`는 `CFBundleVersion`을 사용합니다. 
Apple Developer 사이트의 [Core Foundation Keys][]에서 iOS 버전 관리에 대해 자세히 알아보세요.

## 앱 아이콘 추가 {:#add-an-app-icon}

새로운 Flutter 앱이 생성되면, 플레이스홀더 아이콘 세트가 생성됩니다. 
이 단계에서는 이러한 플레이스홀더 아이콘을 앱 아이콘으로 바꾸는 것을 다룹니다.

1. [macOS 앱 아이콘][appicon] 가이드라인을 검토합니다.
2. Xcode 프로젝트 탐색기에서 `Runner` 폴더에서 `Assets.xcassets`를 선택합니다. 
   플레이스홀더 아이콘을 사용자 앱 아이콘으로 업데이트합니다.
3. `flutter run -d macos`를 사용하여 앱을 실행하여 아이콘이 바뀌었는지 확인합니다.

## Xcode로 빌드 아카이브 만들기 {:#create-a-build-archive-with-xcode}

이 단계에서는 빌드 아카이브를 만들고, Xcode를 사용하여 App Store Connect에 빌드를 업로드하는 방법을 다룹니다.

개발하는 동안 _debug_ 빌드로 빌드, 디버깅 및 테스트를 수행했습니다. 
App Store 또는 TestFlight에서 사용자에게 앱을 제공할 준비가 되면 _release_ 빌드를 준비해야 합니다. 
이 시점에서 리버스 엔지니어링을 어렵게 만들기 위해, [Dart 코드 난독화][obfuscating your Dart code]를 고려할 수 있습니다. 
코드 난독화에는 빌드 명령에 몇 가지 플래그를 추가하는 것이 포함됩니다.

Xcode에서, 앱 버전을 구성하고 빌드합니다.

1. 앱의 `macos` 폴더에서 `Runner.xcworkspace`를 엽니다. 
   명령줄에서 이 작업을 수행하려면, 애플리케이션 프로젝트의 베이스 디렉토리에서 다음 명령을 실행합니다.
   ```console
   open macos/Runner.xcworkspace
   ```
2. Xcode 프로젝트 탐색기에서 **Runner**를 선택한 다음, 설정 보기 사이드바에서 **Runner** 대상을 선택합니다.
3. Identity 섹션에서, **Version**을 게시하려는 사용자 대상(user-facing) 버전 번호로 업데이트합니다.
4. Identity 섹션에서, **Build** 식별자를 App Store Connect에서 이 빌드를 추적하는 데 사용되는 고유한 빌드 번호로 업데이트합니다. 
   각 업로드에는 고유한 빌드 번호가 필요합니다.

마지막으로, 빌드 아카이브를 만들어 App Store Connect에 업로드합니다.

1. 애플리케이션의 릴리스 아카이브를 만듭니다. 애플리케이션 프로젝트의 베이스 디렉토리에서 다음을 실행합니다.
   ```console
   flutter build macos
   ```
2. Xcode를 열고 **Product > Archive**을 선택하여 이전 단계에서 만든 아카이브를 엽니다.
3. **Validate App** 버튼을 클릭합니다. 
   문제가 보고되면 해결하고 다른 빌드를 생성합니다. 
   보관함을 업로드할 때까지 동일한 빌드 ID를 재사용할 수 있습니다.
4. 보관함이 성공적으로 검증되면 **Distribute App**를 클릭합니다. 
   [App Store Connect][appstoreconnect_login]에서, 
   앱의 세부 정보 페이지의 활동 탭에서 빌드 상태를 확인할 수 있습니다.

빌드가 검증되었으며 TestFlight에서 테스터에게 릴리스할 수 있다는 알림 이메일을 30분 이내에 받게 됩니다. 
이 시점에서 TestFlight에서 릴리스할지 또는 App Store에 앱을 릴리스할지 선택할 수 있습니다.

자세한 내용은 [App Store Connect에 앱 업로드][distributionguide_upload]를 참조하세요.

## Codemagic CLI 도구로 빌드 아카이브 만들기 {:#create-a-build-archive-with-codemagic-cli-tools}

이 단계에서는 빌드 아카이브를 만들고, 
Flutter 빌드 명령과 [Codemagic CLI 도구][codemagic_cli_tools]를 사용하여, 
빌드를 App Store Connect에 업로드하는 것을 다룹니다. 
Flutter 프로젝트 디렉토리의 터미널에서 실행됩니다.

<ol>
<li>

Codemagic CLI 도구를 설치하세요:

```bash
pip3 install codemagic-cli-tools
```

</li>
<li>

App Store Connect에서 작업을 자동화하려면, 
App Manager 액세스 권한이 있는 [App Store Connect API 키][appstoreconnect_api_key]를 생성해야 합니다. 
후속 명령을 더 간결하게 만들려면, 새 키에서 다음 환경 변수를 설정하세요. issuer id, key id, 및 API 키 파일.

```bash
export APP_STORE_CONNECT_ISSUER_ID=aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee
export APP_STORE_CONNECT_KEY_IDENTIFIER=ABC1234567
export APP_STORE_CONNECT_PRIVATE_KEY=`cat /path/to/api/key/AuthKey_XXXYYYZZZ.p8`
```

</li>
<li>

코드 서명을 수행하고 빌드 아카이브를 패키징하려면, Mac App Distribution 및 Mac Installer Distribution 인증서를 내보내거나 만들어야 합니다.

기존 [certificates][devportal_certificates]가 있는 경우, 
각 인증서에 대해 다음 명령을 실행하여 private 키를 내보낼 수 있습니다.

```bash
openssl pkcs12 -in <certificate_name>.p12 -nodes -nocerts | openssl rsa -out cert_key
```

또는 다음 명령을 실행하여 새로운 private 키를 생성할 수 있습니다.

```bash
ssh-keygen -t rsa -b 2048 -m PEM -f cert_key -q -N ""
```

나중에, CLI 도구가 자동으로 새 Mac 앱 배포 및
Mac 설치 프로그램 배포 인증서를 만들 수 있습니다. 
각 새 인증서에 대해 동일한 private 키를 사용할 수 있습니다.

</li>
<li>

App Store Connect에서 코드 서명 파일을 가져옵니다.

```bash
app-store-connect fetch-signing-files YOUR.APP.BUNDLE_ID \
    --platform MAC_OS \
    --type MAC_APP_STORE \
    --certificate-key=@file:/path/to/cert_key \
    --create
```

여기서 `cert_key`는 내보낸 Mac App Distribution 인증서 private 키이거나, 
자동으로 새 인증서를 생성하는 새 private 키입니다.

</li>
<li>

Mac Installer Distribution 인증서가 없는 경우, 
다음을 실행하여 새 인증서를 만들 수 있습니다.

```bash
app-store-connect certificates create \
    --type MAC_INSTALLER_DISTRIBUTION \
    --certificate-key=@file:/path/to/cert_key \
    --save
```

이전에 생성한 private 키의 `cert_key`를 사용하세요.

</li>
<li>

Mac Installer Distribution 인증서를 가져옵니다.

```bash
app-store-connect certificates list \
    --type MAC_INSTALLER_DISTRIBUTION \
    --certificate-key=@file:/path/to/cert_key \
    --save
```

</li>
<li>

코드 서명에 사용할 새 임시 키체인을 설정하세요.

```bash
keychain initialize
```

:::note 로그인 키체인 복원!
`keychain initialise`를 실행한 후 **반드시** 다음을 실행해야 합니다:<br>

`keychain use-login`

이렇게 하면 로그인 키체인이 기본값으로 설정되어, 컴퓨터의 앱에서 잠재적인 인증 문제가 발생하지 않습니다.
:::

</li>
<li>

이제 가져온 인증서를 키체인에 추가하세요.

```bash
keychain add-certificates
```

</li>
<li>

가져온 코드 서명 프로필을 사용하도록 Xcode 프로젝트 설정을 업데이트합니다.

```bash
xcode-project use-profiles
```

</li>

<li>

Flutter 종속성 설치:

```bash
flutter packages pub get
```

</li>
<li>

CocoaPods 종속성 설치:

```bash
find . -name "Podfile" -execdir pod install \;
```

</li>
<li>

Flutter macOS 프로젝트를 빌드하세요.

```bash
flutter build macos --release
```

</li>
<li>

앱을 패키징합니다:

```bash
APP_NAME=$(find $(pwd) -name "*.app")
PACKAGE_NAME=$(basename "$APP_NAME" .app).pkg
xcrun productbuild --component "$APP_NAME" /Applications/ unsigned.pkg

INSTALLER_CERT_NAME=$(keychain list-certificates \
          | jq '[.[]
            | select(.common_name
            | contains("Mac Developer Installer"))
            | .common_name][0]' \
          | xargs)
xcrun productsign --sign "$INSTALLER_CERT_NAME" unsigned.pkg "$PACKAGE_NAME"
rm -f unsigned.pkg 
```

</li>
<li>

패키지된 앱을 App Store Connect에 게시:

```bash
app-store-connect publish \
    --path "$PACKAGE_NAME"
```

</li>
<li>

앞서 언급했듯이, 로그인 키체인을 기본값으로 설정하는 것을 잊지 마세요.
이렇게 하면 기기의 앱과 관련된 인증 문제를 피할 수 있습니다.

```bash
keychain use-login
```

</li>
</ol>

## TestFlight에서 앱 출시 {:#release-your-app-on-testflight}

[TestFlight][]를 사용하면 개발자가 앱을 내부 및 외부 테스터에게 푸시할 수 있습니다. 
이 선택 단계는 TestFlight에서 빌드를 릴리스하는 것을 다룹니다.

1. [App Store Connect][appstoreconnect_login]에서 
   앱의 애플리케이션 세부 정보 페이지의 TestFlight 탭으로 이동합니다.
2. 사이드바에서 **Internal Testing**를 선택합니다.
3. 테스터에게 게시할 빌드를 선택한 다음 **Save**을 클릭합니다.
4. 모든 내부 테스터의 이메일 주소를 추가합니다. 
   페이지 상단의 드롭다운 메뉴에서 사용할 수 있는 
   App Store Connect의 **Users and Roles** 페이지에서 추가 내부 사용자를 추가할 수 있습니다.

## 등록된 기기에 배포 {:#distribute-to-registered-devices}

지정된 Mac 컴퓨터에 배포할 보관 파일을 준비하려면 [배포 가이드][distributionguide_macos]를 참조하세요.

## App Store에 앱 출시 {:#release-your-app-to-the-app-store}

앱을 전 세계에 출시할 준비가 되면, 다음 단계에 따라 앱을 검토하고 App Store에 출시하기 위해 제출하세요.

1. [App Store Connect][appstoreconnect_login]에서 앱의 애플리케이션 세부 정보 페이지의 사이드바에서, 
   **Pricing and Availability**을 선택하고 필요한 정보를 입력하세요.
2. 사이드바에서 상태를 선택하세요. 
   이 앱의 첫 번째 릴리스인 경우 상태는 **1.0 Prepare for Submission**입니다. 모든 필수 필드를 입력하세요.
3. **Submit for Review**을 클릭하세요.

Apple에서 앱 검토 프로세스가 완료되면 알려드립니다. **Version Release** 섹션에서 지정한 지침에 따라 앱이 출시됩니다.

자세한 내용은 [App Store를 통해 앱 배포][distributionguide_submit]를 참조하세요.

## 문제 해결 {:#troubleshooting}

[앱 배포][distributionguide] 가이드는 App Store에 앱을 출시하는 과정에 대한 자세한 개요를 제공합니다.

## 추가적인 자료 {:#additional-resources}

유료 Apple 개발자 계정을 사용하지 않고 오픈 소스 방식으로 macOS용 Flutter 데스크톱 앱을 패키징하고 배포하는 방법을 알아보려면, 
단계별 [macOS 패키징 가이드][macos_packaging_guide]를 확인하세요.

[appicon]: {{site.apple-dev}}/design/human-interface-guidelines/macos/icons-and-images/app-icon/
[appreview]: {{site.apple-dev}}/app-store/review/
[appsigning]: https://help.apple.com/xcode/mac/current/#/dev154b28f09
[appstore]: {{site.apple-dev}}/app-store/submissions/
[appstoreconnect]: {{site.apple-dev}}/support/app-store-connect/
[appstoreconnect_api_key]: https://appstoreconnect.apple.com/access/api
[appstoreconnect_guide]: {{site.apple-dev}}/support/app-store-connect/
[appstoreconnect_guide_register]: https://help.apple.com/app-store-connect/#/dev2cd126805
[appstoreconnect_login]: https://appstoreconnect.apple.com/
[codemagic_cli_tools]: {{site.github}}/codemagic-ci-cd/cli-tools
[codesigning_guide]: {{site.apple-dev}}/library/content/documentation/Security/Conceptual/CodeSigningGuide/Introduction/Introduction.html
[Core Foundation Keys]: {{site.apple-dev}}/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html
[devportal_appids]: {{site.apple-dev}}/account/resources/identifiers/list
[devportal_certificates]: {{site.apple-dev}}/account/resources/certificates/list
[devprogram]: {{site.apple-dev}}/programs/
[devprogram_membership]: {{site.apple-dev}}/support/compare-memberships/
[distributionguide]: https://help.apple.com/xcode/mac/current/#/dev8b4250b57
[distributionguide_config]: https://help.apple.com/xcode/mac/current/#/dev91fe7130a
[distributionguide_macos]: https://help.apple.com/xcode/mac/current/#/dev295cc0fae
[distributionguide_submit]: https://help.apple.com/xcode/mac/current/#/dev067853c94
[distributionguide_upload]: https://help.apple.com/xcode/mac/current/#/dev442d7f2ca
[obfuscating your Dart code]: /deployment/obfuscate
[TestFlight]: {{site.apple-dev}}/testflight/
[macos_packaging_guide]: https://medium.com/@fluttergems/packaging-and-distributing-flutter-desktop-apps-the-missing-guide-part-1-macos-b36438269285
