다음 예제에서는 `/path/to/MyApp/Flutter/`에 프레임워크를 생성하려고 한다고 가정합니다.

```console
$ flutter build ios-framework --output=/path/to/MyApp/Flutter/
```

Flutter 모듈에서 코드를 변경할 때마다 _매번_ 이것을 실행합니다.

결과 프로젝트 구조는 이 디렉토리 트리와 유사해야 합니다.

```plaintext
/path/to/MyApp/
└── Flutter/
    ├── Debug/
    │   ├── Flutter.xcframework
    │   ├── App.xcframework
    │   ├── FlutterPluginRegistrant.xcframework (iOS 플랫폼 코드가 있는 플러그인이 있는 경우에만)
    │   └── example_plugin.xcframework (각 플러그인은 별도의 프레임워크입니다)
    ├── Profile/
    │   ├── Flutter.xcframework
    │   ├── App.xcframework
    │   ├── FlutterPluginRegistrant.xcframework
    │   └── example_plugin.xcframework
    └── Release/
        ├── Flutter.xcframework
        ├── App.xcframework
        ├── FlutterPluginRegistrant.xcframework
        └── example_plugin.xcframework
```

:::warning
항상 동일한 디렉토리에 있는 `Flutter.xcframework` 및 `App.xcframework` 번들을 사용하세요. 
다른 디렉토리에서 가져온 `.xcframework`를 섞으면(예: `Profile/Flutter.xcframework`와 `Debug/App.xcframework`), 런타임 충돌이 발생합니다.
:::
