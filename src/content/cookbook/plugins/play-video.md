---
# title: Play and pause a video
title: 비디오 재생 및 일시 정지
# description: How to use the video_player plugin.
description: video_player 플러그인을 사용하는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/plugins/play_video/"?>

비디오 재생은 앱 개발에서 일반적인 작업이며, Flutter 앱도 예외는 아닙니다. 
비디오를 재생하기 위해, Flutter 팀은 [`video_player`][] 플러그인을 제공합니다. 
`video_player` 플러그인을 사용하면 파일 시스템, asset 또는 인터넷에 저장된 비디오를 재생할 수 있습니다.

:::warning
현재 `video_player` 플러그인은 Linux와 Windows에서 작동하지 않습니다. 
자세한 내용은 [`video_player`][] 패키지를 확인하세요.
:::

iOS에서, `video_player` 플러그인은 재생을 처리하기 위해 [`AVPlayer`][]를 사용합니다. 
Android에서는, [`ExoPlayer`][]를 사용합니다.

이 레시피는 다음 단계를 사용하여 기본 재생 및 일시 정지 컨트롤을 사용하여, 
인터넷에서 비디오를 스트리밍하는 `video_player` 패키지를 사용하는 방법을 보여줍니다.

  1. `video_player` 종속성을 추가합니다.
  2. 앱에 권한을 추가합니다.
  3. `VideoPlayerController`를 만들고 초기화합니다.
  4. 비디오 플레이어를 표시합니다.
  5. 비디오를 재생하고 일시 정지합니다.

## 1. `video_player` 종속성 추가 {:#1-add-the-video_player-dependency}

이 레시피는 하나의 Flutter 플러그인인 `video_player`에 의존합니다.
먼저, 이 종속성을 프로젝트에 추가합니다.

`video_player` 패키지를 종속성으로 추가하려면 `flutter pub add`를 실행합니다.

```console
$ flutter pub add video_player
```

## 2. 앱에 권한 추가 {:#2-add-permissions-to-your-app}

다음으로, 앱이 인터넷에서 비디오를 스트리밍할 수 있는 올바른 권한이 있는지 확인하기 위해
`android` 및 `ios` 구성을 업데이트합니다.

### Android

`AndroidManifest.xml` 파일의 `<application>` 정의 바로 뒤에 다음 권한을 추가합니다. 
`AndroidManifest.xml` 파일은 `<project root>/android/app/src/main/AndroidManifest.xml`에서 찾을 수 있습니다.

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application ...>

    </application>

    <uses-permission android:name="android.permission.INTERNET"/>
</manifest>
```

### iOS

iOS의 경우, `<project root>/ios/Runner/Info.plist`에 있는 `Info.plist` 파일에 다음을 추가합니다.

```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```

:::warning
`video_player` 플러그인은 iOS 시뮬레이터에서만 asset 비디오를 재생할 수 있습니다.
실제 iOS 기기에서는 네트워크 호스팅 비디오를 테스트해야 합니다.
:::

### macOS

네트워크 기반 비디오를 사용하는 경우, [`com.apple.security.network.client` 권한(entitlement)][mac-entitlement]을 추가하세요.

### Web

Flutter 웹은 `dart:io`를 **지원하지 않으므로**, 플러그인에 `VideoPlayerController.file` 생성자를 사용하지 마세요.
이 생성자를 사용하면 `UnimplementedError`를 throw하는 `VideoPlayerController.file`을 만들려고 시도합니다.

다른 웹 브라우저는, 지원되는 형식이나 자동 재생과 같이, 비디오 재생 기능이 다를 수 있습니다. 
웹에 대한 자세한 내용은 [video_player_web][] 패키지를 확인하세요.

`VideoPlayerOptions.mixWithOthers` 옵션은 적어도 현재로서는 웹에서 구현할 수 없습니다. 
웹에서 이 옵션을 사용하면 자동으로 무시됩니다.

## 3.`VideoPlayerController` 생성 및 초기화{:#3-create-and-initialize-a-videoplayercontroller}

이제 올바른 권한으로 `video_player` 플러그인을 설치했으므로, `VideoPlayerController`를 만듭니다.
`VideoPlayerController` 클래스를 사용하면 다양한 타입의 비디오에 연결하고 재생을 제어할 수 있습니다.

비디오를 재생하기 전에, 컨트롤러를 `initialize`해야 합니다. 
이렇게 하면 비디오에 대한 연결이 설정되고 재생을 위해 컨트롤러가 준비됩니다.

`VideoPlayerController`를 만들고 초기화하려면, 다음을 수행합니다.

  1. 동반 `State` 클래스와 함께 `StatefulWidget`을 만듭니다.
  2. `VideoPlayerController`를 저장할 변수를 `State` 클래스에 추가합니다.
  3. `VideoPlayerController.initialize`에서 반환된 `Future`를 저장할 변수를 `State` 클래스에 추가합니다.
  4. `initState` 메서드에서 컨트롤러를 만들고 초기화합니다.
  5. `dispose` 메서드에서 컨트롤러를 삭제합니다.

<?code-excerpt "lib/main_step3.dart (VideoPlayerScreen)"?>
```dart
class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    // VideoPlayerController를 생성하고 저장합니다. 
    // VideoPlayerController는 assets, 파일 또는 인터넷에서 
    // 비디오를 재생하기 위한 여러 가지 생성자를 제공합니다.
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      ),
    );

    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // VideoPlayerController를 삭제하여 리소스를 확보하세요.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 다음 단계에서 코드를 완성합니다.
    return Container();
  }
}
```

## 4. 비디오 플레이어 표시 {:#4-display-the-video-player}

이제, 비디오를 표시합니다. 
`video_player` 플러그인은 `VideoPlayerController`에서 초기화된 비디오를 표시하는 
[`VideoPlayer`][] 위젯을 제공합니다. 
기본적으로, `VideoPlayer` 위젯은 가능한 한 많은 공간을 차지합니다. 
이는 비디오가, 16x9 또는 4x3과 같이, 특정 종횡비로 표시되도록 되어 있기 때문에, 비디오에 이상적이지 않은 경우가 많습니다.

따라서, `VideoPlayer` 위젯을 [`AspectRatio`][] 위젯으로 래핑하여 비디오의 비율이 올바른지 확인합니다.

또한, `_initializeVideoPlayerFuture()`가 완료된 후에 `VideoPlayer` 위젯을 표시해야 합니다. 
`FutureBuilder`를 사용하여 컨트롤러가 초기화를 완료할 때까지 로딩 스피너를 표시합니다. 
참고: 컨트롤러를 초기화해도 재생이 시작되지 않습니다.

<?code-excerpt "lib/main.dart (FutureBuilder)" replace="/body: //g;/^\),$/)/g"?>
```dart
// VideoPlayerController가 초기화를 완료할 때까지 
// 로딩 스피너를 표시하려면 FutureBuilder를 사용합니다.
FutureBuilder(
  future: _initializeVideoPlayerFuture,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      // VideoPlayerController가 초기화를 완료하면, 
      // 제공된 데이터를 사용하여 비디오의 종횡비를 제한합니다.
      return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        // VideoPlayer 위젯을 사용하여 비디오를 표시하세요.
        child: VideoPlayer(_controller),
      );
    } else {
      // VideoPlayerController가 아직 초기화 중이면, 로딩 스피너를 표시합니다.
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  },
)
```

## 5. 비디오를 재생하고 일시 정지 {:#5-play-and-pause-the-video}

기본적으로, 비디오는 일시 정지 상태에서 시작합니다. 
재생을 시작하려면, `VideoPlayerController`에서 제공하는 [`play()`][] 메서드를 호출합니다. 
재생을 일시 정지하려면, [`pause()`][] 메서드를 호출합니다.

이 예에서는, 상황에 따라 재생 또는 일시 정지 아이콘을 표시하는 `FloatingActionButton`을 앱에 추가합니다. 
사용자가 버튼을 탭하면, 현재 일시 정지된 경우 비디오를 재생하고, 재생 중인 경우 비디오를 일시 정지합니다.

<?code-excerpt "lib/main.dart (FAB)" replace="/^floatingActionButton: //g;/^\),$/)/g"?>
```dart
FloatingActionButton(
  onPressed: () {
    // 재생 또는 일시 정지를 `setState` 호출로 래핑합니다. 
    // 이렇게 하면 올바른 아이콘이 표시됩니다.
    setState(() {
      // 동영상이 재생 중이면 일시 정지하세요.
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        // 동영상이 일시 정지되어 있으면 재생하세요.
        _controller.play();
      }
    });
  },
  // 플레이어의 상태에 따라 올바른 아이콘을 표시합니다.
  child: Icon(
    _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
  ),
)
```

## 완성된 예제 {:#complete-example}

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter video player hands-on example in DartPad" run="true"
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(const VideoPlayerApp());

class VideoPlayerApp extends StatelessWidget {
  const VideoPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Video Player Demo',
      home: VideoPlayerScreen(),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    // VideoPlayerController를 생성하고 저장합니다. 
    // VideoPlayerController는 assets, 파일 또는 인터넷에서 
    // 비디오를 재생하기 위한 여러 가지 생성자를 제공합니다.
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      ),
    );

    // 컨트롤러를 초기화하고 나중에 사용할 수 있도록 Future를 저장합니다.
    _initializeVideoPlayerFuture = _controller.initialize();

    // 컨트롤러를 사용하여 비디오를 반복합니다.
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    // VideoPlayerController를 삭제하여 리소스를 확보하세요.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Butterfly Video'),
      ),
      // VideoPlayerController가 초기화를 완료할 때까지 
      // 로딩 스피너를 표시하려면 FutureBuilder를 사용합니다.
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // VideoPlayerController가 초기화를 완료하면, 
            // 제공된 데이터를 사용하여 비디오의 종횡비를 제한합니다.
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              // VideoPlayer 위젯을 사용하여 비디오를 표시하세요.
              child: VideoPlayer(_controller),
            );
          } else {
            // VideoPlayerController가 아직 초기화 중이면, 로딩 스피너를 표시합니다.
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 재생 또는 일시 정지를 `setState` 호출로 래핑합니다. 
          // 이렇게 하면 올바른 아이콘이 표시됩니다.
          setState(() {
            // 동영상이 재생 중이면 일시 정지하세요.
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // 동영상이 일시 정지되어 있으면 재생하세요.
              _controller.play();
            }
          });
        },
        // 플레이어의 상태에 따라 올바른 아이콘을 표시합니다.
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
```


[`AspectRatio`]: {{site.api}}/flutter/widgets/AspectRatio-class.html
[`AVPlayer`]: {{site.apple-dev}}/documentation/avfoundation/avplayer
[`ExoPlayer`]: https://google.github.io/ExoPlayer/
[`pause()`]: {{site.pub-api}}/video_player/latest/video_player/VideoPlayerController/pause.html
[`play()`]: {{site.pub-api}}/video_player/latest/video_player/VideoPlayerController/play.html
[`video_player`]: {{site.pub-pkg}}/video_player
[`VideoPlayer`]: {{site.pub-api}}/video_player/latest/video_player/VideoPlayer-class.html
[mac-entitlement]: {{site.url}}/platform-integration/macos/building#entitlements-and-the-app-sandbox
[video_player_web]: {{site.pub-pkg}}/video_player_web
