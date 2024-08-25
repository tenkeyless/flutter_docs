---
# title: Shader compilation jank
title: 셰이더 컴파일 jank
# short-title: Shader jank
short-title: 셰이더 jank
# description: What is shader jank and how to minimize it.
description: 셰이더 jank란 무엇이고 어떻게 최소화할 수 있나요?
---

{% render docs/performance.md %}

모바일 앱의 애니메이션이 처음 실행할 때만 janky하게 보인다면, 이는 셰이더 컴파일 때문일 가능성이 큽니다. 
셰이더 컴파일 jank에 대한 Flutter의 장기적 솔루션은 iOS의 기본 렌더러인 [Impeller][]입니다. 
`--enable-impeller`를 `flutter run`에 전달하여 Android에서 Impeller를 미리 볼 수 있습니다.

[Impeller]: /perf/impeller

Impeller를 완전히 프로덕션에 적합하게 만들기 위해 노력하는 동안, 
iOS 앱과 함께 사전 컴파일된 셰이더를 번들로 묶어 셰이더 컴파일 jank를 완화할 수 있습니다. 
안타깝게도, 이 방법은 사전 컴파일된 셰이더가 기기 또는 GPU에 따라 다르기 때문에 Android에서는 잘 작동하지 않습니다. 
Android 하드웨어 생태계는 규모가 너무 커서, 
애플리케이션과 함께 번들로 제공되는 GPU에 따라 사전 컴파일된 셰이더는 일부 기기에서만 작동하고, 
다른 기기에서는 jank가 더 심해지거나 렌더링 오류가 발생할 가능성이 큽니다.

또한, 아래에 설명된 사전 컴파일된 셰이더를 만드는 개발자 경험을 개선할 계획은 없습니다. 
대신, Impeller가 제공하는 이 문제에 대한 보다 강력한 솔루션에 집중하고 있습니다.

## 셰이더 컴파일 jank란 무엇인가요? {:#what-is-shader-compilation-jank}

셰이더는 GPU(그래픽 처리 장치)에서 실행되는 코드 조각입니다. 
Flutter가 렌더링에 사용하는 Skia 그래픽 백엔드가 처음으로 새로운 그리기 명령 시퀀스를 볼 때, 
때때로 해당 명령 시퀀스에 대한 커스텀 GPU 셰이더를 생성하고 컴파일합니다. 
이를 통해 해당 시퀀스와 잠재적으로 유사한 시퀀스를 가능한 한 빨리 렌더링할 수 있습니다.

안타깝게도, Skia의 셰이더 생성 및 컴파일은 프레임 워크로드와 함께 순서대로 진행됩니다. 
컴파일은 수백 밀리초까지 소요될 수 있는 반면, 부드러운 프레임은 60fps(초당 프레임) 디스플레이의 경우, 16밀리초 이내에 그려야 합니다. 
따라서, 컴파일로 인해 수십 개의 프레임이 누락되고, fps가 60에서 6으로 떨어질 수 있습니다. 
이것이 _컴파일 jank_ 입니다. 
컴파일이 완료된 후에는, 애니메이션이 매끄러워야 합니다.

반면, Impeller는 Flutter Engine을 빌드할 때 필요한 모든 셰이더를 생성하고 컴파일합니다. 
따라서, Impeller에서 실행되는 앱은 이미 필요한 모든 셰이더를 가지고 있으며, 
애니메이션에 jank 없이도 셰이더를 사용할 수 있습니다.

셰이더 컴파일 jank가 존재한다는 확실한 증거는, `--trace-skia`를 활성화하여 추적에서, `GrGLProgramBuilder::finalize`를 설정하는 것입니다. 
다음 스크린샷은 타임라인 추적의 예를 보여줍니다.

![A tracing screenshot verifying jank](/assets/images/docs/perf/render/tracing.png){:width="100%"}

## "첫 번째 실행"이란 무엇을 의미하나요? {:#what-do-we-mean-by-first-run}

iOS에서, "첫 번째 실행"은 사용자가 앱을 처음부터 열 때마다, 애니메이션이 처음 실행될 때 jank가 나타날 수 있음을 의미합니다.

## SkSL 워밍업을 사용하는 방법 {:#how-to-use-sksl-warmup}

Flutter는 앱 개발자가 SkSL(Skia Shader Language) 형식으로, 
최종 사용자에게 필요할 수 있는 셰이더를 수집할 수 있는 명령줄 도구를 제공합니다. 
그런 다음 SkSL 셰이더를 앱에 패키징하고, 최종 사용자가 앱을 처음 열 때 워밍업(사전 컴파일)하여, 
이후 애니메이션의 컴파일 jank를 줄일 수 있습니다. 
다음 지침을 사용하여, SkSL 셰이더를 수집하고 패키징합니다.

<ol>
<li>

SkSL에서 셰이더를 캡처하려면 `--cache-sksl`을 켜서 앱을 실행합니다.

```console
flutter run --profile --cache-sksl
```

동일한 앱이 이전에 `--cache-sksl` 없이 실행된 적이 있는 경우, 
`--purge-persistent-cache` 플래그가 필요할 수 있습니다.

```console
flutter run --profile --cache-sksl --purge-persistent-cache
```

이 플래그는 SkSL 셰이더 캡처링을 방해할 수 있는, 오래된 비-SkSL 셰이더 캐시를 제거합니다. 
또한 SkSL 셰이더를 제거하므로 첫 번째 `--cache-sksl` 실행에서만 사용하세요.
</li>

<li>

필요한 만큼 많은 애니메이션을 트리거하기 위해 앱을 사용해보세요. 
특히 컴파일 jank가 있는 애니메이션을 트리거해보세요.

</li>

<li> 

`flutter run` 명령줄에서 `M`을 눌러, 캡처한 SkSL 셰이더를 `flutter_01.sksl.json`과 같은 이름의 파일에 씁니다. 
최상의 결과를 얻으려면, 실제 iOS 기기에서 SkSL 셰이더를 캡처하세요. 
시뮬레이터에서 캡처한 셰이더는 실제 하드웨어에서 제대로 작동하지 않을 가능성이 큽니다.

</li>

<li> 

적절한 경우, 다음을 사용하여 SkSL 워밍업으로 앱을 빌드하세요.

```console
flutter build ios --bundle-sksl-path flutter_01.sksl.json
```

`test_driver/app.dart`와 같은 드라이버 테스트용으로 빌드된 경우, 
`--target=test_driver/app.dart`도 지정해야 합니다. 
(예: `flutter build ios --bundle-sksl-path flutter_01.sksl.json --target=test_driver/app.dart`)

</li>

<li> 새로 빌드한 앱을 테스트해 보세요.
</li>
</ol>

또는, 단일 명령을 사용하여 처음 세 단계를 자동화하는 통합 테스트를 작성할 수 있습니다. 
예를 들어:

```console
flutter drive --profile --cache-sksl --write-sksl-on-exit flutter_01.sksl.json -t test_driver/app.dart
```

이러한 [통합 테스트][integration tests]를 사용하면, 
앱 코드가 변경되거나 Flutter가 업그레이드될 때, 새로운 SkSL을 쉽고 안정적으로 얻을 수 있습니다. 
이러한 테스트는 SkSL 워밍업 전후의 성능 변화를 확인하는 데에도 사용할 수 있습니다. 
더 나은 점은, 이러한 테스트를 CI(지속적 통합) 시스템에 넣어서, 
SkSL이 앱의 수명 동안 자동으로 생성되고 테스트되도록 할 수 있다는 것입니다.

[integration tests]: /cookbook/testing/integration/introduction

:::note
이제 integration_test 패키지는 통합 테스트를 작성하는 데 권장되는 방법입니다. 
자세한 내용은 [통합 테스트](/testing/integration-tests/) 페이지를 참조하세요.
:::

[Flutter Gallery][]의 원본 버전을 예로 들어보겠습니다. 
CI 시스템은 모든 Flutter 커밋에 대해 SkSL을 생성하도록 설정되어 있으며,
[`transitions_perf_test.dart`][] 테스트에서 성능을 검증합니다. 
자세한 내용은 [`flutter_gallery_sksl_warmup__transition_perf`][] 및 [`flutter_gallery_sksl_warmup__transition_perf_e2e_ios32`][] 작업을 확인하세요.

[Flutter Gallery]: {{site.repo.flutter}}/tree/main/dev/integration_tests/flutter_gallery
[`flutter_gallery_sksl_warmup__transition_perf`]: {{site.repo.flutter}}/blob/master/dev/devicelab/bin/tasks/flutter_gallery_sksl_warmup__transition_perf.dart
[`flutter_gallery_sksl_warmup__transition_perf_e2e_ios32`]: {{site.repo.flutter}}/blob/master/dev/devicelab/bin/tasks/flutter_gallery_sksl_warmup__transition_perf_e2e_ios32.dart
[`transitions_perf_test.dart`]: {{site.repo.flutter}}/blob/master/dev/integration_tests/flutter_gallery/test_driver/transitions_perf_test.dart

최악의 프레임 래스터화 시간은 셰이더 컴파일 jank의 심각도를 나타내는 이러한 통합 테스트에서 유용한 지표입니다. 
예를 들어, 위의 단계는 Flutter 갤러리의 셰이더 컴파일 jank를 줄이고, 
Moto G4에서 최악의 프레임 래스터화 시간을 ~90ms에서 ~40ms로 단축합니다. 
iPhone 4s에서는 ~300ms에서 ~80ms로 단축됩니다. 
이는 이 글의 시작 부분에서 설명한 대로 시각적 차이로 이어집니다.