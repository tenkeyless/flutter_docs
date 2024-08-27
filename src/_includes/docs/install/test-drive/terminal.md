<div class="tab-pane" id="terminal" role="tabpanel" aria-labelledby="terminal-tab">

### 샘플 Flutter 앱 만들기 {:#create-app-terminal}

새로운 Flutter 앱을 만들려면, 셸이나 터미널에서 다음 명령을 실행하세요.

1. `flutter create` 명령을 실행하세요.

   ```console
   flutter create test_drive
   ```

   이 명령은 [Material Components][]를 사용하는 간단한 데모 앱을 포함하는, 
   `test_drive`라는 Flutter 프로젝트 디렉토리를 만듭니다.

1. Flutter 프로젝트 디렉토리로 변경합니다.
   
   ```console
   cd test_drive
   ```

### 샘플 Flutter 앱을 실행하세요 {:#run-your-sample-flutter-app-2}

1. 실행 중인 대상 장치가 있는지 확인하려면, 다음 명령을 실행하세요.

   ```console
   flutter devices
   ```

   **Install** 섹션에서 대상 장치를 생성했습니다.

2. 앱을 실행하려면, 다음 명령을 실행하세요.

   ```console
   flutter run
   ```

{% capture save_changes -%}
.

1. 터미널 창에 <kbd>r</kbd>을 입력합니다.
{% endcapture %}

{% include docs/install/test-drive/try-hot-reload.md save_changes=save_changes  ide="VS Code" %}

</div>
