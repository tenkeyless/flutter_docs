---
# title: Fade in images with a placeholder
title: 플레이스홀더로 이미지 페이드 인
# description: How to fade images into view.
description: 이미지를 페이드하여 보이게 하는 방법.
---

<?code-excerpt path-base="cookbook/images/fading_in_images"?>

기본 `Image` 위젯을 사용하여 이미지를 표시할 때, 이미지가 로드될 때 화면에 팝업되는 것을 알 수 있습니다. 
이는 사용자에게 시각적으로 어색하게 느껴질 수 있습니다.

대신, 처음에 플레이스홀더를 표시하고, 이미지가 로드될 때 페이드인되는 것이 좋지 않을까요? 
바로 이 목적에 [`FadeInImage`][] 위젯을 사용하세요.

`FadeInImage`는 인메모리, 로컬 assets 또는 인터넷으로부터의 이미지 등 모든 타입의 이미지에서 작동합니다.

## 인메모리 {:#in-memory}

이 예에서는, 간단한 투명 플레이스홀더를 위해 [`transparent_image`][] 패키지를 사용합니다.

<?code-excerpt "lib/memory_main.dart (MemoryNetwork)" replace="/^child\: //g"?>
```dart
FadeInImage.memoryNetwork(
  placeholder: kTransparentImage,
  image: 'https://picsum.photos/250?image=9',
),
```

### 완성된 예제 {:#complete-example}

<?code-excerpt "lib/memory_main.dart"?>
```dart
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Fade in images';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: Stack(
          children: <Widget>[
            const Center(child: CircularProgressIndicator()),
            Center(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: 'https://picsum.photos/250?image=9',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

![Fading In Image Demo](/assets/images/docs/cookbook/fading-in-images.gif){:.site-mobile-screenshot}

## Asset 번들로부터 {:#from-asset-bundle}

플레이스홀더에 로컬 에셋을 사용하는 것도 고려할 수 있습니다. 
먼저, 프로젝트의 `pubspec.yaml` 파일에 에셋을 추가합니다. 
(자세한 내용은 [에셋 및 이미지 추가][Adding assets and images] 참조)

```yaml diff
  flutter:
    assets:
+     - assets/loading.gif
```

그런 다음, [`FadeInImage.assetNetwork()`][] 생성자를 사용합니다.

<?code-excerpt "lib/asset_main.dart (AssetNetwork)" replace="/^child\: //g"?>
```dart
FadeInImage.assetNetwork(
  placeholder: 'assets/loading.gif',
  image: 'https://picsum.photos/250?image=9',
),
```

### 완성된 예제 {:#complete-example-1}

<?code-excerpt "lib/asset_main.dart"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Fade in images';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: Center(
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/loading.gif',
            image: 'https://picsum.photos/250?image=9',
          ),
        ),
      ),
    );
  }
}
```

![Asset fade-in](/assets/images/docs/cookbook/fading-in-asset-demo.gif){:.site-mobile-screenshot}


[Adding assets and images]: /ui/assets/assets-and-images
[`FadeInImage`]: {{site.api}}/flutter/widgets/FadeInImage-class.html
[`FadeInImage.assetNetwork()`]: {{site.api}}/flutter/widgets/FadeInImage/FadeInImage.assetNetwork.html
[`transparent_image`]: {{site.pub-pkg}}/transparent_image
