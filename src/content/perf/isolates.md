---
# title: Concurrency and isolates
title: 동시성(Concurrency) 및 격리(isolates)
# description: Multithreading in Flutter using Dart isolates.
description: Dart isolate을 사용하여 Flutter에서 멀티스레딩하기.
---

<?code-excerpt path-base="perf/concurrency/isolates/"?>

모든 Dart 코드는 [isolates]({{site.dart-site}}/language/concurrency)에서 실행됩니다. 
이는 스레드와 유사하지만, isolates는 자체 격리된 메모리를 갖는다는 점에서 다릅니다. 
isolates는 어떤 식으로도 상태를 공유하지 않으며, 메시징으로만 통신할 수 있습니다. 
기본적으로, Flutter 앱은 모든 작업을 단일 isolate(메인 isolate)에서 수행합니다.
대부분의 경우, 이 모델은 더 간단한 프로그래밍을 허용하고 애플리케이션의 UI가 응답하지 않을 정도로 빠릅니다.

하지만 때로는, 애플리케이션에서 "UI jank"(끊기는 동작)를 일으킬 수 있는 매우 큰 계산을 수행해야 합니다. 
이런 이유로 앱에서 jank가 발생하는 경우, 이러한 계산을 헬퍼 isolate로 옮길 수 있습니다. 
이렇게 하면, 기본 런타임 환경에서 메인 UI isolate의 작업과 동시에 계산을 실행하는, 멀티코어 장치의 이점을 활용할 수 있습니다.

각 isolate에는 자체 메모리와 자체 이벤트 루프가 있습니다. 
이벤트 루프는 이벤트 큐에 추가된 순서대로 이벤트를 처리합니다. 
메인 isolate에서, 이러한 이벤트는 UI에서 사용자 탭 처리에서 함수 실행, 화면에 프레임 그리기까지 무엇이든 될 수 있습니다. 
다음 그림은 처리를 기다리는 3개의 이벤트가 있는 예시 이벤트 큐를 보여줍니다.

![The main isolate diagram](/assets/images/docs/development/concurrency/basics-main-isolate.png){:width="50%"}

매끄러운 렌더링을 위해, Flutter는 초당 60회(60Hz 기기의 경우) 이벤트 큐에 "페인트 프레임" 이벤트를 추가합니다. 
이러한 이벤트가 제때 처리되지 않으면, 애플리케이션에서 UI jank가 발생하거나, 더 나쁜 경우 전혀 응답하지 않게 됩니다.

![Event jank diagram](/assets/images/docs/development/concurrency/event-jank.png){:width="50%"}

프로세스가 프레임 갭(두 프레임 사이의 시간)에서 완료될 수 없는 경우, 
메인 isolate이 초당 60프레임을 생성할 수 있도록, 작업을 다른 isolate로 오프로드하는 것이 좋습니다. 
Dart에서 isolate를 스폰(spawn)하면, 차단하지 않고, 메인 isolate와 동시에 작업을 처리할 수 있습니다.

Dart 설명서의 [동시성 페이지][concurrency page]에서, 
isolate와 이벤트 루프가 Dart에서 작동하는 방식에 대해 자세히 알아볼 수 있습니다.

[concurrency page]: {{site.dart-site}}/language/concurrency

{% ytEmbed 'vl_AaCgudcY', 'Isolates와 이벤트 루프 | Flutter in Focus' %}

## isolates의 일반적인 사용 사례 {:#common-use-cases-for-isolates}

isolate을 사용해야 하는 경우에 대한 엄격한 규칙은 하나뿐이며, 
그것은 대규모 계산으로 인해 Flutter 애플리케이션에서 UI jank가 발생하는 경우입니다. 
이 jank는 Flutter의 프레임 갭보다 오래 걸리는 계산이 있을 때 발생합니다.

![Event jank diagram](/assets/images/docs/development/concurrency/event-jank.png){:width="50%"}

구현 및 입력 데이터에 따라 어떤 프로세스는 완료하는 데 _더 오래 걸릴 수_ 있으므로, 
격리를 사용해야 하는 경우의 전체 리스트를 만드는 것은 불가능합니다.

즉, isolates은 일반적으로 다음과 같은 경우에 사용됩니다.

- 로컬 데이터베이스에서 데이터 읽기
- 푸시 알림 보내기
- 대용량 데이터 파일 구문 분석 및 디코딩
- 사진, 오디오 파일 및 비디오 파일 처리 또는 압축
- 오디오 및 비디오 파일 변환
- FFI를 사용하는 동안 비동기 지원이 필요한 경우
- 복잡한 리스트 또는 파일 시스템에 필터링 적용

## isolates 간의 메시지 전달 {:#message-passing-between-isolates}

Dart의 isolates는 [Actor 모델][Actor model]의 구현입니다. 
이들은 [`Port` 객체][`Port` objects]로 수행되는 메시지 전달을 통해서만 서로 통신할 수 있습니다. 
메시지가 서로 "전달"될 때, 일반적으로 전송 isolate에서 수신 isolate로 복사됩니다. 
즉, isolate에 전달된 모든 값은, 해당 isolate에서 변형되더라도, 원래 isolate의 값을 변경하지 않습니다.

isolate에 [전달될 때 복사되지 않는 객체][objects that aren't copied when passed]는 어차피 변경할 수 없는 불변 객체, 예를 들어, 문자열이나 수정 불가능한 바이트입니다. 
isolate 간에 불변 객체를 전달하면, 더 나은 성능을 위해 객체가 복사되는 대신, 
해당 객체에 대한 참조가 포트를 통해 전송됩니다. 
불변 객체는 업데이트할 수 없으므로, 이는 효과적으로 actor 모델 동작을 유지합니다.

[`Port` objects]: {{site.dart.api}}/stable/dart-isolate/ReceivePort-class.html
[objects that aren't copied when passed]: {{site.dart.api}}/stable/dart-isolate/SendPort/send.html

이 규칙의 예외는, `Isolate.exit` 메서드를 사용하여 메시지를 보낼 때, isolate가 종료되는 경우입니다. 
메시지를 보낸 후에는 보내는 isolate가 존재하지 않으므로, 
메시지의 소유권을 한 isolate에서 다른 isolate로 넘겨서, 
한 isolate만 메시지에 액세스할 수 있도록 할 수 있습니다.

메시지를 보내는 두 가지 가장 낮은 레벨 primitives는 `SendPort.send`로, 
보낼 때 변경 가능한(mutable) 메시지의 사본을 만들고, `Isolate.exit`로, 메시지에 대한 참조를 보냅니다. 
`Isolate.run`과 `compute`는 모두 후드 아래(under the hood)에서 `Isolate.exit`를 사용합니다.

## 수명이 짧은 isolates {:#short-lived-isolates}

Flutter에서 프로세스를 isolate로 옮기는 가장 쉬운 방법은 `Isolate.run` 메서드를 사용하는 것입니다. 
이 메서드는 isolate를 생성(spawns)하고, 생성된 isolate에 콜백을 전달하여 계산을 시작하고, 
계산에서 값을 반환한 다음, 계산이 완료되면 isolate를 종료합니다. 
이 모든 작업은 메인 isolate와 동시에 수행되며, isolate를 차단하지 않습니다.

![Isolate diagram](/assets/images/docs/development/concurrency/isolate-bg-worker.png){:width="50%"}

`Isolate.run` 메서드는 새 isolate에서 실행되는 단일 인수인 콜백 함수가 필요합니다. 
이 콜백의 함수 서명에는 정확히 하나의 필수적이고, 이름이 지정되지 않은, 인수가 있어야 합니다. 
계산이 완료되면, 콜백의 값을 다시 메인 isolate로 반환하고, 생성된(spawned) isolate를 종료합니다.

예를 들어, 파일에서 큰 JSON blob을 로드하고 해당 JSON을 커스텀 Dart 객체로 변환하는 이 코드를 고려해 보세요. 
JSON 디코딩 프로세스가 새 isolate를로 오프로드되지(off loaded) 않았다면, 
이 메서드로 인해 UI가 몇 초 동안 응답하지 않게 됩니다.

<?code-excerpt "lib/main.dart (isolate-run)"?>
```dart
// 211,640개의 사진 객체 리스트를 생성합니다.
// (JSON 파일은 ~20MB입니다.)
Future<List<Photo>> getPhotos() async {
  final String jsonString = await rootBundle.loadString('assets/photos.json');
  final List<Photo> photos = await Isolate.run<List<Photo>>(() {
    final List<Object?> photoData = jsonDecode(jsonString) as List<Object?>;
    return photoData.cast<Map<String, Object?>>().map(Photo.fromJson).toList();
  });
  return photos;
}
```

Isolates를 사용하여 백그라운드에서 JSON을 파싱하는 전체 연습 과정은 [이 쿡북 레시피][this cookbook recipe]를 참조하세요.

[this cookbook recipe]: /cookbook/networking/background-parsing

## Stateful, 수명이 긴 isolates {:#stateful-longer-lived-isolates}

수명이 짧은 isolates는 사용하기 편리하지만, 새로운 isolates를 생성하고,
 한 isolate에서 다른 isolate로 객체를 복사하는 데 필요한 성능 오버헤드가 있습니다. 
 `Isolate.run`을 사용하여 동일한 계산을 반복적으로 수행하는 경우, 
 즉시 종료되지 않는 isolates를 생성하면 성능이 더 좋아질 수 있습니다.

이를 위해, `Isolate.run`이 추상화하는 몇 가지 낮은 레벨 isolate 관련 API를 사용할 수 있습니다.

- [`Isolate.spawn()`][] 및 [`Isolate.exit()`][]
- [`ReceivePort`][] 및 [`SendPort`][]
- [`send()`][] 메서드

`Isolate.run` 메서드를 사용하면, 새 isolate는 단일 메시지를 메인 isolate에 반환한 후 즉시 종료됩니다. 
때로는, 수명이 길고 시간이 지남에 따라 여러 메시지를 서로 전달할 수 있는 isolates가 필요합니다. 
Dart에서는, Isolate API와 Ports를 사용하여 이를 달성할 수 있습니다. 
이러한 수명이 긴 isolates는 구어체적으로 _백그라운드 워커(background workers)_ 라고 합니다.

수명이 긴 isolates는 애플리케이션 수명 동안 반복적으로 실행해야 하는 특정 프로세스가 있거나, 
일정 기간 동안 실행되고 메인 isolate에 반환 값을 생성해야 하는 프로세스가 있는 경우에 유용합니다.

또는, [worker_manager][]를 사용하여, 수명이 긴 격리를 관리할 수 있습니다.

[worker_manager]: {{site.pub-pkg}}/worker_manager

### ReceivePorts 및 SendPorts {:#receiveports-and-sendports}

두 개의 클래스(Isolate 외에)를 사용하여 isolates 간에 수명이 긴 통신을 설정합니다. 
[`ReceivePort`][] 및 [`SendPort`][]. 
이러한 포트는 isolates가 서로 통신할 수 있는 유일한 방법입니다.

`Port`는 `Streams`와 유사하게 동작합니다. 
즉, `StreamController` 또는 `Sink`가 한 isolate에서 생성되고, 리스너가 다른 isolate에 설정됩니다. 
이 비유에서, `StreamConroller`는 `SendPort`라고 하며, `send()` 메서드로 메시지를 "추가"할 수 있습니다. 
`ReceivePort`는 리스너이며, 이러한 리스너가 새 메시지를 받으면, 
메시지를 인수로 사용하여 제공된 콜백을 호출합니다.

메인 isolate와 워커 isolate 간에 양방향 통신을 설정하는 방법에 대한 자세한 설명은, 
[Dart 문서][Dart documentation]의 예를 따르세요.

[Dart documentation]: {{site.dart-site}}/language/concurrency

## isolates에서 플랫폼 플러그인 사용 {:#using-platform-plugins-in-isolates}

Flutter 3.7부터, 백그라운드 isolates에서 플랫폼 플러그인을 사용할 수 있습니다. 
이를 통해 UI를 차단하지 않는 isolate에, 무거운 플랫폼 종속 계산을 오프로드할 수 있는 많은 가능성이 열립니다. 
예를 들어, 네이티브 호스트 API(예: Android의 Android API, iOS의 iOS API 등)를 사용하여 데이터를 암호화한다고 가정해 보겠습니다. 
이전에는, 호스트 플랫폼에 [데이터 마샬링(marshaling)][marshaling data]을 수행하면 UI 스레드 시간이 낭비될 수 있었지만, 이제는 백그라운드 isolate에서 수행할 수 있습니다.

플랫폼 채널 isolates는 [`BackgroundIsolateBinaryMessenger`][] API를 사용합니다. 
다음 스니펫은 백그라운드 isolate에서 `shared_preferences` 패키지를 사용하는 예를 보여줍니다.

<?code-excerpt "lib/isolate_binary_messenger.dart"?>
```dart
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // 백그라운드 isolate로 전달할 루트 isolate를 식별합니다.
  RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
  Isolate.spawn(_isolateMain, rootIsolateToken);
}

Future<void> _isolateMain(RootIsolateToken rootIsolateToken) async {
  // 배경 isolate를 루트 isolate와 등록합니다.
  BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

  // 이제 shared_preferences 플러그인을 사용할 수 있습니다.
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  print(sharedPreferences.getBool('isDebug'));
}
```

## isolates의 한계 {:#limitations-of-isolates}

멀티스레딩이 있는 언어에서 Dart로 넘어왔다면, isolates가 스레드처럼 동작할 것이라고 기대하는 것은 합리적이지만, 그렇지 않습니다. 
isolates는 자체 전역 필드를 가지고 있으며, 메시지 전달로만 통신할 수 있으므로, 
isolates의 mutable 객체는 단일 isolate에서만 액세스할 수 있습니다. 
따라서, isolates는 자체 메모리에 대한 액세스로 제한됩니다. 
예를 들어, `configuration`이라는 전역 mutable 변수가 있는 애플리케이션이 있는 경우, 
생성된 isolate에 새 전역 필드로 복사됩니다. 
생성된 isolate에서 해당 변수를 변경하면, 메인 isolate에서는 그대로 유지됩니다. 
`configuration` 객체를 새 isolate에 메시지로 전달하더라도 마찬가지입니다. 
이것이 isolate가 작동하도록 하는 방식이며, isolate를 사용할 때 명심해야 할 중요한 사항입니다.

### 웹 플랫폼 및 컴퓨팅 {:#web-platforms-and-compute}

Flutter 웹을 포함한, Dart 웹 플랫폼은 isolates를 지원하지 않습니다. 
Flutter 앱으로 웹을 타겟팅하는 경우, `compute` 메서드를 사용하여 코드가 컴파일되도록 할 수 있습니다. 
[`compute()`][] 메서드는 웹의 메인 스레드에서 계산을 실행하지만, 모바일 기기에서는 새 스레드를 생성합니다. 
모바일 및 데스크톱 플랫폼에서 `await calculate(fun, message)`는 
`await Isolate.run(() => fun(message))`와 동일합니다.

웹에서 동시성에 대한 자세한 내용은 dart.dev의 [동시성 문서][concurrency documentation]를 ​​확인하세요.

[concurrency documentation]: {{site.dart-site}}/language/concurrency

### `rootBundle` 액세스 또는 `dart:ui` 메서드 없음 {:#no-rootbundle-access-or-dart-ui-methods}

모든 UI 작업과 Flutter 자체는 메인 isolate에 결합되어 있습니다. 
따라서, 생성된 isolate에서 `rootBundle`을 사용하여 assets에 액세스할 수 없으며, 
생성된 isolate에서 위젯이나 UI 작업을 수행할 수도 없습니다.

### 호스트 플랫폼에서 Flutter로의 제한된 플러그인 메시지 {:#limited-plugin-messages-from-host-platform-to-flutter}

백그라운드 isolate 플랫폼 채널을 사용하면, isolates에서 플랫폼 채널을 사용하여 호스트 플랫폼(예: Android 또는 iOS)에 메시지를 보내고, 해당 메시지에 대한 응답을 받을 수 있습니다. 
그러나, 호스트 플랫폼에서 요청하지 않은 메시지를 받을 수는 없습니다.

예를 들어, 백그라운드 isolate에서 수명이 긴 Firestore 리스너를 설정할 수 없습니다. 
Firestore는 플랫폼 채널을 사용하여 요청하지 않은(unsolicited) Flutter에 업데이트를 푸시하기 때문입니다. 
그러나, 백그라운드에서 Firestore에 응답을 쿼리할 수 있습니다.

## 더 많은 정보 {:#more-information}

isolates에 대한 자세한 내용은, 다음 리소스를 확인하세요.

- 여러 isolates를 사용하는 경우, Flutter의 [IsolateNameServer][] 클래스나 
  Flutter를 사용하지 않는 Dart 애플리케이션의 기능을 복제하는 pub 패키지를 고려하세요.
- Dart의 Isolates는 [Actor 모델][Actor model]의 구현입니다.
- [isolate_agents][]는 Ports를 추상화하고, 긴 수명의 isolates를 더 쉽게 만들 수 있는 패키지입니다.
- `BackgroundIsolateBinaryMessenger` API [공지][announcement]에 대해 자세히 알아보세요.

[announcement]: {{site.flutter-medium}}/introducing-background-isolate-channels-7a299609cad8
[Actor model]: https://en.wikipedia.org/wiki/Actor_model
[isolate_agents]: {{site.medium}}/@gaaclarke/isolate-agents-easy-isolates-for-flutter-6d75bf69a2e7
[marshaling data]: https://en.wikipedia.org/wiki/Marshalling_(computer_science)
[`compute()`]: {{site.api}}/flutter/foundation/compute.html
[`Isolate.spawn()`]: {{site.dart.api}}/stable/dart-isolate/Isolate/spawn.html
[`Isolate.exit()`]: {{site.dart.api}}/stable/dart-isolate/Isolate/exit.html
[`ReceivePort`]: {{site.dart.api}}/stable/dart-isolate/ReceivePort-class.html
[`SendPort`]: {{site.dart.api}}/stable/dart-isolate/SendPort-class.html
[`send()`]: {{site.dart.api}}/stable/dart-isolate/SendPort/send.html
[`BackgroundIsolateBinaryMessenger`]: {{site.api}}/flutter/services/BackgroundIsolateBinaryMessenger-class.html
[IsolateNameServer]: {{site.api}}/flutter/dart-ui/IsolateNameServer-class.html
