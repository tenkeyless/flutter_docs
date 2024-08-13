---
# title: Animate a widget across screens
title: 화면 간에 위젯 애니메이션
# description: How to animate a widget from one screen to another
description: 위젯을 한 화면에서 다른 화면으로 애니메이션화하는 방법
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/navigation/hero_animations"?>

사용자가 화면에서 화면으로 이동할 때 앱을 안내하는 것이 종종 도움이 됩니다. 
사용자를 앱으로 안내하는 일반적인 기술은 위젯을 한 화면에서 다음 화면으로 애니메이션화하는 것입니다. 
이렇게 하면, 두 화면을 연결하는 시각적 앵커가 생성됩니다.

[`Hero`][] 위젯을 사용하여 위젯을 한 화면에서 다음 화면으로 애니메이션화합니다. 이 레시피는 다음 단계를 사용합니다.

  1. 동일한 이미지를 표시하는 두 개의 화면을 만듭니다.
  2. 첫 번째 화면에 `Hero` 위젯을 추가합니다.
  3. 두 번째 화면에 `Hero` 위젯을 추가합니다.

## 1. 동일한 이미지를 표시하는 두 개의 화면 만들기{:#1-create-two-screens-showing-the-same-image}

이 예에서는, 두 화면에 동일한 이미지를 표시합니다. 
사용자가 이미지를 탭하면 첫 번째 화면에서 두 번째 화면으로 이미지를 애니메이션화합니다. 
지금은, 시각적 구조를 만들고; 다음 단계에서 애니메이션을 처리합니다.

:::note
이 예제는 [새 화면으로 이동 및 뒤로 돌아가기][Navigate to a new screen and back] 및 
[탭 처리][Handle taps] 레시피를 기반으로 합니다.
:::

<?code-excerpt "lib/main_original.dart"?>
```dart
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Screen'),
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const DetailScreen();
          }));
        },
        child: Image.network(
          'https://picsum.photos/250?image=9',
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Image.network(
            'https://picsum.photos/250?image=9',
          ),
        ),
      ),
    );
  }
}
```

## 2. 첫 번째 화면에 `Hero` 위젯 추가 {:#2-add-a-hero-widget-to-the-first-screen}

두 화면을 애니메이션으로 연결하려면, 두 화면 모두의 `Image` 위젯을 `Hero` 위젯으로 래핑합니다. 
`Hero` 위젯에는 두 개의 인수가 필요합니다.

`tag`
: `Hero`를 식별하는 객체입니다. 두 화면에서 동일해야 합니다.

`child`
: 여러 화면에서 애니메이션을 적용할 위젯입니다.

{% comment %}
RegEx removes the first "child" property name and removed the trailing comma at the end
{% endcomment %}
<?code-excerpt "lib/main.dart (Hero1)" replace="/^child: //g;/^\),$/)/g"?>
```dart
Hero(
  tag: 'imageHero',
  child: Image.network(
    'https://picsum.photos/250?image=9',
  ),
)
```

## 3. 두 번째 화면에 `Hero` 위젯 추가 {:#3-add-a-hero-widget-to-the-second-screen}

첫 번째 화면과의 연결을 완료하려면, 
두 번째 화면의 `Image`를 첫 번째 화면의 `Hero`와 동일한 `tag`를 가진 `Hero` 위젯으로 래핑합니다.

두 번째 화면에 `Hero` 위젯을 적용한 후에는, 화면 간의 애니메이션이 작동합니다.

{% comment %}
RegEx removes the first "child" property name and removed the trailing comma at the end
{% endcomment %}
<?code-excerpt "lib/main.dart (Hero2)" replace="/^child: //g;/^\),$/)/g"?>
```dart
Hero(
  tag: 'imageHero',
  child: Image.network(
    'https://picsum.photos/250?image=9',
  ),
)
```


:::note
이 코드는 첫 번째 화면에 있는 코드와 동일합니다. 
모범 사례로, 코드를 반복하는 대신 재사용 가능한 위젯을 만드세요. 
이 예에서는 단순성을 위해, 두 위젯에 동일한 코드를 사용합니다.
:::

## 대화형 예제 {:#interactive-example}

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter Hero animation hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const HeroApp());

class HeroApp extends StatelessWidget {
  const HeroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Transition Demo',
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Screen'),
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const DetailScreen();
          }));
        },
        child: Hero(
          tag: 'imageHero',
          child: Image.network(
            'https://picsum.photos/250?image=9',
          ),
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network(
              'https://picsum.photos/250?image=9',
            ),
          ),
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/hero.gif" alt="Hero demo" class="site-mobile-screenshot" />
</noscript>


[Handle taps]: /cookbook/gestures/handling-taps
[`Hero`]: {{site.api}}/flutter/widgets/Hero-class.html
[Navigate to a new screen and back]: /cookbook/navigation/navigation-basics
