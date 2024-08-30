1. Flutter 앱 디렉토리를 열려면, 
   **File** <span aria-label="and then">></span> **Open Folder...** 로 가서, 
   `my_app` 디렉토리를 선택합니다.

2. `lib/main.dart` 파일을 엽니다.

3. 두 개 이상의 기기에 앱을 빌드할 수 있는 경우, 먼저 기기를 선택해야 합니다.

   **View** <span aria-label="and then">></span> **Command Palette...** 로 이동합니다.

   <kbd>Ctrl</kbd> / <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd>를 누를 수도 있습니다.

4. `flutter select`를 입력합니다.

5. **Flutter: Select Device** 명령을 클릭합니다.

6. 대상 기기를 선택합니다.

7. 디버그 아이콘(![Flutter 앱의 디버깅 모드를 트리거하는 VS Code의 버그 아이콘](/assets/images/docs/testing/debugging/vscode-ui/icons/debug.png))을 클릭합니다. 
   그러면 **Debug** 창이 열리고 앱이 실행됩니다. 
   기기에서 앱이 실행되고 디버그 창에 **Connected**이 표시될 때까지 기다립니다. 
   디버거가 처음 실행될 때는 시간이 더 오래 걸립니다. 
   이후 실행은 더 빨리 시작됩니다.

   이 Flutter 앱에는 두 개의 버튼이 있습니다.

   - **브라우저에서 실행**: 이 버튼을 누르면 기기의 기본 브라우저에서 이 페이지가 열립니다.
   - **앱에서 실행**: 이 버튼을 누르면 앱 내에서 이 페이지가 열립니다. 
       이 버튼은 iOS 또는 Android에서만 작동합니다. 
       데스크톱 앱은 브라우저를 실행합니다.

{% if include.add == 'launch' -%}
{% include docs/debug/vscode-flutter-attach-json.md %}
{% endif -%}
