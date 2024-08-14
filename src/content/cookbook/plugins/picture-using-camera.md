---
# title: Take a picture using the camera
title: 카메라를 사용하여 사진 촬영
# description: How to use a camera plugin on mobile.
description: 모바일에서 카메라 플러그인을 사용하는 방법.
---

<?code-excerpt path-base="cookbook/plugins/picture_using_camera/"?>

많은 앱은 사진과 비디오를 찍기 위해 기기의 카메라와 함께 작업해야 합니다. 
Flutter는 이 목적을 위해 [`camera`][] 플러그인을 제공합니다. 
`camera` 플러그인은 사용 가능한 카메라 목록을 가져오고, 
특정 카메라에서 나오는 미리보기를 표시하고, 
사진이나 비디오를 찍는 도구를 제공합니다.

:::note
[CameraX][] Android 라이브러리 위에 구축된, [`camera_android_camerax`][] 플러그인은, 
기기의 기능에 따라 해상도를 자동으로 선택하여 이미지 해상도를 개선합니다.
이 플러그인은 예상대로 작동하지 않을 수 있는 카메라 하드웨어로 정의된 
_기기의 괴짜(device quirks)_ 를 처리하는 데에도 도움이 됩니다.

자세한 내용은, Google I/O 2024 토크, 
[CameraX를 사용하여 Flutter에서 완벽한 사진 카메라 경험 구축][camerax-video]를 확인하세요.
:::

[`camera_android_camerax`]: {{site.pub-pkg}}/camera_android_camerax
[CameraX]: https://developer.android.com/training/camerax
[camerax-video]: {{site.youtube-site}}/watch?v=d1sRCa5k2Sg&t=1s

이 레시피는, 다음의 단계들로, `camera` 플러그인을 사용하여 미리보기를 표시하고, 사진을 찍고, 표시하는 방법을 보여줍니다.

  1. 필요한 종속성을 추가합니다.
  2. 사용 가능한 카메라 리스트를 가져옵니다.
  3. `CameraController`를 만들고 초기화합니다.
  4. `CameraPreview`를 사용하여 카메라 피드를 표시합니다.
  5. `CameraController`로 사진을 찍습니다.
  6. `Image` 위젯으로 사진을 표시합니다.

## 1. 필요한 종속성 추가 {:#1-add-the-required-dependencies}

이 레시피를 완료하려면, 앱에 세 가지 종속성을 추가해야 합니다.

[`camera`][]
: 기기의 카메라와 함께 작동하는 도구를 제공합니다.

[`path_provider`][]
: 이미지를 저장할 올바른 경로를 찾습니다.

[`path`][]
: 모든 플랫폼에서 작동하는 경로를 만듭니다.

패키지를 종속성으로 추가하려면, `flutter pub add`를 실행합니다.

```console
$ flutter pub add camera path_provider path
```

:::tip
- 안드로이드의 경우, `minSdkVersion`을 21(또는 그 이상)로 업데이트해야 합니다.
- iOS의 경우, 카메라와 마이크에 접근하려면 `ios/Runner/Info.plist` 내부에 다음 줄을 추가해야 합니다.

  ```xml
  <key>NSCameraUsageDescription</key>
  <string>Explanation on why the camera access is needed.</string>
  <key>NSMicrophoneUsageDescription</key>
  <string>Explanation on why the microphone access is needed.</string>
  ```
:::

## 2. 사용 가능한 카메라 리스트를 가져오기 {:#2-get-a-list-of-the-available-cameras}

다음으로, `camera` 플러그인을 사용하여 사용 가능한 카메라 리스트를 가져옵니다.

<?code-excerpt "lib/main.dart (init)"?>
```dart
// `availableCameras()`가 `runApp()` 전에 호출될 수 있도록, 
// 플러그인 서비스가 초기화되었는지 확인하세요.
WidgetsFlutterBinding.ensureInitialized();

// 장치에서 사용 가능한 카메라 리스트를 얻습니다.
final cameras = await availableCameras();

// 사용 가능한 카메라 리스트에서 특정 카메라를 가져옵니다.
final firstCamera = cameras.first;
```

## 3. `CameraController`를 만들고 초기화 {:#3-create-and-initialize-the-cameracontroller}

카메라가 있으면, 다음 단계에 따라 `CameraController`를 만들고 초기화합니다. 
이 프로세스는 장치의 카메라에 대한 연결을 설정하여 카메라를 제어하고, 카메라 피드의 미리보기를 표시할 수 있습니다.

  1. 동반 `State` 클래스와 함께 `StatefulWidget`을 만듭니다.
  2. `CameraController`를 저장할 변수를 `State` 클래스에 추가합니다.
  3. `CameraController.initialize()`에서 반환된 `Future`를 저장할 변수를 `State` 클래스에 추가합니다.
  4. `initState()` 메서드에서 컨트롤러를 만들고 초기화합니다.
  5. `dispose()` 메서드에서 컨트롤러를 삭제합니다.

<?code-excerpt "lib/main_step3.dart (controller)" remove="ignore:"?>
```dart
// 사용자가 주어진 camera를 사용해 사진을 찍을 수 있는 화면.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // Camera의 현재 출력을 표시하려면, CameraController를 만듭니다.
    _controller = CameraController(
      // 사용 가능한 카메라 리스트에서 특정 카메라를 가져옵니다.
      widget.camera,
      // 사용할 해상도를 정의합니다.
      ResolutionPreset.medium,
    );

    // 다음으로, 컨트롤러를 초기화합니다. 이것은 Future를 반환합니다.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // 위젯이 삭제되면 컨트롤러도 삭제됩니다.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 다음 단계에서 이를 작성합니다.
    return Container();
  }
}
```

:::warning
`CameraController`를 초기화하지 않으면, 
카메라를 사용하여 미리보기를 표시하고 사진을 *찍을 수 없습니다.*
:::

## 4. `CameraPreview`를 사용하여 카메라 피드를 표시{:#4-use-a-camerapreview-to-display-the-cameras-feed}

다음으로, `camera` 패키지의 `CameraPreview` 위젯을 사용하여 카메라 피드의 미리보기를 표시합니다.

:::note 기억하세요.
카메라 작업을 하기 전에 컨트롤러가 초기화를 마칠 때까지 기다려야 합니다. 
따라서, 이전 단계에서 만든 `_initializeControllerFuture()`가 완료될 때까지 기다려야, 
`CameraPreview`를 표시할 수 있습니다.
:::

바로 이 목적을 위해 [`FutureBuilder`][]를 사용하세요.

<?code-excerpt "lib/main.dart (FutureBuilder)" replace="/body: //g;/^\),$/)/g"?>
```dart
// 카메라 미리보기를 표시하기 전에 컨트롤러가 초기화될 때까지 기다려야 합니다. 
// 컨트롤러가 초기화를 마칠 때까지 로딩 스피너를 표시하려면 FutureBuilder를 사용합니다.
FutureBuilder<void>(
  future: _initializeControllerFuture,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      // Future가 완료되면, 미리보기를 표시합니다.
      return CameraPreview(_controller);
    } else {
      // 그렇지 않은 경우, 로딩 표시기를 표시합니다.
      return const Center(child: CircularProgressIndicator());
    }
  },
)
```

## 5. `CameraController`로 사진 찍기 {:#5-take-a-picture-with-the-cameracontroller}

`CameraController`를 사용하면 [`takePicture()`][] 메서드를 사용하여 사진을 찍을 수 있습니다. 
이 메서드는 크로스 플랫폼의 단순화된 `File` 추상화인 [`XFile`][]을 반환합니다.
Android와 IOS에서, 새 이미지는 각각의 캐시 디렉터리에 저장되고, 해당 위치의 `path`가 `XFile`에서 반환됩니다.

이 예에서, 사용자가 버튼을 탭하면 `CameraController`를 사용하여 사진을 찍는 `FloatingActionButton`을 만듭니다.

사진을 찍으려면 2단계가 필요합니다.

  1. 카메라가 초기화되었는지 확인합니다.
  2. 컨트롤러를 사용하여 사진을 찍고 `Future<XFile>`을 반환하는지 확인합니다.

발생할 수 있는 오류를 처리하기 위해 이러한 작업을 `try / catch` 블록으로 래핑하는 것이 좋습니다.

<?code-excerpt "lib/main_step5.dart (FAB)" replace="/^floatingActionButton: //g;/^\),$/)/g"?>
```dart
FloatingActionButton(
  // onPressed 콜백을 제공합니다.
  onPressed: () async {
    // try / catch 블록에서 사진을 찍습니다. 
    // 문제가 발생하면 오류를 catch 합니다.
    try {
      // 카메라가 초기화되었는지 확인하세요.
      await _initializeControllerFuture;

      // 사진을 찍어 본 다음, 이미지 파일이 저장된 위치를 확인해 보세요.
      final image = await _controller.takePicture();
    } catch (e) {
      // 오류가 발생하면, 콘솔에 오류를 기록하세요.
      print(e);
    }
  },
  child: const Icon(Icons.camera_alt),
)
```

## 6. `Image` 위젯으로 사진을 표시 {:#6-display-the-picture-with-an-image-widget}

사진을 성공적으로 찍으면, `Image` 위젯을 사용하여 저장된 사진을 표시할 수 있습니다. 
이 경우, 사진은 기기에 파일로 저장됩니다.

따라서, `Image.file` 생성자에 `File`을 제공해야 합니다. 
이전 단계에서 만든 경로를 전달하여 `File` 클래스의 인스턴스를 만들 수 있습니다.

<?code-excerpt "lib/image_file.dart (ImageFile)" replace="/^return\ //g"?>
```dart
Image.file(File('path/to/my/picture.png'));
```

## 완성된 예제 {:#complete-example}

<?code-excerpt "lib/main.dart"?>
```dart
import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // `availableCameras()`가 `runApp()` 전에 호출될 수 있도록, 
  // 플러그인 서비스가 초기화되었는지 확인하세요.
  WidgetsFlutterBinding.ensureInitialized();

  // 장치에서 사용 가능한 카메라 리스트를 얻습니다.
  final cameras = await availableCameras();

  // 사용 가능한 카메라 리스트에서 특정 카메라를 가져옵니다.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(
        // TakePictureScreen 위젯에 적절한 카메라를 전달합니다.
        camera: firstCamera,
      ),
    ),
  );
}

// 사용자가 주어진 camera를 사용해 사진을 찍을 수 있는 화면.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // Camera의 현재 출력을 표시하려면, CameraController를 만듭니다.
    _controller = CameraController(
      // 사용 가능한 카메라 리스트에서 특정 카메라를 가져옵니다.
      widget.camera,
      // 사용할 해상도를 정의합니다.
      ResolutionPreset.medium,
    );

    // 다음으로, 컨트롤러를 초기화합니다. 이것은 Future를 반환합니다.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // 위젯이 삭제되면 컨트롤러도 삭제됩니다.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // 카메라 미리보기를 표시하기 전에, 컨트롤러가 초기화될 때까지 기다려야 합니다. 
      // 컨트롤러가 초기화를 마칠 때까지 로딩 스피너를 표시하려면, FutureBuilder를 사용합니다.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Future가 완료되면, 미리보기를 표시합니다.
            return CameraPreview(_controller);
          } else {
            // 그렇지 않은 경우, 로딩 표시기를 표시합니다.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed 콜백을 제공합니다.
        onPressed: () async {
          // try / catch 블록에서 사진을 찍습니다. 
          // 문제가 발생하면 오류를 catch 합니다.
          try {
            // 카메라가 초기화되었는지 확인하세요.
            await _initializeControllerFuture;

            // 사진을 찍어 본 다음, 이미지 파일이 저장된 위치를 확인해 보세요.
            final image = await _controller.takePicture();

            if (!context.mounted) return;

            // 사진이 촬영된 경우, 새 화면에 표시하세요.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // 자동 생성된 경로를 DisplayPictureScreen 위젯에 전달합니다.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // 오류가 발생하면, 콘솔에 오류를 기록하세요.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// 사용자가 찍은 사진을 표시하는 위젯입니다.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // 이미지는 장치에 파일로 저장됩니다. 
      // 주어진 경로로 `Image.file` 생성자를 사용하여 이미지를 표시합니다.
      body: Image.file(File(imagePath)),
    );
  }
}
```


[`camera`]: {{site.pub-pkg}}/camera
[`FutureBuilder`]: {{site.api}}/flutter/widgets/FutureBuilder-class.html
[`path`]: {{site.pub-pkg}}/path
[`path_provider`]: {{site.pub-pkg}}/path_provider
[`takePicture()`]: {{site.pub}}/documentation/camera/latest/camera/CameraController/takePicture.html
[`XFile`]:  {{site.pub}}/documentation/cross_file/latest/cross_file/XFile-class.html
