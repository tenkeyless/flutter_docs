---
# title: List with spaced items
title: 간격을 둔 아이템들의 리스트
# description: How to create a list with spaced or expanded items 
description: 간격이 있거나 확장된 아이템들이 있는 리스트를 만드는 방법
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/lists/spaced_items/"?>

모든 리스트 아이템이 균일하게 간격을 두고, 배치되어 아이템이 보이는 공간을 차지하도록 리스트를 만들고 싶을 수 있습니다. 
예를 들어, 다음 이미지의 네 아이템은 균일하게 간격을 두고 배치되어 있으며, 
맨 위에 "Item 0"이 있고, 맨 아래에 "Item 3"이 있습니다.

![간격을 둔 아이템](/assets/images/docs/cookbook/spaced-items-1.png){:.site-mobile-screenshot}

동시에, 기기가 너무 작거나, 사용자가 창 크기를 조정하거나, 아이템 수가 화면 크기를 초과하는 경우와 같이, 
아이템 리스트가 맞지 않을 때 사용자가 리스트를 스크롤할 수 있도록 허용하고 싶을 수 있습니다.

![스크롤 가능한 아이템](/assets/images/docs/cookbook/spaced-items-2.png){:.site-mobile-screenshot}

일반적으로, [`Spacer`][]를 사용하여 위젯 간 간격을 조정하거나, 
[`Expanded`][]를 사용하여 위젯을 확장하여 사용 가능한 공간을 채웁니다. 
그러나, 이러한 솔루션은 스크롤 가능한 위젯 내부에서는 불가능합니다. 
스크롤 가능한 위젯에는 유한(finite) 높이 제약이 필요하기 때문입니다.

이 레시피는 다음의 단계를 사용하여, 
[`LayoutBuilder`][]와 [`ConstrainedBox`][]를 사용하여,
충분한 공간이 있을 때 리스트 아이템을 균등하게 분산하고, 
충분한 공간이 없을 때 사용자가 스크롤할 수 있도록 하는 방법을 보여줍니다.

  1. [`SingleChildScrollView`][]와 함께 [`LayoutBuilder`][]를 추가합니다.
  2. [`SingleChildScrollView`][] 내부에 [`ConstrainedBox`][]를 추가합니다.
  3. 간격을 둔 아이템으로 [`Column`][]을 만듭니다.

## 1. `SingleChildScrollView`를 사용하여 `LayoutBuilder` 추가 {:#1-add-a-layoutbuilder-with-a-singlechildscrollview}

[`LayoutBuilder`][]를 만드는 것으로 시작합니다. 두 개의 매개변수가 있는 `builder` 콜백 함수를 제공해야 합니다.

  1. [`LayoutBuilder`][]에서 제공하는 [`BuildContext`][].
  2. 부모 위젯의 [`BoxConstraints`][].

이 레시피에서는, [`BuildContext`][]를 사용하지 않지만, 다음 단계에서는 [`BoxConstraints`][]가 필요합니다.

`builder` 함수 내부에서, [`SingleChildScrollView`][]를 반환합니다. 
이 위젯은 부모 컨테이너가 너무 작더라도, 자식 위젯을 스크롤할 수 있도록 합니다.

<?code-excerpt "lib/spaced_list.dart (builder)"?>
```dart
LayoutBuilder(builder: (context, constraints) {
  return SingleChildScrollView(
    child: Placeholder(),
  );
});
```

## 2. `SingleChildScrollView` 내부에 `ConstrainedBox` 추가 {:#2-add-a-constrainedbox-inside-the-singlechildscrollview}

이 단계에서는, [`SingleChildScrollView`][]의 자식으로 [`ConstrainedBox`][]를 추가합니다.

[`ConstrainedBox`][] 위젯은 자식에 추가적인 제약 조건을 부과합니다.

`minHeight` 매개변수를 [`LayoutBuilder`][] 제약 조건의 `maxHeight`로 설정하여 제약 조건을 구성합니다.

이렇게 하면 자식 위젯이 [`LayoutBuilder`][] 제약 조건에서 제공하는 사용 가능한 공간과 동일한 최소 높이, 
즉 [`BoxConstraints`][]의 최대 높이로 제한됩니다.

<?code-excerpt "lib/spaced_list.dart (constrainedBox)"?>
```dart
LayoutBuilder(builder: (context, constraints) {
  return SingleChildScrollView(
    child: ConstrainedBox(
      constraints: BoxConstraints(minHeight: constraints.maxHeight),
      child: Placeholder(),
    ),
  );
});
```

하지만, 아이템이 화면에 맞지 않는 경우를 대비해, 
자식 아이템이 [`LayoutBuilder`][] 크기보다 커질 수 있도록 허용해야 하므로, `maxHeight` 매개변수를 설정하지 않습니다.

## 3. 간격이 있는 아이템으로 `Column` 만들기 {:#3-create-a-column-with-spaced-items}

마지막으로, [`ConstrainedBox`][]의 자식으로 [`Column`][]을 추가합니다.

아이템의 간격을 균등하게 하려면, `mainAxisAlignment`를 `MainAxisAlignment.spaceBetween`으로 설정합니다.

<?code-excerpt "lib/spaced_list.dart (column)"?>
```dart
LayoutBuilder(builder: (context, constraints) {
  return SingleChildScrollView(
    child: ConstrainedBox(
      constraints: BoxConstraints(minHeight: constraints.maxHeight),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ItemWidget(text: 'Item 1'),
          ItemWidget(text: 'Item 2'),
          ItemWidget(text: 'Item 3'),
        ],
      ),
    ),
  );
});
```

또는, [`Spacer`][] 위젯을 사용하여 아이템 간 간격을 조정하거나, 
한 위젯이 다른 위젯보다 더 많은 공간을 차지하도록 하려면, [`Expanded`][] 위젯을 사용할 수 있습니다.

그러려면, [`Column`][]을 [`IntrinsicHeight`][] 위젯으로 래핑해야 합니다. 
이렇게 하면, [`Column`][] 위젯이 무한대로 확장되는 대신, 최소 높이로 크기가 조정됩니다.

<?code-excerpt "lib/spaced_list.dart (intrinsic)"?>
```dart
LayoutBuilder(builder: (context, constraints) {
  return SingleChildScrollView(
    child: ConstrainedBox(
      constraints: BoxConstraints(minHeight: constraints.maxHeight),
      child: IntrinsicHeight(
        child: Column(
          children: [
            ItemWidget(text: 'Item 1'),
            Spacer(),
            ItemWidget(text: 'Item 2'),
            Expanded(
              child: ItemWidget(text: 'Item 3'),
            ),
          ],
        ),
      ),
    ),
  );
});
```

:::tip
다양한 기기를 사용해 앱이나 브라우저 창의 크기를 조절해보고, 
아이템 리스트가 사용 가능한 공간에 어떻게 조절되는지 살펴보세요.
:::

## 상호 작용 예제 {:#interactive-example}

이 예는 열 내에 균일하게 간격을 둔 아이템 리스트를 보여줍니다. 
아이템이 화면에 맞지 않을 때, 리스트를 위아래로 스크롤할 수 있습니다. 
아이템 수는 `items` 변수로 정의되며, 이 값을 변경하여 아이템이 화면에 맞지 않을 때 어떤 일이 발생하는지 확인하세요.

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter Spaced Items hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const SpacedItemsList());

class SpacedItemsList extends StatelessWidget {
  const SpacedItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    const items = 4;

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        cardTheme: CardTheme(color: Colors.blue.shade50),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(
                    items, (index) => ItemWidget(text: 'Item $index')),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 100,
        child: Center(child: Text(text)),
      ),
    );
  }
}
```

[`BoxConstraints`]: {{site.api}}/flutter/rendering/BoxConstraints-class.html
[`BuildContext`]: {{site.api}}/flutter/widgets/BuildContext-class.html
[`Column`]: {{site.api}}/flutter/widgets/Column-class.html
[`ConstrainedBox`]: {{site.api}}/flutter/widgets/ConstrainedBox-class.html
[`Expanded`]: {{site.api}}/flutter/widgets/Expanded-class.html
[`IntrinsicHeight`]: {{site.api}}/flutter/widgets/IntrinsicHeight-class.html
[`LayoutBuilder`]: {{site.api}}/flutter/widgets/LayoutBuilder-class.html
[`SingleChildScrollView`]: {{site.api}}/flutter/widgets/SingleChildScrollView-class.html
[`Spacer`]: {{site.api}}/flutter/widgets/Spacer-class.html
