`FlutterActivity` 또는 `FlutterFragment`를 새 `FlutterEngine`으로 구성할 때, 
초기 경로의 개념을 사용할 수 있습니다. 
그러나, `FlutterActivity`와 `FlutterFragment`는 캐시된 엔진을 사용할 때, 
초기 경로의 개념을 제공하지 않습니다. 
이는 캐시된 엔진이 이미 Dart 코드를 실행 중일 것으로 예상되기 때문에, 
초기 경로를 구성하기에는 너무 늦었기 때문입니다.

캐시된 엔진이 커스텀 초기 경로로 시작되기를 원하는 개발자는, 
Dart 진입점을 실행하기 직전에 커스텀 초기 경로를 사용하도록 캐시된 `FlutterEngine`을 구성할 수 있습니다. 
다음 예는 캐시된 엔진에서 초기 경로를 사용하는 방법을 보여줍니다.

{% tabs "android-language" %}
{% tab "Kotlin" %}

```kotlin title="MyApplication.kt"
class MyApplication : Application() {
  lateinit var flutterEngine : FlutterEngine
  override fun onCreate() {
    super.onCreate()
    // FlutterEngine을 인스턴스화합니다.
    flutterEngine = FlutterEngine(this)
    // 초기 경로를 구성합니다.
    flutterEngine.navigationChannel.setInitialRoute("your/route/here");
    // FlutterEngine을 예열하기 위해 Dart 코드 실행을 시작합니다.
    flutterEngine.dartExecutor.executeDartEntrypoint(
      DartExecutor.DartEntrypoint.createDefault()
    )
    // FlutterActivity 또는 FlutterFragment에서 사용할 FlutterEngine을 캐시합니다.
    FlutterEngineCache
      .getInstance()
      .put("my_engine_id", flutterEngine)
  }
}
```

{% endtab %}
{% tab "Java" %}

```java title="MyApplication.java"
public class MyApplication extends Application {
  @Override
  public void onCreate() {
    super.onCreate();
    // FlutterEngine을 인스턴스화합니다.
    flutterEngine = new FlutterEngine(this);
    // 초기 경로를 구성합니다.
    flutterEngine.getNavigationChannel().setInitialRoute("your/route/here");
    // FlutterEngine을 예열하기 위해 Dart 코드 실행을 시작합니다.
    flutterEngine.getDartExecutor().executeDartEntrypoint(
      DartEntrypoint.createDefault()
    );
    // FlutterActivity 또는 FlutterFragment에서 사용할 FlutterEngine을 캐시합니다.
    FlutterEngineCache
      .getInstance()
      .put("my_engine_id", flutterEngine);
  }
}
```

{% endtab %}
{% endtabs %}

탐색 채널의 초기 경로를 설정하면, 
연관된 `FlutterEngine`은 `runApp()` Dart 함수의 초기 실행 시 원하는 경로를 표시합니다.

`runApp()`의 초기 실행 후 탐색 채널의 초기 경로 속성을 변경해도 아무런 효과가 없습니다. 
서로 다른 `Activity`와 `Fragment` 간에 동일한 `FlutterEngine`을 사용하고, 
해당 디스플레이 간에 경로를 전환하려는 개발자는, 
메서드 채널을 설정하고 Dart 코드에 `Navigator` 경로를 변경하도록 명시적으로 지시해야 합니다.