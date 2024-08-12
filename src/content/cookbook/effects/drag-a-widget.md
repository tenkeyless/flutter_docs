---
# title: Drag a UI element
title: UI 요소 드래그
# description: How to implement a draggable UI element.
description: 드래그 가능한 UI 요소를 구현하는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/effects/drag_a_widget"?>

드래그 앤 드롭은 일반적인 모바일 앱 상호작용입니다. 
사용자가 위젯을 길게 누르면(때로는 _터치 & 홀드_ 라고도 함), 다른 위젯이 사용자 손가락 아래에 나타나고, 
사용자는 위젯을 마지막 위치로 끌어서 놓습니다. 
이 레시피에서는, 사용자가 음식 선택 항목을 길게 누른 다음, 
해당 음식을 지불하는 고객의 사진으로 끌어서 놓는 드래그 앤 드롭 상호작용을 빌드합니다.

다음 애니메이션은 앱의 동작을 보여줍니다.

![Ordering the food by dragging it to the person](/assets/images/docs/cookbook/effects/DragAUIElement.gif){:.site-mobile-screenshot}

이 레시피는 미리 작성된 메뉴 항목 목록과 고객 행으로 시작합니다. 
첫 번째 단계는 길게 누름을 인식하고, 메뉴 항목의 드래그 가능한 사진을 표시하는 것입니다.

## 누르고 드래그 {:#press-and-drag}

Flutter는 드래그 앤 드롭 상호작용을 시작하는 데 필요한 정확한 동작을 제공하는 
[`LongPressDraggable`][]이라는 위젯을 제공합니다. 
`LongPressDraggable` 위젯은 길게 누르는 경우를 인식한 다음, 사용자 손가락 근처에 새 위젯을 표시합니다. 
사용자가 드래그하면, 위젯이 사용자 손가락을 따릅니다. 
`LongPressDraggable`은 사용자가 드래그하는 위젯을 완벽하게 제어할 수 있게 해줍니다.

각 메뉴 목록 항목은 커스텀 `MenuListItem` 위젯과 함께 표시됩니다.

<?code-excerpt "lib/main.dart (MenuListItem)" replace="/^child: //g;/^\),$/)/g"?>
```dart
MenuListItem(
  name: item.name,
  price: item.formattedTotalItemPrice,
  photoProvider: item.imageProvider,
)
```

`MenuListItem` 위젯을 `LongPressDraggable` 위젯으로 감싸세요.

<?code-excerpt "lib/main.dart (LongPressDraggable)" replace="/^return //g;/^\),$/)/g"?>
```dart
LongPressDraggable<Item>(
  data: item,
  dragAnchorStrategy: pointerDragAnchorStrategy,
  feedback: DraggingListItem(
    dragKey: _draggableKey,
    photoProvider: item.imageProvider,
  ),
  child: MenuListItem(
    name: item.name,
    price: item.formattedTotalItemPrice,
    photoProvider: item.imageProvider,
  ),
);
```

이 경우, 사용자가 `MenuListItem` 위젯을 길게 누르면, 
`LongPressDraggable` 위젯이 `DraggingListItem`을 표시합니다. 
이 `DraggingListItem`은 사용자의 손가락 아래 중앙에, 선택한 음식 항목의 사진을 표시합니다.

`dragAnchorStrategy` 속성은 [`pointerDragAnchorStrategy`][]로 설정됩니다. 
이 속성 값은 `LongPressDraggable`이 `DraggableListItem`의 위치를 ​​사용자의 손가락에 기반하도록 지시합니다. 
사용자가 손가락을 움직이면, `DraggableListItem`도 함께 움직입니다.

항목을 놓을 때 정보가 전송되지 않으면 끌어서 놓는 것은 별로 소용이 없습니다. 
이러한 이유로, `LongPressDraggable`은 `data` 매개변수를 사용합니다. 
이 경우, `data`의 유형은 `Item`이며, 이는 사용자가 누른 음식 메뉴 항목에 대한 정보를 보유합니다.

`LongPressDraggable`과 연관된 `data`는 `DragTarget`이라는 특수 위젯으로 전송되고, 
여기서 사용자는 드래그 제스처를 해제합니다. 다음에 드롭 동작을 구현합니다.

## 드래그 가능한 것을 드롭 {:#drop-the-draggable}

사용자는 `LongPressDraggable`을 원하는 곳에 놓을 수 있지만, 
`DragTarget` 위에 놓지 않는 한 드래그 가능한 항목을 놓아도 효과가 없습니다. 
사용자가 `DragTarget` 위젯 위에 드래그 가능한 항목을 놓으면,
`DragTarget` 위젯은 드래그 가능한 항목의 데이터를 수락하거나 거부할 수 있습니다.

이 레시피에서, 사용자는 `CustomerCart` 위젯에 메뉴 항목을 드롭해서, 메뉴 항목을 사용자의 카트에 추가해야 합니다.

<?code-excerpt "lib/main.dart (CustomerCart)" replace="/^return //g;/^\),$/)/g"?>
```dart
CustomerCart(
  hasItems: customer.items.isNotEmpty,
  highlighted: candidateItems.isNotEmpty,
  customer: customer,
);
```

`CustomerCart` 위젯을 `DragTarget` 위젯으로 감싸세요.

<?code-excerpt "lib/main.dart (DragTarget)" replace="/^child: //g;/^\),$/)/g"?>
```dart
DragTarget<Item>(
  builder: (context, candidateItems, rejectedItems) {
    return CustomerCart(
      hasItems: customer.items.isNotEmpty,
      highlighted: candidateItems.isNotEmpty,
      customer: customer,
    );
  },
  onAcceptWithDetails: (details) {
    _itemDroppedOnCustomerCart(
      item: details.data,
      customer: customer,
    );
  },
)
```

`DragTarget`은 기존 위젯을 표시하고, `LongPressDraggable`과 조정(coordinates)하여, 
사용자가 `DragTarget` 위로 드래그 가능한 항목을 드래그할 때를 인식합니다. 
`DragTarget`은 또한 사용자가 `DragTarget` 위젯 위로 드래그 가능한 항목을 드롭할 때를 인식합니다.

사용자가 `DragTarget` 위젯 위로 드래그 가능한 항목을 드래그하면, 
`candidateItems`에는 사용자가 드래그하는 데이터 항목이 포함됩니다. 
이 드래그 가능한 항목을 사용하면 사용자가 위젯 위로 드래그할 때 위젯의 모양을 변경할 수 있습니다. 
이 경우, `Customer` 위젯은 `DragTarget` 위젯 위로 항목을 드래그할 때마다 빨간색으로 바뀝니다. 
빨간색 시각적 모양은 `CustomerCart` 위젯 내의 `highlighted` 속성으로 구성됩니다.

사용자가 `DragTarget` 위젯 위로 드래그 가능한 항목을 드롭하면, `onAcceptWithDetails` 콜백이 호출됩니다. 
이때 드롭된 데이터를 수락할지 여부를 결정하게 됩니다. 이 경우, 항목은 항상 수락되고 처리됩니다. 
들어오는 항목을 검사하여 다른 결정을 내릴 수 있습니다.

`DragTarget`에 드롭된 항목의 유형은 `LongPressDraggable`에서 드래그된 항목의 유형과 일치해야 합니다. 
유형이 호환되지 않으면, `onAcceptWithDetails` 메서드가 호출되지 않습니다.

원하는 데이터를 수락하도록 구성된 `DragTarget` 위젯을 사용하면, 
이제 드래그 앤 드롭을 통해 UI의 한 부분에서 다른 부분으로 데이터를 전송할 수 있습니다.

다음 단계에서는, 드롭된 메뉴 항목으로 고객의 카트를 업데이트합니다.

## 장바구니에 메뉴 항목 추가 {:#add-a-menu-item-to-a-cart}

각 고객은 장바구니와 가격 총액을 관리하는, `Customer` 객체로 표현됩니다.

<?code-excerpt "lib/main.dart (CustomerClass)"?>
```dart
class Customer {
  Customer({
    required this.name,
    required this.imageProvider,
    List<Item>? items,
  }) : items = items ?? [];

  final String name;
  final ImageProvider imageProvider;
  final List<Item> items;

  String get formattedTotalItemPrice {
    final totalPriceCents =
        items.fold<int>(0, (prev, item) => prev + item.totalPriceCents);
    return '\$${(totalPriceCents / 100.0).toStringAsFixed(2)}';
  }
}
```

`CustomerCart` 위젯은 `Customer` 인스턴스를 기반으로 고객의 사진, 이름, 총계 및 품목 수를 표시합니다.

메뉴 항목이 드롭될 때 고객의 카트를 업데이트하려면, 드롭된 품목을 연관된 `Customer` 객체에 추가합니다.

<?code-excerpt "lib/main.dart (AddCart)"?>
```dart
void _itemDroppedOnCustomerCart({
  required Item item,
  required Customer customer,
}) {
  setState(() {
    customer.items.add(item);
  });
}
```

`_itemDroppedOnCustomerCart` 메서드는 사용자가 `CustomerCart` 위젯에 메뉴 항목을 드롭할 때,
`onAcceptWithDetails()`에서 호출됩니다. 
드롭된 항목을 `customer` 객체에 추가하고, `setState()`를 호출하여 레이아웃을 업데이트하면, 
UI가 새 고객의 가격 총계와 항목 수로 새로 고쳐집니다.

축하합니다! 고객의 쇼핑 카트에 음식 항목을 추가하는 드래그 앤 드롭 상호 작용이 있습니다.

## 대화형 예제 {:#interactive-example}

앱 실행:

* 음식 항목을 스크롤합니다.
* 손가락으로 하나를 누르고 있거나 마우스로 클릭하고 유지합니다.
* 누르고 있는 동안, 음식 항목의 이미지가 목록 위에 나타납니다.
* 이미지를 끌어서 화면 하단에 있는 사람 중 한 명에게 드롭합니다. 
  이미지 아래의 텍스트가 해당 사람의 요금을 반영하도록 업데이트됩니다. 
  계속해서 음식 항목을 추가하고 요금이 누적되는 것을 볼 수 있습니다.

<!-- Start DartPad -->

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter drag a widget hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: ExampleDragAndDrop(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

const List<Item> _items = [
  Item(
    name: 'Spinach Pizza',
    totalPriceCents: 1299,
    uid: '1',
    imageProvider: NetworkImage('https://docs.flutter.dev'
        '/cookbook/img-files/effects/split-check/Food1.jpg'),
  ),
  Item(
    name: 'Veggie Delight',
    totalPriceCents: 799,
    uid: '2',
    imageProvider: NetworkImage('https://docs.flutter.dev'
        '/cookbook/img-files/effects/split-check/Food2.jpg'),
  ),
  Item(
    name: 'Chicken Parmesan',
    totalPriceCents: 1499,
    uid: '3',
    imageProvider: NetworkImage('https://docs.flutter.dev'
        '/cookbook/img-files/effects/split-check/Food3.jpg'),
  ),
];

@immutable
class ExampleDragAndDrop extends StatefulWidget {
  const ExampleDragAndDrop({super.key});

  @override
  State<ExampleDragAndDrop> createState() => _ExampleDragAndDropState();
}

class _ExampleDragAndDropState extends State<ExampleDragAndDrop>
    with TickerProviderStateMixin {
  final List<Customer> _people = [
    Customer(
      name: 'Makayla',
      imageProvider: const NetworkImage('https://docs.flutter.dev'
          '/cookbook/img-files/effects/split-check/Avatar1.jpg'),
    ),
    Customer(
      name: 'Nathan',
      imageProvider: const NetworkImage('https://docs.flutter.dev'
          '/cookbook/img-files/effects/split-check/Avatar2.jpg'),
    ),
    Customer(
      name: 'Emilio',
      imageProvider: const NetworkImage('https://docs.flutter.dev'
          '/cookbook/img-files/effects/split-check/Avatar3.jpg'),
    ),
  ];

  final GlobalKey _draggableKey = GlobalKey();

  void _itemDroppedOnCustomerCart({
    required Item item,
    required Customer customer,
  }) {
    setState(() {
      customer.items.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: _buildAppBar(),
      body: _buildContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      iconTheme: const IconThemeData(color: Color(0xFFF64209)),
      title: Text(
        'Order Food',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 36,
              color: const Color(0xFFF64209),
              fontWeight: FontWeight.bold,
            ),
      ),
      backgroundColor: const Color(0xFFF7F7F7),
      elevation: 0,
    );
  }

  Widget _buildContent() {
    return Stack(
      children: [
        SafeArea(
          child: Column(
            children: [
              Expanded(
                child: _buildMenuList(),
              ),
              _buildPeopleRow(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _items.length,
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 12,
        );
      },
      itemBuilder: (context, index) {
        final item = _items[index];
        return _buildMenuItem(
          item: item,
        );
      },
    );
  }

  Widget _buildMenuItem({
    required Item item,
  }) {
    return LongPressDraggable<Item>(
      data: item,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: DraggingListItem(
        dragKey: _draggableKey,
        photoProvider: item.imageProvider,
      ),
      child: MenuListItem(
        name: item.name,
        price: item.formattedTotalItemPrice,
        photoProvider: item.imageProvider,
      ),
    );
  }

  Widget _buildPeopleRow() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 20,
      ),
      child: Row(
        children: _people.map(_buildPersonWithDropZone).toList(),
      ),
    );
  }

  Widget _buildPersonWithDropZone(Customer customer) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
        ),
        child: DragTarget<Item>(
          builder: (context, candidateItems, rejectedItems) {
            return CustomerCart(
              hasItems: customer.items.isNotEmpty,
              highlighted: candidateItems.isNotEmpty,
              customer: customer,
            );
          },
          onAcceptWithDetails: (details) {
            _itemDroppedOnCustomerCart(
              item: details.data,
              customer: customer,
            );
          },
        ),
      ),
    );
  }
}

class CustomerCart extends StatelessWidget {
  const CustomerCart({
    super.key,
    required this.customer,
    this.highlighted = false,
    this.hasItems = false,
  });

  final Customer customer;
  final bool highlighted;
  final bool hasItems;

  @override
  Widget build(BuildContext context) {
    final textColor = highlighted ? Colors.white : Colors.black;

    return Transform.scale(
      scale: highlighted ? 1.075 : 1.0,
      child: Material(
        elevation: highlighted ? 8 : 4,
        borderRadius: BorderRadius.circular(22),
        color: highlighted ? const Color(0xFFF64209) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: SizedBox(
                  width: 46,
                  height: 46,
                  child: Image(
                    image: customer.imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                customer.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: textColor,
                      fontWeight:
                          hasItems ? FontWeight.normal : FontWeight.bold,
                    ),
              ),
              Visibility(
                visible: hasItems,
                maintainState: true,
                maintainAnimation: true,
                maintainSize: true,
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      customer.formattedTotalItemPrice,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${customer.items.length} item${customer.items.length != 1 ? 's' : ''}',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: textColor,
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MenuListItem extends StatelessWidget {
  const MenuListItem({
    super.key,
    this.name = '',
    this.price = '',
    required this.photoProvider,
    this.isDepressed = false,
  });

  final String name;
  final String price;
  final ImageProvider photoProvider;
  final bool isDepressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 120,
                height: 120,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeInOut,
                    height: isDepressed ? 115 : 120,
                    width: isDepressed ? 115 : 120,
                    child: Image(
                      image: photoProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 30),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 18,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    price,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DraggingListItem extends StatelessWidget {
  const DraggingListItem({
    super.key,
    required this.dragKey,
    required this.photoProvider,
  });

  final GlobalKey dragKey;
  final ImageProvider photoProvider;

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: const Offset(-0.5, -0.5),
      child: ClipRRect(
        key: dragKey,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 150,
          width: 150,
          child: Opacity(
            opacity: 0.85,
            child: Image(
              image: photoProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class Item {
  const Item({
    required this.totalPriceCents,
    required this.name,
    required this.uid,
    required this.imageProvider,
  });
  final int totalPriceCents;
  final String name;
  final String uid;
  final ImageProvider imageProvider;
  String get formattedTotalItemPrice =>
      '\$${(totalPriceCents / 100.0).toStringAsFixed(2)}';
}

class Customer {
  Customer({
    required this.name,
    required this.imageProvider,
    List<Item>? items,
  }) : items = items ?? [];

  final String name;
  final ImageProvider imageProvider;
  final List<Item> items;

  String get formattedTotalItemPrice {
    final totalPriceCents =
        items.fold<int>(0, (prev, item) => prev + item.totalPriceCents);
    return '\$${(totalPriceCents / 100.0).toStringAsFixed(2)}';
  }
}
```

[`pointerDragAnchorStrategy`]: {{site.api}}/flutter/widgets/pointerDragAnchorStrategy.html
[`LongPressDraggable`]: {{site.api}}/flutter/widgets/LongPressDraggable-class.html
