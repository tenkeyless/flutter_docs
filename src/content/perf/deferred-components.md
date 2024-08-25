---
# title: Deferred components
title: 지연된(Deferred) 컴포넌트
# description: How to create deferred components for improved download performance.
description: 다운로드 성능을 개선하기 위해 지연된 컴포넌트를 만드는 방법.
---

<?code-excerpt path-base="perf/deferred_components"?>

## 소개 {:#introduction}

Flutter는 런타임에 추가 Dart 코드와 assets을 다운로드할 수 있는 앱을 빌드할 수 있는 기능을 가지고 있습니다. 
이를 통해, 앱은 설치 apk 크기를 줄이고, 사용자가 필요로 할 때 기능과 assets을 다운로드할 수 있습니다.

우리는 고유하게 다운로드할 수 있는 각 Dart 라이브러리와 assets 번들을 "지연된(Deferred) 컴포넌트"라고 합니다. 
이러한 구성 요소를 로드하려면, [Dart의 지연된 imports][dart-def-import]를 사용합니다. 
이들은 분할된 AOT 및 JavaScript 공유 라이브러리로 컴파일될 수 있습니다.

:::note
Flutter는 Android와 웹에서 지연된(deferred) 또는 "지연된(lazy)" 로딩을 지원합니다. 구현은 다릅니다. 
Android의 [동적 기능 모듈][dynamic feature modules]은 Android 모듈로 패키징된 지연된 구성 요소를 제공합니다. 
웹은 이러한 구성 요소를 별도의 `*.js` 파일로 만듭니다. 
지연된 코드는 다른 플랫폼에 영향을 미치지 않으며, 모든 지연된 구성 요소와 assets이 초기 설치 시간에 포함되어, 정상적으로 계속 빌드됩니다.
:::

모듈 로딩을 연기(defer)할 수는 있지만, 전체 앱을 빌드하고 해당 앱을 단일 [Android 앱 번들][android-app-bundle] (`*.aab`)로 업로드해야 합니다. Flutter는, 전체 애플리케이션에 대한 새로운 Android 앱 번들을 다시 업로드하지 않고는, 부분 업데이트를 디스패치하는 것을 지원하지 않습니다.

Flutter는 [릴리스 또는 프로필 모드][release or profile mode]에서 앱을 컴파일할 때 지연 로딩을 수행합니다. 
디버그 모드는 모든 지연된 구성 요소를 일반 imports로 처리합니다. 
구성 요소는 시작 시 존재하고 즉시 로드됩니다. 이를 통해 디버그 빌드가 핫 리로드될 수 있습니다.

이 기능의 작동 방식에 대한 기술적 세부 정보를 자세히 알아보려면, [Flutter wiki][]의 [지연된 구성 요소][Deferred Components]를 참조하세요.

## 지연된(Deferred) 컴포넌트에 대한 프로젝트를 설정하는 방법 {:#how-to-set-your-project-up-for-deferred-components}

다음 지침에서는 Android 앱을 지연된(Deferred) 로딩으로 설정하는 방법을 설명합니다.

### 1단계: 종속성 및 초기 프로젝트 설정 {:#step-1-dependencies-and-initial-project-setup}

<ol>
<li>

Play Core를 Android 앱의 build.gradle 종속성에 추가합니다. 
`android/app/build.gradle`에 다음을 추가합니다.

```groovy
...
dependencies {
  ...
  implementation "com.google.android.play:core:1.8.0"
  ...
}
```
</li>

<li>

동적 기능에 대한 배포 모델로 Google Play Store를 사용하는 경우, 
앱은 `SplitCompat`를 지원하고 `PlayStoreDeferredComponentManager`의 인스턴스를 제공해야 합니다. 
이 두 가지 작업은 모두 `android/app/src/main/AndroidManifest.xml`에서, 
애플리케이션의 `android:name` 속성을 `io.flutter.embedding.android.FlutterPlayStoreSplitApplication`으로 설정하여 수행할 수 있습니다.

```xml
<manifest ...
  <application
     android:name="io.flutter.embedding.android.FlutterPlayStoreSplitApplication"
        ...
  </application>
</manifest>
```

`io.flutter.app.FlutterPlayStoreSplitApplication`은 이 두 가지 작업을 모두 처리합니다. 
`FlutterPlayStoreSplitApplication`을 사용하는 경우, 단계 1.3으로 건너뛸 수 있습니다.

Android 애플리케이션이 크거나 복잡한 경우, 
`SplitCompat`를 별도로 지원하고 `PlayStoreDynamicFeatureManager`를 수동으로 제공할 수 있습니다.

`SplitCompat`를 지원하려면, 세 가지 방법이 있습니다. ([Android 문서][Android docs]에 자세히 설명되어 있음)
다음 중 어느 것이든 유효합니다.

<ul>
<li>

애플리케이션 클래스를 `SplitCompatApplication` 확장하도록 하세요.

```java
public class MyApplication extends SplitCompatApplication {
    ...
}
```

</li>

<li>

`attachBaseContext()` 메서드에서 `SplitCompat.install(this);`를 호출합니다.

```java
@Override
protected void attachBaseContext(Context base) {
    super.attachBaseContext(base);
    // SplitCompat를 사용하여 향후 주문형 모듈 설치를 에뮬레이트합니다.
    SplitCompat.install(this);
}
```

</li>

<li>

`SplitCompatApplication`을 애플리케이션 하위 클래스로 선언하고, 
`FlutterApplication`의 Flutter 호환 코드를 애플리케이션 클래스에 추가합니다.

```xml
<application
    ...
    android:name="com.google.android.play.core.splitcompat.SplitCompatApplication">
</application>
```

</li>
</ul>

임베더는 주입된 `DeferredComponentManager` 인스턴스를 사용하여, 
지연된 구성 요소에 대한 설치 요청을 처리합니다. 
앱 초기화에 다음 코드를 추가하여 Flutter 임베더에 `PlayStoreDeferredComponentManager`를 제공합니다.

```java
import io.flutter.embedding.engine.dynamicfeatures.PlayStoreDeferredComponentManager;
import io.flutter.FlutterInjector;
... 
PlayStoreDeferredComponentManager deferredComponentManager = new
  PlayStoreDeferredComponentManager(this, null);
FlutterInjector.setInstance(new FlutterInjector.Builder()
    .setDeferredComponentManager(deferredComponentManager).build());
```

</li>
    
<li>

앱의 `pubspec.yaml`의 `flutter` 항목 아래에, `deferred-components` 항목을 추가하여 지연된 구성 요소를 선택합니다.

```yaml
...
flutter:
  ...
  deferred-components:
  ...
```

`flutter` 도구는 `pubspec.yaml`에서 `deferred-components` 항목을 찾아, 
앱을 지연으로 빌드해야 할지 여부를 결정합니다. 
원하는 구성 요소와 각각에 들어가는 Dart 지연 라이브러리를 이미 알고 있지 않는 한 지금은 비워둘 수 있습니다. 
`gen_snapshot`이 로딩 단위를 생성하면, 나중에 [3.3단계][step 3.3]에서 이 섹션을 채울 것입니다.

</li>
</ol>

### 2단계: 지연된(Deferred) Dart 라이브러리 구현 {:#step-2-implementing-deferred-dart-libraries}

다음으로, 앱의 Dart 코드에서 지연된 로드된 Dart 라이브러리를 구현합니다. 
구현은 아직 기능이 완료될 필요는 없습니다. 
이 페이지의 나머지 부분에 있는 예제는 플레이스홀더로 새로운 간단한 지연 위젯을 추가합니다. 
`loadLibrary()` `Futures` 뒤에 있는 지연된 코드의 imports 및 guarding 사용을 수정하여, 
기존 코드를 지연되도록 변환할 수도 있습니다.

<ol>
<li>

새로운 Dart 라이브러리를 만듭니다. 
예를 들어, 런타임에 다운로드할 수 있는 새로운 `DeferredBox` 위젯을 만듭니다. 
이 위젯은 복잡할 수 있지만, 이 가이드의 목적을 위해, 간단한 상자를 대체품으로 만듭니다. 
간단한 파란색 상자 위젯을 만들려면, 다음 내용으로 `box.dart`를 만듭니다.

<?code-excerpt "lib/box.dart"?>
```dart title="box.dart"
import 'package:flutter/material.dart';

/// 단순한 파란색 30x30 상자입니다.
class DeferredBox extends StatelessWidget {
  const DeferredBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      color: Colors.blue,
    );
  }
}
```

</li>

<li>

앱에서 `deferred` 키워드로 새 Dart 라이브러리를 import하고, `loadLibrary()`를 호출합니다.
([라이브러리 지연 로딩][lazily loading a library] 참조) 
다음 예제에서는 `FutureBuilder`를 사용하여, `loadLibrary` `Future`(`initState`에서 생성됨)가 완료될 때까지 기다리고, `CircularProgressIndicator`를 플레이스홀더로 표시합니다. 
`Future`가 완료되면, `DeferredBox` 위젯을 반환합니다. 
그런 다음, `SomeWidget`을 앱에서 평소처럼 사용할 수 있으며, 
성공적으로 로드될 때까지, 지연된 Dart 코드에 액세스하려고 시도하지 않습니다.

<?code-excerpt "lib/use_deferred_box.dart"?>
```dart
import 'package:flutter/material.dart';
import 'box.dart' deferred as box;

class SomeWidget extends StatefulWidget {
  const SomeWidget({super.key});

  @override
  State<SomeWidget> createState() => _SomeWidgetState();
}

class _SomeWidgetState extends State<SomeWidget> {
  late Future<void> _libraryFuture;

  @override
  void initState() {
    super.initState();
    _libraryFuture = box.loadLibrary();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _libraryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return box.DeferredBox();
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
```

`loadLibrary()` 함수는 라이브러리의 코드를 사용할 수 있을 때 성공적으로 완료되고, 그렇지 않을 경우 오류로 완료되는 `Future<void>`를 반환합니다. 
지연된 라이브러리의 모든 심볼 사용은 완료된 `loadLibrary()` 호출 뒤에 보호되어야 합니다. 
라이브러리의 모든 imports는 지연된 구성 요소에서 사용하기에 적합하게 컴파일되도록 `deferred`로 표시되어야 합니다. 
구성 요소가 이미 로드된 경우, `loadLibrary()`에 대한 추가 호출은 빠르게 완료됩니다. (동기적으로는 완료되지 않습니다.)
`loadLibrary()` 함수는 로딩 시간을 가리는 데 도움이 되는 사전 로드를 트리거하기 위해 일찍 호출될 수도 있습니다.

지연된 import 로딩의 또 다른 예는 [Flutter Gallery의 `lib/deferred_widget.dart`][Flutter Gallery's `lib/deferred_widget.dart`]에서 찾을 수 있습니다.

</li>
</ol>

### 3단계: 앱 빌드 {:#step-3-building-the-app}

다음 `flutter` 명령을 사용하여 지연된 구성 요소 앱을 빌드하세요.

```console
$ flutter build appbundle
```

이 명령은 프로젝트가 지연된 구성 요소 앱을 빌드하도록 올바르게 설정되었는지 확인하여 지원합니다. 
기본적으로, 검증자(validator)가 문제를 감지하고, 이를 수정하기 위한 제안된 변경 사항을 안내하면, 빌드가 실패합니다.

:::note
`--no-deferred-components` 플래그를 사용하여 지연된 구성 요소를 빌드하지 않도록 선택할 수 있습니다. 
이 플래그는 지연된 구성 요소에서 정의된 모든 assets이 `pubspec.yaml`의 assets 섹션에서 정의된 것처럼 처리되도록 합니다. 
모든 Dart 코드는 단일 공유 라이브러리로 컴파일되고, `loadLibrary()` 호출은 다음 이벤트 루프 경계에서 완료됩니다.
(비동기적이면서도 가능한 한 빨리)
이 플래그는 `pubspec.yaml`에서 `deferred-components:` 항목을 생략하는 것과 동일합니다.
:::

<ol>
<li><a id="step-3.1"></a>

`flutter build appbundle` 명령은 검증기(validator)를 실행하고, 
`gen_snapshot`에 별도의 `.so` 파일로 분할된 AOT 공유 라이브러리를 생성하도록 지시하여 앱을 빌드하려고 시도합니다. 
첫 번째 실행에서, 검증기는 문제를 감지하여 실패할 가능성이 높습니다. 
도구는 프로젝트를 설정하고 이러한 문제를 해결하는 방법에 대한 권장 사항을 제공합니다.

검증기는 pre-build 및 post-gen_snapshot 검증의 두 섹션으로 나뉩니다. 
이는 `gen_snapshot`이 완료되고, 최종 로딩 단위 세트를 생성할 때까지, 
로딩 단위를 참조하는 모든 검증을 수행할 수 없기 때문입니다.

:::note
`--no-validate-deferred-components` 플래그를 전달하여 도구가 검증기 없이 앱을 빌드하도록 선택할 수 있습니다. 
이로 인해 실패를 해결하기 위한 예상치 못한 혼란스러운 지침이 발생할 수 있습니다. 
이 플래그는 검증기가 확인하는 기본 Play-store 기반 구현에 의존하지 않는 커스텀 구현에서 사용하도록 의도되었습니다.
:::

검증기는 `gen_snapshot`에서 생성된 새 로딩 단위, 변경된 로딩 단위 또는 제거된 로딩 단위를 감지합니다. 
현재 생성된 로딩 단위는 `<projectDirectory>/deferred_components_loading_units.yaml` 파일에서 추적됩니다. 
이 파일은 다른 개발자가 로딩 단위를 변경한 것을 포착할 수 있도록 소스 제어에 체크인해야 합니다.

검증기는 또한 `android` 디렉토리에서 다음을 확인합니다.

<ul>
<li>

**`<projectDir>/android/app/src/main/res/values/strings.xml`**<br> 
키 `${componentName}Name`을 `${componentName}`로 매핑하는 모든 지연된 구성 요소에 대한 항목입니다. 
이 문자열 리소스는 각 기능 모듈의 `AndroidManifest.xml`에서 `dist:title property`을 정의하는 데 사용됩니다. 
예를 들어:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
  ...
  <string name="boxComponentName">boxComponent</string>
</resources>
```

</li>

<li>

**`<projectDir>/android/<componentName>`**<br>
지연된 각 구성 요소에 대한 Android 동적 기능 모듈이 존재하며, `build.gradle` 및 `src/main/AndroidManifest.xml` 파일이 포함되어 있습니다. 
이는 존재 여부만 확인하고, 이러한 파일의 내용을 검증하지 않습니다. 
파일이 없으면, 기본 권장 파일을 생성합니다.

</li>

<li>

**`<projectDir>/android/app/src/main/res/values/AndroidManifest.xml`**<br>
로딩 단위와 로딩 단위가 연결된 구성 요소 이름 간의 매핑을 인코딩하는 메타데이터 항목을 포함합니다. 
이 매핑은 임베더가 Dart의 내부 로딩 단위 ID를 설치할 지연된 구성 요소의 이름으로 변환하는 데 사용됩니다. 
예를 들어:

```xml
...
<application
    android:label="MyApp"
    android:name="io.flutter.app.FlutterPlayStoreSplitApplication"
    android:icon="@mipmap/ic_launcher">
    ...
    <meta-data android:name="io.flutter.embedding.engine.deferredcomponents.DeferredComponentManager.loadingUnitMapping" android:value="2:boxComponent"/>
</application>
...
```

</li>
</ul>

`gen_snapshot` 검증 도구는 사전 빌드 검증 도구가 통과될 때까지 실행되지 않습니다.
</li>

<li>

또는 이러한 각 검사에서, 도구는 검사를 통과하는 데 필요한 수정된 파일이나 새 파일을 생성합니다. 
이러한 파일은 `<projectDir>/build/android_deferred_components_setup_files` 디렉토리에 배치됩니다. 
프로젝트의 `android` 디렉토리에 있는 동일한 파일을 복사하여 덮어쓰는 방식으로 변경 사항을 적용하는 것이 좋습니다. 
덮어쓰기 전에, 현재 프로젝트 상태를 소스 제어에 커밋하고 권장되는 변경 사항을 검토하여 적절한지 확인해야 합니다. 
도구는 `android/` 디렉토리를 자동으로 변경하지 않습니다.

</li>

<li><a id="step-3.3"></a>

사용 가능한 로딩 단위가 생성되어 `<projectDirectory>/deferred_components_loading_units.yaml`에 로그인되면, 
pubspec의 `deferred-components` 섹션을 완전히 구성하여, 
로딩 단위가 원하는 대로 지연된 구성 요소에 할당되도록 할 수 있습니다. 
상자 예제를 계속하려면, 생성된 `deferred_components_loading_units.yaml` 파일에 다음이 포함됩니다.

```yaml
loading-units:
  - id: 2
    libraries:
      - package:MyAppName/box.Dart
```

로딩 단위 ID(이 경우 '2')는 Dart에서 내부적으로 사용되며, 무시할 수 있습니다. 
기본 로딩 단위(ID '1')는 나열되지 않으며, 다른 로딩 단위에 명시적으로 포함되지 않은 모든 것을 포함합니다.

이제 다음을 `pubspec.yaml`에 추가할 수 있습니다.

```yaml
...
flutter:
  ...
  deferred-components:
    - name: boxComponent
      libraries:
        - package:MyAppName/box.Dart
  ...
```

지연된 구성 요소에 로딩 단위를 할당하려면, 로딩 단위의 모든 Dart 라이브러리를 기능 모듈의 라이브러리 섹션에 추가합니다. 
다음 지침을 명심하세요.

<ul>
<li>

로딩 단위는 두 개 이상의 구성요소에 포함되어서는 안 됩니다.

</li>
<li>

로딩 단위에서 하나의 Dart 라이브러리를 포함하면, 전체 로딩 단위가 지연된 구성 요소에 할당됨을 나타냅니다.

</li>
<li>

지연된 구성 요소에 할당되지 않은 모든 로딩 단위는 (항상 암묵적으로 존재하는) 베이스 구성 요소에 포함됩니다.

</li>
<li>

동일한 지연된 구성 요소에 할당된 로딩 단위는 함께 다운로드, 설치 및 배송됩니다.

</li>
<li>

기본 구성 요소는 암묵적이므로 pubspec에 정의할 필요가 없습니다.

</li>
</ul>
</li>

<li>

지연된 구성 요소 구성에 assets 섹션을 추가하여, assets을 포함할 수도 있습니다.

```yaml
  deferred-components:
    - name: boxComponent
      libraries:
        - package:MyAppName/box.Dart
      assets:
        - assets/image.jpg
        - assets/picture.png
          # wildcard directory
        - assets/gallery/
```

asset은 여러 지연된 구성 요소에 포함될 수 있지만, 두 구성 요소를 모두 설치하면 복제된 asset이 생성됩니다. 
자산 전용 구성 요소(Assets-only components)는 라이브러리 섹션을 생략하여 정의할 수도 있습니다. 
이러한 자산 전용 구성 요소는 `loadLibrary()`가 아닌 서비스의 [`DeferredComponent`][] 유틸리티 클래스로 설치해야 합니다. 
Dart 라이브러리는 assets과 함께 패키징되므로, Dart 라이브러리가 `loadLibrary()`로 로드되면, 
구성 요소의 모든 자산도 로드됩니다. 
그러나, 구성 요소 이름과 서비스 유틸리티로 설치하면 구성 요소에 Dart 라이브러리가 로드되지 않습니다.

assets이 처음 참조될 때 설치되고 로드되는 한, 모든 구성 요소에 assets을 포함할 수 있지만, 
일반적으로 assets과 해당 assets을 사용하는 Dart 코드는 동일한 구성 요소에 패키징하는 것이 가장 좋습니다.

</li>

<li>

`pubspec.yaml`에서 정의한 모든 지연된 구성 요소를 `android/settings.gradle` 파일에 include로 수동으로 추가합니다. 
예를 들어, pubspec에 `boxComponent`, `circleComponent`, `assetComponent`라는 이름의 지연된 구성 요소가 세 개 정의된 경우, 
`android/settings.gradle`에 다음이 포함되어 있는지 확인합니다.

```groovy
include ':app', ':boxComponent', ':circleComponent', ':assetComponent'
...
```

</li>

<li>

모든 검증자 권장 사항이 처리되고 도구가 추가 권장 사항 없이 실행될 때까지, [3.1][]~3.6(이 단계) 단계를 반복합니다.

성공하면, 이 명령은 `build/app/outputs/bundle/release`에 `app-release.aab` 파일을 출력합니다.

빌드가 성공했다고 해서 항상 앱이 의도한 대로 빌드되었다는 것은 아닙니다. 
모든 로딩 단위와 Dart 라이브러리가 의도한 대로 포함되었는지 확인하는 것은 사용자에게 달려 있습니다. 
예를 들어, 일반적인 실수는 `deferred` 키워드 없이 Dart 라이브러리를 실수로 가져와서, 
지연된 라이브러리가 베이스 로딩 단위의 일부로 컴파일되는 것입니다. 
이 경우, Dart 라이브러리는 항상 베이스에 존재하기 때문에 제대로 로드되고, 라이브러리가 분리되지 않습니다. 
`deferred_components_loading_units.yaml` 파일을 검사하여, 
생성된 로딩 단위가 의도한 대로 설명되어 있는지 확인하면, 이를 확인할 수 있습니다.

지연된 구성 요소 구성을 조정하거나, 로딩 단위를 추가, 수정 또는 제거하는 Dart 변경을 할 때, 
검증기가 실패할 것으로 예상해야 합니다. 
빌드를 계속하기 위해 권장되는 변경 사항을 적용하려면, [3.1][]~3.6(이 단계) 단계를 따르십시오.

</li>
</ol>

### 로컬에서 앱 실행하기 {:#running-the-app-locally}

앱이 `.aab` 파일을 성공적으로 빌드하면, 
Android의 [`bundletool`][]을 사용하여 `--local-testing` 플래그로 로컬 테스트를 수행합니다.

테스트 기기에서 `.aab` 파일을 실행하려면, 
[github.com/google/bundletool/releases][]에서 bundletool jar 실행 파일을 다운로드하고 다음을 실행합니다.

```console
$ java -jar bundletool.jar build-apks --bundle=<your_app_project_dir>/build/app/outputs/bundle/release/app-release.aab --output=<your_temp_dir>/app.apks --local-testing

$ java -jar bundletool.jar install-apks --apks=<your_temp_dir>/app.apks
```

여기서 `<your_app_project_dir>`는 앱의 프로젝트 디렉토리 경로이고, 
`<your_temp_dir>`는 bundletool의 출력을 저장하는 데 사용되는 임시 디렉토리입니다. 
이렇게 하면 `.aab` 파일이 `.apks` 파일로 압축 해제되어 기기에 설치됩니다. 
사용 가능한 모든 Android 동적 기능이 기기에 로컬로 로드되고 지연된 구성 요소의 설치가 에뮬레이션됩니다.

`build-apks`를 다시 실행하기 전에, 기존 앱 .apks 파일을 제거합니다.

```console
$ rm <your_temp_dir>/app.apks
```

Dart 코드베이스를 변경하려면 Android 빌드 ID를 증가시키거나 앱을 제거했다가 다시 설치해야 합니다. 
Android는 새로운 버전 번호를 감지하지 않는 한, 기능 모듈을 업데이트하지 않기 때문입니다.

### Google Play 스토어에 출시 {:#releasing-to-the-google-play-store}

빌드된 `.aab` 파일은 평소처럼 Play 스토어에 직접 업로드할 수 있습니다. 
`loadLibrary()`가 호출되면, 
Dart AOT 라이브러리와 에셋이 포함된 필요한 Android 모듈이 Play 스토어의 전달 기능을 사용하여 
Flutter 엔진에 의해 다운로드됩니다.

[3.1]: #step-3.1
[Android docs]: {{site.android-dev}}/guide/playcore/feature-delivery#declare_splitcompatapplication_in_the_manifest
[`bundletool`]: {{site.android-dev}}/studio/command-line/bundletool
[Deferred Components]: {{site.repo.flutter}}/wiki/Deferred-Components
[`DeferredComponent`]: {{site.api}}/flutter/services/DeferredComponent-class.html
[dynamic feature modules]: {{site.android-dev}}/guide/playcore/feature-delivery
[Flutter Gallery's `lib/deferred_widget.dart`]: {{site.repo.gallery-archive}}/blob/main/lib/deferred_widget.dart
[Flutter wiki]: {{site.repo.flutter}}/tree/master/docs
[github.com/google/bundletool/releases]: {{site.github}}/google/bundletool/releases
[lazily loading a library]: {{site.dart-site}}/language/libraries#lazily-loading-a-library
[release or profile mode]: /testing/build-modes
[step 3.3]: #step-3.3
[android-app-bundle]: {{site.android-dev}}/guide/app-bundle
[dart-def-import]: https://dart.dev/language/libraries#lazily-loading-a-library

