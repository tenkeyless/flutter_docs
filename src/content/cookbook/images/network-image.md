---
# title: Display images from the internet
title: 인터넷으로부터 이미지 표시
# description: How to display images from the internet.
description: 인터넷으로부터 이미지를 표시하는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/images/network_image"?>

이미지 표시는 대부분의 모바일 앱에 기본입니다. 
Flutter는 다양한 타입의 이미지를 표시하는 [`Image`][] 위젯을 제공합니다.

URL에서 이미지로 작업하려면, [`Image.network()`][] 생성자를 사용합니다.

<?code-excerpt "lib/main.dart (ImageNetwork)" replace="/^body\: //g"?>
```dart
Image.network('https://picsum.photos/250?image=9'),
```

## 보너스: 애니메이션 gif {:#bonus-animated-gifs}

`Image` 위젯의 유용한 점 중 하나는 애니메이션 GIF를 지원한다는 것입니다.

<?code-excerpt "lib/gif.dart (Gif)" replace="/^return\ //g"?>
```dart
Image.network(
    'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif');
```

## 플레이스홀더로 이미지 페이드 인 {:#image-fade-in-with-placeholders}

기본 `Image.network` 생성자는, 로딩 후 이미지 페이드 인과 같은, 고급 기능을 처리하지 않습니다. 
이 작업을 수행하려면 [플레이스홀더로 이미지 페이드 인][Fade in images with a placeholder]을 확인하세요.

* [플레이스홀더로 이미지 페이드 인][Fade in images with a placeholder]

## 대화형 예제 {:#interactive-example}

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter network images hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var title = 'Web Images';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Image.network('https://picsum.photos/250?image=9'),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/network-image.png" alt="Network image demo" class="site-mobile-screenshot" />
</noscript>


[Fade in images with a placeholder]: /cookbook/images/fading-in-images
[`Image`]: {{site.api}}/flutter/widgets/Image-class.html
[`Image.network()`]: {{site.api}}/flutter/widgets/Image/Image.network.html
