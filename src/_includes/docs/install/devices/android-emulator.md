#### Android 에뮬레이터 셋업 {:#set-up-the-android-emulator}

{% render docs/help-link.md, location:'android-emulator', section:'#android-setup' %}

{% case include.devos %}
{% when 'Windows','Linux' -%}
{% assign images = '**x86 Images**' -%}
{% when 'macOS' -%}
{% assign images = '**x86 Images** if your Mac runs on an Intel CPU or **ARM Images** if your Mac runs on an Apple CPU' -%}
{% endcase -%}

Android 에뮬레이터에서 실행되도록 Flutter 앱을 구성하려면, 다음 단계에 따라 에뮬레이터를 만들고 선택하세요.

1. 개발 컴퓨터에서 [VM 가속]({{site.android-dev}}/studio/run/emulator-acceleration#accel-vm)을 활성화합니다.

1. **Android Studio**를 시작합니다.

1. **Settings** 대화 상자로 이동하여 **SDK Manager**를 봅니다.

   1. 프로젝트가 열려 있으면 **Tools** <span aria-label="and then">></span> **Device Manager**로 이동합니다.

   2. **Welcome to Android Studio** 대화 상자가 표시되면, 
      **Open** 버튼 뒤에 있는 **More Options** 아이콘을 클릭하고, 
      드롭다운 메뉴에서 **Device Manager**를 클릭합니다.

1. **Virtual**을 클릭합니다.

2. **Create Device**를 클릭합니다.

   **Virtual Device Configuration** 대화 상자가 표시됩니다.

3. **Category**에서 **Phone** 또는 **Tablet**을 선택합니다.

4. 장치 정의를 선택합니다. 장치를 찾아보거나 검색할 수 있습니다.

5. **Next**을 클릭합니다.

6. {{images}}를 클릭합니다.

7. 에뮬레이션하려는 Android 버전에 대한 시스템 이미지 하나를 클릭합니다.

   {:type="a"}
   1. 원하는 이미지에 **Release Name** 오른쪽에 **Download** 아이콘이 있으면 클릭합니다.

      **SDK Quickfix Installation** 대화 상자가 완료 미터와 함께 표시됩니다.

   1. 다운로드가 완료되면 **Finish**을 클릭합니다.

8. **Next**을 클릭합니다.

   **Virtual Device Configuration**에 **Verify Configuration** 단계가 표시됩니다.

9. Android 가상 장치(AVD, Android Virtual Device)의 이름을 바꾸려면, **AVD Name** 상자에서 값을 변경합니다.

10. **Show Advanced Settings**를 클릭하고 **Emulated Performance**으로 스크롤합니다.

11. **Graphics** 드롭다운 메뉴에서, **Hardware - GLES 2.0**을 선택합니다.

    이렇게 하면 [하드웨어 가속][hardware acceleration]이 활성화되고 렌더링 성능이 향상됩니다.

12. AVD 구성을 확인합니다. 올바르면 **Finish**을 클릭합니다.

    AVD에 대해 자세히 알아보려면,
    [AVD 관리]({{site.android-dev}}/studio/run/managing-avds)를 확인하세요.

13. **Device Manager** 대화 상자에서 원하는 AVD 오른쪽에 있는 **Run** 아이콘을 클릭합니다. 
    에뮬레이터가 시작되고, 선택한 Android OS 버전 및 장치에 대한 기본 캔버스가 표시됩니다.

[hardware acceleration]: {{site.android-dev}}/studio/run/emulator-acceleration
