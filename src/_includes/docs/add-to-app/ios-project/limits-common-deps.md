
Flutter는 [xcframeworks와의 공통 종속성][common]을 처리할 수 없습니다. 
호스트 앱과 Flutter 모듈의 플러그인이 모두 동일한 포드 종속성을 정의하고, 
이 옵션을 사용하여 Flutter 모듈을 통합하는 경우 오류가 발생합니다. 
이러한 오류에는 `Multiple commands generate 'CommonDependency.framework'`와 같은 문제가 포함됩니다.

이 문제를 해결하려면, Flutter 모듈의 `podspec` 파일에 있는 모든 플러그인 소스를 호스트 앱의 `Podfile`에 연결합니다. 
플러그인의 `xcframework` 프레임워크 대신 소스를 연결합니다. 
다음 섹션에서는 [해당 프레임워크를 생성하는 방법][ios-framework]을 설명합니다.

공통 종속성이 있을 때 발생하는 오류를 방지하려면, 
`flutter build ios-framework`를 `--no-plugins` 플래그와 함께 사용합니다.

[common]: https://github.com/flutter/flutter/issues/130220
[ios-framework]: https://github.com/flutter/flutter/issues/114692
