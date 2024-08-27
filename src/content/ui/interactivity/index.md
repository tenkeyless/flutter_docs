---
# title: Add interactivity to your Flutter app
title: Flutter 앱에 상호 작용 기능 추가
# description: How to implement a stateful widget that responds to taps.
description: 탭에 반응하는 stateful 위젯을 구현하는 방법.
# short-title: Interactivity
short-title: 상호작용
diff2html: true
---

{% assign examples = site.repo.this | append: "/tree/" | append: site.branch | append: "/examples" -%}

:::secondary 학습할 내용
* 탭에 응답하는 방법.
* 커스텀 위젯을 만드는 방법.
* stateless 위젯과 stateful 위젯의 차이점.
:::

사용자 입력에 반응하도록 앱을 수정하려면 어떻게 해야 하나요? 
이 튜토리얼에서는, 비 상호 작용 위젯만 포함된 앱에 상호 작용 기능을 추가합니다. 
구체적으로는, 두 개의 stateless 위젯을 관리하는 커스텀 stateful 위젯을 만들어서 아이콘을 탭할 수 있도록 수정합니다.

[레이아웃 구축 튜토리얼][building layouts tutorial]에서는 다음 스크린샷의 레이아웃을 만드는 방법을 보여주었습니다.

{% render docs/app-figure.md, img-class:"site-mobile-screenshot border", image:"ui/layout/lakes.jpg", caption:"레이아웃 튜토리얼 앱" %}

앱을 처음 실행하면, 별이 빨간색으로 표시되어, 이 호수가 이전에 즐겨찾기에 추가되었음을 나타냅니다. 
별 옆의 숫자는 41명이 이 호수를 즐겨찾기에 추가했음을 나타냅니다. 
이 튜토리얼을 완료한 후, 별을 탭하면 즐겨찾기 상태가 제거되고, 단색 별이 윤곽선으로 바뀌고 개수가 감소합니다. 
다시 탭하면, 호수가 즐겨찾기되고, 단색 별이 그려지고 개수가 증가합니다.

<img src='/assets/images/docs/ui/favorited-not-favorited.png' class="mw-100 text-center" alt="The custom widget you'll create" width="200px">

이를 달성하려면, 별과 카운트를 모두 포함하는 단일 커스텀 위젯을 만들어야 합니다. 
별과 카운트는 위젯 자체입니다. 별을 탭하면 두 위젯의 상태가 변경되므로, 동일한 위젯이 둘 다 관리해야 합니다.

[2단계: StatefulWidget 서브클래싱](#step-2)에서 바로 코드를 터치할 수 있습니다. 
상태 관리의 다른 방법을 시도하려면 [상태 관리][Managing state]로 건너뛰세요.

## Stateful 및 stateless 위젯 {:#stateful-and-stateless-widgets}

위젯은 stateful 이거나 stateless 입니다. 
위젯이 변경될 수 있는 경우 (예: 사용자가 위젯과 상호 작용할 때) stateful 입니다.

* _stateless_ 위젯은 절대 변경되지 않습니다. 
  
  [`Icon`][], [`IconButton`][], [`Text`][]는 stateless 위젯의 예입니다. 
  
  stateless 위젯은 [`StatelessWidget`][]의 하위 클래스입니다.

* _stateful_ 위젯은 동적입니다. 
  
  예를 들어, 사용자 상호 작용으로 트리거된 이벤트에 응답하거나, 데이터를 수신할 때 모양을 변경할 수 있습니다. 
  [`Checkbox`][], [`Radio`][], [`Slider`][], [`InkWell`][], [`Form`][], [`TextField`][]는 stateful 위젯의 예입니다. 
  
  stateful 위젯은 [`StatefulWidget`][]의 하위 클래스입니다.

위젯의 상태는 [`State`][] 객체에 저장되어 위젯의 상태와 모양을 분리합니다. 
상태는, 슬라이더의 현재 값이나 체크박스가 선택되었는지 여부와 같이, 변경될 수 있는 값으로 구성됩니다. 
위젯의 상태가 변경되면, 상태 객체는 `setState()`를 호출하여, 프레임워크에 위젯을 다시 그리라고 알립니다.

## stateless 위젯 만들기 {:#creating-a-stateful-widget}

:::secondary 요점은 무엇인가요?

* stateful 위젯은 두 개의 클래스로 구현됩니다. 
  * `StatefulWidget`의 하위 클래스와 
  * `State`의 하위 클래스입니다.
    * 상태 클래스에는 위젯의 변경 가능한(mutable) 상태와 위젯의 `build()` 메서드가 포함됩니다.
* 위젯의 상태가 변경되면, 상태 객체는 `setState()`를 호출하여, 프레임워크에 위젯을 다시 그리라고 알립니다.

:::

이 섹션에서는, 커스텀 상태 stateful을 만듭니다. 
두 개의 stateless 위젯(빨간색 별표와 그 옆에 있는 숫자 카운트)을, 
두 개의 자식 위젯(`IconButton`과 `Text`)이 있는 행을 관리하는 단일 커스텀 stateful 위젯으로 바꿉니다.

커스텀 stateful 위젯을 구현하려면, 두 개의 클래스를 만들어야 합니다.

* 위젯을 정의하는 `StatefulWidget`의 하위 클래스.
* 해당 위젯의 상태를 포함하고 위젯의 `build()` 메서드를 정의하는 `State`의 하위 클래스.

이 섹션에서는 lakes 앱에 대한 `FavoriteWidget`이라는 stateful 위젯을 빌드하는 방법을 보여줍니다. 
설정 후, 첫 번째 단계는 `FavoriteWidget`에 대한 상태를 관리하는 방법을 선택하는 것입니다.

### 스텝 0: 준비하기 {:#step-0-get-ready}

[빌드 레이아웃 튜토리얼][building layouts tutorial]에서 이미 앱을 빌드했다면, 다음 섹션으로 건너뜁니다.

1. 환경을 [설정][set up]했는지 확인합니다.
1. [새 Flutter 앱][new-flutter-app]을 만듭니다.
1. `lib/main.dart` 파일을 [`main.dart`][]로 바꿉니다.
1. `pubspec.yaml` 파일을 [`pubspec.yaml`][]로 바꿉니다.
1. 프로젝트에 `images` 디렉터리를 만들고 [`lake.jpg`][]를 추가합니다.

연결하고 활성화된 기기가 있거나, 
[iOS 시뮬레이터][iOS simulator](Flutter 설치의 일부) 또는 
[Android 에뮬레이터][Android emulator](Android Studio 설치의 일부)를 실행했다면 사용할 수 있습니다!

<a id="step-1"></a>

### 스텝 1: 위젯의 상태를 관리하는 객체 결정 {:#step-1-decide-which-object-manages-the-widgets-state}

위젯의 상태는 여러 가지 방법으로 관리할 수 있지만, 
우리의 예에서 위젯 자체인 `FavoriteWidget`은 자체 상태를 관리합니다. 
이 예에서, 별표 토글은 부모 위젯이나 나머지 UI에 영향을 미치지 않는 고립된 동작이므로, 
위젯은 내부적으로 상태를 처리할 수 있습니다.

위젯과 상태의 분리와 상태를 관리하는 방법에 대해 자세히 알아보려면, [상태 관리][Managing state]를 참조하세요.

<a id="step-2"></a>

### 스텝 2: StatefulWidget 서브클래싱하기 {:#step-2-subclass-statefulwidget}

`FavoriteWidget` 클래스는 자체 상태를 관리하므로, 
`createState()`를 재정의하여 `State` 객체를 만듭니다. 
프레임워크는 위젯을 빌드하려고 할 때 `createState()`를 호출합니다. 
이 예에서, `createState()`는 다음 단계에서 구현할 `_FavoriteWidgetState`의 인스턴스를 반환합니다.

<?code-excerpt path-base="layout/lakes/interactive"?>

<?code-excerpt "lib/main.dart (favorite-widget)"?>
```dart
class FavoriteWidget extends StatefulWidget {
  const FavoriteWidget({super.key});

  @override
  State<FavoriteWidget> createState() => _FavoriteWidgetState();
}
```

:::note
밑줄(`_`)로 시작하는 멤버 또는 클래스는 private 입니다. 
자세한 내용은 [Dart 언어 문서][Dart language documentation]의 섹션인 [라이브러리 및 가져오기][Libraries and imports]를 참조하세요.
:::

<a id="step-3"></a>

### 스텝 3: State 서브클래싱 하기 {:#step-3-subclass-state}

`_FavoriteWidgetState` 클래스는 위젯의 수명 동안 변경될 수 있는 가변(mutable) 데이터를 저장합니다. 
앱이 처음 실행되면, UI에 빨간색 별표가 표시되어 호수가 "즐겨찾기" 상태임을 나타내며, 좋아요도 41개입니다. 
이러한 값은 `_isFavorited` 및 `_favoriteCount` 필드에 저장됩니다.

<?code-excerpt "lib/main.dart (favorite-state-fields)" replace="/(bool|int) .*/[!$&!]/g"?>
```dart
class _FavoriteWidgetState extends State<FavoriteWidget> {
  [!bool _isFavorited = true;!]
  [!int _favoriteCount = 41;!]
```

클래스는 또한 빨간색 `IconButton`과 `Text`를 포함하는 행을 만드는 `build()` 메서드를 정의합니다. 
탭을 처리하기 위한 콜백 함수(`_toggleFavorite`)를 정의하는 `onPressed` 속성이 있기 때문에, 
[`IconButton`][](`Icon` 대신)을 사용합니다. 
다음으로, 콜백 함수를 정의합니다.

<?code-excerpt "lib/main.dart (favorite-state-build)" replace="/build|icon.*|onPressed.*|child: Text.*/[!$&!]/g"?>
```dart
class _FavoriteWidgetState extends State<FavoriteWidget> {
  // ···
  @override
  Widget [!build!](BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(0),
          child: IconButton(
            padding: const EdgeInsets.all(0),
            alignment: Alignment.center,
            [!icon: (_isFavorited!]
                ? const Icon(Icons.star)
                : const Icon(Icons.star_border)),
            color: Colors.red[500],
            [!onPressed: _toggleFavorite,!]
          ),
        ),
        SizedBox(
          width: 18,
          child: SizedBox(
            [!child: Text('$_favoriteCount'),!]
          ),
        ),
      ],
    );
  }
  // ···
}
```

:::tip
`Text`를 [`SizedBox`][]에 배치하고 너비를 설정하면, 
텍스트가 40과 41 사이에서 변경될 때 눈에 띄는 "점프"가 발생하지 않습니다. 

그렇지 않으면, 값의 너비가 다르기 때문에 점프가 발생합니다.
:::

`IconButton`을 눌렀을 때, 호출되는 `_toggleFavorite()` 메서드는 `setState()`를 호출합니다. 
`setState()`를 호출하는 것은, 프레임워크에 위젯의 상태가 변경되었고 위젯을 다시 그려야 한다는 것을 알리기 때문에, 중요합니다. `setState()`에 대한 함수 인수는 UI를 다음 두 상태 사이에서 토글합니다.

* `star` 아이콘과 숫자 41
* `star_border` 아이콘과 숫자 40

<?code-excerpt "lib/main.dart (toggle-favorite)"?>
```dart
void _toggleFavorite() {
  setState(() {
    if (_isFavorited) {
      _favoriteCount -= 1;
      _isFavorited = false;
    } else {
      _favoriteCount += 1;
      _isFavorited = true;
    }
  });
}
```

<a id="step-4"></a>

### 스텝 4: stateful 위젯을 위젯 트리에 연결하기 {:#step-4-plug-the-stateful-widget-into-the-widget-tree}

앱의 `build()` 메서드에서 위젯 트리에 커스텀 stateful 위젯을 추가합니다. 
먼저, `Icon`과 `Text`를 만드는 코드를 찾아 삭제합니다. 같은 위치에서, stateful 위젯을 만듭니다.

<?code-excerpt path-base=""?>

```dart diff
  child: Row(
    children: [
      // ...
-     Icon(
-       Icons.star,
-       color: Colors.red[500],
-     ),
-     const Text('41'),
+     const FavoriteWidget(),
    ],
  ),
```

그게 다예요! 앱을 핫 리로드하면 별 아이콘이 탭에 응답해야 합니다.

### 문제가 있나요? {:#problems}

코드를 실행할 수 없다면, IDE에서 가능한 오류를 찾아보세요. 
[Flutter 앱 디버깅][Debugging Flutter apps]이 도움이 될 수 있습니다. 
여전히 문제를 찾을 수 없다면, GitHub의 interactive lakes 예제와 코드를 비교해보세요.

{% comment %}
TODO: replace the following links with tabbed code panes.
{% endcomment -%}

* [`lib/main.dart`]({{site.repo.this}}/tree/{{site.branch}}/examples/layout/lakes/interactive/lib/main.dart)
* [`pubspec.yaml`]({{site.repo.this}}/tree/{{site.branch}}/examples/layout/lakes/interactive/pubspec.yaml)
* [`lakes.jpg`]({{site.repo.this}}/tree/{{site.branch}}/examples/layout/lakes/interactive/images/lake.jpg)

여전히 궁금한 점이 있으면, 개발자 [커뮤니티][community] 채널을 참조하세요.

---

이 페이지의 나머지 부분에서는 위젯 상태를 관리하는 여러 가지 방법을 다루며, 
사용 가능한 다른 상호 작용 위젯을 나열합니다.

## 상태 관리 {:#managing-state}

:::secondary 요점은 무엇인가요?
* 상태를 관리하는 데는 다양한 접근 방식이 있습니다.
* 위젯 디자이너인 당신은, 어떤 접근 방식을 사용할지 선택합니다.
* 의심스러운 경우, 부모 위젯에서 상태를 관리하는 것으로 시작합니다.
:::

stateful 위젯의 상태를 관리하는 사람은 누구인가요? 
위젯 자체인가요? 부모 위젯인가요? 둘 다인가요? 다른 객체인가요? 답은... 상황에 따라 다릅니다. 
위젯을 상호 작용으로 만드는 데는 여러 가지 유효한 방법이 있습니다. 
위젯 디자이너인 여러분은 위젯을 어떻게 사용할지에 따라 결정을 내립니다. 
상태를 관리하는 가장 일반적인 방법은 다음과 같습니다.

* [위젯이 자기 스스로 상태를 관리합니다](#self-managed)
* [부모가 위젯의 상태를 관리합니다](#parent-managed)
* [믹스 앤 매치 방식](#mix-and-match)

어떤 접근 방식을 사용할지 어떻게 결정합니까? 다음 원칙이 결정하는 데 도움이 될 것입니다.

* 문제의 상태가 사용자 데이터인 경우(예: 체크박스의 체크 또는 체크 해제 모드, 슬라이더의 위치), 
  * 상태는 부모 위젯에서 관리하는 것이 가장 좋습니다.

* 문제의 상태가 미적인 경우(예: 애니메이션), 
  * 상태는 위젯 자기 스스로에서 관리하는 것이 가장 좋습니다.

의심스러운 경우, 부모 위젯에서 상태를 관리하는 것으로 시작합니다.

세 가지 간단한 예를 만들어 상태를 관리하는 다양한 방법에 대한 예를 들어보겠습니다. 
* TapboxA, TapboxB, TapboxC. 

모든 예는 비슷하게 작동합니다. 
* 각각은 탭하면 녹색 또는 회색 상자 사이를 전환하는 컨테이너를 만듭니다. 
* `_active` boolean은 색상을 결정합니다. 
  * 활성은 녹색, 비활성은 회색입니다.

<div class="row mb-4">
  <div class="col-12 text-center">
    <img src='/assets/images/docs/ui/tapbox-active-state.png' class="border mt-1 mb-1 mw-100" width="150px" alt="Active state">
    <img src='/assets/images/docs/ui/tapbox-inactive-state.png' class="border mt-1 mb-1 mw-100" width="150px" alt="Inactive state">
  </div>
</div>

이러한 예제에서는 [`GestureDetector`][]를 사용하여, `Container`에서 activity를 캡처합니다.

<a id="self-managed"></a>

### (1) 위젯이 자기 스스로 상태를 관리 {:#the-widget-manages-its-own-state}

위젯이 내부적으로 상태를 관리하는 것이 가장 합리적인 경우가 있습니다. 
예를 들어, [`ListView`][]는 콘텐츠가 렌더 상자를 초과하면 자동으로 스크롤합니다. 
`ListView`를 사용하는 대부분의 개발자는 `ListView`의 스크롤 동작을 관리하고 싶어하지 않으므로, 
`ListView` 자체가 스크롤 오프셋을 관리합니다.

`_TapboxAState` 클래스:

* `TapboxA`의 상태를 관리합니다.
* 상자의 현재 색상을 결정하는 `_active` boolean을 정의합니다.
* 상자를 탭하면 `_active`를 업데이트하고, 
  `setState()` 함수를 호출하여 UI를 업데이트하는 `_handleTap()` 함수를 정의합니다.
* 위젯의 모든 상호 작용 동작을 구현합니다.

<?code-excerpt path-base="ui/interactive/"?>

<?code-excerpt "lib/self_managed.dart"?>
```dart
import 'package:flutter/material.dart';

// TapboxA는 자체 상태를 관리합니다.

//------------------------- TapboxA ----------------------------------

class TapboxA extends StatefulWidget {
  const TapboxA({super.key});

  @override
  State<TapboxA> createState() => _TapboxAState();
}

class _TapboxAState extends State<TapboxA> {
  bool _active = false;

  void _handleTap() {
    setState(() {
      _active = !_active;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: _active ? Colors.lightGreen[700] : Colors.grey[600],
        ),
        child: Center(
          child: Text(
            _active ? 'Active' : 'Inactive',
            style: const TextStyle(fontSize: 32, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

//------------------------- MyApp ----------------------------------

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Demo'),
        ),
        body: const Center(
          child: TapboxA(),
        ),
      ),
    );
  }
}
```

<hr>

<a id="parent-managed"></a>

### (2) 부모가 위젯의 상태를 관리 {:#the-parent-widget-manages-the-widgets-state}

부모 위젯이 상태를 관리하고 자식 위젯에 업데이트 시기를 알려주는 것이 가장 합리적인 경우가 많습니다. 
예를 들어, [`IconButton`][]을 사용하면 아이콘을 탭 가능한 버튼으로 처리할 수 있습니다. 
`IconButton`은 (부모 위젯이 버튼이 탭되었는지 알아야 적절한 조치를 취할 수 있다고 결정했기 때문에) stateless 위젯입니다.

다음 예에서, TapboxB는 콜백을 통해 상태를 부모 위젯으로 내보냅니다.
TapboxB는 상태를 관리하지 않으므로, StatelessWidget을 하위 클래스화합니다.

ParentWidgetState 클래스:

* TapboxB의 `_active` 상태를 관리합니다.
* 상자를 탭하면 호출되는 메서드인 `_handleTapboxChanged()`를 구현합니다.
* 상태가 변경되면, `setState()`를 호출하여 UI를 업데이트합니다.

TapboxB 클래스:

* 모든 상태가 부모 위젯에서 처리되므로 StatelessWidget을 확장합니다.
* 탭이 감지되면, 부모 위젯에 알립니다.

<?code-excerpt "lib/parent_managed.dart"?>
```dart
import 'package:flutter/material.dart';

// ParentWidget은 TapboxB의 상태를 관리합니다.

//------------------------ ParentWidget --------------------------------

class ParentWidget extends StatefulWidget {
  const ParentWidget({super.key});

  @override
  State<ParentWidget> createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  bool _active = false;

  void _handleTapboxChanged(bool newValue) {
    setState(() {
      _active = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TapboxB(
        active: _active,
        onChanged: _handleTapboxChanged,
      ),
    );
  }
}

//------------------------- TapboxB ----------------------------------

class TapboxB extends StatelessWidget {
  const TapboxB({
    super.key,
    this.active = false,
    required this.onChanged,
  });

  final bool active;
  final ValueChanged<bool> onChanged;

  void _handleTap() {
    onChanged(!active);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: active ? Colors.lightGreen[700] : Colors.grey[600],
        ),
        child: Center(
          child: Text(
            active ? 'Active' : 'Inactive',
            style: const TextStyle(fontSize: 32, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
```

<hr>

<a id="mix-and-match"></a>

### (3) 믹스 앤 매치 방식 {:#a-mix-and-match-approach}

일부 위젯의 경우, 혼합 및 일치(mix-and-match) 방식이 가장 합리적입니다. 
이 시나리오에서, stateful 위젯은 일부 상태를 관리하고, 부모 위젯은 상태의 다른 측면을 관리합니다.

`TapboxC` 예에서, 탭 다운 시, 상자 주위에 짙은 녹색 테두리가 나타납니다. 
탭 업 시, 테두리가 사라지고 상자의 색상이 변경됩니다. 
`TapboxC`는 `_active` 상태를 부모로 내보내지만, `_highlight` 상태는 내부적으로 관리합니다. 
이 예에는 `_ParentWidgetState`와 `_TapboxCState`라는 두 개의 `State` 객체가 있습니다.

`_ParentWidgetState` 객체:

* `_active` 상태를 관리합니다.
* 상자를 탭할 때 호출되는 메서드인, `_handleTapboxChanged()`를 구현합니다.
* 탭이 발생하고 `_active` 상태가 변경될 때 UI를 업데이트하기 위해 `setState()`를 호출합니다.

`_TapboxCState` 객체:

* `_highlight` 상태를 관리합니다.
* `GestureDetector`는 모든 탭 이벤트를 수신합니다. 
  사용자가 탭하면, 강조 표시(진한 녹색 테두리로 구현됨)를 추가합니다. 
  사용자가 탭을 놓으면, 강조 표시를 제거합니다.
* 탭 다운, 탭 업 또는 탭 취소 시 UI를 업데이트하기 위해, `setState()`를 호출하고 `_highlight` 상태가 변경됩니다.
* 탭 이벤트에서, 해당 상태 변경을 부모 위젯에 전달하여, [`widget`][] 속성을 사용하여 적절한 작업을 수행합니다.

<?code-excerpt "lib/mixed.dart"?>
```dart
import 'package:flutter/material.dart';

//---------------------------- ParentWidget ----------------------------

class ParentWidget extends StatefulWidget {
  const ParentWidget({super.key});

  @override
  State<ParentWidget> createState() => _ParentWidgetState();
}

class _ParentWidgetState extends State<ParentWidget> {
  bool _active = false;

  void _handleTapboxChanged(bool newValue) {
    setState(() {
      _active = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TapboxC(
        active: _active,
        onChanged: _handleTapboxChanged,
      ),
    );
  }
}

//----------------------------- TapboxC ------------------------------

class TapboxC extends StatefulWidget {
  const TapboxC({
    super.key,
    this.active = false,
    required this.onChanged,
  });

  final bool active;
  final ValueChanged<bool> onChanged;

  @override
  State<TapboxC> createState() => _TapboxCState();
}

class _TapboxCState extends State<TapboxC> {
  bool _highlight = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _highlight = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _highlight = false;
    });
  }

  void _handleTapCancel() {
    setState(() {
      _highlight = false;
    });
  }

  void _handleTap() {
    widget.onChanged(!widget.active);
  }

  @override
  Widget build(BuildContext context) {
    // 이 예는 탭 다운 시 녹색 테두리를 추가합니다.
    // 탭 업 시, 사각형은 반대 상태로 변경됩니다.
    return GestureDetector(
      onTapDown: _handleTapDown, // 탭 이벤트는 발생하는 순서대로 처리합니다: 
      onTapUp: _handleTapUp, // down, up, tap, cancel
      onTap: _handleTap,
      onTapCancel: _handleTapCancel,
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: widget.active ? Colors.lightGreen[700] : Colors.grey[600],
          border: _highlight
              ? Border.all(
                  color: Colors.teal[700]!,
                  width: 10,
                )
              : null,
        ),
        child: Center(
          child: Text(widget.active ? 'Active' : 'Inactive',
              style: const TextStyle(fontSize: 32, color: Colors.white)),
        ),
      ),
    );
  }
}
```

대체 구현은 활성 상태를 내부에 유지하면서 하이라이트 상태를 부모에게 내보냈을 수 있지만, 
누군가에게 그 탭 상자를 사용하라고 요청하면, 아마도 별로 의미가 없다고 불평할 것입니다. 
개발자는 상자가 활성 상태인지 신경 씁니다. 
개발자는 아마도 하이라이트가 어떻게 관리되는지 신경 쓰지 않고, 
탭 상자가 그 세부 사항을 처리하는 것을 선호할 것입니다.

<hr>

## 기타 상호 작용 위젯 {:#other-interactive-widgets}

Flutter는 다양한 버튼과 유사한 상호 작용 위젯을 제공합니다. 
이러한 위젯 대부분은 의견이 있는(opinionated) UI로 구성 요소 집합을 정의하는, 
[Material Design 가이드라인][Material Design guidelines]을 구현합니다.

원하는 경우, [`GestureDetector`][]를 사용하여 모든 커스텀 위젯에 상호 작용 기능을 빌드할 수 있습니다. `GestureDetector`의 예는 [상태 관리][Managing state]에서 찾을 수 있습니다. 
`GestureDetector`에 대한 자세한 내용은 [Flutter 쿡북][Flutter cookbook]의 레시피인 [탭 처리][Handle taps]에서 알아보세요.

:::tip
Flutter는 또한 [`Cupertino`][]라는 iOS 스타일 위젯 세트를 제공합니다.
:::

상호 작용이 필요할 때는, 미리 제작된 위젯 중 하나를 사용하는 것이 가장 쉽습니다. 다음은 일부 리스트입니다.

### 표준 위젯 {:#standard-widgets}

* [`Form`][]
* [`FormField`][]

### Material 컴포넌트 {:#material-components}

* [`Checkbox`][]
* [`DropdownButton`][]
* [`TextButton`][]
* [`FloatingActionButton`][]
* [`IconButton`][]
* [`Radio`][]
* [`ElevatedButton`][]
* [`Slider`][]
* [`Switch`][]
* [`TextField`][]

## 리소스 {:#resources}

다음 리소스는 앱에 상호 작용 기능을 추가하는 데 도움이 될 수 있습니다.

[제스쳐][Gestures], [Flutter 쿡북][Flutter cookbook]의 섹션.

[제스처 처리][Handling gestures]
: 버튼을 만들고 입력에 응답하게 하는 방법.

[Flutter의 제스처][Gestures in Flutter]
: Flutter의 제스처 메커니즘에 대한 설명.

[Flutter API 문서][Flutter API documentation]
: 모든 Flutter 라이브러리에 대한 참조 문서.

Wonderous 앱 [실행 중인 앱][wonderous-app], [repo][wonderous-repo]
: 커스텀 디자인과 매력적인 상호 작용을 갖춘 Flutter 쇼케이스 앱.

[Flutter의 계층적 디자인][Flutter's Layered Design] (비디오)
: 이 비디오에는 state 및 stateless 위젯에 대한 정보가 포함되어 있습니다. 
Google 엔지니어 Ian Hickson이 발표합니다.

[Android emulator]: /get-started/install/windows/mobile?tab=virtual#configure-your-target-android-device
[`Checkbox`]: {{site.api}}/flutter/material/Checkbox-class.html
[`Cupertino`]: {{site.api}}/flutter/cupertino/cupertino-library.html
[Dart language documentation]: {{site.dart-site}}/language
[Debugging Flutter apps]: /testing/debugging
[`DropdownButton`]: {{site.api}}/flutter/material/DropdownButton-class.html
[`TextButton`]: {{site.api}}/flutter/material/TextButton-class.html
[`FloatingActionButton`]: {{site.api}}/flutter/material/FloatingActionButton-class.html
[Flutter API documentation]: {{site.api}}
[Flutter cookbook]: /cookbook
[Flutter's Layered Design]: {{site.yt.watch}}?v=dkyY9WCGMi0
[`FormField`]: {{site.api}}/flutter/widgets/FormField-class.html
[`Form`]: {{site.api}}/flutter/widgets/Form-class.html
[`GestureDetector`]: {{site.api}}/flutter/widgets/GestureDetector-class.html
[Gestures]: /cookbook/gestures
[Gestures in Flutter]: /ui/interactivity/gestures
[Handling gestures]: /ui#handling-gestures
[new-flutter-app]: /get-started/test-drive
[`IconButton`]: {{site.api}}/flutter/material/IconButton-class.html
[`Icon`]: {{site.api}}/flutter/widgets/Icon-class.html
[`InkWell`]: {{site.api}}/flutter/material/InkWell-class.html
[iOS simulator]: /get-started/install/macos/mobile-ios#configure-your-target-ios-device
[building layouts tutorial]: /ui/layout/tutorial
[community]: {{site.main-url}}/community
[Handle taps]: /cookbook/gestures/handling-taps
[`lake.jpg`]: {{examples}}/layout/lakes/step6/images/lake.jpg
[Libraries and imports]: {{site.dart-site}}/language/libraries
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
[`main.dart`]: {{examples}}/layout/lakes/step6/lib/main.dart
[Managing state]: #managing-state
[Material Design guidelines]: {{site.material}}/styles
[`pubspec.yaml`]: {{examples}}/layout/lakes/step6/pubspec.yaml
[`Radio`]: {{site.api}}/flutter/material/Radio-class.html
[`ElevatedButton`]: {{site.api}}/flutter/material/ElevatedButton-class.html
[wonderous-app]: {{site.wonderous}}/web
[wonderous-repo]: {{site.repo.wonderous}}
[set up]: /get-started/install
[`SizedBox`]: {{site.api}}/flutter/widgets/SizedBox-class.html
[`Slider`]: {{site.api}}/flutter/material/Slider-class.html
[`State`]: {{site.api}}/flutter/widgets/State-class.html
[`StatefulWidget`]: {{site.api}}/flutter/widgets/StatefulWidget-class.html
[`StatelessWidget`]: {{site.api}}/flutter/widgets/StatelessWidget-class.html
[`Switch`]: {{site.api}}/flutter/material/Switch-class.html
[`TextField`]: {{site.api}}/flutter/material/TextField-class.html
[`Text`]: {{site.api}}/flutter/widgets/Text-class.html
[`widget`]: {{site.api}}/flutter/widgets/State/widget.html
