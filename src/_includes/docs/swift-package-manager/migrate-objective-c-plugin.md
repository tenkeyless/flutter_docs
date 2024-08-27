이 가이드 전체에서 `plugin_name`을 플러그인 이름으로 바꾸세요. 
아래 예에서는 `ios`를 사용하는데, `ios`를 해당되는 경우 `macos`/`darwin`으로 바꾸세요.

1. [Swift Package Manager 기능 켜기][enableSPM].

2. `ios`, `macos`, 및/또는 `darwin` 디렉토리 아래에 디렉토리를 만드는 것으로 시작합니다. 
   이 새 디렉토리의 이름을 플랫폼 패키지의 이름으로 지정합니다.

   <pre>
   plugin_name/ios/
   ├── ...
   └── <b>plugin_name/</b>
   </pre>

3. 이 새로운 디렉토리 내에, 다음 파일/디렉토리를 생성하세요.

    - `Package.swift` (파일)
    - `Sources` (디렉토리)
    - `Sources/plugin_name` (디렉토리)
    - `Sources/plugin_name/include` (디렉토리)
    - `Sources/plugin_name/include/plugin_name` (디렉토리)
    - `Sources/plugin_name/include/plugin_name/.gitkeep` (파일)
      - 이 파일은 디렉토리가 커밋되도록 보장합니다.
        다른 파일이 디렉토리에 추가되면, 
        `.gitkeep` 파일을 제거할 수 있습니다.

   플러그인은 다음과 같이 됩니다.

   <pre>
   plugin_name/ios/
   ├── ...
   └── plugin_name/
      ├── <b>Package.swift</b>
      └── <b>Sources/plugin_name/include/plugin_name/</b>
         └── <b>.gitkeep</b>
   </pre>

4. `Package.swift` 파일에서 다음 템플릿을 사용하세요.

   ```swift title="Package.swift"
   // swift-tools-version: 5.9
   // swift-tools-version은 이 패키지를 빌드하는 데 필요한 최소 Swift 버전을 선언합니다.
   
   import PackageDescription
   
   let package = Package(
       // TODO: 당신의 플러그인 이름으로 업데이트하세요.
       name: "plugin_name",
       platforms: [
           // TODO: 당신의 플러그인이 지원하는 플랫폼을 업데이트하세요.
           // 플러그인이 iOS만 지원하는 경우, `.macOS(...)`를 제거하세요.
           // 플러그인이 macOS만 지원하는 경우, `.iOS(...)`를 제거하세요.
           .iOS("12.0"),
           .macOS("10.14")
       ],
       products: [
           // TODO: 당신의 라이브러리와 타겟 이름을 업데이트하세요.
           // 플러그인 이름에 "_"가 포함되어 있으면, 라이브러리 이름을 "-"로 바꾸세요.
           .library(name: "plugin-name", targets: ["plugin_name"])
       ],
       dependencies: [],
       targets: [
           .target(
               // TODO: 당신의 타겟 이름을 업데이트하세요.
               name: "plugin_name",
               dependencies: [],
               resources: [
                   // TODO: 플러그인에 개인 정보 보호 매니페스트가 필요한 경우 (예: required reason API를 사용하는 경우), 
                   // PrivacyInfo.xcprivacy 파일을 업데이트하여, 
                   // 플러그인의 개인 정보 보호 영향을 설명한 다음, 이 줄의 주석 처리를 제거합니다. 
                   // 자세한 내용은 https://developer.apple.com/documentation/bundleresources/privacy_manifest_files 를 참조하세요.
                   // .process("PrivacyInfo.xcprivacy")

                   // TODO: 플러그인과 함께 번들로 제공해야 하는 다른 리소스가 있는 경우, 다음 지침을 참조하여 추가합니다. 
                   // https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package
               ],
               cSettings: [
                   // TODO: 당신의 플러그인 이름을 업데이트하세요.
                   .headerSearchPath("include/plugin_name")
               ]
           )
       ]
   )
   ```

5. `Package.swift` 파일에서 [지원되는 플랫폼][supported platforms]을 업데이트하세요.

   ```swift title="Package.swift"
       platforms: [
           // TODO: 당신의 플러그인이 지원하는 플랫폼을 업데이트하세요.
           // 플러그인이 iOS만 지원하는 경우, `.macOS(...)`를 제거하세요.
           // 플러그인이 macOS만 지원하는 경우, `.iOS(...)`를 제거하세요.
           [!.iOS("12.0"),!]
           [!.macOS("10.14")!]
       ],
   ```

   [supported platforms]: https://developer.apple.com/documentation/packagedescription/supportedplatform

6. `Package.swift` 파일에서 패키지, 라이브러리 및 타겟 이름을 업데이트합니다.

   ```swift title="Package.swift"
   let package = Package(
       // TODO: 당신의 플러그인 이름을 업데이트하세요.
       name: [!"plugin_name"!],
       platforms: [
           .iOS("12.0"),
           .macOS("10.14")
       ],
       products: [
           // TODO: 당신의 라이브러리 및 타겟 이름을 업데이트하세요.
           // 플러그인 이름에 "_"가 포함되어 있으면 라이브러리 이름을 "-"로 바꾸세요.
           .library(name: [!"plugin-name"!], targets: [[!"plugin_name"!]])
       ],
       dependencies: [],
       targets: [
           .target(
               // TODO: 당신의 타겟 이름을 업데이트하세요.
               name: [!"plugin_name"!],
               dependencies: [],
               resources: [
                   // TODO: 플러그인에 개인 정보 보호 매니페스트가 필요한 경우 (예: required reason API를 사용하는 경우), 
                   // PrivacyInfo.xcprivacy 파일을 업데이트하여, 
                   // 플러그인의 개인 정보 보호 영향을 설명한 다음, 이 줄의 주석 처리를 제거합니다. 
                   // 자세한 내용은 https://developer.apple.com/documentation/bundleresources/privacy_manifest_files 를 참조하세요.
                   // .process("PrivacyInfo.xcprivacy")

                   // TODO: 플러그인과 함께 번들로 제공해야 하는 다른 리소스가 있는 경우, 다음 지침을 참조하여 추가합니다. 
                   // https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package
               ],
               cSettings: [
                   // TODO: 당신의 플러그인 이름을 업데이트하세요.
                   .headerSearchPath("include/[!plugin_name!]")
               ]
           )
       ]
   )
   ```

   :::note
   플러그인 이름에 `_`가 포함되어 있는 경우, 라이브러리 이름은 플러그인 이름을 `-`로 구분한 버전이어야 합니다.
   :::

7. 플러그인에 [`PrivacyInfo.xcprivacy` 파일][`PrivacyInfo.xcprivacy` file]이 있는 경우, 
   이를 `ios/plugin_name/Sources/plugin_name/PrivacyInfo.xcprivacy`로 이동하고, 
   `Package.swift` 파일에서 리소스의 주석 처리를 제거합니다.

   ```swift title="Package.swift"
               resources: [
                   // TODO: 플러그인에 개인 정보 보호 매니페스트가 필요한 경우 (예: required reason API를 사용하는 경우), 
                   // PrivacyInfo.xcprivacy 파일을 업데이트하여, 
                   // 플러그인의 개인 정보 보호 영향을 설명한 다음, 이 줄의 주석 처리를 제거합니다. 
                   // 자세한 내용은 https://developer.apple.com/documentation/bundleresources/privacy_manifest_files 를 참조하세요.
                   [!.process("PrivacyInfo.xcprivacy"),!]
   
                   // TODO: 플러그인과 함께 번들로 제공해야 하는 다른 리소스가 있는 경우, 다음 지침을 참조하여 추가합니다. 
                   // https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package
               ],
   ```

1. `ios/Assets`에서 `ios/plugin_name/Sources/plugin_name`(또는 하위 디렉토리)으로 
   모든 리소스 파일을 이동합니다. 
   해당되는 경우, 리소스 파일을 `Package.swift` 파일에 추가합니다. 
   자세한 지침은 [https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package](https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package)를 참조하세요.

2. `ios/Classes`에서 `ios/plugin_name/Sources/plugin_name/include/plugin_name`으로 
   모든 공개 헤더를 이동합니다.

   * 어떤 헤더가 public인지 확실하지 않으면, 
     `podspec` 파일의 [`public_header_files`][] 속성을 확인하세요. 
     이 속성이 지정되지 않은 경우, 모든 헤더가 public 입니다. 
     모든 헤더를 public으로 할지 여부를 고려해야 합니다.

   * `pubspec.yaml` 파일에 정의된
     `pluginClass`는 public 이어야 하며, 이 디렉토리 내에 있어야 합니다.

1.  `modulemap` 처리.

    플러그인에 `modulemap`이 없으면, 이 단계를 건너뜁니다.

    CocoaPods에서 `modulemap`을 사용하여 테스트 하위 모듈을 만드는 경우, 
    Swift Package Manager에서 제거하는 것을 고려하세요. 
    이렇게 하면 모든 공개 헤더를 모듈을 통해 사용할 수 있습니다.

   Swift Package Manager의 `modulemap`을 제거하지만 CocoaPods의 경우 유지하려면, 
   플러그인의 `Package.swift` 파일에서 `modulemap`과 엄브렐라 헤더를 제외합니다.

   아래 예에서는 `modulemap`과 엄브렐라 헤더가 `ios/plugin_name/Sources/plugin_name/include` 
   디렉토리에 있다고 가정합니다.

    ```swift title="Package.swift" diff
      .target(
          name: "plugin_name",
          dependencies: [],
    +     exclude: ["include/cocoapods_plugin_name.modulemap", "include/plugin_name-umbrella.h"],
    ```

    CocoaPods와 Swift Package Manager 모두와 유닛 테스트의 호환성을 유지하려면 다음을 시도해 보세요.

    ```objc title="Tests/TestFile.m" diff
      @import plugin_name;
    - @import plugin_name.Test;
    + #if __has_include(<plugin_name/plugin_name-umbrella.h>)
    +   @import plugin_name.Test;
    + #endif
    ```

    Swift 패키지와 함께 커스텀 `modulemap`을 사용하려면, [Swift Package Manager 문서][Swift Package Manager's documentation]를 ​​참조하세요.

1.  `ios/Classes`에서 `ios/plugin_name/Sources/plugin_name`으로 모든 파일을 이동합니다.

2.  `ios/Assets`, `ios/Resources`, `ios/Classes` 디렉토리는 이제 비어 있어야 하며 삭제할 수 있습니다.

3.  헤더 파일이 구현 파일과 더 이상 같은 디렉토리에 없는 경우, import 문을 업데이트해야 합니다.

    예를 들어, 다음 마이그레이션을 상상해 보세요.
   
    * 이전:

      <pre>
      ios/Classes/
      ├── PublicHeaderFile.h
      └── ImplementationFile.m
      </pre>

    * 이후:

      <pre>
      ios/plugin_name/Sources/plugin_name/
      └── <b>include/plugin_name/</b>
         └── PublicHeaderFile.h
      └── ImplementationFile.m
      </pre>

   이 예에서, `ImplementationFile.m`의 import 문은 다음과 같이 업데이트되어야 합니다.

   ```objc title="Sources/plugin_name/ImplementationFile.m" diff
   - #import "PublicHeaderFile.h"
   + #import "./include/plugin_name/PublicHeaderFile.h"
   ```

4. 플러그인이 [Pigeon][]을 사용하는 경우, Pigeon 입력 파일을 업데이트하세요.

   ```dart title="pigeons/messages.dart" diff
     javaOptions: JavaOptions(),
   - objcHeaderOut: 'ios/Classes/messages.g.h',
   - objcSourceOut: 'ios/Classes/messages.g.m',
   + objcHeaderOut: 'ios/plugin_name/Sources/plugin_name/messages.g.h',
   + objcSourceOut: 'ios/plugin_name/Sources/plugin_name/messages.g.m',
     copyrightHeader: 'pigeons/copyright.txt',
   ```

   `objcHeaderOut` 파일이 더 이상 `objcSourceOut`과 같은 디렉토리에 없으면, 
   `ObjcOptions.headerIncludePath`를 사용하여 `#import`를 변경할 수 있습니다.

   ```dart title="pigeons/messages.dart" diff
     javaOptions: JavaOptions(),
   - objcHeaderOut: 'ios/Classes/messages.g.h',
   - objcSourceOut: 'ios/Classes/messages.g.m',
   + objcHeaderOut: 'ios/plugin_name/Sources/plugin_name/include/plugin_name/messages.g.h',
   + objcSourceOut: 'ios/plugin_name/Sources/plugin_name/messages.g.m',
   + objcOptions: ObjcOptions(
   +   headerIncludePath: './include/plugin_name/messages.g.h',
   + ),
     copyrightHeader: 'pigeons/copyright.txt',
   ```

   Pigeon을 실행하여 최신 구성으로 코드를 다시 생성합니다.

5. 필요한 커스터마이즈 내용으로 `Package.swift` 파일을 업데이트하세요.

   1. Xcode에서 `ios/plugin_name/` 디렉토리를 엽니다.

   2. Xcode에서 `Package.swift` 파일을 엽니다. 
      Xcode가 이 파일에 대한 경고나 오류를 생성하지 않는지 확인합니다.

      :::tip
      Xcode에 파일이 표시되지 않으면, Xcode를 종료하고(**Xcode > Quit Xcode**) 다시 엽니다.
 
      변경한 후 Xcode가 업데이트되지 않으면, **File > Packages > Reset Package Caches**을 클릭해 보세요.
      :::

   3. `ios/plugin_name.podspec` 파일에 [CocoaPods `dependency`][]가 있는 경우, 
      해당 [Swift Package Manager 종속성][Swift Package Manager dependencies]을 `Package.swift` 파일에 추가합니다.

   4. 패키지가 명시적으로 `static` 또는 `dynamic`으로 연결되어야 하는 경우([Apple에서 권장하지 않음][not recommended by Apple]), 
      [Product][]를 업데이트하여 타입을 정의합니다.

      ```swift title="Package.swift"
      products: [
         .library(name: "plugin-name", type: .static, targets: ["plugin_name"])
      ],
      ```

   5. 다른 커스터마이즈를 합니다. 
      `Package.swift` 파일을 작성하는 방법에 대한 자세한 내용은 [https://developer.apple.com/documentation/packagedescription](https://developer.apple.com/documentation/packagedescription)을 참조하세요.
 
      :::tip
      `Package.swift` 파일에 타겟을 추가하는 경우 고유한(unique) 이름을 사용하세요. 
      이렇게 하면 다른 패키지의 타겟과 충돌하는 것을 피할 수 있습니다.
      :::

6. `ios/plugin_name.podspec`을 업데이트하여 새로운 경로를 가리키도록 합니다.

   ```ruby title="ios/plugin_name.podspec" diff
   - s.source_files = 'Classes/**/*.{h,m}'
   - s.public_header_files = 'Classes/**/*.h'
   - s.module_map = 'Classes/cocoapods_plugin_name.modulemap'
   - s.resource_bundles = {'plugin_name_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
   + s.source_files = 'plugin_name/Sources/plugin_name/**/*.{h,m}'
   + s.public_header_files = 'plugin_name/Sources/plugin_name/include/**/*.h'
   + s.module_map = 'plugin_name/Sources/plugin_name/include/cocoapods_plugin_name.modulemap'
   + s.resource_bundles = {'plugin_name_privacy' => ['plugin_name/Sources/plugin_name/PrivacyInfo.xcprivacy']}
   ```

7. `SWIFTPM_MODULE_BUNDLE`을 사용하기 위해 번들에서 리소스 로딩을 업데이트합니다.

   ```objc
   #if SWIFT_PACKAGE
      NSBundle *bundle = SWIFTPM_MODULE_BUNDLE;
    #else
      NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    #endif
    NSURL *imageURL = [bundle URLForResource:@"image" withExtension:@"jpg"];
   ```

   :::note
   `SWIFTPM_MODULE_BUNDLE`은 실제 리소스가 있는 경우에만 작동합니다.
   ([`Package.swift` 파일에 정의됨][Bundling resources] 또는 [Xcode에서 자동으로 포함됨][Xcode resource detection])
   그렇지 않은 경우, `SWIFTPM_MODULE_BUNDLE`을 사용하면 오류가 발생합니다.
   :::

8.  `ios/Sources/plugin_name/include` 디렉토리에 `.gitkeep`만 포함되어 있는 경우, 
    `.gitignore`를 업데이트하여 다음을 포함해야 합니다.

    ```text title=".gitignore"
    !.gitkeep
    ```

    `flutter pub publish --dry-run`을 실행하여 `include` 디렉토리가 게시되었는지 확인하세요.

9.  플러그인의 변경 사항을 버전 제어 시스템(version control system)에 커밋합니다.

10. 플러그인이 CocoaPods에서 여전히 작동하는지 확인합니다.

    1. Swift Package Manager를 끕니다.

       ```sh
       flutter config --no-enable-swift-package-manager
       ```
      
       그렇지 않으면, Flutter 버전 3.24 이상이 설치되어 있지 않으면, 플러그인의 예제 앱이 빌드되지 않습니다.

    2. 플러그인의 예제 앱으로 이동합니다.

       ```sh
       cd path/to/plugin/example/
       ```

    3. 플러그인의 예제 앱이 빌드되고 실행되는지 확인하세요.

       ```sh
       flutter run
       ```

    4. 플러그인의 최상위 디렉토리로 이동합니다.

       ```sh
       cd path/to/plugin/
       ```

    5. CocoaPods 검증 린트를 실행합니다.

       ```sh
       pod lib lint ios/plugin_name.podspec  --configuration=Debug --skip-tests --use-modular-headers --use-libraries
       ```
 
       ```sh
       pod lib lint ios/plugin_name.podspec  --configuration=Debug --skip-tests --use-modular-headers
       ```

11. 플러그인이 Swift Package Manager와 작동하는지 확인하세요.

    1. Swift Package Manager를 켭니다.

       ```sh
       flutter config --enable-swift-package-manager
       ```

    2. 플러그인의 예제 앱으로 이동합니다.

       ```sh
       cd path/to/plugin/example/
       ```

    3. 플러그인의 예제 앱이 빌드되고 실행되는지 확인하세요.

       ```sh
       flutter run
       ```

       :::warning
       Flutter CLI를 사용하여 Swift Package Manager 기능을 켠 상태에서 플러그인의 예제 앱을 실행하면, 
       프로젝트가 마이그레이션되어 Swift Package Manager 통합이 추가됩니다.
 
       **마이그레이션의 변경 사항을 버전 제어 시스템에 커밋하지 마세요.**
 
       그렇지 않으면, Swift Package Manager 기능이 꺼져 있으면, 플러그인의 예제 앱이 빌드되지 않습니다.
 
       실수로 마이그레이션의 변경 사항을 플러그인의 예제 앱에 커밋한 경우, 
       [Swift Package Manager 마이그레이션 취소][removeSPM] 단계를 따르세요.
       :::

    4. Xcode에서 플러그인의 예제 앱을 엽니다. 
       왼쪽의 **Project Navigator**에 **Package Dependencies**가 표시되는지 확인합니다.

12. 테스트에 통과하는지 확인하세요.

    * **플러그인에 네이티브 유닛 테스트(XCTest)가 있는 경우, [플러그인의 예제 앱에서 유닛 테스트 업데이트][update unit tests in the plugin's example app]도 수행해야 합니다.**

    * [플러그인 테스트][testing plugins]에 대한 지침을 따르세요.

[enableSPM]: /packages-and-plugins/swift-package-manager/for-plugin-authors#how-to-turn-on-swift-package-manager
[`PrivacyInfo.xcprivacy` file]: https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
[`public_header_files`]: https://guides.cocoapods.org/syntax/podspec.html#public_header_files
[Swift Package Manager's documentation]: {{site.github}}/apple/swift-package-manager/blob/main/Documentation/Usage.md#creating-c-language-targets
[Pigeon]: https://pub.dev/packages/pigeon
[CocoaPods `dependency`]: https://guides.cocoapods.org/syntax/podspec.html#dependency
[Swift Package Manager dependencies]: https://developer.apple.com/documentation/packagedescription/package/dependency
[not recommended by Apple]: https://developer.apple.com/documentation/packagedescription/product/library(name:type:targets:)
[Product]: https://developer.apple.com/documentation/packagedescription/product
[Bundling resources]: https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package#Explicitly-declare-or-exclude-resources
[Xcode resource detection]: https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package#:~:text=Xcode%20detects%20common%20resource%20types%20for%20Apple%20platforms%20and%20treats%20them%20as%20a%20resource%20automatically
[removeSPM]: /packages-and-plugins/swift-package-manager/for-app-developers#how-to-remove-swift-package-manager-integration
[update unit tests in the plugin's example app]: /packages-and-plugins/swift-package-manager/for-plugin-authors/#how-to-update-unit-tests-in-a-plugins-example-app
[testing plugins]: https://docs.flutter.dev/testing/testing-plugins
