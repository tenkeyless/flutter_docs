---
# title: Export fonts from a package
title: 패키지에서 글꼴 내보내기
# description: How to export fonts from a package.
description: 패키지에서 글꼴을 내보내는 방법.
---

<?code-excerpt path-base="cookbook/design/package_fonts"?>

앱의 일부로 글꼴을 선언하는 대신, 별도의 패키지의 일부로 글꼴을 선언할 수 있습니다. 
이는 여러 다른 프로젝트에서 동일한 글꼴을 공유하거나, [pub.dev][]에 패키지를 게시하는 코더에게 편리한 방법입니다. 
이 레시피는 다음 단계를 사용합니다.

  1. 패키지에 글꼴을 추가합니다.
  2. 패키지와 글꼴을 앱에 추가합니다.
  3. 글꼴을 사용합니다.

:::note
약 1000개의 오픈소스 글꼴 패밀리에 직접 액세스하려면, [google_fonts][] 패키지를 확인하세요.
:::

## 1. 패키지에 글꼴 추가 {:#1-add-a-font-to-a-package}

패키지에서 글꼴을 내보내려면, 글꼴 파일을 패키지 프로젝트의 `lib` 폴더로 가져와야 합니다. 
글꼴 파일을 `lib` 폴더나 `lib/fonts`와 같은 하위 디렉터리에 직접 넣을 수 있습니다.

이 예에서는, `lib/fonts` 폴더에 글꼴이 있는 `awesome_package`라는 Flutter 라이브러리가 있다고 가정합니다.

```plaintext
awesome_package/
  lib/
    awesome_package.dart
    fonts/
      Raleway-Regular.ttf
      Raleway-Italic.ttf
```

## 2. 앱에 패키지와 글꼴 추가 {:#2-add-the-package-and-fonts-to-the-app}

이제 *앱의* 루트 디렉토리에 있는 `pubspec.yaml`을 업데이트하여 패키지의 글꼴을 사용할 수 있습니다.

### 앱에 패키지 추가 {:#add-the-package-to-the-app}

`awesome_package` 패키지를 종속성으로 추가하려면, `flutter pub add`를 실행하세요.

```console
$ flutter pub add awesome_package
```

### 글꼴 Asset 선언 {:#declare-the-font-assets}

이제 패키지를 가져왔으니, Flutter에 `awesome_package`에서 글꼴을 찾을 위치를 알려주세요.

패키지 글꼴을 선언하려면, 글꼴 경로 앞에 `packages/awesome_package`를 접두사로 붙입니다. 
이렇게 하면 Flutter가 패키지의 `lib` 폴더에서 글꼴을 찾게 됩니다.

```yaml
flutter:
  fonts:
    - family: Raleway
      fonts:
        - asset: packages/awesome_package/fonts/Raleway-Regular.ttf
        - asset: packages/awesome_package/fonts/Raleway-Italic.ttf
          style: italic
```

<a id="use" aria-hidden="true"></a>

## 3. 글꼴 사용 {:#3-use-the-font}

[`TextStyle`][]을 사용하여 텍스트 모양을 변경합니다. 
패키지 글꼴을 사용하려면, 사용하고 싶은 글꼴과 글꼴이 속한 패키지를 선언합니다.

<?code-excerpt "lib/main.dart (TextStyle)"?>
```dart
child: Text(
  'Using the Raleway font from the awesome_package',
  style: TextStyle(
    fontFamily: 'Raleway',
  ),
),
```

## 예제 완성하기 {:#complete-example}

### Fonts

Raleway 및 RobotoMono 글꼴은 [Google Fonts][]에서 다운로드되었습니다.

### `pubspec.yaml`

```yaml
name: package_fonts
description: An example of how to use package fonts with Flutter

dependencies:
  awesome_package:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  fonts:
    - family: Raleway
      fonts:
        - asset: packages/awesome_package/fonts/Raleway-Regular.ttf
        - asset: packages/awesome_package/fonts/Raleway-Italic.ttf
          style: italic
  uses-material-design: true
```

### `main.dart`

<?code-excerpt "lib/main.dart"?>
```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Package Fonts',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar는 앱 기본 글꼴을 사용합니다.
      appBar: AppBar(title: const Text('Package Fonts')),
      body: const Center(
        // 이 텍스트 위젯은 Raleway 글꼴을 사용합니다.
        child: Text(
          'Using the Raleway font from the awesome_package',
          style: TextStyle(
            fontFamily: 'Raleway',
          ),
        ),
      ),
    );
  }
}
```

![Package Fonts Demo](/assets/images/docs/cookbook/package-fonts.png){:.site-mobile-screenshot}

[Google Fonts]: https://fonts.google.com
[google_fonts]: {{site.pub-pkg}}/google_fonts
[pub.dev]: {{site.pub}}
[`TextStyle`]: {{site.api}}/flutter/painting/TextStyle-class.html
