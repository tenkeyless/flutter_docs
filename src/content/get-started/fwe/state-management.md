---
# title: State management
title: 상태 관리
# description: Learn how to manage state in Flutter.
description: Flutter에서 상태를 관리하는 방법을 알아보세요.
prev:
  # title: Layouts
  title: 레이아웃
  path: /get-started/fwe/layout
next:
  # title: Handling user input
  title: 사용자 입력 처리
  path: /get-started/fwe/user-input
---

Flutter 앱의 _상태(state)_ 는 UI를 표시하거나 시스템 리소스를 관리하는 데 사용하는 모든 객체를 말합니다. 
상태 관리란 앱을 구성하여 이러한 객체에 가장 효과적으로 액세스하고 여러 위젯 간에 공유하는 방법입니다.

이 페이지에서는 다음을 포함하여 상태 관리의 여러 측면을 살펴봅니다.

* [`StatefulWidget`] 사용
* 생성자, [`InheritedWidget`], 콜백을 사용하여 위젯 간에 상태 공유
* [`Listenable`]을 사용하여, 무언가 변경되면 다른 위젯에 알림
* 애플리케이션 아키텍처에 Model-View-ViewModel(MVVM) 사용

상태 관리에 대한 다른 소개는, 다음 리소스를 확인하세요.

* 비디오: [Flutter에서 상태 관리하기][managing-state-video].
  이 비디오는 [riverpod][] 패키지를 사용하는 방법을 보여줍니다.

<i class="material-symbols" aria-hidden="true">flutter_dash</i> 튜토리얼:
[상태 관리][State management].
여기서는 `ChangeNotifer`를 [provider][] 패키지와 함께 사용하는 방법을 보여줍니다.

이 가이드에서는 provider나 Riverpod와 같은 타사 패키지를 사용하지 않습니다. 
대신, Flutter 프레임워크에서 사용 가능한 primitives만 사용합니다.

## StatefulWidget 사용 {:#using-a-statefulwidget}

상태를 관리하는 가장 간단한 방법은 `StatefulWidget`을 사용하는 것입니다. 
`StatefulWidget`은 상태를 자체적으로 저장합니다. 
예를 들어, 다음 위젯을 살펴보세요.

```dart
class MyCounter extends StatefulWidget {
  const MyCounter({super.key});

  @override
  State<MyCounter> createState() => _MyCounterState();
}

class _MyCounterState extends State<MyCounter> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Count: $count'),
        TextButton(
          onPressed: () {
            setState(() {
              count++;
            });
          },
          child: Text('Increment'),
        )
      ],
    );
  }
}
```

이 코드는 상태 관리를 생각할 때 중요한 두 가지 개념을 보여줍니다.

* **캡슐화 (Encapsulation)**
: `MyCounter`를 사용하는 위젯은 기본 `count` 변수에 대한 가시성이 없으며, 
  액세스하거나 변경할 수 있는 수단이 없습니다.
* **객체 수명 주기 (Object lifecycle)**
: `_MyCounterState` 객체와 해당 `count` 변수는 `MyCounter`가 처음 빌드될 때 생성되고, 
  화면에서 제거될 때까지 존재합니다. 이는 _임시적 상태(ephemeral state)_ 의 예입니다.

다음 리소스가 유용할 수 있습니다.

* 글: [임시적 상태 및 앱 상태][ephemeral-state]
* API 문서: [StatefulWidget][]

## 위젯 간 상태 공유 {:#sharing-state-between-widgets}

앱이 상태를 저장해야 하는 시나리오는 다음과 같습니다.

* 공유 상태를 **업데이트(update)**하여, 앱의 다른 부분에 알리기 위해
* 공유 상태의 변경 사항을 **수신(listen)**하여, 변경 시 UI를 다시 빌드하기 위해

이 섹션에서는 앱의 여러 위젯 간에 상태를 효과적으로 공유하는 방법을 살펴봅니다. 
가장 일반적인 패턴은 다음과 같습니다.

* **위젯 생성자 사용** (다른 프레임워크에서는 "prop drilling"이라고도 함)
* **`InheritedWidget` 사용** (또는 [provider][] 패키지와 같은 유사한 API).
* **콜백 사용** 부모 위젯에 무언가 변경되었음을 알리기

### (1) 위젯 생성자 사용 {:#using-widget-constructors}

Dart 객체는 참조로 전달되므로, 위젯이 생성자에서 사용해야 하는 객체를 정의하는 것은 매우 일반적입니다. 
위젯의 생성자에 전달하는 모든 상태는 UI를 빌드하는 데 사용할 수 있습니다.

```dart
class MyCounter extends StatelessWidget {
  final int count;
  const MyCounter({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Text('$count');
  }
}
```

이렇게 하면 위젯을 사용하는 다른 사용자가, 
위젯을 사용하기 위해 제공해야 하는 내용을 명확하게 알 수 있습니다.

```dart
Column(
  children: [
    MyCounter(
      count: count,
    ),
    MyCounter(
      count: count,
    ),
    TextButton(
      child: Text('Increment'),
      onPressed: () {
        setState(() {
          count++;
        });
      },
    )
  ],
)
```

위젯 생성자를 통해 앱의 공유 데이터를 전달하면, 
코드를 읽는 모든 사람에게 공유 종속성이 있다는 것이 분명해집니다. 
이는 _종속성 주입(dependency injection)_ 이라고 하는 일반적인 디자인 패턴이며, 
많은 프레임워크가 이를 활용하거나 이를 더 쉽게 만드는 도구를 제공합니다.

### (2) InheritedWidget 사용 {:#using-inheritedwidget}

위젯 트리를 따라 수동으로 데이터를 전달하는 것은, 
장황하고 원치 않는 보일러플레이트 코드를 생성할 수 있으므로, 
Flutter는 _`InheritedWidget`_을 제공합니다. 
이는 부모 위젯에서 데이터를 효율적으로 호스팅하여, 
자식 위젯이 필드로 저장하지 않고도 데이터에 액세스할 수 있는 방법을 제공합니다.

`InheritedWidget`을 사용하려면, `InheritedWidget` 클래스를 확장하고, `dependOnInheritedWidgetOfExactType`을 사용하여 정적 메서드 `of()`를 구현합니다. 
빌드 메서드에서 `of()`를 호출하는 위젯은, 
Flutter 프레임워크에서 관리하는 종속성을 생성하므로, 
이 `InheritedWidget`에 종속된 모든 위젯은, 
이 위젯은 `updateShouldNotify`가 true를 반환할 때 새 데이터로 재빌드됩니다.

```dart
class MyState extends InheritedWidget {
  const MyState({
    super.key,
    required this.data,
    required super.child,
  });

  final String data;

  static MyState of(BuildContext context) {
    // 이 메서드는 가장 가까운 `MyState` 위젯 조상을 찾습니다.
    final result = context.dependOnInheritedWidgetOfExactType<MyState>();

    assert(result != null, 'No MyState found in context');

    return result!;
  }

  @override
  // 이 메서드는 이전 위젯의 데이터가 이 위젯의 ​​데이터와 다를 경우, true를 반환해야 합니다. 
  // true인 경우, `of()`를 호출하여 이 위젯에 의존하는 모든 위젯이 재빌드됩니다.
  bool updateShouldNotify(MyState oldWidget) => data != oldWidget.data;
}
```

다음으로, 공유 상태에 액세스해야 하는 위젯의 `build()` 메서드에서 `of()` 메서드를 호출합니다.

```dart
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var data = MyState.of(context).data;
    return Scaffold(
      body: Center(
        child: Text(data),
      ),
    );
  }
}
```


### (3) 콜백 사용 {:#using-callbacks}

콜백을 노출하여 값이 변경될 때 다른 위젯에 알릴 수 있습니다. 
Flutter는, 단일 매개변수로 함수 콜백을 선언하는, `ValueChanged` 타입을 제공합니다.

```dart
typedef ValueChanged<T> = void Function(T value);
```

위젯 생성자에서 `onChanged`를 노출하면, 
이 위젯을 사용하는 모든 위젯이 위젯에서 `onChanged`를 호출할 때 응답할 수 있는 방법을 제공합니다.

```dart
class MyCounter extends StatefulWidget {
  const MyCounter({super.key, required this.onChanged});

  final ValueChanged<int> onChanged;

  @override
  State<MyCounter> createState() => _MyCounterState();
}
```

예를 들어, 이 위젯은 `onPressed` 콜백을 처리하고, 
`count` 변수에 대한 최신 내부 상태로 `onChanged`를 호출할 수 있습니다.

```dart
TextButton(
  onPressed: () {
    widget.onChanged(count++);
  },
),
```

### 더 깊이 들어가 보세요 {:#dive-deeper}

위젯 간 상태 공유에 대한 자세한 내용은 다음 리소스를 확인하세요.

* 글: [Flutter 아키텍처 개요 - 상태 관리][architecture-state]
* 비디오: [실용적인(Pragmatic) 상태 관리][Pragmatic state management]
* 비디오: [InheritedWidgets][inherited-widget-video]
* 비디오: [Inherited 위젯에 대한 가이드][A guide to Inherited Widgets]
* 샘플: [Provider shopper][Provider shopper]
* 샘플: [Provider counter][Provider counter]
* API 문서: [`InheritedWidget`][]

## listenables 사용 {:#using-listenables}

이제 앱에서 상태를 공유하는 방법을 선택했으니, UI가 변경될 때 UI를 어떻게 업데이트할까요? 
앱의 다른 부분에 알리는 방식으로 공유 상태를 어떻게 변경할까요?

Flutter는 하나 이상의 리스너를 업데이트할 수 있는 `Listenable`이라는 추상 클래스를 제공합니다. 
리스너블을 사용하는 몇 가지 유용한 방법은 다음과 같습니다.

* `ChangeNotifier`를 사용하고 `ListenableBuilder`를 사용하여 구독합니다.
* `ValueNotifier`를 `ValueListenableBuilder`와 함께 사용합니다.

### (1) ChangeNotifier {:#changenotifier}

`ChangeNotifier`를 사용하려면 이를 확장하는 클래스를 만들고, 
클래스가 리스너에게 알림을 보내야 할 때마다 `notifyListeners`를 호출합니다.

```dart
class CounterNotifier extends ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}
```

그런 다음, 이를 `ListenableBuilder`에 전달하여, 
`ChangeNotifier`가 리스너를 업데이트할 때마다, 
`builder` 함수에서 반환된 하위 트리가 재빌드되도록 합니다.

```dart
Column(
  children: [
    ListenableBuilder(
      listenable: counterNotifier,
      builder: (context, child) {
        return Text('counter: ${counterNotifier.count}');
      },
    ),
    TextButton(
      child: Text('Increment'),
      onPressed: () {
        counterNotifier.increment();
      },
    ),
  ],
)
```

### (2) ValueNotifier {:#valuenotifier}

[`ValueNotifier`]는 단일 값을 저장하는 `ChangeNotifier`의 더 간단한 버전입니다. 
`ValueListenable` 및 `Listenable` 인터페이스를 구현하므로, 
`ListenableBuilder` 및 `ValueListenableBuilder`와 같은 위젯과 호환됩니다. 
사용하려면, 초기 값으로 `ValueNotifier` 인스턴스를 만듭니다.

```dart
ValueNotifier<int> counterNotifier = ValueNotifier(0);
```

그런 다음, `value` 필드를 사용하여 값을 읽거나 업데이트하고, 값이 변경되었음을 모든 리스너에게 알립니다. 
`ValueNotifier`는 `ChangeNotifier`를 확장하므로, 
`Listenable`이기도 ​​하며 `ListenableBuilder`와 함께 사용할 수 있습니다. 
하지만, `Builder` 콜백에서 값을 제공하는 `ValueListenableBuilder`도 사용할 수 있습니다.

```dart
Column(
  children: [
    ValueListenableBuilder(
      valueListenable: counterNotifier,
      builder: (context, child, value) {
        return Text('counter: $value');
      },
    ),
    TextButton(
      child: Text('Increment'),
      onPressed: () {
        counterNotifier.value++;
      },
    ),
  ],
)
```

### 깊이 들어가기 {:#deep-dive}

`Listenable` 객체에 대해 자세히 알아보려면, 다음 리소스를 확인하세요.

* API 문서: [`Listenable`][]
* API 문서: [`ValueNotifier`][]
* API 문서: [`ValueListenable`][]
* API 문서: [`ChangeNotifier`][]
* API 문서: [`ListenableBuilder`][]
* API 문서: [`ValueListenableBuilder`][]
* API 문서: [`InheritedNotifier`][]

## 애플리케이션 아키텍처에 MVVM 사용 {:#using-mvvm-for-your-applications-architecture}

이제 상태를 공유하고 상태가 변경될 때 앱의 다른 부분에 알리는 방법을 이해했으므로, 
앱에서 상태 객체를 구성하는 방법에 대해 생각할 준비가 되었습니다.

이 섹션에서는 _Model-View-ViewModel_ 또는 _MVVM_ 이라고 하는, 
Flutter와 같은 반응형 프레임워크에서 잘 작동하는 디자인 패턴을 구현하는 방법을 설명합니다.

### (1) Model 정의 {:#defining-the-model}

모델은 일반적으로 HTTP 요청, (데이터 캐싱 또는 (플러그인과 같은) 시스템 리소스 관리와 같은) 
낮은 레벨 작업을 수행하는 Dart 클래스입니다. 
모델은 일반적으로 Flutter 라이브러리를 가져올 필요가 없습니다.

예를 들어, HTTP 클라이언트를 사용하여 카운터 상태를 로드하거나 업데이트하는 모델을 생각해 보세요.

```dart
import 'package:http/http.dart';

class CounterData {
  CounterData(this.count);

  final int count;
}

class CounterModel {
  Future<CounterData> loadCountFromServer() async {
    final uri = Uri.parse('https://myfluttercounterapp.net/count');
    final response = await get(uri);

    if (response.statusCode != 200) {
      throw ('Failed to update resource');
    }

    return CounterData(int.parse(response.body));
  }

  Future<CounterData> updateCountOnServer(int newCount) async {
    // ...
  }
}
```

이 모델은 Flutter primitives를 사용하지 않으며, 실행 중인 플랫폼에 대한 가정도 하지 않습니다. 
유일한 작업은 HTTP 클라이언트를 사용하여 카운트를 가져오거나 업데이트하는 것입니다. 
이를 통해 유닛 테스트에서 Mock ​​또는 Fake로 모델을 구현할 수 있으며, 
앱의 낮은 레벨 구성 요소와 전체 앱을 빌드하는 데 필요한 높은 레벨 UI 구성 요소 간의 명확한 경계를 정의합니다.

`CounterData` 클래스는 데이터의 구조를 정의하며, 애플리케이션의 진정한 "모델"입니다. 
모델 레이어는 일반적으로 앱에 필요한 핵심 알고리즘과 데이터 구조를 담당합니다. 
(불변(immutable) 값 타입을 사용하는 것과 같이) 모델을 정의하는 다른 방법에 관심이 있는 경우, 
pub.dev에서 [freezed][] 또는 [build_collection][]과 같은 패키지를 확인하세요.

### (2) ViewModel 정의 {:#defining-the-viewmodel}

`ViewModel`은 _View_ 를 _Model_ 에 바인딩합니다. 
View에서 직접 모델에 액세스하는 것을 방지하고, 데이터 흐름이 모델의 변경에서 시작되도록 합니다. 
데이터 흐름은 `ViewModel`에서 처리하는데, `notifyListeners`를 사용하여 View에 무언가 변경되었음을 알립니다. 
`ViewModel`은 주방(모델)과 고객(뷰) 간의 통신을 처리하는 레스토랑의 웨이터와 같습니다.

```dart
import 'package:flutter/foundation.dart';

class CounterViewModel extends ChangeNotifier {
  final CounterModel model;
  int? count;
  String? errorMessage;
  CounterViewModel(this.model);

  Future<void> init() async {
    try {
      count = (await model.loadCountFromServer()).count;
    } catch (e) {
      errorMessage = 'Could not initialize counter';
    }
    notifyListeners();
  }

  Future<void> increment() async {
    var count = this.count;
    if (count == null) {
      throw('Not initialized');
    }
    try {
      await model.updateCountOnServer(count + 1);
      count++;
    } catch(e) {
      errorMessage = 'Count not update count';
    }
    notifyListeners();
  }
}
```

`ViewModel`은 Model에서 오류를 받으면 `errorMessage`를 저장합니다. 
이렇게 하면, View가 처리되지 않은 런타임 오류로부터 보호되어 충돌이 발생할 수 있습니다. 
대신, `errorMessage` 필드는 view에서 사용자 친화적인 오류 메시지를 표시하는 데 사용할 수 있습니다.

### (3) View 정의 {:#defining-the-view}

`ViewModel`은 `ChangeNotifier`이므로, 
이를 참조하는 모든 위젯은 `ViewModel`이 리스너에게 알릴 때, 
`ListenableBuilder`를 사용하여 위젯 트리를 재빌드할 수 있습니다.

```dart
ListenableBuilder(
  listenable: viewModel,
  builder: (context, child) {
    return Column(
      children: [
        if (viewModel.errorMessage != null)
          Text(
            'Error: ${viewModel.errorMessage}',
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.apply(color: Colors.red),
          ),
        Text('Count: ${viewModel.count}'),
        TextButton(
          onPressed: () {
            viewModel.increment();
          },
          child: Text('Increment'),
        ),
      ],
    );
  },
)
```

이 패턴을 사용하면 애플리케이션의 비즈니스 로직을, 
UI 로직과 모델 레이어에서 수행하는 낮은 레벨 작업과 분리할 수 있습니다.

## 상태 관리에 대해 자세히 알아보기 {:#learn-more-about-state-management}

이 페이지는 Flutter 애플리케이션의 상태를 구성하고 관리하는 방법이 많기 때문에 상태 관리의 표면을 다룹니다. 
자세히 알아보려면 다음 리소스를 확인하세요.

* 글: [상태 관리 접근 방식 리스트][List of state management approaches]
* 저장소: [Flutter 아키텍처 샘플][Flutter Architecture Samples]

[A guide to Inherited Widgets]: {{site.youtube-site}}/watch?v=Zbm3hjPjQMk
[build_collection]: {{site.pub-pkg}}/built_collection
[Flutter Architecture Samples]: https://fluttersamples.com/
[`InheritedWidget`]: {{site.api}}/flutter/widgets/InheritedWidget-class.html
[List of state management approaches]: /data-and-backend/state-mgmt/options
[Pragmatic state management]: {{site.youtube-site}}/watch?v=d_m5csmrf7I
[Provider counter]: https://github.com/flutter/samples/tree/main/provider_counter
[Provider shopper]: https://flutter.github.io/samples/provider_shopper.html
[State management]: /data-and-backend/state-mgmt/intro
[StatefulWidget]: /flutter/widgets/StatefulWidget-class.html
[`StatefulWidget`]: /flutter/widgets/StatefulWidget-class.html
[`ChangeNotifier`]: {{site.api}}/flutter/foundation/ChangeNotifier-class.html
[`InheritedNotifier`]: {{site.api}}/flutter/widgets/InheritedNotifier-class.html
[`ListenableBuilder`]: {{site.api}}/flutter/widgets/ListenableBuilder-class.html
[`Listenable`]: {{site.api}}/flutter/foundation/Listenable-class.html
[`ValueListenableBuilder`]: {{site.api}}/flutter/widgets/ValueListenableBuilder-class.html
[`ValueListenable`]: {{site.api}}/flutter/foundation/ValueListenable-class.html
[`ValueNotifier`]: {{site.api}}/flutter/foundation/ValueNotifer-class.html
[architecture-state]: /resources/architectural-overview#state-management
[ephemeral-state]: /data-and-backend/state-mgmt/ephemeral-vs-app
[freezed]: {{site.pub-pkg}}/freezed
[inherited-widget-video]: {{site.youtube-site}}/watch?v=og-vJqLzg2c
[managing-state-video]: {{site.youtube-site}}/watch?v=vU9xDLdEZtU
[provider]: {{site.pub-pkg}}/provider
[riverpod]: {{site.pub-pkg}}/riverpod

## 피드백 {:#feedback}

이 웹사이트의 이 섹션이 발전하기 때문에, 우리는 [당신의 피드백을 환영합니다][welcome your feedback]!

[welcome your feedback]: https://google.qualtrics.com/jfe/form/SV_6A9KxXR7XmMrNsy?page="state-management"
