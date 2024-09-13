---
# title: Leveraging Apple's system APIs and frameworks
title: Apple의 시스템 API 및 프레임워크 활용
# description: >-
#   Learn about Flutter plugins that offer equivalent
#   functionalities to Apple's frameworks.
description: >-
  Apple 프레임워크와 동일한 기능을 제공하는 Flutter 플러그인에 대해 알아보세요.
---

iOS 개발에서 온 경우, Apple의 시스템 라이브러리와 동일한 기능을 제공하는 Flutter 플러그인을 찾아야 할 수도 있습니다. 
여기에는 기기 하드웨어에 액세스하거나 `HealthKit`과 같은 특정 프레임워크와 상호 작용하는 것이 포함될 수 있습니다.

SwiftUI 프레임워크가 Flutter와 어떻게 비교되는지에 대한 개요는 [SwiftUI 개발자를 위한 Flutter][Flutter for SwiftUI developers]를 참조하세요.

## Flutter 플러그인 소개 {:#introducing-flutter-plugins}

Dart는 플랫폼별 코드가 포함된 라이브러리를 _플러그인_ 이라고 부르는데, 
이는 "플러그인 패키지"의 줄임말입니다. 
Flutter로 앱을 개발할 때, _플러그인_ 을 사용하여 시스템 라이브러리와 상호 작용합니다.

Dart 코드에서, 플러그인의 Dart API를 사용하여 사용 중인 시스템 라이브러리에서 네이티브 코드를 호출합니다. 
즉, Dart API를 호출하는 코드를 작성할 수 있습니다. 
그런 다음, API는 플러그인이 지원하는 모든 플랫폼에서 작동하도록 합니다.

플러그인에 대해 자세히 알아보려면, [패키지 사용][Using packages]을 참조하세요. 
이 페이지는 일부 인기 있는 플러그인에 대한 링크를 제공하지만, 
[pub.dev][]에서 수천 개의 플러그인과 예제를 찾을 수 있습니다. 
다음 표는 특정 플러그인을 보증하지 않습니다. 
필요에 맞는 패키지를 찾을 수 없는 경우, 직접 만들거나 프로젝트에서 플랫폼 채널을 직접 사용할 수 있습니다. 
자세히 알아보려면 [플랫폼별 코드 작성][Writing platform-specific code]을 확인하세요.

## 프로젝트에 플러그인 추가하기 {:#adding-a-plugin-to-your-project}

네이티브 프로젝트 내에서 Apple 프레임워크를 사용하려면, Swift 또는 Objective-C 파일에 import 합니다.

Flutter 플러그인을 추가하려면, 프로젝트 루트에서 `flutter pub add package_name`을 실행합니다. 
이렇게 하면 종속성이 [`pubspec.yaml`][] 파일에 추가됩니다. 
종속성을 추가한 후, Dart 파일에 패키지에 대한 `import` 문을 추가합니다.

앱 설정이나 초기화 로직을 변경해야 할 수도 있습니다. 
필요한 경우 [pub.dev][]의 패키지 "Readme" 페이지에서 자세한 내용을 확인할 수 있습니다.

### Flutter 플러그인과 Apple 프레임워크 {:#flutter-plugins-and-apple-frameworks}

| 사용 사례       | Apple 프레임워크 또는 클래스    | Flutter 플러그인               |
|------------------------------------------------|---------------------------------------------------------------------------------------|------------------------------|
| 사진 라이브러리에 액세스 | `Photos` 및 `PhotosUI` 프레임워크와 `UIImagePickerController`를 사용하는 `PhotoKit` | [`image_picker`][]           |
| 카메라에 액세스   | `.camera` `sourceType`을 사용하는 `UIImagePickerController` | [`image_picker`][]           |
| 고급 카메라 기능 사용                   | `AVFoundation`                                                                        | [`camera`][]                 |
| 앱 내 구매 제공                         | `StoreKit`                                                                            | [`in_app_purchase`][][^1]    |
| 결제 처리                               | `PassKit`                                                                             | [`pay`][][^2]                |
| 푸시 알림 보내기                        | `UserNotifications`                                                                   | [`firebase_messaging`][][^3] |
| GPS 좌표에 액세스                         | `CoreLocation`                                                                        | [`geolocator`][]             |
| 센서 데이터에 액세스[^4]                         | `CoreMotion`                                                                          | [`sensors_plus`][]           |
| 네트워크 요청하기                          | `URLSession`                                                                          | [`http`][]                   |
| 키-값 저장                               | `@AppStorage` 속성 래퍼 및 `NSUserDefaults`   | [`shared_preferences`][]     |
| 데이터베이스에 유지                          | `CoreData` 또는 SQLite                                                                  | [`sqflite`][]                |
| 건강 데이터에 액세스                             | `HealthKit`                                                                           | [`health`][]                 |
| 머신러닝 사용                           | `CoreML`                                                                              | [`google_ml_kit`][][^5]      |
| 텍스트 인식                                 | `VisionKit`                                                                           | [`google_ml_kit`][][^5]      |
| 음성 인식                               | `Speech`                                                                              | [`speech_to_text`][]         |
| 증강 현실 사용                          | `ARKit`                                                                               | [`ar_flutter_plugin`][]      |
| 날씨 데이터에 액세스                            | `WeatherKit`                                                                          | [`weather`][][^6]            |
| 연락처 액세스 및 관리                     | `Contacts`                                                                            | [`contacts_service`][]       |
| 홈 화면에 빠른 작업 표시        | `UIApplicationShortcutItem`                                                           | [`quick_actions`][]          |
| Spotlight 검색에서 항목 인덱스                | `CoreSpotlight`                                                                       | [`flutter_core_spotlight`][] |
| 위젯 구성, 업데이트 및 통신 | `WidgetKit`                                                                           | [`home_widget`][]            |

{:.table .table-striped .nowrap}

[^1]: Android의 Google Play Store와 iOS의 Apple App Store를 모두 지원합니다.
[^2]: Android에서는 Google Pay 결제를, iOS에서는 Apple Pay 결제를 추가합니다.
[^3]: Firebase 클라우드 메시징을 사용하고 APN과 통합됩니다.
[^4]: 가속도계, 자이로스코프 등의 센서가 포함됩니다.
[^5]: Google의 ML Kit을 사용하고 (텍스트 인식, 얼굴 감지, 이미지 레이블 지정, 랜드마크 인식 및 바코드 스캐닝과 같은) 다양한 기능을 지원합니다. Firebase를 사용하여 커스텀 모델을 만들 수도 있습니다. 자세한 내용은, [Flutter로 커스텀 TensorFlow Lite 모델 사용][Use a custom TensorFlow Lite model with Flutter]을 참조하세요.
[^6]: [OpenWeatherMap API][]를 사용합니다. 다른 날씨 API에서 가져올 수 있는 다른 패키지가 있습니다.

[Flutter for SwiftUI developers]: /get-started/flutter-for/swiftui-devs
[Using packages]: /packages-and-plugins/using-packages
[pub.dev]: {{site.pub-pkg}}
[`shared_preferences`]: {{site.pub-pkg}}/shared_preferences
[`http`]: {{site.pub-pkg}}/http
[`sensors_plus`]: {{site.pub-pkg}}/sensors_plus
[`geolocator`]: {{site.pub-pkg}}/geolocator
[`image_picker`]: {{site.pub-pkg}}/image_picker
[`pubspec.yaml`]: /tools/pubspec
[`quick_actions`]: {{site.pub-pkg}}/quick_actions
[`in_app_purchase`]: {{site.pub-pkg}}/in_app_purchase
[`pay`]: {{site.pub-pkg}}/pay
[`firebase_messaging`]: {{site.pub-pkg}}/firebase_messaging
[`google_ml_kit`]: {{site.pub-pkg}}/google_ml_kit
[Use a custom TensorFlow Lite model with Flutter]: {{site.firebase}}/docs/ml/flutter/use-custom-models
[`speech_to_text`]: {{site.pub-pkg}}/speech_to_text
[`ar_flutter_plugin`]: {{site.pub-pkg}}/ar_flutter_plugin
[`weather`]: {{site.pub-pkg}}/weather
[`contacts_service`]: {{site.pub-pkg}}/contacts_service
[`health`]: {{site.pub-pkg}}/health
[OpenWeatherMap API]: https://openweathermap.org/api
[`sqflite`]: {{site.pub-pkg}}/sqflite
[Writing platform-specific code]: /platform-integration/platform-channels
[`camera`]: {{site.pub-pkg}}/camera
[`flutter_core_spotlight`]: {{site.pub-pkg}}/flutter_core_spotlight
[`home_widget`]: {{site.pub-pkg}}/home_widget
