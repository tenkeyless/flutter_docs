
## iOS 개발 구성 {:#configure-ios-development}

{% assign prompt1='$' %}

### Xcode 설치 및 구성 {:#install-and-configure-xcode}

{% if include.attempt=="first" %}

{{include.target}}에 대한 Flutter 앱을 개발하려면, Xcode를 설치하여 네이티브 바이트코드로 컴파일합니다.

1. **App Store**를 열고 로그인합니다.

1. `Xcode`를 검색합니다.

1. **Install**를 클릭합니다.

   Xcode 설치 프로그램은 6GB 이상의 저장 공간을 차지합니다.
   다운로드하는 데 시간이 걸릴 수 있습니다.

1. 설치된 버전의 Xcode를 사용하도록 명령줄 도구를 구성하려면, 다음 명령을 사용합니다.

    ```console
    {{prompt1}} sudo sh -c 'xcode-select -s /Applications/Xcode.app/Contents/Developer && xcodebuild -runFirstLaunch'
    ```

   최신 버전의 Xcode에 이 경로를 사용하세요.
   다른 버전을 사용해야 하는 경우, 대신 해당 경로를 지정하세요.

2. Xcode 라이센스 계약에 서명하세요.

    ```console
    {{prompt1}} sudo xcodebuild -license
    ```

{% else %}

이 섹션에서는

{%- case include.target %}
{%- when 'iOS' %}
[macOS desktop][macos-install]
{%- when 'desktop' %}
[iOS][ios-install]
{%- endcase %}
 개발을 위해, Flutter를 설치할 때 Xcode를 설치하고 구성했다고 가정합니다.

[macos-install]: /get-started/install/macos/desktop/#configure-ios-development
[ios-install]: /get-started/install/macos/mobile-ios/#configure-ios-development

{% endif %}

Xcode의 최신 버전을 유지하세요.

{% if include.target=='iOS' %}

### 대상 iOS 기기를 구성하세요. {:#configure-your-target-ios-device}

Xcode를 사용하면, iOS 기기나 시뮬레이터에서 Flutter 앱을 실행할 수 있습니다.

{% tabs "ios-simulator-or-not" %}
{% tab "가상 장치" %}

{% include docs/install/devices/ios-simulator.md %}

{% endtab %}
{% tab "실제 장치" %}

{% include docs/install/devices/ios-physical.md %}

{% endtab %}
{% endtabs %}

{% endif %}

{% if include.attempt=="first" %}

### CocoaPods 설치 {:#install-cocoapods}

앱이 네이티브 {{include.target}} 코드가 있는 [Flutter 플러그인][Flutter plugins]에 의존하는 경우, 
[CocoaPods][cocoapods]를 설치하세요. 
이 프로그램은 Flutter와 {{include.target}} 코드에서 다양한 종속성을 번들로 묶습니다.

CocoaPods를 설치하고 설정하려면, 다음 명령을 실행하세요.

1. [CocoaPods 설치 가이드][cocoapods]에 따라 `cocoapods`를 설치하세요.

   ```console
   $ sudo gem install cocoapods
   ```
2. 원하는 텍스트 편집기를 실행합니다.

3. 텍스트 편집기에서 Zsh 환경 변수 파일 `~/.zshenv`를 엽니다.

4. 다음 줄을 복사하여 `~/.zshenv` 파일 끝에 붙여넣습니다.

   ```bash
   export PATH=$HOME/.gem/bin:$PATH
   ```

5. `~/.zshenv` 파일을 저장합니다.

6. 이 변경 사항을 적용하려면, 열려 있는 모든 터미널 세션을 다시 시작합니다.

[Flutter plugins]: /packages-and-plugins/developing-packages#types

{% endif %}

[cocoapods]: https://guides.cocoapods.org/using/getting-started.html#installation
