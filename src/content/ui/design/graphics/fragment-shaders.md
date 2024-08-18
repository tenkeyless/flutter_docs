---
# title: Writing and using fragment shaders
title: 프래그먼트 셰이더 작성 및 사용
# description: How to author and use fragment shaders to create custom visual effects in your Flutter app.
description: Flutter 앱에서 커스텀 시각 효과를 만들기 위해 프래그먼트 셰이더를 작성하고 사용하는 방법.
# short-title: Fragment shaders
short-title: 프래그먼트 셰이더
---

:::note
Skia와 [Impeller][] 백엔드는 모두 커스텀 셰이더 작성을 지원합니다. 
별도로 언급된 경우를 제외하고, 동일한 지침이 두 가지 모두에 적용됩니다.
:::

[Impeller]: /perf/impeller

커스텀 셰이더는 Flutter SDK에서 제공하는 것 이상의 풍부한 그래픽 효과를 제공하는 데 사용할 수 있습니다. 
셰이더는 GLSL이라고 알려진 작은 Dart 유사 언어로 작성된 프로그램이며 사용자의 GPU에서 실행됩니다.

사용자 정의 셰이더는 `pubspec.yaml` 파일에 나열하여 Flutter 프로젝트에 추가하고, 
[`FragmentProgram`][] API를 사용하여 가져옵니다.

[`FragmentProgram`]: {{site.api}}/flutter/dart-ui/FragmentProgram-class.html

## 애플리케이션에 셰이더 추가 {:#adding-shaders-to-an-application}

`.frag` 확장자를 가진 GLSL 파일 형태의 셰이더는, 프로젝트의 `pubspec.yaml` 파일의 `shaders` 섹션에서 선언해야 합니다. Flutter 명령줄 도구는 셰이더를 적절한 백엔드 형식으로 컴파일하고, 필요한 런타임 메타데이터를 생성합니다. 
그런 다음, 컴파일된 셰이더는 asset처럼 애플리케이션에 포함됩니다.

```yaml
flutter:
  shaders:
    - shaders/myshader.frag
```

디버그 모드에서 실행할 때, 셰이더 프로그램을 변경하면 재컴파일이 트리거되고, 핫 리로드 또는 핫 재시작 중에 셰이더가 업데이트됩니다.

패키지의 셰이더는 셰이더 프로그램 이름 앞에 `packages/$pkgname`이 접두사로 붙은 프로젝트에 추가됩니다.
(여기서 `$pkgname`은 패키지 이름입니다)

### 런타임에 셰이더 로딩 {:#loading-shaders-at-runtime}

런타임에 `FragmentProgram` 객체에 셰이더를 로드하려면, [`FragmentProgram.fromAsset`][] 생성자를 사용합니다. 
asset의 이름은 `pubspec.yaml` 파일에 제공된 셰이더 경로와 동일합니다.

[`FragmentProgram.fromAsset`]: {{site.api}}/flutter/dart-ui/FragmentProgram/fromAsset.html

```dart
void loadMyShader() async {
  var program = await FragmentProgram.fromAsset('shaders/myshader.frag');
}
```

`FragmentProgram` 객체는 하나 이상의 [`FragmentShader`][] 인스턴스를 생성하는 데 사용할 수 있습니다. 
`FragmentShader` 객체는 특정 _uniforms_(구성 매개변수) 세트와 함께 프래그먼트 프로그램을 나타냅니다. 
사용 가능한 uniforms는 셰이더가 정의된 방식에 따라 달라집니다.

[`FragmentShader`]: {{site.api}}/flutter/dart-ui/FragmentShader-class.html

```dart
void updateShader(Canvas canvas, Rect rect, FragmentProgram program) {
  var shader = program.fragmentShader();
  shader.setFloat(0, 42.0);
  canvas.drawRect(rect, Paint()..shader = shader);
}
```

### Canvas API {:#canvas-api}

대부분의 Canvas API에서 [`Paint.shader`][]를 설정하여 프래그먼트 셰이더를 사용할 수 있습니다. 
예를 들어, [`Canvas.drawRect`][]를 사용하는 경우 셰이더는 사각형 내의 모든 프래그먼트에 대해 평가됩니다. 
스트로크 경로가 있는 [`Canvas.drawPath`][]와 같은 API의 경우, 셰이더는 스트로크 선 내의 모든 프래그먼트에 대해 평가됩니다. [`Canvas.drawImage`][]와 같은 일부 API는, 셰이더 값을 무시합니다.

[`Canvas.drawImage`]:  {{site.api}}/flutter/dart-ui/Canvas/drawImage.html
[`Canvas.drawRect`]:   {{site.api}}/flutter/dart-ui/Canvas/drawRect.html
[`Canvas.drawPath`]:   {{site.api}}/flutter/dart-ui/Canvas/drawPath.html
[`Paint.shader`]:      {{site.api}}/flutter/dart-ui/Paint/shader.html

```dart
void paint(Canvas canvas, Size size, FragmentShader shader) {
  // 셰이더를 색상 소스로 사용하여 사각형을 그립니다.
  canvas.drawRect(
    Rect.fromLTWH(0, 0, size.width, size.height),
    Paint()..shader = shader,
  );

  // 셰이더를 선 안에 있는 프로그먼트에만 적용하여 선이 그어진 사각형을 그립니다.
  canvas.drawRect(
    Rect.fromLTWH(0, 0, size.width, size.height),
    Paint()
      ..style = PaintingStyle.stroke
      ..shader = shader,
  )
}

```

## 셰이더 작성(Authoring) {:#authoring-shaders}

프래그먼트 셰이더는 GLSL 소스 파일로 작성됩니다. 
관례에 따라, 이러한 파일은 `.frag` 확장자를 갖습니다. 
(Flutter는 `.vert` 확장자를 갖는 정점 셰이더를 지원하지 않습니다.)

460에서 100까지의 모든 GLSL 버전이 지원되지만, 일부 사용 가능한 기능은 제한됩니다. 
이 문서의 나머지 예제는 `460 core` 버전을 사용합니다.

셰이더는 Flutter와 함께 사용할 경우 다음과 같은 제한 사항이 적용됩니다.

* UBO 및 SSBO는 지원되지 않습니다.
* `sampler2D`가 유일하게 지원되는 샘플러 유형입니다.
* `texture`의 두 인수 버전(sampler 및 uv)만 지원됩니다.
* 추가 가변 입력을 선언할 수 없습니다.
* Skia를 타겟팅할 때 모든 정밀도 힌트가 무시됩니다.
* 부호 없는 정수(Unsigned integers) 및 booleans은 지원되지 않습니다.

### Uniforms {:#uniforms}

프래그먼트 프로그램은 GLSL 셰이더 소스에서 `uniform` 값을 정의한 다음, 
각 프래그먼트 셰이더 인스턴스에 대해 Dart에서 이 값을 설정하여 구성할 수 있습니다.

GLSL 타입 `float`, `vec2`, `vec3`, `vec4`를 갖는 부동 소수점 유니폼은, 
[`FragmentShader.setFloat`][] 메서드를 사용하여 설정됩니다. 
`sampler2D` 타입을 사용하는 GLSL 샘플러 값은, 
[`FragmentShader.setImageSampler`][] 메서드를 사용하여 설정됩니다.

각 `uniform` 값의 올바른 인덱스는 프래그먼트 프로그램에서 유니폼 값이 정의된 순서에 따라 결정됩니다. 
`vec4`와 같이 여러 개의 부동 소수점으로 구성된 데이터 타입의 경우, 
각 값에 대해 [`FragmentShader.setFloat`][]를 한 번씩 호출해야 합니다.

[`FragmentShader.setFloat`]: {{site.api}}/flutter/dart-ui/FragmentShader/setFloat.html
[`FragmentShader.setImageSampler`]: {{site.api}}/flutter/dart-ui/FragmentShader/setImageSampler.html

예를 들어, GLSL 프래그먼트 프로그램에서 다음과 같은 uniforms 선언이 주어졌다고 가정해 보겠습니다.

```glsl
uniform float uScale;
uniform sampler2D uTexture;
uniform vec2 uMagnitude;
uniform vec4 uColor;
```

이러한 `uniform` 값을 초기화하는 해당 Dart 코드는 다음과 같습니다.

```dart
void updateShader(FragmentShader shader, Color color, Image image) {
  shader.setFloat(0, 23);  // uScale
  shader.setFloat(1, 114); // uMagnitude x
  shader.setFloat(2, 83);  // uMagnitude y

  // color를 미리 곱해진(premultiplied) opacity로 변환합니다.
  shader.setFloat(3, color.red / 255 * color.opacity);   // uColor r
  shader.setFloat(4, color.green / 255 * color.opacity); // uColor g
  shader.setFloat(5, color.blue / 255 * color.opacity);  // uColor b
  shader.setFloat(6, color.opacity);                     // uColor a

  // 샘플러 유니폼을 초기화합니다.
  shader.setImageSampler(0, image);
 }
 ```

Any float uniforms that are left uninitialized will default to `0.0`.

[`FragmentShader.setFloat`][]와 함께 사용된 인덱스는 `sampler2D` 유니폼을 계산하지 않는다는 점에 유의하세요. 
이 유니폼은 [`FragmentShader.setImageSampler`][]와 별도로 설정되며, 인덱스는 0에서 시작합니다.

초기화되지 않은 모든 float 유니폼은 기본적으로 `0.0`으로 설정됩니다.

#### 현재 위치 {:#current-position}

셰이더는 평가되는 특정 프래그먼트에 대한 로컬 좌표를 포함하는 `varying` 값에 액세스할 수 있습니다. 
이 기능을 사용하여 현재 위치에 따라 달라지는 효과를 계산합니다. 
이는 `flutter/runtime_effect.glsl` 라이브러리를 import 하고, 
`FlutterFragCoord` 함수를 호출하여 액세스할 수 있습니다. 예를 들어:

```glsl
#include <flutter/runtime_effect.glsl>

void main() {
  vec2 currentPos = FlutterFragCoord().xy;
}
```

`FlutterFragCoord`에서 반환된 값은 `gl_FragCoord`와 다릅니다. 
`gl_FragCoord`는 화면 공간 좌표를 제공하며, 일반적으로 셰이더가 백엔드에서 일관되도록(consistent) 하기 위해 피해야 합니다. 
Skia 백엔드를 타겟팅하는 경우, 
`gl_FragCoord`에 대한 호출은 로컬 좌표에 액세스하도록 다시 작성되지만, Impeller에서는 이 다시 작성이 불가능합니다.

#### Colors {:#colors}

색상에 대한 빌트인 데이터 타입은 없습니다. 
대신 일반적으로 각 구성 요소가 RGBA 색상 채널 중 하나에 해당하는 `vec4`로 표현됩니다.

단일 출력 `fragColor`는 색상 값이 `0.0`~`1.0` 범위로 정규화되고, 사전 곱해진 알파가 있다고 예상합니다. 
이는 `0-255` 값 인코딩을 사용하고, 사전 곱해지지 않은 알파가 있는, 일반적인 Flutter 색상과 다릅니다.

#### 샘플러 {:#samplers}

샘플러는 `dart:ui` `Image` 객체에 대한 액세스를 제공합니다. 
이 이미지는 디코딩된 이미지에서 또는 [`Scene.toImageSync`][] 또는 [`Picture.toImageSync`][]를 사용하여, 
애플리케이션의 일부에서 획득할 수 있습니다.

[`Picture.toImageSync`]: {{site.api}}/flutter/dart-ui/Picture/toImageSync.html
[`Scene.toImageSync`]: {{site.api}}/flutter/dart-ui/Scene/toImageSync.html

```glsl
#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform sampler2D uTexture;

out vec4 fragColor;

void main() {
  vec2 uv = FlutterFragCoord().xy / uSize;
  fragColor = texture(uTexture, uv);
}
```

기본적으로, 이미지는 [`TileMode.clamp`][]를 사용하여 `[0, 1]` 범위를 벗어난 값이 어떻게 동작하는지 결정합니다. 
타일 모드의 커스터마이즈는 지원되지 않으며, 셰이더에서 에뮬레이션해야 합니다.

[`TileMode.clamp`]: {{site.api}}/flutter/dart-ui/TileMode.html

### 성능 고려 사항 {:#performance-considerations}

Skia 백엔드를 타겟팅하는 경우, 런타임에 적절한 플랫폼별 셰이더로 컴파일해야 하므로, 
셰이더를 로드하는 데 비용이 많이 들 수 있습니다. 
애니메이션 중에 하나 이상의 셰이더를 사용하려는 경우, 
애니메이션을 시작하기 전에 프래그먼트 프로그램 객체를 미리 캐시하는 것을 고려하세요.

`FragmentShader` 객체를 여러 프레임에서 재사용할 수 있습니다. 
이는 각 프레임에 대해 새 `FragmentShader`를 만드는 것보다 효율적입니다.

성능이 뛰어난 셰이더를 작성하는 방법에 대한 자세한 가이드는, 
GitHub의 [효율적인 셰이더 작성][Writing efficient shaders]을 확인하세요.

[Shader compilation jank]: /perf/shader
[Writing efficient shaders]: {{site.repo.engine}}/blob/main/impeller/docs/shader_optimization.md

### 기타 리소스 {:#other-resources}

자세한 내용은 몇 가지 리소스를 참조하세요.

* [The Book of Shaders][], Patricio Gonzalez Vivo와 Jen Lowe 지음
* [Shader toy][], 협업 셰이더 플레이그라운드
* [`simple_shader`], 간단한 Flutter 프래그먼트 셰이더 샘플 프로젝트

[Shader toy]: https://www.shadertoy.com/
[The Book of Shaders]: https://thebookofshaders.com/
[`simple_shader`]: {{site.repo.samples}}/tree/main/simple_shader

