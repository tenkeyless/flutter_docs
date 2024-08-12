---
# title: Use themes to share colors and font styles
title: 테마를 사용하여 색상과 글꼴 스타일 공유
# short-title: Themes
short-title: 테마
# description: How to share colors and font styles throughout an app using Themes.
description: 테마를 사용하여 앱 전체에서 색상과 글꼴 스타일을 공유하는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/design/themes"?>

:::note
이 레시피는 Flutter의 [Material 3][] 및 [google_fonts][] 패키지 지원을 사용합니다. 
Flutter 3.16 릴리스부터, Material 3이 Flutter의 기본 테마입니다.
:::

[Material 3]: /ui/design/material
[google_fonts]: {{site.pub-pkg}}/google_fonts

앱 전체에서 색상과 글꼴 스타일을 공유하려면, 테마를 사용합니다.

앱 전체 테마를 정의할 수 있습니다. 
테마를 확장하여, 한 구성 요소의 테마 스타일을 변경할 수 있습니다. 
각 테마는 Material 구성 요소의 타입에 적용 가능한 색상, 타입 스타일 및 기타 매개변수를 정의합니다.

Flutter는 다음 순서로 스타일을 적용합니다.

1. 특정 위젯에 적용되는 스타일.
2. 바로 위의 부모 테마를 재정의하는 테마.
3. 전체 앱의 기본 테마.

`Theme`를 정의한 후, 자체 위젯 내에서 사용합니다. 
Flutter의 Material 위젯은 테마를 사용하여 앱 바, 버튼, 체크박스 등의 배경색과 글꼴 스타일을 설정합니다.

## 앱 테마 만들기 {:#create-an-app-theme}

앱 전체에서 `Theme`을 공유하려면, `MaterialApp` 생성자에 `theme` 속성을 설정합니다. 
이 속성은 [`ThemeData`][] 인스턴스를 사용합니다.

Flutter 3.16 릴리스부터, Material 3이 Flutter의 기본 테마입니다.

생성자에서 테마를 지정하지 않으면, Flutter가 기본 테마를 만듭니다.

<?code-excerpt "lib/main.dart (MaterialApp)" replace="/return //g"?>
```dart
MaterialApp(
  title: appName,
  theme: ThemeData(
    useMaterial3: true,

    // 기본 밝기와 색상을 정의합니다.
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.purple,
      // ···
      brightness: Brightness.dark,
    ),

    // 기본 `TextTheme`을 정의합니다. 
    // 이를 사용하여 헤드라인, 제목, 본문 등의 기본 텍스트 스타일을 지정합니다.
    textTheme: TextTheme(
      displayLarge: const TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.bold,
      ),
      // ···
      titleLarge: GoogleFonts.oswald(
        fontSize: 30,
        fontStyle: FontStyle.italic,
      ),
      bodyMedium: GoogleFonts.merriweather(),
      displaySmall: GoogleFonts.pacifico(),
    ),
  ),
  home: const MyHomePage(
    title: appName,
  ),
);
```

`ThemeData`의 대부분 인스턴스는 다음 두 속성에 대한 값을 설정합니다. 이러한 속성은 전체 앱에 영향을 미칩니다.

1. [`colorScheme`][] 색상을 정의합니다.
2. [`textTheme`][] 텍스트 스타일을 정의합니다.

[`colorScheme`]: {{site.api}}/flutter/material/ThemeData/colorScheme.html
[`textTheme`]: {{site.api}}/flutter/material/ThemeData/textTheme.html

정의할 수 있는 색상, 글꼴 및 기타 속성에 대해 알아보려면, [`ThemeData`][] 문서를 확인하세요.

## 테마 적용하기 {:#apply-a-theme}

새 테마를 적용하려면, 위젯의 스타일 속성을 지정할 때 `Theme.of(context)` 메서드를 사용합니다. 
여기에는 `style` 및 `color`가 포함될 수 있지만, 이에 국한되지 않습니다.

`Theme.of(context)` 메서드는 위젯 트리를 조회하여 트리에서 가장 가까운 `Theme`을 검색합니다. 
독립 실행형 `Theme`이 있는 경우, 적용됩니다. 그렇지 않은 경우, Flutter는 앱의 테마를 적용합니다.

다음 예에서, `Container` 생성자는 이 기술을 사용하여 `color`를 설정합니다.

<?code-excerpt "lib/main.dart (Container)" replace="/^child: //g"?>
```dart
Container(
  padding: const EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 12,
  ),
  color: Theme.of(context).colorScheme.primary,
  child: Text(
    'Text with a background color',
    // ···
    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
  ),
),
```

## 테마 재정의 {:#override-a-theme}

앱의 일부에서 전체 테마를 재정의하려면, 앱의 해당 섹션을 `Theme` 위젯으로 래핑합니다.

테마는 두 가지 방법으로 재정의할 수 있습니다.

1. 고유한 `ThemeData` 인스턴스를 만듭니다.
2. 부모 테마를 확장합니다.

### 고유한 `ThemeData` 인스턴스 설정 {:#set-a-unique-themedata-instance}

앱의 구성 요소가 전체 테마를 무시하도록 하려면, `ThemeData` 인스턴스를 만듭니다. 
해당 인스턴스를 `Theme` 위젯에 전달합니다.

<?code-excerpt "lib/main.dart (Theme)"?>
```dart
Theme(
  // `ThemeData`로 고유한 테마를 생성합니다.
  data: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.pink,
    ),
  ),
  child: FloatingActionButton(
    onPressed: () {},
    child: const Icon(Icons.add),
  ),
);
```

### 부모 테마 확장 {:#extend-the-parent-theme}

모든 것을 재정의하는 대신, 부모 테마를 확장하는 것을 고려하세요. 
테마를 확장하려면, [`copyWith()`][] 메서드를 사용하세요.

<?code-excerpt "lib/main.dart (ThemeCopyWith)"?>
```dart
Theme(
  // `copyWith`를 사용하여 부모 테마를 찾아 확장합니다.
  // 자세한 내용은 `Theme.of` 섹션을 확인하세요.
  data: Theme.of(context).copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.pink,
    ),
  ),
  child: const FloatingActionButton(
    onPressed: null,
    child: Icon(Icons.add),
  ),
);
```

## `Theme`에 대한 비디오 시청 {:#watch-a-video-on-theme}

자세한 내용을 알아보려면, `Theme` 위젯에 대한 이 짧은 주간 위젯 비디오를 시청하세요.

{% ytEmbed 'oTvQDJOBXmM', 'Theme | 이번 주의 Flutter 위젯' %}

## 대화형 예제 시도 {:#try-an-interactive-example}

<?code-excerpt "lib/main.dart (FullApp)"?>
```dartpad title="Flutter themes hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';
// Include the Google Fonts package to provide more text format options
// https://pub.dev/packages/google_fonts
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appName = 'Custom Themes';

    return MaterialApp(
      title: appName,
      theme: ThemeData(
        useMaterial3: true,

        // 기본 밝기와 색상을 정의합니다.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          // 다음을 시도해 보세요: 
          // "Brightness.light"로 변경하고, 
          //  모든 색상이 밝은 배경과 더 잘 대비되도록 변경되는지 확인하세요.
          brightness: Brightness.dark,
        ),

        // 기본 `TextTheme`을 정의합니다. 
        // 이를 사용하여 헤드라인, 제목, 본문 등의 기본 텍스트 스타일을 지정합니다.
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          // 다음을 시도해 보세요: 
          // GoogleFont 중 하나를 "lato", "poppins" 또는 "lora"로 변경합니다. 
          // 제목은 "titleLarge"를 사용하고 가운데 텍스트는 "bodyMedium"을 사용합니다.
          titleLarge: GoogleFonts.oswald(
            fontSize: 30,
            fontStyle: FontStyle.italic,
          ),
          bodyMedium: GoogleFonts.merriweather(),
          displaySmall: GoogleFonts.pacifico(),
        ),
      ),
      home: const MyHomePage(
        title: appName,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                )),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          color: Theme.of(context).colorScheme.primary,
          child: Text(
            'Text with a background color',
            // 다음을 시도해 보세요: 
            // 텍스트 값을 변경하거나 
            // Theme.of(context).textTheme을 "displayLarge" 또는 "displaySmall"로 변경하세요.
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
        ),
      ),
      floatingActionButton: Theme(
        data: Theme.of(context).copyWith(
          // 다음을 시도해 보세요: 
          // seedColor를 "Colors.red" 또는 "Colors.blue"로 변경하세요.
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.pink,
            brightness: Brightness.dark,
          ),
        ),
        child: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/themes.png" alt="Themes Demo" class="site-mobile-screenshot" />
</noscript>

[`copyWith()`]: {{site.api}}/flutter/material/ThemeData/copyWith.html
[`ThemeData`]: {{site.api}}/flutter/material/ThemeData-class.html
