---
# title: Material Design for Flutter
title: Flutter를 위한 Material 디자인
# description: Learn about Material Design for Flutter.
description: Flutter를 위한 Material Design에 대해 알아보세요.
---

Material Design은 Google 디자이너와 개발자가 구축하고 지원하는 오픈소스 디자인 시스템입니다.

최신 버전인 Material 3은 (동적 색상과 향상된 접근성부터 대형 화면 레이아웃의 기초와 디자인 토큰에 이르기까지) 
개인적이고 적응적이며 표현적인 경험을 가능하게 합니다.

:::warning
Flutter 3.16 릴리스부터 **Material 3이 기본적으로 활성화되었습니다**. 
지금은 [`useMaterial3`][] 속성을 `false`로 설정하여 Material 3을 선택 해제할 수 있습니다. 
하지만 `useMaterial3` 속성과 Material 2 지원은 Flutter의 [사용 중단 정책][deprecation policy]에 따라 결국 deprecated 될 것입니다.
:::

_대부분_ Flutter 위젯의 경우, Material 3으로의 업그레이드는 매끄럽습니다. 
하지만 _일부_ 위젯은 업데이트할 수 없었습니다. 
[`NavigationBar`][]와 같이 완전히 새로운 구현이 필요했습니다. 
당신의 코드를 수동으로 변경해야 합니다. 
앱이 완전히 업데이트될 때까지 UI가 이상하게 보이거나 작동할 수 있습니다. 
[영향을 받는 위젯][Affected widgets] 페이지를 방문하면 완전히 새로운 Material 구성 요소를 찾을 수 있습니다.

[Affected widgets]: {{site.api}}/flutter/material/ThemeData/useMaterial3.html#affected-widgets
[deprecation policy]: /release/compatibility-policy#deprecation-policy
[demo]: https://flutter.github.io/samples/web/material_3_demo/#/
[`NavigationBar`]: {{site.api}}/flutter/material/NavigationBar-class.html
[`useMaterial3`]: {{site.api}}/flutter/material/ThemeData/useMaterial3.html

[상호 작용 Material 3 데모][demo]를 통해 업데이트된 구성 요소, 타이포그래피, 색상 시스템 및 elevation 지원을 살펴보세요.

<iframe src="https://flutter.github.io/samples/web/material_3_demo/#/" width="100%" height="600px" title="Material 3 Demo App"></iframe>

## 더 많은 정보 {:#more-information :.no_toc}

Material Design과 Flutter에 대해 자세히 알아보려면 다음을 확인하세요.

* [Material.io 개발자 문서][Material.io developer documentation]
* [Flutter 앱을 Material 3으로 마이그레이션][Migrating a Flutter app to Material 3] Taha Tesser의 블로그 포스트
* [GitHub의 Umbrella 이슈][Umbrella issue on GitHub]

[Material.io developer documentation]: {{site.material}}/develop/flutter
[Migrating a Flutter app to Material 3]: https://blog.codemagic.io/migrating-a-flutter-app-to-material-3/
[Umbrella issue on GitHub]: {{site.github}}//flutter/flutter/issues/91605
