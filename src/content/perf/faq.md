---
# title: Performance FAQ
title: 성능 FAQ
# description: Frequently asked questions about Flutter performance
description: Flutter 성능에 대한 자주 묻는 질문
---

이 페이지는 Flutter의 성능을 평가하고 디버깅하는 것에 대한, 자주 묻는 질문을 모아놓았습니다.

* Flutter와 관련된 메트릭이 있는 성능 대시보드는 무엇입니까?
  * [Appspot의 Flutter 대시보드][Flutter dashboard on appspot]
  * [Flutter Skia 대시보드][Flutter Skia dashboard]
  * [Flutter Engine Skia 대시보드][Flutter Engine Skia dashboard]

[Flutter dashboard on appspot]: https://flutter-dashboard.appspot.com/
[Flutter engine Skia dashboard]: https://flutter-engine-perf.skia.org/t/?subset=regressions
[Flutter Skia dashboard]: https://flutter-flutter-perf.skia.org/t/?subset=regressions

* Flutter에 벤치마크를 추가하려면 어떻게 해야 하나요?
  * [Flutter용 렌더 속도 테스트를 작성하는 방법][speed-test]
  * [Flutter용 메모리 테스트를 작성하는 방법][memory-test]

[memory-test]: {{site.repo.flutter}}/blob/master/docs/contributing/testing/How-to-write-a-memory-test-for-Flutter.md
[speed-test]: {{site.repo.flutter}}/blob/master/docs/contributing/testing/How-to-write-a-render-speed-test-for-Flutter.md

* 성능 지표를 캡처하고 분석하는 도구는 무엇인가요?
  * [Dart/Flutter DevTools](/tools/devtools)
  * [Apple instruments](https://en.wikipedia.org/wiki/Instruments_(software))
  * [Linux perf](https://en.wikipedia.org/wiki/Perf_(Linux))
  * [Chrome 추적(Chrome URL 필드에 `about:tracing` 입력)][tracing]
  * [Android systrace(`adb systrace`)][systrace]
  * [Fuchsia `fx traceutil`][traceutil]
  * [Perfetto](https://ui.perfetto.dev/)
  * [speedscope](https://www.speedscope.app/)

[systrace]: {{site.android-dev}}/studio/profile/systrace
[tracing]: https://www.chromium.org/developers/how-tos/trace-event-profiling-tool
[traceutil]: https://fuchsia.dev/fuchsia-src/development/tracing/usage-guide

* 내 Flutter 앱이 janky 이거나 끊깁니다(stutters). 어떻게 고칠 수 있나요?
  * [렌더링 성능 개선][Improving rendering performance]

[Improving rendering performance]: /perf/rendering-performance

* 고려해야 할 비용이 많이 드는 성능 작업은 무엇입니까?
  * [`Opacity`][], [`Clip.antiAliasWithSaveLayer`][] 또는 [`saveLayer`][]를 트리거하는 모든 것
  * [`ImageFilter`][]
  * 또한 [성능 모범 사례][Performance best practices]를 참조하세요.

[`Clip.antiAliasWithSaveLayer`]: {{site.api}}/flutter/dart-ui/Clip.html#antiAliasWithSaveLayer
[`ImageFilter`]: {{site.api}}/flutter/dart-ui/ImageFilter-class.html
[`Opacity`]: {{site.api}}/flutter/widgets/Opacity-class.html
[Performance best practices]: /perf/best-practices
[`savelayer`]: {{site.api}}/flutter/dart-ui/Canvas/saveLayer.html

* Flutter 앱에서 각 프레임에서 어떤 위젯이 재빌드되는지 어떻게 알 수 있나요?
  * [widgets/debug.dart][debug.dart]에서, [`debugProfileBuildsEnabled`][]를 true로 설정합니다.
  * 또는, [widgets/framework.dart][framework.dart]에서 `performRebuild` 함수를 변경하여, 
    `debugProfileBuildsEnabled`를 무시하고, 
    항상 `Timeline.startSync(...)/finish`를 호출합니다.
  * IntelliJ를 사용하는 경우, 이 데이터의 GUI 뷰를 사용할 수 있습니다. 
    **Track widget rebuilds**을 선택하면, IDE에서 어떤 위젯이 다시 빌드되는지 표시합니다.

[`debugProfileBuildsEnabled`]: {{site.api}}/flutter/widgets/debugProfileBuildsEnabled.html
[debug.dart]: {{site.repo.flutter}}/blob/master/packages/flutter/lib/src/widgets/debug.dart
[framework.dart]: {{site.repo.flutter}}/blob/master/packages/flutter/lib/src/widgets/framework.dart

* 대상의 디스플레이의 초당 프레임을 어떻게 쿼리합니까?
  * [디스플레이 새로 고침 빈도 가져오기][Get the display refresh rate]

[Get the display refresh rate]: {{site.repo.engine}}/blob/main/docs/Engine-specific-Service-Protocol-extensions.md#get-the-display-refresh-rate-_fluttergetdisplayrefreshrate

* UI 스레드를 차단하는, 비싼 Dart async 함수 호출로 인해 발생하는, 
  앱의 애니메이션이 제대로 작동하지 않는 문제를 해결하는 방법은?
  * [백그라운드에서 JSON 파싱][Parse JSON in the background] 쿡북에서 설명한 대로, 
  [`compute()`][] 메서드를 사용하여 다른 isolate를 생성합니다.

[`compute()`]: {{site.api}}/flutter/foundation/compute-constant.html
[Parse JSON in the background]: /cookbook/networking/background-parsing

* 사용자가 다운로드할 Flutter 앱의 패키지 크기를 어떻게 결정합니까?
  * [앱 크기 측정]Measuring your app's size[] 참조

[Measuring your app's size]: /perf/app-size

* 플러터 엔진 크기 세부 내역을 어떻게 볼 수 있나요?
  * [바이너리 크기 대시보드][binary size dashboard]를 방문하여, 
    URL의 git 해시를 [GitHub 엔진 저장소 커밋][GitHub engine repository commits]의 최근 커밋 해시로 바꾸세요.

[binary size dashboard]: https://storage.googleapis.com/flutter_infra_release/flutter/241c87ad800beeab545ab867354d4683d5bfb6ce/android-arm-release/sizes/index.html
[GitHub engine repository commits]: {{site.repo.engine}}/commits

* 실행 중인 앱의 스크린샷을 찍어 SKP 파일로 내보내려면, 어떻게 해야 하나요?
  * `flutter screenshot --type=skia --observatory-uri=...`를 실행합니다.
  * 스크린샷을 보면서, 알려진 이슈를 노트합니다.
    * [Issue 21237][]: 실제 기기에서 이미지를 기록하지 않습니다.
  * SKP 파일을 분석하고 시각화하려면, [Skia WASM 디버거][Skia WASM debugger]를 확인하세요.

[Issue 21237]: {{site.repo.flutter}}/issues/21237
[Skia WASM debugger]: https://debugger.skia.org/

* 장치에서 셰이더 지속형 캐시(shader persistent cache)를 어떻게 검색하나요?
  * Android에서는, 다음을 수행할 수 있습니다.
    ```console
    adb shell
    run-as <com.your_app_package_name>
    cp <your_folder> <some_public_folder, e.g., /sdcard> -r
    adb pull <some_public_folder/your_folder>
    ```

* Fuchsia에서 추적을 수행하려면, 어떻게 해야 하나요?
  * [Fuchsia 추적 가이드라인][traceutil] 참조