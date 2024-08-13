---
# title: Communicate with WebSockets
title: WebSockets으로 통신하기
# description: How to connect to a web socket.
description: 웹 소켓에 연결하는 방법.
---

<?code-excerpt path-base="cookbook/networking/web_sockets/"?>

일반적인 HTTP 요청 외에도, `WebSockets`를 사용하여 서버에 연결할 수 있습니다. 
`WebSockets`를 사용하면, 폴링 없이 서버와 양방향 통신이 가능합니다.

이 예에서는 [Lob.com이 후원하는 테스트 WebSocket 서버][test WebSocket server sponsored by Lob.com]에 연결합니다. 
서버는 사용자가 보낸 것과 동일한 메시지를 다시 보냅니다. 이 레시피는 다음 단계를 사용합니다.

  1. WebSocket 서버에 연결합니다.
  2. 서버에서 메시지를 수신합니다.
  3. 서버에 데이터를 보냅니다.
  4. WebSocket 연결을 닫습니다.

## 1. WebSocket 서버에 연결 {:#1-connect-to-a-websocket-server}

[`web_socket_channel`][] 패키지는 WebSocket 서버에 연결하는 데 필요한 도구를 제공합니다.

이 패키지는 서버에서 메시지를 수신하고 서버에 메시지를 푸시할 수 있는 `WebSocketChannel`을 제공합니다.

Flutter에서는, 다음 라인을 사용하여 서버에 연결하는 `WebSocketChannel`을 만듭니다.

<?code-excerpt "lib/main.dart (connect)" replace="/_channel/channel/g"?>
```dart
final channel = WebSocketChannel.connect(
  Uri.parse('wss://echo.websocket.events'),
);
```

## 2. 서버에서 메시지 수신 {:#2-listen-for-messages-from-the-server}

이제 연결을 설정했으니, 서버에서 메시지를 수신하세요.

테스트 서버에 메시지를 보낸 후, 동일한 메시지가 다시 돌아옵니다. ([테스트 서버][test WebSocket server sponsored by Lob.com]의 설정에 따라)

이 예에서는, [`StreamBuilder`][] 위젯을 사용하여 새 메시지를 수신하고, [`Text`][] 위젯을 사용하여 메시지를 표시합니다.

<?code-excerpt "lib/main.dart (StreamBuilder)" replace="/_channel/channel/g"?>
```dart
StreamBuilder(
  stream: channel.stream,
  builder: (context, snapshot) {
    return Text(snapshot.hasData ? '${snapshot.data}' : '');
  },
)
```

### 이것이 작동하는 방식 {:#how-this-works}

`WebSocketChannel`은 서버에서 온 메시지의 [`Stream`][]을 제공합니다.

`Stream` 클래스는 `dart:async` 패키지의 기본적인 파트입니다. 
데이터 소스에서 async 이벤트를 수신하는 방법을 제공합니다. 
단일 async 응답을 반환하는 `Future`와 달리, `Stream` 클래스는 시간이 지남에 따라 여러 이벤트를 전달할 수 있습니다.

[`StreamBuilder`][] 위젯은 `Stream`에 연결하고, 
주어진 `builder()` 함수를 사용하여 이벤트를 수신할 때마다 Flutter에 다시 빌드하도록 요청합니다.

## 3. 서버에 데이터 송신 {:#3-send-data-to-the-server}

서버로 데이터를 전송하려면, `WebSocketChannel`에서 제공하는 `sink`에 `add()` 메시지를 추가합니다.

<?code-excerpt "lib/main.dart (add)" replace="/_channel/channel/g;/_controller.text/'Hello!'/g"?>
```dart
channel.sink.add('Hello!');
```

### 이것이 작동하는 방식 {:#how-this-works-1}

`WebSocketChannel`은 메시지를 서버로 푸시하기 위한 [`StreamSink`][]를 제공합니다.

`StreamSink` 클래스는 데이터 소스에 sync 또는 async 이벤트를 추가하는 일반적인 방법을 제공합니다.

## 4. WebSocket 연결 닫기 {:#4-close-the-websocket-connection}

WebSocket 사용이 끝나면, 연결을 닫습니다.

<?code-excerpt "lib/main.dart (close)" replace="/_channel/channel/g"?>
```dart
channel.sink.close();
```

## 완성된 예제 {:#complete-example}

<?code-excerpt "lib/main.dart"?>
```dart
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'WebSocket Demo';
    return const MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final _channel = WebSocketChannel.connect(
    Uri.parse('wss://echo.websocket.events'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),
            const SizedBox(height: 24),
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                return Text(snapshot.hasData ? '${snapshot.data}' : '');
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ), // 이 마지막 쉼표는 빌드 메서드에 대한 자동 서식을 더욱 좋게 만들어줍니다.
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text);
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }
}
```
![Web sockets demo](/assets/images/docs/cookbook/web-sockets.gif){:.site-mobile-screenshot}


[`Stream`]: {{site.api}}/flutter/dart-async/Stream-class.html
[`StreamBuilder`]: {{site.api}}/flutter/widgets/StreamBuilder-class.html
[`StreamSink`]: {{site.api}}/flutter/dart-async/StreamSink-class.html
[test WebSocket server sponsored by Lob.com]: https://www.lob.com/blog/websocket-org-is-down-here-is-an-alternative
[`Text`]: {{site.api}}/flutter/widgets/Text-class.html
[`web_socket_channel`]: {{site.pub-pkg}}/web_socket_channel
