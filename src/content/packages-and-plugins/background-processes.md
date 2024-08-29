---
# title: Background processes
title: 백그라운드 프로세스
# description: Where to find more information on implementing background processes in Flutter.
description: Flutter에서 백그라운드 프로세스를 구현하는 방법에 대한 자세한 내용은 어디에서 찾을 수 있나요?
---

앱이 현재 활성화된 앱이 아니더라도 백그라운드에서 Dart 코드를 실행하고 싶었던 적이 있나요? 
아마도 시간을 감시하거나, 카메라 움직임을 포착하는 프로세스를 구현하고 싶었을 것입니다. 
Flutter에서는 백그라운드에서 Dart 코드를 실행할 수 있습니다.

이 기능의 메커니즘에는 isolate를 설정하는 것이 포함됩니다. 
_isolate_ 는 멀티스레딩을 위한 Dart 모델이지만, 
isolate는 메인 프로그램과 메모리를 공유하지 않는다는 점에서 기존 스레드와 다릅니다. 
콜백과 콜백 디스패처를 사용하여 백그라운드 실행을 위한 isolate를 설정합니다.

또한, [WorkManager] 플러그인은 앱 재시작 및 시스템 재부팅을 통해 작업을 예약하는, 
지속적인 백그라운드 처리를 가능하게 합니다.

자세한 내용과 Dart 코드의 백그라운드 실행을 사용하는 지오펜싱 예제는, 
Ben Konyi의 Medium 문서 [Flutter 플러그인 및 지오펜싱을 사용하여 백그라운드에서 Dart 실행][background-processes]을 참조하세요. 
이 글의 끝부분에서는 Dart, iOS, Android에 대한 예제 코드와 관련 문서에 대한 링크를 찾을 수 있습니다.
 
[background-processes]: {{site.flutter-medium}}/executing-dart-in-the-background-with-flutter-plugins-and-geofencing-2b3e40a1a124
[WorkManager]: {{site.pub-pkg}}/workmanager 
