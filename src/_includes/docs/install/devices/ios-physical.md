#### 대상 실제 iOS 기기 설정 {:#set-up-your-target-physical-ios-device}

실제 iPhone 또는 iPad에 Flutter 앱을 배포하려면, 다음을 수행해야 합니다.

- [Apple Developer][] 계정을 만듭니다.
- Xcode에서 실제 장치 배포를 설정합니다.
- 인증서에 자체 서명하기 위한 개발 프로비저닝 프로필을 만듭니다.
- 앱이 Flutter 플러그인을 사용하는 경우 타사 CocoaPods 종속성 관리자를 설치합니다.

##### Apple ID와 Apple 개발자 계정 만들기 {:#create-your-apple-id-and-apple-developer-account}

지금은 이 단계를 건너뛸 수 있습니다. 
앱을 App Store에 배포할 준비가 될 때까지 실제로 Apple 개발자 계정이 필요하지 않습니다.

앱 배포를 _테스트_ 만 하면 되는 경우, 첫 번째 단계를 완료하고 다음 섹션으로 넘어가세요.

1. [Apple ID][]가 없으면 만드세요.

1. [Apple Developer][] 프로그램에 등록하지 않은 경우, 지금 등록하세요.

   멤버십 타입에 대해 자세히 알아보려면, [멤버십 선택][Choosing a Membership]을 확인하세요.

[Apple ID]: https://support.apple.com/en-us/HT204316

##### 실제 iOS 기기를 Mac에 연결 {:#attach}

실제 iOS 기기를 구성하여 Xcode에 연결합니다.

1. iOS 기기를 Mac의 USB 포트에 연결합니다.

2. iOS 기기를 Mac에 처음 연결할 때, iOS 기기에 **이 컴퓨터를 신뢰하시겠습니까?** 대화 상자가 표시됩니다.

3. **Trust**를 클릭합니다.

   ![Mac 신뢰][Trust Mac]{:.mw-100}

4. 메시지가 표시되면, iOS 기기를 잠금 해제합니다.

##### iOS 16 이상에서 개발자 모드 활성화 {:#enable-developer-mode-on-ios-16-or-later}

iOS 16부터, Apple은 악성 소프트웨어로부터 보호하기 위해 **[개발자 모드][Developer Mode]** 를 활성화해야 합니다. 
iOS 16 이상을 실행하는 기기에 배포하기 전에 개발자 모드를 활성화하세요.

1. **Settings** <span aria-label="and then">></span> **Privacy & Security** <span aria-label="and then">></span> **Developer Mode**를 탭합니다.

2. 탭하여 **Developer Mode**를 **On**으로 토글합니다.

3. **Restart**을 탭합니다.

4. iOS 기기를 다시 시작한 후, iOS 기기를 잠금 해제합니다.

5. **Turn on Developer Mode?** 대화 상자가 나타나면, **Turn On**를 탭합니다.

   대화 상자에는 개발자 모드가 iOS 기기의 보안을 낮춰야 한다고 설명되어 있습니다.

6. iOS 기기를 잠금 해제합니다.

##### 개발자 코드 서명 인증서 활성화 {:#enable-developer-code-signing-certificates}

실제 iOS 기기에 배포하려면, Mac과 iOS 기기와의 신뢰를 구축해야 합니다. 
이를 위해서는 서명된 개발자 인증서를 iOS 기기에 로드해야 합니다. 
Xcode에서 앱에 서명하려면 개발 프로비저닝 프로필을 만들어야 합니다.

프로젝트를 프로비저닝하려면, Xcode 서명 흐름을 따르세요.

1. Xcode를 시작합니다.

2. **Xcode** <span aria-label="and then">></span> **Settings...** 으로 이동합니다.

   1. **Xcode** <span aria-label="and then">></span> **Settings...** 으로 이동합니다.
   2. **Accounts**을 클릭합니다.
   3. **+** 를 클릭합니다.
   4. **Apple ID**를 선택하고 **Continue**을 클릭합니다.
   5. 메시지가 표시되면 **Apple ID**와 **Password**를 입력합니다.
   6. **Settings** 대화 상자를 닫습니다.

   개발 및 테스트는 모든 Apple ID를 지원합니다.

3. **파일** <span aria-label="그리고">></span> **Open...** 으로 이동합니다.

   <kbd>Cmd</kbd> + <kbd>O</kbd>를 누를 수도 있습니다.

4. Flutter 프로젝트 디렉토리로 이동합니다.

5. 프로젝트에서 기본 Xcode workspace인 `ios/Runner.xcworkspace`를 엽니다.

6. 실행 버튼 오른쪽에 있는 기기 드롭다운 메뉴에서 배포하려는 실제 iOS 기기를 선택합니다.

   **iOS devices** 제목 아래에 표시되어야 합니다.

7. 왼쪽 탐색 패널의 **Targets** 아래에서, **Runner**를 선택합니다.

8. **Runner** 설정 창에서, **Signing & Capabilities**을 클릭합니다.

9. 상단에서 **All**를 선택합니다.

10. **Automatically manage signing**를 선택합니다.

11. **Team** 드롭다운 메뉴에서 팀을 선택합니다.

    팀은 [Apple 개발자 계정][Apple Developer Account] 페이지의 **App Store Connect** 섹션에서 생성됩니다.
    팀을 생성하지 않은 경우 _개인 팀_ 을 선택할 수 있습니다.

    **팀** 드롭다운은 해당 옵션을 **Your Name (Personal Team)** 으로 표시합니다.

    ![Xcode 계정 추가][Xcode account add]{:.mw-100}

    팀을 선택하면, Xcode에서 다음 작업을 수행합니다.

    1. 개발 인증서(Development Certificate)를 생성하고 다운로드합니다.
    2. 계정에 기기를 등록합니다.
    3. 필요한 경우 프로비저닝 프로필을 생성하고 다운로드합니다.

Xcode에서 자동 서명이 실패하면, 
프로젝트의 **General** <span aria-label="and then">></span> **Identity** <span aria-label="and then">></span> **Bundle Identifier** 값이 고유한지 확인합니다.

![Check the app's Bundle ID][]{:.mw-100}

##### Mac 및 iOS 기기 신뢰 활성화 {:#trust}

처음으로 실제 iOS 기기를 연결할 때, Mac과 iOS 기기의 개발 인증서(Development Certificate)에 대한 신뢰를 활성화하세요.

[기기를 Mac에 연결](#attach)할 때, iOS 기기에서 Mac의 신뢰를 활성화했어야 합니다.

##### iOS 기기에 개발자 인증서 활성화 {:#enable-developer-certificate-for-your-ios-devices}

인증서 활성화는 iOS 버전마다 다릅니다.

{% tabs "ios-versions" %}
{% tab "iOS 14" %}

1. iOS 기기에서 **Settings** 앱을 엽니다.

2. **General** <span aria-label="and then">></span> **Profiles & Device Management**를 탭합니다.

3. 인증서를 탭하여 **Enable**로 전환합니다.

{% endtab %}
{% tab "iOS 15" %}

1. iOS 기기에서 **Settings** 앱을 엽니다.

2. **General** <span aria-label="and then">></span> **VPN & Device Management**를 탭합니다.

3. 인증서를 탭하여 **Enable**로 전환합니다.

{% endtab %}
{% tab "iOS 16 이상" %}

1. iOS 기기에서 **설정** 앱을 엽니다.

2. **General** <span aria-label="and then">></span> **VPN & Device Management**를 탭합니다.

    :::note
    **Settings**에서 **VPN & Device Management**를 찾을 수 없는 경우, 
    iOS 기기에서 당신의 앱을 한 번 실행한 다음 다시 시도하세요.
    :::

3. **Developer App** 제목 아래에서, 인증서를 찾을 수 있습니다.

4. 인증서를 탭합니다.

5. ***Trust "\<certificate\>"**.를 탭합니다.

6. 대화 상자가 표시되면 **Trust**를 탭합니다.

{% endtab %}
{% endtabs %}

**codesign wants to access key...** 대화 상자가 표시됩니다.

1. macOS 비밀번호를 입력합니다.

2. **Always Allow**을 탭합니다.

#### iOS 기기에서 무선 디버깅 설정(선택 사항) {:#set-up-wireless-debugging-on-your-ios-device-optional}

Wi-Fi 연결을 사용하여 기기를 디버깅하려면 다음 절차를 따르세요.

1. iOS 기기를 macOS 기기와 동일한 네트워크에 연결합니다.

1. iOS 기기의 암호를 설정합니다.

1. **Xcode**를 엽니다.

1. **Window** <span aria-label="and then">></span> **Devices and Simulators**로 이동합니다.

<kbd>Shift</kbd> + <kbd>Cmd</kbd> + <kbd>2</kbd>를 누를 수도 있습니다.

1. iOS 기기를 선택합니다.

1. **Connect via Network**을 선택합니다.

1. 기기 이름 옆에 네트워크 아이콘이 나타나면, Mac에서 iOS 기기를 분리합니다.

`flutter run`을 사용할 때 기기가 나열되지 않으면 시간 초과를 연장하세요. 
시간 초과는 기본적으로 10초입니다. 시간 초과를 연장하려면 값을 10보다 큰 정수로 변경하세요.

```console
$ flutter run --device-timeout 60
```

:::note 무선 디버깅에 대해 자세히 알아보기
* 자세히 알아보려면, [Xcode와 무선 기기를 페어링하는 방법에 대한 Apple 문서][Apple's documentation on pairing a wireless device with Xcode]를 ​​확인하세요.
* 문제를 해결하려면 [Apple 개발자 포럼][Apple's Developer Forums]을 확인하세요.
* `flutter attachment`로 무선 디버깅을 구성하는 방법을 알아보려면 [앱 추가 모듈 디버깅][Debugging your add-to-app module]을 확인하세요.
:::

[Check the app's Bundle ID]: /assets/images/docs/setup/xcode-unique-bundle-id.png
[Choosing a Membership]: {{site.apple-dev}}/support/compare-memberships
[Trust Mac]: /assets/images/docs/setup/trust-computer.png
[Xcode account add]: /assets/images/docs/setup/xcode-account.png
[Developer Mode]: {{site.apple-dev}}/documentation/xcode/enabling-developer-mode-on-a-device
[Apple's Developer Forums]: {{site.apple-dev}}/forums/
[Debugging your add-to-app module]: /add-to-app/debugging/#wireless-debugging
[Apple's documentation on pairing a wireless device with Xcode]: https://help.apple.com/xcode/mac/9.0/index.html?localePath=en.lproj#/devbc48d1bad
[Apple Developer]: {{site.apple-dev}}/programs/
[Apple Developer Account]: {{site.apple-dev}}/account
