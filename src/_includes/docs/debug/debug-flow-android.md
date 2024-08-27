:::note
Android 앱 프로세스 내에서 실행되는 Flutter 엔진을 디버깅하기 위해, 
[GNU Project Debugger][]를 사용하려면, [`flutter_gdb`][]를 확인하세요.
:::

[GNU Project Debugger]: https://www.sourceware.org/gdb/
[`flutter_gdb`]: {{site.repo.engine}}/blob/main/sky/tools/flutter_gdb

#### 터미널에서 Flutter 앱의 Android 버전 빌드 {:#build-the-android-version-of-the-flutter-app-in-the-terminal}

필요한 Android 플랫폼 종속성을 생성하려면, `flutter build` 명령을 실행하세요.

```console
flutter build appbundle --debug
```

```console
Running Gradle task 'bundleDebug'...                               27.1s
✓ Built build/app/outputs/bundle/debug/app-debug.aab.
```


{% tabs %}
{% tab "VS Code로 시작하기" %}

#### 먼저 VS Code로 디버깅 시작하기 {:#from-vscode-to-android-studio}

VS Code를 사용하여 대부분의 코드를 디버깅하는 경우, 이 섹션부터 시작하세요.

{% include docs/debug/debug-flow-vscode-as-start.md %}

#### Android Studio에서 Flutter 프로세스에 연결 {:#attach-to-the-flutter-process-in-android-studio}

{% include docs/debug/debug-android-attach-process.md %}

{% endtab %}
{% tab "Android Studio로 시작하기" %}

#### 먼저 Android Studio로 디버깅 시작하기 {:#from-android-studio}

Android Studio를 사용하여 대부분의 코드를 디버깅하는 경우, 이 섹션부터 시작하세요.

{% include docs/debug/debug-flow-androidstudio-as-start.md %}

{% include docs/debug/debug-android-attach-process.md %}

{% endtab %}
{% endtabs %}
