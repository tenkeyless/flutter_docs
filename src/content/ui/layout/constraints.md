---
# title: Understanding constraints
title: 제약 조건 이해
# description: Flutter's model for widget constraints, sizing, positioning, and how they interact.
description: 위젯 제약 조건, 크기, 위치 및 상호작용 방식에 대한 Flutter 모델입니다.
toc: false
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="layout/constraints/"?>

<img src='/assets/images/docs/ui/layout/article-hero-image.png'
     class="mw-100" alt="Hero image from the article">

:::note
특정 레이아웃 오류가 발생하는 경우, [일반적인 Flutter 오류][Common Flutter errors]를 확인하세요.
:::

[Common Flutter errors]: /testing/common-errors

When someone learning Flutter asks you why some widget with `width: 100` isn't 100 pixels wide, the default answer is to tell them to put that widget inside of a `Center`, right?

Flutter를 배우는 사람이 `width: 100`인 어떤 위젯의 너비가 100 픽셀이 아닌 이유를 묻는다면, 
기본 대답은 그 위젯을 `Center` 안에 넣으라고 말하는 것이 맞나요?

**그렇게 하지 마세요.**

그렇게 하면, 그들은 계속해서 돌아와서, `FittedBox`가 왜 작동하지 않는지, 
`Column`이 왜 오버플로되는지, 
`IntrinsicWidth`가 무엇을 해야 하는지 물을 것입니다.

대신, 먼저 플러터 레이아웃은 HTML 레이아웃과 매우 다르다고 말하고, 
(아마도 그들이 그런 생각을 하는 이유일 겁니다) 다음 규칙을 암기하게 하세요.

<center><font size="+2">
<b>제약조건은 아래로 가고, 크기는 위로 갑니다. 부모가 위치를 설정합니다.</b>
</font></center>

이 규칙을 알지 못하면 Flutter 레이아웃을 제대로 이해할 수 없으므로, Flutter 개발자는 일찍부터 배워야 합니다.

더 자세히 설명하자면:

* 위젯은 **부모**로부터 자체 **제약 조건**을 가져옵니다. 
  * _제약 조건_ 은 최소 및 최대 너비와 최소 및 최대 높이의 4개 double의 세트일 뿐입니다.
* 그런 다음, 위젯은 자체 **자식** 리스트로 갑니다. 
  * 위젯은 자식에게 그들의 **제약 조건**이 무엇인지(자식마다 다를 수 있음) 하나씩 알려준 다음, 
    각 자식에게 원하는 크기를 묻습니다.
* 그런 다음, 위젯은 **자식(children)** 을 하나씩 배치합니다.
  (수평으로 `x` 축에, 수직으로 `y` 축에)
* 마지막으로, 위젯은 부모에게 자체 **크기**를 알려줍니다. (물론 원본 제약 조건 내에서)

예를 들어, 구성된 위젯에 패딩이 있는 column이 포함되어 있고, 
두 자식을 레이아웃하려는 경우는 다음과 같습니다:

<img src='/assets/images/docs/ui/layout/children.png' class="mw-100" alt="Visual layout">

협상은 다음과 같습니다.

**위젯**: "안녕하세요, 부모님, 제 제약 조건은 무엇인가요?"

**부모**: "너비는 `0`에서 `300`픽셀, 높이는 `0`에서 `85`픽셀이어야 한다."

**위젯**: "음, 저는 패딩을 `5`픽셀로 하고 싶으므로, 제 자식은 최대 너비가 `290`픽셀, 높이가 `75`픽셀이 될 수 있습니다."

**위젯**: "첫 번째 아이야, 너는 너비가 `0`에서 `290`픽셀, 높이는 `0`에서 `75`픽셀이어야 해."

**첫 번째 자식**: "좋아요, 그러면 저는 너비가 `290`픽셀, 높이가 `20`픽셀이 되기를 바랍니다."

**위젯**: "음, 난 두 번째 자식을 첫 번째 자식 아래에 두고 싶으므로, 두 번째 자식의 높이는 `55` 픽셀만 남아."

**위젯**: "두 번째 아이야, 너비가 `0`에서 `290` 사이, 키가 `0`에서 `55` 사이여야 해."

**두 번째 아이**: "좋아요, 저는 너비가 `140`픽셀, 키가 `30`픽셀이 되기를 바랍니다."

**위젯**: "알았다. 내 첫 번째 아이는 위치가 `x: 5`, `y: 5`이고, 두 번째 아이는 위치가 `x: 80`, `y: 25`이군."

**위젯**: "부모님, 제 사이즈는 너비가 `300`픽셀, 키가 `60`픽셀이 되기를 바랍니다."

## 한계 {:#limitations}

Flutter의 레이아웃 엔진은 원패스 프로세스로 설계되었습니다. 
즉, Flutter는 위젯을 매우 효율적으로 레이아웃하지만, 몇 가지 제한이 있습니다.

* 위젯은 부모가 지정한 제약 내에서만 자체 크기를 결정할 수 있습니다. 
  * 즉, 위젯은 일반적으로 **원하는 크기를 가질 수 없습니다**.

* 위젯은 위젯의 부모가 위젯의 위치를 ​​결정하기 때문에, 
  * **화면에서 자체 위치를 알 수 없고 결정하지 않습니다**.

* 부모의 크기와 위치는 차례로 자체 부모에도 따라 달라지므로, 
  * 트리 전체를 고려하지 않고는 위젯의 크기와 위치를 정확하게 정의할 수 없습니다.

* 자식이 부모와 다른 크기를 원하고 부모가 정렬할 정보가 충분하지 않으면, 자식의 크기가 무시될 수 있습니다. 
  * **정렬을 정의할 때는 구체적으로 지정하세요.**

Flutter에서, 위젯은 기본 [`RenderBox`][] 객체에 의해 렌더링됩니다. 
Flutter의 많은 상자, 특히 단일 자식만 취하는 상자는, 그들의 자식에게 제약 조건을 전달합니다.

일반적으로, 제약 조건을 처리하는 방식 측면에서, 세 가지 종류의 상자가 있습니다.

* 가능한 한 크게 만들려는 상자. 
  * 예를 들어, [`Center`][] 및 [`ListView`][]에서 사용하는 상자.
* 자식과 같은 크기가 되려는 상자. 
  * 예를 들어, [`Transform`][] 및 [`Opacity`][]에서 사용하는 상자.
* 특정 크기가 되려는 상자. 
  * 예를 들어, [`Image`][] 및 [`Text`][]에서 사용하는 상자.

[`Container`][]와 같은 일부 위젯은, 생성자 인수에 따라 타입마다 다릅니다. 
[`Container`][] 생성자는 가능한 한 크게 만들려고 기본적으로 하지만, 
예를 들어, `width`를 지정하면, 이를 존중하고 해당 특정 크기가 되려고 합니다.

예를 들어, [`Row`][] 및 [`Column`][] (flex 상자)와 같은 다른 항목은, 
[Flex](#flex) 섹션에 설명된 대로 지정된 제약 조건에 따라 달라집니다.
  
[`Center`]: {{site.api}}/flutter/widgets/Center-class.html
[`Column`]: {{site.api}}/flutter/widgets/Column-class.html
[`Container`]: {{site.api}}/flutter/widgets/Container-class.html
[`Image`]: {{site.api}}/flutter/dart-ui/Image-class.html
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
[`Opacity`]: {{site.api}}/flutter/widgets/Opacity-class.html
[`Row`]: {{site.api}}/flutter/widgets/Row-class.html
[`Text`]: {{site.api}}/flutter/widgets/Text-class.html
[`Transform`]: {{site.api}}/flutter/widgets/Transform-class.html

## 예제 {:#examples}

상호 작용 경험을 위해, 다음 DartPad를 사용하세요. 
번호가 매겨진 수평 스크롤 막대를 사용하여, 29개의 다른 예 사이를 전환하세요.

<?code-excerpt "lib/main.dart"?>
```dartpad title="Constraints DartPad hands-on example" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const HomePage());

const red = Colors.red;
const green = Colors.green;
const blue = Colors.blue;
const big = TextStyle(fontSize: 30);

//////////////////////////////////////////////////

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const FlutterLayoutArticle([
      Example1(),
      Example2(),
      Example3(),
      Example4(),
      Example5(),
      Example6(),
      Example7(),
      Example8(),
      Example9(),
      Example10(),
      Example11(),
      Example12(),
      Example13(),
      Example14(),
      Example15(),
      Example16(),
      Example17(),
      Example18(),
      Example19(),
      Example20(),
      Example21(),
      Example22(),
      Example23(),
      Example24(),
      Example25(),
      Example26(),
      Example27(),
      Example28(),
      Example29(),
    ]);
  }
}

//////////////////////////////////////////////////

abstract class Example extends StatelessWidget {
  const Example({super.key});

  String get code;

  String get explanation;
}

//////////////////////////////////////////////////

class FlutterLayoutArticle extends StatefulWidget {
  const FlutterLayoutArticle(
    this.examples, {
    super.key,
  });

  final List<Example> examples;

  @override
  State<FlutterLayoutArticle> createState() => _FlutterLayoutArticleState();
}

//////////////////////////////////////////////////

class _FlutterLayoutArticleState extends State<FlutterLayoutArticle> {
  late int count;
  late Widget example;
  late String code;
  late String explanation;

  @override
  void initState() {
    count = 1;
    code = const Example1().code;
    explanation = const Example1().explanation;

    super.initState();
  }

  @override
  void didUpdateWidget(FlutterLayoutArticle oldWidget) {
    super.didUpdateWidget(oldWidget);
    var example = widget.examples[count - 1];
    code = example.code;
    explanation = example.explanation;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Layout Article',
      home: SafeArea(
        child: Material(
          color: Colors.black,
          child: FittedBox(
            child: Container(
              width: 400,
              height: 670,
              color: const Color(0xFFCCCCCC),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: ConstrainedBox(
                          constraints: const BoxConstraints.tightFor(
                              width: double.infinity, height: double.infinity),
                          child: widget.examples[count - 1])),
                  Container(
                    height: 50,
                    width: double.infinity,
                    color: Colors.black,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (int i = 0; i < widget.examples.length; i++)
                            Container(
                              width: 58,
                              padding: const EdgeInsets.only(left: 4, right: 4),
                              child: button(i + 1),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 273,
                    color: Colors.grey[50],
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        key: ValueKey(count),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Center(child: Text(code)),
                              const SizedBox(height: 15),
                              Text(
                                explanation,
                                style: TextStyle(
                                    color: Colors.blue[900],
                                    fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget button(int exampleNumber) {
    return Button(
      key: ValueKey('button$exampleNumber'),
      isSelected: count == exampleNumber,
      exampleNumber: exampleNumber,
      onPressed: () {
        showExample(
          exampleNumber,
          widget.examples[exampleNumber - 1].code,
          widget.examples[exampleNumber - 1].explanation,
        );
      },
    );
  }

  void showExample(int exampleNumber, String code, String explanation) {
    setState(() {
      count = exampleNumber;
      this.code = code;
      this.explanation = explanation;
    });
  }
}

//////////////////////////////////////////////////

class Button extends StatelessWidget {
  final bool isSelected;
  final int exampleNumber;
  final VoidCallback onPressed;

  const Button({
    super.key,
    required this.isSelected,
    required this.exampleNumber,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: isSelected ? Colors.grey : Colors.grey[800],
      ),
      child: Text(exampleNumber.toString()),
      onPressed: () {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
          alignment: 0.5,
        );
        onPressed();
      },
    );
  }
}
//////////////////////////////////////////////////

class Example1 extends Example {
  const Example1({super.key});

  @override
  final code = 'Container(color: red)';

  @override
  final explanation = 'The screen is the parent of the Container, '
      'and it forces the Container to be exactly the same size as the screen.'
      '\n\n'
      'So the Container fills the screen and paints it red.';

  @override
  Widget build(BuildContext context) {
    return Container(color: red);
  }
}

//////////////////////////////////////////////////

class Example2 extends Example {
  const Example2({super.key});

  @override
  final code = 'Container(width: 100, height: 100, color: red)';
  @override
  final String explanation =
      'The red Container wants to be 100x100, but it can\'t, '
      'because the screen forces it to be exactly the same size as the screen.'
      '\n\n'
      'So the Container fills the screen.';

  @override
  Widget build(BuildContext context) {
    return Container(width: 100, height: 100, color: red);
  }
}

//////////////////////////////////////////////////

class Example3 extends Example {
  const Example3({super.key});

  @override
  final code = 'Center(\n'
      '   child: Container(width: 100, height: 100, color: red))';
  @override
  final String explanation =
      'The screen forces the Center to be exactly the same size as the screen, '
      'so the Center fills the screen.'
      '\n\n'
      'The Center tells the Container that it can be any size it wants, but not bigger than the screen.'
      'Now the Container can indeed be 100x100.';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(width: 100, height: 100, color: red),
    );
  }
}

//////////////////////////////////////////////////

class Example4 extends Example {
  const Example4({super.key});

  @override
  final code = 'Align(\n'
      '   alignment: Alignment.bottomRight,\n'
      '   child: Container(width: 100, height: 100, color: red))';
  @override
  final String explanation =
      'This is different from the previous example in that it uses Align instead of Center.'
      '\n\n'
      'Align also tells the Container that it can be any size it wants, but if there is empty space it won\'t center the Container. '
      'Instead, it aligns the Container to the bottom-right of the available space.';

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(width: 100, height: 100, color: red),
    );
  }
}

//////////////////////////////////////////////////

class Example5 extends Example {
  const Example5({super.key});

  @override
  final code = 'Center(\n'
      '   child: Container(\n'
      '              color: red,\n'
      '              width: double.infinity,\n'
      '              height: double.infinity))';
  @override
  final String explanation =
      'The screen forces the Center to be exactly the same size as the screen, '
      'so the Center fills the screen.'
      '\n\n'
      'The Center tells the Container that it can be any size it wants, but not bigger than the screen.'
      'The Container wants to be of infinite size, but since it can\'t be bigger than the screen, it just fills the screen.';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          width: double.infinity, height: double.infinity, color: red),
    );
  }
}

//////////////////////////////////////////////////

class Example6 extends Example {
  const Example6({super.key});

  @override
  final code = 'Center(child: Container(color: red))';
  @override
  final String explanation =
      'The screen forces the Center to be exactly the same size as the screen, '
      'so the Center fills the screen.'
      '\n\n'
      'The Center tells the Container that it can be any size it wants, but not bigger than the screen.'
      '\n\n'
      'Since the Container has no child and no fixed size, it decides it wants to be as big as possible, so it fills the whole screen.'
      '\n\n'
      'But why does the Container decide that? '
      'Simply because that\'s a design decision by those who created the Container widget. '
      'It could have been created differently, and you have to read the Container documentation to understand how it behaves, depending on the circumstances. ';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(color: red),
    );
  }
}

//////////////////////////////////////////////////

class Example7 extends Example {
  const Example7({super.key});

  @override
  final code = 'Center(\n'
      '   child: Container(color: red\n'
      '      child: Container(color: green, width: 30, height: 30)))';
  @override
  final String explanation =
      'The screen forces the Center to be exactly the same size as the screen, '
      'so the Center fills the screen.'
      '\n\n'
      'The Center tells the red Container that it can be any size it wants, but not bigger than the screen.'
      'Since the red Container has no size but has a child, it decides it wants to be the same size as its child.'
      '\n\n'
      'The red Container tells its child that it can be any size it wants, but not bigger than the screen.'
      '\n\n'
      'The child is a green Container that wants to be 30x30.'
      '\n\n'
      'Since the red `Container` has no size but has a child, it decides it wants to be the same size as its child. '
      'The red color isn\'t visible, since the green Container entirely covers all of the red Container.';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: red,
        child: Container(color: green, width: 30, height: 30),
      ),
    );
  }
}

//////////////////////////////////////////////////

class Example8 extends Example {
  const Example8({super.key});

  @override
  final code = 'Center(\n'
      '   child: Container(color: red\n'
      '      padding: const EdgeInsets.all(20),\n'
      '      child: Container(color: green, width: 30, height: 30)))';
  @override
  final String explanation =
      'The red Container sizes itself to its children size, but it takes its own padding into consideration. '
      'So it is also 30x30 plus padding. '
      'The red color is visible because of the padding, and the green Container has the same size as in the previous example.';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        color: red,
        child: Container(color: green, width: 30, height: 30),
      ),
    );
  }
}

//////////////////////////////////////////////////

class Example9 extends Example {
  const Example9({super.key});

  @override
  final code = 'ConstrainedBox(\n'
      '   constraints: BoxConstraints(\n'
      '              minWidth: 70, minHeight: 70,\n'
      '              maxWidth: 150, maxHeight: 150),\n'
      '      child: Container(color: red, width: 10, height: 10)))';
  @override
  final String explanation =
      'You might guess that the Container has to be between 70 and 150 pixels, but you would be wrong. '
      'The ConstrainedBox only imposes ADDITIONAL constraints from those it receives from its parent.'
      '\n\n'
      'Here, the screen forces the ConstrainedBox to be exactly the same size as the screen, '
      'so it tells its child Container to also assume the size of the screen, '
      'thus ignoring its \'constraints\' parameter.';

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 70,
        minHeight: 70,
        maxWidth: 150,
        maxHeight: 150,
      ),
      child: Container(color: red, width: 10, height: 10),
    );
  }
}

//////////////////////////////////////////////////

class Example10 extends Example {
  const Example10({super.key});

  @override
  final code = 'Center(\n'
      '   child: ConstrainedBox(\n'
      '      constraints: BoxConstraints(\n'
      '                 minWidth: 70, minHeight: 70,\n'
      '                 maxWidth: 150, maxHeight: 150),\n'
      '        child: Container(color: red, width: 10, height: 10))))';
  @override
  final String explanation =
      'Now, Center allows ConstrainedBox to be any size up to the screen size.'
      '\n\n'
      'The ConstrainedBox imposes ADDITIONAL constraints from its \'constraints\' parameter onto its child.'
      '\n\n'
      'The Container must be between 70 and 150 pixels. It wants to have 10 pixels, so it will end up having 70 (the MINIMUM).';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 70,
          minHeight: 70,
          maxWidth: 150,
          maxHeight: 150,
        ),
        child: Container(color: red, width: 10, height: 10),
      ),
    );
  }
}

//////////////////////////////////////////////////

class Example11 extends Example {
  const Example11({super.key});

  @override
  final code = 'Center(\n'
      '   child: ConstrainedBox(\n'
      '      constraints: BoxConstraints(\n'
      '                 minWidth: 70, minHeight: 70,\n'
      '                 maxWidth: 150, maxHeight: 150),\n'
      '        child: Container(color: red, width: 1000, height: 1000))))';
  @override
  final String explanation =
      'Center allows ConstrainedBox to be any size up to the screen size.'
      'The ConstrainedBox imposes ADDITIONAL constraints from its \'constraints\' parameter onto its child'
      '\n\n'
      'The Container must be between 70 and 150 pixels. It wants to have 1000 pixels, so it ends up having 150 (the MAXIMUM).';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 70,
          minHeight: 70,
          maxWidth: 150,
          maxHeight: 150,
        ),
        child: Container(color: red, width: 1000, height: 1000),
      ),
    );
  }
}

//////////////////////////////////////////////////

class Example12 extends Example {
  const Example12({super.key});

  @override
  final code = 'Center(\n'
      '   child: ConstrainedBox(\n'
      '      constraints: BoxConstraints(\n'
      '                 minWidth: 70, minHeight: 70,\n'
      '                 maxWidth: 150, maxHeight: 150),\n'
      '        child: Container(color: red, width: 100, height: 100))))';
  @override
  final String explanation =
      'Center allows ConstrainedBox to be any size up to the screen size.'
      'ConstrainedBox imposes ADDITIONAL constraints from its \'constraints\' parameter onto its child.'
      '\n\n'
      'The Container must be between 70 and 150 pixels. It wants to have 100 pixels, and that\'s the size it has, since that\'s between 70 and 150.';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 70,
          minHeight: 70,
          maxWidth: 150,
          maxHeight: 150,
        ),
        child: Container(color: red, width: 100, height: 100),
      ),
    );
  }
}

//////////////////////////////////////////////////

class Example13 extends Example {
  const Example13({super.key});

  @override
  final code = 'UnconstrainedBox(\n'
      '   child: Container(color: red, width: 20, height: 50));';
  @override
  final String explanation =
      'The screen forces the UnconstrainedBox to be exactly the same size as the screen.'
      'However, the UnconstrainedBox lets its child Container be any size it wants.';

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Container(color: red, width: 20, height: 50),
    );
  }
}

//////////////////////////////////////////////////

class Example14 extends Example {
  const Example14({super.key});

  @override
  final code = 'UnconstrainedBox(\n'
      '   child: Container(color: red, width: 4000, height: 50));';
  @override
  final String explanation =
      'The screen forces the UnconstrainedBox to be exactly the same size as the screen, '
      'and UnconstrainedBox lets its child Container be any size it wants.'
      '\n\n'
      'Unfortunately, in this case the Container has 4000 pixels of width and is too big to fit in the UnconstrainedBox, '
      'so the UnconstrainedBox displays the much dreaded "overflow warning".';

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Container(color: red, width: 4000, height: 50),
    );
  }
}

//////////////////////////////////////////////////

class Example15 extends Example {
  const Example15({super.key});

  @override
  final code = 'OverflowBox(\n'
      '   minWidth: 0,'
      '   minHeight: 0,'
      '   maxWidth: double.infinity,'
      '   maxHeight: double.infinity,'
      '   child: Container(color: red, width: 4000, height: 50));';
  @override
  final String explanation =
      'The screen forces the OverflowBox to be exactly the same size as the screen, '
      'and OverflowBox lets its child Container be any size it wants.'
      '\n\n'
      'OverflowBox is similar to UnconstrainedBox, and the difference is that it won\'t display any warnings if the child doesn\'t fit the space.'
      '\n\n'
      'In this case the Container is 4000 pixels wide, and is too big to fit in the OverflowBox, '
      'but the OverflowBox simply shows as much as it can, with no warnings given.';

  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      minWidth: 0,
      minHeight: 0,
      maxWidth: double.infinity,
      maxHeight: double.infinity,
      child: Container(color: red, width: 4000, height: 50),
    );
  }
}

//////////////////////////////////////////////////

class Example16 extends Example {
  const Example16({super.key});

  @override
  final code = 'UnconstrainedBox(\n'
      '   child: Container(color: Colors.red, width: double.infinity, height: 100));';
  @override
  final String explanation =
      'This won\'t render anything, and you\'ll see an error in the console.'
      '\n\n'
      'The UnconstrainedBox lets its child be any size it wants, '
      'however its child is a Container with infinite size.'
      '\n\n'
      'Flutter can\'t render infinite sizes, so it throws an error with the following message: '
      '"BoxConstraints forces an infinite width."';

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Container(color: Colors.red, width: double.infinity, height: 100),
    );
  }
}

//////////////////////////////////////////////////

class Example17 extends Example {
  const Example17({super.key});

  @override
  final code = 'UnconstrainedBox(\n'
      '   child: LimitedBox(maxWidth: 100,\n'
      '      child: Container(color: Colors.red,\n'
      '                       width: double.infinity, height: 100));';
  @override
  final String explanation = 'Here you won\'t get an error anymore, '
      'because when the LimitedBox is given an infinite size by the UnconstrainedBox, '
      'it passes a maximum width of 100 down to its child.'
      '\n\n'
      'If you swap the UnconstrainedBox for a Center widget, '
      'the LimitedBox won\'t apply its limit anymore (since its limit is only applied when it gets infinite constraints), '
      'and the width of the Container is allowed to grow past 100.'
      '\n\n'
      'This explains the difference between a LimitedBox and a ConstrainedBox.';

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: LimitedBox(
        maxWidth: 100,
        child: Container(
          color: Colors.red,
          width: double.infinity,
          height: 100,
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////

class Example18 extends Example {
  const Example18({super.key});

  @override
  final code = 'FittedBox(\n'
      '   child: Text(\'Some Example Text.\'));';
  @override
  final String explanation =
      'The screen forces the FittedBox to be exactly the same size as the screen.'
      'The Text has some natural width (also called its intrinsic width) that depends on the amount of text, its font size, and so on.'
      '\n\n'
      'The FittedBox lets the Text be any size it wants, '
      'but after the Text tells its size to the FittedBox, '
      'the FittedBox scales the Text until it fills all of the available width.';

  @override
  Widget build(BuildContext context) {
    return const FittedBox(
      child: Text('Some Example Text.'),
    );
  }
}

//////////////////////////////////////////////////

class Example19 extends Example {
  const Example19({super.key});

  @override
  final code = 'Center(\n'
      '   child: FittedBox(\n'
      '      child: Text(\'Some Example Text.\')));';
  @override
  final String explanation =
      'But what happens if you put the FittedBox inside of a Center widget? '
      'The Center lets the FittedBox be any size it wants, up to the screen size.'
      '\n\n'
      'The FittedBox then sizes itself to the Text, and lets the Text be any size it wants.'
      '\n\n'
      'Since both FittedBox and the Text have the same size, no scaling happens.';

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: FittedBox(
        child: Text('Some Example Text.'),
      ),
    );
  }
}

////////////////////////////////////////////////////

class Example20 extends Example {
  const Example20({super.key});

  @override
  final code = 'Center(\n'
      '   child: FittedBox(\n'
      '      child: Text(\'…\')));';
  @override
  final String explanation =
      'However, what happens if FittedBox is inside of a Center widget, but the Text is too large to fit the screen?'
      '\n\n'
      'FittedBox tries to size itself to the Text, but it can\'t be bigger than the screen. '
      'It then assumes the screen size, and resizes Text so that it fits the screen, too.';

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: FittedBox(
        child: Text(
            'This is some very very very large text that is too big to fit a regular screen in a single line.'),
      ),
    );
  }
}

//////////////////////////////////////////////////

class Example21 extends Example {
  const Example21({super.key});

  @override
  final code = 'Center(\n'
      '   child: Text(\'…\'));';
  @override
  final String explanation = 'If, however, you remove the FittedBox, '
      'the Text gets its maximum width from the screen, '
      'and breaks the line so that it fits the screen.';

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
          'This is some very very very large text that is too big to fit a regular screen in a single line.'),
    );
  }
}

//////////////////////////////////////////////////

class Example22 extends Example {
  const Example22({super.key});

  @override
  final code = 'FittedBox(\n'
      '   child: Container(\n'
      '      height: 20, width: double.infinity));';
  @override
  final String explanation =
      'FittedBox can only scale a widget that is BOUNDED (has non-infinite width and height).'
      'Otherwise, it won\'t render anything, and you\'ll see an error in the console.';

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        height: 20,
        width: double.infinity,
        color: Colors.red,
      ),
    );
  }
}

//////////////////////////////////////////////////

class Example23 extends Example {
  const Example23({super.key});

  @override
  final code = 'Row(children:[\n'
      '   Container(color: red, child: Text(\'Hello!\'))\n'
      '   Container(color: green, child: Text(\'Goodbye!\'))]';
  @override
  final String explanation =
      'The screen forces the Row to be exactly the same size as the screen.'
      '\n\n'
      'Just like an UnconstrainedBox, the Row won\'t impose any constraints onto its children, '
      'and instead lets them be any size they want.'
      '\n\n'
      'The Row then puts them side-by-side, and any extra space remains empty.';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(color: red, child: const Text('Hello!', style: big)),
        Container(color: green, child: const Text('Goodbye!', style: big)),
      ],
    );
  }
}

//////////////////////////////////////////////////

class Example24 extends Example {
  const Example24({super.key});

  @override
  final code = 'Row(children:[\n'
      '   Container(color: red, child: Text(\'…\'))\n'
      '   Container(color: green, child: Text(\'Goodbye!\'))]';
  @override
  final String explanation =
      'Since the Row won\'t impose any constraints onto its children, '
      'it\'s quite possible that the children might be too big to fit the available width of the Row.'
      'In this case, just like an UnconstrainedBox, the Row displays the "overflow warning".';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          color: red,
          child: const Text(
            'This is a very long text that '
            'won\'t fit the line.',
            style: big,
          ),
        ),
        Container(color: green, child: const Text('Goodbye!', style: big)),
      ],
    );
  }
}

//////////////////////////////////////////////////

class Example25 extends Example {
  const Example25({super.key});

  @override
  final code = 'Row(children:[\n'
      '   Expanded(\n'
      '       child: Container(color: red, child: Text(\'…\')))\n'
      '   Container(color: green, child: Text(\'Goodbye!\'))]';
  @override
  final String explanation =
      'When a Row\'s child is wrapped in an Expanded widget, the Row won\'t let this child define its own width anymore.'
      '\n\n'
      'Instead, it defines the Expanded width according to the other children, and only then the Expanded widget forces the original child to have the Expanded\'s width.'
      '\n\n'
      'In other words, once you use Expanded, the original child\'s width becomes irrelevant, and is ignored.';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Center(
            child: Container(
              color: red,
              child: const Text(
                'This is a very long text that won\'t fit the line.',
                style: big,
              ),
            ),
          ),
        ),
        Container(color: green, child: const Text('Goodbye!', style: big)),
      ],
    );
  }
}

//////////////////////////////////////////////////

class Example26 extends Example {
  const Example26({super.key});

  @override
  final code = 'Row(children:[\n'
      '   Expanded(\n'
      '       child: Container(color: red, child: Text(\'…\')))\n'
      '   Expanded(\n'
      '       child: Container(color: green, child: Text(\'Goodbye!\'))]';
  @override
  final String explanation =
      'If all of Row\'s children are wrapped in Expanded widgets, each Expanded has a size proportional to its flex parameter, '
      'and only then each Expanded widget forces its child to have the Expanded\'s width.'
      '\n\n'
      'In other words, Expanded ignores the preferred width of its children.';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: red,
            child: const Text(
              'This is a very long text that won\'t fit the line.',
              style: big,
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: green,
            child: const Text(
              'Goodbye!',
              style: big,
            ),
          ),
        ),
      ],
    );
  }
}

//////////////////////////////////////////////////

class Example27 extends Example {
  const Example27({super.key});

  @override
  final code = 'Row(children:[\n'
      '   Flexible(\n'
      '       child: Container(color: red, child: Text(\'…\')))\n'
      '   Flexible(\n'
      '       child: Container(color: green, child: Text(\'Goodbye!\'))]';
  @override
  final String explanation =
      'The only difference if you use Flexible instead of Expanded, '
      'is that Flexible lets its child be SMALLER than the Flexible width, '
      'while Expanded forces its child to have the same width of the Expanded.'
      '\n\n'
      'But both Expanded and Flexible ignore their children\'s width when sizing themselves.'
      '\n\n'
      'This means that it\'s IMPOSSIBLE to expand Row children proportionally to their sizes. '
      'The Row either uses the exact child\'s width, or ignores it completely when you use Expanded or Flexible.';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Container(
            color: red,
            child: const Text(
              'This is a very long text that won\'t fit the line.',
              style: big,
            ),
          ),
        ),
        Flexible(
          child: Container(
            color: green,
            child: const Text(
              'Goodbye!',
              style: big,
            ),
          ),
        ),
      ],
    );
  }
}

//////////////////////////////////////////////////

class Example28 extends Example {
  const Example28({super.key});

  @override
  final code = 'Scaffold(\n'
      '   body: Container(color: blue,\n'
      '   child: Column(\n'
      '      children: [\n'
      '         Text(\'Hello!\'),\n'
      '         Text(\'Goodbye!\')])))';

  @override
  final String explanation =
      'The screen forces the Scaffold to be exactly the same size as the screen, '
      'so the Scaffold fills the screen.'
      '\n\n'
      'The Scaffold tells the Container that it can be any size it wants, but not bigger than the screen.'
      '\n\n'
      'When a widget tells its child that it can be smaller than a certain size, '
      'we say the widget supplies "loose" constraints to its child. More on that later.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: blue,
        child: const Column(
          children: [
            Text('Hello!'),
            Text('Goodbye!'),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////

class Example29 extends Example {
  const Example29({super.key});

  @override
  final code = 'Scaffold(\n'
      '   body: Container(color: blue,\n'
      '   child: SizedBox.expand(\n'
      '      child: Column(\n'
      '         children: [\n'
      '            Text(\'Hello!\'),\n'
      '            Text(\'Goodbye!\')]))))';

  @override
  final String explanation =
      'If you want the Scaffold\'s child to be exactly the same size as the Scaffold itself, '
      'you can wrap its child with SizedBox.expand.'
      '\n\n'
      'When a widget tells its child that it must be of a certain size, '
      'we say the widget supplies "tight" constraints to its child. More on that later.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          color: blue,
          child: const Column(
            children: [
              Text('Hello!'),
              Text('Goodbye!'),
            ],
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////
```

원하시면 [이 GitHub repo][]에서 코드를 가져올 수 있습니다.

다음 섹션에서는 예시를 설명합니다.

[this GitHub repo]: {{site.github}}/marcglasberg/flutter_layout_article

### Example 1 {:#example-1}

<img src='/assets/images/docs/ui/layout/layout-1.png' class="mw-100" alt="Example 1 layout">

<?code-excerpt "lib/main.dart (Example1)" replace="/(return |;)//g"?>
```dart
Container(color: red)
```

화면은 `Container`의 부모이며, `Container`가 화면과 정확히 같은 크기가 되도록 강제합니다.

따라서 `Container`는 화면을 채우고 빨간색으로 칠합니다.

### Example 2 {:#example-2}

<img src='/assets/images/docs/ui/layout/layout-2.png' class="mw-100" alt="Example 2 layout">

<?code-excerpt "lib/main.dart (Example2)" replace="/(return |;)//g"?>
```dart
Container(width: 100, height: 100, color: red)
```

빨간색 `Container`는 100 x 100이 되고 싶어하지만, 
화면이 정확히 화면과 같은 크기가 되도록 강제하기 때문에 불가능합니다.

그래서 `Container`는 화면을 채웁니다.

### Example 3 {:#example-3}

<img src='/assets/images/docs/ui/layout/layout-3.png' class="mw-100" alt="Example 3 layout">

<?code-excerpt "lib/main.dart (Example3)" replace="/(return |;)//g"?>
```dart
Center(
  child: Container(width: 100, height: 100, color: red),
)
```

화면은 `Center`가 화면과 정확히 같은 크기가 되도록 강제하므로, `Center`가 화면을 채웁니다.

`Center`는 `Container`에게 원하는 크기가 될 수 있지만, 화면보다 클 수는 없다고 알려줍니다. 
이제 `Container`는 실제로 100 x 100이 될 수 있습니다.

### Example 4 {:#example-4}

<img src='/assets/images/docs/ui/layout/layout-4.png' class="mw-100" alt="Example 4 layout">

<?code-excerpt "lib/main.dart (Example4)" replace="/(return |;)//g"?>
```dart
Align(
  alignment: Alignment.bottomRight,
  child: Container(width: 100, height: 100, color: red),
)
```

이것은 `Center` 대신 `Align`을 사용한다는 점에서 이전 예와 다릅니다.

`Align`은 또한 `Container`에 원하는 크기가 될 수 있다고 알려주지만, 
빈 공간이 있으면 `Container`를 가운데 정렬하지 않습니다. 
대신, 컨테이너를 사용 가능한 공간의 오른쪽 하단에 정렬합니다.

### Example 5 {:#example-5}

<img src='/assets/images/docs/ui/layout/layout-5.png' class="mw-100" alt="Example 5 layout">

<?code-excerpt "lib/main.dart (Example5)" replace="/(return |;)//g"?>
```dart
Center(
  child: Container(
      width: double.infinity, height: double.infinity, color: red),
)
```

화면은 `Center`가 화면과 정확히 같은 크기가 되도록 강제하므로, `Center`가 화면을 채웁니다.

`Center`는 `Container`에게 원하는 크기가 될 수 있지만, 화면보다 클 수는 없다고 알려줍니다. 
`Container`는 무한한 크기가 되기를 원하지만, 화면보다 클 수 없으므로 화면을 채웁니다.

### Example 6 {:#example-6}

<img src='/assets/images/docs/ui/layout/layout-6.png' class="mw-100" alt="Example 6 layout">

<?code-excerpt "lib/main.dart (Example6)" replace="/(return |;)//g"?>
```dart
Center(
  child: Container(color: red),
)
```

화면은 `Center`가 화면과 정확히 같은 크기가 되도록 강제하므로, `Center`가 화면을 채웁니다.

`Center`는 `Container`에게 원하는 크기가 될 수 있지만, 화면보다 클 수는 없다고 알려줍니다. 
`Container`에는 자식이 없고 고정된 크기가 없으므로, 가능한 한 크게 하려고 결정하여, 전체 화면을 채웁니다.

하지만 `Container`가 왜 그렇게 결정할까요? 
그것은 단순히 `Container` 위젯을 만든 사람들이 내린 디자인 결정이기 때문입니다. 
다르게 만들어졌을 수도 있고 상황에 따라 어떻게 작동하는지 이해하려면 [`Container`][] API 문서를 읽어야 합니다.

### Example 7 {:#example-7}

<img src='/assets/images/docs/ui/layout/layout-7.png' class="mw-100" alt="Example 7 layout">

<?code-excerpt "lib/main.dart (Example7)" replace="/(return |;)//g"?>
```dart
Center(
  child: Container(
    color: red,
    child: Container(color: green, width: 30, height: 30),
  ),
)
```

화면은 `Center`가 화면과 정확히 같은 크기가 되도록 강제하므로, `Center`가 화면을 채웁니다.

`Center`는 빨간색 `Container`에게 원하는 크기가 될 수 있지만, 화면보다 크지는 않아야 한다고 알려줍니다. 
빨간색 `Container`는 크기가 없지만 자식이 있으므로, 자식과 같은 크기가 되기를 원한다고 결정합니다.

빨간색 `Container`는 자식에게 원하는 크기가 될 수 있지만, 화면보다 크지는 않아야 한다고 알려줍니다.

자식은 30 x 30이 되기를 원하는 녹색 `Container`입니다. 
빨간색 `Container`가 자식의 크기에 맞게 크기가 조정되므로 30 x 30이기도 합니다. 
녹색 `Container`가 빨간색 `Container`를 완전히 가리기 때문에 빨간색은 보이지 않습니다.

### Example 8 {:#example-8}

<img src='/assets/images/docs/ui/layout/layout-8.png' class="mw-100" alt="Example 8 layout">

<?code-excerpt "lib/main.dart (Example8)" replace="/(return |;)//g"?>
```dart
Center(
  child: Container(
    padding: const EdgeInsets.all(20),
    color: red,
    child: Container(color: green, width: 30, height: 30),
  ),
)
```

빨간색 `Container`는 자식의 크기에 맞게 크기를 조정하지만, 자체 패딩을 고려합니다. 
따라서 30 x 30 플러스 패딩입니다. 
패딩 때문에 빨간색이 보이고, 녹색 `Container`는 이전 예와 같은 크기를 갖습니다.

### Example 9 {:#example-9}

<img src='/assets/images/docs/ui/layout/layout-9.png' class="mw-100" alt="Example 9 layout">

<?code-excerpt "lib/main.dart (Example9)" replace="/(return |;)//g"?>
```dart
ConstrainedBox(
  constraints: const BoxConstraints(
    minWidth: 70,
    minHeight: 70,
    maxWidth: 150,
    maxHeight: 150,
  ),
  child: Container(color: red, width: 10, height: 10),
)
```

`Container`는 70~150픽셀이어야 한다고 생각할 수 있지만, 틀렸습니다. 
`ConstrainedBox`는 부모로부터 받은 제약 조건으로부터 **추가적인** 제약 조건만 부과합니다.

여기서, 화면은 `ConstrainedBox`가 화면과 정확히 같은 크기가 되도록 강제하므로, 
자식 `Container`에게도 화면 크기를 가정하도록 지시하여, 
`constraints` 매개변수를 무시합니다.

### Example 10 {:#example-10}

<img src='/assets/images/docs/ui/layout/layout-10.png' class="mw-100" alt="Example 10 layout">

<?code-excerpt "lib/main.dart (Example10)" replace="/(return |;)//g"?>
```dart
Center(
  child: ConstrainedBox(
    constraints: const BoxConstraints(
      minWidth: 70,
      minHeight: 70,
      maxWidth: 150,
      maxHeight: 150,
    ),
    child: Container(color: red, width: 10, height: 10),
  ),
)
```

이제, `Center`는 `ConstrainedBox`가 화면 크기까지 어떤 크기든 될 수 있도록 허용합니다. 
`ConstrainedBox`는 `constraints` 매개변수에서 자식에 **추가적인** 제약 조건을 부과합니다.

컨테이너는 70~150픽셀이어야 합니다. 10픽셀을 원하므로 70(최소)을 갖게 됩니다.

### Example 11 {:#example-11}

<img src='/assets/images/docs/ui/layout/layout-11.png' class="mw-100" alt="Example 11 layout">

<?code-excerpt "lib/main.dart (Example11)" replace="/(return |;)//g"?>
```dart
Center(
  child: ConstrainedBox(
    constraints: const BoxConstraints(
      minWidth: 70,
      minHeight: 70,
      maxWidth: 150,
      maxHeight: 150,
    ),
    child: Container(color: red, width: 1000, height: 1000),
  ),
)
```

`Center`는 `ConstrainedBox`가 화면 크기까지 어떤 크기든 될 수 있도록 합니다. 
`ConstrainedBox`는 `constraints` 매개변수에서 자식에 **추가적인** 제약을 부과합니다.

`Container`는 70~150픽셀이어야 합니다. 1000픽셀을 원하므로 150(최대)을 갖게 됩니다.

### Example 12 {:#example-12}

<img src='/assets/images/docs/ui/layout/layout-12.png' class="mw-100" alt="Example 12 layout">

<?code-excerpt "lib/main.dart (Example12)" replace="/(return |;)//g"?>
```dart
Center(
  child: ConstrainedBox(
    constraints: const BoxConstraints(
      minWidth: 70,
      minHeight: 70,
      maxWidth: 150,
      maxHeight: 150,
    ),
    child: Container(color: red, width: 100, height: 100),
  ),
)
```

`Center`는 `ConstrainedBox`가 화면 크기까지 어떤 크기든 될 수 있도록 합니다. 
`ConstrainedBox`는 `constraints` 매개변수에서 자식에 **추가** 제약 조건을 부과합니다.

`Container`는 70~150픽셀이어야 합니다. 100픽셀을 원하고, 70~150 사이에 있으므로 그 크기가 됩니다.

### Example 13 {:#example-13}

<img src='/assets/images/docs/ui/layout/layout-13.png' class="mw-100" alt="Example 13 layout">

<?code-excerpt "lib/main.dart (Example13)" replace="/(return |;)//g"?>
```dart
UnconstrainedBox(
  child: Container(color: red, width: 20, height: 50),
)
```

화면은 `UnconstrainedBox`가 화면과 정확히 같은 크기가 되도록 강제합니다. 
그러나 `UnconstrainedBox`는 자식 `Container`가 원하는 크기가 되도록 합니다.

### Example 14 {:#example-14}

<img src='/assets/images/docs/ui/layout/layout-14.png' class="mw-100" alt="Example 14 layout">

<?code-excerpt "lib/main.dart (Example14)" replace="/(return |;)//g"?>
```dart
UnconstrainedBox(
  child: Container(color: red, width: 4000, height: 50),
)
```

화면은 `UnconstrainedBox`가 화면과 정확히 같은 크기가 되도록 강제하고, 
`UnconstrainedBox`는 자식 `Container`가 원하는 크기가 무엇이든 그 크기가 되도록 합니다.

안타깝게도, 이 경우 `Container`는 너비가 4000픽셀이고, 
`UnconstrainedBox`에 fit하기에는 너무 크기 때문에, 
`UnconstrainedBox`는 두려운 "오버플로 경고"를 표시합니다.

### Example 15 {:#example-15}

<img src='/assets/images/docs/ui/layout/layout-15.png' class="mw-100" alt="Example 15 layout">

<?code-excerpt "lib/main.dart (Example15)" replace="/(return |;)//g"?>
```dart
OverflowBox(
  minWidth: 0,
  minHeight: 0,
  maxWidth: double.infinity,
  maxHeight: double.infinity,
  child: Container(color: red, width: 4000, height: 50),
)
```

화면은 `OverflowBox`가 화면과 정확히 같은 크기가 되도록 강제하고, 
`OverflowBox`는 자식 `Container`가 원하는 크기가 되도록 합니다.

`OverflowBox`는 `UnconstrainedBox`와 비슷합니다. 
다만, 자식이 공간에 맞지 않으면 경고를 표시하지 않는다는 점이 다릅니다.

이 경우, `Container`는 너비가 4000픽셀이고, `OverflowBox`에 맞을 만큼 크지 않지만, 
`OverflowBox`는 경고 없이 가능한 한 많이 표시합니다.

### Example 16 {:#example-16}

<img src='/assets/images/docs/ui/layout/layout-16.png' class="mw-100" alt="Example 16 layout">

<?code-excerpt "lib/main.dart (Example16)" replace="/(return |;)//g"?>
```dart
UnconstrainedBox(
  child: Container(color: Colors.red, width: double.infinity, height: 100),
)
```

이렇게 하면 아무것도 렌더링되지 않고, 콘솔에 오류가 표시됩니다.

`UnconstrainedBox`는 자식이 원하는 크기가 되도록 하지만, 자식은 무한 크기의 `Container`입니다.

Flutter는 무한 크기를 렌더링할 수 없으므로, 다음 메시지와 함께 오류가 발생합니다. 
`BoxConstraints forces an infinite width.`

### Example 17 {:#example-17}

<img src='/assets/images/docs/ui/layout/layout-17.png' class="mw-100" alt="Example 17 layout">

<?code-excerpt "lib/main.dart (Example17)" replace="/(return |;)//g"?>
```dart
UnconstrainedBox(
  child: LimitedBox(
    maxWidth: 100,
    child: Container(
      color: Colors.red,
      width: double.infinity,
      height: 100,
    ),
  ),
)
```

여기서는 더 이상 오류가 발생하지 않습니다. 
`LimitedBox`가 `UnconstrainedBox`에 의해 무한 크기가 주어지면, 
최대 너비 100을 자식에게 전달하기 때문입니다.

`UnconstrainedBox`를 `Center` 위젯으로 바꾸면, 
`LimitedBox`는 더 이상 제한을 적용하지 않습니다. (제한은 무한 제약 조건을 받을 때만 적용되기 때문)
그리고 `Container`의 너비는 100을 초과할 수 있습니다.

이것은 `LimitedBox`와 `ConstrainedBox`의 차이점을 설명합니다.

### Example 18 {:#example-18}

<img src='/assets/images/docs/ui/layout/layout-18.png' class="mw-100" alt="Example 18 layout">

<?code-excerpt "lib/main.dart (Example18)" replace="/(return |;)//g"?>
```dart
const FittedBox(
  child: Text('Some Example Text.'),
)
```

화면은 `FittedBox`가 화면과 정확히 같은 크기가 되도록 강제합니다. 
`Text`는 텍스트 양, 글꼴 크기 등에 따라 달라지는 자연스러운 너비(본질적인 너비라고도 함)를 가지고 있습니다.

`FittedBox`는 `Text`가 원하는 크기로 만들 수 있지만, 
`Text`가 `FittedBox`에 크기를 알려준 후, 
`FittedBox`는 사용 가능한 모든 너비를 채울 때까지 Text의 크기를 조정합니다.

### Example 19 {:#example-19}

<img src='/assets/images/docs/ui/layout/layout-19.png' class="mw-100" alt="Example 19 layout">

<?code-excerpt "lib/main.dart (Example19)" replace="/(return |;)//g"?>
```dart
const Center(
  child: FittedBox(
    child: Text('Some Example Text.'),
  ),
)
```

하지만 `Center` 위젯 안에 `FittedBox`를 넣으면 어떻게 될까요? 
`Center`는 `FittedBox`를 원하는 크기로, 화면 크기까지 지정할 수 있습니다.

그런 다음, `FittedBox`는 `Text`에 맞춰 크기를 조정하고, `Text`를 원하는 크기로 지정합니다. 
`FittedBox`와 `Text`는 크기가 같으므로, 크기 조정이 일어나지 않습니다.

### Example 20 {:#example-20}

<img src='/assets/images/docs/ui/layout/layout-20.png' class="mw-100" alt="Example 20 layout">

<?code-excerpt "lib/main.dart (Example20)" replace="/(return |;)//g"?>
```dart
const Center(
  child: FittedBox(
    child: Text(
        'This is some very very very large text that is too big to fit a regular screen in a single line.'),
  ),
)
```

하지만, `FittedBox`가 `Center` 위젯 안에 있지만, `Text`가 너무 커서 화면에 맞지 않으면 어떻게 될까요?

`FittedBox`는 `Text`에 맞게 크기를 조정하려고 하지만, 화면보다 클 수는 없습니다. 
그런 다음, 화면 크기를 가정하고, `Text`의 크기를 조정하여 화면에 맞게 조정합니다.

### Example 21 {:#example-21}

<img src='/assets/images/docs/ui/layout/layout-21.png' class="mw-100" alt="Example 21 layout">

<?code-excerpt "lib/main.dart (Example21)" replace="/(return |;)//g"?>
```dart
const Center(
  child: Text(
      'This is some very very very large text that is too big to fit a regular screen in a single line.'),
)
```

그러나, `FittedBox`를 제거하면, `Text`는 화면에서 최대 너비를 차지하며, 화면에 맞게 줄을 바꿉니다.

### Example 22 {:#example-22}

<img src='/assets/images/docs/ui/layout/layout-22.png' class="mw-100" alt="Example 22 layout">

<?code-excerpt "lib/main.dart (Example22)" replace="/(return |;)//g"?>
```dart
FittedBox(
  child: Container(
    height: 20,
    width: double.infinity,
    color: Colors.red,
  ),
)
```

`FittedBox`는 경계가 있는 (무한하지 않은 너비와 높이를 가진) 위젯만 확장할 수 있습니다. 
그렇지 않으면, 아무것도 렌더링하지 않고, 콘솔에 오류가 표시됩니다.

### Example 23 {:#example-23}

<img src='/assets/images/docs/ui/layout/layout-23.png' class="mw-100" alt="Example 23 layout">

<?code-excerpt "lib/main.dart (Example23)" replace="/(return |;)//g"?>
```dart
Row(
  children: [
    Container(color: red, child: const Text('Hello!', style: big)),
    Container(color: green, child: const Text('Goodbye!', style: big)),
  ],
)
```

화면은 `Row`가 화면과 정확히 같은 크기가 되도록 강제합니다.

`UnconstrainedBox`와 마찬가지로, `Row`는 자식에 어떠한 제약도 부과하지 않고, 대신 원하는 크기로 둡니다. 
그런 다음, `Row`는 자식을 나란히 놓고, 여분의 공간은 비어 있게 됩니다.

### Example 24 {:#example-24}

<img src='/assets/images/docs/ui/layout/layout-24.png' class="mw-100" alt="Example 24 layout">

<?code-excerpt "lib/main.dart (Example24)" replace="/(return |;)//g"?>
```dart
Row(
  children: [
    Container(
      color: red,
      child: const Text(
        'This is a very long text that '
        'won\'t fit the line.',
        style: big,
      ),
    ),
    Container(color: green, child: const Text('Goodbye!', style: big)),
  ],
)
```

`Row`는 자식에 제약을 부과하지 않으므로, 자식이 `Row`의 사용 가능한 너비에 맞지 않을 수 있습니다.
이 경우, `UnconstrainedBox`와 마찬가지로 `Row`는 "오버플로 경고"를 표시합니다.

### Example 25 {:#example-25}

<img src='/assets/images/docs/ui/layout/layout-25.png' class="mw-100" alt="Example 25 layout">

<?code-excerpt "lib/main.dart (Example25)" replace="/(return |;)//g"?>
```dart
Row(
  children: [
    Expanded(
      child: Center(
        child: Container(
          color: red,
          child: const Text(
            'This is a very long text that won\'t fit the line.',
            style: big,
          ),
        ),
      ),
    ),
    Container(color: green, child: const Text('Goodbye!', style: big)),
  ],
)
```

`Row`의 자식이 `Expanded` 위젯에 래핑되면, 
`Row`는 더 이상 이 자식이 자체 너비를 정의하도록 허용하지 않습니다.

대신, 다른 자식에 따라 `Expanded` 너비를 정의하고, 
그런 다음에야 `Expanded` 위젯이 원래 자식이 `Expanded`의 너비를 갖도록 강제합니다.

즉, `Expanded`를 사용하면 원래 자식의 너비는 무관해지고 무시됩니다.

### Example 26 {:#example-26}

<img src='/assets/images/docs/ui/layout/layout-26.png' class="mw-100" alt="Example 26 layout">

<?code-excerpt "lib/main.dart (Example26)" replace="/(return |;)//g"?>
```dart
Row(
  children: [
    Expanded(
      child: Container(
        color: red,
        child: const Text(
          'This is a very long text that won\'t fit the line.',
          style: big,
        ),
      ),
    ),
    Expanded(
      child: Container(
        color: green,
        child: const Text(
          'Goodbye!',
          style: big,
        ),
      ),
    ),
  ],
)
```

`Row`의 모든 자식이 `Expanded` 위젯에 래핑된 경우, 
각 `Expanded`는 flex 매개변수에 비례하는 크기를 가지며, 
그런 경우에만 각 `Expanded` 위젯은 자식이 `Expanded`의 너비를 갖도록 강제합니다.

즉, `Expanded`는 자식의 기본 너비를 무시합니다.

### Example 27 {:#example-27}

<img src='/assets/images/docs/ui/layout/layout-27.png' class="mw-100" alt="Example 27 layout">

<?code-excerpt "lib/main.dart (Example27)" replace="/(return |;)//g"?>
```dart
Row(
  children: [
    Flexible(
      child: Container(
        color: red,
        child: const Text(
          'This is a very long text that won\'t fit the line.',
          style: big,
        ),
      ),
    ),
    Flexible(
      child: Container(
        color: green,
        child: const Text(
          'Goodbye!',
          style: big,
        ),
      ),
    ),
  ],
)
```

`Expanded` 대신 `Flexible`을 사용하는 경우 유일한 차이점은, 
`Flexible`은 자식이 `Flexible` 자체와 같거나 더 작은 너비를 갖도록 하는 반면, 
`Expanded`는 자식이 `Expanded`와 정확히 같은 너비를 갖도록 강제한다는 것입니다. 
하지만, `Expanded`와 `Flexible`은 모두 크기를 조정할 때 자식의 너비를 무시합니다.

:::note
즉, `Row` 자식을 크기에 비례하여 확장하는 것은 불가능합니다. 
`Row`는 정확한 자식의 너비를 사용하거나, `Expanded` 또는 `Flexible`을 사용할 때 완전히 무시합니다.
:::

### Example 28 {:#example-28}

<img src='/assets/images/docs/ui/layout/layout-28.png' class="mw-100" alt="Example 28 layout">

<?code-excerpt "lib/main.dart (Example28)" replace="/(return |;)//g"?>
```dart
Scaffold(
  body: Container(
    color: blue,
    child: const Column(
      children: [
        Text('Hello!'),
        Text('Goodbye!'),
      ],
    ),
  ),
)
```

스크린은 `Scaffold`가 스크린과 정확히 같은 크기가 되도록 강제하므로, `Scaffold`가 스크린을 채웁니다. 
`Scaffold`는 `Container`에게 원하는 크기가 될 수 있지만, 스크린보다 클 수는 없다고 말합니다.

:::note
위젯이 자식에게 특정 크기보다 작을 수 있다고 말할 때, 
우리는 위젯이 자식에게 _느슨한(loose)_ 제약을 제공한다고 말합니다. 나중에 더 자세히 설명하겠습니다.
:::

### Example 29 {:#example-29}

<img src='/assets/images/docs/ui/layout/layout-29.png' class="mw-100" alt="Example 29 layout">

<?code-excerpt "lib/main.dart (Example29)" replace="/(return |;)//g"?>
```dart
Scaffold(
  body: SizedBox.expand(
    child: Container(
      color: blue,
      child: const Column(
        children: [
          Text('Hello!'),
          Text('Goodbye!'),
        ],
      ),
    ),
  ),
)
```

`Scaffold`의 자식이 `Scaffold` 자체와 정확히 같은 크기가 되게 하려면, 
자식을 `SizedBox.expand`로 래핑하면 됩니다.

## 엄격한(Tight) 제약 vs 느슨한(loose) 제약 {:#tight-vs-loose-constraints}

어떤 제약이 "엄격하다" 또는 "느슨하다"는 말을 흔히 듣습니다. 그러면 이는 무슨 뜻일까요?

### 엄격한 제약 {:#tight-constraints}

_tight_ 제약은 단일 가능성, 즉 정확한 크기를 제공합니다. 
즉, 엄격한 제약은 최대 너비가 최소 너비와 같고 최대 높이가 최소 높이와 같습니다.

이에 대한 예로는 [`RenderView`][] 클래스에 포함된 `App` 위젯이 있습니다. 
애플리케이션의 [`build`][] 함수에서 반환된 자식이 사용하는 상자에는, 
애플리케이션의 콘텐츠 영역(일반적으로 전체 화면)을 정확히 채우도록 하는 제약이 주어집니다.

또 다른 예로, 애플리케이션의 렌더 트리 루트에서 여러 상자를 서로 중첩하면, 
상자의 엄격한 제약에 의해 모두 서로 정확히 맞습니다.

Flutter의 `box.dart` 파일로 이동하여, `BoxConstraints` 생성자를 검색하면 다음을 찾을 수 있습니다.

```dart
BoxConstraints.tight(Size size)
   : minWidth = size.width,
     maxWidth = size.width,
     minHeight = size.height,
     maxHeight = size.height;
```

[예제 2](#example-2)를 다시 살펴보면, 화면은 빨간색 `Container`를 화면과 정확히 같은 크기로 강제합니다.
화면은 물론 `Container`에 엄격한 제약을 전달하여 이를 달성합니다.

### 느슨한 제약 {:#loose-constraints}

_느슨한_ 제약 조건은 최소값이 0이고, 최대값이 0이 아닌 제약 조건입니다.

일부 상자는 들어오는 제약 조건을 _느슨하게_ 합니다. 
즉, 최대값은 유지되지만 최소값은 제거되므로, 위젯은 **최소** 너비와 높이를 모두 **0**으로 설정할 수 있습니다.

궁극적으로, `Center`의 목적은 부모(화면)에게서 받은 엄격한 제약 조건을, 
자식(`Container`)의 느슨한 제약 조건으로 변환하는 것입니다.

[예제 3](#example-3)을 다시 살펴보면, 
`Center`는 빨간색 `Container`를 더 작게 만들 수 있지만, 
화면보다 크게 만들 수는 없습니다.

[`build`]: {{site.api}}/flutter/widgets/State/build.html
[`RenderView`]: {{site.api}}/flutter/rendering/RenderView-class.html

<a id="unbounded"></a>

## 무제한(Unbounded) 제약 {:#unbounded-constraints}

:::note
프레임워크가 상자 제약과 관련된 문제를 감지하면 여기로 안내될 수 있습니다. 
아래의 `Flex` 섹션도 적용될 수 있습니다.
:::

특정 상황에서, 상자의 제약 조건은 _무제한(unbounded)_ 또는 무한(infinite)합니다. 
즉, 최대 너비 또는 최대 높이가 [`double.infinity`][]로 설정됩니다.

가능한 한 크게 만들려는 상자는 무제한 제약 조건이 주어지면 유용하게 작동하지 않으며, 
디버그 모드에서 예외가 발생합니다.

렌더 상자가 무제한 제약 조건으로 끝나는 가장 일반적인 경우는, 
플렉스 상자 ([`Row`][] 또는 [`Column`][]) 내부와 
**스크롤 가능 영역** (예: [`ListView`][] 및 기타 [`ScrollView`][] 하위 클래스) 내부입니다.

예를 들어, [`ListView`][]는 교차 방향으로 사용 가능한 공간에 맞게 확장하려고 합니다.
(아마도 수직 스크롤 블록이고 부모만큼 넓으려고 할 것입니다)
수직 스크롤링 [`ListView`][]를 수평 스크롤링 `ListView` 안에 중첩하면, 
안쪽 리스트는 가능한 한 넓게 만들려고 하는데, 
바깥쪽 리스트는 그 방향으로 스크롤할 수 있기 때문에, 무한히 넓어집니다.

다음 섹션에서는 `Flex` 위젯에서 무제한 제약 조건으로 인해 발생할 수 있는 오류에 대해 설명합니다.

## Flex

flex 상자([`Row`][] 및 [`Column`][])는 
기본 방향(primary direction)에서 제약 조건이 제한되어 있는지 제한되지 않았는지에 따라 다르게 동작합니다.

기본 방향에서 제한된 제약 조건이 있는 flex 상자는 최대한 크게 만들려고 합니다.

기본 방향에서 제한되지 않은 제약 조건이 있는 flex 상자는 해당 공간에 자식을 맞추려고 합니다. 
각 자식의 `flex` 값은 0으로 설정해야 합니다. 
즉, flex 상자가 다른 flex 상자나 scrollable 안에 있는 경우, [`Expanded`][]를 사용할 수 없습니다. 
그렇지 않으면 예외가 발생합니다.

_교차(cross)_ 방향([`Column`][]의 너비 또는 [`Row`][]의 높이)은, 
_절대_ 제한되지 않아야 하며, 그렇지 않으면 자식을 합리적으로 정렬할 수 없습니다.

[`double.infinity`]: {{site.api}}/flutter/dart-core/double/infinity-constant.html
[`Expanded`]: {{site.api}}/flutter/widgets/Expanded-class.html
[`RenderBox`]: {{site.api}}/flutter/rendering/RenderBox-class.html
[`ScrollView`]: {{site.api}}/flutter/widgets/ScrollView-class.html

## 특정 위젯의 레이아웃 규칙 학습 {:#learning-the-layout-rules-for-specific-widgets}

일반 레이아웃 규칙을 아는 것은 필요하지만, 충분하지는 않습니다.

각 위젯은 일반 규칙을 적용할 때 많은 자유도가 있으므로, 
위젯의 이름만 읽어서는 위젯이 어떻게 작동하는지 알 수 없습니다.

추측하려고 하면, 아마 틀릴 것입니다. 
문서를 읽거나 소스 코드를 연구하지 않는 한, 위젯이 정확히 어떻게 작동하는지 알 수 없습니다.

레이아웃 소스 코드는 일반적으로 복잡하므로, 문서를 읽는 것이 더 나을 것입니다. 
그러나, 레이아웃 소스 코드를 연구하기로 결정했다면, IDE의 탐색 기능을 사용하여 쉽게 찾을 수 있습니다.

다음은 예입니다.

* 코드에서 `Column`을 찾아 소스 코드로 이동합니다. 
  * 이렇게 하려면, Android Studio나 IntelliJ에서 `command+B`(macOS) 또는 `control+B`(Windows/Linux)를 사용합니다. 
    * `basic.dart` 파일로 이동하게 될 것입니다. 
    * `Column`은 `Flex`를 확장하므로, `Flex` 소스 코드(`basic.dart`에도 있음)로 이동합니다.

* `createRenderObject()`라는 메서드를 찾을 때까지 아래로 스크롤합니다. 
  * 보시다시피, 이 메서드는 `RenderFlex`를 반환합니다. 
    * 이것은 `Column`의 렌더 객체입니다. 
  * 이제 `RenderFlex`의 소스 코드로 이동하면, `flex.dart` 파일로 이동합니다.

* `performLayout()`라는 메서드를 찾을 때까지 아래로 스크롤합니다. 
  * 이것은 `Column`의 레이아웃을 수행하는 메서드입니다.

<img src='/assets/images/docs/ui/layout/layout-final.png' class="mw-100" alt="A goodbye layout">

---

Marcelo Glasberg의 원본 글

Marcelo는 원래 이 콘텐츠를 [Flutter: 초보자도 알아야 하는 고급 레이아웃 규칙][article]로 Medium에 게시했습니다. 
우리는 그것을 좋아했고 docs.flutter.dev에 게시하도록 허락해 달라고 요청했고, 그는 기꺼이 동의했습니다. 감사합니다, Marcelo! Marcelo는 [GitHub][]과 [pub.dev][]에서 찾을 수 있습니다.

또한, 기사 맨 위에 헤더 이미지를 만들어 준 [Simon Lightfoot][]에게 감사드립니다.

[article]: {{site.medium}}/flutter-community/flutter-the-advanced-layout-rule-even-beginners-must-know-edc9516d1a2
[GitHub]: {{site.github}}/marcglasberg
[pub.dev]: {{site.pub}}/publishers/glasberg.dev/packages
[Simon Lightfoot]: {{site.github}}/slightfoot

:::note
Flutter가 레이아웃 제약 조건을 구현하는 방식을 더 잘 이해하려면, 다음 5분 분량의 비디오를 시청하세요.

{% ytEmbed 'jckqXR5CrPI', 'Flutter 디코딩: 무제한의(Unbounded) 높이와 너비' %}
:::
