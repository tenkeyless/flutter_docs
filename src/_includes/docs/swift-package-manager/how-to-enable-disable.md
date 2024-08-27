## Swift Package Manager를 켜는 방법 {:#how-to-turn-on-swift-package-manager}

Flutter의 Swift Package Manager 지원은 기본적으로 꺼져 있습니다. 켜려면:

1. Flutter의 `main` 채널로 전환:

   ```sh
   flutter channel main --no-cache-artifacts
   ```

2. 최신 Flutter SDK로 업그레이드하고 아티팩트를 다운로드하세요.

   ```sh
   flutter upgrade
   ```

3. Swift Package Manager 기능을 켜세요:

   ```sh
   flutter config --enable-swift-package-manager
   ```

Flutter CLI를 사용하여 앱을 실행하면 [프로젝트를 마이그레이션][addSPM]하여, 
Swift Package Manager 통합을 추가합니다. 
이렇게 하면 프로젝트에서 Flutter 플러그인이 의존하는 Swift 패키지를 다운로드합니다. 
Swift Package Manager 통합이 있는 앱에는 Flutter 버전 3.24 이상이 필요합니다. 
이전 Flutter 버전을 사용하려면 앱에서 [Swift Package Manager 통합 제거][removeSPM]해야 합니다.

Flutter는 아직 Swift Package Manager를 지원하지 않는 종속성의 경우, CocoaPods로 폴백합니다.

## Swift Package Manager를 끄는 방법 {:#how-to-turn-off-swift-package-manager}

:::secondary 플러그인 작성자
플러그인 작성자는 테스트를 위해 Flutter의 Swift Package Manager 지원을 켜고 꺼야 합니다. 
앱 개발자는 문제가 발생하지 않는 한 Swift Package Manager 지원을 비활성화할 필요가 없습니다.

Flutter의 Swift Package Manager 지원에서 버그를 발견하면 [문제를 엽니다][open an issue].
:::

Swift Package Manager를 비활성화하면, 
Flutter가 모든 종속성에 CocoaPods를 사용합니다. 
그러나, Swift Package Manager는 프로젝트와 통합된 상태로 유지됩니다. 
프로젝트에서 Swift Package Manager 통합을 완전히 제거하려면, 
[Swift Package Manager 통합 제거 방법][removeSPM] 지침을 따르세요.

### 단일 프로젝트에 대해 끄기 {:#turn-off-for-a-single-project}

프로젝트의 `pubspec.yaml` 파일에서, 
`flutter` 섹션 아래에 `disable-swift-package-manager: true`를 추가합니다.

```yaml title="pubspec.yaml"
# 다음 섹션은 Flutter 패키지에 관한 내용입니다.
flutter:
  disable-swift-package-manager: true
```

이렇게 하면 이 프로젝트에 참여한 모든 기여자에 대해 Swift Package Manager가 해제됩니다.

### 모든 프로젝트에 대해 전역적으로 끄기 {:#turn-off-globally-for-all-projects}

다음 명령을 실행하세요.

```sh
flutter config --no-enable-swift-package-manager
```

이렇게 하면, 현재 사용자의 Swift Package Manager가 꺼집니다.

프로젝트가 Swift Package Manager와 호환되지 않는 경우, 
모든 기여자는 이 명령을 실행해야 합니다.

[addSPM]: /packages-and-plugins/swift-package-manager/for-app-developers/#how-to-add-swift-package-manager-integration
[removeSPM]: /packages-and-plugins/swift-package-manager/for-app-developers#how-to-remove-swift-package-manager-integration
[open an issue]: {{site.github}}/flutter/flutter/issues/new?template=2_bug.yml
