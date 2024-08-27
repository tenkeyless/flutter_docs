{% assign id =  include.os | downcase -%}
{% assign channels =  'stable beta' | split: ' ' -%}

{% for channel in channels -%}

## {{channel | capitalize }} channel ({{include.os}})

다음 스크롤 리스트에서 선택하세요:

<div class="scrollable-table">
  <table id="downloads-{{id}}-{{channel}}" class="table table-striped">
  <thead><tr><th>Flutter 버전</th><th>아키텍쳐</th><th>Ref</th><th class="date">릴리즈 날짜</th><th>Dart 버전</th><th>Provenance</th></tr></thead>
  <tr class="loading"><td colspan="6">로딩중입니다...</td></tr>
  </table>
</div>

{% endfor -%}
