---
# title: Simple app state management
title: 간단한 앱 상태 관리
# description: A simple form of state management.
description: 간단한 형태의 상태 관리.
prev:
  # title: Ephemeral versus app state
  title: 일시적(ephemeral) 상태 vs 앱 상태
  path: /development/data-and-backend/state-mgmt/ephemeral-vs-app
next:
  # title: List of approaches
  title: 접근법 리스트
  path: /development/data-and-backend/state-mgmt/options
---

<?code-excerpt path-base="state_mgmt/simple/"?>

이제 [선언적 UI 프로그래밍][declarative UI programming]과 [일시적 상태 및 앱 상태][ephemeral and app state]의 차이점에 대해 알았으니, 간단한 앱 상태 관리에 대해 알아볼 준비가 되었습니다.

이 페이지에서는, `provider` 패키지를 사용할 것입니다. 
Flutter를 처음 사용하고 다른 접근 방식(Redux, Rx, hooks 등)을 선택할 만한 강력한 이유가 없다면, 
이 접근 방식부터 시작해야 할 것입니다. 
`provider` 패키지는 이해하기 쉽고 코드를 많이 사용하지 않습니다. 
또한 다른 모든 접근 방식에 적용할 수 있는 개념을 사용합니다.

즉, 다른 reactive 프레임워크에서 상태 관리에 대한 강력한 배경이 있다면, 
[옵션 페이지][options page]에 나열된 패키지와 튜토리얼을 찾을 수 있습니다.

## 우리의 예제 {:#our-example}

<img src='/assets/images/docs/development/data-and-backend/state-mgmt/model-shopper-screencast.gif' alt='An animated gif showing a Flutter app in use. It starts with the user on a login screen. They log in and are taken to the catalog screen, with a list of items. The click on several items, and as they do so, the items are marked as "added". The user clicks on a button and gets taken to the cart view. They see the items there. They go back to the catalog, and the items they bought still show "added". End of animation.' class='site-image-right'>

예를 들어, 다음의 간단한 앱을 생각해 보세요.

앱에는 카탈로그와 카트(각각 `MyCatalog` 및 `MyCart` 위젯으로 표현됨)라는 두 개의 별도 화면이 있습니다. 
쇼핑 앱일 수도 있지만, 간단한 소셜 네트워킹 앱에서도 동일한 구조를 상상할 수 있습니다.
(카탈로그를 "wall"로, 카트를 "favorites"로 대체)

카탈로그 화면에는 커스텀 앱 바(`MyAppBar`)와 여러 리스트 아이템의 스크롤 뷰(`MyListItems`)가 포함되어 있습니다.

위젯 트리로 시각화된 앱은 다음과 같습니다.

<img src='/assets/images/docs/development/data-and-backend/state-mgmt/simple-widget-tree.png' width="100%" alt="A widget tree with MyApp at the top, and  MyCatalog and MyCart below it. MyCart area leaf nodes, but MyCatalog have two children: MyAppBar and a list of MyListItems.">

{% comment %}
  Source drawing for the png above: https://docs.google.com/drawings/d/1KXxAl_Ctxc-avhR4uE58BXBM6Tyhy0pQMCsSMFHVL_0/edit?zx=y4m1lzbhsrvx
{% endcomment %}

따라서 `Widget`의 하위 클래스가 최소 5개 있습니다. 
그 중 다수는 다른 곳에 "속하는" 상태에 대한 액세스가 필요합니다. 
예를 들어, 각 `MyListItem`은 카트에 자신을 추가할 수 있어야 합니다. 
또한 현재 표시된 아이템이 이미 카트에 있는지 확인하고 싶을 수도 있습니다.

여기서 첫 번째 질문으로 넘어갑니다. 카트의 현재 상태를 어디에 두어야 할까요?

## 상태 들어올리기 {:#lifting-state-up}

Flutter에서는, 상태를 사용하는 위젯 위에 두는 것이 합리적입니다.

왜? Flutter와 같은 선언적 프레임워크에서, UI를 변경하려면, 다시 빌드해야 합니다. 
`MyCart.updateWith(somethingNew)`를 갖는 쉬운 방법은 없습니다. 
즉, 외부에서 위젯을 강제로 변경하기는 어렵고, 메서드를 호출하여 변경하는 것도 어렵습니다. 
그리고 이것을 작동시킬 수 있다 하더라도, 프레임워크가 여러분을 돕게 하는 대신, 프레임워크와 싸우게 될 것입니다.

```dart
// 나쁨: 이렇게 하지 마세요
void myTapHandler() {
  var cartWidget = somehowGetMyCartWidget();
  cartWidget.updateWith(item);
}
```

위의 코드를 작동시키더라도, `MyCart` 위젯에서 다음 문제를 처리해야 합니다.

```dart
// 나쁨: 이렇게 하지 마세요
Widget build(BuildContext context) {
  return SomeWidget(
    // 카트의 초기 상태.
  );
}

void updateWith(Item item) {
  // 어떻게든 여기에서 UI를 바꿔야 할 필요가 있습니다.
}
```

UI의 현재 상태를 고려하고 새 데이터를 적용해야 합니다. 이런 식으로는 버그를 피하기 어렵습니다.

Flutter에서는, 내용이 변경될 때마다 새 위젯을 구성합니다. 
`MyCart.updateWith(somethingNew)`(메서드 호출) 대신 `MyCart(contents)`(생성자)를 사용합니다. 
부모의 빌드 메서드에서만 새 위젯을 구성할 수 있으므로, `contents`를 변경하려면, `MyCart`의 부모나 그 이상에 있어야 합니다.

<?code-excerpt "lib/src/provider.dart (my-tap-handler)"?>
```dart
// 좋음
void myTapHandler(BuildContext context) {
  var cartModel = somehowGetMyCartModel(context);
  cartModel.add(item);
}
```

이제 `MyCart`에는 모든 버전의 UI를 빌드하기 위한 코드 경로가 하나뿐입니다.

<?code-excerpt "lib/src/provider.dart (build)"?>
```dart
// 좋음
Widget build(BuildContext context) {
  var cartModel = somehowGetMyCartModel(context);
  return SomeWidget(
    // 카트의 현재 상태를 사용하여, UI를 한 번만 구성하면 됩니다.
    // ···
  );
}
```

우리의 예에서, `contents`는 `MyApp`에 있어야 합니다. 
변경될 때마다, 위에서 `MyCart`를 다시 빌드합니다. (나중에 자세히 설명) 
이 때문에, `MyCart`는 라이프사이클에 대해 걱정할 필요가 없습니다. - 주어진 `contents`에 대해 무엇을 보여줄지 선언하기만 하면 됩니다. 
변경되면, 이전 `MyCart` 위젯이 사라지고, 새 위젯으로 완전히 대체됩니다.

<img src='/assets/images/docs/development/data-and-backend/state-mgmt/simple-widget-tree-with-cart.png' width="100%" alt="Same widget tree as above, but now we show a small 'cart' badge next to MyApp, and there are two arrows here. One comes from one of the MyListItems to the 'cart', and another one goes from the 'cart' to the MyCart widget.">

{% comment %}
  Source drawing for the png above: https://docs.google.com/drawings/d/1ErMyaX4fwfbIW9ABuPAlHELLGMsU6cdxPDFz_elsS9k/edit?zx=j42inp8903pt
{% endcomment %}

위젯이 불변(immutable)이라고 말할 때, 우리가 의미하는 바는 바로 이것입니다. 위젯은 변하지 않고 대체됩니다.

이제 카트 상태를 어디에 두어야 할지 알았으니, 액세스하는 방법을 살펴보겠습니다.

## 상태에 접근하기 {:#accessing-the-state}

사용자가 카탈로그의 아이템 중 하나를 클릭하면, 카트에 추가됩니다. 
하지만, 카트가 `MyListItem` 위에 있으므로 어떻게 해야 할까요?

간단한 옵션은 `MyListItem`이 클릭될 때, 호출할 수 있는 콜백을 제공하는 것입니다. 
Dart의 함수는 일급 객체이므로, 원하는 대로 전달할 수 있습니다. 
따라서, `MyCatalog` 내부에서 다음을 정의할 수 있습니다.

<?code-excerpt "lib/src/passing_callbacks.dart (methods)"?>
```dart
@override
Widget build(BuildContext context) {
  return SomeWidget(
    // 위 메서드에 대한 참조를 전달하여, 위젯을 구성합니다.
    MyListItem(myTapCallback),
  );
}

void myTapCallback(Item item) {
  print('user tapped on $item');
}
```

이 방법은 잘 작동하지만, 여러 다른 위치에서 수정해야 하는 앱 상태의 경우, 
많은 콜백을 전달해야 하며, 이는 금세 오래됩니다. (which gets old pretty quickly.)

다행히도, Flutter에는 위젯이 하위 위젯(즉, 단순히 자식만이 아닌, 그 밑의 어떤 하위 위젯이라도)에 데이터와 서비스를 제공하는 메커니즘이 있습니다. 
_모든 것이 위젯™_ 인 Flutter에서 예상했듯이, 이러한 메커니즘은 특별한 종류의 위젯(`InheritedWidget`, `InheritedNotifier`, `InheritedModel` 등)일 뿐입니다. 
여기서는 다루지 않을 것입니다. 우리가 하려는 일에 비해 낮은 레벨이기 때문입니다.

대신, 낮은 레벨 위젯과 함께 작동하지만, 사용하기 쉬운 패키지를 사용할 것입니다. `provider`라고 합니다.

`provider`를 사용하기 전에, `pubspec.yaml`에 종속성을 추가하는 것을 잊지 마세요.

`provider` 패키지를 종속성으로 추가하려면, `flutter pub add`를 실행하세요.

```console
$ flutter pub add provider
```

이제 `import 'package:provider/provider.dart';`를 사용하여 빌드를 시작할 수 있습니다.

`provider`를 사용하면, 콜백이나 `InheritedWidgets`에 대해 걱정할 필요가 없습니다. 하지만 3가지 개념을 이해해야 합니다.

* ChangeNotifier
* ChangeNotifierProvider
* Consumer

## ChangeNotifier {:#changenotifier}

`ChangeNotifier`는 리스너에 변경 알림을 제공하는 Flutter SDK에 포함된 간단한 클래스입니다. 
즉, 무언가가 `ChangeNotifier`인 경우, 해당 변경 사항을 구독할 수 있습니다. 
(이 용어에 익숙한 사람들을 위해 설명하자면, Observable의 한 형태입니다.)

`provider`에서, `ChangeNotifier`는 애플리케이션 상태를 캡슐화하는 한 가지 방법입니다. 
매우 간단한 앱의 경우, 단일 `ChangeNotifier`로 충분합니다. 
복잡한 앱의 경우, 여러 모델이 있으므로, 여러 `ChangeNotifier`가 있습니다. 
(`ChangeNotifier`를 `provider`와 함께 사용할 필요는 없지만, 사용하기 쉬운 클래스입니다.)

우리의 쇼핑 앱 예제에서, `ChangeNotifier`에서 카트 상태를 관리하려고 합니다. 
다음과 같이 이를 확장하는 새 클래스를 만듭니다.

<?code-excerpt "lib/src/provider.dart (model)" replace="/ChangeNotifier/[!$&!]/g;/notifyListeners/[!$&!]/g"?>
```dart
class CartModel extends [!ChangeNotifier!] {
  /// 카트의 internal, private 상태입니다.
  final List<Item> _items = [];

  /// 카트에 있는 아이템의 변경 불가능한(unmodifiable) 뷰입니다.
  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  /// 모든 품목의 현재 총 가격입니다. (모든 품목의 가격이 $42라고 가정)
  int get totalPrice => _items.length * 42;

  /// 카트에 [item]을 추가합니다. 
  /// 이것과 [removeAll]은 외부에서 카트를 수정하는 유일한 방법입니다.
  void add(Item item) {
    _items.add(item);
    // 이 호출은, 이 모델을 수신하고 있는 위젯에, 다시 빌드하라고 알려줍니다.
    [!notifyListeners!]();
  }

  /// 카트에서 모든 항목을 제거합니다.
  void removeAll() {
    _items.clear();
    // 이 호출은 이 모델을 수신하고 있는 위젯에 다시 빌드하라고 알려줍니다.
    [!notifyListeners!]();
  }
}
```

`ChangeNotifier`에 특정한 유일한 코드는 `notifyListeners()`에 대한 호출입니다. 
앱의 UI를 변경할 수 있는 방식으로, 모델이 변경될 때마다 이 메서드를 호출합니다. 
`CartModel`의 다른 모든 것은 모델 자체와 비즈니스 로직입니다.

`ChangeNotifier`는 `flutter:foundation`의 일부이며, Flutter의 더 높은 레벨 클래스에 의존하지 않습니다. 
쉽게 테스트할 수 있습니다. ([위젯 테스트][widget testing]를 사용할 필요조차 없습니다)
예를 들어, `CartModel`의 간단한 유닛 테스트는 다음과 같습니다.

<?code-excerpt "test/model_test.dart (test)"?>
```dart
test('adding item increases total cost', () {
  final cart = CartModel();
  final startingPrice = cart.totalPrice;
  var i = 0;
  cart.addListener(() {
    expect(cart.totalPrice, greaterThan(startingPrice));
    i++;
  });
  cart.add(Item('Dash'));
  expect(i, 1);
});
```

## ChangeNotifierProvider {:#changenotifierprovider}

`ChangeNotifierProvider`는 `ChangeNotifier`의 인스턴스를 하위 위젯에 제공하는 위젯입니다. 
`provider` 패키지에서 제공됩니다.

우리는 `ChangeNotifierProvider`를 어디에 두어야 할지 이미 알고 있습니다. 액세스해야 하는 위젯 위에 두는 것입니다. 
`CartModel`의 경우, `MyCart`와 `MyCatalog` 둘 다 위 어딘가를 의미합니다.

`ChangeNotifierProvider`를 필요 이상으로 위에 두지 않아야 합니다. (범위를 오염시키고 싶지 않기 때문입니다) 
하지만, 우리의 경우 `MyCart`와 `MyCatalog` 둘 다 위에 있는 유일한 위젯은 `MyApp`입니다.

<?code-excerpt "lib/main.dart (main)" replace="/ChangeNotifierProvider/[!$&!]/g"?>
```dart
void main() {
  runApp(
    [!ChangeNotifierProvider!](
      create: (context) => CartModel(),
      child: const MyApp(),
    ),
  );
}
```

`CartModel`의 새 인스턴스를 만드는 빌더를 정의하고 있다는 점에 유의하세요. 
`ChangeNotifierProvider`는 절대적으로 필요하지 않는 한, `CartModel`을 다시 빌드하지 _않을 만큼_ 똑똑합니다. 
또한 인스턴스가 더 이상 필요하지 않으면, `CartModel`에서 `dispose()`를 자동으로 호출합니다.

두 개 이상의 클래스를 제공하려면, `MultiProvider`를 사용할 수 있습니다.

<?code-excerpt "lib/main.dart (multi-provider-main)" replace="/multiProviderMain/main/g;/MultiProvider/[!$&!]/g"?>
```dart
void main() {
  runApp(
    [!MultiProvider!](
      providers: [
        ChangeNotifierProvider(create: (context) => CartModel()),
        Provider(create: (context) => SomeOtherClass()),
      ],
      child: const MyApp(),
    ),
  );
}
```

## Consumer {:#consumer}

이제 `CartModel`이 상단의 `ChangeNotifierProvider` 선언을 통해 앱의 위젯에 제공되므로, 사용을 시작할 수 있습니다.

이는 `Consumer` 위젯을 통해 수행됩니다.

<?code-excerpt "lib/src/provider.dart (descendant)" replace="/Consumer/[!$&!]/g"?>
```dart
return [!Consumer!]<CartModel>(
  builder: (context, cart, child) {
    return Text('Total price: ${cart.totalPrice}');
  },
);
```

액세스하려는 모델의 타입을 지정해야 합니다. 
이 경우, `CartModel`을 원하므로, `Consumer<CartModel>`을 작성합니다. 
제네릭(`<CartModel>`)을 지정하지 않으면, `provider` 패키지에서 도움을 받을 수 없습니다. 
`provider`는 타입에 기반하며, 타입이 없으면 원하는 것을 알 수 없습니다.

`Consumer` 위젯의 유일한 필수 인수는 빌더입니다. 
빌더는 `ChangeNotifier`가 변경될 때마다 호출되는 함수입니다. 
(즉, 모델에서 `notifyListeners()`를 호출하면, 해당 `Consumer` 위젯의 모든 빌더 메서드가 호출됩니다.)

빌더는 세 개의 인수로 호출됩니다. 

1. 첫 번째는 `context`로, 
   * 모든 빌드 메서드에서도 가져옵니다.

2. 빌더 함수의 두 번째 인수는 `ChangeNotifier`의 인스턴스입니다. 
   * 처음에 요청했던 것입니다. (asking for in the first place.)
   * 모델의 데이터를 사용하여, UI가 주어진 지점에서 어떻게 보여야 하는지 정의할 수 있습니다.

3. 세 번째 인수는 최적화를 위해 있는 `child`입니다. 
   * 모델이 변경될 때, _변경되지 않는_ `Consumer` 아래에 큰 위젯 하위 트리가 있는 경우, 
     한 번 구성하여 빌더를 통해 가져올 수 있습니다.

<?code-excerpt "lib/src/performance.dart (child)" replace="/\bchild\b/[!$&!]/g"?>
```dart
return Consumer<CartModel>(
  builder: (context, cart, [!child!]) => Stack(
    children: [
      // 매번 다시 빌드하지 않고도, SomeExpensiveWidget을 사용할 수 있습니다.
      if ([!child!] != null) [!child!],
      Text('Total price: ${cart.totalPrice}'),
    ],
  ),
  // 여기서 값비싼 위젯을 만들어 보세요.
  [!child!]: const SomeExpensiveWidget(),
);
```

`Consumer` 위젯을 가능한 한 트리의 깊은 곳에 두는 것이 가장 좋습니다. 
어딘가의 세부 사항이 변경되었다고 해서, UI의 큰 부분을 다시 빌드하고 싶지는 않을 것입니다.

<?code-excerpt "lib/src/performance.dart (non-leaf-descendant)"?>
```dart
// 이렇게 하지 마세요.
return Consumer<CartModel>(
  builder: (context, cart, child) {
    return HumongousWidget(
      // ...
      child: AnotherMonstrousWidget(
        // ...
        child: Text('Total price: ${cart.totalPrice}'),
      ),
    );
  },
);
```

대신에:

<?code-excerpt "lib/src/performance.dart (leaf-descendant)"?>
```dart
// 이렇게 하세요
return HumongousWidget(
  // ...
  child: AnotherMonstrousWidget(
    // ...
    child: Consumer<CartModel>(
      builder: (context, cart, child) {
        return Text('Total price: ${cart.totalPrice}');
      },
    ),
  ),
);
```

### Provider.of {:#provider-of}

때로는, UI를 변경하기 위해 모델의 _데이터_ 가 실제로 필요하지 않지만, 여전히 액세스해야 합니다. 
예를 들어, `ClearCart` 버튼은 사용자가 카트에서 모든 것을 제거할 수 있도록 허용하려고 합니다. 
카트의 내용을 표시할 필요는 없으며, `clear()` 메서드만 호출하면 됩니다.

이를 위해 `Consumer<CartModel>`을 사용할 수 있지만, 낭비일 것입니다. 
다시 빌드할 필요가 없는 위젯을 다시 빌드하도록 프레임워크에 요청하게 됩니다.

이 사용 사례의 경우, `Provider.of`를 사용할 수 있으며, `listen` 매개변수는 `false`로 설정됩니다.

<?code-excerpt "lib/src/performance.dart (non-rebuilding)" replace="/listen: false/[!$&!]/g"?>
```dart
Provider.of<CartModel>(context, [!listen: false!]).removeAll();
```

빌드 메서드에서 위 줄을 사용하면, `notifyListeners`가 호출될 때 위젯이 다시 빌드되지 않습니다.

## 모두 합치기 {:#putting-it-all-together}

이 글에서 다룬 [예제를 확인][check out the example]할 수 있습니다.
더 간단한 것을 원하시면, [`provider`로 빌드][built with `provider`]했을 때 간단한 Counter 앱이 어떻게 보이는지 확인하세요.

이 글을 따라하면, 상태 기반 애플리케이션을 만드는 능력이 크게 향상됩니다. 
`provider`로 애플리케이션을 직접 빌드하여, 이러한 기술을 마스터해 보세요.

[built with `provider`]: {{site.repo.samples}}/tree/main/provider_counter
[check out the example]: {{site.repo.samples}}/tree/main/provider_shopper
[declarative UI programming]: /data-and-backend/state-mgmt/declarative
[ephemeral and app state]: /data-and-backend/state-mgmt/ephemeral-vs-app
[options page]: /data-and-backend/state-mgmt/options
[widget testing]: /testing/overview#widget-tests
