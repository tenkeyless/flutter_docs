---
# title: Impeller rendering engine
title: Impeller 렌더링 엔진
# description: What is Impeller and how to enable it?
description: Impeller란 무엇이고 어떻게 활성화하나요?
---

## Impeller란? {:#what-is-impeller}

Impeller는 Flutter에 새로운 렌더링 런타임을 제공합니다. 
Flutter 팀은 이것이 Flutter의 [초기 시작 jank(early-onset jank)][early-onset jank] 문제를 해결한다고 믿습니다. 
Impeller는 엔진 빌드 시간에 [더 작고 간단한 셰이더 세트][smaller, simpler set of shaders]를 사전 컴파일하므로 런타임에 컴파일되지 않습니다.

[early-onset jank]: {{site.repo.flutter}}/projects/188
[smaller, simpler set of shaders]: {{site.repo.flutter}}/issues/77412

Impeller에 대한 소개 영상을 보려면, Google I/O 2023에서 있었던 다음 강연을 확인하세요.

{% ytEmbed 'vd5NqS01rlA', 'Flutter의 새로운 렌더링 엔진 Impeller를 소개합니다.' %}

Impeller의 목표는 다음과 같습니다.

* **예측 가능한 성능 (Predictable performance)**:
  Impeller는 빌드 시 모든 셰이더와 리플렉션을 오프라인으로 컴파일합니다.
  모든 파이프라인 상태 객체를 미리 빌드합니다.
  엔진은 캐싱을 제어하고 명시적으로 캐시합니다.
* **계측 가능 (Instrumentable)**:
  Impeller는 (텍스처 및 버퍼와 같은) 모든 그래픽 리소스에 태그를 지정하고, 레이블을 지정합니다.
  프레임당 렌더링 성능에 영향을 미치지 않고, 애니메이션을 캡처하여, 디스크에 유지할 수 있습니다.
* **이식 가능 (Portable)**:
  Flutter는 Impeller를 특정 클라이언트 렌더링 API에 연결하지 않습니다.
  필요에 따라 셰이더를 한 번 작성하여 백엔드별 형식으로 변환할 수 있습니다.
* **최신 그래픽 API 활용 (Leverages modern graphics APIs)**:
  Impeller는 Metal 및 Vulkan과 같은 최신 API에서 사용할 수 있는 기능을 사용하지만, 이에 의존하지 않습니다.
* **동시성 활용 (Leverages concurrency)**:
  필요한 경우 Impeller는 단일 프레임 워크로드를 여러 스레드에 분산할 수 있습니다.

## 유효성 {:#availability}

임펠러는 어디에서 사용할 수 있나요?

### iOS {:#ios}

Flutter는 iOS에서 **기본적으로 Impeller를 활성화합니다.**

* 디버깅 시 iOS에서 Impeller를 _비활성화_ 하려면, `--no-enable-impeller`를 `flutter run` 명령에 전달합니다.

  ```console
  flutter run --no-enable-impeller
  ```

* 앱을 배포할 때 iOS에서 Impeller를 비활성화하려면, 앱의 `Info.plist` 파일에 있는 최상위 `<dict>` 태그 아래에 다음 태그를 추가합니다.

  ```xml
    <key>FLTEnableImpeller</key>
    <false />
  ```

팀은 iOS 지원을 계속 개선하고 있습니다. 
iOS에서 Impeller에 성능이나 충실도 문제(fidelity issues)가 발생하면, [GitHub 추적기][file-issue]에 문제를 제출하세요. 
문제 제목 앞에 `[Impeller]`를 접두사로 붙이고, 재현 가능한 작은 테스트 사례를 포함하세요.

[file-issue]: {{site.repo.flutter}}/issues/new/choose

### macOS {:#macos}

3.19 릴리스부터, 플래그 뒤에 macOS용 Impeller를 사용해 볼 수 있습니다. 
향후 릴리스에서는, Impeller 사용을 옵트아웃하는 기능이 제거됩니다.

디버깅 시 macOS에서 Impeller를 활성화하려면, `--enable-impeller`를 `flutter run` 명령에 전달합니다.

```console
flutter run --enable-impeller
```

앱을 배포할 때 macOS에서 Impeller를 활성화하려면, 앱의 `Info.plist` 파일에 있는 최상위 `<dict>` 태그 아래에 다음 태그를 추가합니다.

```xml
  <key>FLTEnableImpeller</key>
  <true />
```

### Android {:#android}

3.22 릴리스부터, Vulkan이 있는 Android의 Impeller는 릴리스 후보입니다. 
Vulkan을 지원하지 않는 기기에서, Impeller는 레거시 OpenGL 렌더러로 폴백합니다. 
이 폴백 동작에 대해 사용자가 아무런 조치를 취할 필요는 없습니다. 
stable 버전에서 기본이 되기 전에 Android에서 Impeller를 사용해 보는 것을 고려하세요. 
명시적으로 선택할 수 있습니다.

:::secondary 귀하의 기기가 Vulkan을 지원합니까?
귀하의 Android 기기가 Vulkan을 지원하는지 여부는 [Vulkan 지원 확인][vulkan]에서 확인할 수 있습니다.
:::

Vulkan 지원 Android 기기에서 Impeller를 사용해 보려면 `flutter run`에 `--enable-impeller`를 전달하세요.

```console
flutter run --enable-impeller
```

또는, 프로젝트의 AndroidManifest.xml 파일의 `<application>` 태그 아래에 다음 설정을 추가할 수 있습니다.

```xml
<meta-data
    android:name="io.flutter.embedding.android.EnableImpeller"
    android:value="true" />
```

[vulkan]: https://docs.vulkan.org/guide/latest/checking_for_support.html#_android

### 버그 및 이슈 {:#bugs-and-issues}

Impeller의 알려진 버그와 누락된 기능의 전체 리스트는 GitHub의 [Impeller 프로젝트 보드][Impeller project board]에서 최신 정보를 확인할 수 있습니다.

팀은 Impeller 지원을 지속적으로 개선하고 있습니다. 
모든 플랫폼에서 Impeller의 성능 또는 충실도 문제(fidelity issues)가 발생하면, [GitHub 추적기][file-issue]에서 문제를 제출하세요. 
문제 제목 앞에 `[Impeller]`를 붙이고 재현 가능한 작은 테스트 사례를 포함하세요.

Impeller에 대한 문제를 제출할 때 다음 정보를 포함하세요.

* 칩 정보를 포함한, 실행 중인 장치.
* 눈에 보이는 문제의 스크린샷 또는 녹화.
* [성능 추적 내보내기][export of the performance trace]. 파일을 압축하여 GitHub 문제에 첨부하세요.

[export of the performance trace]:/tools/devtools/performance#import-and-export
[Impeller project board]: {{site.github}}/orgs/flutter/projects/21

## 아키텍처 {:#architecture}

Impeller의 디자인과 아키텍처에 대한 자세한 내용을 알아보려면, 소스 트리의 [README.md][] 파일을 확인하세요.

[README.md]: {{site.repo.engine}}/blob/main/impeller/README.md

## 추가 정보 {:#additional-information}

* [자주 묻는 질문]({{site.repo.engine}}/blob/main/impeller/docs/faq.md)
* [Impeller의 좌표계(coordinate system)]({{site.repo.engine}}/blob/main/impeller/docs/coordinate_system.md)
* [Metal로 GPU 프레임 캡처를 위한 Xcode 설정 방법]({{site.repo.engine}}/blob/main/impeller/docs/xcode_frame_capture.md)
* [GPU 프레임 캡처를 읽는 방법]({{site.repo.engine}}/blob/main/impeller/docs/read_frame_captures.md)
* [명령줄 앱에 대한 Metal 검증을 활성화하는 방법]({{site.repo.engine}}/blob/main/impeller/docs/metal_validation.md)
* [Impeller가 균일한 버퍼가 부족한 문제를 해결하는 방법 Open GL ES 2.0]({{site.repo.engine}}/blob/main/impeller/docs/ubo_gles2.md)
* [효율적인 셰이더를 작성하기 위한 가이드]({{site.repo.engine}}/blob/main/impeller/docs/shader_optimization.md)
* [Impeller에서 색상 블렌딩이 작동하는 방식]({{site.repo.engine}}/blob/main/impeller/docs/blending.md)