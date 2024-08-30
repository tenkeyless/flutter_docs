# DevTools 2.39.0 릴리스 노트

Dart 및 Flutter DevTools의 2.39.0 릴리스에는 다른 일반적인 개선 사항과 함께 다음과 같은 변경 사항이 포함됩니다. DevTools에 대해 자세히 알아보려면 [DevTools 개요](/tools/devtools/overview)를 확인하세요.

## 일반 업데이트 {:#general-updates}

* 테이블 열을 기본적으로 정렬 가능하도록 변경. - 
  [#8175](https://github.com/flutter/devtools/pull/8175)
* Flutter 지원 IDE에서 사용되는 것과 일치하도록, DevTools 화면 아이콘 업데이트. - 
  [#8181](https://github.com/flutter/devtools/pull/8181)

## 메모리 업데이트 {:#memory-updates}

* 메모리 스냅샷의 오프라인 분석이 활성화되었고, 
  앱이 연결 해제될 때 메모리 데이터를 보는 기능이 지원되었습니다. 
  예를 들어, 앱이 예기치 않게 충돌하거나 메모리 부족 문제가 발생할 때 이런 일이 발생할 수 있습니다. - 
  [#7843](https://github.com/flutter/devtools/pull/7843),
  [#8093](https://github.com/flutter/devtools/pull/8093),
  [#8096](https://github.com/flutter/devtools/pull/8096)

* 메모리 차트가 크고 수명이 짧은 객체를 반복적으로 할당하는 동안, 
  연결된 애플리케이션에서 메모리 부족 예외가 발생하는 문제를 해결했습니다. - 
  [#8209](https://github.com/flutter/devtools/pull/8209)

## 앱 크기 도구(App size tool) 업데이트 {:#app-size-tool-updates}

* 파일 import 뷰에 UI 개선이 추가되었습니다. -
  [#8232](https://github.com/flutter/devtools/pull/8232)

## 전체 커밋 내역 {:#full-commit-history}

이 릴리스의 변경 사항 전체 리스트를 보려면,
[DevTools git log](https://github.com/flutter/devtools/tree/v2.39.0)를 확인하세요.
