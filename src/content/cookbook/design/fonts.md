---
# title: Use a custom font
title: 커스텀 글꼴 사용
# description: How to use custom fonts.
description: 커스텀 글꼴을 사용하는 방법.
---

<?code-excerpt path-base="cookbook/design/fonts/"?>

:::secondary 학습할 내용
* 글꼴을 선택하는 방법.
* 글꼴 파일을 가져오는 방법.
* 글꼴을 기본값으로 설정하는 방법.
* 주어진 위젯에서 글꼴을 사용하는 방법.
:::

Android와 iOS는 고품질 시스템 글꼴을 제공하지만, 디자이너는 커스텀 글꼴에 대한 지원을 원합니다. 
디자이너로부터 커스텀 글꼴을 받았거나, [Google Fonts][]에서 글꼴을 다운로드했을 수 있습니다.

typeface는 주어진 스타일의 글자를 구성하는 글리프(glyphs) 또는 모양의 모음입니다. 
font는 주어진 굵기(weight) 또는 변형으로 해당 글꼴을 표현한 것입니다. 
Roboto는 typeface이고, Roboto Bold는 글꼴(font)입니다.

Flutter를 사용하면 전체 앱 또는 개별 위젯에 커스텀 글꼴을 적용할 수 있습니다. 
이 레시피는 다음 단계에 따라 커스텀 글꼴을 사용하는 앱을 만듭니다.

1. 글꼴을 선택합니다.
2. 글꼴 파일을 가져옵니다.
3. pubspec에서 글꼴을 선언합니다.
4. 글꼴을 기본값으로 설정합니다.
5. 특정 위젯에서 글꼴을 사용합니다.

각 단계를 따라갈 필요는 없습니다.
가이드의 마지막에 완성된 예제 파일이 제공됩니다.

:::note
이 가이드에서는 다음과 같은 가정을 합니다.

1. [Flutter 환경이 설정되어 있습니다.][set up your Flutter environment]
2. `custom_fonts`라는 이름으로 [새로운 Flutter 앱][new-flutter-app]을 만들었습니다. 
   아직 이러한 단계를 완료하지 않았다면, 이 가이드를 계속하기 전에 완료하세요.
3. 제공된 명령을 macOS 또는 Linux 셸에서 `vi`를 사용하여 수행합니다. 
   `vi`를 다른 텍스트 편집기로 대체할 수 있습니다. Windows 사용자는 단계를 수행할 때 적절한 명령과 경로를 사용해야 합니다.
4. Flutter 앱에 Raleway 및 RobotoMono 글꼴을 추가하였습니다.
:::

[set up your Flutter environment]: /get-started/install
[new-flutter-app]: /get-started/test-drive

## 글꼴 선택 {:#choose-a-font}

글꼴 선택은 선호도 이상이어야 합니다. 
Flutter에서 어떤 파일 형식이 작동하는지, 
글꼴이 디자인 옵션과 앱 성능에 어떤 영향을 미칠 수 있는지 고려하세요.

#### 지원되는 글꼴 형식 선택 {:#pick-a-supported-font-format}

Flutter는 다음 글꼴 형식을 지원합니다.

* OpenType 글꼴 컬렉션: `.ttc`
* TrueType 글꼴: `.ttf`
* OpenType 글꼴: `.otf`

Flutter는 데스크톱 플랫폼에서, Web Open Font Format인 `.woff` 및 `.woff2`의 글꼴을 지원하지 않습니다.

#### 특정 이점에 맞는 글꼴 선택 {:#choose-fonts-for-their-specific-benefits}

글꼴 파일 타입이 무엇인지 또는 어떤 것이 공간을 덜 사용하는지에 대해 동의하는 출처는 거의 없습니다.
글꼴 파일 타입 간의 주요 차이점은 형식이 파일의 글리프(glyphs)를 인코딩하는 방식과 관련이 있습니다. 
대부분의 TrueType 및 OpenType 글꼴 파일은 시간이 지남에 따라 형식과 글꼴이 개선됨에 따라 
서로에게서 빌려온 유사한 기능을 가지고 있습니다.

사용해야 하는 글꼴은 다음 고려 사항에 따라 달라집니다.

* 앱에서 글꼴에 필요한 변형은 얼마나 됩니까?
* 앱에서 사용하는 글꼴을 허용할 수 있는 파일 크기는 얼마입니까?
* 앱에서 지원해야 하는 언어는 몇 개입니까?

글꼴 파일당 두 개 이상의 굵기 또는 스타일, [가변 글꼴 기능][variable-fonts], 
여러 글꼴 굵기에 대한 여러 글꼴 파일의 가용성 또는 글꼴당 두 개 이상의 너비와 같이, 
주어진 글꼴이 제공하는 옵션을 조사합니다.

앱의 디자인 요구 사항을 충족하는 typeface 또는 font 패밀리를 선택합니다.

:::secondary
1,000개가 넘는 오픈소스 글꼴 패밀리에 직접 액세스하는 방법을 알아보려면, [google_fonts][] 패키지를 확인하세요.

{% ytEmbed '8Vzv2CdbEY0', 'google_fonts | 이번 주의 Flutter 패키지' %}

여러 프로젝트에서 하나의 글꼴을 재사용할 수 있는 커스텀 글꼴을 사용하는 
또 다른 접근 방식에 대해 알아보려면 [패키지에서 글꼴 내보내기][Export fonts from a package]를 확인하세요.
:::

## 글꼴 파일 가져오기 {:#import-the-font-files}

글꼴을 사용하려면, 해당 글꼴 파일을 Flutter 프로젝트로 가져옵니다.

글꼴 파일을 가져오려면, 다음 단계를 수행합니다.

1. 필요한 경우, 이 가이드의 나머지 단계와 일치하도록, Flutter 앱의 이름을 `custom_fonts`로 변경합니다.

   ```console
   $ mv /path/to/my_app /path/to/custom_fonts
   ```

2. Flutter 프로젝트의 루트로 이동합니다.

   ```console
   $ cd /path/to/custom_fonts
   ```

3. Flutter 프로젝트의 루트에 `fonts` 디렉터리를 만듭니다.

   ```console
   $ mkdir fonts
   ```

4. Flutter 프로젝트의 루트에 있는 `fonts` 또는 `assets` 폴더의 글꼴 파일을 이동하거나 복사합니다.

   ```console
   $ cp ~/Downloads/*.ttf ./fonts
   ```

결과 폴더 구조는 다음과 유사해야 합니다.

```plaintext
custom_fonts/
|- fonts/
  |- Raleway-Regular.ttf
  |- Raleway-Italic.ttf
  |- RobotoMono-Regular.ttf
  |- RobotoMono-Bold.ttf
```

## pubspec.yaml 파일에 글꼴 선언 {:#declare-the-font-in-the-pubspec-yaml-file}

글꼴을 다운로드한 후, `pubspec.yaml` 파일에 글꼴 정의를 포함합니다. 
이 글꼴 정의는 앱에 주어진 굵기나 스타일을 렌더링하는 데 사용할 글꼴 파일도 지정합니다.

### `pubspec.yaml` 파일에 글꼴 정의 {:#define-fonts-in-the-pubspec-yaml-file}

Flutter 앱에 글꼴 파일을 추가하려면, 다음 단계를 완료하세요.

1. Flutter 프로젝트의 루트에서 `pubspec.yaml` 파일을 엽니다.

   ```console
   $ vi pubspec.yaml
   ```

2. `flutter` 선언 뒤에 다음 YAML 블록을 붙여넣습니다.

   ```yaml
     fonts:
       - family: Raleway
         fonts:
           - asset: fonts/Raleway-Regular.ttf
           - asset: fonts/Raleway-Italic.ttf
             style: italic
       - family: RobotoMono
         fonts:
           - asset: fonts/RobotoMono-Regular.ttf
           - asset: fonts/RobotoMono-Bold.ttf
             weight: 700
   ```

이 `pubspec.yaml` 파일은 `Raleway` 글꼴 패밀리의 기울임체 스타일을 `Raleway-Italic.ttf` 글꼴 파일로 정의합니다.
`style: TextStyle(fontStyle: FontStyle.italic)`을 설정하면, 
Flutter는 `Raleway-Regular`를 `Raleway-Italic`으로 바꿉니다.

`family` 값은 typeface 이름을 설정합니다. 
이 이름은 [`TextStyle`][] 객체의 [`fontFamily`][] 속성에서 사용합니다.

`asset`의 값은 `pubspec.yaml` 파일에서 글꼴 파일로의 상대 경로입니다. 
이러한 파일에는 글꼴의 글리프(glyphs) 윤곽선이 포함되어 있습니다. 
앱을 빌드할 때 Flutter는 이러한 파일을 앱의 asset 번들에 포함합니다.

### 각 글꼴에 대한 글꼴 파일 포함 {:#include-font-files-for-each-font}

다양한 typeface은 글꼴 파일을 다른 방식으로 구현합니다. 
다양한 글꼴 두께와 스타일이 있는 typeface가 필요한 경우, 해당 다양성을 나타내는 글꼴 파일을 선택하여 가져옵니다.

여러 글꼴이 포함되지 않거나 가변 글꼴 기능이 없는 글꼴 파일을 가져올 때는, 
`style` 또는 `weight` 속성을 사용하여 표시 방식을 조정하지 마세요. 
일반 글꼴 파일에서 이러한 속성을 사용하는 경우, Flutter는 모양을 _시뮬레이션_ 하려고 시도합니다. 
시각적 결과는 올바른 글꼴 파일을 사용하는 것과 상당히 다르게 보일 것입니다.

### 글꼴 파일에 스타일과 두께 설정 {:#set-styles-and-weights-with-font-files}

글꼴의 스타일이나 두께를 나타내는 글꼴 파일을 선언할 때, `style` 또는 `weight` 속성을 적용할 수 있습니다.

#### 글꼴 두께 설정 {:#set-font-weight}

`weight` 속성은 파일의 윤곽선 두께를 100에서 900 사이의 100 정수 배수로 지정합니다. 
이러한 값은 [`FontWeight`][]에 해당하며 
[`TextStyle`][] 객체의 [`fontWeight`][fontWeight 속성] 속성에서 사용할 수 있습니다.

이 가이드에 표시된 `pubspec.yaml`에서, `RobotoMono-Bold`를 글꼴 패밀리의 `700` 두께로 정의했습니다. 
앱에 추가한 `RobotoMono-Bold` 글꼴을 사용하려면, 
`TextStyle` 위젯에서 `fontWeight`를 `FontWeight.w700`으로 설정합니다.

앱에 `RobotoMono-Bold`를 추가하지 않은 경우, Flutter는 글꼴을 굵게 표시하려고 시도합니다. 
그러면 텍스트가 다소 어둡게 보일 수 있습니다.

`weight` 속성을 사용하여 글꼴의 두께를 재정의할 수 없습니다. 
`RobotoMono-Bold`를 `700` 이외의 다른 굵기로 설정할 수 없습니다. 
`TextStyle(fontFamily: 'RobotoMono', fontWeight: FontWeight.w900)`를 설정하면, 
표시되는 글꼴은 `RobotoMono-Bold`가 아무리 굵게 보이더라도 그대로 렌더링됩니다.

#### 글꼴 스타일 설정 {:#set-font-style}

`style` 속성은 글꼴 파일의 글리프(glyphs)가 `italic` 또는 `normal`로 표시되는지 여부를 지정합니다. 
이러한 값은 [`FontStyle`][]에 해당합니다. 
이러한 스타일은 [`TextStyle`][] 객체의 [`fontStyle`][fontStyle property] 속성에서 사용할 수 있습니다.

이 가이드에 표시된 `pubspec.yaml`에서, `Raleway-Italic`을 `italic` 스타일로 정의했습니다. 
앱에 추가한 `Raleway-Italic` 글꼴을 사용하려면, `style: TextStyle(fontStyle: FontStyle.italic)`을 설정합니다.
Flutter는 렌더링할 때 `Raleway-Regular`를 `Raleway-Italic`으로 바꿉니다.

앱에 `Raleway-Italic`을 추가하지 않았다면, Flutter는 글꼴을 기울임체로 _보이게_ 하려고 시도합니다. 
그러면 텍스트가 오른쪽으로 기울어지는 것처럼 보일 수 있습니다.

`style` 속성을 사용하여 글꼴의 글리프(glyphs)를 재정의할 수 없습니다. 
`TextStyle(fontFamily: 'Raleway', fontStyle: FontStyle.normal)`을 설정하면, 
표시된 글꼴은 여전히 ​​이탤릭으로 렌더링됩니다. 이탤릭 글꼴의 `regular` 스타일은 _이탤릭입니다_.

## 기본 글꼴로 설정하기 {:#set-a-font-as-the-default}

텍스트에 글꼴을 적용하려면, 해당 글꼴을 앱의 `theme`에서 기본 글꼴로 설정할 수 있습니다.

기본 글꼴을 설정하려면, 앱의 `theme`에서 `fontFamily` 속성을 설정합니다. 
`fontFamily` 값을 `pubspec.yaml` 파일에 선언된 `family` 이름과 일치시킵니다.

결과는 다음 코드와 유사합니다.

<?code-excerpt "lib/main.dart (MaterialApp)"?>
```dart
return MaterialApp(
  title: 'Custom Fonts',
  // Raleway를 기본 앱 글꼴로 설정합니다.
  theme: ThemeData(fontFamily: 'Raleway'),
  home: const MyHomePage(),
);
```

테마에 대해 자세히 알아보려면, 
[테마를 사용하여 색상 및 글꼴 스타일 공유][Using Themes to share colors and font styles] 레시피를 확인하세요.

## 특정 위젯에 글꼴 설정 {:#set-the-font-in-a-specific-widget}

`Text` 위젯과 같은 특정 위젯에 글꼴을 적용하려면, 위젯에 [`TextStyle`][]을 제공합니다.

이 가이드에서는, `RobotoMono` 글꼴을 단일 `Text` 위젯에 적용해 보세요. 
`fontFamily` 값을 `pubspec.yaml` 파일에 선언된 `family` 이름과 일치시킵니다.

결과는 다음 코드와 유사합니다.

<?code-excerpt "lib/main.dart (Text)"?>
```dart
child: Text(
  'Roboto Mono sample',
  style: TextStyle(fontFamily: 'RobotoMono'),
),
```

:::important
[`TextStyle`][] 객체가 해당 글꼴 파일 없이 두께나 스타일을 지정하는 경우, 
엔진은 글꼴에 대한 일반 파일을 사용하고, 요청된 두께와 스타일에 대한 윤곽선을 외삽하려고 시도합니다.

이 기능에 의존하지 마십시오. 대신 적절한 글꼴 파일을 가져오십시오.
:::

## 완성된 예제 시도하기 {:#try-the-complete-example}

### 글꼴 다운로드 {:#download-fonts}

[Google Fonts][]에서 Raleway 및 RobotoMono 글꼴 파일을 다운로드하세요.

### `pubspec.yaml` 파일 업데이트 {:#update-the-pubspec-yaml-file}

1. Flutter 프로젝트의 루트에서 `pubspec.yaml` 파일을 엽니다.

   ```console
   $ vi pubspec.yaml
   ```

2. 해당 내용을 다음 YAML로 바꾸세요.

   ```yaml
   name: custom_fonts
   description: An example of how to use custom fonts with Flutter
   
   dependencies:
     flutter:
       sdk: flutter
   
   dev_dependencies:
     flutter_test:
       sdk: flutter
   
   flutter:
     fonts:
       - family: Raleway
         fonts:
           - asset: fonts/Raleway-Regular.ttf
           - asset: fonts/Raleway-Italic.ttf
             style: italic
       - family: RobotoMono
         fonts:
           - asset: fonts/RobotoMono-Regular.ttf
           - asset: fonts/RobotoMono-Bold.ttf
             weight: 700
     uses-material-design: true
   ```

### 이 `main.dart` 파일 사용하기 {:#use-this-main-dart-file}

1. Flutter 프로젝트의 `lib/` 디렉토리에 있는 `main.dart` 파일을 엽니다.

   ```console
   $ vi lib/main.dart
   ```

2. 해당 내용을 다음 Dart 코드로 바꾸세요.

   <?code-excerpt "lib/main.dart"?>
   ```dart
   import 'package:flutter/material.dart';
   
   void main() => runApp(const MyApp());
   
   class MyApp extends StatelessWidget {
     const MyApp({super.key});
   
     @override
     Widget build(BuildContext context) {
       return MaterialApp(
         title: 'Custom Fonts',
         // Raleway를 기본 앱 글꼴로 설정합니다.
         theme: ThemeData(fontFamily: 'Raleway'),
         home: const MyHomePage(),
       );
     }
   }
   
   class MyHomePage extends StatelessWidget {
     const MyHomePage({super.key});
   
     @override
     Widget build(BuildContext context) {
       return Scaffold(
         // AppBar는 앱 기본 Raleway 글꼴을 사용합니다.
         appBar: AppBar(title: const Text('Custom Fonts')),
         body: const Center(
           // 이 텍스트 위젯은 RobotoMono 글꼴을 사용합니다.
           child: Text(
             'Roboto Mono sample',
             style: TextStyle(fontFamily: 'RobotoMono'),
           ),
         ),
       );
     }
   }
   ```

결과적으로 Flutter 앱은 다음 화면을 표시해야 합니다.

![Custom Fonts Demo](/assets/images/docs/cookbook/fonts.png){:.site-mobile-screenshot}

[variable-fonts]: https://fonts.google.com/knowledge/introducing_type/introducing_variable_fonts
[Export fonts from a package]: /cookbook/design/package-fonts
[`fontFamily`]: {{site.api}}/flutter/painting/TextStyle/fontFamily.html
[fontStyle property]: {{site.api}}/flutter/painting/TextStyle/fontStyle.html
[`FontStyle`]: {{site.api}}/flutter/dart-ui/FontStyle.html
[fontWeight property]: {{site.api}}/flutter/painting/TextStyle/fontWeight.html
[`FontWeight`]: {{site.api}}/flutter/dart-ui/FontWeight-class.html
[Google Fonts]: https://fonts.google.com
[google_fonts]: {{site.pub-pkg}}/google_fonts
[`TextStyle`]: {{site.api}}/flutter/painting/TextStyle-class.html
[Using Themes to share colors and font styles]: /cookbook/design/themes
