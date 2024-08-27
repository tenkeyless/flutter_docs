---
# title: Hero animations
title: Hero 애니메이션
# description: How to animate a widget to fly between two screens.
description: 두 화면 사이를 이동하도록 위젯을 애니메이션으로 표시하는 방법.
short-title: Hero
---

:::secondary 학습할 내용
* _hero_ 는 화면 사이를 날아다니는 위젯을 말합니다.
* Flutter의 Hero 위젯을 사용하여 hero 애니메이션을 만듭니다.
* hero를 한 화면에서 다른 화면으로 날아다닙니다.
* hero의 모양이 원형에서 직사각형으로 변형되는 것을 애니메이션으로 표현하면서, 한 화면에서 다른 화면으로 날아다닙니다.
* Flutter의 Hero 위젯은 _공유 요소 전환(shared element transitions)_ 또는 _공유 요소 애니메이션(shared element animations)_ 이라고 일반적으로 알려진 애니메이션 스타일을 구현합니다.
:::

여러분은 아마도 Hero 애니메이션을 여러 번 보았을 것입니다. 
예를 들어, 화면에 판매 중인 아이템을 나타내는 썸네일 리스트가 표시됩니다. 
품목을 선택하면 더 자세한 내용과 "구매" 버튼이 있는 새 화면으로 이동합니다. 
Flutter에서는 이미지를 한 화면에서 다른 화면으로 이동하는 것을 _Hero 애니메이션(hero animation)_ 이라고 하지만, 
동일한 동작을 _공유 요소 전환(shared element transition)_ 이라고도 합니다.

Hero 위젯을 소개하는 이 1분 분량의 비디오를 시청해 보세요.

{% ytEmbed 'Be9UH1kXFDw', 'Hero | Flutter widget of the week' %}

이 가이드에서는 표준 Hero 애니메이션을 만드는 방법과,
비행 중에 이미지를 원형에서 사각형 모양으로 변환하는 Hero 애니메이션을 만드는 방법을 보여줍니다.

:::secondary 예시
이 가이드는 다음 링크에서 각 Hero 애니메이션 스타일의 예시를 제공합니다.

* [표준(Standard) Hero 애니메이션 코드][Standard hero animation code]
* [Radial Hero 애니메이션 코드][Radial hero animation code]
::

:::secondary Flutter를 처음 사용하시나요?
이 페이지에서는 Flutter 위젯을 사용하여 레이아웃을 만드는 방법을 알고 있다고 가정합니다. 
자세한 내용은 [Flutter에서 레이아웃 구축][Building Layouts in Flutter]을 참조하세요.
:::

:::tip 용어
[_Route_][]는 Flutter 앱의 페이지나 화면을 설명합니다.
:::

Flutter에서 Hero 위젯을 사용하여 이 애니메이션을 만들 수 있습니다. 
Hero가 소스에서 대상 route로 애니메이션을 적용하면, 대상 경로(Hero minus)가 사라집니다. 
일반적으로, Hero는 두 경로가 공통적으로 가지고 있는 (이미지와 같은) UI의 작은 부분입니다. 
사용자 관점에서 Hero는 경로 사이를 "날아다닙니다". 
이 가이드에서는 다음 Hero 애니메이션을 만드는 방법을 보여줍니다.

**표준(Standard) Hero 애니메이션**<br>

_표준(Standard) Hero 애니메이션_ 은 Hero를 한 경로에서 새 경로로 날리며, 일반적으로 다른 위치에 다른 크기로 착륙합니다.

다음 비디오(느린 속도로 녹화)는 일반적인 예를 보여줍니다. 
경로 중앙의 플리퍼를 탭하면 더 작은 크기의 새 파란색 경로의 왼쪽 상단 모서리로 날아갑니다. 
파란색 경로의 플리퍼를 탭하거나(또는 기기의 이전 경로로 돌아가기 제스처를 사용) 플리퍼를 원래 경로로 다시 날립니다.

{% ytEmbed 'CEcFnqRDfgw', 'Flutter의 표준 Hero 애니메이션' %}

**Radial Hero 애니메이션**<br>

_Radial Hero 애니메이션_ 에서 Hero가 경로 사이를 날아다닐 때, 모양이 원형에서 직사각형으로 바뀌는 것처럼 보입니다.

다음 영상(느린 속도로 녹화)은 Radial 영웅 애니메이션의 예를 보여줍니다. 
처음에, 경로 하단에 세 개의 원형 이미지 행이 나타납니다. 
원형 이미지 중 하나를 탭하면 해당 이미지가 정사각형 모양으로 표시되는 새 경로로 이동합니다. 
정사각형 이미지를, 탭하면 Hero가 원형 모양으로 표시되는 원래 경로로 돌아갑니다.

{% ytEmbed 'LWKENpwDKiM', 'Flutter의 Radial Hero 애니메이션' %}

[표준](#standard-hero-animations) 또는 [radial](#radial-hero-animations) hero 애니메이션에 대한 섹션으로 이동하기 전에, [hero 애니메이션의 기본 구조](#basic-structure)를 읽어, hero 애니메이션 코드를 구성하는 방법을 알아보고, [비하인드 스토리](#behind-the-scenes)를 읽어 Flutter가 hero 애니메이션을 수행하는 방식을 이해하세요.

<a id="basic-structure"></a>

## hero 애니메이션의 기본 구조 {:#basic-structure-of-a-hero-animation}

:::secondary 요점은 무엇인가요?
* 서로 다른 경로에서 두 개의 hero 위젯을 사용하지만, 태그가 일치하여 애니메이션을 구현합니다.
* Navigator는 앱의 경로를 포함하는 스택을 관리합니다.
* Navigator의 스택에서 경로를 푸시하거나 팝하면 애니메이션이 트리거됩니다.
* Flutter 프레임워크는 소스에서 대상 경로로 날아갈 때, hero의 경계를 정의하는 사각형 트윈 [`RectTween`][]을 계산합니다. 
  비행하는 동안, hero는 애플리케이션 오버레이로 이동하여, 두 경로 위에 나타납니다.
:::

:::tip 용어
tweens 또는 tweening의 개념이 생소하다면, [Flutter의 애니메이션 튜토리얼][Animations in Flutter tutorial]을 확인하세요.
:::

Hero 애니메이션은 두 개의 [`Hero`][] 위젯을 사용하여 구현됩니다. 
하나는 소스 경로의 위젯을 표현하고, 다른 하나는 대상 경로의 위젯을 표현합니다. 
사용자 관점에서 Hero는 공유되는 것처럼 보이고, 프로그래머만 이 구현 세부 사항을 이해하면 됩니다. 
Hero 애니메이션 코드는 다음과 같은 구조를 갖습니다.

1. _소스 hero_ 라고 하는 시작 hero 위젯을 정의합니다. 
   * hero는 그래픽 표현(일반적으로 이미지)과 식별 태그를 지정하고, 소스 경로에서 정의한 대로 현재 표시된 위젯 트리에 있습니다.
2. _대상 hero_ 라고 하는 종료 hero 위젯을 정의합니다. 
   * 이 hero도 그래픽 표현과 소스 hero와 동일한 태그를 지정합니다. 
   * 두 hero 위젯을 **모두 동일한 태그로 만드는 것이 필수적입니다.** 
     * 일반적으로 기본 데이터를 나타내는 객체입니다. 
     * 최상의 결과를 얻으려면, hero에 사실상 동일한 위젯 트리가 있어야 합니다.
3. 대상 hero가 포함된 경로를 만듭니다. 
   * 대상 경로는 애니메이션 끝에 있는 위젯 트리를 정의합니다.
4. Navigator의 스택에서 대상 경로를 푸시하여, 애니메이션을 트리거합니다. 
   * Navigator 푸시 및 팝 작업은 
     소스 및 대상 경로에서 일치하는 태그가 있는 각 hero 쌍에 대해 hero 애니메이션을 트리거합니다.

Flutter는 Hero의 경계를 시작점에서 끝점까지 애니메이션화하는 트윈을 계산하고(크기와 위치를 보간), 
오버레이에서 애니메이션을 수행합니다.

다음 섹션에서는 Flutter의 프로세스를 더 자세히 설명합니다.

## 비하인드 스토리 {:#behind-the-scenes}

다음은 Flutter가 한 경로에서 다른 경로로 전환하는 방법을 설명합니다.

![Before the transition the source hero appears in the source route](/assets/images/docs/ui/animations/hero-transition-0.png)

전환 전에, 소스 hero는 소스 경로의 위젯 트리에서 대기합니다. 
목적지 경로는 아직 존재하지 않으며, 오버레이는 비어 있습니다.

---

![The transition begins](/assets/images/docs/ui/animations/hero-transition-1.png)

`Navigator`로 경로를 푸시하면 애니메이션이 트리거됩니다. `t=0.0`에서, Flutter는 다음을 수행합니다.

* Material 모션 사양에 설명된 대로 곡선 모션을 사용하여, 화면 밖(offscreen)에서, 대상 hero의 경로를 계산합니다. 
  Flutter는 이제 hero가 어디에서 끝나는지 알고 있습니다.

* 오버레이에서 대상 hero를 _소스_ hero와 동일한 위치와 크기로 배치합니다. 
  오버레이에 hero를 추가하면, Z 순서가 변경되어 모든 경로 위에 표시됩니다.

* 소스 hero를 화면 밖(offscreen)으로 이동합니다.

---

![The hero flies in the overlay to its final position and size](/assets/images/docs/ui/animations/hero-transition-2.png)

hero가 날 때, 직사각형 경계는 hero의 [`createRectTween`][] 속성에서 지정된 [Tween&lt;Rect&gt;][]를 사용하여 애니메이션화됩니다. 
기본적으로, Flutter는 [`MaterialRectArcTween`][] 인스턴스를 사용하여, 
곡선 경로(curved path)를 따라, 직사각형의 반대 모서리를 애니메이션화합니다. 
(다른 Tween 애니메이션을 사용하는 예는 [Radial hero 애니메이션][Radial hero animations]를 참조하세요.)

---

![When the transition is complete, the hero is moved from the overlay to the destination route](/assets/images/docs/ui/animations/hero-transition-3.png)

비행이 완료되면:

* Flutter가 오버레이에서 목적지 route로 hero 위젯을 이동합니다. 오버레이는 이제 비어 있습니다.

* 목적지 hero가 목적지 route의 최종 위치에 나타납니다.

* 소스 hero가 route로 복원됩니다.

---

경로를 팝하면 동일한 프로세스가 수행되어, hero가 소스 route에서 원래 크기와 위치로 다시 애니메이션화됩니다.

### 필수 클래스 {:#essential-classes}

이 가이드의 예제에서는 다음 클래스를 사용하여 hero 애니메이션을 구현합니다.

[`Hero`][]
: 소스에서 대상 경로로 날아가는 위젯입니다. 
  소스 경로에 대해 하나의 hero를 정의하고, 대상 경로에 대해 다른 hero를 정의하고, 각각에 동일한 태그를 지정합니다. 
  Flutter는 일치하는 태그가 있는 hero 쌍을 애니메이션화합니다.

[`InkWell`][]
: hero를 탭할 때 발생하는 작업을 지정합니다. 
  `InkWell`의 `onTap()` 메서드는 새 경로를 빌드하여, `Navigator`의 스택에 푸시합니다.

[`Navigator`][]
: `Navigator`는 경로 스택을 관리합니다. 
  `Navigator`의 스택에서 경로를 푸시하거나 팝하면 애니메이션이 트리거됩니다.

[`Route`][]
: 화면이나 페이지를 지정합니다. 
  가장 기본적인 것 외에도 대부분의 앱에는 여러 경로가 있습니다.

## 1. 표준 hero 애니메이션 {:#standard-hero-animations}

:::secondary 요점은 무엇인가요?
* `MaterialPageRoute`, `CupertinoPageRoute`를 사용하여 경로를 지정하거나, 
  `PageRouteBuilder`를 사용하여 커스텀 경로를 빌드합니다. 
  이 섹션의 예에서는 MaterialPageRoute를 사용합니다.
* 대상 이미지를 `SizedBox`로 래핑하여, 전환이 끝날 때 이미지 크기를 변경합니다.
* 대상 이미지를 레이아웃 위젯에 배치하여 이미지 위치를 변경합니다. 
  이 예에서는 `Container`를 사용합니다.
:::

<a id="standard-hero-animation-code"></a>

:::secondary 표준 hero 애니메이션 코드
다음의 각 예는 이미지를 한 경로에서 다른 경로로 비행하는 것을 보여줍니다. 이 가이드에서는 첫 번째 예를 설명합니다.

[hero_animation][]
: 커스텀 `PhotoHero` 위젯에 hero 코드를 캡슐화합니다. 
  Material 모션 사양에 설명된 대로 곡선 경로를 따라 hero의 동작을 애니메이션화합니다.

[basic_hero_animation][]
: hero 위젯을 직접 사용합니다. 
  참조용으로 제공된 보다 기본적인 이 예제는 이 가이드에서 설명하지 않습니다.
:::

### 무슨 일이 일어나고 있나요? {:#whats-going-on}

Flutter의 hero 위젯을 사용하면, 이미지를 한 경로에서 다른 경로로 날아가는 것을 쉽게 구현할 수 있습니다. 
`MaterialPageRoute`를 사용하여 새 경로를 지정하면, 
이미지는 [Material Design 모션 사양][Material Design motion spec]에서 설명한 대로 곡선 경로(curved path)를 따라 이동합니다.

[새 Flutter 예제 만들기][Create a new Flutter example]를 실행하고, [hero_animation][]의 파일을 사용하여 업데이트합니다.

예제를 실행하려면 다음을 수행합니다.

* 홈 경로의 사진을 탭하여 다른 위치와 다른 크기로 같은 사진을 보여주는 새 경로로 이미지를 날립니다.
* 이미지를 탭하거나, 기기의 이전 경로로 돌아가기 제스처를 사용하여, 이전 경로로 돌아갑니다.
* `timeDilation` 속성을 사용하여 전환 속도를 더 늦출 수 있습니다.

### PhotoHero 클래스 {:#photohero-class}

커스텀 PhotoHero 클래스는 hero와 탭했을 때의 크기, 이미지, 동작을 유지합니다. 
PhotoHero는 다음 위젯 트리를 빌드합니다.

<div class="text-center mb-4">

  ![PhotoHero class widget tree](/assets/images/docs/ui/animations/photohero-class.png)

</div>

코드는 다음과 같습니다.

```dart
class PhotoHero extends StatelessWidget {
  const PhotoHero({
    super.key,
    required this.photo,
    this.onTap,
    required this.width,
  });

  final String photo;
  final VoidCallback? onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Hero(
        tag: photo,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Image.asset(
              photo,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
```

주요 정보:

* `HeroAnimation`이 앱의 홈 속성으로 제공되면, `MaterialApp`에서 시작 경로를 암묵적으로 푸시합니다.
* `InkWell`은 이미지를 래핑하여, 소스 및 대상 hero에 탭 제스처를 추가하는 것을 쉽게 만듭니다.
* Material 위젯을 투명한 색상으로 정의하면, 이미지가 대상으로 날아갈 때 배경에서 "튀어나옵니다(pop out)".
* `SizedBox`는 애니메이션의 시작과 끝에서 hero의 크기를 지정합니다.
* 이미지의 `fit` 속성을 `BoxFit.contain`으로 설정하면, 
  종횡비를 변경하지 않고도 전환 중에 이미지가 가능한 한 크게 표시됩니다.

### HeroAnimation 클래스 {:#heroanimation-class}

`HeroAnimation` 클래스는 소스 및 대상 PhotoHeroes를 생성하고, 전환을 설정합니다.

코드는 다음과 같습니다.

```dart
class HeroAnimation extends StatelessWidget {
  const HeroAnimation({super.key});

  Widget build(BuildContext context) {
    [!timeDilation = 5.0; // 1.0은 일반적인 애니메이션 속도를 의미합니다.!]

    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Hero Animation'),
      ),
      body: Center(
        [!child: PhotoHero(!]
          photo: 'images/flippers-alpha.png',
          width: 300.0,
          [!onTap: ()!] {
            [!Navigator.of(context).push(MaterialPageRoute<void>(!]
              [!builder: (context)!] {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Flippers Page'),
                  ),
                  body: Container(
                    // 새로운 경로라는 점을 강조하기 위해 배경을 파란색으로 설정하세요.
                    color: Colors.lightBlueAccent,
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.topLeft,
                    [!child: PhotoHero(!]
                      photo: 'images/flippers-alpha.png',
                      width: 100.0,
                      [!onTap: ()!] {
                        [!Navigator.of(context).pop();!]
                      },
                    ),
                  ),
                );
              }
            ));
          },
        ),
      ),
    );
  }
}
```

주요 정보:

* 사용자가 소스 hero가 포함된 `InkWell`을 탭하면, 코드는 `MaterialPageRoute`를 사용하여 대상 경로를 만듭니다. 
  대상 경로를 `Navigator`의 스택으로 푸시하면, 애니메이션이 트리거됩니다.
* `Container`는 `PhotoHero`를 대상 경로의 왼쪽 상단 모서리, `AppBar` 아래에 배치합니다.
* 대상 `PhotoHero`의 `onTap()` 메서드는 `Navigator`의 스택을 팝하여, 
  `Hero`를 원래 경로로 다시 날아가는 애니메이션을 트리거합니다.
* 디버깅하는 동안 전환 속도를 늦추려면 `timeDilation` 속성을 사용합니다.

---

## 2. Radial hero 애니메이션 {:#radial-hero-animations}

:::secondary 요점은 무엇인가요?
* _radial 변환_ 은 원형 모양을 정사각형 모양으로 애니메이션화합니다.
* radial _hero_ 애니메이션은 hero를 소스 경로에서 대상 경로로 비행하는 동안 radial 변환을 수행합니다.
* MaterialRectCenter&shy;Arc&shy;Tween은 트윈 애니메이션을 정의합니다.
* `PageRouteBuilder`를 사용하여 대상 경로를 빌드합니다.
:::

원형에서 직사각형 모양으로 변형되면서 한 경로에서 다른 경로로 hero를 날리는 것은, 
hero 위젯을 사용하여 구현할 수 있는 멋진 효과입니다. 
이를 달성하기 위해, 코드는 두 클립 모양인 원과 사각형의 교차점을 애니메이션화합니다. 
애니메이션 전체에서, 원형 클립(및 이미지)은 `minRadius`에서 `maxRadius`로 확장되는 반면, 사각형 클립은 일정한 크기를 유지합니다. 
동시에, 이미지는 소스 경로의 위치에서 대상 경로의 위치로 날아갑니다. 
이 전환의 시각적 예는 Material 모션 사양의 [Radial 변환][Radial transformation]을 참조하세요.

이 애니메이션은 복잡해 보일 수 있지만(실제로 그렇습니다), **제공된 예를 필요에 맞게 커스터마이즈 할 수 있습니다.** 
힘든 작업은 이미 끝났습니다.

<a id="radial-hero-animation-code"></a>

:::secondary Radial hero 애니메이션 코드
다음의 각 예는 Radial hero 애니메이션을 보여줍니다. 이 가이드에서는 첫 번째 예를 설명합니다.

[radial_hero_animation][]
: Material 모션 사양에 설명된 radial hero 애니메이션입니다.

[basic_radial_hero_animation][]
: radial hero 애니메이션의 가장 간단한 예입니다. 
  대상 경로에는 Scaffold, Card, Column 또는 Text가 없습니다. 
  참조용으로 제공된 이 기본 예제는, 이 가이드에 설명되어 있지 않습니다.

[radial_hero_animation_animate<wbr>_rectclip][]
: 직사각형 클립의 크기를 애니메이션화하여 radial_hero_animation을 확장합니다. 
  참조용으로 제공된 이 고급 예제는, 이 가이드에 설명되어 있지 않습니다.
:::

:::tip 프로 팁
radial hero 애니메이션은 둥근 모양과 정사각형 모양을 교차하는 것을 포함합니다. 
`timeDilation`으로 애니메이션 속도를 늦추더라도 보기 어려울 수 있으므로, 
개발 중에 [`debugPaintSizeEnabled`][] 플래그를 활성화하는 것을 고려할 수 있습니다.
:::

### 무슨 일이 일어나고 있나요? {:#whats-going-on-1}

다음 다이어그램은 애니메이션의 시작 부분(`t = 0.0`)과 끝 부분(`t = 1.0`)의 클립된 이미지를 보여줍니다.

![Radial transformation from beginning to end](/assets/images/docs/ui/animations/radial-hero-animation.png)

파란색 그라데이션(이미지를 나타냄)은, 클립 모양이 교차하는 위치를 나타냅니다. 
전환이 시작될 때, 교차의 결과는 원형 클립([`ClipOval`][])입니다. 
변환 중에, `ClipOval`은 `minRadius`에서 `maxRadius`로 확장되는 반면, [ClipRect][]는 일정한 크기를 유지합니다. 
전환이 끝날 때, 원형 및 직사각형 클립의 교차는 hero 위젯과 같은 크기의 직사각형을 생성합니다. 
즉, 전환이 끝날 때 이미지는 더 이상 clip 되지 않습니다.

[새 Flutter 예제 만들기][Create a new Flutter example] 및 [radial_hero_animation][] GitHub 디렉토리의 파일을 사용하여 업데이트합니다.

예제를 실행하려면:

* 세 개의 원형 썸네일 중 하나를 탭하여 이미지를 새로운 경로의 중앙에 위치한 더 큰 사각형으로 애니메이션화하여 원래 경로를 가립니다.
* 이미지를 탭하거나 장치의 이전 경로로 돌아가기 제스처를 사용하여, 이전 경로로 돌아갑니다.
* `timeDilation` 속성을 사용하여 전환 속도를 더 늦출 수 있습니다.

### Photo 클래스 {:#photo-class}

`Photo` 클래스는 이미지를 보관하는 위젯 트리를 구축합니다.

```dart
class Photo extends StatelessWidget {
  const Photo({super.key, required this.photo, this.color, this.onTap});

  final String photo;
  final Color? color;
  final VoidCallback onTap;

  Widget build(BuildContext context) {
    return [!Material(!]
      // 이미지에 투명한 부분이 있으면 약간 불투명한 색상이 나타납니다.
      [!color: Theme.of(context).primaryColor.withOpacity(0.25),!]
      child: [!InkWell(!]
        onTap: [!onTap,!]
        child: [!Image.asset(!]
          photo,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
```

주요 정보:

* `InkWell`은 탭 제스처를 캡처합니다. 
  * 호출하는 함수는 `onTap()` 함수를 `Photo`의 생성자에 전달합니다.
* 비행 중에, `InkWell`은 첫 번째 Material 조상에 스플래시를 그립니다.
* Material 위젯은 약간 불투명한 색상을 가지고 있으므로, 이미지의 투명한 부분은 색상으로 렌더링됩니다. 
  * 이렇게 하면 투명한 이미지에서도, 원에서 사각형으로의 전환을 쉽게 볼 수 있습니다.
* `Photo` 클래스는 위젯 트리에 `Hero`를 포함하지 않습니다. 
  * 애니메이션이 작동하려면, hero가 `RadialExpansion` 위젯을 래핑합니다.

### RadialExpansion 클래스 {:#radialexpansion-class}

데모의 핵심인, `RadialExpansion` 위젯은, 전환 중에 이미지를 클립하는 위젯 트리를 빌드합니다. 
클립된 모양은 원형 클립(비행 중에 커짐)과 직사각형 클립(전체적으로 일정한 크기 유지)의 교차점에서 발생합니다.

이를 위해, 다음 위젯 트리를 빌드합니다.

<div class="text-center mb-4">

  ![RadialExpansion widget tree](/assets/images/docs/ui/animations/radial-expansion-class.png)

</div>

코드는 다음과 같습니다.

```dart
class RadialExpansion extends StatelessWidget {
  const RadialExpansion({
    super.key,
    required this.maxRadius,
    this.child,
  }) : [!clipRectSize = 2.0 * (maxRadius / math.sqrt2);!]

  final double maxRadius;
  final clipRectSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return [!ClipOval(!]
      child: [!Center(!]
        child: [!SizedBox(!]
          width: clipRectSize,
          height: clipRectSize,
          child: [!ClipRect(!]
            child: [!child,!] // Photo
          ),
        ),
      ),
    );
  }
}
```

주요 정보:

* hero는 `RadialExpansion` 위젯을 래핑합니다.
* hero가 날아가면서 크기가 변경되고, 자식의 크기를 제한하기 때문에 `RadialExpansion` 위젯의 크기가 일치하도록 변경됩니다.
* `RadialExpansion` 애니메이션은 두 개의 겹치는 클립으로 만들어집니다.
* 이 예에서는 [`MaterialRectCenterArcTween`][]을 사용하여 tweening 보간을 정의합니다. 
  * hero 애니메이션의 기본 비행 경로는 hero의 모서리를 사용하여 트윈을 보간합니다. 
  * 이 접근 방식은 radial 변환 중에 hero의 종횡비에 영향을 미치므로, 
    새 비행 경로는 `MaterialRectCenterArcTween`을 사용하여 각 hero의 중심점을 사용하여 트윈을 보간합니다.

  코드는 다음과 같습니다.

  ```dart
  static RectTween _createRectTween(Rect? begin, Rect? end) {
    return MaterialRectCenterArcTween(begin: begin, end: end);
  }
  ```

  hero의 비행 경로는 여전히 호(arc)를 따라가지만, 이미지의 종횡비는 일정하게 유지됩니다.

[Animations in Flutter tutorial]: /ui/animations/tutorial
[basic_hero_animation]: {{site.repo.this}}/tree/{{site.branch}}/examples/_animation/basic_hero_animation/
[basic_radial_hero_animation]: {{site.repo.this}}/tree/{{site.branch}}/examples/_animation/basic_radial_hero_animation
[Building Layouts in Flutter]: /ui/layout
[`ClipOval`]: {{site.api}}/flutter/widgets/ClipOval-class.html
[ClipRect]: {{site.api}}/flutter/widgets/ClipRect-class.html
[Create a new Flutter example]: /get-started/test-drive
[`createRectTween`]: {{site.api}}/flutter/widgets/CreateRectTween.html
[`debugPaintSizeEnabled`]: /tools/devtools/inspector#debugging-layout-issues-visually
[`Hero`]: {{site.api}}/flutter/widgets/Hero-class.html
[hero_animation]: {{site.repo.this}}/tree/{{site.branch}}/examples/_animation/hero_animation/
[`InkWell`]: {{site.api}}/flutter/material/InkWell-class.html
[Material Design motion spec]: {{site.material2}}/design/motion/understanding-motion.html#principles
[`MaterialRectArcTween`]: {{site.api}}/flutter/material/MaterialRectArcTween-class.html
[`MaterialRectCenterArcTween`]: {{site.api}}/flutter/material/MaterialRectCenterArcTween-class.html
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[Radial hero animation code]: #radial-hero-animation-code
[radial_hero_animation]: {{site.repo.this}}/tree/{{site.branch}}/examples/_animation/radial_hero_animation
[radial_hero_animation_animate<wbr>_rectclip]: {{site.repo.this}}/tree/{{site.branch}}/examples/_animation/radial_hero_animation_animate_rectclip
[Radial hero animations]: #radial-hero-animations
[Radial transformation]: https://web.archive.org/web/20180223140424/https://material.io/guidelines/motion/transforming-material.html
[`RectTween`]: {{site.api}}/flutter/animation/RectTween-class.html
[_Route_]: /cookbook/navigation/navigation-basics
[`Route`]: {{site.api}}/flutter/widgets/Route-class.html
[Standard hero animation code]: #standard-hero-animation-code
[Tween&lt;Rect&gt;]: {{site.api}}/flutter/animation/Tween-class.html
