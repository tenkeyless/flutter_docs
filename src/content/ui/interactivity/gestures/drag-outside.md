---
# title: Drag outside an app
title: 앱 밖으로 드래그
# description: How to drag from an app to another app or the operating system.
description: 앱에서 다른 앱이나 운영 체제로 드래그하는 방법.
---

앱 어딘가에 드래그 앤 드롭을 구현하고 싶을 수도 있습니다.

취할 수 있는 잠재적인 접근 방식이 몇 가지 있습니다. 
하나는 Flutter 위젯을 직접 사용하고, 
다른 하나는 [pub.dev][]에서 제공되는 패키지([super_drag_and_drop][])를 사용합니다.

[pub.dev]: {{site.pub}}
[super_drag_and_drop]: {{site.pub-pkg}}/super_drag_and_drop

## 앱 내에서 draggable 위젯 만들기 {:#create-draggable-widgets-within-your-app}

애플리케이션 내에서 드래그 앤 드롭을 구현하려면, [`Draggable`][] 위젯을 사용할 수 있습니다. 
이 접근 방식에 대한 통찰력을 얻으려면, [앱 내에서 UI 요소 드래그][Drag a UI element within an app] 레시피를 참조하세요.

`Draggable`과 `DragTarget`을 사용하는 이점은 드롭을 허용할지 여부를 결정하는 Dart 코드를 제공할 수 있다는 것입니다.

자세한 내용은 [`Draggable` 주간 위젯][video] 비디오를 확인하세요.

[Drag a UI element within an app]: /cookbook/effects/drag-a-widget
[`Draggable`]:  {{site.api}}/flutter/widgets/Draggable-class.html
[`DragTarget`]: {{site.api}}/flutter/widgets/DragTarget-class.html
[local data]: {{site.pub-api}}/super_drag_and_drop/latest/super_drag_and_drop/DragItem/localData.html
[video]: https://youtu.be/q4x2G_9-Mu0?si=T4679e90U2yrloCs

## 앱 간 드래그 앤 드롭 구현 {:#implement-drag-and-drop-between-apps}

당신의 애플리케이션 내부에서 _그리고_ 당신의 애플리케이션과 다른 앱(Flutter가 아닐 수도 있음) 간에도 드래그 앤 드롭을 구현하려면, [super_drag_and_drop][] 패키지를 확인하세요.

앱 외부에서 드래그하는 것과 앱 내부에서 드래그하는 것의, 두 가지 드래그 앤 드롭 스타일을 구현하지 않으려면, 
패키지에 [localData][]를 제공하여 앱 내에서 드래그를 수행할 수 있습니다.

이 접근 방식과 `Draggable`을 직접 사용하는 것의 또 다른 차이점은, 
플랫폼 API에 동기 응답이 필요하기 때문에 앱에서 어떤 데이터를 허용하는지 패키지에 미리 알려야 한다는 것입니다. 
동기 응답은 프레임워크에서 비동기 응답을 허용하지 않습니다.

이 접근 방식을 사용하는 이점은 데스크톱, 모바일, _및_ 웹에서 작동한다는 것입니다.
