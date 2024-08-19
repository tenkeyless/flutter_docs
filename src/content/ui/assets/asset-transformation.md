---
# title: Transforming assets at build time
title: 빌드 시에 assets 변환
# description: How to set up automatic transformation of images (and other assets) in your Flutter app.
description: Flutter 앱에서 이미지(및 기타 assets)의 자동 변환을 설정하는 방법.
# short-title: Asset transformation
short-title: Asset 변환
---

호환되는 Dart 패키지를 사용하여, 빌드 시에 assets을 자동으로 변환하도록 프로젝트를 구성할 수 있습니다.

## asset 변환 지정 {:#specifying-asset-transformations}

`pubspec.yaml` 파일에서, 변환할 assets과 관련 transformer 패키지를 나열합니다.

```yaml
flutter:
  assets:
    - path: assets/logo.svg
      transformers:
        - package: vector_graphics_compiler
```

이 구성을 사용하면, `assets/logo.svg`는 빌드 출력에 복사될 때 [`vector_graphics_compiler`][] 패키지에 의해 변환됩니다. 
이 패키지는 SVG 파일을 다음과 같이 [`vector_graphics`][] 패키지를 사용하여 표시할 수 있는, 
최적화된 바이너리 파일로 사전 컴파일합니다.

<?code-excerpt "ui/assets_and_images/lib/logo.dart (TransformedAsset)"?>
```dart
import 'package:vector_graphics/vector_graphics.dart';

const Widget logo = VectorGraphic(
  loader: AssetBytesLoader('assets/logo.svg'),
);
```

### asset 변환기에 인수 전달 {:#passing-arguments-to-asset-transformers}

asset 변환기에 인수 문자열을 전달하려면, pubspec에서도 다음을 지정하세요.

```yaml
flutter:
  assets:
    - path: assets/logo.svg
      transformers:
        - package: vector_graphics_compiler
          args: ['--tessellate', '--font-size=14']
```

### asset 변환기 체이닝 {:#chaining-asset-transformers}

asset 변환기는 체인화될 수 있으며, 선언된 순서대로 적용됩니다. imaginary 패키지를 사용하는 다음 예를 고려하세요.

```yaml
flutter:
  assets:
    - path: assets/bird.png
      transformers:
        - package: grayscale_filter
        - package: png_optimizer
```

여기서, `bird.png`는 `grayscale_filter` 패키지에 의해 변환됩니다. 
그런 다음, 출력은 빌드된 앱에 번들로 제공되기 전에 `png_optimizer` 패키지에 의해 변환됩니다.

## asset 변환기 패키지 작성 {:#writing-asset-transformer-packages}

asset 변환기는 `dart run`과 함께 호출되는 Dart [명령줄 앱][command-line app]이며, 최소한 두 개의 인수를 포함합니다.
(1) 변환할 파일의 경로를 포함하는 `--input`과 (2) 변환기 코드가 출력을 써야 하는 위치인 `--output`입니다.

변환기 애플리케이션이 0이 아닌 종료 코드로 종료되면, 빌드가 실패하고 asset 변환이 실패했다는 오류 메시지가 표시됩니다. 
변환기가 프로세스의 [`stderr`] 스트림에 쓴 모든 내용은 오류 메시지에 포함됩니다.

## 샘플 {:#sample}

asset 변환을 사용하고 변환기로 사용되는 커스텀 Dart 패키지를 포함하는 샘플 Flutter 프로젝트의 경우, 
[Flutter 샘플 저장소의 asset_transformers 프로젝트][asset_transformers project in the Flutter samples repo]를 확인하세요.

[command-line app]: {{site.dart-site}}/tutorials/server/cmdline
[asset_transformers project in the Flutter samples repo]: {{site.repo.samples}}/tree/main/asset_transformation
[`vector_graphics_compiler`]: {{site.pub}}/packages/vector_graphics_compiler
[`vector_graphics`]: {{site.pub}}//packages/vector_graphics
[`stderr`]: {{site.api}}/flutter/dart-io/Process/stderr.html
