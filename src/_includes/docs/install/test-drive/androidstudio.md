<div class="tab-pane" id="androidstudio" role="tabpanel" aria-labelledby="androidstudio-tab">

### 샘플 Flutter 앱 만들기 {:#create-app-android-studio}

1. IDE를 시작합니다.
   
2. Android Studio에서 Flutter 프로젝트를 만들려면 [Flutter 플러그인](https://plugins.jetbrains.com/plugin/9212-flutter)을 설치해야 하며, 
    코드 완성, 포맷팅, 탐색, 의도, 리팩토링 등을 포함한 스마트한 Dart 코딩 지원을 위해,
    [Dart 플러그인](https://plugins.jetbrains.com/plugin/6351-dart/)을 설치해야 합니다.

3. IDE 시작 페이지로 돌아가서 **Welcome to Android Studio** 대화 상자 상단에 있는, 
   **새 Flutter 프로젝트**를 클릭합니다.

4. **Generators**에서, **Flutter**를 클릭합니다.

5. 개발 머신의 Flutter SDK 위치와 **Flutter SDK path** 값을 확인합니다.

6. **Next**를 클릭합니다.

7. **Project name** 필드에 `test_drive`를 입력합니다. 
   프로젝트 이름은 [스네이크 케이스](https://developer.mozilla.org/en-US/docs/Glossary/Snake_case)로 작성하고 소문자로 작성해야 합니다. 
   이는 Flutter의 프로젝트 이름 지정 모범 사례를 따릅니다.

8. **Project location** 필드의 디렉토리를 Microsoft Windows에서는 `C:\dev\test_drive`로, 
   다른 플랫폼에서는 `~/development/test_drive`로 설정합니다.

   이전에 해당 디렉토리를 만들지 않은 경우, 
   Android Studio에서 **Directory Does Not Exist**라는 경고가 표시됩니다. **Create**를 클릭합니다.

9. **Project type** 드롭다운에서 **Application**을 선택합니다.

10. 나머지 양식 필드는 무시합니다. 이 테스트 드라이브에서는 변경할 필요가 없습니다. **Create**를 클릭합니다.

11. Android Studio에서 프로젝트를 생성할 때까지 기다립니다.

12. `lib` 디렉터리를 열고, `main.dart`를 엽니다.

    각 코드 블록이 무엇을 하는지 알아보려면, 해당 Dart 파일의 주석을 확인하세요.

이전 명령은 [Material Components][]를 사용하는, 
간단한 데모 앱이 포함된 `test_drive`라는 Flutter 프로젝트 디렉토리를 생성합니다.

### 샘플 Flutter 앱을 실행하세요 {:#run-your-sample-flutter-app-1}

1. Android Studio 편집 창의 맨 위에 있는 기본 Android Studio 툴바를 찾습니다.

   ![기본 IntelliJ 툴바][Main IntelliJ toolbar]{:.mw-100}

2. **target selector**에서, 앱을 실행할 Android 기기를 선택합니다. 
   **Install** 섹션에서 Android 대상 기기를 만들었습니다.

3. 앱을 실행하려면, 다음 선택 사항 중 하나를 선택합니다.

   {:type="a"}
   1. 툴바에서 실행 아이콘을 클릭합니다.

   2. **Run** <span aria-label="and then">></span> **Run**으로 이동합니다.

   3. <kbd>Ctrl</kbd> + <kbd>R</kbd>을 누릅니다.

{% capture save_changes -%}
  : **Save All**을 호출하거나, **Hot Reload**를 클릭하세요.
  {% render docs/install/test-drive/hot-reload-icon.md %}.
{% endcapture %}

{% capture ide_profile -%}
  IDE에서 **Run > Profile** 메뉴 항목을 호출하거나,
{% endcapture %}

{% include docs/install/test-drive/try-hot-reload.md save_changes=save_changes ide="Android Studio" %}

[Main IntelliJ toolbar]: /assets/images/docs/tools/android-studio/main-toolbar.png
[Material Components]: {{site.material}}/components

</div>
