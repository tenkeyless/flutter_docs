---
# title: Flutter fundamentals
title: Flutter 기본 사항
# description: Learn the basic building blocks of Flutter.
description: Flutter의 기본 구성 요소를 알아보세요.
prev:
  # title: First week experience
  title: 첫 주의 경험
  path: /get-started/fwe
next:
  # title: Layouts
  title: 레이아웃
  path: /get-started/fwe/layout
---

Flutter를 시작하려면, 두 가지 주제에 대해 어느 정도 알고 있어야 합니다. 
(1) Flutter 애플리케이션이 작성된 Dart 프로그래밍 언어와 (2) Flutter UI의 구성 요소인 위젯입니다. 
이 페이지에서는 두 가지를 모두 소개하지만, 이 시리즈 전반에 걸쳐 각각에 대해 계속 학습하게 됩니다. 
이 페이지 전반에 추가 리소스가 나열되어 있지만, 계속하기 위해 두 주제의 전문가가 될 필요는 없습니다.

## Dart {:#dart}

Flutter 애플리케이션은 Java, Javascript 또는 기타 C 계열 언어를 작성한 사람이라면, 
누구나 익숙할 언어인 [Dart][]로 빌드되었습니다.

:::note
Flutter를 설치하면 Dart도 함께 설치되므로, Dart를 별도로 설치할 필요가 없습니다.
:::

다음 예제는 dart.dev에서 데이터를 페치하고, 반환된 json을 디코딩하고, 콘솔에 출력하는 작은 프로그램입니다. 
이 프로그램을 이해하는 데 자신이 있다면, 이 페이지의 다음 섹션으로 건너뛰어도 됩니다.

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class Package {
  final String name, latestVersion; 
  String? description;

  Package(this.name, this.latestVersion, this.description);

  @override
  String toString() {
    return 'Package{name: $name, latestVersion: $latestVersion, description: $description}';
  }
}

void main() async {
  final httpPackageUrl = Uri.https('dart.dev', '/f/packages/http.json');
  final httpPackageResponse = await http.get(httpPackageUrl);
  if (httpPackageResponse.statusCode != 200) {
    print('Failed to retrieve the http package!');
    return;
  }
  final json = jsonDecode(httpPackageResponse.body);
  final package = Package(json['name'], json['latestVersion'], json['description']);
  print(package);
}
```

이 프로그램은 두 부분으로 구성되어 있습니다. `Package` 클래스 선언과 [`main`][] 함수에 포함된 비즈니스 로직입니다.

`Package` 클래스에는 [Dart의 클래스][classes in Dart]로 작업할 때 사용하는 가장 일반적인 기능이 많이 포함되어 있습니다. 
이 클래스에는 멤버가 세 개 있으며, 생성자와 메서드를 정의합니다.

Dart 언어는 [타입 안전][type safe]입니다. 
정적 타입 검사를 사용하여, 변수의 값이 항상 변수의 정적 타입과 일치하는지 확인합니다. 
클래스를 정의할 때, 멤버에 `String` 주석을 달 필요가 있지만, 타입 추론으로 인해 종종 선택 사항입니다. 
이 예제의 `main` 함수에는 `final variableName =`으로 시작하는 줄이 많이 있습니다. 
이러한 줄은 명시적으로 타입이 지정되지 않았음에도 불구하고 타입이 안전합니다.

Dart에는 또한 내장된 [sound null safety][]가 있습니다. 
이 예제에서 `description` 멤버는 `String?` 타입으로 선언됩니다. `String?`의 끝에 있는 `?`는 이 속성이 null일 수 있음을 의미합니다. 
다른 두 멤버는 null이 될 수 없으며, null로 설정하려고 하면 프로그램이 컴파일되지 않습니다. 
'Package class'의 생성자에서 이를 확인할 수 있습니다. 
두 개의 필수(required) 위치(positional) 인수와 하나의 선택적인(optional) 명명된(named) 인수가 필요합니다.

다음은 `main` 함수입니다. 
Flutter 앱을 포함한 모든 Dart 프로그램은 `main` 함수로 시작합니다. 
이 함수는 라이브러리 사용, 함수를 async로 표시, 함수 호출, `if` 문 제어 흐름 사용 등 여러 가지 기본 Dart 언어 기능을 보여줍니다.

:::note 초기화 코드는 어디에 들어가나요?
스타터 Flutter 앱의 주요 진입점은 `lib/main.dart`에 있습니다. 
기본 `main` 메서드는 다음과 같습니다.

```dart
void main() {
  runApp(const MyApp());
}       

```

`runApp()`를 호출하기 _전에_, _빠른_ 초기화(1~2프레임 미만)를 수행하지만, 위젯 트리가 아직 생성되지 않았다는 점에 유의하세요. 
(디스크나 네트워크를 통해 데이터를 로드하는 것과 같이) 시간이 오래 걸리는 초기화를 수행하려는 경우, 
메인 UI 스레드를 차단하지 않는 방식으로 수행하세요. 
자세한 내용은 [비동기 프로그래밍][Asynchronous programming], [`FutureBuilder`][] API, 
[지연된 구성 요소][Deferred components] 또는 [긴 리스트로 작업하기][Working with long lists] 쿡북 레시피를 적절하게 확인하세요.

[Asynchronous programming]: {{site.dart-site}}/libraries/async/async-await
[Deferred components]: /perf/deferred-components
[`FutureBuilder`]: {{site.api}}/flutter/widgets/FutureBuilder-class.html
[Working with long lists]: /cookbook/lists/long-lists

모든 stateful 위젯에는 위젯이 생성되어 위젯 트리에 추가될 때 호출되는 `initState()` 메서드가 있습니다. 
이 메서드를 재정의하여 초기화를 수행할 수 있지만, 이 메서드의 첫 번째 줄은 _반드시_ `super.initState()`여야 합니다.

마지막으로, 앱을 핫 리로딩해도 `initState`나 `main`이 다시 호출되지는 _않습니다_. 핫 리스타트는 둘 다 호출합니다.
:::

이러한 기능이 익숙하지 않은 경우, Dart 문서의 [Dart 소개][Introduction to Dart]를 읽어보세요.

## 위젯 {:#widgets}

Flutter와 관련하여, "모든 것이 위젯이다"라는 말을 자주 듣게 될 것입니다. 
위젯은 Flutter 앱의 사용자 인터페이스의 구성 요소이며, 각 위젯은 사용자 인터페이스의 일부에 대한 불변(immutable) 선언입니다. 
위젯은 패딩 및 정렬과 같은 효과를 배치하기 위한 텍스트 및 버튼과 같은 물리적 측면을 포함하여, 
사용자 인터페이스의 모든 측면을 설명하는 데 사용됩니다.

위젯은 구성을 기반으로 계층 구조를 형성합니다. 
각 위젯은 부모 위젯 내부에 중첩되어, 부모 위젯에서 컨텍스트를 수신할 수 있습니다. 
이 구조는 이 사소한 예에서 알 수 있듯이, 루트 위젯까지 이어집니다.

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // 루트 위젯
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Home Page'),
        ),
        body: Center(
          child: Builder(
            builder: (context) {
              return Column(
                children: [
                  const Text('Hello, World!'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      print('Click!');
                    },
                    child: const Text('A button'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
```

이전 코드에서, 인스턴스화된 모든 클래스는 위젯입니다: 
`MaterialApp`, `Scaffold`, `AppBar`, `Text`, `Center`, `Builder`, `Column`, `SizedBox`, `ElevatedButton`.

### 위젯 구성 {:#widget-composition}

앞서 언급했듯이, Flutter는 위젯을 유닛 구성으로 강조합니다. 
위젯은 일반적으로 강력한 효과를 내기 위해, 결합된 여러 다른 작고 단일 목적의 위젯으로 구성됩니다.

`Padding`, `Alignment`, `Row`, `Column`, `Grid`와 같은 레이아웃 위젯이 있습니다. 
이러한 레이아웃 위젯은 자체의 시각적 표현이 없습니다. 
대신, 유일한 목적은 다른 위젯의 레이아웃의 일부 측면을 제어하는 ​​것입니다. 
Flutter에는 이러한 구성적 접근 방식을 활용하는 유틸리티 위젯도 포함되어 있습니다. 
예를 들어, 일반적으로 사용되는 위젯인 `Container`는 레이아웃, 페인팅, 위치 지정 및 크기를 담당하는 여러 위젯으로 구성됩니다. 
일부 위젯은 이전 예의 `ElevatedButton` 및 `Text`와 같은 시각적 표현이 있으며, `Icon` 및 `Image`와 같은 위젯도 있습니다.

이전 예의 코드를 실행하면, Flutter는 화면 중앙에 "Hello, World!"라는 텍스트가 있는 버튼을 수직으로 배치하여 그립니다. 
이러한 요소를 배치하려면, 사용 가능한 공간의 중앙에 자식 요소를 배치하는 `Center` 위젯과, 
자식 요소를 하나씩 수직으로 배치하는 `Column` 위젯이 있습니다.

<img src='/assets/images/docs/fwe/simple_composition_example.png' width="100%" alt="A diagram that shows widget composition with a series of lines and nodes.">

이 시리즈의 [다음 페이지][next page]에서는 Flutter의 레이아웃에 대해 자세히 알아보겠습니다.

### 위젯 빌드 {:#building-widgets}

Flutter에서 사용자 인터페이스를 만들려면, 위젯 객체에서 [`build`][] 메서드를 재정의합니다. 
모든 위젯에는 build 메서드가 있어야 하며, 다른 위젯을 반환해야 합니다. 
예를 들어, 패딩을 사용하여 화면에 텍스트를 추가하려면, 다음과 같이 작성할 수 있습니다.

```dart
class PaddedText extends StatelessWidget {
  const PaddedText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: const Text('Hello, World!'),
    );
  }
}
```

이 위젯이 생성되고, 이 위젯의 ​​종속성이 변경될 때(예: 위젯에 전달되는 상태), 프레임워크는 `build` 메서드를 호출합니다. 
이 메서드는 잠재적으로 모든 프레임에서 호출될 수 있으며, 위젯을 빌드하는 것 외에는 부수 효과가 없어야 합니다. 
Flutter가 위젯을 렌더링하는 방법에 대한 자세한 내용은, [Flutter 아키텍처 개요][Flutter architectural overview]를 참조하세요.

### 위젯 상태 {:#widget-state}

프레임워크는 두 가지 주요 위젯 클래스를 소개합니다. stateful 위젯과 stateless 위젯입니다.

변경 가능한(mutable) 상태가 없는 위젯(시간이 지남에 따라 변경되는 클래스 속성이 없음)은 [`StatelessWidget`][]의 하위 클래스입니다. 
`Padding`, `Text`, `Icon`과 같이 많은 빌트인 위젯은 stateless 위젯입니다. 
사용자 고유의 위젯을 만들 때, 대부분 `Stateless` 위젯을 만들게 됩니다.

반면, 위젯의 고유한 특성이 사용자 상호 작용이나 기타 요인에 따라 변경되어야 하는 경우, 해당 위젯은 stateful 위젯입니다. 
예를 들어, 위젯에 사용자가 버튼을 탭할 때마다 증가하는 카운터가 있는 경우, 카운터의 값은 해당 위젯의 상태입니다. 
해당 값이 변경되면, 위젯을 다시 빌드하여, UI의 해당 부분을 업데이트해야 합니다. 
이러한 위젯은 [`StatefulWidget`][]의 하위 클래스이며(위젯 자체가 변경 불가능(immutable)하기 때문에), 
[`State`][]의 하위 클래스에 변경 가능한(mutable) 상태를 저장합니다. 
`StatefulWidgets`에는 `build` 메서드가 없습니다. 
대신 아래 예에서 볼 수 있듯이, `State` 객체를 통해 사용자 인터페이스가 빌드됩니다.

```dart
class CounterWidget extends StatefulWidget {
  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
    int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Text('$_counter');
  }
}
```

`State` 객체를 변형(mutate)할 때마다(예: 카운터 증가), [`setState`][]를 호출하여, 
프레임워크에 `State`의 `build` 메서드를 다시 호출하여, 사용자 인터페이스를 업데이트하도록 신호를 보내야 합니다.

위젯 객체에서 상태를 분리하면, 
다른 위젯이 stateless 위젯과 stateful 위젯을 모두 정확히 같은 방식으로 처리할 수 있으며, 
상태 손실에 대해 걱정할 필요가 없습니다. 
상태를 보존하기 위해 자식을 붙잡아둘 필요가 없는 대신, 
부모는 자식의 지속 상태를 잃지 않고, 
언제든지 자식의 새 인스턴스를 만들 수 있습니다. 
프레임워크는 적절한 경우, 기존 상태 객체를 찾고 재사용하는 모든 작업을 수행합니다.

이 시리즈의 후반부인 [상태 관리 레슨][state management lesson]에서
[`StatefulWidget`][] 객체에 대한 자세한 정보를 제공합니다.

## 알아두어야 할 중요한 위젯 {:#important-widgets-to-know}

Flutter SDK에는 `Text`와 같은 가장 작은 UI부터, 
레이아웃 위젯, 애플리케이션의 스타일을 지정하는 위젯까지, 
많은 내장 위젯이 포함되어 있습니다. 
다음 위젯은 학습 경로의 다음 레슨으로 넘어갈 때 알아야 할 가장 중요한 위젯입니다.

* [`Container`][]
* [`Text`][]
* [`Scaffold`][]
* [`AppBar`][]
* [`Row`][] 및 [`Column`][]
* [`ElevatedButton`][]
* [`Image`][]
* [`Icon`][]

## 다음: 레이아웃 {:#next-layouts}

이 페이지는 위젯과 같은 기본적인 Flutter 개념에 대한 소개이며, 
Flutter와 Dart 코드를 읽는 데 익숙해지는 데 도움이 됩니다. 
이후의 모든 페이지는 특정 주제에 대한 심층 분석이므로, 
마주친 모든 주제에 대해 명확하게 느끼지 못해도 괜찮습니다. 
다음 섹션에서는 Flutter에서 더 복잡한 레이아웃을 만들어, 더 흥미로운 UI를 빌드하기 시작합니다.

이 페이지에서 배운 정보로 연습하고 싶다면, 
[Flutter로 사용자 인터페이스 빌드][Building user interfaces with Flutter]를 읽어보세요.

[Building user interfaces with Flutter]: /ui
[Introduction to Dart]: {{site.dart-site}}/language
[Dart]: {{site.dart-site}}
[`main`]: {{site.dart-site}}/language#hello-world
[classes in Dart]: {{site.dart-site}}/language/classes
[type safe]: {{site.dart-site}}/language/type-system
[sound null safety]: {{site.dart-site}}/null-safety
[Why did Flutter choose to use Dart?]: /resources/faq#why-did-flutter-choose-to-use-dart
[next page]: /get-started/fwe/layout
[`build`]: {{site.api}}/flutter/widgets/StatelessWidget/build.html
[Flutter architectural overview]: /resources/architectural-overview
[`StatelessWidget`]: {{site.api}}/flutter/widgets/StatelessWidget-class.html
[`StatefulWidget`]: {{site.api}}/flutter/widgets/StatefulWidget-class.html
[`State`]: {{site.api}}/flutter/widgets/State-class.html
[`setState`]: {{site.api}}/flutter/widgets/State/setState.html
[state management lesson]: /get-started/fwe/state-management
[`AppBar`]: {{site.api}}/flutter/material/AppBar-class.html
[`Column`]: {{site.api}}/flutter/widgets/Column-class.html
[`Container`]: {{site.api}}/flutter/widgets/Container-class.html
[`ElevatedButton`]: {{site.api}}/flutter/material/ElevatedButton-class.html
[`Icon`]: {{site.api}}/flutter/widgets/Icon-class.html
[`Image`]: {{site.api}}/flutter/widgets/Image-class.html
[`Row`]: {{site.api}}/flutter/widgets/Row-class.html
[`Scaffold`]: {{site.api}}/flutter/material/Scaffold-class.html
[`Text`]: {{site.api}}/flutter/widgets/Text-class.html

## 피드백 {:#feedback}

이 웹사이트의 이 섹션이 발전하기 때문에, 우리는 [당신의 피드백을 환영합니다][welcome your feedback]!

[welcome your feedback]: https://google.qualtrics.com/jfe/form/SV_6A9KxXR7XmMrNsy?page="fundamentals"
