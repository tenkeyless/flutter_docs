#### PowerShell 또는 명령 프롬프트에서 Flutter 앱의 Windows 버전 빌드 {:#build-the-windows-version-of-the-flutter-app-in-powershell-or-the-command-prompt}

필요한 Windows 플랫폼 종속성을 생성하려면, `flutter build` 명령을 실행하세요.

```console
C:\> flutter build windows --debug
```

```console
Building Windows application...                                    31.4s
√  Built build\windows\runner\Debug\my_app.exe.
```

{% tabs %}
{% tab "VS Code로 시작하기" %}

#### 먼저 VS Code로 디버깅 시작 {:#vscode-windows}

VS Code를 사용하여 대부분의 코드를 디버깅하는 경우, 이 섹션부터 시작하세요.

##### VS Code에서 디버거 시작 {:#start-the-debugger-in-vs-code-1}

{% include docs/debug/debug-flow-vscode-as-start.md %}

{% comment %}
     !['Flutter app generated as a Windows app. The app displays two buttons to open this page in a browser or in the app'](/assets/images/docs/testing/debugging/native/url-launcher-app/windows.png){:width="50%"}
     <div class="figure-caption">
     
     Flutter app generated as a Windows app. The app displays two buttons to open this page in a browser or in the app.

     </div>
{% endcomment %}

##### Visual Studio에서 Flutter 프로세스에 연결 {:#attach-to-the-flutter-process-in-visual-studio}

1. 프로젝트 솔루션 파일을 열려면, **File** <span aria-label="and then">></span> **Open** <span aria-label="and then">></span> **Project/Solution…**

   <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>O</kbd>를 누를 수도 있습니다.

1. Flutter 앱 디렉토리에서 `build/windows/my_app.sln` 파일을 선택합니다.

{% comment %}
   ![Open Project/Solution dialog box in Visual Studio 2022 with my_app.sln file selected.](/assets/images/docs/testing/debugging/native/visual-studio/choose-solution.png){:width="100%"}
   <div class="figure-caption">

   Open Project/Solution dialog box in Visual Studio 2022 with
   `my_app.sln` file selected.

   </div>
{% endcomment %}

1. **Debug** > **Attach to Process**로 이동합니다.

   <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>P</kbd>를 누를 수도 있습니다.

2. **Attach to Process** 대화 상자에서 `my_app.exe`를 선택합니다.

{% comment %}
   ![Selecting my_app from the Attach to Process dialog box](/assets/images/docs/testing/debugging/native/visual-studio/attach-to-process-dialog.png){:width="100%"}
{% endcomment %}

   Visual Studio가 Flutter 앱 모니터링을 시작합니다.

{% comment %}
   ![Visual Studio debugger running and monitoring the Flutter app](/assets/images/docs/testing/debugging/native/visual-studio/debugger-active.png){:width="100%"}
{% endcomment %}

{% endtab %}
{% tab "Visual Studio로 시작하기" %}

#### 먼저 Visual Studio로 디버깅 시작 {:#start-debugging-with-visual-studio-first}

Visual Studio를 사용하여 대부분의 코드를 디버깅하는 경우, 이 섹션부터 시작하세요.

##### 로컬 Windows 디버거 시작 {:#start-the-local-windows-debugger}

1. 프로젝트 솔루션 파일을 열려면 **File** <span aria-label="and then">></span> **Open** <span aria-label="and then">></span> **Project/Solution…**으로 가세요.

   <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>O</kbd>를 누를 수도 있습니다.

1. Flutter 앱 디렉토리에서 `build/windows/my_app.sln` 파일을 선택합니다.

{% comment %}
   ![Open Project/Solution dialog box in Visual Studio 2022 with my_app.sln file selected.](/assets/images/docs/testing/debugging/native/visual-studio/choose-solution.png){:width="100%"}
   <div class="figure-caption">

   Open Project/Solution dialog box in Visual Studio 2022 with
   `my_app.sln` file selected.

   </div>
{% endcomment %}

1. `my_app`을 시작 프로젝트로 설정합니다. **Solution Explorer**에서, 
   `my_app`을 마우스 오른쪽 버튼으로 클릭하고, **Set as Startup Project**을 선택합니다.

2. **Local Windows Debugger**를 클릭하여 디버깅을 시작합니다.

   <kbd>F5</kbd>를 누를 수도 있습니다.

   Flutter 앱이 시작되면, 콘솔 창에 Dart VM 서비스 URI가 포함된 메시지가 표시됩니다. 
   다음 응답과 유사합니다.

   ```console
   flutter: The Dart VM service is listening on http://127.0.0.1:62080/KPHEj2qPD1E=/
   ```

3. Dart VM 서비스 URI를 복사합니다.

##### VS Code에서 Dart VM에 연결 {:#attach-to-the-dart-vm-in-vs-code-2}

1. 명령 팔레트를 열려면, **View** <span aria-label="and then">></span> **Command Palette...**로 이동합니다.

   <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd>를 누를 수도 있습니다.

2. `debug`를 입력합니다.

3. **Debug: Attach to Flutter on Device** 명령을 클릭합니다.

{% comment %}
   !['Running the Debug: Attach to Flutter on Device command in VS Code.'](/assets/images/docs/testing/debugging/vscode-ui/screens/attach-flutter-process-menu.png){:width="100%"}
{% endcomment %}

1. **Paste an VM Service URI** 상자에, Visual Studio에서 복사한 URI를 붙여넣고 <kbd>Enter</kbd> 키를 누릅니다.

{% comment %}
   ![Alt text](/assets/images/docs/testing/debugging/vscode-ui/screens/vscode-add-attach-uri-filled.png)
{% endcomment %}

{% endtab %}
{% endtabs %}
