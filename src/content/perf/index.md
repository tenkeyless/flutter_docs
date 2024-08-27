---
# title: Performance
title: 성능
# description: Evaluating the performance of your app from several angles.
description: 다양한 각도에서 앱의 성능을 평가합니다.
---

{% ytEmbed 'PKGguGUwSYE', 'Flutter 성능 팁 | Flutter in Focus' %}

:::note
앱에 성능 문제가 있고 이를 디버깅하려는 경우, 
DevTools의 [성능 보기 사용][Using the Performance view] 페이지를 확인하세요.
:::

[Using the Performance view]: /tools/devtools/performance

성능이란 무엇인가요? 성능이 중요한 이유는 무엇인가요? 성능을 개선하려면 어떻게 해야 할까요?

저희의 목표는 이 세 가지 질문(주로 세 번째 질문)과 이와 관련된 모든 것에 답하는 것입니다. 
이 문서는 성능에 대한 모든 질문을 다루는 리소스 트리의 단일 진입점 또는 루트 노드 역할을 해야 합니다.

처음 두 질문에 대한 답변은 대부분 철학적이며, 
해결해야 할 특정 성능 문제가 있는 이 페이지를 방문하는 많은 개발자에게는 도움이 되지 않습니다. 
따라서, 이러한 질문에 대한 답변은 [부록](/perf/appendix)에 있습니다.

성능을 개선하려면, 먼저 메트릭이 필요합니다. 
문제와 개선 사항을 검증하기 위한 측정 가능한 숫자입니다. 
[메트릭](/perf/metrics) 페이지에서, 
현재 사용 중인 메트릭과 메트릭을 가져오는 데 사용할 수 있는 도구 및 API를 확인할 수 있습니다.

[자주 묻는 질문](/perf/faq) 리스트가 있어서, 
질문이나 문제가 이미 답변되었는지 또는 발생했는지, 그리고 기존 솔루션이 있는지 확인할 수 있습니다. 
(또는, [성능][performance] 레이블을 사용하여, 
Flutter GitHub 문제 데이터베이스를 확인할 수 있습니다.)

마지막으로, 성능 문제는 네 가지 범주로 나뉩니다. 
이는 Flutter GitHub 문제 데이터베이스에서 사용되는 네 가지 레이블인, 
"[성능: 속도][속도]", "[성능: 메모리][메모리]", "[성능: 앱 크기][크기]", "[성능: 에너지][에너지]"에 해당합니다.

나머지 콘텐츠는 이 네 가지 범주를 사용하여 구성됩니다.

{% comment %}
Let's put "speed" (rendering) first as it's the most popular performance issue
category.
{% endcomment -%}

## 속도 {:#speed}

애니메이션이 janky합니까(부드럽지 않음)? 렌더링 문제를 평가하고 수정하는 방법을 알아보세요.

[렌더링 성능 향상](/perf/rendering-performance)

{% comment %}
Do your apps take a long time to open? We'll also cover the startup speed issue
in some future pages.
{% endcomment -%}

{% comment %}

TODO(<https://github.com/flutter/website/issues/8249>): Reintroduce this article and add this link back.

## Memory

[Using memory wisely](/perf/memory)

{% endcomment -%}

## 앱 크기 {:#app-size}

앱 크기를 측정하는 방법. 크기가 작을수록, 다운로드 속도가 빨라집니다.

[앱 크기 측정][Measuring your app's size]

{% comment %}

TODO(<https://github.com/flutter/website/issues/8249>): Reintroduce this article and add this link back.

## Energy

How to ensure a longer battery life when running your app.

[Preserving your battery](/perf/power)

{% endcomment -%}

[Measuring your app's size]: /perf/app-size

[speed]: {{site.repo.flutter}}/issues?q=is%3Aopen+label%3A%22perf%3A+speed%22+sort%3Aupdated-asc+
[energy]: {{site.repo.flutter}}/issues?q=is%3Aopen+label%3A%22perf%3A+energy%22+sort%3Aupdated-asc+
[memory]: {{site.repo.flutter}}/issues?q=is%3Aopen+label%3A%22perf%3A+memory%22+sort%3Aupdated-asc+
[size]: {{site.repo.flutter}}/issues?q=is%3Aopen+label%3A%22perf%3A+app+size%22+sort%3Aupdated-asc+
[performance]: {{site.repo.flutter}}/issues?q=+label%3A%22severe%3A+performance%22
