---
# title: Widget catalog
title: 위젯 카탈로그
# description: A catalog of some of Flutter's rich set of widgets.
description: Flutter의 다양한 위젯 중 일부를 소개한 카탈로그입니다.
# short-title: Widgets
short-title: 위젯
toc: false
---

Flutter의 시각적, 구조적, 플랫폼적, 상호 작용 위젯 컬렉션으로 아름다운 앱을 더 빠르게 만들어 보세요. 
카테고리별로 위젯을 탐색하는 것 외에도, [위젯 인덱스][widget index]에서 모든 위젯을 볼 수도 있습니다.

{% comment %}
    이곳의 카테고리 이름을 바꾸려면, 다음 페이지들의 내용을 변경할 필요가 있습니다.
    
    - src/_data/catalog/index.yml
    - src/_data/catalog/widgets.yml
    - src/_includes/docs/catalogpage.html
{% endcomment %}

## 디자인 시스템 {:#design-systems}

Flutter는 SDK의 일부로 두 가지 디자인 시스템을 제공합니다. 
Flutter 커뮤니티에서 만든 더 많은 디자인 시스템은, 
Dart 및 Flutter의 패키지 저장소인 [pub.dev]({{site.pub}})에서 찾을 수 있습니다.

<div class="card-grid">
{% assign categories = catalog.index | sort: 'name' -%}
{% for section in categories %}
    {%- if section.name == "Cupertino" or section.name == "Material components" -%}
        <div class="card">
            <div class="card-body">
                <a href="{{page.url}}{{section.id}}"><header class="card-title">{{section.name}}</header></a>
                <p class="card-text">{{section.description}}</p>
            </div>
            <div class="card-footer card-footer--transparent">
                <a href="{{page.url}}{{section.id}}" aria-label="Navigate to the {{section.name}} widgets catalog">Visit</a>
            </div>
        </div>
    {% endif -%}
{% endfor %}
</div>

## 베이스 위젯 {:#base-widgets}

베이스 위젯은 입력, 레이아웃, 텍스트와 같은 다양한 일반적인 렌더링 옵션을 지원합니다.

<div class="card-grid">
{% assign categories = catalog.index | sort: 'name' -%}
{% for section in categories %}
    {%- if section.name != "Cupertino" and section.name != "Material components" and section.name != "Material 2 components" -%}
        <div class="card">
            <div class="card-body">
                <a href="{{page.url}}{{section.id}}"><header class="card-title">{{section.name}}</header></a>
                <p class="card-text">{{section.description}}</p>
            </div>
            <div class="card-footer card-footer--transparent">
                <a href="{{page.url}}{{section.id}}" aria-label="Navigate to the {{section.name}} widgets catalog">Visit</a>
            </div>
        </div>
    {% endif -%}
{% endfor %}
</div>

## Widget of the Week {:#widget-of-the-week}

Flutter 위젯을 빠르게 시작하는 데 도움이 되는, 100개 이상의, 1분 분량 짧은 설명 영상.

<div class="card-grid wide">
    <div class="card">
        <div class="card-body">
            {% ytEmbed '1z6YP7YmvwA', 'TextStyle - Flutter widget of the week', true, true %}
        </div>
    </div>
    <div class="card">
        <div class="card-body">
            {% ytEmbed 'VdkRy3yZiPo', 'flutter_rating_bar - Flutter package of the week', true, true %}
        </div>
    </div>
    <div class="card">
        <div class="card-body">
            {% ytEmbed 'VdkRy3yZiPo', 'LinearGradient - Flutter widget of the week', true, true %}
        </div>
    </div>
    <div class="card">
        <div class="card-body">
            {% ytEmbed '-Nny8kzW380', 'AutoComplete - Flutter widget of the week', true, true %}
        </div>
    </div>
    <div class="card">
        <div class="card-body">
            {% ytEmbed 'y9xchtVTtqQ', 'NavigationRail - Flutter widget of the week', true, true %}
        </div>
    </div>
    <div class="card">
        <div class="card-body">
            {% ytEmbed 'qjA0JFiPMnQ', 'mason - Flutter package of the week', true, true %}
        </div>
    </div>
</div>

<a class="btn btn-primary full-width" target="_blank" href="{{site.yt.playlist}}PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG">더 많은 widget of the week 영상을 보세요.</a>

[widget index]: /reference/widgets
