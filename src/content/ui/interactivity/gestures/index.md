---
# title: Taps, drags, and other gestures
title: 탭, 드래그 및 기타 제스처
# short-title: Gestures
short-title: 제스처
# description: How gestures, such as taps and drags, work in Flutter.
description: 탭, 드래그 등의 제스처가 Flutter에서 작동하는 방식.
---

이 문서에서는 Flutter에서 _제스처_ 를 수신하고 응답하는 방법을 설명합니다. 
제스처의 예로는 탭, 드래그, 크기 조정이 있습니다.

Flutter의 제스처 시스템에는 두 개의 별도 레이어가 있습니다. 
1. 첫 번째 레이어에는 화면에서 포인터(예: 터치, 마우스, 스타일러스)의 위치와 움직임을 설명하는 raw 포인터 이벤트가 있습니다. 
2. 두 번째 레이어에는 하나 이상의 포인터 움직임으로 구성된 의미적 동작(semantic actions)을 설명하는 _제스처_ 가 있습니다.

## 포인터 {:#pointers}

포인터는 사용자가 기기 화면과 상호작용하는 것에 대한 raw 데이터를 나타냅니다.
포인터 이벤트에는 네 가지 타입이 있습니다.

[`PointerDownEvent`][]
: 포인터가 특정 위치에서 화면에 접촉했습니다.

[`PointerMoveEvent`][]
: 포인터가 화면의 한 위치에서 다른 위치로 이동했습니다.

[`PointerUpEvent`][]
: 포인터가 화면에 접촉하는 것을 멈췄습니다.

[`PointerCancelEvent`][]
: 이 포인터의 입력은 더 이상 이 앱으로 전달되지 않습니다.

포인터가 down 되면, 프레임워크는 앱에서 _히트 테스트_ 를 수행하여 포인터가 화면에 접촉한 위치에 어떤 위젯이 있는지 확인합니다. 
포인터 down 이벤트(및 해당 포인터에 대한 후속 이벤트)는 그런 다음 히트 테스트에서 찾은 가장 안쪽 위젯으로 전송됩니다. 
거기에서, 이벤트는 트리 위로 버블링(bubble up)되어, 가장 안쪽 위젯에서 트리 루트까지의 경로에 있는 모든 위젯으로 전송됩니다. 
포인터 이벤트가 더 이상 전송되는 것을 취소하거나 중지하는 메커니즘은 없습니다.

위젯 레이어에서 직접 포인터 이벤트를 수신하려면, [`Listener`][] 위젯을 사용합니다. 
그러나, 일반적으로 제스처(아래에서 설명)를 대신 사용하는 것을 고려합니다.

[`Listener`]: {{site.api}}/flutter/widgets/Listener-class.html
[`PointerCancelEvent`]: {{site.api}}/flutter/gestures/PointerCancelEvent-class.html
[`PointerDownEvent`]: {{site.api}}/flutter/gestures/PointerDownEvent-class.html
[`PointerMoveEvent`]: {{site.api}}/flutter/gestures/PointerMoveEvent-class.html
[`PointerUpEvent`]: {{site.api}}/flutter/gestures/PointerUpEvent-class.html

## 제스쳐 {:#gestures}

제스처는 (여러 개별 포인터 이벤트, 심지어 여러 개별 포인터에서 인식되는) 의미적 동작(예: 탭, 드래그, 크기 조절)을 나타냅니다. 
제스처는 제스처의 수명 주기(예: 드래그 시작, 드래그 업데이트, 드래그 종료)에 해당하는 여러 이벤트를 전달할 수 있습니다.

**탭**

`onTapDown`
: 탭을 유발할 수 있는 포인터가 특정 위치에서 화면에 접촉했습니다.

`onTapUp`
: 탭을 트리거하는 포인터가 특정 위치에서 화면에 접촉하는 것을 멈췄습니다.

`onTap`
: 이전에 `onTapDown`을 트리거한 포인터가,  `onTapUp`도 트리거하여 결국 탭을 발생시킵니다.

`onTapCancel`
: 이전에 `onTapDown`을 트리거한 포인터가 결국 탭을 발생시키지 않습니다.

**더블 탭**

`onDoubleTap`
: 사용자가 화면을 같은 위치에서 빠르게 두 번 탭했습니다.

**길게 누르기**

`onLongPress`
: 포인터가 장시간 동안 화면의 같은 위치에 접촉해 있었습니다.

**수직 드래그**

`onVerticalDragStart`
: 포인터가 화면에 접촉하여 수직으로 움직이기 시작할 수 있습니다.

`onVerticalDragUpdate`
: 화면과 접촉하여 수직으로 움직이는 포인터가 수직 방향으로 움직였습니다.

`onVerticalDragEnd`
: 이전에 화면과 접촉하여 수직으로 움직이는 포인터가 더 이상 화면과 접촉하지 않고, 
  특정 속도로 움직이다가 화면과의 접촉을 멈췄습니다.

**수평 드래그**

`onHorizontalDragStart`
: 포인터가 화면에 접촉하여 수평으로 움직이기 시작할 수 있습니다.

`onHorizontalDragUpdate`
: 화면과 접촉하여 수평으로 움직이는 포인터가 수평 방향으로 움직였습니다.

`onHorizontalDragEnd`
: 이전에 화면과 접촉하여 수평으로 움직이는 포인터가 더 이상 화면과 접촉하지 않고, 
  특정 속도로 움직이다가 화면과 접촉을 멈췄습니다.

**Pan**

`onPanStart`
: 포인터가 화면에 접촉하여 수평 또는 수직으로 움직이기 시작할 수 있습니다. 
  `onHorizontalDragStart` 또는 `onVerticalDragStart`가 설정된 경우, 이 콜백은 충돌합니다.

`onPanUpdate`
: 화면과 접촉하여 수직 또는 수평 방향으로 움직이는 포인터입니다. 
  `onHorizontalDragUpdate` 또는 `onVerticalDragUpdate`가 설정된 경우, 이 콜백은 충돌합니다.

`onPanEnd`
: 이전에 화면과 접촉했던 포인터가 더 이상 화면과 접촉하지 않고, 화면과의 접촉을 멈췄을 때 특정 속도로 움직입니다.
  `onHorizontalDragEnd` 또는 `onVerticalDragEnd`가 설정된 경우, 이 콜백은 충돌합니다.

### 위젯에 제스처 감지 추가 {:#adding-gesture-detection-to-widgets}

위젯 레이어에서 제스처를 수신하려면, [`GestureDetector`][]를 사용하세요.

:::note
자세한 내용을 알아보려면, `GestureDetector` 위젯에 대한 이 짧은 주간 위젯 비디오를 시청하세요.

{% ytEmbed 'WhVXkCFPmK4', 'GestureDetector - Flutter widget of the week' %}
:::

Material Components를 사용하는 경우, 이러한 위젯 중 다수는 이미 탭이나 제스처에 반응합니다. 
예를 들어, [`IconButton`][] 및 [`TextButton`][]은 누르기 (탭)에 반응하고, 
[`ListView`][]는 스크롤을 트리거하기 위한 스와이프에 반응합니다. 
이러한 위젯을 사용하지 않지만, 탭에 "잉크 튀김" 효과를 원하는 경우, [`InkWell`][]을 사용할 수 있습니다.

[`GestureDetector`]: {{site.api}}/flutter/widgets/GestureDetector-class.html
[`IconButton`]: {{site.api}}/flutter/material/IconButton-class.html
[`InkWell`]: {{site.api}}/flutter/material/InkWell-class.html
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
[`TextButton`]: {{site.api}}/flutter/material/TextButton-class.html

### 제스처 모호성 해소 {:#gesture-disambiguation}

화면의 주어진 위치에, 여러 제스처 감지기가 있을 수 있습니다. 예를 들어:

* `ListTile`에는 
  * (1) 전체 `ListTile`에 응답하는 탭 인식기와, (2) trailing 아이콘 버튼 주위에 중첩된 인식기가 있습니다. 
  * trailing 아이콘의 화면 사각형은 이제, 
    탭으로 판명될 경우 제스처를 처리할 것이 누구인지를 협상해야 하는, 
    두 개의 제스처 인식기로 덮여 있습니다.
* 단일 `GestureDetector`는 (길게 누르기 및 탭과 같은) 여러 제스처를 처리하도록 구성된 화면 영역을 덮습니다. 
  * `tap` 인식기는 이제 사용자가 화면의 해당 부분을 터치할 때 `long press` 인식기와 협상해야만 합니다. 
  * 해당 포인터에서 다음에 무슨 일이 일어나는지에 따라, 
    * 두 인식기 중 하나가 제스처를 수신하거나, 
    * 사용자가 탭도 길게 누르기도 아닌 작업을 수행하면 어느 것도 제스처를 수신하지 않습니다.

이러한 모든 제스처 감지기는, 포인터 이벤트 스트림이 지나갈 때 이를 듣고, 특정 제스처를 인식하려고 시도합니다. [`GestureDetector`] 위젯은 null이 아닌 콜백에 따라 인식을 시도할 제스처를 결정합니다.

화면에 주어진 포인터에 대한 제스처 인식기가 두 개 이상 있는 경우, 
프레임워크는 각 인식기를 _제스처 경기장_ 에 참여시켜, 사용자가 의도하는 제스처의 모호성을 해소합니다. 
제스처 경기장은 다음 규칙을 사용하여 어떤 제스처가 승리하는지 결정합니다.

* 언제든지, 인식기는 자신을 제거하고 경기장을 떠날 수 있습니다. 
  경기장에 인식기가 하나만 남아 있는 경우, 해당 인식기가 승리합니다. <기권. 하나만 남으면 그것이 승리.>

* 언제든지, 인식기는 자신을 승자로 선언하여, 나머지 모든 인식기가 패배하게 할 수 있습니다. <승리선언. 승리선언하면 그것이 승리.>

예를 들어, 수평 및 수직 드래그를 모호하게 구분할 때, 두 인식기는 포인터 down 이벤트를 수신하면 경기장에 들어갑니다. 
인식기는 포인터 이동 이벤트를 관찰합니다. 
사용자가 포인터를 수평으로 특정 수의 논리적 픽셀 이상 이동하면, 수평 인식기는 승리를 선언하고 제스처는 수평 드래그로 해석됩니다. 
마찬가지로, 사용자가 수직으로 특정 수의 논리적 픽셀 이상 이동하면, 수직 인식기는 자신을 승자로 선언합니다.

제스처 경기장은 수평(또는 수직) 드래그 인식기만 있을 때 유용합니다. 
이 경우, 경기장에 인식기가 하나뿐이고 수평 드래그가 즉시 인식되므로, 
수평 이동의 첫 번째 픽셀을 드래그로 처리할 수 있으며, 사용자는 추가 제스처 모호성 해결을 기다릴 필요가 없습니다.
