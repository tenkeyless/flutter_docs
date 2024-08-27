---
# title: Continuous delivery with Flutter
title: Flutter를 사용한 지속적인 배포(Continuous delivery)
# description: >
#   How to automate continuous building and releasing of your Flutter app.
description: >
  Flutter 앱의 지속적인(continuous) 빌드와 릴리스를 자동화하는 방법
---

Flutter를 사용하여 지속적인 배포 모범 사례를 따르면, 수동 워크플로를 사용하지 않고도, 
애플리케이션이 베타 테스터에게 제공되고 정기적으로 검증될 수 있습니다.

## CI/CD 옵션 {:#cicd-options}

애플리케이션 배포를 자동화하는 데 도움이 되는, 
다양한 CI(지속적인 통합, continuous integration) 및 CD(지속적인 배포, continuous delivery) 옵션을 사용할 수 있습니다.

### Flutter 기능이 내장된 올인원 옵션 {:#all-in-one-options-with-built-in-flutter-functionality}

* [Codemagic][]
* [Bitrise][]
* [Appcircle][]

### 기존 워크플로와 Fastlane 통합 {:#integrating-fastlane-with-existing-workflows}

다음 도구와 함께 fastlane을 사용할 수 있습니다.

* [GitHub Actions][]
  * 예제: [Flutter 프로젝트의 Github Action][Github Action in Flutter Project]
* [Cirrus][]
* [Travis][]
* [GitLab][]
* [CircleCI][]
   * [Fastlane을 사용하여 Flutter 앱 빌드 및 배포][Building and deploying Flutter apps with Fastlane]

이 가이드에서는 fastlane을 설정한 다음, 기존 테스트 및 지속적 통합(CI) 워크플로와 통합하는 방법을 보여줍니다. 
자세한 내용은 "기존 워크플로와 fastlane 통합"을 참조하세요.

## fastlane {:#fastlane}

[fastlane][]은 앱의 릴리스 및 배포를 자동화하는 오픈 소스 도구 모음입니다.

### 로컬 설정 {:#local-setup}

클라우드 기반 시스템으로 마이그레이션하기 전에, 로컬에서 빌드 및 배포 프로세스를 테스트하는 것이 좋습니다. 
로컬 머신에서 지속적인 배포(continuous delivery)를 수행할 수도 있습니다.

1. `gem install fastlane` 또는 `brew install fastlane`로 fastlane을 설치합니다. 
   * 자세한 내용은 [fastlane 문서][fastlane]을 방문하세요.
2. `FLUTTER_ROOT`라는 환경 변수를 만들고, Flutter SDK의 루트 디렉터리로 설정합니다. 
   (iOS에 배포하는 스크립트에 필요합니다.)
3. Flutter 프로젝트를 만들고, 준비가 되면, 프로젝트가 다음을 통해 빌드되는지 확인합니다.
   * ![Android](/assets/images/docs/cd/android.png) `flutter build appbundle`; 및
   * ![iOS](/assets/images/docs/cd/ios.png) `flutter build ipa`.
4. 각 플랫폼에 대한 fastlane 프로젝트를 초기화합니다.
   * ![Android](/assets/images/docs/cd/android.png) `[project]/android` 디렉토리에서, 
     `fastlane init`를 실행합니다.
   * ![iOS](/assets/images/docs/cd/ios.png) `[project]/ios` 디렉토리에서, 
     `fastlane init`를 실행합니다.
5. `Appfile`을 편집하여, 앱에 대한 적절한 메타데이터가 있는지 확인합니다.
   * ![Android](/assets/images/docs/cd/android.png) `[project]/android/fastlane/Appfile`의 `package_name`이 AndroidManifest.xml의 패키지 이름과 일치하는지 확인합니다.
   * ![iOS](/assets/images/docs/cd/ios.png) `[project]/ios/fastlane/Appfile`의 `app_identifier`가 Info.plist의 번들 식별자와도 일치하는지 확인합니다. 
     `apple_id`, `itc_team_id`, `team_id`에 해당 계정 정보를 입력하세요.
6. 스토어에 대한 로컬 로그인 자격 증명을 설정합니다.
   * ![Android](/assets/images/docs/cd/android.png) [공급 설정 단계][Supply setup steps]를 따르고,
     `fastlane supply init`가 Play Store 콘솔에서 데이터를 성공적으로 동기화하는지 확인합니다. 
     _.json 파일을 비밀번호처럼 취급하여, 공개 소스 제어 저장소에 체크인하지 마세요._
   * ![iOS](/assets/images/docs/cd/ios.png) iTunes Connect 사용자 이름이 이미 `Appfile`의 `apple_id` 필드에 있습니다. 
     `FASTLANE_PASSWORD` 셸 환경 변수를 iTunes Connect 비밀번호로 설정합니다. 
     그렇지 않으면, iTunes/TestFlight에 업로드할 때 메시지가 표시됩니다.
7. 코드 서명을 설정합니다.
   * ![Android](/assets/images/docs/cd/android.png) [Android 앱 서명 단계][Android app signing steps]를 따릅니다.
   * ![iOS](/assets/images/docs/cd/ios.png) iOS에서 TestFlight 또는 App Store를 사용하여 테스트하고, 
     배포할 준비가 되면, 개발 인증서(development certificate) 대신 배포 인증서(distribution certificate)를 사용하여 만들고 서명합니다.
     * [Apple Developer Account 콘솔][Apple Developer Account console]에서 배포 인증서를 만들고 다운로드합니다.
     * `open [project]/ios/Runner.xcworkspace/`를 열고 대상 설정 창에서 배포 인증서를 선택합니다.
8. 각 플랫폼에 대한 `Fastfile` 스크립트를 만듭니다.
   * ![Android](/assets/images/docs/cd/android.png) Android에서 [fastlane Android 베타 배포 가이드][fastlane Android beta deployment guide]를 따릅니다. 
     편집은 `upload_to_play_store`를 호출하는 `lane`을 추가하는 것만큼 간단할 수 있습니다. 
     이미 빌드된 앱 번들 `flutter build`를 사용하려면, 
     `aab` 인수를 `../build/app/outputs/bundle/release/app-release.aab`로 설정합니다.
   * ![iOS](/assets/images/docs/cd/ios.png) iOS에서 [fastlane iOS 베타 배포 가이드][fastlane iOS beta deployment guide]를 따릅니다. 
     프로젝트를 다시 빌드하지 않으려면, 아카이브 경로를 지정할 수 있습니다. 예:

      ```ruby
      build_app(
        skip_build_archive: true,
        archive_path: "../build/ios/archive/Runner.xcarchive",
      )
      upload_to_testflight
      ```

이제 로컬에서 배포를 수행하거나, 배포 프로세스를 CI(지속적인 통합) 시스템으로 마이그레이션할 준비가 되었습니다.

### 로컬에서 배포 실행 {:#running-deployment-locally}

1. 릴리스 모드 앱을 빌드합니다.
   * ![Android](/assets/images/docs/cd/android.png) `flutter build appbundle`.
   * ![iOS](/assets/images/docs/cd/ios.png) `flutter build ipa`.
2. 각 플랫폼에서 Fastfile 스크립트를 실행합니다.
   * ![Android](/assets/images/docs/cd/android.png) `cd android` 그리고나서, `fastlane [name of the lane you created]`.
   * ![iOS](/assets/images/docs/cd/ios.png) `cd ios` 그리고나서, `fastlane [name of the lane you created]`.

### 클라우드 빌드 및 배포 설정 {:#cloud-build-and-deploy-setup}

먼저, Travis와 같은 클라우드 시스템으로 마이그레이션하기 전에, 
'로컬 설정(Local setup)'에 설명된 로컬 설정 섹션을 따라 프로세스가 제대로 작동하는지 확인하세요.

가장 중요한 고려 사항은 클라우드 인스턴스가 일시적이고 신뢰할 수 없기 때문에, 
Play Store 서비스 계정 JSON이나 iTunes 배포 인증서와 같은 자격 증명을 서버에 두지 않는다는 것입니다.

CI(Continuous Integration) 시스템은 일반적으로 암호화된 환경 변수를 지원하여 비공개 데이터를 저장합니다. 
앱을 빌드하는 동안, `--dart-define MY_VAR=MY_VALUE`를 사용하여 이러한 환경 변수를 전달할 수 있습니다.

**테스트 스크립트에서 해당 변수 값을 콘솔에 다시 에코하지 않도록 주의하세요.** 
이러한 변수는 악의적인 행위자가 이러한 비밀을 출력하는 풀 리퀘스트를 만들 수 없도록, 
병합될 때까지 풀 리퀘스트에서 사용할 수 없습니다. 
수락하고 병합하는 풀 리퀘스트에서 이러한 비밀과 상호 작용할 때는 주의하세요.

1. 로그인 자격 증명을 임시로(ephemeral) 만듭니다.
    * ![Android](/assets/images/docs/cd/android.png) Android에서:
        * `Appfile`에서 `json_key_file` 필드를 제거하고, 
          JSON의 문자열 내용을 CI 시스템의 암호화된 변수에 저장합니다. 
          `Fastfile`에서 환경 변수를 직접 읽습니다.

          ```plaintext
          upload_to_play_store(
            ...
            json_key_data: ENV['<variable name>']
          )
          ```

        * 업로드 키를 직렬화하고(예: base64 사용) 암호화된 환경 변수로 저장합니다. 
          설치 단계에서 다음을 통해 CI 시스템에서 역직렬화할 수 있습니다.
        
          ```bash
          echo "$PLAY_STORE_UPLOAD_KEY" | base64 --decode > [path to your upload keystore]
          ```

    * ![iOS](/assets/images/docs/cd/ios.png) iOS에서:
        * 로컬 환경 변수 `FASTLANE_PASSWORD`를 이동하여, CI 시스템에서 암호화된 환경 변수를 사용합니다.
        * CI 시스템은 배포 인증서에 액세스해야 합니다. 
          fastlane의 [Match][] 시스템은 머신 간에 인증서를 동기화하는 데 권장됩니다.

2. 로컬 머신과 클라우드 머신 간에 fastlane 종속성이 안정적이고 재현 가능하도록, 
   CI 시스템에서 매번 불확정적인 `gem install fastlane`을 사용하는 대신, 
   Gemfile을 사용하는 것이 좋습니다. 
   그러나, 이 단계는 선택 사항입니다.
   * `[project]/android` 및 `[project]/ios` 폴더 모두에서, 다음 내용이 포함된 `Gemfile`을 만듭니다.
  
        ```plaintext
        source "https://rubygems.org"

        gem "fastlane"
        ```

   * 두 디렉토리에서 `bundle update`를 실행하고, `Gemfile`과 `Gemfile.lock`을 소스 제어에 체크합니다.
   * 로컬에서 실행할 때는, `fastlane` 대신 `bundle exec fastlane`을 사용합니다.

3. 저장소 루트에 `.travis.yml` 또는 `.cirrus.yml`과 같은 CI 테스트 스크립트를 만듭니다.
   * CI 관련 설정은 [fastlane CI 문서][fastlane CI documentation]를 ​​참조하세요.
   * Linux와 macOS 플랫폼에서 모두 실행되도록, 스크립트를 샤딩합니다.
   * CI 작업의 설정 단계에서, 다음을 수행합니다.
     * `gem install bundler`를 사용하여 Bundler를 사용할 수 있는지 확인합니다.
     * `[project]/android` 또는 `[project]/ios`에서 `bundle install`을 실행합니다.
     * Flutter SDK를 사용할 수 있고, `PATH`에 설정되어 있는지 확인합니다.
     * Android의 경우, Android SDK를 사용할 수 있고, `ANDROID_SDK_ROOT` 경로가 설정되어 있는지 확인합니다.
     * iOS의 경우, Xcode에 대한 종속성을 명시해야 할 수 있습니다. (예: `osx_image: xcode9.2`)
   * CI 작업의 스크립트 단계에서:
     * 플랫폼에 따라 `flutter build appbundle` 또는 `flutter build ios --release --no-codesign`을 실행합니다.
     * `cd android` 또는 `cd ios`
     * `bundle exec fastlane [name of the lane]`

## Xcode Cloud {:#xcode-cloud}

[Xcode Cloud][]는 Apple 플랫폼용 앱과 프레임워크를 빌드, 테스트, 배포하기 위한 지속적인 통합 및 전달 서비스입니다.

### 요구 사항 {:#requirements}

* Xcode 13.4.1 이상.
* [Apple Developer Program][]에 등록되어 있어야 합니다.

### 커스텀 빌드 스크립트 {:#custom-build-script}

Xcode Cloud는 지정된 시간에 추가 작업을 수행하는 데 사용할 수 있는 [커스텀 빌드 스크립트][custom build scripts]를 인식합니다. 
또한, 복제된 저장소의 위치인, `$CI_WORKSPACE`와 같은 [사전 정의된 환경 변수][predefined environment variables] 세트도 포함합니다.

:::note
Xcode Cloud에서 사용하는 임시 빌드 환경에는 macOS와 Xcode의 일부인 도구(예: Python)와 
타사 종속성 및 도구 설치를 지원하는 Homebrew가 포함됩니다.
:::

#### Post-clone script {:#post-clone-script}

다음 지침을 사용하여 Xcode Cloud가 Git 저장소를 복제한 후 실행되는, 복제 후 커스텀 빌드 스크립트를 활용하세요.

`ios/ci_scripts/ci_post_clone.sh`에 파일을 만들고, 아래 내용을 추가하세요.

<?code-excerpt "deployment/xcode_cloud/ci_post_clone.sh"?>
```sh
#!/bin/sh

# 하위 명령이 실패하면 이 스크립트도 실패합니다.
set -e

# 이 스크립트의 기본 실행 디렉토리는 ci_scripts 디렉토리입니다.
cd $CI_PRIMARY_REPOSITORY_PATH # 복제된 저장소의 루트로 작업 디렉토리를 변경합니다.

# git을 사용하여 Flutter를 설치합니다.
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

# iOS(--ios) 또는 macOS(--macos) 플랫폼용 Flutter 아티팩트를 설치합니다.
flutter precache --ios

# Flutter 종속성을 설치합니다.
flutter pub get

# Homebrew를 사용하여 CocoaPods를 설치합니다.
HOMEBREW_NO_AUTO_UPDATE=1 # Homebrew의 자동 업데이트를 비활성화합니다.
brew install cocoapods

# CocoaPods 종속성을 설치합니다..
cd ios && pod install # `ios` 디렉토리에서 `pod install`을 실행합니다.

exit 0
```

이 파일을 git 저장소에 추가하고, 실행 파일로 표시해야 합니다.

```console
$ git add --chmod=+x ios/ci_scripts/ci_post_clone.sh
```

### 워크플로 구성 {:#workflow-configuration}

[Xcode Cloud 워크플로][Xcode Cloud workflow]는 워크플로가 트리거될 때, CI/CD 프로세스에서 수행되는 단계를 정의합니다.

:::note
이렇게 하려면 프로젝트가 이미 Git으로 초기화되어 있고, 원격 저장소에 연결되어 있어야 합니다.
:::

Xcode에서 새 워크플로를 만들려면, 다음 지침을 따르세요.

1. **Product > Xcode Cloud > Create Workflow**를 선택하여 **Create Workflow** 시트를 엽니다.

2. 워크플로를 첨부할 제품(앱)을 선택한 다음, **Next** 버튼을 클릭합니다.

3. 다음 시트에는 Xcode에서 제공하는 기본 워크플로 개요가 표시되며, 
   **Edit Workflow** 버튼을 클릭하여 커스터마이즈 할 수 있습니다.

#### 브랜치 변경 {:#branch-changes}

기본적으로 Xcode는 Git 저장소의 기본 브랜치에 대한 모든 변경 사항에 대해 새 빌드를 시작하는, 
Branch Changes 조건을 제안합니다.

앱의 iOS 변형의 경우, flutter 패키지를 변경하거나, 
`lib\` 및 `ios\` 디렉터리 내의 Dart 또는 iOS 소스 파일을 수정한 후, 
Xcode Cloud에서 워크플로를 트리거하도록 하는 것이 합리적입니다.

다음 파일 및 폴더 조건을 사용하여 이를 달성할 수 있습니다.

![Xcode Workflow Branch Changes](/assets/images/docs/releaseguide/xcode_workflow_branch_changes.png){:width="100%"}

### 다음 빌드 번호 {:#next-build-number}

Xcode Cloud는 새 워크플로의 빌드 번호를 `1`로 기본 설정하고, 성공적인 빌드마다 증가시킵니다. 
빌드 번호가 더 높은 기존 앱을 사용하는 경우, 반복에서 `Next Build Number`를 지정하기만 하면, 
Xcode Cloud가 빌드에 올바른 빌드 번호를 사용하도록 구성해야 합니다.

자세한 내용은 [Xcode Cloud 빌드의 다음 빌드 번호 설정][Setting the next build number for Xcode Cloud builds]을 확인하세요.

[Android app signing steps]: /deployment/android#signing-the-app
[Appcircle]: https://appcircle.io/blog/guide-to-automated-mobile-ci-cd-for-flutter-projects-with-appcircle/
[Apple Developer Account console]: {{site.apple-dev}}/account/ios/certificate/
[Bitrise]: https://devcenter.bitrise.io/en/getting-started/quick-start-guides/getting-started-with-flutter-apps
[CI Options and Examples]: #reference-and-examples
[Cirrus]: https://cirrus-ci.org
[Cirrus script]: {{site.repo.flutter}}/blob/master/.cirrus.yml
[Codemagic]: https://blog.codemagic.io/getting-started-with-codemagic/
[fastlane]: https://docs.fastlane.tools
[fastlane Android beta deployment guide]: https://docs.fastlane.tools/getting-started/android/beta-deployment/
[fastlane CI documentation]: https://docs.fastlane.tools/best-practices/continuous-integration
[fastlane iOS beta deployment guide]: https://docs.fastlane.tools/getting-started/ios/beta-deployment/
[Github Action in Flutter Project]: {{site.github}}/nabilnalakath/flutter-githubaction
[GitHub Actions]: {{site.github}}/features/actions
[GitLab]: https://docs.gitlab.com/ee/ci/
[CircleCI]: https://circleci.com
[Building and deploying Flutter apps with Fastlane]: https://circleci.com/blog/deploy-flutter-android
[Match]: https://docs.fastlane.tools/actions/match/
[Supply setup steps]: https://docs.fastlane.tools/getting-started/android/setup/#setting-up-supply
[Travis]: https://travis-ci.org/
[Apple Developer Program]: {{site.apple-dev}}/programs
[Xcode Cloud]: {{site.apple-dev}}/xcode-cloud
[Xcode Cloud workflow]: {{site.apple-dev}}/documentation/xcode/xcode-cloud-workflow-reference
[custom build scripts]: {{site.apple-dev}}/documentation/xcode/writing-custom-build-scripts
[predefined environment variables]: {{site.apple-dev}}/documentation/xcode/environment-variable-reference
[Setting the next build number for Xcode Cloud builds]: {{site.apple-dev}}/documentation/xcode/setting-the-next-build-number-for-xcode-cloud-builds#Set-the-next-build-number-to-a-custom-value
