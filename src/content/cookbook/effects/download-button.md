---
# title: Create a download button
title: 다운로드 버튼 생성
# description: How to implement a download button.
description: 다운로드 버튼을 구현하는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/effects/download_button"?>

앱은 장기 실행 동작을 실행하는 버튼으로 가득 차 있습니다. 
예를 들어, 버튼은 다운로드를 트리거하여, 다운로드 프로세스를 시작하고, 
시간이 지남에 따라 데이터를 수신한 다음, 다운로드된 자산에 대한 액세스를 제공할 수 있습니다. 
사용자에게 장기 실행 프로세스의 진행 상황을 보여주는 것이 유용하며, 버튼 자체는 이러한 피드백을 제공하기에 좋은 위치입니다. 
이 레시피에서는, 앱 다운로드 상태에 따라, 여러 시각적 상태를 전환하는 다운로드 버튼을 빌드합니다.

다음 애니메이션은 앱의 동작을 보여줍니다.

![The download button cycles through its stages](/assets/images/docs/cookbook/effects/DownloadButton.gif){:.site-mobile-screenshot}

## 새로운 stateless 위젯 정의 {:#define-a-new-stateless-widget}

버튼 위젯은 시간이 지남에 따라 모양을 변경해야 합니다. 
따라서, 커스텀 stateless 위젯으로 버튼을 구현해야 합니다.

`DownloadButton`이라는 새 stateless 위젯을 정의합니다.

<?code-excerpt "lib/stateful_widget.dart (DownloadButton)"?>
```dart
@immutable
class DownloadButton extends StatelessWidget {
  const DownloadButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // TODO:
    return const SizedBox();
  }
}
```

## 버튼의 가능한 시각적 상태 정의 {:#define-the-buttons-possible-visual-states}

다운로드 버튼의 시각적 표현은 주어진 다운로드 상태에 따라 달라집니다. 
다운로드의 가능한 상태를 정의한 다음, `DownloadButton`을 업데이트하여, 
`DownloadStatus`와 버튼이 한 상태에서 다른 상태로 애니메이션화되는 데 걸리는 시간인 `Duration`을 받습니다.

<?code-excerpt "lib/visual_states.dart (VisualStates)"?>
```dart
enum DownloadStatus {
  notDownloaded,
  fetchingDownload,
  downloading,
  downloaded,
}

@immutable
class DownloadButton extends StatelessWidget {
  const DownloadButton({
    super.key,
    required this.status,
    this.transitionDuration = const Duration(
      milliseconds: 500,
    ),
  });

  final DownloadStatus status;
  final Duration transitionDuration;

  @override
  Widget build(BuildContext context) {
    // TODO: 나중에 더 많은 내용을 추가할 것입니다.
    return const SizedBox();
  }
}
```

:::note
커스텀 위젯을 정의할 때마다, 모든 관련 정보를 부모로부터 위젯에 제공할지 또는 
위젯이 자체 내에서 애플리케이션 동작을 조율할지 결정해야 합니다. 

예를 들어, `DownloadButton`은 부모로부터 현재 `DownloadStatus`를 받을 수 있고, 
`DownloadButton`은 자체 `State` 객체 내에서 다운로드 프로세스를 조율할 수 있습니다. 

대부분 위젯의 경우, 가장 좋은 답은 위젯 내에서 동작을 관리하는 대신, 
부모로부터 위젯으로 관련 정보를 전달하는 것입니다. 
모든 관련 정보를 전달하면, 위젯의 재사용성이 높아지고, 테스트가 쉬워지고, 
향후 애플리케이션 동작을 쉽게 변경할 수 있습니다.
:::

## 버튼 모양 표시 {:#display-the-button-shape}

다운로드 버튼은 다운로드 상태에 따라 모양이 바뀝니다. 
버튼은 `notDownloaded` 및 `downloaded` 상태에서, 회색의 둥근 사각형을 표시합니다. 
버튼은 `fetchingDownload` 및 `downloading` 상태에서 투명한 원을 표시합니다.

현재 `DownloadStatus`를 기반으로, 
둥근 사각형 또는 원을 표시하는 `ShapeDecoration`이 있는 `AnimatedContainer`를 빌드합니다.

분리된 `Stateless` 위젯에서 모양의 위젯 트리를 정의하여 
주요 `build()` 메서드가 단순하게 유지되고, 그에 따라 추가되는 내용이 허용되도록 합니다. 
`Widget _buildSomething() {}`와 같이 위젯을 반환하는 함수를 만드는 대신, 
항상 성능이 더 좋은 `StatelessWidget` 또는 `StatefulWidget`을 만드는 것을 선호합니다. 

이에 대한 추가 고려 사항은 [문서]({{site.api}}/flutter/widgets/StatelessWidget-class.html) 또는 Flutter [YouTube 채널]({{site.yt.watch}}?v=IOyq-eTRhvo)의 전용 비디오에서 찾을 수 있습니다.

지금으로서는, `AnimatedContainer` child는 단지 `SizedBox` 뿐인데, 다른 단계에서 다시 다룰 것이기 때문입니다.

<?code-excerpt "lib/display.dart (Display)"?>
```dart
@immutable
class DownloadButton extends StatelessWidget {
  const DownloadButton({
    super.key,
    required this.status,
    this.transitionDuration = const Duration(
      milliseconds: 500,
    ),
  });

  final DownloadStatus status;
  final Duration transitionDuration;

  bool get _isDownloading => status == DownloadStatus.downloading;

  bool get _isFetching => status == DownloadStatus.fetchingDownload;

  bool get _isDownloaded => status == DownloadStatus.downloaded;

  @override
  Widget build(BuildContext context) {
    return ButtonShapeWidget(
      transitionDuration: transitionDuration,
      isDownloaded: _isDownloaded,
      isDownloading: _isDownloading,
      isFetching: _isFetching,
    );
  }
}

@immutable
class ButtonShapeWidget extends StatelessWidget {
  const ButtonShapeWidget({
    super.key,
    required this.isDownloading,
    required this.isDownloaded,
    required this.isFetching,
    required this.transitionDuration,
  });

  final bool isDownloading;
  final bool isDownloaded;
  final bool isFetching;
  final Duration transitionDuration;

  @override
  Widget build(BuildContext context) {
    var shape = const ShapeDecoration(
      shape: StadiumBorder(),
      color: CupertinoColors.lightBackgroundGray,
    );

    if (isDownloading || isFetching) {
      shape = ShapeDecoration(
        shape: const CircleBorder(),
        color: Colors.white.withOpacity(0),
      );
    }

    return AnimatedContainer(
      duration: transitionDuration,
      curve: Curves.ease,
      width: double.infinity,
      decoration: shape,
      child: const SizedBox(),
    );
  }
}
```

투명한 원이 보이지 않는데도 불구하고, `ShapeDecoration` 위젯이 필요한 이유가 궁금할 수 있습니다. 
보이지 않는 원의 목적은 원하는 애니메이션을 조율하는 것입니다. 
`AnimatedContainer`는 둥근 사각형으로 시작합니다. 
`DownloadStatus`가 `fetchingDownload`로 변경되면, 
`AnimatedContainer`는 둥근 사각형에서 원으로 애니메이션을 적용한 다음, 애니메이션이 실행되면서 페이드 아웃해야 합니다. 
이 애니메이션을 구현하는 유일한 방법은 둥근 사각형의 시작 모양과 원의 끝 모양을 모두 정의하는 것입니다. 
하지만, 마지막 원이 보이지 않게 하려고 하므로, 투명하게 만들어, 애니메이션 페이드 아웃을 발생시킵니다.

## 버튼 텍스트 표시 {:#display-the-button-text}

`DownloadButton`은 `notDownloaded` 단계에서 `GET`을 표시하고, 
`downloaded` 단계에서 `OPEN`을 표시하며, 그 사이에는 텍스트가 없습니다.

각 다운로드 단계에서 텍스트를 표시하는 위젯을 추가하고, 그 사이에 텍스트의 불투명도를 애니메이션으로 표시합니다. 
버튼 래퍼 위젯에서 `AnimatedContainer`의 자식으로 텍스트 위젯 트리를 추가합니다.

<?code-excerpt "lib/display_text.dart (DisplayText)"?>
```dart
@immutable
class ButtonShapeWidget extends StatelessWidget {
  const ButtonShapeWidget({
    super.key,
    required this.isDownloading,
    required this.isDownloaded,
    required this.isFetching,
    required this.transitionDuration,
  });

  final bool isDownloading;
  final bool isDownloaded;
  final bool isFetching;
  final Duration transitionDuration;

  @override
  Widget build(BuildContext context) {
    var shape = const ShapeDecoration(
      shape: StadiumBorder(),
      color: CupertinoColors.lightBackgroundGray,
    );

    if (isDownloading || isFetching) {
      shape = ShapeDecoration(
        shape: const CircleBorder(),
        color: Colors.white.withOpacity(0),
      );
    }

    return AnimatedContainer(
      duration: transitionDuration,
      curve: Curves.ease,
      width: double.infinity,
      decoration: shape,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: AnimatedOpacity(
          duration: transitionDuration,
          opacity: isDownloading || isFetching ? 0.0 : 1.0,
          curve: Curves.ease,
          child: Text(
            isDownloaded ? 'OPEN' : 'GET',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.activeBlue,
                ),
          ),
        ),
      ),
    );
  }
}
```

## 다운로드를 가져오는 동안 스피너 표시 {:#display-a-spinner-while-fetching-download}

`fetchingDownload` 단계 동안, `DownloadButton`은 방사형 스피너를 표시합니다. 
이 스피너는 `notDownloaded` 단계에서 페이드 인하고, `fetchingDownload` 단계로 페이드 아웃합니다.

버튼 모양 위에 위치하고 적절한 시간에 페이드 인 및 페이드 아웃하는 방사형 스피너를 구현합니다.

`ButtonShapeWidget`의 생성자를 제거하여, 빌드 메서드와 우리가 추가한 `Stack` 위젯에 초점을 맞췄습니다.

<?code-excerpt "lib/spinner.dart (Spinner)"?>
```dart
@override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: _onPressed,
    child: Stack(
      children: [
        ButtonShapeWidget(
          transitionDuration: transitionDuration,
          isDownloaded: _isDownloaded,
          isDownloading: _isDownloading,
          isFetching: _isFetching,
        ),
        Positioned.fill(
          child: AnimatedOpacity(
            duration: transitionDuration,
            opacity: _isDownloading || _isFetching ? 1.0 : 0.0,
            curve: Curves.ease,
            child: ProgressIndicatorWidget(
              downloadProgress: downloadProgress,
              isDownloading: _isDownloading,
              isFetching: _isFetching,
            ),
          ),
        ),
      ],
    ),
  );
}
```

## 다운로드 중 진행 상황과 중지 버튼 표시 {:#display-the-progress-and-a-stop-button-while-downloading}

`fetchingDownload` 단계 다음에는 `downloading` 단계가 있습니다. 
`downloading` 단계 동안, `DownloadButton`은 방사형 진행률 스피너를 점점 커지는 방사형 진행률 막대로 대체합니다. 
`DownloadButton`은 또한 사용자가 진행 중인 다운로드를 취소할 수 있도록 중지 버튼 아이콘을 표시합니다.

`DownloadButton` 위젯에 진행률 속성을 추가한 다음, 
`downloading` 단계 동안 방사형 진행률 막대로 전환하도록 진행률 표시를 업데이트합니다.

다음으로, 방사형 진행률 막대의 중앙에 중지 버튼 아이콘을 추가합니다.

<?code-excerpt "lib/stop.dart (StopIcon)"?>
```dart
@override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: _onPressed,
    child: Stack(
      children: [
        ButtonShapeWidget(
          transitionDuration: transitionDuration,
          isDownloaded: _isDownloaded,
          isDownloading: _isDownloading,
          isFetching: _isFetching,
        ),
        Positioned.fill(
          child: AnimatedOpacity(
            duration: transitionDuration,
            opacity: _isDownloading || _isFetching ? 1.0 : 0.0,
            curve: Curves.ease,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ProgressIndicatorWidget(
                  downloadProgress: downloadProgress,
                  isDownloading: _isDownloading,
                  isFetching: _isFetching,
                ),
                if (_isDownloading)
                  const Icon(
                    Icons.stop,
                    size: 14.0,
                    color: CupertinoColors.activeBlue,
                  ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
```

## 버튼 탭 콜백 추가 {:#add-button-tap-callbacks}

`DownloadButton`에 필요한 마지막 세부 사항은 버튼 동작입니다. 버튼은 사용자가 탭하면 동작을 수행해야 합니다.

다운로드 시작, 다운로드 취소, 다운로드 열기를 위한 콜백에 대한 위젯 속성을 추가합니다.

마지막으로, `DownloadButton`의 기존 위젯 트리를 `GestureDetector` 위젯으로 래핑하고, 
탭 이벤트를 해당 콜백 속성으로 전달합니다.

<?code-excerpt "lib/button_taps.dart (TapCallbacks)"?>
```dart
@immutable
class DownloadButton extends StatelessWidget {
  const DownloadButton({
    super.key,
    required this.status,
    this.downloadProgress = 0,
    required this.onDownload,
    required this.onCancel,
    required this.onOpen,
    this.transitionDuration = const Duration(milliseconds: 500),
  });

  final DownloadStatus status;
  final double downloadProgress;
  final VoidCallback onDownload;
  final VoidCallback onCancel;
  final VoidCallback onOpen;
  final Duration transitionDuration;

  bool get _isDownloading => status == DownloadStatus.downloading;

  bool get _isFetching => status == DownloadStatus.fetchingDownload;

  bool get _isDownloaded => status == DownloadStatus.downloaded;

  void _onPressed() {
    switch (status) {
      case DownloadStatus.notDownloaded:
        onDownload();
      case DownloadStatus.fetchingDownload:
        // 아무것도 안 함.
        break;
      case DownloadStatus.downloading:
        onCancel();
      case DownloadStatus.downloaded:
        onOpen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressed,
      child: const Stack(
        children: [
          /* ButtonShapeWidget 및 진행률 표시기 */
        ],
      ),
    );
  }
}
```

축하합니다! 버튼이 다운로드 시작 안함(not downloaded), 다운로드 가져오는 중, 다운로드 중, 다운로드됨의 단계에 따라 
디스플레이가 변경되는 버튼이 있습니다. 이제, 사용자는 탭하여 다운로드를 시작하고, 탭하여 진행 중인 다운로드를 취소하고, 
탭하여 완료된 다운로드를 열 수 있습니다.

## 대화형 예제 {:#interactive-example}

앱 실행:

* **GET** 버튼을 클릭하여 시뮬레이션된 다운로드를 시작합니다.
* 버튼이 진행 ​​중 다운로드를 시뮬레이션하기 위해, 진행률 표시기로 바뀝니다.
* 시뮬레이션된 다운로드가 완료되면, 버튼이 **OPEN**으로 전환되어, 앱이 사용자가 다운로드된 asset을 열 준비가 되었음을 나타냅니다.

<!-- start dartpad -->

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter download button hands-on example in DartPad" run="true"
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: ExampleCupertinoDownloadButton(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

@immutable
class ExampleCupertinoDownloadButton extends StatefulWidget {
  const ExampleCupertinoDownloadButton({super.key});

  @override
  State<ExampleCupertinoDownloadButton> createState() =>
      _ExampleCupertinoDownloadButtonState();
}

class _ExampleCupertinoDownloadButtonState
    extends State<ExampleCupertinoDownloadButton> {
  late final List<DownloadController> _downloadControllers;

  @override
  void initState() {
    super.initState();
    _downloadControllers = List<DownloadController>.generate(
      20,
      (index) => SimulatedDownloadController(onOpenDownload: () {
        _openDownload(index);
      }),
    );
  }

  void _openDownload(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Open App ${index + 1}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apps')),
      body: ListView.separated(
        itemCount: _downloadControllers.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: _buildListItem,
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    final theme = Theme.of(context);
    final downloadController = _downloadControllers[index];

    return ListTile(
      leading: const DemoAppIcon(),
      title: Text(
        'App ${index + 1}',
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleLarge,
      ),
      subtitle: Text(
        'Lorem ipsum dolor #${index + 1}',
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall,
      ),
      trailing: SizedBox(
        width: 96,
        child: AnimatedBuilder(
          animation: downloadController,
          builder: (context, child) {
            return DownloadButton(
              status: downloadController.downloadStatus,
              downloadProgress: downloadController.progress,
              onDownload: downloadController.startDownload,
              onCancel: downloadController.stopDownload,
              onOpen: downloadController.openDownload,
            );
          },
        ),
      ),
    );
  }
}

@immutable
class DemoAppIcon extends StatelessWidget {
  const DemoAppIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 1,
      child: FittedBox(
        child: SizedBox(
          width: 80,
          height: 80,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red, Colors.blue],
              ),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Center(
              child: Icon(
                Icons.ac_unit,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum DownloadStatus {
  notDownloaded,
  fetchingDownload,
  downloading,
  downloaded,
}

abstract class DownloadController implements ChangeNotifier {
  DownloadStatus get downloadStatus;
  double get progress;

  void startDownload();
  void stopDownload();
  void openDownload();
}

class SimulatedDownloadController extends DownloadController
    with ChangeNotifier {
  SimulatedDownloadController({
    DownloadStatus downloadStatus = DownloadStatus.notDownloaded,
    double progress = 0.0,
    required VoidCallback onOpenDownload,
  })  : _downloadStatus = downloadStatus,
        _progress = progress,
        _onOpenDownload = onOpenDownload;

  DownloadStatus _downloadStatus;
  @override
  DownloadStatus get downloadStatus => _downloadStatus;

  double _progress;
  @override
  double get progress => _progress;

  final VoidCallback _onOpenDownload;

  bool _isDownloading = false;

  @override
  void startDownload() {
    if (downloadStatus == DownloadStatus.notDownloaded) {
      _doSimulatedDownload();
    }
  }

  @override
  void stopDownload() {
    if (_isDownloading) {
      _isDownloading = false;
      _downloadStatus = DownloadStatus.notDownloaded;
      _progress = 0.0;
      notifyListeners();
    }
  }

  @override
  void openDownload() {
    if (downloadStatus == DownloadStatus.downloaded) {
      _onOpenDownload();
    }
  }

  Future<void> _doSimulatedDownload() async {
    _isDownloading = true;
    _downloadStatus = DownloadStatus.fetchingDownload;
    notifyListeners();

    // 읽어 오는 시간의 시뮬레이션을 위해 잠깐 기다립니다.
    await Future<void>.delayed(const Duration(seconds: 1));

    // 사용자가 다운로드를 취소하면, 시뮬레이션이 중지됩니다.
    if (!_isDownloading) {
      return;
    }

    // 다운로드 단계로 전환합니다.
    _downloadStatus = DownloadStatus.downloading;
    notifyListeners();

    const downloadProgressStops = [0.0, 0.15, 0.45, 0.8, 1.0];
    for (final stop in downloadProgressStops) {
      // 다양한 다운로드 속도를 시뮬레이션하기 위해 잠시 기다립니다.
      await Future<void>.delayed(const Duration(seconds: 1));

      // 사용자가 다운로드를 취소하면 시뮬레이션이 중지됩니다.
      if (!_isDownloading) {
        return;
      }

      // 다운로드 진행 상황을 업데이트합니다.
      _progress = stop;
      notifyListeners();
    }

    // 최종 지연을 시뮬레이션하기 위해 잠시 기다립니다.
    await Future<void>.delayed(const Duration(seconds: 1));

    // 사용자가 다운로드를 취소하면 시뮬레이션이 중지됩니다.
    if (!_isDownloading) {
      return;
    }

    // 다운로드 상태로 전환하고, 시뮬레이션을 완료합니다.
    _downloadStatus = DownloadStatus.downloaded;
    _isDownloading = false;
    notifyListeners();
  }
}

@immutable
class DownloadButton extends StatelessWidget {
  const DownloadButton({
    super.key,
    required this.status,
    this.downloadProgress = 0.0,
    required this.onDownload,
    required this.onCancel,
    required this.onOpen,
    this.transitionDuration = const Duration(milliseconds: 500),
  });

  final DownloadStatus status;
  final double downloadProgress;
  final VoidCallback onDownload;
  final VoidCallback onCancel;
  final VoidCallback onOpen;
  final Duration transitionDuration;

  bool get _isDownloading => status == DownloadStatus.downloading;

  bool get _isFetching => status == DownloadStatus.fetchingDownload;

  bool get _isDownloaded => status == DownloadStatus.downloaded;

  void _onPressed() {
    switch (status) {
      case DownloadStatus.notDownloaded:
        onDownload();
      case DownloadStatus.fetchingDownload:
        // 아무것도 안 함.
        break;
      case DownloadStatus.downloading:
        onCancel();
      case DownloadStatus.downloaded:
        onOpen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressed,
      child: Stack(
        children: [
          ButtonShapeWidget(
            transitionDuration: transitionDuration,
            isDownloaded: _isDownloaded,
            isDownloading: _isDownloading,
            isFetching: _isFetching,
          ),
          Positioned.fill(
            child: AnimatedOpacity(
              duration: transitionDuration,
              opacity: _isDownloading || _isFetching ? 1.0 : 0.0,
              curve: Curves.ease,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ProgressIndicatorWidget(
                    downloadProgress: downloadProgress,
                    isDownloading: _isDownloading,
                    isFetching: _isFetching,
                  ),
                  if (_isDownloading)
                    const Icon(
                      Icons.stop,
                      size: 14,
                      color: CupertinoColors.activeBlue,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

@immutable
class ButtonShapeWidget extends StatelessWidget {
  const ButtonShapeWidget({
    super.key,
    required this.isDownloading,
    required this.isDownloaded,
    required this.isFetching,
    required this.transitionDuration,
  });

  final bool isDownloading;
  final bool isDownloaded;
  final bool isFetching;
  final Duration transitionDuration;

  @override
  Widget build(BuildContext context) {
    var shape = const ShapeDecoration(
      shape: StadiumBorder(),
      color: CupertinoColors.lightBackgroundGray,
    );

    if (isDownloading || isFetching) {
      shape = ShapeDecoration(
        shape: const CircleBorder(),
        color: Colors.white.withOpacity(0),
      );
    }

    return AnimatedContainer(
      duration: transitionDuration,
      curve: Curves.ease,
      width: double.infinity,
      decoration: shape,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: AnimatedOpacity(
          duration: transitionDuration,
          opacity: isDownloading || isFetching ? 0.0 : 1.0,
          curve: Curves.ease,
          child: Text(
            isDownloaded ? 'OPEN' : 'GET',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.activeBlue,
                ),
          ),
        ),
      ),
    );
  }
}

@immutable
class ProgressIndicatorWidget extends StatelessWidget {
  const ProgressIndicatorWidget({
    super.key,
    required this.downloadProgress,
    required this.isDownloading,
    required this.isFetching,
  });

  final double downloadProgress;
  final bool isDownloading;
  final bool isFetching;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: downloadProgress),
        duration: const Duration(milliseconds: 200),
        builder: (context, progress, child) {
          return CircularProgressIndicator(
            backgroundColor: isDownloading
                ? CupertinoColors.lightBackgroundGray
                : Colors.white.withOpacity(0),
            valueColor: AlwaysStoppedAnimation(isFetching
                ? CupertinoColors.lightBackgroundGray
                : CupertinoColors.activeBlue),
            strokeWidth: 2,
            value: isFetching ? null : progress,
          );
        },
      ),
    );
  }
}
```
