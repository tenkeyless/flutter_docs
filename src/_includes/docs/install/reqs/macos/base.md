{% case include.target %}
{% when 'mobile-ios' %}
{% assign v-target = "iOS" %}
{% when 'mobile-android' %}
{% assign v-target = "Android" %}
{% else %}
{% assign v-target = include.target %}
{% endcase %}

## 시스템 요구 사항 확인 (Verify system requirements)

Flutter를 설치하고 실행하려면, 
{{include.os}} 환경이 다음 하드웨어 및 소프트웨어 요구 사항을 충족해야 합니다.

### 하드웨어 요구 사항 (Hardware requirements)

{{include.os}} Flutter 개발 환경은 다음과 같은 최소 하드웨어 요구 사항을 충족해야 합니다.

|     요구 사항              |                                    최소 사양                               |    권장 사양      |
|:-----------------------------|:------------------------------------------------------------------------:|:-------------------:|
| CPU 코어                    | 4                                                                        | 8                   |
| 메모리 (GB)                 | 8                                                                        | 16                  |
| 디스플레이 해상도 (픽셀) | WXGA (1366 x 768)                                                        | FHD (1920 x 1080)   |
| 여유 디스크 공간 (GB)        | {% include docs/install/reqs/macos/storage.md target=include.target %}

{:.table .table-striped}

### 소프트웨어 요구 사항 (Software requirements)

{{v-target}}에 대한 Flutter 코드를 작성하고 컴파일하려면, 다음 패키지를 설치하세요.

{% render docs/install/admonitions/install-dart.md %}

#### 운영 체제 (Operating system)

Flutter는 macOS {{site.devmin.macos}} 이상에서 개발을 지원합니다. 
이 가이드에서는 Mac이 기본 셸로 `zsh`를 실행한다고 가정합니다.

{% include docs/install/reqs/macos/zsh-config.md target=include.target %}

{% include docs/install/reqs/macos/apple-silicon.md %}

#### 개발 도구 (Development tools)

다음 패키지를 다운로드하여 설치하세요.

{% include docs/install/reqs/macos/software.md target=include.target %}

이전 소프트웨어 개발자는 해당 제품에 대한 지원을 제공합니다.
설치 문제를 해결하려면, 해당 제품의 문서를 참조하세요.

{% render docs/install/reqs/flutter-sdk/flutter-doctor-precedence.md %}

#### 텍스트 편집기 또는 통합 개발 환경 (Text editor or integrated development environment)

Flutter의 명령줄 도구와 결합된 모든 텍스트 편집기나 통합 개발 환경(IDE)을 사용하여, Flutter로 앱을 빌드할 수 있습니다.

Flutter 확장 프로그램이나 플러그인이 있는 IDE를 사용하면, 
코드 완성, 구문 강조 표시, 위젯 편집 지원, 디버깅 및 기타 기능이 제공됩니다.

인기 있는 옵션은 다음과 같습니다.

* [Visual Studio Code][] {{site.appmin.vscode}} 이상과 [VS Code용 Flutter 확장 프로그램][Flutter extension for VS Code].
* [Android Studio][] {{site.appmin.android_studio}} 이상과 [IntelliJ용 Flutter 플러그인][Flutter plugin for IntelliJ].
* [IntelliJ IDEA][] {{site.appmin.intellij_idea}} 이상과 [IntelliJ용 Flutter 플러그인][Flutter plugin for IntelliJ]과 [IntelliJ용 Android 플러그인][Android plugin for IntelliJ].

:::recommend
Flutter 팀은 [Visual Studio Code][] {{site.appmin.vscode}} 이상과 
[VS Code용 Flutter 확장 프로그램][Flutter extension for VS Code]을 설치하는 것을 권장합니다. 
이 조합은 Flutter SDK 설치를 간소화합니다.
:::

[Android Studio]: https://developer.android.com/studio/install
[IntelliJ IDEA]: https://www.jetbrains.com/help/idea/installation-guide.html
[Visual Studio Code]: https://code.visualstudio.com/docs/setup/mac
[Flutter extension for VS Code]: https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter
[Flutter plugin for IntelliJ]: https://plugins.jetbrains.com/plugin/9212-flutter
[Android plugin for IntelliJ]: https://plugins.jetbrains.com/plugin/22989-android
