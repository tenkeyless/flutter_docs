---
# title: Flutter concurrency for Swift developers
title: Swift 개발자를 위한 Flutter 동시성(concurrency)
# description: >
#   Leverage your Swift concurrency knowledge while learning Flutter and Dart.
description: >
  Flutter와 Dart를 배우는 동안, Swift 동시성에 대한 지식을 활용하세요.
---

<?code-excerpt path-base="resources/dart_swift_concurrency"?>

Dart와 Swift는 모두 동시 프로그래밍을 지원합니다. 
이 가이드는 Dart에서 동시성이 어떻게 작동하는지, 그리고 Swift와 어떻게 비교되는지 이해하는 데 도움이 될 것입니다. 
이러한 이해를 바탕으로 고성능 iOS 앱을 만들 수 있습니다.

Apple 생태계에서 개발할 때, 일부 작업은 완료하는 데 오랜 시간이 걸릴 수 있습니다. 
이러한 작업에는 대량의 데이터를 가져오거나 처리하는 것이 포함됩니다. 
iOS 개발자는 일반적으로 Grand Central Dispatch(GCD)를 사용하여, 공유 스레드 풀을 사용하여 작업을 예약합니다. 
GCD를 사용하면 개발자가 디스패치 큐에 작업을 추가하고, GCD가 실행할 스레드를 결정합니다.

그러나, GCD는 나머지 작업 항목을 처리하기 위해 스레드를 시작합니다. 
즉, 많은 수의 스레드가 발생하고, 시스템이 과도하게 커밋될 수 있습니다. 
Swift를 사용하면, 구조화된 동시성 모델이 스레드 수와 컨텍스트 전환을 줄였습니다. 
이제 각 코어에는 스레드가 하나만 있습니다.

Dart는 `Isolates`, 이벤트 루프, 비동기 코드를 지원하는 단일 스레드 실행 모델을 가지고 있습니다. 
`Isolate`는 Dart가 구현한 가벼운 스레드입니다. 
`Isolate`를 생성하지 않는 한, Dart 코드는 이벤트 루프로 구동되는 메인 UI 스레드에서 실행됩니다. 
Flutter의 이벤트 루프는 iOS 메인 루프와 동일합니다. 즉, 메인 스레드에 연결된 Looper입니다.

Dart의 단일 스레드 모델은 UI가 정지되는 모든 것을 차단 작업(blocking operation)으로 실행해야 한다는 것을 의미하지 않습니다. 
대신, `async`/`await`와 같이 Dart 언어가 제공하는 비동기 기능을 사용하세요.

## 비동기 프로그래밍 {:#asynchronous-programming}

비동기 작업은 완료되기 전에 다른 작업을 실행할 수 있습니다. 
Dart와 Swift는 모두 `async` 및 `await` 키워드를 사용하여 비동기 함수를 지원합니다. 
두 경우 모두 `async`는 함수가 비동기 작업을 수행함을 표시하고, `await`는 시스템에 함수의 결과를 기다리라고 지시합니다. 
즉, 필요한 경우 Dart VM이 함수를 일시 중단할 수 있습니다. 
비동기 프로그래밍에 대한 자세한 내용은 [Dart의 동시성]({{site.dart-site}}/guides/language/concurrency)을 확인하세요.

### 메인 스레드/isolate 활용 {:#leveraging-the-main-threadisolate}

Apple 운영 체제의 경우, 기본(또는 메인) 스레드는 애플리케이션이 실행되기 시작하는 곳입니다. 
사용자 인터페이스 렌더링은 항상 메인 스레드에서 이루어집니다. 
Swift와 Dart의 한 가지 차이점은 Swift가 다른 작업에 다른 스레드를 사용할 수 있고, 
Swift가 어떤 스레드를 사용하는지 보장하지 않는다는 것입니다. 
따라서, Swift에서 UI 업데이트를 디스패치할 때, 작업이 메인 스레드에서 수행되는지 확인해야 할 수 있습니다.

날씨를 비동기적으로 가져와 결과를 표시하는 함수를 작성하고 싶다고 가정해 보겠습니다.

GCD에서, 프로세스를 메인 스레드에 수동으로 디스패치하려면, 다음과 같이 할 수 있습니다.

먼저 `Weather` `enum`을 정의합니다.

```swift
// mock API 호출에서는 1초 지연이 사용됩니다.
extension UInt64 {
  static let oneSecond = UInt64(1_000_000_000)
} 

enum Weather: String {
    case rainy, sunny
}
```

다음으로, 뷰 모델을 정의하고 `ObservableObject`로 표시하여, `Weather?` 타입의 값을 반환할 수 있도록 합니다. 
GCD create를 사용하여 `DispatchQueue`를 사용하여 작업을 스레드 풀로 보냅니다.

```swift
class ContentViewModel: ObservableObject {
    @Published private(set) var result: Weather?

    private let queue = DispatchQueue(label: "weather_io_queue")
    func load() {
        // 1초 지연을 모방합니다.
        queue.asyncAfter(deadline: .now() + 1) { [weak self] in
            DispatchQueue.main.async {
                self?.result = .sunny
            }
        }
    }
}
```

마지막으로, 결과를 표시합니다.

```swift
struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    var body: some View {
        Text(viewModel.result?.rawValue ?? "Loading")
            .onAppear {
                viewModel.load()
        }
    }
}
```

최근, Swift는 공유되고 변경 가능한(mutable) 상태에 대한 동기화를 지원하기 위해, _actors_ 를 도입했습니다. 
작업이 메인 스레드에서 수행되도록 하려면, `@MainActor`로 표시된 뷰 모델 클래스를 정의하고, 
`Task`를 사용하여 비동기 함수를 내부적으로 호출하는 `load()` 함수를 정의합니다.

```swift
@MainActor class ContentViewModel: ObservableObject {
  @Published private(set) var result: Weather?
  
  func load() async {
    try? await Task.sleep(nanoseconds: .oneSecond)
    self.result = .sunny
  }
}
```

다음으로, `@StateObject`를 사용하여 뷰 모델을 상태 객체로 정의하고, 
뷰 모델에서 호출할 수 있는 `load()` 함수를 사용합니다.

```swift
struct ContentView: View {
  @StateObject var viewModel = ContentViewModel()
  var body: some View {
    Text(viewModel.result?.rawValue ?? "Loading...")
      .task {
        await viewModel.load()
      }
  }
}
```

Dart에서 모든 작업은 기본적으로 메인 isolate에서 실행됩니다. 
Dart에서 동일한 예를 구현하려면, 먼저 `Weather` `enum`을 만듭니다.

<?code-excerpt "lib/async_weather.dart (weather)"?>
```dart
enum Weather {
  rainy,
  windy,
  sunny,
}
```

그런 다음, 날씨를 가져오기 위해 간단한 뷰 모델(SwiftUI에서 만든 것과 유사)을 정의합니다. 
Dart에서, `Future` 객체는 미래에 제공될 값을 나타냅니다. 
`Future`는 Swift의 `ObservableObject`와 유사합니다. 
이 예에서, 뷰 모델 내의 함수는 `Future<Weather>` 객체를 반환합니다.

<?code-excerpt "lib/async_weather.dart (home-page-view-model)"?>
```dart
@immutable
class HomePageViewModel {
  const HomePageViewModel();
  Future<Weather> load() async {
    await Future.delayed(const Duration(seconds: 1));
    return Weather.sunny;
  }
}
```

이 예제의 `load()` 함수는 Swift 코드와 유사합니다. 
Dart 함수는 `await` 키워드를 사용하기 때문에, `async`로 표시됩니다.

또한, `async`로 표시된 Dart 함수는 자동으로 `Future`를 반환합니다. 
즉, `async`로 표시된 함수 내에서 `Future` 인스턴스를 수동으로 만들 필요가 없습니다.

마지막 단계에서는, 날씨 값을 표시합니다. 
Flutter에서 [`FutureBuilder`]({{site.api}}/flutter/widgets/FutureBuilder-class.html) 및 [`StreamBuilder`]({{site.api}}/flutter/widgets/StreamBuilder-class.html) 위젯은 UI에서 Future의 결과를 표시하는 데 사용됩니다. 
다음 예제에서는 `FutureBuilder`를 사용합니다.

<?code-excerpt "lib/async_weather.dart (home-page-widget)"?>
```dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final HomePageViewModel viewModel = const HomePageViewModel();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // 위젯 트리에 FutureBuilder를 제공합니다.
      child: FutureBuilder<Weather>(
        // 추적하고 싶은 Future를 지정하세요.
        future: viewModel.load(),
        builder: (context, snapshot) {
          // 스냅샷은 `AsyncSnapshot` 타입이며 Future의 상태를 포함합니다. 
          // 스냅샷에 오류가 있는지 또는 데이터가 null인지 확인하여, 
          // 사용자에게 무엇을 표시할지 결정할 수 있습니다.
          if (snapshot.hasData) {
            return Center(
              child: Text(
                snapshot.data.toString(),
              ),
            );
          } else {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
        },
      ),
    );
  }
}
```

전체 예를 보려면 GitHub의 [async_weather][] 파일을 확인하세요.

[async_weather]: {{site.repo.this}}/examples/resources/lib/async_weather.dart

### 백그라운드 스레드/isolate 활용 {:#leveraging-a-background-threadisolate}

Flutter 앱은 macOS 및 iOS를 실행하는 기기를 포함하여 다양한 멀티코어 하드웨어에서 실행할 수 있습니다. 
이러한 애플리케이션의 성능을 개선하려면, 때때로 여러 코어에서 동시에 작업을 실행해야 합니다. 
이는 특히 장기 실행 작업으로 UI 렌더링을 차단하는 것을 방지하는 데 중요합니다.

Swift에서는, GCD를 활용하여 다양한 서비스 품질 클래스(qos, quality of service class) 속성을 가진, 
글로벌 큐에서 작업을 실행할 수 있습니다. 이는 작업의 우선순위를 나타냅니다.

```swift
func parse(string: String, completion: @escaping ([String:Any]) -> Void) {
  // 1초 지연을 모방합니다.
  DispatchQueue(label: "data_processing_queue", qos: .userInitiated)
    .asyncAfter(deadline: .now() + 1) {
      let result: [String:Any] = ["foo": 123]
      completion(result)
    }
  }
}
```

Dart에서는 계산을 종종 백그라운드 워커라고 하는 워커 isolate에 오프로드할 수 있습니다. 
일반적인 시나리오는 간단한 워커 isolate를 생성하고 워커가 종료될 때 메시지로 결과를 반환합니다. 
Dart 2.19부터, `Isolate.run()`을 사용하여 isolate를 생성하고 계산을 실행할 수 있습니다.

```dart
void main() async {
  // 데이터를 읽습니다.
  final jsonData = await Isolate.run(() => jsonDecode(jsonString) as Map<String, dynamic>);`

  // 해당 데이터를 활용하세요.
  print('Number of JSON keys: ${jsonData.length}');
}
```

Flutter에서는, `compute` 함수를 사용하여 콜백 함수를 실행하기 위해 isolate를 시작할 수도 있습니다.

```dart
final jsonData = await compute(getNumberOfKeys, jsonString);
```

이 경우, 콜백 함수는 아래와 같이 가장 높은 레벨 함수입니다.

```dart
Map<String, dynamic> getNumberOfKeys(String jsonString) {
 return jsonDecode(jsonString);
}
```

Dart에 대한 자세한 내용은 [Swift 개발자를 위한 Dart 학습][Learning Dart as a Swift developer]에서 확인할 수 있으며, 
Flutter에 대한 자세한 내용은 [SwiftUI 개발자를 위한 Flutter][Flutter for SwiftUI developers] 또는 [UIKit 개발자를 위한 Flutter][Flutter for UIKit developers]에서 확인할 수 있습니다.

[Learning Dart as a Swift developer]: {{site.dart-site}}/guides/language/coming-from/swift-to-dart
[Flutter for SwiftUI developers]: /get-started/flutter-for/swiftui-devs
[Flutter for UIKit developers]: /get-started/flutter-for/uikit-devs
