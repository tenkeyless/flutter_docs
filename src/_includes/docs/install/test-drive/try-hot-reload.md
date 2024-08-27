앱 빌드가 완료되면, 기기에 앱이 표시됩니다.

{% render docs/app-figure.md, img-class:"site-mobile-screenshot border", image:"get-started/macos/starter-app.png", caption:"Starter app on macOS" %}

## 핫 리로드를 시도하세요 (Try hot reload)

Flutter는 _Stateful Hot Reload_ 를 통해 빠른 개발 주기를 제공합니다. 
이는 앱 상태를 다시 시작하거나 잃지 않고도 라이브로 실행되는 앱의 코드를 다시 로드할 수 있는 기능입니다.

앱 소스 코드를 변경하고, {{include.ide}}에서 핫 리로드 명령을 실행하고, 대상 기기에서 변경 사항을 확인할 수 있습니다.

1. `lib/main.dart`를 엽니다.

2. 다음 문자열에서 `pushed`라는 단어를 `clicked`로 변경합니다.
   이 글을 쓰는 시점에서는 `main.dart` 파일의 109번째 줄에 있습니다.

   |                   **원본**                    |                      **새로운 내용**                       |
   |:-------------------------------------------------:|:--------------------------------------------------:|
   | `'You have pushed the button this many times:' ,` | `'You have clicked the button this many times:' ,` |
   
   {:.table .table-striped}

   :::important
   _앱을 중단하지 마세요._ 앱을 실행하세요.
   :::

3. 변경 사항을 저장합니다. {{include.save_changes}}

당신의 앱에서 문자열 업데이트가 실시간으로 보여집니다.

{% render docs/app-figure.md, img-class:"site-mobile-screenshot border", image:"get-started/macos/starter-app-hot-reload.png", caption:"핫 리로드 후 Starter 앱" %}
