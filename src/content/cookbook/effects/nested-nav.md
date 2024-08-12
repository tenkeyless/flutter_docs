---
# title: Create a nested navigation flow
title: 중첩된 네비게이션 흐름 만들기
# description: How to implement a flow with nested navigation.
description: 중첩된 네비게이션이 있는 흐름을 구현하는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/effects/nested_nav"?>

앱은 시간이 지남에 따라 수십 개, 그다음에는 수백 개의 경로를 축적합니다. 
일부 경로는 최상위(top-level, global) 경로(routes)로 의미가 있습니다. 
예를 들어, "/", "profile", "contact", "social_feed"는 모두 앱 내에서 가능한 최상위 경로입니다. 
하지만, 최상위 `Navigator` 위젯에서 가능한 모든 경로를 정의했다고 가정해 보겠습니다. 
목록은 매우 길어질 것이고, 이러한 경로 중 다수는 다른 위젯 내에 중첩하여 처리하는 것이 더 좋습니다.

앱으로 제어하는 ​​무선 전구에 대한 사물 인터넷(IoT) 설정 흐름을 생각해 보세요. 
이 설정 흐름은 4개 페이지로 구성됩니다. 

1> 근처 전구 찾기, 2> 추가하려는 전구 선택, 3> 전구 추가, 4> 설정 완료. 

최상위 `Navigator` 위젯에서 이 동작을 조율할 수 있습니다. 
하지만, `SetupFlow` 위젯 내에 두 번째 중첩된 `Navigator` 위젯을 정의하고, 
중첩된 `Navigator`가 설정 흐름의 4개 페이지에 대한 소유권을 갖도록 하는 것이 더 합리적입니다. 
이러한 네비게이션 위임은 더 큰 로컬 제어를 용이하게 하며, 이는 일반적으로 소프트웨어를 개발할 때 선호됩니다.

다음 애니메이션은 앱의 동작을 보여줍니다.

![중첩된 "설정" 흐름을 보여주는 GIF](/assets/images/docs/cookbook/effects/NestedNavigator.gif){:.site-mobile-screenshot}

이 레시피에서는, 최상위 `Navigator` 위젯 아래에 중첩된 자체 탐색을 유지하는 4페이지 IoT 설정 흐름을 구현합니다.

## 네비게이션 준비 {:#prepare-for-navigation}

이 IoT 앱에는 설정 흐름과 함께, 두 개의 최상위 화면이 있습니다. 
이러한 경로 이름을 상수로 정의하여 코드 내에서 참조할 수 있도록 합니다.

<?code-excerpt "lib/main.dart (routes)"?>
```dart
const routeHome = '/';
const routeSettings = '/settings';
const routePrefixDeviceSetup = '/setup/';
const routeDeviceSetupStart = '/setup/$routeDeviceSetupStartPage';
const routeDeviceSetupStartPage = 'find_devices';
const routeDeviceSetupSelectDevicePage = 'select_device';
const routeDeviceSetupConnectingPage = 'connecting';
const routeDeviceSetupFinishedPage = 'finished';
```

홈 및 설정 화면은 정적 이름으로 참조됩니다. 
그러나, 설정 흐름 페이지는, 두 경로를 사용하여 경로 이름을 만듭니다. `/setup/` 접두사 뒤에 특정 페이지 이름이 옵니다. 
두 경로를 결합하면, `Navigator`는 설정 흐름과 관련된 모든 개별 페이지를 인식하지 않고도, 
경로 이름이 설정 흐름에 대한 것인지 확인할 수 있습니다.

최상위 `Navigator`는 개별 설정 흐름 페이지를 식별할 책임이 없습니다. 
따라서, 최상위 `Navigator`는 들어오는 경로 이름을 구문 분석하여 설정 흐름 접두사를 식별해야 합니다. 
경로 이름을 구문 분석해야 한다는 것은 최상위 `Navigator`의 `routes` 속성을 사용할 수 없다는 것을 의미합니다. 
대신, `onGenerateRoute` 속성에 대한 함수를 제공해야 합니다.

세 개의 최상위 경로 각각에 대해 적절한 위젯을 반환하도록 `onGenerateRoute`를 구현합니다.

<?code-excerpt "lib/main.dart (OnGenerateRoute)"?>
```dart
onGenerateRoute: (settings) {
  late Widget page;
  if (settings.name == routeHome) {
    page = const HomeScreen();
  } else if (settings.name == routeSettings) {
    page = const SettingsScreen();
  } else if (settings.name!.startsWith(routePrefixDeviceSetup)) {
    final subRoute =
        settings.name!.substring(routePrefixDeviceSetup.length);
    page = SetupFlow(
      setupPageRoute: subRoute,
    );
  } else {
    throw Exception('Unknown route: ${settings.name}');
  }

  return MaterialPageRoute<dynamic>(
    builder: (context) {
      return page;
    },
    settings: settings,
  );
},
```

홈 및 설정 경로가 정확한 경로 이름과 일치한다는 점에 유의하세요. 
그러나, 설정 흐름 경로 조건은 접두사만 확인합니다. 
경로 이름에 설정 흐름 접두사가 포함되어 있으면, 나머지 경로 이름은 무시되고, `SetupFlow` 위젯으로 전달되어 처리됩니다. 
경로 이름을 이렇게 분할하면, 최상위 `Navigator`가 설정 흐름 내의 다양한 하위 경로에 대해 독립적일 수 있습니다.

경로 이름을 받는 `SetupFlow`라는 stateful 위젯을 만듭니다.

<?code-excerpt "lib/setupflow.dart (SetupFlow)" replace="/@override\n*.*\n\s*return const SizedBox\(\);\n\s*}/\/\/.../g"?>
```dart
class SetupFlow extends StatefulWidget {
  const SetupFlow({
    super.key,
    required this.setupPageRoute,
  });

  final String setupPageRoute;

  @override
  State<SetupFlow> createState() => SetupFlowState();
}

class SetupFlowState extends State<SetupFlow> {
  //...
}
```

## 설정 흐름에 대한 앱 바 표시 {:#display-an-app-bar-for-the-setup-flow}

설정 흐름은 모든 페이지에 나타나는 지속적인 앱 바(persistent app bar)를 표시합니다.

`SetupFlow` 위젯의 `build()` 메서드에서 원하는 `AppBar` 위젯을 포함하는 `Scaffold` 위젯을 반환합니다.

<?code-excerpt "lib/setupflow2.dart (SetupFlow2)"?>
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: _buildFlowAppBar(),
    body: const SizedBox(),
  );
}

PreferredSizeWidget _buildFlowAppBar() {
  return AppBar(
    title: const Text('Bulb Setup'),
  );
}
```

앱 바에 뒤로가기 화살표가 표시되고, 뒤로가기 화살표를 누르면 설정 흐름이 종료됩니다. 
그러나, 흐름을 종료하면 사용자는 모든 진행 상황을 잃게 됩니다. 
따라서, 사용자에게 설정 흐름을 종료할지 확인하라는 메시지가 표시됩니다.

사용자에게 설정 흐름 종료를 확인하라는 메시지를 표시하고, 
사용자가 Android에서 하드웨어 뒤로가기 버튼을 누르면 메시지가 표시되는지 확인합니다.

<?code-excerpt "lib/prompt_user.dart (PromptUser)"?>
```dart
Future<void> _onExitPressed() async {
  final isConfirmed = await _isExitDesired();

  if (isConfirmed && mounted) {
    _exitSetup();
  }
}

Future<bool> _isExitDesired() async {
  return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text(
                  'If you exit device setup, your progress will be lost.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Leave'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Stay'),
                ),
              ],
            );
          }) ??
      false;
}

void _exitSetup() {
  Navigator.of(context).pop();
}

@override
Widget build(BuildContext context) {
  return PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, _) async {
      if (didPop) return;

      if (await _isExitDesired() && context.mounted) {
        _exitSetup();
      }
    },
    child: Scaffold(
      appBar: _buildFlowAppBar(),
      body: const SizedBox(),
    ),
  );
}

PreferredSizeWidget _buildFlowAppBar() {
  return AppBar(
    leading: IconButton(
      onPressed: _onExitPressed,
      icon: const Icon(Icons.chevron_left),
    ),
    title: const Text('Bulb Setup'),
  );
}
```

사용자가 앱 바에서 뒤로가기 화살표를 탭하거나, Android에서 뒤로가기 버튼을 누르면, 
알림 대화 상자가 나타나 사용자가 설정 흐름을 종료할지 확인합니다. 
사용자가 **Leave**를 누르면, 설정 흐름이 최상위 네비게이션 스택에서 팝업됩니다. 
사용자가 **Stay**를 누르면, 작업이 무시됩니다.

`Navigator.pop()`가 **Leave** 및 **Stay** 버튼 모두에서 호출되는 것을 알 수 있습니다. 
명확히 하자면, 이 `pop()` 작업은 설정 흐름이 아니라 네비게이션 스택에서 알림 대화 상자를 팝업합니다.

## 중첩된 경로 생성 {:#generate-nested-routes}

설정 흐름의 작업은 흐름 내에서 적절한 페이지를 표시하는 것입니다.

`SetupFlow`에 `Navigator` 위젯을 추가하고, `onGenerateRoute` 속성을 구현합니다.

<?code-excerpt "lib/add_navigator.dart (AddNavigator)"?>
```dart
final _navigatorKey = GlobalKey<NavigatorState>();

void _onDiscoveryComplete() {
  _navigatorKey.currentState!.pushNamed(routeDeviceSetupSelectDevicePage);
}

void _onDeviceSelected(String deviceId) {
  _navigatorKey.currentState!.pushNamed(routeDeviceSetupConnectingPage);
}

void _onConnectionEstablished() {
  _navigatorKey.currentState!.pushNamed(routeDeviceSetupFinishedPage);
}

@override
Widget build(BuildContext context) {
  return PopScope(
    canPop: false,
    onPopInvokedWithResult: (didPop, _) async {
      if (didPop) return;

      if (await _isExitDesired() && context.mounted) {
        _exitSetup();
      }
    },
    child: Scaffold(
      appBar: _buildFlowAppBar(),
      body: Navigator(
        key: _navigatorKey,
        initialRoute: widget.setupPageRoute,
        onGenerateRoute: _onGenerateRoute,
      ),
    ),
  );
}

Route<Widget> _onGenerateRoute(RouteSettings settings) {
  final page = switch (settings.name) {
    routeDeviceSetupStartPage => WaitingPage(
        message: 'Searching for nearby bulb...',
        onWaitComplete: _onDiscoveryComplete,
      ),
    routeDeviceSetupSelectDevicePage => SelectDevicePage(
        onDeviceSelected: _onDeviceSelected,
      ),
    routeDeviceSetupConnectingPage => WaitingPage(
        message: 'Connecting...',
        onWaitComplete: _onConnectionEstablished,
      ),
    routeDeviceSetupFinishedPage => FinishedPage(
        onFinishPressed: _exitSetup,
      ),
    _ => throw StateError('Unexpected route name: ${settings.name}!')
  };

  return MaterialPageRoute(
    builder: (context) {
      return page;
    },
    settings: settings,
  );
}
```

`_onGenerateRoute` 함수는 최상위 `Navigator`와 동일하게 작동합니다. 
`RouteSettings` 객체가 함수에 전달되며, 여기에는 경로의 `name`이 포함됩니다. 
해당 경로 이름을 기준으로 4개의 흐름 페이지 중 하나가 반환됩니다.

`find_devices`라는 첫 번째 페이지는, 네트워크 스캐닝을 시뮬레이션하기 위해 몇 초 동안 기다립니다. 
대기 기간 후, 페이지는 콜백을 호출합니다. 이 경우, 해당 콜백은 `_onDiscoveryComplete`입니다. 
설정 흐름은 장치 검색이 완료되면, 장치 선택 페이지가 표시되어야 함을 인식합니다. 
따라서, `_onDiscoveryComplete`에서, `_navigatorKey`는 중첩된 `Navigator`에게 
`select_device` 페이지로 네비게이트하도록 지시합니다.

`select_device` 페이지는 사용자에게 사용 가능한 장치 목록에서 장치를 선택하도록 요청합니다. 
이 레시피에서는, 하나의 장치만 사용자에게 표시됩니다. 사용자가 기기를 탭하면, `onDeviceSelected` 콜백이 호출됩니다. 
설정 흐름은 기기를 선택하면, 연결 페이지가 표시되어야 한다는 것을 인식합니다. 
따라서, `_onDeviceSelected`에서, `_navigatorKey`는 중첩된 `Navigator`에게
`"connecting"` 페이지로 이동하도록 지시합니다.

`connecting` 페이지는 `find_devices` 페이지와 같은 방식으로 작동합니다. 
`connecting` 페이지는 몇 초 동안 기다린 다음 콜백을 호출합니다. 이 경우, 콜백은 `_onConnectionEstablished`입니다. 
설정 흐름은 연결이 설정되면, 마지막 페이지가 표시되어야 한다는 것을 인식합니다. 
따라서, `_onConnectionEstablished`에서, `_navigatorKey`는 중첩된 `Navigator`에게 
`finished` 페이지로 이동하도록 지시합니다.

`finished` 페이지는 사용자에게 **Finish** 버튼을 제공합니다. 
사용자가 **Finish**를 탭하면, `_exitSetup` 콜백이 호출되어, 
전체 설정 흐름이 최상위 `Navigator` 스택에서 팝업되고, 사용자는 홈 화면으로 돌아갑니다.

축하합니다!
네 개의 하위 경로로 중첩된 네비게이션을 구현했습니다.

## 대화형 예제 {:#interactive-example}

앱 실행:

* **Add your first bulb** 화면에서, 더하기 기호, **+**로 표시된 FAB를 클릭합니다. 
  그러면 **Select a nearby device** 화면으로 이동합니다. 전구 하나가 나열됩니다.
* 나열된 전구를 클릭합니다. **Finished!** 화면이 나타납니다.
* **Finished** 버튼을 클릭하여, 첫 번째 화면으로 돌아갑니다.

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter nested navigation hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

const routeHome = '/';
const routeSettings = '/settings';
const routePrefixDeviceSetup = '/setup/';
const routeDeviceSetupStart = '/setup/$routeDeviceSetupStartPage';
const routeDeviceSetupStartPage = 'find_devices';
const routeDeviceSetupSelectDevicePage = 'select_device';
const routeDeviceSetupConnectingPage = 'connecting';
const routeDeviceSetupFinishedPage = 'finished';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
        ),
      ),
      onGenerateRoute: (settings) {
        late Widget page;
        if (settings.name == routeHome) {
          page = const HomeScreen();
        } else if (settings.name == routeSettings) {
          page = const SettingsScreen();
        } else if (settings.name!.startsWith(routePrefixDeviceSetup)) {
          final subRoute =
              settings.name!.substring(routePrefixDeviceSetup.length);
          page = SetupFlow(
            setupPageRoute: subRoute,
          );
        } else {
          throw Exception('Unknown route: ${settings.name}');
        }

        return MaterialPageRoute<dynamic>(
          builder: (context) {
            return page;
          },
          settings: settings,
        );
      },
      debugShowCheckedModeBanner: false,
    ),
  );
}

@immutable
class SetupFlow extends StatefulWidget {
  static SetupFlowState of(BuildContext context) {
    return context.findAncestorStateOfType<SetupFlowState>()!;
  }

  const SetupFlow({
    super.key,
    required this.setupPageRoute,
  });

  final String setupPageRoute;

  @override
  SetupFlowState createState() => SetupFlowState();
}

class SetupFlowState extends State<SetupFlow> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
  }

  void _onDiscoveryComplete() {
    _navigatorKey.currentState!.pushNamed(routeDeviceSetupSelectDevicePage);
  }

  void _onDeviceSelected(String deviceId) {
    _navigatorKey.currentState!.pushNamed(routeDeviceSetupConnectingPage);
  }

  void _onConnectionEstablished() {
    _navigatorKey.currentState!.pushNamed(routeDeviceSetupFinishedPage);
  }

  Future<void> _onExitPressed() async {
    final isConfirmed = await _isExitDesired();

    if (isConfirmed && mounted) {
      _exitSetup();
    }
  }

  Future<bool> _isExitDesired() async {
    return await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Are you sure?'),
                content: const Text(
                    'If you exit device setup, your progress will be lost.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Leave'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('Stay'),
                  ),
                ],
              );
            }) ??
        false;
  }

  void _exitSetup() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;

        if (await _isExitDesired() && context.mounted) {
          _exitSetup();
        }
      },
      child: Scaffold(
        appBar: _buildFlowAppBar(),
        body: Navigator(
          key: _navigatorKey,
          initialRoute: widget.setupPageRoute,
          onGenerateRoute: _onGenerateRoute,
        ),
      ),
    );
  }

  Route<Widget> _onGenerateRoute(RouteSettings settings) {
    final page = switch (settings.name) {
      routeDeviceSetupStartPage => WaitingPage(
          message: 'Searching for nearby bulb...',
          onWaitComplete: _onDiscoveryComplete,
        ),
      routeDeviceSetupSelectDevicePage => SelectDevicePage(
          onDeviceSelected: _onDeviceSelected,
        ),
      routeDeviceSetupConnectingPage => WaitingPage(
          message: 'Connecting...',
          onWaitComplete: _onConnectionEstablished,
        ),
      routeDeviceSetupFinishedPage => FinishedPage(
          onFinishPressed: _exitSetup,
        ),
      _ => throw StateError('Unexpected route name: ${settings.name}!')
    };

    return MaterialPageRoute(
      builder: (context) {
        return page;
      },
      settings: settings,
    );
  }

  PreferredSizeWidget _buildFlowAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: _onExitPressed,
        icon: const Icon(Icons.chevron_left),
      ),
      title: const Text('Bulb Setup'),
    );
  }
}

class SelectDevicePage extends StatelessWidget {
  const SelectDevicePage({
    super.key,
    required this.onDeviceSelected,
  });

  final void Function(String deviceId) onDeviceSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select a nearby device:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateColor.resolveWith((states) {
                      return const Color(0xFF222222);
                    }),
                  ),
                  onPressed: () {
                    onDeviceSelected('22n483nk5834');
                  },
                  child: const Text(
                    'Bulb 22n483nk5834',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WaitingPage extends StatefulWidget {
  const WaitingPage({
    super.key,
    required this.message,
    required this.onWaitComplete,
  });

  final String message;
  final VoidCallback onWaitComplete;

  @override
  State<WaitingPage> createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage> {
  @override
  void initState() {
    super.initState();
    _startWaiting();
  }

  Future<void> _startWaiting() async {
    await Future<dynamic>.delayed(const Duration(seconds: 3));

    if (mounted) {
      widget.onWaitComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 32),
              Text(widget.message),
            ],
          ),
        ),
      ),
    );
  }
}

class FinishedPage extends StatelessWidget {
  const FinishedPage({
    super.key,
    required this.onFinishPressed,
  });

  final VoidCallback onFinishPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 250,
                height: 250,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF222222),
                ),
                child: const Center(
                  child: Icon(
                    Icons.lightbulb,
                    size: 175,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Bulb added!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ButtonStyle(
                  padding: WidgetStateProperty.resolveWith((states) {
                    return const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12);
                  }),
                  backgroundColor: WidgetStateColor.resolveWith((states) {
                    return const Color(0xFF222222);
                  }),
                  shape: WidgetStateProperty.resolveWith((states) {
                    return const StadiumBorder();
                  }),
                ),
                onPressed: onFinishPressed,
                child: const Text(
                  'Finish',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

@immutable
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 250,
                height: 250,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF222222),
                ),
                child: Center(
                  child: Icon(
                    Icons.lightbulb,
                    size: 175,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Add your first bulb',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(routeDeviceSetupStart);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Welcome'),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.pushNamed(context, routeSettings);
          },
        ),
      ],
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(8, (index) {
            return Container(
              width: double.infinity,
              height: 54,
              margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFF222222),
              ),
            );
          }),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Settings'),
    );
  }
}
```
