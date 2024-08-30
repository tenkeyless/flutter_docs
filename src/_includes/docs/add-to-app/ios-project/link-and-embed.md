Flutter 플러그인은 [정적 또는 동적 프레임워크][static or dynamic frameworks]를 생성할 수 있습니다.
정적 프레임워크를 연결하고, [_절대_ 임베드하지 마세요][static-framework].

iOS 앱에 정적 프레임워크를 임베드하는 경우, 해당 앱을 App Store에 게시할 수 없습니다. 
`Found an unexpected Mach-O header code`라는 아카이브 오류로 게시가 실패합니다.

##### 모든 프레임워크 연결 (Link all frameworks)

필요한 프레임워크를 연결하려면, 다음 절차를 따르세요.

1. 연결할 프레임워크를 선택합니다.

   1. **Project Navigator**에서 프로젝트를 클릭합니다.

   2. **Build Phases** 탭을 클릭합니다.

   3. **Link Binary With Libraries**을 확장합니다.

      {% render docs/captioned-image.liquid,
      image:"development/add-to-app/ios/project-setup/linked-libraries.png",
      caption:"Xcode에서 **Link Binary With Libraries** 빌드 단계 확장" %}

   4. **+**(더하기 기호)를 클릭합니다.

   5. **Add Other...** 를 클릭한 다음 **Add Files...** 를 클릭합니다.

   6. **Choose frameworks and libraries to add:** 대화 상자에서
      `/path/to/MyApp/Flutter/Release/` 디렉토리로 이동합니다.

   7. 해당 디렉토리에서 프레임워크를 Command-클릭한 다음 **Open**를 클릭합니다.

      {% render docs/captioned-image.liquid,
      image:"development/add-to-app/ios/project-setup/choose-libraries.png",
      caption:"Xcode의 **Choose frameworks and libraries to add:** 대화 상자에서 링크할 프레임워크를 선택하세요." %}

2. 빌드 모드를 고려하여, 라이브러리 경로를 업데이트합니다.

   1. Finder를 시작합니다.

   2. `/path/to/MyApp/` 디렉토리로 이동합니다.

   3. `MyApp.xcodeproj`를 마우스 오른쪽 버튼으로 클릭하고, 
      **Show Package Contents**를 선택합니다.

   4. Xcode로 `project.pbxproj`를 엽니다. 
      파일이 Xcode의 텍스트 편집기에서 열립니다. 
      이렇게 하면 텍스트 편집기를 닫을 때까지 **Project Navigator**도 잠깁니다.

      {% render docs/captioned-image.liquid,
      image:"development/add-to-app/ios/project-setup/project-pbxproj.png",
      caption:"Xcode 텍스트 편집기에서 열리는 `project-pbxproj` 파일" %}

   5. `/* Begin PBXFileReference section */`에서 다음 텍스트와 비슷한 줄을 찾으세요.

      ```text
      312885572C1A441C009F74FF /* Flutter.xcframework */ = {
        isa = PBXFileReference;
        expectedSignature = "AppleDeveloperProgram:S8QB4VV633:FLUTTER.IO LLC";
        lastKnownFileType = wrapper.xcframework;
        name = Flutter.xcframework;
        path = Flutter/[!Release!]/Flutter.xcframework;
        sourceTree = "<group>";
      };
      312885582C1A441C009F74FF /* App.xcframework */ = {
        isa = PBXFileReference;
        lastKnownFileType = wrapper.xcframework;
        name = App.xcframework;
        path = Flutter/[!Release!]/App.xcframework;
        sourceTree = "<group>";
      };
      ```

   6. 이전 단계에서 강조 표시된 `Release` 텍스트를 `$(CONFIGURATION)`로 변경합니다. 
      또한 경로를 따옴표로 묶습니다.

      ```text
      312885572C1A441C009F74FF /* Flutter.xcframework */ = {
        isa = PBXFileReference;
        expectedSignature = "AppleDeveloperProgram:S8QB4VV633:FLUTTER.IO LLC";
        lastKnownFileType = wrapper.xcframework;
        name = Flutter.xcframework;
        path = [!"!]Flutter/[!$(CONFIGURATION)!]/Flutter.xcframework[!"!];
        sourceTree = "<group>";
      };
      312885582C1A441C009F74FF /* App.xcframework */ = {
        isa = PBXFileReference;
        lastKnownFileType = wrapper.xcframework;
        name = App.xcframework;
        path = [!"!]Flutter/[!$(CONFIGURATION)!]/App.xcframework[!"!];
        sourceTree = "<group>";
      };
      ```

3. 검색 경로를 업데이트합니다.

   1. **Build Settings** 탭을 클릭합니다.

   2. **Search Paths**로 이동합니다.

   3. **Framework Search Paths** 오른쪽을 두 번 클릭합니다.

   4. 콤보 상자에서, **+**(더하기 기호)를 클릭합니다.

   5. `$(inherited)`를 입력하고, <kbd>Enter</kbd>를 누릅니다.

   6. **+**(더하기 기호)를 클릭합니다.

   7. `$(PROJECT_DIR)/Flutter/$(CONFIGURATION)/`를 입력하고, 
      <kbd>Enter</kbd>를 누릅니다.

      {% render docs/captioned-image.liquid, image:"development/add-to-app/ios/project-setup/framework-search-paths.png", caption:"Xcode에서 **Framework Search Paths** 업데이트" %}

프레임워크를 연결한 후에는, 
타겟의 **General** 설정의 **Frameworks, Libraries, and Embedded Content** 섹션에 표시되어야 합니다.

##### 동적 프레임워크 임베드 (Embed the dynamic frameworks)

동적 프레임워크를 임베드하려면, 다음 절차를 완료하세요.

1. **General** <span aria-label="and then">></span> 
   **Frameworks, Libraries, and Embedded Content**로 이동합니다.

2. 각 동적 프레임워크를 클릭하고 **Embed & Sign**을 선택합니다.

   {% render docs/captioned-image.liquid,
   image:"development/add-to-app/ios/project-setup/choose-to-embed.png",
   caption:"Xcode에서 각 프레임워크에 대해 **Embed & Sign**을 선택하세요." %}

   `FlutterPluginRegistrant.xcframework`를 포함하여, 정적 프레임워크를 포함하지 마세요.

3. **Build Phases** 탭을 클릭합니다.

4. **Embed Frameworks**를 확장합니다. 당신의 동적 프레임워크가 해당 섹션에 표시되어야 합니다.

   {% render docs/captioned-image.liquid,
   image:"development/add-to-app/ios/project-setup/embed-xcode.png",
   caption:"Xcode의 확장된 **Embed Frameworks** 빌드 단계" %}

5. 프로젝트를 빌드합니다.

   1. Xcode에서 `MyApp.xcworkspace`를 엽니다.

      `MyApp.xcworkspace`를 열고, `MyApp.xcodeproj`를 열지 않는지 확인합니다. 
      `.xcworkspace` 파일에는 CocoaPod 종속성이 있지만, `.xcodeproj`에는 없습니다.

   2. **Product** <span aria-label="and then">></span> **Build**를 선택하거나, 
      <kbd>Cmd</kbd> + <kbd>B</kbd>를 누릅니다.

[static or dynamic frameworks]: https://stackoverflow.com/questions/32591878/ios-is-it-a-static-or-a-dynamic-framework
[static-framework]: https://developer.apple.com/library/archive/technotes/tn2435/_index.html
