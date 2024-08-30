---
# title: Add a Flutter screen to an iOS app
title: iOS 앱에 Flutter 화면 추가
# short-title: Add a Flutter screen
short-title: Flutter 화면 추가
# description: Learn how to add a single Flutter screen to your existing iOS app.
description: 기존 iOS 앱에 단일 Flutter 화면을 추가하는 방법을 알아보세요.
---

이 가이드에서는 기존 iOS 앱에 단일 Flutter 화면을 추가하는 방법을 설명합니다.

## FlutterEngine 및 FlutterViewController 시작 {:#start-a-flutterengine-and-flutterviewcontroller}

기존 iOS 앱에서 Flutter 화면을 시작하려면, 
[`FlutterEngine`][]과 [`FlutterViewController`][]를 시작합니다.

:::note
`FlutterEngine`은 Dart VM과 Flutter 런타임에 대한 호스트 역할을 하며, `FlutterViewController`는 `FlutterEngine`에 연결되어,
입력 이벤트를 Flutter에 전달하고 `FlutterEngine`에서 렌더링한 프레임을 표시합니다.
:::

`FlutterEngine`은 `FlutterViewController`와 같은 수명을 가질 수도 있고, `FlutterViewController`보다 더 오래 지속될 수도 있습니다.

:::tip
일반적으로 애플리케이션에 대해 오래 지속되는 `FlutterEngine`을 미리 워밍업하는 것이 좋습니다. 
그 이유는 다음과 같습니다.

* `FlutterViewController`를 표시할 때, 첫 번째 프레임이 더 빨리 나타납니다.
* Flutter와 Dart 상태가 하나의 `FlutterViewController`보다 오래 지속됩니다.
* 애플리케이션과 플러그인은 UI를 표시하기 전에, Flutter와 Dart 로직과 상호 작용할 수 있습니다.
:::

엔진 예열의 지연 시간과 메모리 트레이드 오프에 대한 자세한 분석은, 
[로딩 순서 및 성능][Loading sequence and performance]을 참조하세요.

### FlutterEngine 만들기 {:#create-a-flutterengine}

`FlutterEngine`을 생성하는 위치는 호스트 앱에 따라 달라집니다.

{% tabs "darwin-framework" %}
{% tab "SwiftUI" %}

이 예에서, 우리는 `FlutterDependencies`라는 SwiftUI [`Observable`][] 객체 내부에 `FlutterEngine` 객체를 생성합니다. 
`run()`을 호출하여 엔진을 사전 워밍업한 다음, 
`environment()` 뷰 수정자를 사용하여 이 객체를 `ContentView`에 주입합니다.

 ```swift title="MyApp.swift"
import SwiftUI
import Flutter
// 다음 라이브러리는 플러그인을 iOS 플랫폼 코드와 이 앱에 연결합니다.
import FlutterPluginRegistrant

@Observable
class FlutterDependencies {
  let flutterEngine = FlutterEngine(name: "my flutter engine")
  init() {
    // 기본 Flutter 경로로 기본 Dart 진입점을 실행합니다.
    flutterEngine.run()
    // 플러그인을 iOS 플랫폼 코드와 이 앱에 연결합니다.
    GeneratedPluginRegistrant.register(with: self.flutterEngine);
  }
}

@main
struct MyApp: App {
    // flutterDependencies는 뷰 환경을 통해 주입됩니다.
    @State var flutterDependencies = FlutterDependencies()
    var body: some Scene {
      WindowGroup {
        ContentView()
          .environment(flutterDependencies)
      }
    }
}
```

{% endtab %}
{% tab "UIKit-Swift" %}

예를 들어, 앱 시작 시 앱 delegate에서 속성으로 노출되는 
`FlutterEngine`을 생성하는 방법을 보여줍니다.

```swift title="AppDelegate.swift"
import UIKit
import Flutter
// 다음 라이브러리는 플러그인을 iOS 플랫폼 코드와 이 앱에 연결합니다.
import FlutterPluginRegistrant

@UIApplicationMain
class AppDelegate: FlutterAppDelegate { // FlutterAppDelegate에 대해 자세히 알아보세요.
  lazy var flutterEngine = FlutterEngine(name: "my flutter engine")

  override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // 기본 Flutter 경로로 기본 Dart 진입점을 실행합니다.
    flutterEngine.run();
    // 플러그인을 iOS 플랫폼 코드와 이 앱에 연결합니다.
    GeneratedPluginRegistrant.register(with: self.flutterEngine);
    return super.application(application, didFinishLaunchingWithOptions: launchOptions);
  }
}
```

{% endtab %}
{% tab "UIKit-ObjC" %}

다음 예제는 앱 시작 시 앱 delegate에서 속성으로 노출되는 `FlutterEngine`을 만드는 방법을 보여줍니다.

```objc title="AppDelegate.h"
@import UIKit;
@import Flutter;

@interface AppDelegate : FlutterAppDelegate // FlutterAppDelegate에 대한 자세한 내용은 아래와 같습니다.
@property (nonatomic,strong) FlutterEngine *flutterEngine;
@end
```

```objc title="AppDelegate.m"
// 다음 라이브러리는 플러그인을 iOS 플랫폼 코드와 이 앱에 연결합니다.
#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h>

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions {
  self.flutterEngine = [[FlutterEngine alloc] initWithName:@"my flutter engine"];
  // 기본 Flutter 경로로 기본 Dart 진입점을 실행합니다.
  [self.flutterEngine run];
  // 플러그인을 iOS 플랫폼 코드와 이 앱에 연결합니다.
  [GeneratedPluginRegistrant registerWithRegistry:self.flutterEngine];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
```

{% endtab %}
{% endtabs %}

### FlutterEngine으로 FlutterViewController 표시 {:#show-a-flutterviewcontroller-with-your-flutterengine}

{% tabs "darwin-framework" %}
{% tab "SwiftUI" %}

다음 예제는 Flutter 화면에 연결된 [`NavigationLink`][]가 있는 일반적인 `ContentView`를 보여줍니다. 
먼저 `FlutterViewController`를 나타내는 `FlutterViewControllerRepresentable`을 만듭니다. 
`FlutterViewController` 생성자는 미리 워밍업된 `FlutterEngine`을 인수로 받으며, 
이는 뷰 환경을 통해 주입됩니다.

```swift title="ContentView.swift"
import SwiftUI
import Flutter

struct FlutterViewControllerRepresentable: UIViewControllerRepresentable {
  // Flutter 종속성은 뷰 환경을 통해 전달됩니다.
  @Environment(FlutterDependencies.self) var flutterDependencies
  
  func makeUIViewController(context: Context) -> some UIViewController {
    return FlutterViewController(
      engine: flutterDependencies.flutterEngine,
      nibName: nil,
      bundle: nil)
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct ContentView: View {

  var body: some View {
    NavigationStack {
      NavigationLink("My Flutter Feature") {
        FlutterViewControllerRepresentable()
      }
    }
  }
}
```

{% endtab %}
{% tab "UIKit-Swift" %}

다음 예제는 [`FlutterViewController`][]를 표시하기 위해, 
`UIButton`이 연결된 일반적인 `ViewController`를 보여줍니다. 
`FlutterViewController`는 `AppDelegate`에서 생성된, 
`FlutterEngine` 인스턴스를 사용합니다.

```swift title="ViewController.swift"
import UIKit
import Flutter

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    // 누르면 showFlutter 함수를 호출하는 버튼을 만듭니다.
    let button = UIButton(type:UIButton.ButtonType.custom)
    button.addTarget(self, action: #selector(showFlutter), for: .touchUpInside)
    button.setTitle("Show Flutter!", for: UIControl.State.normal)
    button.frame = CGRect(x: 80.0, y: 210.0, width: 160.0, height: 40.0)
    button.backgroundColor = UIColor.blue
    self.view.addSubview(button)
  }

  @objc func showFlutter() {
    let flutterEngine = (UIApplication.shared.delegate as! AppDelegate).flutterEngine
    let flutterViewController =
        FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
    present(flutterViewController, animated: true, completion: nil)
  }
}
```

{% endtab %}
{% tab "UIKit-ObjC" %}

다음 예제는 [`FlutterViewController`][]를 표시하기 위해, 
`UIButton`이 연결된 일반적인 `ViewController`를 보여줍니다. 
`FlutterViewController`는 `AppDelegate`에서 생성된 `FlutterEngine` 인스턴스를 사용합니다.

```objc title="ViewController.m"
@import Flutter;
#import "AppDelegate.h"
#import "ViewController.h"

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];

    // 누르면 showFlutter 함수를 호출하는 버튼을 만듭니다.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(showFlutter)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Show Flutter!" forState:UIControlStateNormal];
    button.backgroundColor = UIColor.blueColor;
    button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [self.view addSubview:button];
}

- (void)showFlutter {
    FlutterEngine *flutterEngine =
        ((AppDelegate *)UIApplication.sharedApplication.delegate).flutterEngine;
    FlutterViewController *flutterViewController =
        [[FlutterViewController alloc] initWithEngine:flutterEngine nibName:nil bundle:nil];
    [self presentViewController:flutterViewController animated:YES completion:nil];
}
@end
```

{% endtab %}
{% endtabs %}

이제, iOS 앱에 Flutter 화면이 내장되었습니다.

:::note
이전 예제를 사용하면, 
기본 Dart 라이브러리의 기본 `main()` 진입점 함수는, 
`AppDelegate`에서 생성된 `FlutterEngine`에서 `run`을 호출할 때 실행됩니다.
:::

### _대안으로_ - implicit FlutterEngine을 사용하여 FlutterViewController를 만듭니다. {:#alternatively-create-a-flutterviewcontroller-with-an-implicit-flutterengine}

이전 예제의 대안으로, `FlutterViewController`가 사전에 하나를 예열하지 않고도, 
암묵적으로 자체 `FlutterEngine`을 생성하도록 할 수 있습니다.

이는 일반적으로 권장되지 않습니다. 
주문형으로 `FlutterEngine`을 생성하면, `FlutterViewController`가 표시되는 시점과 첫 번째 프레임을 렌더링하는 시점 사이에 눈에 띄는 지연이 발생할 수 있기 때문입니다. 
그러나, Flutter 화면이 거의 표시되지 않고, Dart VM을 언제 시작해야 하는지 판단할 수 있는 좋은 휴리스틱이 없으며, 
Flutter가 뷰 컨트롤러 간에 상태를 유지할 필요가 없는 경우, 이 방법이 유용할 수 있습니다.

기존 `FlutterEngine` 없이 `FlutterViewController`가 표시되도록 하려면, 
`FlutterEngine` 구성을 생략하고 엔진 참조 없이 `FlutterViewController`를 만듭니다.

{% tabs "darwin-framework" %}
{% tab "SwiftUI" %}

```swift title="ContentView.swift"
import SwiftUI
import Flutter

struct FlutterViewControllerRepresentable: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> some UIViewController {
    return FlutterViewController(
      project: nil,
      nibName: nil,
      bundle: nil)
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct ContentView: View {
  var body: some View {
    NavigationStack {
      NavigationLink("My Flutter Feature") {
        FlutterViewControllerRepresentable()
      }
    }
  }
}
```

{% endtab %}
{% tab "UIKit-Swift" %}

```swift title="ViewController.swift"
// 기존 코드는 생략되었습니다.
func showFlutter() {
  let flutterViewController = FlutterViewController(project: nil, nibName: nil, bundle: nil)
  present(flutterViewController, animated: true, completion: nil)
}
```

{% endtab %}
{% tab "UIKit-ObjC" %}

```objc title="ViewController.m"
// 기존 코드는 생략되었습니다.
- (void)showFlutter {
  FlutterViewController *flutterViewController =
      [[FlutterViewController alloc] initWithProject:nil nibName:nil bundle:nil];
  [self presentViewController:flutterViewController animated:YES completion:nil];
}
@end
```

{% endtab %}
{% endtabs %}

대기 시간 및 메모리 사용에 대한 자세한 내용은 [로딩 순서 및 성능][Loading sequence and performance]을 참조하세요.

## FlutterAppDelegate 사용하기 {:#using-the-flutterappdelegate}

애플리케이션의 `UIApplicationDelegate` 하위 클래스인 `FlutterAppDelegate`를 사용하는 것이 좋지만 필수는 아닙니다.

`FlutterAppDelegate`는 다음과 같은 기능을 수행합니다.

* [`openURL`][]과 같은 애플리케이션 콜백을 [local_auth][]와 같은 플러그인으로 전달합니다.
* 휴대전화 화면이 잠길 때 디버그 모드에서 Flutter 연결을 열어둡니다.

### FlutterAppDelegate 서브클래스 생성 {:#creating-a-flutterappdelegate-subclass}

UIKit 앱에서 `FlutterAppDelegate`의 하위 클래스를 만드는 것은 [FlutterEngine 및 FlutterViewController 시작 섹션][Start a FlutterEngine and FlutterViewController section]에서 보여졌습니다. 
SwiftUI 앱에서, `FlutterAppDelegate`의 하위 클래스를 만들고, 
다음과 같이 [`Observable()`][] 매크로로 어노테이션을 달 수 있습니다.

```swift
import SwiftUI
import Flutter
import FlutterPluginRegistrant

@Observable
class AppDelegate: FlutterAppDelegate {
  let flutterEngine = FlutterEngine(name: "my flutter engine")

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      // 기본 Flutter 경로로 기본 Dart 진입점을 실행합니다.
      flutterEngine.run();
      // 플러그인을 연결하는 데 사용됩니다. (iOS 플랫폼 코드가 있는 플러그인이 있는 경우에만)
      GeneratedPluginRegistrant.register(with: self.flutterEngine);
      return true;
    }
}

@main
struct MyApp: App {
  // 이 속성 래퍼를 사용하여, 
  // SwiftUI에 애플리케이션 delegate에 대한 AppDelegate 클래스를 사용해야 한다고 알립니다.
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
      WindowGroup {
        ContentView()
      }
  }
}
```

그러면, 뷰에서 `AppDelegate`에 뷰 환경을 통해 접근할 수 있습니다.

```swift title="ContentView.swift"
import SwiftUI
import Flutter

struct FlutterViewControllerRepresentable: UIViewControllerRepresentable {
  // 뷰 환경을 통해 AppDelegate에 액세스합니다.
  @Environment(AppDelegate.self) var appDelegate
  
  func makeUIViewController(context: Context) -> some UIViewController {
    return FlutterViewController(
      engine: appDelegate.flutterEngine,
      nibName: nil,
      bundle: nil)
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct ContentView: View {

  var body: some View {
    NavigationStack {
      NavigationLink("My Flutter Feature") {
        FlutterViewControllerRepresentable()
      }
    }
  }
}
```

### FlutterAppDelegate를 직접 하위 클래스로 만들 수 없는 경우 {:#if-you-cant-directly-make-flutterappdelegate-a-subclass}

앱 delegate가 `FlutterAppDelegate`를 하위 클래스로 직접 만들 수 없는 경우, 
앱 delegate가 `FlutterAppLifeCycleProvider` 프로토콜을 구현하도록 하여, 
플러그인이 필요한 콜백을 수신하도록 합니다. 
그렇지 않으면, 이러한 이벤트에 의존하는 플러그인이 정의되지 않은 동작을 할 수 있습니다.

예를 들어:

{% tabs "darwin-language" %}
{% tab "Swift" %}

```swift title="AppDelegate.swift"
import Foundation
import Flutter

@Observable
class AppDelegate: UIResponder, UIApplicationDelegate, FlutterAppLifeCycleProvider {

  private let lifecycleDelegate = FlutterPluginAppLifeCycleDelegate()

  let flutterEngine = FlutterEngine(name: "my flutter engine")

  override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    flutterEngine.run()
    return lifecycleDelegate.application(application, didFinishLaunchingWithOptions: launchOptions ?? [:])
  }

  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    lifecycleDelegate.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    lifecycleDelegate.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
  }

  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    lifecycleDelegate.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
  }

  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    return lifecycleDelegate.application(app, open: url, options: options)
  }

  func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
    return lifecycleDelegate.application(application, handleOpen: url)
  }

  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    return lifecycleDelegate.application(application, open: url, sourceApplication: sourceApplication ?? "", annotation: annotation)
  }

  func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
    lifecycleDelegate.application(application, performActionFor: shortcutItem, completionHandler: completionHandler)
  }

  func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
    lifecycleDelegate.application(application, handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler)
  }

  func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    lifecycleDelegate.application(application, performFetchWithCompletionHandler: completionHandler)
  }

  func add(_ delegate: FlutterApplicationLifeCycleDelegate) {
    lifecycleDelegate.add(delegate)
  }
}
```

{% endtab %}
{% tab "Objective-C" %}

```objc title="AppDelegate.h"
@import Flutter;
@import UIKit;
@import FlutterPluginRegistrant;

@interface AppDelegate : UIResponder <UIApplicationDelegate, FlutterAppLifeCycleProvider>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) FlutterEngine *flutterEngine;
@end
```

The implementation should delegate mostly to a
`FlutterPluginAppLifeCycleDelegate`:

```objc title="AppDelegate.m"
@interface AppDelegate ()
@property (nonatomic, strong) FlutterPluginAppLifeCycleDelegate* lifeCycleDelegate;
@end

@implementation AppDelegate

- (instancetype)init {
    if (self = [super init]) {
        _lifeCycleDelegate = [[FlutterPluginAppLifeCycleDelegate alloc] init];
    }
    return self;
}

- (BOOL)application:(UIApplication*)application
didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id>*))launchOptions {
    self.flutterEngine = [[FlutterEngine alloc] initWithName:@"io.flutter" project:nil];
    [self.flutterEngine runWithEntrypoint:nil];
    [GeneratedPluginRegistrant registerWithRegistry:self.flutterEngine];
    return [_lifeCycleDelegate application:application didFinishLaunchingWithOptions:launchOptions];
}

// FlutterViewController인 경우, 키 창의 rootViewController를 반환합니다.
// 그렇지 않으면, nil을 반환합니다.
- (FlutterViewController*)rootFlutterViewController {
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([viewController isKindOfClass:[FlutterViewController class]]) {
        return (FlutterViewController*)viewController;
    }
    return nil;
}

- (void)application:(UIApplication*)application
didRegisterUserNotificationSettings:(UIUserNotificationSettings*)notificationSettings {
    [_lifeCycleDelegate application:application
didRegisterUserNotificationSettings:notificationSettings];
}

- (void)application:(UIApplication*)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    [_lifeCycleDelegate application:application
didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication*)application
didReceiveRemoteNotification:(NSDictionary*)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    [_lifeCycleDelegate application:application
       didReceiveRemoteNotification:userInfo
             fetchCompletionHandler:completionHandler];
}

- (BOOL)application:(UIApplication*)application
            openURL:(NSURL*)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id>*)options {
    return [_lifeCycleDelegate application:application openURL:url options:options];
}

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)url {
    return [_lifeCycleDelegate application:application handleOpenURL:url];
}

- (BOOL)application:(UIApplication*)application
            openURL:(NSURL*)url
  sourceApplication:(NSString*)sourceApplication
         annotation:(id)annotation {
    return [_lifeCycleDelegate application:application
                                   openURL:url
                         sourceApplication:sourceApplication
                                annotation:annotation];
}

- (void)application:(UIApplication*)application
performActionForShortcutItem:(UIApplicationShortcutItem*)shortcutItem
  completionHandler:(void (^)(BOOL succeeded))completionHandler {
    [_lifeCycleDelegate application:application
       performActionForShortcutItem:shortcutItem
                  completionHandler:completionHandler];
}

- (void)application:(UIApplication*)application
handleEventsForBackgroundURLSession:(nonnull NSString*)identifier
  completionHandler:(nonnull void (^)(void))completionHandler {
    [_lifeCycleDelegate application:application
handleEventsForBackgroundURLSession:identifier
                  completionHandler:completionHandler];
}

- (void)application:(UIApplication*)application
performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    [_lifeCycleDelegate application:application performFetchWithCompletionHandler:completionHandler];
}

- (void)addApplicationLifeCycleDelegate:(NSObject<FlutterPlugin>*)delegate {
    [_lifeCycleDelegate addDelegate:delegate];
}
@end
```

{% endtab %}
{% endtabs %}

## 시작 옵션 {:#launch-options}

이 예제에서는 기본 실행(default launch) 설정을 사용하여, Flutter를 실행하는 방법을 보여줍니다.

Flutter 런타임을 커스터마이즈하기 위해, Dart 진입점, 라이브러리 및 경로를 지정할 수도 있습니다.

### Dart 진입점 {:#dart-entrypoint}

`FlutterEngine`에서 `run`을 호출하면, 
기본적으로, `lib/main.dart` 파일의 `main()` Dart 함수가 실행됩니다.

다른 Dart 함수를 지정하는 `NSString`과 함께, 
[`runWithEntrypoint`][]를 사용하여 다른 진입점 함수를 실행할 수도 있습니다.

:::note
`main()` 이외의 Dart 진입점 함수는, 
컴파일 시 [tree-shaken][]되지 않도록 다음과 같이 주석 처리되어야 합니다.

```dart
@pragma('vm:entry-point')
void myOtherEntrypoint() { ... };
```
:::

### Dart 라이브러리 {:#dart-library}

Dart 함수를 지정하는 것 외에도, 특정 파일에서 진입점 함수를 지정할 수 있습니다.

예를 들어, 다음은 `lib/main.dart`의 `main()` 대신, 
`lib/other_file.dart`에서 `myOtherEntrypoint()`를 실행합니다.

{% tabs "darwin-language" %}
{% tab "Swift" %}

```swift
flutterEngine.run(withEntrypoint: "myOtherEntrypoint", libraryURI: "other_file.dart")
```

{% endtab %}
{% tab "Objective-C" %}

```objc
[flutterEngine runWithEntrypoint:@"myOtherEntrypoint" libraryURI:@"other_file.dart"];
```

{% endtab %}
{% endtabs %}


### Route {:#route}

Flutter 버전 1.22부터, 
FlutterEngine 또는 FlutterViewController를 구성할 때, 
Flutter [`WidgetsApp`][]에 대한 초기 경로를 설정할 수 있습니다.

{% tabs "darwin-language" %}
{% tab "Swift" %}

```swift
let flutterEngine = FlutterEngine()
// FlutterDefaultDartEntrypoint는 main()을 실행하는 nil과 동일합니다.
engine.run(
  withEntrypoint: "main", initialRoute: "/onboarding")
```

{% endtab %}
{% tab "Objective-C" %}

```objc
FlutterEngine *flutterEngine = [[FlutterEngine alloc] init];
// FlutterDefaultDartEntrypoint는 main()을 실행하는 nil과 동일합니다.
[flutterEngine runWithEntrypoint:FlutterDefaultDartEntrypoint
                    initialRoute:@"/onboarding"];
```

{% endtab %}
{% endtabs %}

이 코드는 `dart:ui`의 [`PlatformDispatcher.defaultRouteName`][]을
`"/"` 대신 `"/onboarding"`으로 설정합니다.

또는, FlutterEngine을 미리 예열하지 않고, 
FlutterViewController를 직접 구성하려면 다음을 수행합니다.

{% tabs "darwin-language" %}
{% tab "Swift" %}

```swift
let flutterViewController = FlutterViewController(
      project: nil, initialRoute: "/onboarding", nibName: nil, bundle: nil)
```

{% endtab %}
{% tab "Objective-C" %}

```objc
FlutterViewController* flutterViewController =
      [[FlutterViewController alloc] initWithProject:nil
                                        initialRoute:@"/onboarding"
                                             nibName:nil
                                              bundle:nil];
```

{% endtab %}
{% endtabs %}

:::tip
`FlutterEngine`이 이미 실행 중일 때, 플랫폼 측에서 현재 Flutter 경로를 필수적으로 변경하려면, 
`FlutterViewController`에서 [`pushRoute()`][] 또는 [`popRoute()`]를 사용합니다.

Flutter 측에서 iOS 경로를 팝하려면, [`SystemNavigator.pop()`][]를 호출합니다.
:::

Flutter 경로에 대한 자세한 내용은 [네비게이션 및 라우팅][Navigation and routing]을 참조하세요.

### 기타 {:#other}

이전 예제는 Flutter 인스턴스가 시작되는 방식을 커스터마이즈하는 몇 가지 방법만 보여줍니다. 
[platform channels][]를 사용하면, `FlutterViewController`를 사용하여, 
Flutter UI를 표시하기 전에 원하는 대로 데이터를 푸시하거나, Flutter 환경을 준비할 수 있습니다.

[`FlutterEngine`]: {{site.api}}/ios-embedder/interface_flutter_engine.html
[`FlutterViewController`]: {{site.api}}/ios-embedder/interface_flutter_view_controller.html
[Loading sequence and performance]: /add-to-app/performance
[local_auth]: {{site.pub}}/packages/local_auth
[Navigation and routing]: /ui/navigation
[Navigator]: {{site.api}}/flutter/widgets/Navigator-class.html
[`NavigatorState`]: {{site.api}}/flutter/widgets/NavigatorState-class.html
[`openURL`]: {{site.apple-dev}}/documentation/uikit/uiapplicationdelegate/1623112-application
[platform channels]: /platform-integration/platform-channels
[`popRoute()`]: {{site.api}}/ios-embedder/interface_flutter_view_controller.html#ac89c8010fbf7a39f7aaab64f68c013d2
[`pushRoute()`]: {{site.api}}/ios-embedder/interface_flutter_view_controller.html#ac7cffbf03f9c8c0b28d1f0dafddece4e
[`runApp`]: {{site.api}}/flutter/widgets/runApp.html
[`runWithEntrypoint`]: {{site.api}}/ios-embedder/interface_flutter_engine.html#a019d6b3037eff6cfd584fb2eb8e9035e
[`SystemNavigator.pop()`]: {{site.api}}/flutter/services/SystemNavigator/pop.html
[tree-shaken]: https://en.wikipedia.org/wiki/Tree_shaking
[`WidgetsApp`]: {{site.api}}/flutter/widgets/WidgetsApp-class.html
[`PlatformDispatcher.defaultRouteName`]: {{site.api}}/flutter/dart-ui/PlatformDispatcher/defaultRouteName.html
[Start a FlutterEngine and FlutterViewController section]:/add-to-app/ios/add-flutter-screen/#start-a-flutterengine-and-flutterviewcontroller
[`Observable`]: https://developer.apple.com/documentation/observation/observable
[`NavigationLink`]: https://developer.apple.com/documentation/swiftui/navigationlink
[`Observable()`]: https://developer.apple.com/documentation/observation/observable()
