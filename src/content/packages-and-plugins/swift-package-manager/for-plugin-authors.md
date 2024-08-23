---
# title: Swift Package Manager for plugin authors
title: 플러그인 작성자를 위한 Swift Package Manager
# description: How to add Swift Package Manager compatibility to iOS and macOS plugins
description: iOS 및 macOS 플러그인에 Swift Package Manager 호환성을 추가하는 방법
diff2html: true
---

:::warning
Flutter는 iOS 및 macOS 네이티브 종속성을 관리하기 위해, [Swift Package Manager][]로 마이그레이션하고 있습니다. 
Flutter의 Swift Package Manager 지원은 개발 중입니다. 구현은 향후 변경될 수 있습니다. 
Swift Package Manager 지원은 [`main` 채널][`main` channel]에서만 제공됩니다. 
Flutter는 CocoaPods를 계속 지원합니다.
:::

Flutter의 Swift Package Manager 통합에는 여러 가지 이점이 있습니다.

1. **Swift 패키지 생태계에 액세스**.
   Flutter 플러그인은 [Swift 패키지][Swift packages]의 성장하는 생태계를 사용할 수 있습니다!
2. **Flutter 설치를 간소화**.
   Swift Package Manager는 Xcode와 함께 번들로 제공됩니다. 
   앞으로는, iOS 또는 macOS를 대상으로 Ruby와 CocoaPods를 설치할 필요가 없습니다.

Flutter의 Swift Package Manager 지원에서 버그를 발견하면, [문제를 엽니다][open an issue].

[Swift Package Manager]: https://www.swift.org/documentation/package-manager/
[`main` channel]: /release/upgrade#switching-flutter-channels
[Swift packages]: https://swiftpackageindex.com/
[open an issue]: {{site.github}}/flutter/flutter/issues/new?template=2_bug.yml

{% include docs/swift-package-manager/how-to-enable-disable.md %}

## 기존 Flutter 플러그인에 Swift Package Manager 지원을 추가하는 방법 {:#how-to-add-swift-package-manager-support-to-an-existing-flutter-plugin}

이 가이드에서는 CocoaPods를 이미 지원하는 플러그인에 Swift Package Manager 지원을 추가하는 방법을 보여줍니다. 
이렇게 하면 모든 Flutter 프로젝트에서 플러그인을 사용할 수 있습니다.

Flutter 플러그인은 별도 공지가 있을 때까지 Swift Package Manager와 CocoaPods를 _둘 다_ 지원해야 합니다.

Swift Package Manager 채택은 점진적으로 이루어질 것입니다. 
CocoaPods를 지원하지 않는 플러그인은 아직 Swift Package Manager로 마이그레이션하지 않은 프로젝트에서 사용할 수 없습니다. 
Swift Package Manager를 지원하지 않는 플러그인은 마이그레이션한 프로젝트에 문제를 일으킬 수 있습니다.

{% tabs %}
{% tab "Swift 플러그인" %}

{% include docs/swift-package-manager/migrate-swift-plugin.md %}

{% endtab %}
{% tab "Objective-C 플러그인" %}

{% include docs/swift-package-manager/migrate-objective-c-plugin.md %}

{% endtab %}
{% endtabs %}

## 플러그인의 예제 앱에서 유닛 테스트를 업데이트하는 방법 {:#how-to-update-unit-tests-in-a-plugins-example-app}

플러그인에 네이티브 XCTests가 있는 경우, 
다음 중 하나가 true이면 Swift Package Manager에서 작동하도록 업데이트해야 할 수 있습니다.

* 테스트에 CocoaPod 종속성을 사용하고 있습니다.
* 플러그인이 `Package.swift` 파일에서 `type: .dynamic`으로 명시적으로 설정되어 있습니다.

유닛 테스트를 업데이트하려면 다음을 수행합니다.

1. Xcode에서 `example/ios/Runner.xcworkspace`를 엽니다.

2. (`OCMock`와 같이) 테스트에 CocoaPod 종속성을 사용했다면, `Podfile` 파일에서 해당 종속성을 제거해야 합니다.

   ```diff2html
   --- a/ios/Podfile
   +++ b/ios/Podfile
   @@ -33,7 +33,6 @@ target 'Runner' do
      target 'RunnerTests' do
        inherit! :search_paths
   
   -    pod 'OCMock', '3.5'
      end
    end
   ```

   그런 다음 터미널에서, `plugin_name_ios/example/ios` 디렉토리에서 `pod install`을 실행합니다.

3. 프로젝트의 **Package Dependencies**으로 이동합니다.

   {% render docs/captioned-image.liquid,
   image:"development/packages-and-plugins/swift-package-manager/package-dependencies.png",
   caption:"프로젝트의 패키지 종속성" %}

4. **+** 버튼을 클릭하고, 오른쪽 상단 검색 창에서 테스트 전용 종속성을 검색하여 추가합니다.

   {% render docs/captioned-image.liquid,
   image:"development/packages-and-plugins/swift-package-manager/search-for-ocmock.png",
   caption:"테스트 전용 종속성 검색" %}

   :::note
   OCMock은 안전하지 않은 빌드 플래그를 사용하며 커밋의 대상이 되는 경우에만 사용할 수 있습니다.
   `fe1661a3efed11831a6452f4b1a0c5e6ddc08c3d`는 3.9.3 버전의 커밋입니다.
   :::

5. 종속성이 `RunnerTests` 대상에 추가되었는지 확인하세요.

   {% render docs/captioned-image.liquid,
   image:"development/packages-and-plugins/swift-package-manager/choose-package-products-test.png",
   caption:"종속성이 `RunnerTests` 대상에 추가되었는지 확인하세요." %}

6. **Add Package** 버튼을 클릭합니다.

7. 플러그인의 라이브러리 타입을 `Package.swift` 파일에서 `.dynamic`으로 명시적으로 설정한 경우,
   ([Apple에서 권장하지 않음][library type recommendations]), `RunnerTests` 대상에 종속성으로 추가해야 합니다.

   1. `RunnerTests` **Build Phases**에 **Link Binary With Libraries** 빌드 단계가 있는지 확인하세요.
   
      {% render docs/captioned-image.liquid,
      image:"development/packages-and-plugins/swift-package-manager/runner-tests-link-binary-with-libraries.png",
      caption:"`RunnerTests` 대상의 `Link Binary With Libraries` 빌드 단계" %}

      빌드 단계가 아직 없다면 하나 만드세요. 
      <span class="material-symbols-outlined">add</span> 를 클릭한 다음, 
      **New Link Binary With Libraries Phase**를 클릭하세요.

      {% render docs/captioned-image.liquid,
      image:"development/packages-and-plugins/swift-package-manager/add-runner-tests-link-binary-with-libraries.png",
      caption:"`Link Binary With Libraries` 빌드 단계 추가" %}

   2. 프로젝트의 **Package Dependencies**으로 이동합니다.

   3. <span class="material-symbols-outlined">add</span>를 클릭합니다.

   4. 열리는 대화 상자에서 **Add Local...** 버튼을 클릭합니다.

   5. `plugin_name/plugin_name_ios/ios/plugin_name_ios`로 이동하여 **Add Package** 버튼을 클릭합니다.

   6. `RunnerTests` 대상에 추가되었는지 확인하고 **Add Package** 버튼을 클릭합니다.

8. 테스트가 **Product > Test**를 통과하는지 확인합니다.

[library type recommendations]: https://developer.apple.com/documentation/packagedescription/product/library(name:type:targets:)
