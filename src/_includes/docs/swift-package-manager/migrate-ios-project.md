[Swift Package Manager를 켜면][turn on Swift Package Manager], Flutter CLI는 다음에 CLI를 사용하여 앱을 실행할 때 프로젝트를 마이그레이션하려고 시도합니다. 
이 마이그레이션은 Swift Package Manager를 사용하여 Flutter 플러그인 종속성을 추가하도록 Xcode 프로젝트를 업데이트합니다.

프로젝트를 마이그레이션하려면:

1. [Swift Package Manager를 켜세요][Turn on Swift Package Manager].

2. Flutter CLI를 사용하여 iOS 앱을 실행합니다.

   iOS 프로젝트에 아직 Swift Package Manager 통합이 없는 경우, 
   Flutter CLI는 프로젝트를 마이그레이션하려고 시도하고, 
   다음과 같은 내용을 출력합니다.

   ```console
   $ flutter run
   Adding Swift Package Manager integration...
   ```

   자동 iOS 마이그레이션은 `ios/Runner.xcodeproj/project.pbxproj` 및 `ios/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme` 파일을 수정합니다.

3. Flutter CLI의 자동 마이그레이션이 실패하면, 
   [Swift Package Manager 통합 수동으로 추가][manualIntegration]의 단계를 따르세요.

[선택 사항] 프로젝트가 마이그레이션되었는지 확인하려면:

1. Xcode에서 앱을 실행합니다.
2. **Run Prepare Flutter Framework Script**가 사전 작업(pre-action)으로 실행되고, `FlutterGeneratedPluginSwiftPackage`가 대상 종속성인지 확인합니다.

   {% render docs/captioned-image.liquid,
   image:"development/packages-and-plugins/swift-package-manager/flutter-pre-action-build-log.png",
   caption:"**Run Prepare Flutter Framework Script**가 사전 작업(pre-action)으로 실행되도록 합니다. %}

[Turn on Swift Package Manager]: /packages-and-plugins/swift-package-manager/for-app-developers/#how-to-turn-on-swift-package-manager
[manualIntegration]: /packages-and-plugins/swift-package-manager/for-app-developers/#add-to-a-flutter-app-manually
