## 성능 {:#performance}

Flutter의 플랫폼 뷰는 성능 트레이드 오프가 따릅니다.

예를 들어, 일반적인 Flutter 앱에서 Flutter UI는 전용 래스터 스레드에서 구성됩니다. 
이를 통해 Flutter 앱은 빠르게 실행될 수 있는데, 메인 ​​플랫폼 스레드가 거의 차단되지 않기 때문입니다.

플랫폼 뷰는 하이브리드 구성으로 렌더링되는 반면, Flutter UI는 플랫폼 스레드에서 구성되며, 
이는 OS 또는 플러그인 메시지 처리와 같은 다른 작업과 경쟁합니다.

Android 10 이전에는 하이브리드 구성이 각 Flutter 프레임을 그래픽 메모리에서 메인 메모리로 복사한 다음, 
GPU 텍스처로 다시 복사했습니다. 
이 복사는 프레임당 수행되므로, 전체 Flutter UI의 성능에 영향을 미칠 수 있습니다.
Android 10 이상에서는 그래픽 메모리가 한 번만 복사됩니다.

반면 가상 디스플레이는, 네이티브 뷰의 각 픽셀을 추가 중간 그래픽 버퍼를 통해 흐르게 하여, 
그래픽 메모리와 그리기 성능을 저하시킵니다.

복잡한 경우, 이러한 문제를 완화하는 데 사용할 수 있는 몇 가지 기술이 있습니다.

예를 들어, Dart에서 애니메이션이 진행되는 동안 플레이스홀더 텍스처를 사용할 수 있습니다. 
즉, 플랫폼 뷰가 렌더링되는 동안 애니메이션이 느리면 네이티브 뷰의 스크린샷을 찍어 텍스처로 렌더링하는 것을 고려하세요.

자세한 내용은 다음을 참조하세요.

* [`TextureLayer`][]
* [`TextureRegistry`][]
* [`FlutterTextureRegistry`][]
* [`FlutterImageView`][]

[`FlutterImageView`]: {{site.api}}/javadoc/io/flutter/embedding/android/FlutterImageView.html
[`FlutterTextureRegistry`]: {{site.api}}/ios-embedder/protocol_flutter_texture_registry-p.html
[`TextureLayer`]: {{site.api}}/flutter/rendering/TextureLayer-class.html
[`TextureRegistry`]: {{site.api}}/javadoc/io/flutter/view/TextureRegistry.html
