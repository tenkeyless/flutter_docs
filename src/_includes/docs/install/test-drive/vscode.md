<div class="tab-pane active" id="vscode" role="tabpanel" aria-labelledby="vscode-tab">

### 샘플 Flutter 앱 만들기 {:#create-app-vs-code}

1. VS Code에서 Flutter DevTools를 사용하려면,
   [Flutter 확장 프로그램](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)을 설치합니다. 
   이렇게 하면 [Dart 확장 프로그램](https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code)도 자동으로 설치됩니다. 
   이러한 확장 프로그램을 사용하면, 애플리케이션을 디버깅할 수 있습니다.

2. 명령 팔레트를 엽니다.

   **View** <span aria-label="그리고">></span> **Command Palette**로 이동하거나, 
   <kbd class="special-key"></kbd> + <kbd>Shift</kbd> + <kbd>P</kbd>를 누릅니다.

3. `flutter`를 입력합니다.

4. **Flutter: New Project**를 선택합니다.

5. **Which Flutter Project**를 묻는 메시지가 표시되면 **Application**을 선택합니다.

6. 새 프로젝트 폴더의 부모 디렉터리를 만들거나 선택합니다.

7. **Project Name**을 입력하라는 메시지가 표시되면, `test_drive`를 입력합니다.

8. <kbd>Enter</kbd>를 누릅니다.

9. 프로젝트 생성이 완료될 때까지 기다립니다.

10. `lib` 디렉터리를 연 다음, `main.dart`를 엽니다.

    각 코드 블록의 기능을 알아보려면 해당 Dart 파일의 주석을 확인하세요.

이전 명령은 `test_drive`라는 Flutter 프로젝트 디렉터리를 생성하며, 
여기에는 [Material Components][]를 사용하는 간단한 데모 앱이 포함됩니다.

### 샘플 Flutter 앱 실행 {:#run-your-sample-flutter-app}

데스크톱 플랫폼, Chrome 웹 브라우저, iOS 시뮬레이터 또는 Android 에뮬레이터에서 예제 애플리케이션을 실행해 보세요.

:::note
앱을 웹에 배포할 수는 있지만, 웹 대상은 현재 핫 리로드를 지원하지 않습니다.
:::

1. 명령 팔레트를 엽니다.

   **View** <span aria-label="and then">></span> **Command Palette**로 이동하거나, 
   <kbd class="special-key"></kbd> + <kbd>Shift</kbd> + <kbd>P</kbd>를 누릅니다.

2. `flutter`를 입력합니다.

3. **Flutter: Select Device**을 선택합니다.

   실행 중인 장치가 없으면 이 명령은 장치를 활성화하라는 메시지를 표시합니다.

4. **Select Device** 프롬프트에서 대상 장치를 선택합니다.

5. 대상을 선택한 후 앱을 시작합니다. 
   **Run** <span aria-label="and then">></span> **Start Debugging**으로 이동하거나, 
   <kbd>F5</kbd>를 누릅니다.

6. 앱이 실행될 때까지 기다립니다.

   **Debug Console** 뷰에서 실행 진행 상황을 볼 수 있습니다.

{% capture save_changes -%}
: **Save All**을 호출하거나, **Hot Reload**를 클릭하세요.
{% render docs/install/test-drive/hot-reload-icon.md %}.
{% endcapture %}

{% include docs/install/test-drive/try-hot-reload.md save_changes=save_changes ide="VS Code" %}

[Material Components]: {{site.material}}/components

</div>

<script>
  document.addEventListener("DOMContentLoaded", function() {
    const specialKey = navigator.userAgent.includes('Mac')? 'Command' : 'Control';
    document.querySelectorAll('.special-key').forEach((element)=>element.textContent=specialKey);
  });
</script>
