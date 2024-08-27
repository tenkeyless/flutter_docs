---
# title: Animations API overview
title: 애니메이션 API 개요
# short-title: API overview
short-title: API 개요
# description: An overview of animation concepts.
description: 애니메이션 개념 개요.
---

Flutter의 애니메이션 시스템은 타입이 지정된 [`Animation`][] 객체를 기반으로 합니다. 
위젯은 현재 값을 읽고 상태 변경을 수신하여 이러한 애니메이션을 빌드 함수에 직접 통합하거나, 
애니메이션을 다른 위젯에 전달하는 보다 정교한 애니메이션의 기반으로 사용할 수 있습니다.

## Animation {:#animation}

애니메이션 시스템의 주요 빌딩 블록은 [`Animation`][] 클래스입니다. 
애니메이션은 애니메이션의 수명 동안 변경될 수 있는 특정 타입의 값을 나타냅니다. 
애니메이션을 수행하는 대부분의 위젯은 매개변수로 `Animation` 객체를 수신하고, 
여기에서 애니메이션의 현재 값을 읽고 해당 값의 변경 사항을 수신합니다.

### `addListener` {:#addlistener}

애니메이션의 값이 변경될 때마다, 애니메이션은 [`addListener`][]로 추가된 모든 리스너에 알립니다. 
일반적으로, 애니메이션을 수신하는 [`State`][] 객체는 리스너 콜백에서 자체적으로 [`setState`][]를 호출하여, 
위젯 시스템에 애니메이션의 새 값으로 다시 빌드해야 함을 알립니다.

이 패턴은 매우 일반적이어서 애니메이션 값이 변경될 때 위젯을 다시 빌드하는 데 도움이 되는 위젯이 두 개 있습니다. [`AnimatedWidget`][]과 [`AnimatedBuilder`][]입니다. 
(1) 첫 번째, `AnimatedWidget`은 stateless 애니메이션 위젯에 가장 유용합니다. 
`AnimatedWidget`을 사용하려면, 이를 서브클래싱하고 [`build`][] 함수를 구현하기만 하면 됩니다. 
(2) 두 번째 `AnimatedBuilder`는 더 큰 빌드 함수의 일부로 애니메이션을 포함하려는 보다 복잡한 위젯에 유용합니다. 
`AnimatedBuilder`를 사용하려면, 위젯을 구성하고 `builder` 함수를 전달하기만 하면 됩니다.

### `addStatusListener` {:#addstatuslistener}

애니메이션은 또한 애니메이션이 시간이 지남에 따라 어떻게 진화할지를 나타내는 [`AnimationStatus`][]를 제공합니다. 
애니메이션의 상태가 변경될 때마다, 애니메이션은 [`addStatusListener`][]로 추가된 모든 리스너에 알립니다. 
일반적으로, 애니메이션은 `dismissed` 상태에서 시작하는데, 이는 애니메이션이 범위의 시작에 있음을 의미합니다. 
예를 들어, 0.0에서 1.0으로 진행되는 애니메이션은 값이 0.0일 때 `dismissed`됩니다. 
그런 다음, 애니메이션은 `forward`(0.0에서 1.0) 또는 `reverse`(1.0에서 0.0)로 실행될 수 있습니다. 
결국, 애니메이션이 범위 끝(1.0)에 도달하면, 애니메이션은 `completed` 상태에 도달합니다.

## Animation&shy;Controller {:#animationcontroller}

애니메이션을 만들려면, 먼저 [`AnimationController`][]를 만듭니다. 
애니메이션 자체일 뿐만 아니라, `AnimationController`는 애니메이션을 제어할 수 있게 해줍니다. 
예를 들어, 컨트롤러에 애니메이션을 재생하도록 [`forward`][] 또는 [`stop`][]하도록 할 수 있습니다. 
(스프링과 같은) 물리적 시뮬레이션을 사용하여, 애니메이션을 구동하는, 애니메이션을 [`fling`][]할 수도 있습니다.

애니메이션 컨트롤러를 만든 후에는, 이를 기반으로 다른 애니메이션을 빌드할 수 있습니다. 
예를 들어, 원래 애니메이션을 미러링하지만 반대 방향(1.0에서 0.0)으로 실행되는 [`ReverseAnimation`][]을 만들 수 있습니다. 
마찬가지로, 값이 [`Curve`][]로 조정되는 [`CurvedAnimation`][]을 만들 수 있습니다.

## Tweens {:#tweens}

0.0~1.0 간격을 넘어 애니메이션을 적용하려면, [`Tween<T>`][]을 사용할 수 있습니다. 
이 함수는 [`begin`][]과 [`end`][] 값 사이를 보간합니다. 
많은 타입에는 타입별 보간을 제공하는 특정 `Tween` 하위 클래스가 있습니다. 
예를 들어, [`ColorTween`][]은 색상 사이를 보간하고, [`RectTween`][]은 사각형 사이를 보간합니다. 
`Tween`의 하위 클래스를 직접 만들고, [`lerp`][] 함수를 재정의하여, 고유한 보간을 정의할 수 있습니다.

트윈 자체는 두 값 사이를 보간하는 방법을 정의합니다. 
애니메이션의 현재 프레임에 대한 구체적인 값을 얻으려면, 현재 상태를 결정하는 애니메이션도 필요합니다. 
트윈을 애니메이션과 결합하여 구체적인 값을 얻는 방법에는 두 가지가 있습니다.

1. 애니메이션의 현재 값에서 트윈을 [`evaluate`][]할 수 있습니다. 
   이 접근 방식은 애니메이션을 이미 듣고 있고 애니메이션 값이 변경될 때마다 다시 빌드하는 위젯에 가장 유용합니다.

2. 애니메이션을 기반으로 트윈을 [`animate`][]할 수 있습니다. 
   animate 함수는 단일 값을 반환하는 대신, 트윈을 통합하는 새 `Animation`을 반환합니다. 
   이 접근 방식은 새로 만든 애니메이션을 다른 위젯에 제공하고, 
   그런 다음, 트윈을 통합하는 현재 값을 읽고 값의 변경을 수신할 수 있는 경우에 가장 유용합니다.

## Architecture {:#architecture}

애니메이션은 실제로 여러 개의 핵심 빌딩 블록으로 구성됩니다.

### Scheduler {:#scheduler}

[`SchedulerBinding`][]은 Flutter 스케줄링 primitives를 노출하는 싱글톤 클래스입니다.

이 논의에서, 핵심 primitive는 프레임 콜백입니다. 
프레임을 화면에 표시해야 할 때마다, Flutter 엔진은 스케줄러가 [`scheduleFrameCallback()`][]을 사용하여, 
등록된 모든 리스너에 다중화하는(multiplexes) "프레임 시작" 콜백을 트리거합니다. 
이러한 모든 콜백에는 임의의 에포크에서 `Duration` 형태로, 프레임의 공식 타임스탬프가 제공됩니다. 
모든 콜백의 시간이 동일하므로, 
이러한 콜백에서 트리거된 모든 애니메이션은 실행되는 데 몇 밀리초가 걸리더라도 정확히 동기화된 것처럼 보입니다.

### Tickers {:#tickers}

[`Ticker`][] 클래스는 스케줄러의 [`scheduleFrameCallback()`][] 메커니즘에 연결하여(hooks into) 매 틱마다 콜백을 호출합니다.

`Ticker`는 시작 및 중지할 수 있습니다. 시작되면, 중지될 때 해결(resolve)되는 `Future`를 반환합니다.

각 틱에서, `Ticker`는 시작된 후 첫 번째 틱 이후의 기간(duration)을 콜백에 제공합니다.

tickers는 항상 시작된 후 첫 번째 틱을 기준으로 경과 시간(elapsed time)을 제공하므로 티커는 모두 동기화됩니다. 
두 틱 사이에 다른 시간에 세 개의 티커를 시작하면, 모두 동일한 시작 시간으로 동기화되고, 이후에는(in lockstep) 동시에 틱합니다. 
버스 정류장의 사람들처럼, 모든 tickers는 정기적으로 발생하는 이벤트(틱)가 움직이기 시작할 때까지 기다립니다. (시간 계산)

### Simulations {:#simulations}

[`Simulation`][] 추상 클래스는 상대 시간 값(경과 시간)을 double 값에 매핑하고, 완료 개념을 갖습니다.

원칙적으로 시뮬레이션은 상태가 없지만, 
실제로 일부 시뮬레이션(예: [`BouncingScrollSimulation`][] 및 [`ClampingScrollSimulation`][])은 쿼리 시 상태가 되돌릴 수 없게(irreversibly) 변경됩니다.

다양한 효과에 대한 `Simulation` 클래스의 [다양한 구체적 구현][various concrete implementations]이 있습니다.

### Animatables {:#animatables}

[`Animatable`][] 추상 클래스는 double을 특정 타입의 값에 매핑합니다.

`Animatable` 클래스는 stateless 이고, 변경할 수 없습니다. (immutable)

#### Tweens {:#tweens-1}

`Tween` classes are stateless and immutable.

[`Tween<T>`][] 추상 클래스는 명목상 0.0-1.0 범위의 double 값을 타입화된 값(예: `Color` 또는 다른 double)에 매핑합니다. 

`Animatable`입니다.

출력 타입(`T`), 해당 타입의 `begin` 값 및 `end` 값, 주어진 입력 값에 대한 시작 값과 종료 값(명목상 0.0-1.0 범위의 double) 사이를 보간(`lerp`)하는 방법을 가지고 있습니다.

`Tween` 클래스는 상태가 없고 변경할 수 없습니다.

#### Animatables 구성하기 {:#composing-animatables}

`Animatable<double>`(부모)을 `Animatable`의 `chain()` 메서드에 전달하면, 
부모의 매핑을 적용한 다음 자식의 매핑을 적용하는 새로운 `Animatable` 하위 클래스가 생성됩니다.

### Curves {:#curves}

[`Curve`][] 추상 클래스는 명목상 0.0-1.0 범위의 double을 명목상 0.0-1.0 범위의 double로 매핑합니다.

`Curve` 클래스는 stateless 이고, 변경할 수 없습니다. (immutable)

### Animations {:#animations}

[`Animation`][] 추상 클래스는 주어진 타입의 값, 애니메이션 방향 및 애니메이션 상태의 개념, 값 또는 상태가 변경될 때 호출되는 콜백을 등록하기 위한 리스너 인터페이스를 제공합니다.

`Animation`의 일부 하위 클래스는 절대 변경되지 않는 값을 갖습니다. ([`kAlwaysCompleteAnimation`][], [`kAlwaysDismissedAnimation`][], [`AlwaysStoppedAnimation`][]) 
이러한 하위 클래스에 콜백을 등록해도 콜백이 호출되지 않으므로 아무런 효과가 없습니다.

`Animation<double>` 변형은, `Curve` 및 `Tween` 클래스와 `Animation`의 일부 하위 클래스에서 기대하는 입력인, 
0.0-1.0 범위의 double을 나타내는 데 사용할 수 있기 때문에 특별합니다.

일부 `Animation` 하위 클래스는 stateless 이며, 리스너를 부모에게 전달하기만 합니다. 일부는 매우 stateful 입니다.

#### 애니메이션 구성하기 {:#composable-animations}

대부분의 `Animation` 하위 클래스는 명시적인 "부모"인 `Animation<double>`을 사용합니다. 
이들은 해당 부모에 의해 구동됩니다.

`CurvedAnimation` 하위 클래스는 `Animation<double>` 클래스(부모)와 몇 개의 `Curve` 클래스(forward 및 reverse 커브)를 입력으로 사용하고, 부모의 값을 커브에 대한 입력으로 사용하여 출력을 결정합니다. 
`CurvedAnimation`은 변경 불가능(immutable)하고, stateless 입니다.

`ReverseAnimation` 하위 클래스는 `Animation<double>` 클래스를 부모로 사용하고, 애니메이션의 모든 값을 반전합니다. 
부모가 명목상 0.0-1.0 범위의 값을 사용하고, 1.0-0.0 범위의 값을 반환한다고 가정합니다. 
부모 애니메이션의 상태와 방향도 반전됩니다. 
`ReverseAnimation`은 변경 불가능(immutable)하고, stateless 입니다.

`ProxyAnimation` 하위 클래스는 `Animation<double>` 클래스를 부모로 취하고, 해당 부모의 현재 상태를 전달합니다. 
그러나, 부모는 변경 가능(mutable)합니다. 

`TrainHoppingAnimation` 하위 클래스는 두 부모를 취하고, 값이 교차할 때 두 부모 사이를 전환합니다.

#### Animation 컨트롤러 {:#animation-controllers}

[`AnimationController`][]는 `Ticker`를 사용하여 자체적으로 생명을 부여하는 stateful `Animation<double>`입니다. 
시작 및 중지가 가능합니다. 각 tick에서, 시작된 이후 경과된 시간을 가져와, `Simulation`에 전달하여 값을 얻습니다. 
그러면 보고하는 값입니다. 
`Simulation`이 그 시점에 종료되었다고 보고하면, 컨트롤러가 자체적으로 중지됩니다.

애니메이션 컨트롤러는 애니메이션을 적용할 하한 및 상한과 기간(duration)을 지정할 수 있습니다.

간단한 경우(`forward()` 또는 `reverse()` 사용), 애니메이션 컨트롤러는 지정된 기간 동안, 
하한에서 상한으로(또는 그 반대로, 역방향) 선형 보간을 수행합니다.

`repeat()`를 사용할 때, 애니메이션 컨트롤러는 지정된 기간 동안 지정된 경계 사이에서 선형 보간을 사용하지만, 중지하지는 않습니다.

`animateTo()`를 사용할 때, 애니메이션 컨트롤러는 현재 값에서 주어진 대상까지 주어진 기간 동안 선형 보간을 수행합니다. 
메서드에 기간이 지정되지 않은 경우, 컨트롤러의 기본 기간과 컨트롤러의 하한 및 상한으로 설명된 범위가 애니메이션의 속도를 결정하는 데 사용됩니다.

`fling()`를 사용할 때, `Force`를 사용하여 특정 시뮬레이션을 생성한 다음, 컨트롤러를 구동하는 데 사용됩니다.

`animateWith()`를 사용할 때, 주어진 시뮬레이션을 사용하여, 컨트롤러를 구동합니다.

이러한 메서드는 모두 `Ticker`가 제공하는 future를 반환하며, 컨트롤러가 다음에 중지되거나, 시뮬레이션이 변경될 때 해결(resolve)됩니다.

#### animatables에 animations 붙이기 {:#attaching-animatables-to-animations}

`Animation<double>` (새 부모)를 `Animatable`의 `animate()` 메서드에 전달하면, 
`Animatable`처럼 작동하지만, 지정된 부모에서 구동되는 새로운 `Animation` 하위 클래스가 생성됩니다.

[`addListener`]: {{site.api}}/flutter/animation/Animation/addListener.html
[`addStatusListener`]: {{site.api}}/flutter/animation/Animation/addStatusListener.html
[`AlwaysStoppedAnimation`]: {{site.api}}/flutter/animation/AlwaysStoppedAnimation-class.html
[`Animatable`]: {{site.api}}/flutter/animation/Animatable-class.html
[`animate`]: {{site.api}}/flutter/animation/Animatable/animate.html
[`AnimatedBuilder`]: {{site.api}}/flutter/widgets/AnimatedBuilder-class.html
[`AnimationController`]: {{site.api}}/flutter/animation/AnimationController-class.html
[`AnimatedWidget`]: {{site.api}}/flutter/widgets/AnimatedWidget-class.html
[`Animation`]: {{site.api}}/flutter/animation/Animation-class.html
[`AnimationStatus`]: {{site.api}}/flutter/animation/AnimationStatus.html
[`begin`]: {{site.api}}/flutter/animation/Tween/begin.html
[`BouncingScrollSimulation`]: {{site.api}}/flutter/widgets/BouncingScrollSimulation-class.html
[`build`]: {{site.api}}/flutter/widgets/AnimatedWidget/build.html
[`ClampingScrollSimulation`]: {{site.api}}/flutter/widgets/ClampingScrollSimulation-class.html
[`ColorTween`]: {{site.api}}/flutter/animation/ColorTween-class.html
[`Curve`]: {{site.api}}/flutter/animation/Curves-class.html
[`CurvedAnimation`]: {{site.api}}/flutter/animation/CurvedAnimation-class.html
[`end`]: {{site.api}}/flutter/animation/Tween/end.html
[`evaluate`]: {{site.api}}/flutter/animation/Animatable/evaluate.html
[`fling`]: {{site.api}}/flutter/animation/AnimationController/fling.html
[`forward`]: {{site.api}}/flutter/animation/AnimationController/forward.html
[`kAlwaysCompleteAnimation`]: {{site.api}}/flutter/animation/kAlwaysCompleteAnimation-constant.html
[`kAlwaysDismissedAnimation`]: {{site.api}}/flutter/animation/kAlwaysDismissedAnimation-constant.html
[`lerp`]: {{site.api}}/flutter/animation/Tween/lerp.html
[`RectTween`]: {{site.api}}/flutter/animation/RectTween-class.html
[`ReverseAnimation`]: {{site.api}}/flutter/animation/ReverseAnimation-class.html
[`scheduleFrameCallback()`]: {{site.api}}/flutter/scheduler/SchedulerBinding/scheduleFrameCallback.html
[`SchedulerBinding`]: {{site.api}}/flutter/scheduler/SchedulerBinding-mixin.html
[`setState`]: {{site.api}}/flutter/widgets/State/setState.html
[`Simulation`]: {{site.api}}/flutter/physics/Simulation-class.html
[`State`]: {{site.api}}/flutter/widgets/State-class.html
[`stop`]: {{site.api}}/flutter/animation/AnimationController/stop.html
[`Ticker`]: {{site.api}}/flutter/scheduler/Ticker-class.html
[`Tween<T>`]: {{site.api}}/flutter/animation/Tween-class.html
[various concrete implementations]: {{site.api}}/flutter/physics/physics-library.html
