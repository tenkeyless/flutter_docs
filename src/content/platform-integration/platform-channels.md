---
# title: Writing custom platform-specific code
title: 플랫폼별 커스텀 코드 작성
# short-title: Platform-specific code
short-title: 플랫폼별 코드
# description: Learn how to write custom platform-specific code in your app.
description: 앱에서 플랫폼별 커스텀 코드를 작성하는 방법을 알아보세요.
---

<?code-excerpt path-base="platform_integration"?>

이 가이드에서는 커스텀 플랫폼별 코드를 작성하는 방법을 설명합니다. 
일부 플랫폼별 기능은 기존 패키지를 통해 사용할 수 있습니다. 
[패키지 사용][using packages]을 참조하세요.

[using packages]: /packages-and-plugins/using-packages

:::note
이 페이지의 정보는 대부분 플랫폼에 유효하지만, 
웹의 플랫폼별 코드는 일반적으로 [JS 상호 운용성][JS interoperability] 또는 [`dart:html` 라이브러리][`dart:html` library]를 대신 사용합니다.
:::

Flutter는, 해당 API와 직접 작동하는 언어로 플랫폼별 API를 호출할 수 있는, 유연한 시스템을 사용합니다.

* Android에서 Kotlin 또는 Java
* iOS에서 Swift 또는 Objective-C
* Windows에서 C++
* macOS에서 Objective-C
* Linux에서 C

Flutter의 내장 플랫폼별 API 지원은 코드 생성에 의존하지 않고, 유연한 메시지 전달 스타일을 사용합니다. 
또는, 코드 생성을 통해 [구조화된 타입 세이프 메시지 보내기][sending structured typesafe messages]를 위한 [Pigeon][pigeon] 패키지를 사용할 수 있습니다.

* 앱의 Flutter 부분은 플랫폼 채널을 통해, 앱의 Dart가 아닌 부분인, _호스트_ 로 메시지를 보냅니다.

* _호스트_ 는 플랫폼 채널을 listens하고, 메시지를 받습합니다. 
  그런 다음, (네이티브 프로그래밍 언어를 사용하여) 플랫폼별 API를 여러 개 호출하고, 
  앱의 Flutter 부분인, _클라이언트_ 로 응답을 다시 보냅니다.

:::note
이 가이드에서는 Dart가 아닌 언어로 플랫폼의 API를 사용해야 하는 경우, 플랫폼 채널 메커니즘을 사용하는 방법을 다룹니다. 
하지만, [`defaultTargetPlatform`][] 속성을 검사하여, Flutter 앱에서 플랫폼별 Dart 코드를 작성할 수도 있습니다. 
[플랫폼 적응][Platform adaptations]은 Flutter가 프레임워크에서 자동으로 수행하는 일부 플랫폼별 적응을 나열합니다.
:::

[`defaultTargetPlatform`]: {{site.api}}/flutter/foundation/defaultTargetPlatform.html
[pigeon]: {{site.pub-pkg}}/pigeon

## 아키텍처 개요: 플랫폼 채널 {:#architecture}

메시지는 이 다이어그램에 표시된 것처럼, 플랫폼 채널을 사용하여, 클라이언트(UI)와 호스트(플랫폼) 간에 전달됩니다.

![Platform channels architecture](/assets/images/docs/PlatformChannels.png){:width="100%"}

사용자 인터페이스가 항상 반응성(responsive)을 유지할 수 있도록, 메시지와 응답은 비동기적으로 전달됩니다.

:::note
Flutter가 Dart와 비동기적으로 메시지를 주고받는다고 하더라도, 
채널 메서드를 호출할 때마다, 플랫폼의 메인 스레드에서 해당 메서드를 호출해야 합니다. 
자세한 내용은 [스레딩 섹션(section on threading)][section on threading]을 참조하세요.
:::

클라이언트 측에서, [`MethodChannel`][]은 메서드 호출에 해당하는 메시지를 보낼 수 있도록 합니다. 
플랫폼 측에서, Android의 `MethodChannel`([`MethodChannelAndroid`][])과 iOS의 `FlutterMethodChannel`([`MethodChanneliOS`][])은 메서드 호출을 수신하고, 결과를 다시 보낼 수 있도록 합니다. 
이러한 클래스를 사용하면 매우 적은 '보일러플레이트' 코드로 플랫폼 플러그인을 개발할 수 있습니다.

:::note
원하는 경우, 메서드 호출은 역방향으로도 전송될 수 있으며, 플랫폼은 Dart에서 구현된 메서드에 대한 클라이언트 역할을 합니다. 
구체적인 예는, [`quick_actions`][] 플러그인을 확인하세요.
:::

### 플랫폼 채널 데이터 타입 지원 및 코덱 {:#codec}

표준 플랫폼 채널은 (booleans, 숫자, 문자열, 바이트 버퍼, 이러한 값의 리스트 및 맵과 같은) 간단한 JSON 유사(JSON-like) 값의 효율적인 이진 직렬화를 지원하는 표준 메시지 코덱을 사용합니다. (자세한 내용은 [`StandardMessageCodec`][] 참조) 
이러한 값의 메시지 직렬화 및 역직렬화는 값을 보내고 받을 때 자동으로 수행됩니다.

다음 표는 Dart 값이 플랫폼 측에서 수신되는 방식과 그 반대의 방식을 보여줍니다.

{% tabs "platform-channel-language" %}
{% tab "Kotlin" %}

| Dart              | Kotlin        |
| ----------------- | ------------- |
| `null`            | `null`        |
| `bool`            | `Boolean`     |
| `int` (<=32 bits) | `Int`         |
| `int` (>32 bits)  | `Long`        |
| `double`          | `Double`      |
| `String`          | `String`      |
| `Uint8List`       | `ByteArray`   |
| `Int32List`       | `IntArray`    |
| `Int64List`       | `LongArray`   |
| `Float32List`     | `FloatArray`  |
| `Float64List`     | `DoubleArray` |
| `List`            | `List`        |
| `Map`             | `HashMap`     |

{:.table .table-striped}

{% endtab %}
{% tab "Java" %}

| Dart              | Java                  |
| ----------------- | --------------------- |
| `null`            | `null`                |
| `bool`            | `java.lang.Boolean`   |
| `int` (<=32 bits) | `java.lang.Integer`   |
| `int` (>32 bits)  | `java.lang.Long`      |
| `double`          | `java.lang.Double`    |
| `String`          | `java.lang.String`    |
| `Uint8List`       | `byte[]`              |
| `Int32List`       | `int[]`               |
| `Int64List`       | `long[]`              |
| `Float32List`     | `float[]`             |
| `Float64List`     | `double[]`            |
| `List`            | `java.util.ArrayList` |
| `Map`             | `java.util.HashMap`   |

{:.table .table-striped}

{% endtab %}
{% tab "Swift" %}

| Dart              | Swift                                     |
| ----------------- | ----------------------------------------- |
| `null`            | `nil` (`NSNull` when nested)              |
| `bool`            | `NSNumber(value: Bool)`                   |
| `int` (<=32 bits) | `NSNumber(value: Int32)`                  |
| `int` (>32 bits)  | `NSNumber(value: Int)`                    |
| `double`          | `NSNumber(value: Double)`                 |
| `String`          | `String`                                  |
| `Uint8List`       | `FlutterStandardTypedData(bytes: Data)`   |
| `Int32List`       | `FlutterStandardTypedData(int32: Data)`   |
| `Int64List`       | `FlutterStandardTypedData(int64: Data)`   |
| `Float32List`     | `FlutterStandardTypedData(float32: Data)` |
| `Float64List`     | `FlutterStandardTypedData(float64: Data)` |
| `List`            | `Array`                                   |
| `Map`             | `Dictionary`                              |

{:.table .table-striped}

{% endtab %}
{% tab "Obj-C" %}

| Dart              | Objective-C                                      |
| ----------------- | ------------------------------------------------ |
| `null`            | `nil` (`NSNull` when nested)                     |
| `bool`            | `NSNumber numberWithBool:`                       |
| `int` (<=32 bits) | `NSNumber numberWithInt:`                        |
| `int` (>32 bits)  | `NSNumber numberWithLong:`                       |
| `double`          | `NSNumber numberWithDouble:`                     |
| `String`          | `NSString`                                       |
| `Uint8List`       | `FlutterStandardTypedData typedDataWithBytes:`   |
| `Int32List`       | `FlutterStandardTypedData typedDataWithInt32:`   |
| `Int64List`       | `FlutterStandardTypedData typedDataWithInt64:`   |
| `Float32List`     | `FlutterStandardTypedData typedDataWithFloat32:` |
| `Float64List`     | `FlutterStandardTypedData typedDataWithFloat64:` |
| `List`            | `NSArray`                                        |
| `Map`             | `NSDictionary`                                   |

{:.table .table-striped}

{% endtab %}
{% tab "C++" %}

| Dart               | C++                                                        |
| ------------------ | ---------------------------------------------------------- |
| `null`             | `EncodableValue()`                                         |
| `bool`             | `EncodableValue(bool)`                                     |
| `int` (<=32 bits)  | `EncodableValue(int32_t)`                                  |
| `int` (>32 bits)   | `EncodableValue(int64_t)`                                  |
| `double`           | `EncodableValue(double)`                                   |
| `String`           | `EncodableValue(std::string)`                              |
| `Uint8List`        | `EncodableValue(std::vector<uint8_t>)`                     |
| `Int32List`        | `EncodableValue(std::vector<int32_t>)`                     |
| `Int64List`        | `EncodableValue(std::vector<int64_t>)`                     |
| `Float32List`      | `EncodableValue(std::vector<float>)`                       |
| `Float64List`      | `EncodableValue(std::vector<double>)`                      |
| `List`             | `EncodableValue(std::vector<EncodableValue>)`              |
| `Map`              | `EncodableValue(std::map<EncodableValue, EncodableValue>)` |

{:.table .table-striped}

{% endtab %}
{% tab "C" %}

| Dart               | C (GObject)                 |
| ------------------ | --------------------------- |
| `null`             | `FlValue()`                 |
| `bool`             | `FlValue(bool)`             |
| `int`              | `FlValue(int64_t)`          |
| `double`           | `FlValue(double)`           |
| `String`           | `FlValue(gchar*)`           |
| `Uint8List`        | `FlValue(uint8_t*)`         |
| `Int32List`        | `FlValue(int32_t*)`         |
| `Int64List`        | `FlValue(int64_t*)`         |
| `Float32List`      | `FlValue(float*)`           |
| `Float64List`      | `FlValue(double*)`          |
| `List`             | `FlValue(FlValue)`          |
| `Map`              | `FlValue(FlValue, FlValue)` |

{:.table .table-striped}

{% endtab %}
{% endtabs %}

## 예제 : 플랫폼 채널을 사용하여 플랫폼별 코드 호출 {:#example}

다음 코드는 플랫폼별 API를 호출하여, 현재 배터리 수준을 검색하고 표시하는 방법을 보여줍니다. 
Android `BatteryManager` API, iOS `device.batteryLevel` API, 
Windows `GetSystemPowerStatus` API, Linux `UPower` API를 
단일 플랫폼 메시지 `getBatteryLevel()`와 함께 사용합니다.

이 예제는 메인 앱 자체 내부에 플랫폼별 코드를 추가합니다. 
여러 앱에 플랫폼별 코드를 재사용하려는 경우, 프로젝트 생성 단계는 약간 다르지만([패키지 개발][plugins] 참조), 
플랫폼 채널 코드는 여전히 동일한 방식으로 작성됩니다.

:::note
이 예제의 전체 실행 가능한 소스 코드는 
Java를 사용하는 Android, Objective-C를 사용하는 iOS, C++를 사용하는 Windows, C를 사용하는 Linux에서 [`/examples/platform_channel/`][]에서 사용할 수 있습니다. 
Swift를 사용하는 iOS의 경우, [`/examples/platform_channel_swift/`][]를 참조하세요.
:::

### 스텝 1: 새로운 앱 프로젝트 만들기 {:#example-project}

새 앱을 만드는 것으로 시작합니다.

* 터미널에서 실행: `flutter create batterylevel`

기본적으로, 저희 템플릿은 Kotlin을 사용하여 Android 코드를 작성하거나, Swift를 사용하여 iOS 코드를 작성하는 것을 지원합니다. Java 또는 Objective-C를 사용하려면 `-i` 및/또는 `-a` 플래그를 사용합니다.

* 터미널에서 실행: `flutter create -i objc -a java batterylevel`

### 스텝 2: Flutter 플랫폼 클라이언트 생성 {:#example-client}

앱의 `State` 클래스는 현재 앱 상태를 보관합니다. 이를 확장하여 현재 배터리 상태를 보관합니다.

먼저, 채널을 구성합니다. 배터리 수준을 반환하는 단일 플랫폼 메서드가 있는 `MethodChannel`을 사용합니다.

채널의 클라이언트 및 호스트 측은 채널 생성자에서 전달된 채널 이름을 통해 연결됩니다. 
단일 앱에서 사용되는 모든 채널 이름은 고유해야 합니다. 
채널 이름 앞에 고유한 '도메인 접두사'를 붙입니다. (예: `samples.flutter.dev/battery`)

<?code-excerpt "platform_channels/lib/platform_channels.dart (import)"?>
```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
```

<?code-excerpt "platform_channels/lib/platform_channels.dart (my-home-page-state)"?>
```dart
class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('samples.flutter.dev/battery');
  // 배터리 수준을 확인합니다.
```

다음으로, 메서드 채널에서 메서드를 호출하고, 
`String` 식별자 `getBatteryLevel`을 사용하여 호출할 구체적인 메서드를 지정합니다. 
호출이 실패할 수 있습니다. 
예를 들어, 플랫폼이 플랫폼 API를 지원하지 않는 경우(예: 시뮬레이터에서 실행할 때)가 그렇습니다. 
따라서, `invokeMethod` 호출을 try-catch 문으로 래핑합니다.

반환된 결과를 사용하여, `setState` 내부의 `_batteryLevel`에서 사용자 인터페이스 상태를 업데이트합니다.

<?code-excerpt "platform_channels/lib/platform_channels.dart (get-battery)"?>
```dart
// 배터리 수준을 확인합니다.
String _batteryLevel = 'Unknown battery level.';

Future<void> _getBatteryLevel() async {
  String batteryLevel;
  try {
    final result = await platform.invokeMethod<int>('getBatteryLevel');
    batteryLevel = 'Battery level at $result % .';
  } on PlatformException catch (e) {
    batteryLevel = "Failed to get battery level: '${e.message}'.";
  }

  setState(() {
    _batteryLevel = batteryLevel;
  });
}
```

마지막으로, 템플릿의 `build` 메서드를 배터리 상태를 문자열로 표시하는 작은 사용자 인터페이스와, 
값을 새로 고침하는 버튼을 포함하도록 바꿉니다.

<?code-excerpt "platform_channels/lib/platform_channels.dart (build)"?>
```dart
@override
Widget build(BuildContext context) {
  return Material(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: _getBatteryLevel,
            child: const Text('Get Battery Level'),
          ),
          Text(_batteryLevel),
        ],
      ),
    ),
  );
}
```

### 스텝 3: Android 플랫폼별 구현 추가 {:#step-3-add-an-android-platform-specific-implementation}

{% tabs "android-language" %}
{% tab "Kotlin" %}

Android Studio에서 Flutter 앱의 Android 호스트 부분을 열어 시작합니다.

1. Android Studio 시작

2. **File > Open...** 메뉴 항목을 선택합니다.

3. Flutter 앱이 있는 디렉토리로 이동하여, 그 안에 있는 **android** 폴더를 선택합니다. **OK**을 클릭합니다.

4. Project 뷰에서 **kotlin** 폴더에 있는 `MainActivity.kt` 파일을 엽니다.

`configureFlutterEngine()` 메서드 내에서, `MethodChannel`을 만들고, `setMethodCallHandler()`를 호출합니다. 
Flutter 클라이언트 측에서 사용한 것과 동일한 채널 이름을 사용해야 합니다.

```kotlin title="MainActivity.kt"
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
  private val CHANNEL = "samples.flutter.dev/battery"

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      call, result ->
      // 이 메서드는 메인 스레드에서 호출됩니다.
      // TODO
    }
  }
}
```

Android 배터리 API를 사용하여, 배터리 수준을 검색하는 Android Kotlin 코드를 추가합니다. 
이 코드는 네이티브 Android 앱에서 작성하는 코드와 정확히 동일합니다.

먼저, 파일 맨 위에 필요한 import를 추가합니다.

```kotlin title="MainActivity.kt"
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
```

다음으로, `configureFlutterEngine()` 메서드 아래의 `MainActivity` 클래스에 다음 메서드를 추가합니다.

```kotlin title="MainActivity.kt"
  private fun getBatteryLevel(): Int {
    val batteryLevel: Int
    if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
      val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
      batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    } else {
      val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
      batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
    }

    return batteryLevel
  }
```

마지막으로, 이전에 추가한 `setMethodCallHandler()` 메서드를 완성합니다. 
단일 플랫폼 메서드인 `getBatteryLevel()`를 처리해야 하므로, `call` 인수에서 테스트합니다. 
이 플랫폼 메서드의 구현은 이전 단계에서 작성된 Android 코드를 호출하고, 
`result` 인수를 사용하여 성공 및 오류 사례에 대한 응답을 반환합니다. 
알 수 없는 메서드가 호출되면, 대신 보고합니다.

다음 코드를 제거합니다.

```kotlin title="MainActivity.kt"
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      call, result ->
      // 이 메서드는 메인 스레드에서 호출됩니다.
      // TODO
    }
```

다음으로 대체합니다:

```kotlin title="MainActivity.kt"
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      // 이 메서드는 메인 스레드에서 호출됩니다.
      call, result ->
      if (call.method == "getBatteryLevel") {
        val batteryLevel = getBatteryLevel()

        if (batteryLevel != -1) {
          result.success(batteryLevel)
        } else {
          result.error("UNAVAILABLE", "Battery level not available.", null)
        }
      } else {
        result.notImplemented()
      }
    }
```

{% endtab %}
{% tab "Java" %}

Android Studio에서 Flutter 앱의 Android 호스트 부분을 열어 시작합니다.

1. Android Studio 시작

2. **File > Open...** 메뉴 항목을 선택합니다.

3. Flutter 앱이 있는 디렉토리로 이동하여, 그 안에 있는 **android** 폴더를 선택합니다. **OK**을 클릭합니다.

4. Project 뷰에서 **java** 폴더에 있는 `MainActivity.java` 파일을 엽니다.

다음으로, `MethodChannel`을 만들고 `configureFlutterEngine()` 메서드 내부에 `MethodCallHandler`를 설정합니다. 
Flutter 클라이언트 측에서 사용한 것과 동일한 채널 이름을 사용해야 합니다.

```java title="MainActivity.java"
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "samples.flutter.dev/battery";

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
        .setMethodCallHandler(
          (call, result) -> {
            // 이 메서드는 메인 스레드에서 호출됩니다.
            // TODO
          }
        );
  }
}
```

Android 배터리 API를 사용하여 배터리 수준을 검색하는 Android Java 코드를 추가합니다. 
이 코드는 네이티브 Android 앱에서 작성하는 코드와 정확히 동일합니다.

먼저 파일 맨 위에 필요한 import를 추가합니다.

```java title="MainActivity.java"
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Bundle;
```

그런 다음 `configureFlutterEngine()` 메서드 아래에 있는 activity 클래스에서 다음을 새 메서드로 추가합니다.

```java title="MainActivity.java"
  private int getBatteryLevel() {
    int batteryLevel = -1;
    if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
      BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
      batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
    } else {
      Intent intent = new ContextWrapper(getApplicationContext()).
          registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
      batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
          intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
    }

    return batteryLevel;
  }
```

마지막으로, 이전에 추가한 `setMethodCallHandler()` 메서드를 완성합니다. 
단일 플랫폼 메서드인 `getBatteryLevel()`를 처리해야 하므로, `call` 인수에서 테스트합니다. 
이 플랫폼 메서드의 구현은 이전 단계에서 작성된 Android 코드를 호출하고, 
`result` 인수를 사용하여 성공 및 오류 사례에 대한 응답을 반환합니다. 
알 수 없는 메서드가 호출되면, 대신 보고합니다.

다음 코드를 제거합니다.

```java title="MainActivity.java"
      new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
        .setMethodCallHandler(
          (call, result) -> {
            // 이 메서드는 메인 스레드에서 호출됩니다.
            // TODO
          }
      );
```

다음으로 대체합니다:

```java title="MainActivity.java"
      new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
        .setMethodCallHandler(
          (call, result) -> {
            // 이 메서드는 메인 스레드에서 호출됩니다.
            if (call.method.equals("getBatteryLevel")) {
              int batteryLevel = getBatteryLevel();

              if (batteryLevel != -1) {
                result.success(batteryLevel);
              } else {
                result.error("UNAVAILABLE", "Battery level not available.", null);
              }
            } else {
              result.notImplemented();
            }
          }
      );
```

{% endtab %}
{% endtabs %}

이제 Android에서 앱을 실행할 수 있습니다. 
Android Emulator를 사용하는 경우, 
도구 모음의 **...** 버튼에서 액세스할 수 있는 Extended Controls 패널에서 배터리 수준을 설정합니다.

### 스텝 4: iOS 플랫폼별 구현 추가 {:#step-4-add-an-ios-platform-specific-implementation}

{% tabs "darwin-language" %}
{% tab "Swift" %}

Xcode에서 Flutter 앱의 iOS 호스트 부분을 열어 시작합니다.

1. Xcode를 시작합니다.

1. **File > Open...** 메뉴 항목을 선택합니다.

1. Flutter 앱이 있는 디렉토리로 이동하여, 그 안에 있는 **ios** 폴더를 선택합니다. **OK**를 클릭합니다.

Objective-C를 사용하는 표준 템플릿 설정에서 Swift에 대한 지원을 추가합니다.

1. 프로젝트 탐색기에서 **Expand Runner > Runner**를 선택합니다.

1. 프로젝트 탐색기에서 **Runner > Runner** 아래에 있는 `AppDelegate.swift` 파일을 엽니다.

`application:didFinishLaunchingWithOptions:` 함수를 재정의하고, 
채널 이름 `samples.flutter.dev/battery`에 연결된 `FlutterMethodChannel`을 만듭니다.

```swift title="AppDelegate.swift"
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let batteryChannel = FlutterMethodChannel(name: "samples.flutter.dev/battery",
                                              binaryMessenger: controller.binaryMessenger)
    batteryChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
      // 이 메서드는 UI 스레드에서 호출됩니다.
      // 배터리 메시지를 처리합니다.
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

다음으로, 배터리 수준을 검색하기 위해 iOS 배터리 API를 사용하는 iOS Swift 코드를 추가합니다. 
이 코드는 네이티브 iOS 앱에서 작성하는 코드와 정확히 동일합니다.

다음을 `AppDelegate.swift` 하단에 새 메서드로 추가합니다.

```swift title="AppDelegate.swift"
private func receiveBatteryLevel(result: FlutterResult) {
  let device = UIDevice.current
  device.isBatteryMonitoringEnabled = true
  if device.batteryState == UIDevice.BatteryState.unknown {
    result(FlutterError(code: "UNAVAILABLE",
                        message: "Battery level not available.",
                        details: nil))
  } else {
    result(Int(device.batteryLevel * 100))
  }
}
```

마지막으로, 이전에 추가한 `setMethodCallHandler()` 메서드를 완성합니다. 
단일 플랫폼 메서드인 `getBatteryLevel()`를 처리해야 하므로, `call` 인수에서 테스트합니다. 
이 플랫폼 메서드의 구현은 이전 단계에서 작성된 iOS 코드를 호출합니다. 
알 수 없는 메서드가 호출되면, 대신 보고합니다.

```swift title="AppDelegate.swift"
batteryChannel.setMethodCallHandler({
  [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
  // 이 메서드는 UI 스레드에서 호출됩니다.
  guard call.method == "getBatteryLevel" else {
    result(FlutterMethodNotImplemented)
    return
  }
  self?.receiveBatteryLevel(result: result)
})
```

{% endtab %}
{% tab "Objective-C" %}

Xcode에서 Flutter 앱의 iOS 호스트 부분을 열어 시작합니다.

1. Xcode를 시작합니다.

1. **File > Open...** 메뉴 항목을 선택합니다.

1. Flutter 앱이 있는 디렉토리로 이동하여, 그 안에 있는 **ios** 폴더를 선택합니다. **OK**를 클릭합니다.

1. Xcode 프로젝트가 오류 없이 빌드되는지 확인합니다.

1. 프로젝트 탐색기에서 **Runner > Runner** 아래에 있는 `AppDelegate.m` 파일을 엽니다.

`FlutterMethodChannel`을 만들고, `application didFinishLaunchingWithOptions:` 메서드 내부에 
핸들러를 추가합니다. 
Flutter 클라이언트 측에서 사용된 것과 동일한 채널 이름을 사용해야 합니다.

```objc title="AppDelegate.m"
#import <Flutter/Flutter.h>
#import "GeneratedPluginRegistrant.h"

@implementation AppDelegate
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
  FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;

  FlutterMethodChannel* batteryChannel = [FlutterMethodChannel
                                          methodChannelWithName:@"samples.flutter.dev/battery"
                                          binaryMessenger:controller.binaryMessenger];

  [batteryChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
    // 이 메서드는 UI 스레드에서 호출됩니다.
    // TODO
  }];

  [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
```

다음으로, 배터리 수준을 검색하기 위해 iOS 배터리 API를 사용하는 iOS ObjectiveC 코드를 추가합니다. 
이 코드는 네이티브 iOS 앱에서 작성하는 코드와 정확히 같습니다.

`AppDelegate` 클래스에서 `@end` 바로 앞에 다음 메서드를 추가합니다.

```objc title="AppDelegate.m"
- (int)getBatteryLevel {
  UIDevice* device = UIDevice.currentDevice;
  device.batteryMonitoringEnabled = YES;
  if (device.batteryState == UIDeviceBatteryStateUnknown) {
    return -1;
  } else {
    return (int)(device.batteryLevel * 100);
  }
}
```

마지막으로, 이전에 추가한 `setMethodCallHandler()` 메서드를 완성합니다. 
단일 플랫폼 메서드인 `getBatteryLevel()`를 처리해야 하므로, `call` 인수에서 테스트합니다. 
이 플랫폼 메서드의 구현은 이전 단계에서 작성된 iOS 코드를 호출하고 `result` 인수를 사용하여, 
성공 및 오류 사례에 대한 응답을 반환합니다. 
알 수 없는 메서드가 호출되면, 대신 보고합니다.

```objc title="AppDelegate.m"
__weak typeof(self) weakSelf = self;
[batteryChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
  // 이 메서드는 UI 스레드에서 호출됩니다.
  if ([@"getBatteryLevel" isEqualToString:call.method]) {
    int batteryLevel = [weakSelf getBatteryLevel];

    if (batteryLevel == -1) {
      result([FlutterError errorWithCode:@"UNAVAILABLE"
                                 message:@"Battery level not available."
                                 details:nil]);
    } else {
      result(@(batteryLevel));
    }
  } else {
    result(FlutterMethodNotImplemented);
  }
}];
```

{% endtab %}
{% endtabs %}

이제 iOS에서 앱을 실행할 수 있습니다. 
iOS 시뮬레이터를 사용하는 경우, 배터리 API를 지원하지 않으며, 앱에 'Battery level not available'이 표시됩니다.
  
### 스텝 5: Windows 플랫폼별 구현 추가 {:#step-5-add-a-windows-platform-specific-implementation}

Visual Studio에서 Flutter 앱의 Windows 호스트 부분을 열어 시작합니다.

1. 프로젝트 디렉토리에서 `flutter build windows`를 한 번 실행하여, Visual Studio 솔루션 파일을 생성합니다.

2. Visual Studio를 시작합니다.

3. **Open a project or solution**를 선택합니다.

4. Flutter 앱이 있는 디렉토리로 이동한 다음, **build** 폴더, **windows** 폴더로 이동한 다음, 
   `batterylevel.sln` 파일을 선택합니다. **Open**을 클릭합니다.

플랫폼 채널 메서드의 C++ 구현을 추가합니다.

1. 솔루션 탐색기에서 **batterylevel > Source Files**을 확장합니다.

2. `flutter_window.cpp` 파일을 엽니다.

먼저, 파일 맨 위, `#include "flutter_window.h"` 바로 뒤에, 필요한 include를 추가합니다.

```cpp title="flutter_window.cpp"
#include <flutter/event_channel.h>
#include <flutter/event_sink.h>
#include <flutter/event_stream_handler_functions.h>
#include <flutter/method_channel.h>
#include <flutter/standard_method_codec.h>
#include <windows.h>

#include <memory>
```

`FlutterWindow::OnCreate` 메서드를 편집하고, 
채널 이름 `samples.flutter.dev/battery`에 연결된 `flutter::MethodChannel`을 만듭니다.

```cpp title="flutter_window.cpp"
bool FlutterWindow::OnCreate() {
  // ...
  RegisterPlugins(flutter_controller_->engine());

  flutter::MethodChannel<> channel(
      flutter_controller_->engine()->messenger(), "samples.flutter.dev/battery",
      &flutter::StandardMethodCodec::GetInstance());
  channel.SetMethodCallHandler(
      [](const flutter::MethodCall<>& call,
         std::unique_ptr<flutter::MethodResult<>> result) {
        // TODO
      });

  SetChildContent(flutter_controller_->view()->GetNativeWindow());
  return true;
}
```

다음으로, Windows 배터리 API를 사용하여 배터리 수준을 검색하는 C++ 코드를 추가합니다. 
이 코드는 네이티브 Windows 애플리케이션에서 작성하는 코드와 정확히 같습니다.

`#include` 섹션 바로 뒤의 `flutter_window.cpp` 맨 위에 다음을 새 함수로 추가합니다.

```cpp title="flutter_window.cpp"
static int GetBatteryLevel() {
  SYSTEM_POWER_STATUS status;
  if (GetSystemPowerStatus(&status) == 0 || status.BatteryLifePercent == 255) {
    return -1;
  }
  return status.BatteryLifePercent;
}
```

마지막으로, 이전에 추가한 `setMethodCallHandler()` 메서드를 완성합니다. 
단일 플랫폼 메서드인 `getBatteryLevel()`를 처리해야 하므로, `call` 인수에서 테스트합니다. 
이 플랫폼 메서드의 구현은 이전 단계에서 작성된 Windows 코드를 호출합니다. 
알 수 없는 메서드가 호출되면, 대신 보고합니다.

다음 코드를 제거합니다.

```cpp title="flutter_window.cpp"
  channel.SetMethodCallHandler(
      [](const flutter::MethodCall<>& call,
         std::unique_ptr<flutter::MethodResult<>> result) {
        // TODO
      });
```

다음으로 대체합니다:

```cpp title="flutter_window.cpp"
  channel.SetMethodCallHandler(
      [](const flutter::MethodCall<>& call,
         std::unique_ptr<flutter::MethodResult<>> result) {
        if (call.method_name() == "getBatteryLevel") {
          int battery_level = GetBatteryLevel();
          if (battery_level != -1) {
            result->Success(battery_level);
          } else {
            result->Error("UNAVAILABLE", "Battery level not available.");
          }
        } else {
          result->NotImplemented();
        }
      });
```

이제 Windows에서 애플리케이션을 실행할 수 있습니다. 
기기에 배터리가 없으면, 'Battery level not available'이 표시됩니다.
  
### 스텝 6: macOS 플랫폼별 구현 추가 {:#step-6-add-a-macos-platform-specific-implementation}

Xcode에서 Flutter 앱의 macOS 호스트 부분을 열어 시작합니다.

1. Xcode를 시작합니다.

2. **File > Open...** 메뉴 아이템을 선택합니다.

3. Flutter 앱이 있는 디렉토리로 이동하여, 그 안에 있는 **macos** 폴더를 선택합니다. **OK**를 클릭합니다.

플랫폼 채널 메서드의 Swift 구현을 추가합니다.

1. 프로젝트 탐색기에서 **Expand Runner > Runner**를 선택합니다.

1. 프로젝트 탐색기에서 **Runner > Runner** 아래에 있는 `MainFlutterWindow.swift` 파일을 엽니다.

먼저 파일 맨 위, `import FlutterMacOS` 바로 뒤에, 필요한 가져오기를 추가합니다.

```swift title="MainFlutterWindow.swift"
import IOKit.ps
```

`awakeFromNib` 메서드에서 `samples.flutter.dev/battery` 채널 이름에 연결된 `FlutterMethodChannel`을 만듭니다.

```swift title="MainFlutterWindow.swift"
  override func awakeFromNib() {
    // ...
    self.setFrame(windowFrame, display: true)
  
    let batteryChannel = FlutterMethodChannel(
      name: "samples.flutter.dev/battery",
      binaryMessenger: flutterViewController.engine.binaryMessenger)
    batteryChannel.setMethodCallHandler { (call, result) in
      // 이 메서드는 UI 스레드에서 호출됩니다.
      // 배터리 메시지를 처리합니다.
    }

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
```

다음으로, 배터리 수준을 검색하기 위해 IOKit 배터리 API를 사용하는 macOS Swift 코드를 추가합니다. 
이 코드는 네이티브 macOS 앱에서 작성하는 코드와 정확히 동일합니다.

다음을 `MainFlutterWindow.swift` 하단에 새 메서드로 추가합니다.

```swift title="MainFlutterWindow.swift"
private func getBatteryLevel() -> Int? {
  let info = IOPSCopyPowerSourcesInfo().takeRetainedValue()
  let sources: Array<CFTypeRef> = IOPSCopyPowerSourcesList(info).takeRetainedValue() as Array
  if let source = sources.first {
    let description =
      IOPSGetPowerSourceDescription(info, source).takeUnretainedValue() as! [String: AnyObject]
    if let level = description[kIOPSCurrentCapacityKey] as? Int {
      return level
    }
  }
  return nil
}
```

마지막으로, 이전에 추가한 `setMethodCallHandler` 메서드를 완성합니다. 
단일 플랫폼 메서드인 `getBatteryLevel()`를 처리해야 하므로, `call` 인수에서 테스트합니다. 
이 플랫폼 메서드의 구현은 이전 단계에서 작성된 macOS 코드를 호출합니다. 
알 수 없는 메서드가 호출되면, 대신 보고합니다.

```swift title="MainFlutterWindow.swift"
batteryChannel.setMethodCallHandler { (call, result) in
  switch call.method {
  case "getBatteryLevel":
    guard let level = getBatteryLevel() else {
      result(
        FlutterError(
          code: "UNAVAILABLE",
          message: "Battery level not available",
          details: nil))
     return
    }
    result(level)
  default:
    result(FlutterMethodNotImplemented)
  }
}
```

이제 macOS에서 애플리케이션을 실행할 수 있습니다. 
기기에 배터리가 없으면, 'Battery level not available'이 표시됩니다.

### 스텝 7: Linux 플랫폼별 구현 추가 {:#step-7-add-a-linux-platform-specific-implementation}
  
이 예제에서는 `upower` 개발자 헤더를 설치해야 합니다. 
이것은 배포판에서 사용할 수 있을 가능성이 높습니다. 예를 들어, 다음과 같습니다.

```console
sudo apt install libupower-glib-dev
```

선택한 편집기에서 Flutter 앱의 Linux 호스트 부분을 열어 시작합니다. 
아래 지침은 "C/C++" 및 "CMake" 확장 프로그램이 설치된 Visual Studio Code에 대한 것이지만, 
다른 IDE에 맞게 조정할 수 있습니다.

1. Visual Studio Code를 시작합니다.

2. 프로젝트 내에서 **linux** 디렉터리를 엽니다.

3. `Would you like to configure project "linux"?`라는 프롬프트에서 **Yes**를 선택합니다. 
   이렇게 하면 C++ 자동 완성이 활성화됩니다.

4. `my_application.cc` 파일을 엽니다.

먼저, 파일 맨 위, `#include <flutter_linux/flutter_linux.h` 바로 뒤에, 필요한 include를 추가합니다.

```c title="my_application.cc"
#include <math.h>
#include <upower.h>
```

`_MyApplication` 구조체에 `FlMethodChannel`을 추가합니다.

```c title="my_application.cc"
struct _MyApplication {
  GtkApplication parent_instance;
  char** dart_entrypoint_arguments;
  FlMethodChannel* battery_channel;
};
```

`my_application_dispose`에서 정리해야 합니다.

```c title="my_application.cc"
static void my_application_dispose(GObject* object) {
  MyApplication* self = MY_APPLICATION(object);
  g_clear_pointer(&self->dart_entrypoint_arguments, g_strfreev);
  g_clear_object(&self->battery_channel);
  G_OBJECT_CLASS(my_application_parent_class)->dispose(object);
}
```

`my_application_activate` 메서드를 편집하고, 
`fl_register_plugins` 호출 바로 뒤에 채널 이름 `samples.flutter.dev/battery`를 사용하여, 
`battery_channel`을 초기화합니다.

```c title="my_application.cc"
static void my_application_activate(GApplication* application) {
  // ...
  fl_register_plugins(FL_PLUGIN_REGISTRY(self->view));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  self->battery_channel = fl_method_channel_new(
      fl_engine_get_binary_messenger(fl_view_get_engine(view)),
      "samples.flutter.dev/battery", FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(
      self->battery_channel, battery_method_call_handler, self, nullptr);

  gtk_widget_grab_focus(GTK_WIDGET(self->view));
}
```

다음으로, 배터리 수준을 검색하기 위해 Linux 배터리 API를 사용하는 C 코드를 추가합니다. 
이 코드는 네이티브 Linux 애플리케이션에서 작성하는 코드와 정확히 같습니다.

다음을 `my_application.cc` 맨 위의 `G_DEFINE_TYPE` 줄 바로 뒤에 새 함수로 추가합니다.

```c title="my_application.cc"
static FlMethodResponse* get_battery_level() {
  // 사용 가능한 첫 번째 배터리를 찾아서 보고하세요.
  g_autoptr(UpClient) up_client = up_client_new();
  g_autoptr(GPtrArray) devices = up_client_get_devices2(up_client);
  if (devices->len == 0) {
    return FL_METHOD_RESPONSE(fl_method_error_response_new(
        "UNAVAILABLE", "Device does not have a battery.", nullptr));
  }

  UpDevice* device = (UpDevice*)(g_ptr_array_index(devices, 0));
  double percentage = 0;
  g_object_get(device, "percentage", &percentage, nullptr);

  g_autoptr(FlValue) result =
      fl_value_new_int(static_cast<int64_t>(round(percentage)));
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}
```

마지막으로, 이전 호출에서 참조된 `battery_method_call_handler` 함수를 `fl_method_channel_set_method_call_handler`에 추가합니다. 
단일 플랫폼 메서드인 `getBatteryLevel`을 처리해야 하므로, `method_call` 인수에서 테스트합니다. 
이 함수의 구현은 이전 단계에서 작성된 Linux 코드를 호출합니다. 
알 수 없는 메서드가 호출되면, 대신 보고합니다.

`get_battery_level` 함수 뒤에 다음 코드를 추가합니다.

```cpp title="flutter_window.cpp"
static void battery_method_call_handler(FlMethodChannel* channel,
                                        FlMethodCall* method_call,
                                        gpointer user_data) {
  g_autoptr(FlMethodResponse) response = nullptr;
  if (strcmp(fl_method_call_get_name(method_call), "getBatteryLevel") == 0) {
    response = get_battery_level();
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  g_autoptr(GError) error = nullptr;
  if (!fl_method_call_respond(method_call, response, &error)) {
    g_warning("Failed to send response: %s", error->message);
  }
}
```

이제 Linux에서 애플리케이션을 실행할 수 있습니다. 
기기에 배터리가 없으면 'Battery level not available'이 표시됩니다.

## Pigeon을 사용한 Typesafe 플랫폼 채널 {:#pigeon}

이전 예제는 호스트와 클라이언트 간 통신에 `MethodChannel`을 사용하는데, 이는 Typesafe가 아닙니다. 
메시지를 호출하고 수신하는 것은 호스트와 클라이언트가 메시지가 작동하도록 동일한 인수와 데이터 타입을 선언하는 데 달려 있습니다. 
`MethodChannel` 대신 [Pigeon][pigeon] 패키지를 사용하여, 
구조화되고 typesafe 방식으로 메시지를 보내는 코드를 생성할 수 있습니다.

[Pigeon][pigeon]을 사용하면, 메시징 프로토콜이 Dart의 하위 집합에 정의되어, 
Android, iOS, macOS 또는 Windows용 메시징 코드를 생성합니다. 
pub.dev의 [`pigeon`][pigeon] 페이지에서 보다 완전한 예제와 자세한 정보를 찾을 수 있습니다.

[Pigeon][pigeon]을 사용하면, 메시지의 이름과 데이터 타입에 대해 호스트와 클라이언트 간의 문자열을 일치시킬 필요가 없습니다. 
이는 중첩 클래스, API로 메시지 그룹화, 비동기 래퍼 코드 생성 및 양방향으로 메시지 전송을 지원합니다. 
생성된 코드는 읽을 수 있으며, 서로 다른 버전의 여러 클라이언트 간에 충돌이 없음을 보장합니다. 
지원되는 언어는 Objective-C, Java, Kotlin, C++, Swift(Objective-C 상호 운용성 포함)입니다.

### Pigeon 예제 {:#pigeon-example}

**Pigeon file:**

<?code-excerpt "pigeon/lib/pigeon_source.dart (search)"?>
```dart
import 'package:pigeon/pigeon.dart';

class SearchRequest {
  final String query;

  SearchRequest({required this.query});
}

class SearchReply {
  final String result;

  SearchReply({required this.result});
}

@HostApi()
abstract class Api {
  @async
  SearchReply search(SearchRequest request);
}
```

**Dart usage:**

<?code-excerpt "pigeon/lib/use_pigeon.dart (use-api)"?>
```dart
import 'generated_pigeon.dart';

Future<void> onClick() async {
  SearchRequest request = SearchRequest(query: 'test');
  Api api = SomeApi();
  SearchReply reply = await api.search(request);
  print('reply: ${reply.result}');
}
```

## 플랫폼별 코드를 UI 코드에서 분리하기 {:#separate}

여러 Flutter 앱에서 플랫폼별 코드를 사용할 예정이라면, 
코드를 메인 애플리케이션 외부 디렉토리에 있는 플랫폼 플러그인으로 분리하는 것을 고려할 수 있습니다. 
자세한 내용은 [패키지 개발][developing packages]을 참조하세요.

## 플랫폼별 코드를 패키지로 게시 {:#publish}

Flutter 생태계의 다른 개발자와 플랫폼별 코드를 공유하려면, [패키지 게시][publishing packages]를 참조하세요.

## 커스텀 채널 및 코덱 {:#custom-channels-and-codecs}

위에 언급된 `MethodChannel` 외에도, 커스텀 메시지 코덱을 사용하여 기본 비동기 메시지 전달을 지원하는, 
보다 기본적인 [`BasicMessageChannel`][]을 사용할 수도 있습니다. 
또한 특수화된 [`BinaryCodec`][], [`StringCodec`][], 및 [`JSONMessageCodec`][] 클래스를 사용하거나, 
고유한 코덱을 만들 수도 있습니다.

또한 기본 타입보다 훨씬 더 많은 타입을 직렬화하고 역직렬화할 수 있는, 
[`cloud_firestore`][] 플러그인에서 커스텀 코덱의 예를 확인할 수도 있습니다.

## 채널 및 플랫폼 스레딩 {:#channels-and-platform-threading}

Flutter를 대상으로 하는 플랫폼 측 채널을 호출할 때는, 플랫폼의 메인 스레드에서 호출합니다. 
Flutter에서 플랫폼 측 채널을 호출할 때는, 루트 `Isolate` _또는_ 백그라운드 `Isolate`로 등록된, 어떤 `Isolate`에서든 호출합니다. 
플랫폼 측 핸들러는 플랫폼의 메인 스레드에서 실행하거나, Task Queue를 사용하는 경우, 백그라운드 스레드에서 실행할 수 있습니다. 
플랫폼 측 핸들러는 비동기적으로 어떤 스레드에서든 호출할 수 있습니다.

:::note
Android에서, 플랫폼의 메인 스레드는 때때로 "메인 스레드"라고 불리지만, 
기술적으로는 [UI 스레드][the UI thread]로 정의됩니다. 
UI 스레드에서 실행해야 하는 메서드에 `@UiThread`로 어노테이션 합니다. 
iOS에서, 이 스레드는 공식적으로 [메인 스레드][the main thread]라고 합니다.
:::

### 백그라운드 isolates 에서 플러그인 및 채널 사용 {:#using-plugins-and-channels-from-background-isolates}

플러그인과 채널은 어떤 `Isolate`에서든 사용할 수 있지만, 
해당 `Isolate`는 루트 `Isolate`(Flutter에서 만든 것)이거나, 
루트 `Isolate`에 대한 백그라운드 `Isolate`로 등록되어야 합니다.

다음 예는 백그라운드 `Isolate`에서 플러그인을 사용하기 위해, 백그라운드 `Isolate`를 등록하는 방법을 보여줍니다.

```dart
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void _isolateMain(RootIsolateToken rootIsolateToken) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  print(sharedPreferences.getBool('isDebug'));
}

void main() {
  RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
  Isolate.spawn(_isolateMain, rootIsolateToken);
}
```

### 백그라운드 스레드에서 채널 핸들러 실행 {:#executing-channel-handlers-on-background-threads}

채널의 플랫폼 측 핸들러가 백그라운드 스레드에서 실행되도록 하려면, Task Queue API를 사용해야 합니다. 
현재, 이 기능은 iOS 및 Android에서만 지원됩니다.

Kotlin에서:

```kotlin
override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
  val taskQueue =
      flutterPluginBinding.binaryMessenger.makeBackgroundTaskQueue()
  channel = MethodChannel(flutterPluginBinding.binaryMessenger,
                          "com.example.foo",
                          StandardMethodCodec.INSTANCE,
                          taskQueue)
  channel.setMethodCallHandler(this)
}
```

자바에서:

```java
@Override
public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
  BinaryMessenger messenger = binding.getBinaryMessenger();
  BinaryMessenger.TaskQueue taskQueue =
      messenger.makeBackgroundTaskQueue();
  channel =
      new MethodChannel(
          messenger,
          "com.example.foo",
          StandardMethodCodec.INSTANCE,
          taskQueue);
  channel.setMethodCallHandler(this);
}
```

Swift에서:

:::note
릴리스 2.10에서는, Task Queue API는 iOS에 대해 `master` 채널에서만 사용할 수 있습니다.
:::

```swift
public static func register(with registrar: FlutterPluginRegistrar) {
  let taskQueue = registrar.messenger.makeBackgroundTaskQueue()
  let channel = FlutterMethodChannel(name: "com.example.foo",
                                     binaryMessenger: registrar.messenger(),
                                     codec: FlutterStandardMethodCodec.sharedInstance,
                                     taskQueue: taskQueue)
  let instance = MyPlugin()
  registrar.addMethodCallDelegate(instance, channel: channel)
}
```

Objective-C에서:

:::note
릴리스 2.10에서는, Task Queue API는 iOS에 대해 `master` 채널에서만 사용할 수 있습니다.
:::

```objc
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  NSObject<FlutterTaskQueue>* taskQueue =
      [[registrar messenger] makeBackgroundTaskQueue];
  FlutterMethodChannel* channel =
      [FlutterMethodChannel methodChannelWithName:@"com.example.foo"
                                  binaryMessenger:[registrar messenger]
                                            codec:[FlutterStandardMethodCodec sharedInstance]
                                        taskQueue:taskQueue];
  MyPlugin* instance = [[MyPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}
```

### Android에서 UI 스레드로 점프하기 {:#jumping-to-the-ui-thread-in-android}

채널의 UI 스레드 요구 사항을 준수하려면, 백그라운드 스레드에서 Android의 UI 스레드로 점프하여, 
채널 메서드를 실행해야 할 수 있습니다. 
Android에서는, `Runnable`을 Android의 UI 스레드 `Looper`에 `post()`하여 이를 수행할 수 있습니다. 
그러면 다음 기회에 `Runnable`이 메인 스레드에서 실행됩니다.

Kotlin에서:

```kotlin
Handler(Looper.getMainLooper()).post {
  // 원하는 채널의 메시지를 여기서 호출하세요.
}
```

Java에서:

```java
new Handler(Looper.getMainLooper()).post(new Runnable() {
  @Override
  public void run() {
    // 원하는 채널의 메시지를 여기서 호출하세요.
  }
});
```

### iOS에서 메인 스레드로 점프하기 {:#jumping-to-the-main-thread-in-ios}

채널의 메인 스레드 요구 사항을 준수하려면, 백그라운드 스레드에서 iOS의 메인 스레드로 점프하여, 
채널 메서드를 실행해야 할 수 있습니다. 
iOS에서 이를 수행하려면, 메인 [dispatch queue][]에서 [block][]을 실행하면 됩니다.

Objective-C에서:

```objc
dispatch_async(dispatch_get_main_queue(), ^{
  // 원하는 채널의 메시지를 여기서 호출하세요.
});
```

Swift에서:

```swift
DispatchQueue.main.async {
  // 원하는 채널의 메시지를 여기서 호출하세요.
}
```

[`BasicMessageChannel`]: {{site.api}}/flutter/services/BasicMessageChannel-class.html
[`BinaryCodec`]: {{site.api}}/flutter/services/BinaryCodec-class.html
[block]: {{site.apple-dev}}/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/WorkingwithBlocks/WorkingwithBlocks.html
[`cloud_firestore`]: {{site.github}}/firebase/flutterfire/blob/master/packages/cloud_firestore/cloud_firestore_platform_interface/lib/src/method_channel/utils/firestore_message_codec.dart
[`dart:html` library]: {{site.dart.api}}/dart-html/dart-html-library.html
[developing packages]: /packages-and-plugins/developing-packages
[plugins]: /packages-and-plugins/developing-packages#plugin
[dispatch queue]: {{site.apple-dev}}/documentation/dispatch/dispatchqueue
[`/examples/platform_channel/`]: {{site.repo.flutter}}/tree/main/examples/platform_channel
[`/examples/platform_channel_swift/`]: {{site.repo.flutter}}/tree/main/examples/platform_channel_swift
[JS interoperability]: {{site.dart-site}}/web/js-interop
[`JSONMessageCodec`]: {{site.api}}/flutter/services/JSONMessageCodec-class.html
[`MethodChannel`]: {{site.api}}/flutter/services/MethodChannel-class.html
[`MethodChannelAndroid`]: {{site.api}}/javadoc/io/flutter/plugin/common/MethodChannel.html
[`MethodChanneliOS`]: {{site.api}}/ios-embedder/interface_flutter_method_channel.html
[Platform adaptations]: /platform-integration/platform-adaptations
[publishing packages]: /packages-and-plugins/developing-packages#publish
[`quick_actions`]: {{site.pub}}/packages/quick_actions
[section on threading]: #channels-and-platform-threading
[`StandardMessageCodec`]: {{site.api}}/flutter/services/StandardMessageCodec-class.html
[`StringCodec`]: {{site.api}}/flutter/services/StringCodec-class.html
[the main thread]: {{site.apple-dev}}/documentation/uikit?language=objc
[the UI thread]: {{site.android-dev}}/guide/components/processes-and-threads#Threads
[sending structured typesafe messages]: #pigeon
