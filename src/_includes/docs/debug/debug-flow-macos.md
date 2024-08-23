#### 터미널에서 Flutter 앱의 macOS 버전 빌드 {:#build-the-macos-version-of-the-flutter-app-in-the-terminal}

필요한 macOS 플랫폼 종속성을 생성하려면, `flutter build` 명령을 실행하세요.

```console
flutter build macos --debug
```

```console
Building macOS application...
```

{% tabs "darwin-debug-flow" %}
{% tab "VS Code로 시작하기" %}

#### 먼저 VS Code로 디버깅 시작 {:#vscode-macos}

##### VS Code에서 디버거 시작 {:#start-the-debugger-in-vs-code}

{% include docs/debug/debug-flow-vscode-as-start.md %}

##### Xcode에서 Flutter 프로세스에 연결 {:#attach-to-the-flutter-process-in-xcode-1}

1. Flutter 앱에 연결하려면, **Debug** <span aria-label="and then">></span> **Attach to Process** <span aria-label="and then">></span> **Runner**로 이동합니다.

   **Runner**는 **Attach to Process** 메뉴의 맨 위에 **Likely Targets** 제목 아래에 있어야 합니다.

{% endtab %}
{% tab "Xcode로 시작하기" %}

#### 먼저 Xcode로 디버깅 시작 {:#xcode-macos}

##### Xcode에서 디버거 시작 {:#start-the-debugger-in-xcode}

1. Flutter 앱 디렉토리에서 `macos/Runner.xcworkspace`를 엽니다.

2. Xcode에서 이 Runner를 일반 앱으로 실행합니다.

{% comment %}
   ![Start button in Xcode interface](/assets/images/docs/testing/debugging/native/xcode/run-app.png)
   <div class="figure-caption">

   Start button displayed in Xcode interface.

   </div>
{% endcomment %}

   실행이 완료되면, Xcode 하단의 **Debug** 영역에 Dart VM 서비스 URI가 포함된 메시지가 표시됩니다. 
   다음 응답과 유사합니다.

   ```console
   2023-07-12 14:55:39.966191-0500 Runner[58361:53017145]
       flutter: The Dart VM service is listening on
       http://127.0.0.1:50642/00wEOvfyff8=/
   ```

1. Dart VM 서비스 URI를 복사합니다.

##### VS Code에서 Dart VM에 연결 {:#attach-to-the-dart-vm-in-vs-code-1}

1. 명령 팔레트를 열려면 **View** > **Command Palette...**로 이동합니다.

   <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd>를 누를 수도 있습니다.

2. `debug`를 입력합니다.

3. **Debug: Attach to Flutter on Device** 명령을 클릭합니다.

{% comment %}
   !['Running the Debug: Attach to Flutter on Device command in VS Code.'](/assets/images/docs/testing/debugging/vscode-ui/screens/attach-flutter-process-menu.png){:width="100%"}
{% endcomment %}

1. **Paste an VM Service URI** 상자에 Xcode에서 복사한 URI를 붙여넣고, <kbd>Enter</kbd> 키를 누릅니다.

{% comment %}
   ![Alt text](/assets/images/docs/testing/debugging/vscode-ui/screens/vscode-add-attach-uri-filled.png)
{% endcomment %}

{% endtab %}
{% endtabs %}
