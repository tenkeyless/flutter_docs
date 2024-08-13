---
# title: Send data to a new screen
title: 새 화면으로 데이터 보내기
# description: How to pass data to a new route.
description: 새로운 경로로 데이터를 전달하는 방법.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/navigation/passing_data"?>

종종, 새 화면으로 이동할 뿐만 아니라, 화면에 데이터도 전달하고 싶을 수 있습니다. 
예를 들어, 탭한 아이템에 대한 정보를 전달하고 싶을 수 있습니다.

기억하세요: 화면은 위젯일 뿐입니다. 
이 예에서는, 할 일 리스트를 만듭니다. 
할 일을 탭하면, 할 일에 대한 정보를 표시하는 새 화면(위젯)으로 이동합니다. 
이 레시피는 다음 단계를 사용합니다.

1. 할 일 클래스를 정의합니다.
2. 할 일 리스트를 표시합니다.
3. 할 일에 대한 정보를 표시할 수 있는 세부 화면을 만듭니다.
4. 세부 화면으로 이동 및 데이터를 전달합니다.

## 1. Todo 클래스 정의 {:#1-define-a-todo-class}

먼저, todos를 표현하는 간단한 방법이 필요합니다. 
이 예에서는, title과 description이라는 두 가지 데이터를 포함하는 클래스를 만듭니다.

<?code-excerpt "lib/main.dart (Todo)"?>
```dart
class Todo {
  final String title;
  final String description;

  const Todo(this.title, this.description);
}
```

## 2. Todo 리스트 만들기 {:#2-create-a-list-of-todos}

두 번째로, Todo 리스트를 표시합니다. 
이 예에서는, 20개의 할 일을 생성하고, ListView를 사용하여 표시합니다. 
리스트로 작업하는 것에 대한 자세한 내용은 [리스트 사용][Use lists] 레시피를 참조하세요.

### Todo 리스트 생성 {:#generate-the-list-of-todos}

<?code-excerpt "lib/main.dart (Generate)" replace="/^todos:/final todos =/g/^\),$/);/g"?>
```dart
final todos = List.generate(
  20,
  (i) => Todo(
    'Todo $i',
    'A description of what needs to be done for Todo $i',
  ),
);
```

### ListView를 사용하여 TODO 리스트 표시 {:#display-the-list-of-todos-using-a-listview}

<?code-excerpt "lib/main_todoscreen.dart (ListViewBuilder)" replace="/^body: //g;/^\),$/)/g"?>
```dart
ListView.builder(
  itemCount: todos.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(todos[index].title),
    );
  },
)
```

지금까지는 잘 되었습니다. 
이것은 20개의 할 일을 생성하여 ListView에 표시합니다.

## 3. Todo 리스트를 표시하기 위한 Todo 화면 만들기 {:#3-create-a-todo-screen-to-display-the-list}

이를 위해 `StatelessWidget`을 만듭니다. 
`TodosScreen`이라고 합니다. 
이 페이지의 내용은 런타임 동안 변경되지 않으므로, 이 위젯의 ​​범위 내에서 Todo 리스트를 요구해야 합니다.

`ListView.builder`를 `build()`로 반환하는 위젯의 body로 전달합니다. 
이렇게 하면 리스트를 화면에 렌더링하여 시작할 수 있습니다!

<?code-excerpt "lib/main_todoscreen.dart (TodosScreen)"?>
```dart
class TodosScreen extends StatelessWidget {
  // Todo 리스트가 필요합니다.
  const TodosScreen({super.key, required this.todos});

  final List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
      ),
      // ListView.builder에 전달
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(todos[index].title),
          );
        },
      ),
    );
  }
}
```

Flutter의 기본 스타일을 사용하면, 나중에 하고 싶은 작업에 대해 걱정할 필요 없이 바로 시작할 수 있습니다!

## 4. Todo에 대한 정보를 표시하는 세부 정보 화면 만들기 {:#4-create-a-detail-screen-to-display-information-about-a-todo}

이제 두 번째 화면을 만듭니다. 화면의 제목에는 Todo의 제목이 포함되고, 화면의 본문에는 설명이 표시됩니다.

세부 정보 화면은 일반적인 `StatelessWidget`이므로, 사용자가 UI에 `Todo`을 입력하도록 요구합니다. 
그런 다음, 제공된 Todo를 사용하여 UI를 빌드합니다.

<?code-excerpt "lib/main.dart (detail)"?>
```dart
class DetailScreen extends StatelessWidget {
  // 생성자에서 Todo를 요구합니다.
  const DetailScreen({super.key, required this.todo});

  // Todo를 보관하는 필드를 선언합니다.
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    // Todo를 사용하여 UI를 만듭니다.
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(todo.description),
      ),
    );
  }
}
```

## 5. 세부 화면으로 이동 및 데이터를 전달 {:#5-navigate-and-pass-data-to-the-detail-screen}

`DetailScreen`이 있으면, 네비게이션을 수행할 준비가 됩니다. 
이 예에서는, 사용자가 리스트에서 Todo를 탭하면 `DetailScreen`으로 이동합니다. 
Todo를 `DetailScreen`에 전달합니다.

`TodosScreen`에서 사용자의 탭을 캡처하려면, `ListTile` 위젯에 대한 [`onTap()`][] 콜백을 작성합니다. 
`onTap()` 콜백 내에서, [`Navigator.push()`][] 메서드를 사용합니다.

<?code-excerpt "lib/main.dart (builder)"?>
```dart
body: ListView.builder(
  itemCount: todos.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(todos[index].title),
      // 사용자가 ListTile을 탭하면, DetailScreen으로 이동합니다. 
      // DetailScreen을 만드는 것뿐만 아니라, 현재 Todo를 전달한다는 점에 유의하세요.
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(todo: todos[index]),
          ),
        );
      },
    );
  },
),
```

### 대화형 예제 {:#interactive-example}

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter passing data hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

class Todo {
  final String title;
  final String description;

  const Todo(this.title, this.description);
}

void main() {
  runApp(
    MaterialApp(
      title: 'Passing Data',
      home: TodosScreen(
        todos: List.generate(
          20,
          (i) => Todo(
            'Todo $i',
            'A description of what needs to be done for Todo $i',
          ),
        ),
      ),
    ),
  );
}

class TodosScreen extends StatelessWidget {
  const TodosScreen({super.key, required this.todos});

  final List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(todos[index].title),
            // 사용자가 ListTile을 탭하면, DetailScreen으로 이동합니다. 
            // DetailScreen을 만드는 것뿐만 아니라, 현재 Todo를 전달한다는 점에 유의하세요.
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(todo: todos[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  // 생성자에서 Todo를 요구합니다.
  const DetailScreen({super.key, required this.todo});

  // Todo를 보관하는 필드를 선언합니다.
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    // Todo를 사용하여 UI를 만듭니다.
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(todo.description),
      ),
    );
  }
}
```

## 대안으로, RouteSettings를 사용하여 인수 전달하기 {:#alternatively-pass-the-arguments-using-routesettings}

처음 두 단계를 반복합니다.

### 인수를 추출하기 위한 세부 정보 화면 만들기 {:#create-a-detail-screen-to-extract-the-arguments}

다음으로, `Todo`에서 제목과 설명을 추출하여 표시하는 세부 정보 화면을 만듭니다. 
`Todo`에 액세스하려면, [`ModalRoute.of()`][] 메서드를 사용합니다. 이 메서드는 인수와 함께 현재 경로를 반환합니다.

<?code-excerpt "lib/main_routesettings.dart (DetailScreen)"?>
```dart
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todo = ModalRoute.of(context)!.settings.arguments as Todo;

    // Todo를 사용하여 UI를 만듭니다.
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(todo.description),
      ),
    );
  }
}
```

### 세부 화면으로 이동 및 데이터를 전달 {:#navigate-and-pass-the-arguments-to-the-detail-screen}

마지막으로, 사용자가 `Navigator.push()`를 사용하여 `ListTile` 위젯을 탭하면 `DetailScreen`으로 이동합니다. 
인수를 [`RouteSettings`][]의 일부로 전달합니다. `DetailScreen`은 이러한 인수를 추출합니다.

<?code-excerpt "lib/main_routesettings.dart (builder)" replace="/^body: //g;/^\),$/)/g"?>
```dart
ListView.builder(
  itemCount: todos.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(todos[index].title),
      // 사용자가 ListTile을 탭하면, DetailScreen으로 이동합니다. 
      // DetailScreen을 만드는 것뿐만 아니라, 현재 Todo를 전달한다는 점에 유의하세요.
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DetailScreen(),
            // RouteSettings의 일부로 인수를 전달합니다. 
            // DetailScreen은 이러한 설정에서 인수를 읽습니다.
            settings: RouteSettings(
              arguments: todos[index],
            ),
          ),
        );
      },
    );
  },
)
```

### 완성된 예제 {:#complete-example}

<?code-excerpt "lib/main_routesettings.dart"?>
```dart
import 'package:flutter/material.dart';

class Todo {
  final String title;
  final String description;

  const Todo(this.title, this.description);
}

void main() {
  runApp(
    MaterialApp(
      title: 'Passing Data',
      home: TodosScreen(
        todos: List.generate(
          20,
          (i) => Todo(
            'Todo $i',
            'A description of what needs to be done for Todo $i',
          ),
        ),
      ),
    ),
  );
}

class TodosScreen extends StatelessWidget {
  const TodosScreen({super.key, required this.todos});

  final List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(todos[index].title),
            // 사용자가 ListTile을 탭하면, DetailScreen으로 이동합니다. 
            // DetailScreen을 만드는 것뿐만 아니라, 현재 Todo를 전달한다는 점에 유의하세요.
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DetailScreen(),
                  // RouteSettings의 일부로 인수를 전달합니다. 
                  // DetailScreen은 이러한 설정에서 인수를 읽습니다.
                  settings: RouteSettings(
                    arguments: todos[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final todo = ModalRoute.of(context)!.settings.arguments as Todo;

    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(todo.description),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/passing-data.gif" alt="Passing Data Demo" class="site-mobile-screenshot" />
</noscript>


[`ModalRoute.of()`]: {{site.api}}/flutter/widgets/ModalRoute/of.html
[`Navigator.push()`]: {{site.api}}/flutter/widgets/Navigator/push.html
[`onTap()`]: {{site.api}}/flutter/material/ListTile/onTap.html
[`RouteSettings`]: {{site.api}}/flutter/widgets/RouteSettings-class.html
[Use lists]: /cookbook/lists/basic-list
