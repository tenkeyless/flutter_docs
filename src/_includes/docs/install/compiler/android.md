
## Android 개발 구성 {:#configure-android-development}

{% case include.devos %}
{% when 'Windows' -%}
   {% assign terminal='PowerShell' %}
   {% assign prompt='C:\>' %}
{% when "macOS" -%}
   {% assign terminal='your Terminal' %}
   {% assign prompt='$' %}
{% else -%}
   {% assign terminal='a shell' %}
   {% assign prompt='$' %}
{% endcase -%}

### Android Studio에서 Android 툴체인 구성 {:#configure-the-android-toolchain-in-android-studio}

{% render docs/help-link.md, location:'android-studio', section:'#android-setup' %}

Flutter로 Android 앱을 만들려면, 다음 Android 구성 요소가 설치되었는지 확인하세요.

* **Android SDK 플랫폼, API {{ site.appnow.android_sdk }}**
* **Android SDK 명령줄 도구**
* **Android SDK 빌드 도구**
* **Android SDK 플랫폼 도구**
* **Android 에뮬레이터**

이러한 도구를 설치하지 않았거나 모르는 경우, 다음 절차를 계속 진행하세요.

그렇지 않으면, [다음 섹션][check-dev]로 건너뛸 수 있습니다.

[check-dev]: #check-your-development-setup

{% tabs "android-studio-experience" %}
{% tab "Android Studio를 처음 사용" %}

1. **Android Studio**를 실행합니다.

   **Welcome to Android Studio** 대화 상자가 표시됩니다.

2. **Android Studio Setup Wizard**를 따릅니다.

3. 다음 구성 요소를 설치합니다.

   * **Android SDK 플랫폼, API {{ site.appnow.android_sdk }}**
   * **Android SDK 명령줄 도구**
   * **Android SDK 빌드 도구**
   * **Android SDK 플랫폼 도구**
   * **Android 에뮬레이터**

{% endtab %}
{% tab "Current Android Studio 사용자" %}

1. **Android Studio**를 실행합니다.

2. **Settings** 대화 상자로 이동하여 **SDK Manager**를 확인합니다.

   1. 프로젝트가 열려 있는 경우, **Tools** <span aria-label="and then">></span> **SDK Manager**로 이동합니다.

   2. **Welcome to Android Studio** 대화 상자가 표시되면, 
      **Open** 버튼 뒤에 있는 **More Options** 아이콘을 클릭하고, 드롭다운 메뉴에서 **SDK Manager**를 클릭합니다.

3. **SDK Platforms**을 클릭합니다.

4. **Android API {{ site.appnow.android_sdk }}**가 선택되었는지 확인합니다.

   **Status** 열에 **Update available** 또는 **Not installed**이 표시되는 경우:

   {:type="a"}
   1. **Android API {{ site.appnow.android_sdk }}**를 선택합니다.

   2. **Apply**을 클릭합니다.

   3. **Confirm Change** 대화 상자가 표시되면 **OK**을 클릭합니다.

      **SDK Quickfix Installation** 대화 상자가 완료 미터와 함께 표시됩니다.

   4. 설치가 완료되면 **Finish**을 클릭합니다.

      최신 SDK를 설치한 후, **Status** 열에 **Update available**이 표시될 수 있습니다. 
      즉, 일부 추가 시스템 이미지가 설치되지 않았을 수 있습니다. 이를 무시하고 계속할 수 있습니다.

5. **SDK Tools**를 클릭합니다.

6. 다음 SDK 도구가 선택되었는지 확인합니다.

   * **Android SDK 명령줄 도구**
   * **Android SDK 빌드 도구**
   * **Android SDK 플랫폼 도구**
   * **Android 에뮬레이터**

7. 이전 도구 중 하나에 대한 **Status** 열에 **Update available** 또는 **Not installed**이 표시되는 경우:

   {:type="a"}
   1. 필요한 도구를 선택합니다.

   2. **Apply**을 클릭합니다.

   3. **Confirm Change** 대화 상자가 표시되면 **OK**을 클릭합니다.

      **SDK Quickfix Installation** 대화 상자가 완료 미터와 함께 표시됩니다.

   4. 설치가 완료되면 **Finish**을 클릭합니다.

{% endtab %}
{% endtabs %}

### 대상 Android 기기 구성 {:#configure-your-target-android-device}

{% tabs "android-emulator-or-not" %}
{% tab "가상 장치" %}

{% include docs/install/devices/android-emulator.md devos=include.devos %}

{% endtab %}
{% tab "실제 장치" %}

{% include docs/install/devices/android-physical.md devos=include.devos %}

{% endtab %}
{% endtabs %}

{% if include.attempt == 'first' %}

### Android 라이센스에 동의하기 {:#agree-to-android-licenses}

{% render docs/help-link.md, location:'android-licenses', section:'#android-setup' %}

Flutter를 사용하기 전에 모든 필수 구성 요소를 설치한 후, Android SDK 플랫폼의 라이선스에 동의하세요.

1. 관리자 권한 콘솔 창을 엽니다.

1. 다음 명령을 실행하여 라이선스 서명을 활성화합니다.

   ```console
   {{prompt}} flutter doctor --android-licenses
   ```

   다른 시간에 Android Studio 라이선스를 수락한 경우, 이 명령은 다음을 반환합니다.

   ```console
   [========================================] 100% Computing updates...
   All SDK package licenses accepted.
   ```

   다음 단계는 건너뛸 수 있습니다.

2. 각 라이선스의 조건에 동의하기 전에, 각 라이선스의 내용을 주의 깊게 읽어보세요.

#### 라이센스 문제 해결 {:#troubleshooting-licensing-issues}

<details>
<summary>Java 설치 찾기 오류를 수정하는 방법</summary>

Android SDK가 Java SDK를 찾는 데 문제가 있을 수 있습니다.

```console
$ flutter doctor --android-licenses

ERROR: JAVA_HOME is set to an invalid directory: /Applications/Android\ Studio.app/Contents/jre/Contents/Home

Please set the JAVA_HOME variable in your environment to match the
location of your Java installation.

Android sdkmanager tool was found, but failed to run
(/Users/atsansone/Library/Android/sdk/cmdline-tools/latest/bin/sdkmanager): "exited code 1".
Try re-installing or updating your Android SDK,
visit https://flutter.dev/docs/get-started/install/macos#android-setup for detailed instructions.
```

`flutter doctor` 명령은 `JAVA_HOME` 변수가 설정된 방식 때문에 이 오류를 반환합니다. 
`JAVA_HOME`에 경로를 추가할 때, `Android`와 `Studio` 사이의 공백에 백슬래시를 추가하거나, 
전체 경로를 일치하는 따옴표로 묶을 수 있습니다. _둘 다_ 할 수는 없습니다.

해당 셸 리소스 파일에서 `JAVA_HOME` 경로를 찾으세요.

다음을 변경하세요.

```bash
export JAVA_HOME="/Applications/Android\ Studio.app/Contents/jre/Contents/Home"
```

이렇게 변경하세요.

```bash
export JAVA_HOME="/Applications/Android Studio.app/Contents/jre/Contents/Home"
```

`Android`와 `Studio` 사이에 백슬래시를 포함하지 마십시오.

이 업데이트된 환경 변수를 로드하려면 셸을 다시 로드하십시오.
이 예에서는 `zsh` 리소스 파일을 사용합니다.

```console
source ~/.zshrc
```

</details>

{% endif %}
