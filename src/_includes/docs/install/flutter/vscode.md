{%- if include.os=='macOS' -%}
{% assign special = 'Command' %}
{% else %}
{% assign special = 'Control' %}
{%- endif %}

### VS Code를 사용하여 Flutter 설치 {:#use-vs-code-to-install-flutter .no_toc}

이러한 지침에 따라 Flutter를 설치하려면, 
[Visual Studio Code][] {{site.appmin.vscode}} 이상 및 
[VS Code용 Flutter 확장 프로그램][Flutter extension for VS Code]이 설치되어 있는지 확인하세요.

#### VS Code를 프롬프트하여 Flutter 설치 {:#prompt-vs-code-to-install-flutter}

1. VS Code를 시작합니다.

1. **Command Palette**를 열려면, 
   <kbd>{{special}}</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd>를 누릅니다.

2. **Command Palette**에서 `flutter`를 입력합니다.

3. **Flutter: New Project**를 선택합니다.

4. VS Code에서 컴퓨터에서 Flutter SDK를 찾으라는 메시지가 표시됩니다.

   {:type="a"}
   1. Flutter SDK가 설치되어 있으면, **Locate SDK**를 클릭합니다.

   1. Flutter SDK가 설치되어 있지 않으면, **Download SDK**를 클릭합니다.

      이 옵션을 선택하면 [개발 도구 필수 조건][development tools prerequisites]에서 지시한 대로, 
      {% if include.os == "Windows" %} Windows용{% endif %} Git을 설치하지 않은 경우, 
      Flutter 설치 페이지로 이동합니다.

5. **Which Flutter template?** 라는 메시지가 표시되면 무시합니다. 
   <kbd>Esc</kbd>를 누르세요. 
   개발 설정을 확인한 후, 테스트 프로젝트를 만들 수 있습니다.

#### Flutter SDK 다운로드 {:#download-the-flutter-sdk}

1. **Select Folder for Flutter SDK** 대화 상자가 표시되면, Flutter를 설치할 위치를 선택합니다.

   VS Code는 사용자 프로필에서 시작합니다. 다른 위치를 선택합니다.

   {% if include.os == "Windows" -%}
   `%USERPROFILE%` 또는 `C:\dev`를 고려하세요.

   {% render docs/install/admonitions/install-paths.md %}
   {% else -%}
   `~/development/`를 고려하세요.
   {% endif %}

2. **Clone Flutter**를 클릭합니다.

   Flutter를 다운로드하는 동안, VS Code는 이 팝업 알림을 표시합니다.

   ```console
   Downloading the Flutter SDK. This may take a few minutes.
   ```

   이 다운로드는 몇 분 정도 걸립니다.
   다운로드가 중단되었다고 생각되면, **Cancel**를 클릭한 다음 설치를 다시 시작하세요.

3. Flutter 다운로드가 완료되면, **Output** 패널이 표시됩니다.

   ```console
   Checking Dart SDK version...
   Downloading Dart SDK from the Flutter engine ...
   Expanding downloaded archive...
   ```

   성공하면, VS Code는 다음 팝업 알림을 표시합니다.

   ```console
   Initializing the Flutter SDK. This may take a few minutes.
   ```

   초기화하는 동안, **Output** 패널에 다음이 표시됩니다.

   ```console
   Building flutter tool...
   Running pub upgrade...
   Resolving dependencies...
   Got dependencies.
   Downloading Material fonts...
   Downloading Gradle Wrapper...
   Downloading package sky_engine...
   Downloading flutter_patched_sdk tools...
   Downloading flutter_patched_sdk_product tools...
   Downloading windows-x64 tools...
   Downloading windows-x64/font-subset tools...
   ```

   이 프로세스는 `flutter doctor -v`도 실행합니다.
   이 시점에서는, _이 출력을 무시합니다._
   Flutter Doctor는 이 빠른 시작에 적용되지 않는 오류를 표시할 수 있습니다.

   Flutter 설치가 성공하면, VS Code는 이 팝업 알림을 표시합니다.

   ```console
   Do you want to add the Flutter SDK to PATH so it's accessible
   in external terminals?
   ```

{% if include.os=='Windows' %}

1. **Add SDK to PATH**를 클릭합니다.

   성공하면, 알림이 표시됩니다.

   ```console
   The Flutter SDK was added to your PATH
   ```

{% endif %}

1. VS Code는 Google Analytics 알림을 표시할 수 있습니다.

   동의하면 **OK**을 클릭합니다.

2. 모든 {{include.terminal}} 창에서 `flutter`를 활성화하려면:

   {:type="a"}
   1. 모든 {{include.terminal}} 창을 닫았다가 다시 엽니다.
   2. VS Code를 다시 시작합니다.

[development tools prerequisites]: #development-tools
[Visual Studio Code]: https://code.visualstudio.com/docs/setup/mac
[Flutter extension for VS Code]: https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter
