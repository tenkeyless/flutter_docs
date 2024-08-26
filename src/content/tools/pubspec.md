---
# title: "Flutter and the pubspec file"
title: "Flutter와 pubspec 파일"
# description: "Describes the Flutter-only fields in the pubspec file."
description: "pubspec 파일에서 Flutter 전용 필드를 설명합니다."
---

:::note
이 페이지는 주로 Flutter 앱을 작성하는 사람들을 대상으로 합니다. 
패키지나 플러그인을 작성하는 경우(아마도 페더레이션 플러그인을 만들고 싶을 수도 있음), 
[패키지 및 플러그인 개발][Developing packages and plugins] 페이지를 확인해야 합니다.
:::

모든 Flutter 프로젝트에는 `pubspec.yaml` 파일이 포함되어 있으며, 이를 종종 _pubspec_ 이라고 합니다. 
기본 pubspec은 새 Flutter 프로젝트를 만들 때 생성됩니다. 
이는 프로젝트 트리의 맨 위에 있으며, Dart 및 Flutter 툴링이 알아야 하는 프로젝트에 대한 메타데이터를 포함합니다. 
pubspec은 [YAML][]로 작성되어 있으며, 사람이 읽을 수 있지만, _공백(탭 vs 공백)이 중요하다는 점에 유의하세요_.

[YAML]: https://yaml.org/

pubspec 파일은 특정 패키지(및 해당 버전), 글꼴 또는 이미지 파일과 같이 프로젝트에 필요한 종속성을 지정합니다. 
또한 개발자 패키지(테스트 또는 모의 패키지 등)에 대한 종속성 또는
Flutter SDK 버전에 대한 특정 제약 조건과 같은 다른 요구 사항도 지정합니다.

Dart와 Flutter 프로젝트에 공통적인 필드는 [dart.dev][]의 [pubspec 파일][the pubspec file]에 설명되어 있습니다. 
이 페이지에는 Flutter 프로젝트에만 유효한 _Flutter 관련_ 필드가 나열되어 있습니다.

:::note
프로젝트를 처음 빌드하면 포함된 패키지의 특정 버전을 포함하는 `pubspec.lock` 파일이 생성됩니다. 
이렇게 하면, 다음에 프로젝트를 빌드할 때 동일한 버전을 얻을 수 있습니다.
:::

[the pubspec file]: {{site.dart-site}}/tools/pub/pubspec
[dart.dev]: {{site.dart-site}}

`flutter create` 명령(또는 IDE에서 동일한 버튼 사용)으로 새 프로젝트를 만들면,
기본 Flutter 앱에 대한 pubspec이 생성됩니다.

Flutter 프로젝트 pubspec 파일의 예는 다음과 같습니다. 
Flutter 전용 필드가 강조 표시됩니다.

```yaml
name: <project name>
description: A new Flutter project.

publish_to: none

version: 1.0.0+1

environment:
  sdk: ^3.5.0

dependencies:
  [!flutter:!]       # 모든 Flutter 프로젝트에 필요합니다
    [!sdk: flutter!] # 모든 Flutter 프로젝트에 필요합니다
  [!flutter_localizations:!] # 지역화를 활성화하는 데 필요합니다.
    [!sdk: flutter!]         # 지역화를 활성화하는 데 필요합니다.

  [!cupertino_icons: ^1.0.8!] # Cupertino(iOS 스타일) 아이콘을 사용하는 경우에만 필요합니다.

dev_dependencies:
  [!flutter_test:!]
    [!sdk: flutter!] # 테스트가 포함된 Flutter 프로젝트에 필요합니다.

  [!flutter_lints: ^4.0.0!] # Flutter 코드에 권장되는 린트 세트가 포함되어 있습니다.

[!flutter:!]

  [!uses-material-design: true!] # Material 아이콘 글꼴을 사용하는 경우 필수입니다.

  [!generate: true!] # arb 파일에서 지역화된 문자열 생성을 활성화합니다.

  [!assets:!]  # 이미지 파일 등의 assets 리스트.
    [!- images/a_dot_burr.jpeg!]
    [!- images/a_dot_ham.jpeg!]

  [!fonts:!]              # 앱에서 커스텀 글꼴을 사용하는 경우 필수입니다.
    [!- family: Schyler!]
      [!fonts:!]
        [!- asset: fonts/Schyler-Regular.ttf!]
        [!- asset: fonts/Schyler-Italic.ttf!]
          [!style: italic!]
    [!- family: Trajan Pro!]
      [!fonts:!]
        [!- asset: fonts/TrajanPro.ttf!]
        [!- asset: fonts/TrajanPro_Bold.ttf!]
          [!weight: 700!]
```
 
## Assets {:#assets}

일반적인 assets 타입에는 static 데이터(예: JSON 파일), 구성 파일, 아이콘 및 이미지(JPEG, WebP, GIF, 애니메이션 WebP/GIF, PNG, BMP 및 WBMP)가 포함됩니다.

앱 패키지에 포함된 이미지를 나열하는 것 외에도, 이미지 asset은 하나 이상의 해상도별 "변형"을 참조할 수도 있습니다. 
자세한 내용은 [Assets 및 이미지][Assets and images] 페이지의 [해상도 인식][resolution aware] 섹션을 참조하세요. 
패키지 종속성에서 assets을 추가하는 방법에 대한 자세한 내용은, 
같은 페이지의 [패키지 종속성의 asset 이미지][asset images in package dependencies] 섹션을 참조하세요.

[Assets and images]: /ui/assets/assets-and-images
[asset images in package dependencies]: /ui/assets/assets-and-images#from-packages
[resolution aware]: /ui/assets/assets-and-images#resolution-aware

## 글꼴 {:#fonts}

위의 예에서 보듯이, 글꼴 섹션의 각 항목에는 글꼴 패밀리 이름이 있는 `family` 키와 
글꼴에 대한 asset 및 기타 설명자를 지정하는 목록이 있는 `fonts` 키가 있어야 합니다.

글꼴 사용의 예는 [Flutter 쿡북][Flutter cookbook]의 
[커스텀 글꼴 사용][Use a custom font] 및 [패키지에서 글꼴 내보내기][Export fonts from a package] 레시피를 참조하세요.

[Export fonts from a package]: /cookbook/design/package-fonts
[Flutter cookbook]: /cookbook
[Use a custom font]: /cookbook/design/fonts

## 더 많은 정보 {:#more-information}

패키지, 플러그인 및 pubspec 파일에 대한 자세한 내용은 다음을 참조하세요.

* dart.dev의 [패키지 생성][Creating packages] 
* dart.dev의 [패키지 용어집][Glossary of package terms]
* dart.dev의 [패키지 종속성][Package dependencies]
* [패키지 사용][Using packages]
* dart.dev의 [커밋하지 말아야 할 것][What not to commit]

[Creating packages]: {{site.dart-site}}/guides/libraries/create-library-packages
[Developing packages and plugins]: /packages-and-plugins/developing-packages
[Federated plugins]: /packages-and-plugins/developing-packages#federated-plugins
[Glossary of package terms]: {{site.dart-site}}/tools/pub/glossary
[Package dependencies]: {{site.dart-site}}/tools/pub/dependencies
[Using packages]: /packages-and-plugins/using-packages
[What not to commit]: {{site.dart-site}}/guides/libraries/private-files#pubspeclock
