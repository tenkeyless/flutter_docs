---
# title: Performance metrics
title: 성능 메트릭
# description: Flutter metrics, and which tools and APIs are used to get them
description: Flutter 메트릭과 이를 얻기 위해 사용되는 도구 및 API
---

* 첫 번째 프레임까지의 시작 시간
  * [WidgetsBinding.instance.firstFrameRasterized][firstFrameRasterized]가 true인 시간을 확인합니다.
  * [perf 대시보드](https://flutter-flutter-perf.skia.org/e/?queries=sub_result%3DtimeToFirstFrameRasterizedMicros)를 참조하세요.

* 프레임 buildDuration, rasterDuration 및 totalSpan
  * API 문서에서 [`FrameTiming`]({{site.api}}/flutter/dart-ui/FrameTiming-class.html)을 참조하세요.

* 프레임 `buildDuration`의 통계(`*_frame_build_time_millis`)
  * 평균, 90th percentile, 99th percentile 및 최악의 프레임 빌드 시간이라는 네 가지 통계를 모니터링하는 것이 좋습니다.
  * 예를 들어, `flutter_gallery__transition_perf` 테스트에 대한 [메트릭][transition_build]을 참조하세요.

* 프레임 `rasterDuration`의 통계(`*_frame_build_time_millis`)
  * 평균, 90th percentile, 99th percentile, 최악의 프레임 빌드 시간이라는 네 가지 통계를 모니터링하는 것이 좋습니다.
  * 예를 들어 `flutter_gallery__transition_perf` 테스트에 대한 [메트릭][transition_raster]을 참조하세요.

* CPU/GPU 사용량(에너지 사용량에 대한 좋은 근사치)
  * 사용량은 현재 추적 이벤트를 통해서만 사용할 수 있습니다. 
    [profiling_summarizer.dart][profiling_summarizer]를 참조하세요.
  * `simple_animation_perf_ios` 테스트에 대한 [메트릭][cpu_gpu]을 참조하세요.

* release_size_bytes는 Flutter 앱의 크기를 대략적으로 측정합니다.
  * [basic_material_app_android][], [basic_material_app_ios][], [hello_world_android][], 
    [hello_world_ios][], [flutter_gallery_android][], [flutter_gallery_ios][] 테스트를 참조하세요.
  * 대시보드에서 [메트릭][size_perf]을 참조하세요.
  * 크기를 더 정확하게 측정하는 방법에 대한 자세한 내용은 [app size](/perf/app-size) 페이지를 참조하세요.

Flutter가 커밋당 측정하는 성능 지표의 전체 리스트를 보려면, 다음 사이트를 방문하여, 
**Query**를 클릭하고 **test** 및 **sub_result** 필드를 필터링하세요.

  * [https://flutter-flutter-perf.skia.org/e/](https://flutter-flutter-perf.skia.org/e/)
  * [https://flutter-engine-perf.skia.org/e/](https://flutter-engine-perf.skia.org/e/)

[firstFrameRasterized]: {{site.api}}/flutter/widgets/WidgetsBinding/firstFrameRasterized.html

[transition_build]: https://flutter-flutter-perf.skia.org/e/?queries=sub_result%3D90th_percentile_frame_build_time_millis%26sub_result%3D99th_percentile_frame_build_time_millis%26sub_result%3Daverage_frame_build_time_millis%26sub_result%3Dworst_frame_build_time_millis%26test%3Dflutter_gallery__transition_perf

[transition_raster]: https://flutter-flutter-perf.skia.org/e/?queries=sub_result%3D90th_percentile_frame_rasterizer_time_millis%26sub_result%3D99th_percentile_frame_rasterizer_time_millis%26sub_result%3Daverage_frame_rasterizer_time_millis%26sub_result%3Dworst_frame_rasterizer_time_millis%26test%3Dflutter_gallery__transition_perf

[profiling_summarizer]: {{site.repo.flutter}}/blob/master/packages/flutter_driver/lib/src/driver/profiling_summarizer.dart

[cpu_gpu]: https://flutter-flutter-perf.skia.org/e/?queries=sub_result%3Daverage_cpu_usage%26sub_result%3Daverage_gpu_usage%26test%3Dsimple_animation_perf_ios

[basic_material_app_android]: {{site.repo.flutter}}/blob/master/dev/devicelab/bin/tasks/basic_material_app_android__compile.dart

[basic_material_app_ios]: {{site.repo.flutter}}/blob/master/dev/devicelab/bin/tasks/basic_material_app_ios__compile.dart

[hello_world_android]: {{site.repo.flutter}}/blob/master/dev/devicelab/bin/tasks/hello_world_android__compile.dart

[hello_world_ios]: {{site.repo.flutter}}/blob/master/dev/devicelab/bin/tasks/hello_world_ios__compile.dart

[flutter_gallery_android]: {{site.repo.flutter}}/blob/master/dev/devicelab/bin/tasks/flutter_gallery_android__compile.dart

[flutter_gallery_ios]: {{site.repo.flutter}}/blob/master/dev/devicelab/bin/tasks/flutter_gallery_ios__compile.dart

[size_perf]: https://flutter-flutter-perf.skia.org/e/?queries=sub_result%3Drelease_size_bytes%26test%3Dbasic_material_app_android__compile%26test%3Dbasic_material_app_ios__compile%26test%3Dhello_world_android__compile%26test%3Dhello_world_ios__compile%26test%3Dflutter_gallery_ios__compile%26test%3Dflutter_gallery_android__compile
