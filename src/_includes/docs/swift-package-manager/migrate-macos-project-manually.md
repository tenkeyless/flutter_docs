[Swift Package Manager를 켜면][turn on Swift Package Manager], 
Flutter CLI는 다음에 CLI를 사용하여 앱을 실행할 때, 
Swift Package Manager를 사용하도록 프로젝트를 마이그레이션하려고 시도합니다.

그러나, Flutter CLI 도구는 예상치 못한 수정 사항이 있는 경우, 
프로젝트를 자동으로 마이그레이션하지 못할 수 있습니다.

자동 마이그레이션이 실패하면, 
아래 단계에 따라 프로젝트에 Swift Package Manager 통합을 수동으로 추가하세요.

수동으로 마이그레이션하기 전에 [문제를 제출하세요][file an issue]. 
이렇게 하면 Flutter 팀이 자동 마이그레이션 프로세스를 개선하는 데 도움이 됩니다. 
오류 메시지를 포함하고, 가능하면 문제에 다음 파일의 사본을 포함하세요.

* `macos/Runner.xcodeproj/project.pbxproj`
* `macos/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme`(또는 사용된 플레이버의 xcscheme)

### 스텝 1: FlutterGeneratedPluginSwiftPackage 패키지 종속성 추가 {:#step-1-add-fluttergeneratedpluginswiftpackage-package-dependency-1 .no_toc}

1. Xcode에서 앱(`macos/Runner.xcworkspace`)을 엽니다.
1. 프로젝트의 **Package Dependencies**로 이동합니다.

   {% render docs/captioned-image.liquid,
   image:"development/packages-and-plugins/swift-package-manager/package-dependencies.png",
   caption:"프로젝트의 패키지 종속성" %}

2. <span class="material-symbols-outlined">add</span>를 클릭합니다.
3. 열리는 대화 상자에서 **Add Local...**를 클릭합니다.
4. `macos/Flutter/ephemeral/Packages/FlutterGeneratedPluginSwiftPackage`로 이동하여 **Add Package**를 클릭합니다.
5. Runner Target에 추가되었는지 확인하고 **Add Package**를 클릭합니다.

   {% render docs/captioned-image.liquid,
   image:"development/packages-and-plugins/swift-package-manager/choose-package-products.png",
   caption:"패키지가 `Runner` 대상에 추가되었는지 확인하세요." %}

6. `FlutterGeneratedPluginSwiftPackage`가 **Frameworks, Libraries, and Embedded Content**에 추가되었는지 확인하세요.
   
   {% render docs/captioned-image.liquid,
   image:"development/packages-and-plugins/swift-package-manager/add-generated-framework.png",
   caption:"`FlutterGeneratedPluginSwiftPackage`가 **Frameworks, Libraries, and Embedded Content**에 추가되었는지 확인하세요." %}

### 스텝 2: Flutter Framework 스크립트 사전 작업(Pre-Action) 실행 준비 추가 {:#step-2-add-run-prepare-flutter-framework-script-pre-action-1 .no_toc}

**각 플레이버에 대해 다음 단계를 완료해야 합니다.**

1. **Product > Scheme > Edit Scheme**으로 이동합니다.
1. 왼쪽 사이드바에서 **Build** 섹션을 확장합니다.
1. **Pre-actions**을 클릭합니다.
1. <span class="material-symbols-outlined">add</span> 버튼을 클릭하고, 
   메뉴에서 **New Run Script Action**을 선택합니다.
2. **Run Script** 제목을 클릭하고 다음과 같이 변경합니다.

   ```plaintext
   Run Prepare Flutter Framework Script
   ```

3. **Provide build settings from**을 `Runner` 대상으로 변경합니다.
4. 텍스트 상자에 다음을 입력합니다.

   ```sh
   "$FLUTTER_ROOT"/packages/flutter_tools/bin/macos_assemble.sh prepare
   ```

   {% render docs/captioned-image.liquid,
   image:"development/packages-and-plugins/swift-package-manager/add-flutter-pre-action.png",
   caption:"**Flutter Framework 스크립트 실행 준비** 빌드 사전 작업(pre-action) 추가" %}

### 스텝 3: 앱 실행 {:#step-3-run-app-1 .no_toc}

1. Xcode에서 앱을 실행합니다.
1. **Run Prepare Flutter Framework Script**가 사전 작업(pre-action)으로 실행되고, 
   `FlutterGeneratedPluginSwiftPackage`가 대상 종속성인지 확인합니다.

   {% render docs/captioned-image.liquid,
   image:"development/packages-and-plugins/swift-package-manager/flutter-pre-action-build-log.png",
   caption:"`Run Prepare Flutter Framework Script`가 사전 작업(pre-action)으로 실행되도록 합니다." %}

2. `flutter run`을 사용해 명령줄에서 앱이 실행되는지 확인하세요.

[turn on Swift Package Manager]: /packages-and-plugins/swift-package-manager/for-app-developers/#how-to-turn-on-swift-package-manager
[file an issue]: {{site.github}}/flutter/flutter/issues/new?template=2_bug.yml
