---
# title: Staggered animations
title: 단계적(Staggered) 애니메이션
# description: How to write a staggered animation in Flutter.
description: Flutter에서 단계적 애니메이션을 작성하는 방법.
short-title: 단계적(Staggered)
---

:::secondary 학습할 내용
* 단계적(Staggered) 애니메이션은 순차적이거나 겹치는 애니메이션으로 구성됩니다.
* 단계적 애니메이션을 만들려면, 여러 개의 `Animation` 객체를 사용합니다.
* 하나의 `AnimationController`가 모든 `Animation`을 제어합니다.
* 각 `Animation` 객체는 `Interval` 동안 애니메이션을 지정합니다.
* 애니메이션을 적용하는 각 속성에 대해, `Tween`을 만듭니다.
:::

:::tip 용어
tweens 또는 tweening 개념이 생소하다면 [Flutter 튜토리얼의 애니메이션][Animations in Flutter tutorial]을 참조하세요.
:::

단계적(Staggered) 애니메이션은 간단한 개념입니다. 시각적 변화는 한꺼번에 일어나는 것이 아니라, 일련의 작업으로 일어납니다. 
애니메이션은 순전히 순차적일 수 있으며, 한 가지 변화가 다음 변화 이후에 발생하거나, 부분적으로 또는 완전히 겹칠 수 있습니다. 
또한, 변화가 발생하지 않는 갭이 있을 수도 있습니다.

이 가이드는 Flutter에서 단계적 애니메이션을 빌드하는 방법을 보여줍니다.

:::secondary 예제
이 가이드에서는 basic_staggered_animation 예제를 설명합니다. 
더 복잡한 예제인, staggered_pic_selection도 참조할 수 있습니다.

[basic_staggered_animation][]
: 단일 위젯의 연속적이고 겹치는 일련의 애니메이션을 보여줍니다. 
  화면을 탭하면 불투명도, 크기, 모양, 색상 및 패딩을 변경하는 애니메이션이 시작됩니다.

[staggered_pic_selection][]
: 세 가지 크기 중 하나로 표시된 이미지 리스트에서 이미지를 삭제하는 것을 보여줍니다. 
  이 예제에서는 두 개의 [animation controller][]를 사용합니다. 
  (1) 하나는 이미지 선택/선택 해제용이고, (2) 다른 하나는 이미지 삭제용입니다. 
  선택/선택 해제 애니메이션은 단계적입니다. (이 효과를 보려면, `timeDilation` 값을 늘려야 할 수도 있습니다.) 
  가장 큰 이미지 중 하나를 선택합니다. 파란색 원 안에 체크 표시가 표시되면서 축소됩니다. 
  그런 다음, 가장 작은 이미지 중 하나를 선택합니다. 체크 표시가 사라지면서 큰 이미지가 확장됩니다. 
  큰 이미지가 확장을 완료하기 전에, 작은 이미지가 축소되어 체크 표시가 표시됩니다. 
  이러한 단계적 동작은 Google Photos에서 볼 수 있는 것과 비슷합니다.
:::

다음 비디오는 basic_staggered_animation이 수행하는 애니메이션을 보여줍니다.

{% ytEmbed '0fFvnZemmh8', '단계적 애니메이션 예제', true %}

비디오에서, 모서리가 약간 둥근 테두리가 있는 파란색 사각형으로 시작하는, 단일 위젯의 다음 애니메이션을 볼 수 있습니다. 
사각형은 다음 순서로 변경됩니다.

1. 페이드 인
2. 넓어짐
3. 위로 이동하면서 더 높아짐
4. 테두리가 있는 원으로 변형
5. 색상이 주황색으로 변경

앞으로 실행한 후, 애니메이션은 역순으로 실행됩니다.

:::secondary Flutter를 처음 사용하시나요?
이 페이지에서는 Flutter 위젯을 사용하여 레이아웃을 만드는 방법을 알고 있다고 가정합니다. 
자세한 내용은 [Flutter에서 레이아웃 구축][Building Layouts in Flutter]을 참조하세요.
:::

## 단계적 애니메이션의 기본 구조 {:#basic-structure-of-a-staggered-animation}

:::secondary 요점은 무엇인가요?
* 모든 애니메이션은 동일한 [`AnimationController`][]에 의해 구동됩니다.
* 애니메이션이 실시간으로 얼마나 오래 지속되든, 컨트롤러의 값은 0.0~1.0 사이여야 합니다.
* 각 애니메이션에는 0.0~1.0 사이의 [`Interval`][]이 있습니다.
* 간격으로 애니메이션을 적용하는 각 속성에 대해 [`Tween`][]을 만듭니다. 
  * `Tween`은 해당 속성의 시작 및 종료 값을 지정합니다.
* `Tween`은 컨트롤러가 관리하는 [`Animation`][] 객체를 생성합니다.
:::

{% comment %}
The app is essentially animating a `Container` whose
decoration and size are animated. The `Container`
is within another `Container` whose padding moves the
inner container around and an `Opacity` widget that's
used to fade everything in and out.
{% endcomment %}

다음 다이어그램은 [basic_staggered_animation][] 예제에서 사용된 `Interval`을 보여줍니다. 
다음과 같은 특징이 눈에 띄실 수 있습니다.

* 불투명도는 타임라인의 처음 10% 동안 변경됩니다.
* 불투명도의 변화와 너비의 변화 사이에 작은 간격이 발생합니다.
* 타임라인의 마지막 25% 동안은 아무것도 애니메이션화되지 않습니다.
* 패딩을 늘리면 위젯이 위로 올라가는 것처럼 보입니다.
* 테두리 반경을 0.5로 늘리면, 모서리가 둥근 사각형이 원으로 변환됩니다.
* 패딩과 높이의 변화는 정확히 같은 간격 동안 발생하지만 반드시 그럴 필요는 없습니다.

![Diagram showing the interval specified for each motion](/assets/images/docs/ui/animations/StaggeredAnimationIntervals.png)

애니메이션을 설정하려면:

* 모든 `Animations`를 관리하는 `AnimationController`를 만듭니다.
* 애니메이션을 적용하는 각 속성에 대해 `Tween`을 만듭니다.
  * `Tween`은 값 범위를 정의합니다.
  * `Tween`의 `animate` 메서드는 `parent` 컨트롤러를 필요로 하며, 해당 속성에 대해 `Animation`을 생성합니다.
* `Animation`의 `curve` 속성에 간격을 지정합니다.

제어하는 애니메이션의 값이 변경되면, 새 애니메이션의 값이 변경되어, UI가 업데이트됩니다.

다음 코드는 `width` 속성에 대한 트윈을 만듭니다. 
[`CurvedAnimation`][]을 빌드하여 완화된 곡선(eased curve)을 지정합니다. 
사용 가능한 다른 사전 정의된 애니메이션 곡선은 [`Curves`][]를 참조하세요.

```dart
width = Tween<double>(
  begin: 50.0,
  end: 150.0,
).animate(
  CurvedAnimation(
    parent: controller,
    curve: const Interval(
      0.125,
      0.250,
      curve: Curves.ease,
    ),
  ),
),
```

`begin`과 `end` 값은 double일 필요가 없습니다. 
다음 코드는 `borderRadius` 속성(사각형 모서리의 둥글기를 제어)에 대한 트윈을 `BorderRadius.circular()`를 사용하여 빌드합니다.

```dart
borderRadius = BorderRadiusTween(
  begin: BorderRadius.circular(4),
  end: BorderRadius.circular(75),
).animate(
  CurvedAnimation(
    parent: controller,
    curve: const Interval(
      0.375,
      0.500,
      curve: Curves.ease,
    ),
  ),
),
```

### 단계적 애니메이션 완성 {:#complete-staggered-animation}

모든 상호 작용 위젯과 마찬가지로, 완전한 애니메이션은 위젯 쌍으로 구성됩니다. stateless 위젯과 stateful 위젯입니다.

stateless 위젯은 `Tween`을 지정하고, `Animation` 객체를 정의하고, 
위젯 트리의 애니메이션 부분을 빌드하는 `build()` 함수를 제공합니다.

stateful 위젯은 컨트롤러를 생성하고, 애니메이션을 재생하고, 위젯 트리의 애니메이션이 아닌 부분을 빌드합니다. 
애니메이션은 화면의 어느 곳에서나 탭이 감지되면 시작됩니다.

[basic_staggered_animation의 main.dart에 대한 전체 코드][Full code for basic_staggered_animation's main.dart]

### Stateless 위젯: StaggerAnimation {:#stateless-widget-staggeranimation}

stateless 위젯인 `StaggerAnimation`에서, `build()` 함수는 (애니메이션을 빌드하기 위한 범용 위젯인) [`AnimatedBuilder`][]를 인스턴스화합니다. 
`AnimatedBuilder`는 위젯을 빌드하고 `Tweens`의 현재 값을 사용하여 구성합니다. 
이 예제에서는 `_buildAnimation()`(실제 UI 업데이트를 수행)이라는 함수를 생성하고, `builder` 속성에 할당합니다. 
AnimatedBuilder는 애니메이션 컨트롤러의 알림을 수신하여, 값이 변경되면 위젯 트리를 더티(dirty)로 표시합니다. 
애니메이션의 각 틱에 대해 값이 업데이트되어, `_buildAnimation()`이 호출됩니다.

```dart
[!class StaggerAnimation extends StatelessWidget!] {
  StaggerAnimation({super.key, required this.controller}) :

    // 여기에 정의된 각 애니메이션은 애니메이션 interval로 정의된 컨트롤러 duration의 subset 동안 값을 변환합니다. 
    // 예를 들어, opacity 애니메이션은 컨트롤러 duration의 처음 10% 동안 값을 변환합니다.

    [!opacity = Tween<double>!](
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(
          0.0,
          0.100,
          curve: Curves.ease,
        ),
      ),
    ),

    // ... 기타 tween 정의 ...
    );

  [!final AnimationController controller;!]
  [!final Animation<double> opacity;!]
  [!final Animation<double> width;!]
  [!final Animation<double> height;!]
  [!final Animation<EdgeInsets> padding;!]
  [!final Animation<BorderRadius?> borderRadius;!]
  [!final Animation<Color?> color;!]

  // 이 함수는 컨트롤러가 새 프레임을 "틱"할 때마다 호출됩니다. 
  // 실행되면, 모든 애니메이션 값이 컨트롤러의 현재 값을 반영하도록 업데이트됩니다.
  [!Widget _buildAnimation(BuildContext context, Widget? child)!] {
    return Container(
      padding: padding.value,
      alignment: Alignment.bottomCenter,
      child: Opacity(
        opacity: opacity.value,
        child: Container(
          width: width.value,
          height: height.value,
          decoration: BoxDecoration(
            color: color.value,
            border: Border.all(
              color: Colors.indigo[300]!,
              width: 3,
            ),
            borderRadius: borderRadius.value,
          ),
        ),
      ),
    );
  }

  @override
  [!Widget build(BuildContext context)!] {
    return [!AnimatedBuilder!](
      [!builder: _buildAnimation!],
      animation: controller,
    );
  }
}
```

### Stateful 위젯: StaggerDemo {:#stateful-widget-staggerdemo}

stateful 위젯인 `StaggerDemo`는 `AnimationController`(모든 것을 지배하는 컨트롤러)를 생성하여, 2000ms duration을 지정합니다. 
애니메이션을 재생하고, 위젯 트리의 애니메이션이 아닌 부분을 빌드합니다. 
애니메이션은 화면에서 탭이 감지되면 시작됩니다. 
애니메이션은 앞으로 실행된 다음, 뒤로 실행됩니다.

```dart
[!class StaggerDemo extends StatefulWidget!] {
  @override
  State<StaggerDemo> createState() => _StaggerDemoState();
}

class _StaggerDemoState extends State<StaggerDemo>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
  }

  // ...Boilerplate...

  [!Future<void> _playAnimation() async!] {
    try {
      [!await _controller.forward().orCancel;!]
      [!await _controller.reverse().orCancel;!]
    } on TickerCanceled {
      // 애니메이션은 취소되었는데, 아마도 폐기되었기 때문일 겁니다.
    }
  }

  @override
  [!Widget build(BuildContext context)!] {
    timeDilation = 10.0; // 1.0은 일반적인 애니메이션 속도입니다.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staggered Animation'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _playAnimation();
        },
        child: Center(
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              border: Border.all(
                color:  Colors.black.withOpacity(0.5),
              ),
            ),
            child: StaggerAnimation(controller:_controller.view),
          ),
        ),
      ),
    );
  }
}
```

[`Animation`]: {{site.api}}/flutter/animation/Animation-class.html
[animation controllers]: {{site.api}}/flutter/animation/AnimationController-class.html
[`AnimationController`]: {{site.api}}/flutter/animation/AnimationController-class.html
[`AnimatedBuilder`]: {{site.api}}/flutter/widgets/AnimatedBuilder-class.html
[Animations in Flutter tutorial]: /ui/animations/tutorial
[basic_staggered_animation]: {{site.repo.this}}/tree/{{site.branch}}/examples/_animation/basic_staggered_animation
[Building Layouts in Flutter]: /ui/layout
[staggered_pic_selection]: {{site.repo.this}}/tree/{{site.branch}}/examples/_animation/staggered_pic_selection
[`CurvedAnimation`]: {{site.api}}/flutter/animation/CurvedAnimation-class.html
[`Curves`]: {{site.api}}/flutter/animation/Curves-class.html
[Full code for basic_staggered_animation's main.dart]: {{site.repo.this}}/tree/{{site.branch}}/examples/_animation/basic_staggered_animation/lib/main.dart
[`Interval`]: {{site.api}}/flutter/animation/Interval-class.html
[`Tween`]: {{site.api}}/flutter/animation/Tween-class.html
