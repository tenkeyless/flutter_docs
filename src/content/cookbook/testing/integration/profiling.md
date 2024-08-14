---
# title: Measure performance with an integration test
title: 통합 테스트로 성능 측정
# description: How to profile performance for a Flutter app.
description: Flutter 앱의 성능을 프로파일링하는 방법.
---

<?code-excerpt path-base="cookbook/testing/integration/profiling/"?>

모바일 앱의 경우, 성능은 사용자 경험에 매우 중요합니다. 
사용자는 앱이 매끄러운 스크롤링과 ("jank"라고 알려진, 끊기거나 건너뛰는 프레임이 없는) 의미 있는 애니메이션을 기대합니다. 
다양한 기기에서 앱이 jank 없이 작동하는지 확인하는 방법은 무엇일까요?

두 가지 옵션이 있습니다. 
1. 첫째, 다른 기기에서 앱을 수동으로 테스트합니다. 
   * 이 방법은 작은 앱에는 효과적일 수 있지만, 앱의 크기가 커질수록 더 번거로워집니다. 
2. 대안으로, 특정 작업을 수행하고 성능 타임라인을 기록하는 통합 테스트를 실행합니다. 
   * 그런 다음, 결과를 검토하여 앱의 특정 섹션을 개선해야 하는지 확인합니다.

이 레시피에서는, 특정 작업을 수행하는 동안 성능 타임라인을 기록하고 
결과 요약을 로컬 파일에 저장하는 테스트를 작성하는 방법을 알아봅니다.

:::note
성능 타임라인 기록은 웹에서 지원되지 않습니다. 
웹에서 성능 프로파일링은, [웹 앱의 성능 디버깅][Debugging performance for web apps]을 참조하세요.
:::

이 레시피는 다음 단계를 사용합니다.

1. 아이템 리스트를 스크롤하는 테스트를 작성합니다.
2. 앱의 성능을 기록합니다.
3. 결과를 디스크에 저장합니다.
4. 테스트를 실행합니다.
5. 결과를 검토합니다.

## 1. 아이템 리스트를 스크롤하는 테스트 작성 {:#1-write-a-test-that-scrolls-through-a-list-of-items}

이 레시피에서는, 앱이 아이템 리스트를 스크롤할 때 앱의 성능을 기록합니다. 
성능 프로파일링에 집중하기 위해, 이 레시피는 위젯 테스트에서 [스크롤링][Scrolling] 레시피를 기반으로 합니다.

해당 레시피의 지침에 따라 앱을 만들고, 모든 것이 예상대로 작동하는지 확인하는 테스트를 작성합니다.

## 2. 앱의 성능 기록 {:#2-record-the-performance-of-the-app}

다음으로, 리스트를 스크롤할 때 앱의 성능을 기록합니다. 
[`IntegrationTestWidgetsFlutterBinding`][] 클래스에서 제공하는 
[`traceAction()`][] 메서드를 사용하여 이 작업을 수행합니다.

이 메서드는 제공된 함수를 실행하고 앱 성능에 대한 자세한 정보가 포함된 [`Timeline`][]을 기록합니다. 
이 예제는 아이템 리스트를 스크롤하여 특정 아이템이 표시되도록 하는 함수를 제공합니다. 
함수가 완료되면, `traceAction()`은 `Timeline`을 포함하는 보고서 데이터 `Map`을 만듭니다.

두 개 이상의 `traceAction`을 실행할 때 `reportKey`를 지정합니다. 
기본적으로 모든 `Timeline`은 `timeline` 키와 함께 저장되며, 
이 예제에서 `reportKey`는 `scrolling_timeline`으로 변경됩니다.

<?code-excerpt "integration_test/scrolling_test.dart (traceAction)"?>
```dart
await binding.traceAction(
  () async {
    // 찾으려는 항목이 나타날 때까지 스크롤하세요.
    await tester.scrollUntilVisible(
      itemFinder,
      500.0,
      scrollable: listFinder,
    );
  },
  reportKey: 'scrolling_timeline',
);
```

## 3. 결과를 디스크에 저장 {:#3-save-the-results-to-disk}

이제 성능 타임라인을 캡처했으니, 이를 검토할 방법이 필요합니다. 
`Timeline` 객체는 발생한 모든 이벤트에 대한 자세한 정보를 제공하지만, 결과를 검토하는 편리한 방법은 제공하지 않습니다.

따라서, `Timeline`을 [`TimelineSummary`][]로 변환합니다. 
`TimelineSummary`는 결과를 검토하기 쉽게 만드는 두 가지 작업을 수행할 수 있습니다.

   1. `Timeline`에 포함된 데이터를 요약하는 디스크에 JSON 문서를 작성합니다. 
      * 이 요약에는 건너뛴 프레임 수, 가장 느린 빌드 시간 등에 대한 정보가 포함됩니다.
   2. 전체 `Timeline`을 디스크에 JSON 파일로 저장합니다. 
      * 이 파일은 `chrome://tracing`에서 찾을 수 있는 Chrome 브라우저의 추적 도구로 열 수 있습니다.

결과를 캡처하려면, `test_driver` 폴더에 `perf_driver.dart`라는 파일을 만들고 다음 코드를 추가합니다.

<?code-excerpt "test_driver/perf_driver.dart"?>
```dart
import 'package:flutter_driver/flutter_driver.dart' as driver;
import 'package:integration_test/integration_test_driver.dart';

Future<void> main() {
  return integrationDriver(
    responseDataCallback: (data) async {
      if (data != null) {
        final timeline = driver.Timeline.fromJson(
          data['scrolling_timeline'] as Map<String, dynamic>,
        );

        // Timeline을 읽고 이해하기 쉬운 TimelineSummary으로 변환하세요.
        final summary = driver.TimelineSummary.summarize(timeline);

        // 그런 다음, 전체 타임라인을 json 형식으로 디스크에 씁니다. 
        // 이 파일은 chrome://tracing으로 이동하여 찾을 수 있는 Chrome 브라우저의 추적 도구에서 열 수 있습니다. 
        // 선택적으로, includeSummary를 true로 설정하여, 요약을 디스크에 저장합니다.
        await summary.writeTimelineToFile(
          'scrolling_timeline',
          pretty: true,
          includeSummary: true,
        );
      }
    },
  );
}
```

`integrationDriver` 함수에는 커스터마이즈 할 수 있는 `responseDataCallback`이 있습니다. 
기본적으로, 결과를 `integration_response_data.json` 파일에 기록하지만, 
이 예와 같이 요약을 생성하도록 커스터마이즈 할 수 있습니다.

## 4. 테스트 실행 {:#4-run-the-test}

성능 `Timeline`을 캡처하고 결과 요약을 디스크에 저장하도록 테스트를 구성한 후, 
다음 명령으로 테스트를 실행합니다.

```console
flutter drive \
  --driver=test_driver/perf_driver.dart \
  --target=integration_test/scrolling_test.dart \
  --profile
```

`--profile` 옵션은 "디버그 모드"가 아닌 "프로필 모드"로 앱을 컴파일하여, 
벤치마크 결과가 최종 사용자가 경험하는 것에 더 가까워지도록 하는 것을 의미합니다.

:::note
모바일 기기나 에뮬레이터에서 실행할 때는 `--no-dds`로 명령을 실행하세요. 
이 옵션은 컴퓨터에서 액세스할 수 없는 Dart Development Service(DDS)를 비활성화합니다.
:::

## 5. 결과 검토 {:#5-review-the-results}

테스트가 성공적으로 완료되면, 프로젝트 루트에 있는 `build` 디렉토리에 두 개의 파일이 포함됩니다.

1. `scrolling_summary.timeline_summary.json`에는 요약이 포함됩니다. 
   * 텍스트 편집기로 파일을 열어 포함된 정보를 검토합니다. 
   * 고급 설정을 사용하면, 테스트를 실행할 때마다 요약을 저장하고 결과 그래프를 만들 수 있습니다.
2. `scrolling_timeline.timeline.json`에는 전체 타임라인 데이터가 포함됩니다. 
   * `chrome://tracing`에서 찾을 수 있는 Chrome 브라우저의 추적 도구를 사용하여 파일을 엽니다. 
   * 추적 도구는 타임라인 데이터를 검사하여 성능 문제의 원인을 발견하기 위한 편리한 인터페이스를 제공합니다.

### 요약 예 {:#summary-example}

```json
{
  "average_frame_build_time_millis": 4.2592592592592595,
  "worst_frame_build_time_millis": 21.0,
  "missed_frame_build_budget_count": 2,
  "average_frame_rasterizer_time_millis": 5.518518518518518,
  "worst_frame_rasterizer_time_millis": 51.0,
  "missed_frame_rasterizer_budget_count": 10,
  "frame_count": 54,
  "frame_build_times": [
    6874,
    5019,
    3638
  ],
  "frame_rasterizer_times": [
    51955,
    8468,
    3129
  ]
}
```

## 완성된 예제 {:#complete-example}

**integration_test/scrolling_test.dart**

<?code-excerpt "integration_test/scrolling_test.dart"?>
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:scrolling/main.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Counter increments smoke test', (tester) async {
    // 앱을 빌드하고 프레임을 트리거합니다.
    await tester.pumpWidget(MyApp(
      items: List<String>.generate(10000, (i) => 'Item $i'),
    ));

    final listFinder = find.byType(Scrollable);
    final itemFinder = find.byKey(const ValueKey('item_50_text'));

    await binding.traceAction(
      () async {
        // 찾으려는 항목이 나타날 때까지 스크롤하세요.
        await tester.scrollUntilVisible(
          itemFinder,
          500.0,
          scrollable: listFinder,
        );
      },
      reportKey: 'scrolling_timeline',
    );
  });
}
```

**test_driver/perf_driver.dart**

<?code-excerpt "test_driver/perf_driver.dart"?>
```dart
import 'package:flutter_driver/flutter_driver.dart' as driver;
import 'package:integration_test/integration_test_driver.dart';

Future<void> main() {
  return integrationDriver(
    responseDataCallback: (data) async {
      if (data != null) {
        final timeline = driver.Timeline.fromJson(
          data['scrolling_timeline'] as Map<String, dynamic>,
        );

        // Timeline을 읽고 이해하기 쉬운 TimelineSummary으로 변환하세요.
        final summary = driver.TimelineSummary.summarize(timeline);

        // 그런 다음, 전체 타임라인을 json 형식으로 디스크에 씁니다. 
        // 이 파일은 chrome://tracing으로 이동하여 찾을 수 있는 Chrome 브라우저의 추적 도구에서 열 수 있습니다. 
        // 선택적으로, includeSummary를 true로 설정하여 요약을 디스크에 저장합니다.
        await summary.writeTimelineToFile(
          'scrolling_timeline',
          pretty: true,
          includeSummary: true,
        );
      }
    },
  );
}
```


[`IntegrationTestWidgetsFlutterBinding`]: {{site.api}}/flutter/package-integration_test_integration_test/IntegrationTestWidgetsFlutterBinding-class.html
[Scrolling]: /cookbook/testing/widget/scrolling
[`Timeline`]: {{site.api}}/flutter/flutter_driver/Timeline-class.html
[`TimelineSummary`]: {{site.api}}/flutter/flutter_driver/TimelineSummary-class.html
[`traceAction()`]: {{site.api}}/flutter/flutter_driver/FlutterDriver/traceAction.html
[Debugging performance for web apps]: /perf/web-performance
