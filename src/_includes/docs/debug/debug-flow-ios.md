#### 터미널에서 Flutter 앱의 iOS 버전 빌드 {:#build-the-ios-version-of-the-flutter-app-in-the-terminal}

필요한 iOS 플랫폼 종속성을 생성하려면, `flutter build` 명령을 실행하세요.

```console
$ flutter build ios --config-only --no-codesign --debug
```

```console
Warning: Building for device with codesigning disabled. You will have to manually codesign before deploying to device.
Building com.example.myApp for device (ios)...
```

{% tabs "darwin-debug-flow" %}
{% tab "VS Code로 시작하기" %}

#### 먼저 VS Code로 디버깅 시작 {:#vscode-ios}

VS Code를 사용하여 대부분의 코드를 디버깅하는 경우, 이 섹션부터 시작하세요.

##### VS Code에서 Dart 디버거 시작 {:#start-the-dart-debugger-in-vs-code}

{% include docs/debug/debug-flow-vscode-as-start.md add=include.add %}

##### Xcode에서 Flutter 프로세스에 연결 {:#attach-to-the-flutter-process-in-xcode}

Xcode에서 Flutter 앱에 연결하려면:

1. **Debug** <span aria-label="and then">></span> **Attach to Process** <span aria-label="and then">></span>

2. **Runner**를 선택합니다. **Attach to Process** 메뉴의 맨 위에 **Likely Targets** 제목 아래에 있어야 합니다.

{% endtab %}
{% tab "Xcode로 시작하기" %}

#### 먼저 Xcode로 디버깅 시작 {:#xcode-ios}

Xcode를 사용하여 대부분의 코드를 디버깅하는 경우, 이 섹션부터 시작하세요.

##### Xcode 디버거 시작 {:#start-the-xcode-debugger}

1. Flutter 앱 디렉토리에서 `ios/Runner.xcworkspace`를 엽니다.

1. 툴바의 **Scheme** 메뉴를 사용하여 올바른 기기를 선택합니다.

    선호 사항이 없으면, **iPhone Pro 14**를 선택합니다.

   {% comment %}
    ![Selecting iPhone 14 in the Scheme menu in the Xcode toolbar](/assets/images/docs/testing/debugging/native/xcode/select-device.png){:width="100%"}
    <div class="figure-caption">

    Selecting iPhone 14 in the Scheme menu in the Xcode toolbar.

    </div>
    {% endcomment %}

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

3. Dart VM 서비스 URI를 복사합니다.

##### VS Code에서 Dart VM에 연결 {:#attach-to-the-dart-vm-in-vs-code}

1. 명령 팔레트를 열려면 **View** <span aria-label="그리고">></span> **Command Palette...** 로 이동합니다.

    <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd>를 누를 수도 있습니다.

2. `debug`를 입력합니다.

3. **Debug: Attach to Flutter on Device** 명령을 클릭합니다.
   
{% comment %}
    !['Running the Debug: Attach to Flutter on Device command in VS Code.'](/assets/images/docs/testing/debugging/vscode-ui/screens/attach-flutter-process-menu.png){:width="100%"}
{% endcomment %}

1. **Paste an VM Service URI** 상자에, Xcode에서 복사한 URI를 붙여넣고 <kbd>Enter</kbd>를 누릅니다.

{% comment %}
    ![Alt text](/assets/images/docs/testing/debugging/vscode-ui/screens/vscode-add-attach-uri-filled.png)
{% endcomment %}

{% endtab %}
{% endtabs %}
