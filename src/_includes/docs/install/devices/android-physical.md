#### 대상 Android 기기 셋업 {:#set-up-your-target-android-device}

{% render docs/help-link.md, location:'android-device', section:'#android-setup' %}

실제 Android 기기에서 실행되도록 Flutter 앱을 구성하려면, 
{{site.targetmin.android}} 이상을 실행하는 Android 기기가 필요합니다.

1. [Android 문서]({{site.android-dev}}/studio/debug/dev-options)에 설명된 대로, 
   기기에서 **Developer options** 및 **USB debugging**을 활성화합니다.

2. [선택 사항] 무선 디버깅을 활용하려면, [Android 문서]({{site.android-dev}}/studio/run/device#wireless)에 설명된 대로, 기기에서 **Wireless debugging**을 활성화합니다.

{%- if include.devos == 'Windows' %}

1. [Google USB 드라이버]({{site.android-dev}}/studio/run/win-usb)를 설치하세요.

{% endif %}

1. 기기를 {{include.devos}} 컴퓨터에 연결합니다.
   기기에서 메시지가 표시되면 컴퓨터가 기기에 액세스할 수 있도록 승인합니다.

1. Flutter가 연결된 Android 기기를 인식하는지 확인합니다.

   {%- if include.devos == 'Windows' %}

   PowerShell에서 다음을 실행합니다.

   ```console
   c:\> flutter devices
   ```

   {% elsif devos == 'macOS' %}

   터미널에서 다음을 실행하세요.

   ```console
   $ flutter devices
   ```

   {% endif %}

   기본적으로, Flutter는 `adb` 도구가 기반하는 Android SDK 버전을 사용합니다. 
   Flutter에서 다른 Android SDK 설치 경로를 사용하려면, 
   `ANDROID_SDK_ROOT` 환경 변수를 해당 설치 디렉토리로 설정합니다.
