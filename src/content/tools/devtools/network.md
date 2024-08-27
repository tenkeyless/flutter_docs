---
# title: Use the Network View
title: 네트워크 뷰 사용
# description: How to use the DevTools network view.
description: DevTools 네트워크 뷰를 사용하는 방법.
---

:::note
네트워크 뷰는 모든 Flutter 및 Dart 애플리케이션에서 작동합니다.
:::

## 그것은 무엇입니까? {:#what-is-it}

네트워크 뷰를 사용하면, Dart 또는 Flutter 애플리케이션에서, HTTP, HTTPS 및 웹 소켓 트래픽을 검사할 수 있습니다.

![Screenshot of the network screen](/assets/images/docs/tools/devtools/network_screenshot.png){:width="100%"}

## 사용 방법 {:#how-to-use-it}

네트워크 페이지를 열면 기본적으로 네트워크 트래픽이 기록되어야 합니다. 
그렇지 않은 경우, 왼쪽 위에 있는 **Resume** 버튼을 클릭하여 폴링을 시작합니다.

테이블(왼쪽)에서 네트워크 요청을 선택하여 세부 정보(오른쪽)를 확인합니다. 
요청에 대한 일반 및 타이밍 정보와, 응답 및 요청 헤더와 본문의 내용을 검사할 수 있습니다.

### 검색 및 필터링 {:#search-and-filtering}

검색 및 필터 컨트롤을 사용하여, 특정 요청을 찾거나 요청 표에서 요청을 필터링할 수 있습니다.

![Screenshot of the network screen](/assets/images/docs/tools/devtools/network_search_and_filter.png)

필터를 적용하려면, 필터 버튼(검색 바 오른쪽)을 누르세요. 
필터 대화 상자가 팝업으로 나타납니다.

![Screenshot of the network screen](/assets/images/docs/tools/devtools/network_filter_dialog.png)

필터 쿼리 구문은 대화 상자에 설명되어 있습니다. 다음 키로 네트워크 요청을 필터링할 수 있습니다.

* `method`, `m`: 이 필터는 "Method" 열의 값에 해당합니다.
* `status`, `s`: 이 필터는 "Status" 열의 값에 해당합니다.
* `type`, `t`: 이 필터는 "Type" 열의 값에 해당합니다.

사용 가능한 필터 키와 페어링되지 않은 모든 텍스트는 모든 카테고리(method, uri, status, type)에 대해 쿼리됩니다.

필터 쿼리 예:

```plaintext
my-endpoint m:get t:json s:200
```

```plaintext
https s:404
```

### 앱 시작 시 네트워크 요청 기록 {:#recording-network-requests-on-app-startup}

앱 시작 시 네트워크 트래픽을 기록하려면, 
일시 중지 상태에서 앱을 시작한 다음, 
앱을 재개하기 전에 DevTools에서 네트워크 트래픽 기록을 시작할 수 있습니다.

1. 일시 중지 상태에서 앱을 시작합니다.
   * `flutter run --start-paused ...`
   * `dart run --pause-isolates-on-start --observe ...`
2. 앱을 시작한 IDE에서 DevTools를 열거나, CLI에서 앱을 시작한 경우, 명령줄에 출력된 링크에서 엽니다.
3. 네트워크 화면으로 이동하여 기록이 시작되었는지 확인합니다.
4. 앱을 재개합니다.
   ![Screenshot of the app resumption experience on the Network screen](/assets/images/docs/tools/devtools/network_startup_resume.png){:width="100%"}
5. 네트워크 프로파일러는 이제, 앱 시작 트래픽을 포함하여, 앱의 모든 네트워크 트래픽을 기록합니다.

## 기타 리소스 {:#other-resources}

HTTP 및 HTTP 요청도 [타임라인][timeline]에 비동기 타임라인 이벤트로 표시됩니다. 
타임라인에서 네트워크 활동을 보는 것은, 
HTTP 트래픽이 앱이나 Flutter 프레임워크에서 발생하는 다른 이벤트와 어떻게 일치하는지 보고 싶을 때, 
유용할 수 있습니다.

DevTools를 사용하여 앱의 네트워크 트래픽을 모니터링하고 다양한 타입의 요청을 검사하는 방법을 알아보려면, 
가이드 [네트워크 뷰 튜토리얼][network-tutorial]을 확인하세요. 
이 튜토리얼은 또한 뷰를 사용하여 앱 성능 저하의 원인이 되는 네트워크 활동을 식별합니다.

[timeline]: /tools/devtools/performance#timeline-events-tab
[network-tutorial]: {{site.medium}}/@fluttergems/mastering-dart-flutter-devtools-network-view-part-4-of-8-afce2463687c
