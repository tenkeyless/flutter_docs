---
# title: Flutter widget index
title: Flutter Widget 인덱스
# description: An alphabetical list of Flutter widgets.
description: Flutter 위젯의 알파벳순 리스트입니다.
# short-title: Widgets
short-title: 위젯
show_breadcrumbs: false
---

{% assign sorted = catalog.widgets | sort:'name' -%}

이것은 Flutter와 함께 제공되는 많은 위젯의 알파벳순 리스트입니다. 
또한 [카테고리 별 위젯 탐색][catalog]를 할 수 있습니다.

또한 [Flutter YouTube 채널]({{site.social.youtube}})에서, 
Widget of the Week 비디오 시리즈를 확인해 볼 수도 있습니다. 
각 짧은 에피소드에는 다른 Flutter 위젯이 등장합니다. 
더 많은 비디오 시리즈를 보려면, [비디오](/resources/videos) 페이지를 참조하세요.

{% ytEmbed 'b_sQ9bMltGU', 'Flutter Widget of the Week 소개' %}

[Widget of the Week 플레이리스트]({{site.yt.playlist}}PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG)

<div class="card-grid">
{% for comp in sorted -%}
    <div class="card">
        <a href="{{comp.link}}">
            <div class="card-image-holder">
                {% if comp.vector -%}
                    {{comp.vector}}
                {% elsif comp.image -%}
                    <img alt="Rendered image or visualization of the {{comp.name}} widget." src="{{comp.image.src}}">
                {% else -%}
                    <img alt="Flutter logo for widget missing visualization image." src="/assets/images/docs/catalog-widget-placeholder.png" aria-hidden="true">
                {% endif -%}
            </div>
        </a>
        <div class="card-body">
            <a href="{{comp.link}}"><header class="card-title">{{comp.name}}</header></a>
            <p class="card-text">{{ comp.description | truncatewords: 25 }}</p>
        </div>
    </div>
{% endfor %}
</div>

[catalog]: /ui/widgets
