##### 자동 첨부 활성화 {:#enable-automatic-attachment}

디버깅을 시작할 때마다 VS Code를 Flutter 모듈 프로젝트에 연결하도록 구성할 수 있습니다. 
이 기능을 사용하려면, Flutter 모듈 프로젝트에 `.vscode/launch.json` 파일을 만드세요.

1. **View** <span aria-label="and then">></span> **Run**으로 이동합니다.

   <kbd>Ctrl</kbd> / <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>D</kbd>를 누를 수도 있습니다.

   VS Code가 **Run and Debug** 사이드바를 표시합니다.

2. 이 사이드바에서, **create a launch.json file**을 클릭합니다.

   VS Code가 상단에 **Select debugger** 메뉴를 표시합니다.

3. **Dart & Flutter**를 선택합니다.

   VS Code가 `.vscode/launch.json` 파일을 만든 다음 엽니다.

   <details markdown="1">
   <summary>확장하여 launch.json 파일 예를 확인하세요.</summary>

    ```json
    {
        // Use IntelliSense to learn about possible attributes.
        // Hover to view descriptions of existing attributes.
        // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
        "version": "0.2.0",
        "configurations": [
            {
                "name": "my_app",
                "request": "launch",
                "type": "dart"
            },
            {
                "name": "my_app (profile mode)",
                "request": "launch",
                "type": "dart",
                "flutterMode": "profile"
            },
            {
                "name": "my_app (release mode)",
                "request": "launch",
                "type": "dart",
                "flutterMode": "release"
            }
        ]
    }
    ```

    </details>

4. 첨부하려면, **Run** <span aria-label="and then">></span> **Start Debugging**으로 이동합니다.

   <kbd>F5</kbd>를 누를 수도 있습니다.
