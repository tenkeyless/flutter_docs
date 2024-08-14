---
# title: Add multiplayer support using Firestore
title: Firestore를 통해 멀티플레이어 지원 추가
# description: >
#   How to use use Firebase Cloud Firestore to implement multiplayer
#   in your game.
description: >
  Firebase Cloud Firestore를 사용하여 게임에서 멀티플레이어를 구현하는 방법입니다.
---

<?code-excerpt path-base="cookbook/games/firestore_multiplayer"?>

멀티플레이어 게임은 플레이어 간에 게임 상태를 동기화하는 방법이 필요합니다. 대체로, 두 가지 타입의 멀티플레이어 게임이 있습니다.

1. **높은 틱 비율**.
  이러한 게임은 낮은 지연 시간으로 초당 여러 번 게임 상태를 동기화해야 합니다. 
  여기에는 액션 게임, 스포츠 게임, 격투 게임이 포함됩니다.

2. **낮은 틱 비율**.
  이러한 게임은 지연 시간이 덜한 가끔만 게임 상태를 동기화하면 됩니다. 
  여기에는 카드 게임, 전략 게임, 퍼즐 게임이 포함됩니다.

이는 실시간 게임과 턴 기반 게임의 차이점과 비슷하지만 비유가 부족합니다. 
예를 들어, 실시간 전략 게임은 이름에서 알 수 있듯이 실시간으로 실행되지만, 높은 틱 비율과 관련이 없습니다. 
이러한 게임은 로컬 컴퓨터에서 플레이어 상호 작용 사이에 발생하는 대부분의 상황을 시뮬레이션할 수 있습니다. 
따라서, 게임 상태를 그렇게 자주 동기화할 필요가 없습니다.

![An illustration of two mobile phones and a two-way arrow between them](/assets/images/docs/cookbook/multiplayer-two-mobiles.jpg){:.site-illustration}

개발자로서 낮은 틱 비율을 선택할 수 있다면, 그렇게 해야 합니다. 낮은 틱 비율은 지연 요구 사항과 서버 비용을 낮춥니다. 
때때로, 게임에서 높은 틱 비율의 동기화가 필요합니다. 이런 경우, Firestore와 같은 솔루션은 *적합하지 않습니다*. 
[Nakama][]와 같은 전용 멀티플레이어 서버 솔루션을 선택하세요. Nakama에는 [Dart 패키지][Dart package]가 있습니다.

게임에서 낮은 틱 비율의 동기화가 필요할 것으로 예상되면, 계속 읽어보세요.

이 레시피는 [`cloud_firestore` 패키지][`cloud_firestore` package]를 사용하여 게임에서 멀티플레이어 기능을 구현하는 방법을 보여줍니다. 
이 레시피에는 서버가 필요하지 않습니다. 
Cloud Firestore를 사용하여 게임 상태를 공유하는 두 개 이상의 클라이언트를 사용합니다.

[`cloud_firestore` package]: {{site.pub-pkg}}/cloud_firestore
[Dart package]: {{site.pub-pkg}}/nakama
[Nakama]: https://heroiclabs.com/nakama/

## 1. 멀티플레이어를 위한 게임 준비 {:#1-prepare-your-game-for-multiplayer}

로컬 이벤트와 원격 이벤트에 대한 응답으로 게임 상태를 변경할 수 있도록 게임 코드를 작성하세요. 
로컬 이벤트는 플레이어 액션이나 게임 로직일 수 있습니다. 
원격 이벤트는 서버에서 오는 월드 업데이트일 수 있습니다.

![Screenshot of the card game](/assets/images/docs/cookbook/multiplayer-card-game.jpg){:.site-mobile-screenshot .site-illustration}

이 쿡북 레시피를 간소화하려면, [`flutter/games` 저장소][`flutter/games` repository]에서 찾을 수 있는 [`card`][] 템플릿으로 시작하세요. 
다음 명령을 실행하여 해당 저장소를 복제하세요.

```console
git clone https://github.com/flutter/games.git
```

{% comment %}
  If/when we have a "sample_extractor" tool, or any other easier way
  to get the code, mention that here.
{% endcomment %}

`templates/card`에서 프로젝트를 엽니다.

:::note
이 단계를 무시하고 자신의 게임 프로젝트로 레시피를 따를 수 있습니다. 
적절한 위치에 코드를 조정하세요.
:::

[`card`]: {{site.github}}/flutter/games/tree/main/templates/card#readme
[`flutter/games` repository]: {{site.github}}/flutter/games

## 2. Firestore 설치 {:#2-install-firestore}

[Cloud Firestore][]는 클라우드에서 수평 확장이 가능한, NoSQL 문서 데이터베이스입니다. 
내장된 라이브 동기화가 포함되어 있습니다. 이는 우리의 요구에 완벽합니다. 
클라우드 데이터베이스에서 게임 상태를 최신 상태로 유지하므로, 모든 플레이어가 동일한 상태를 볼 수 있습니다.

Cloud Firestore에 대한 15분 분량의 빠른 입문서를 원하시면, 다음 비디오를 확인하세요.

{% ytEmbed 'v_hR4K4auoQ', 'NoSQL 데이터베이스란? Cloud Firestore에 대해 알아보기' %}

Flutter 프로젝트에 Firestore를 추가하려면, [Cloud Firestore 시작하기][Get started with Cloud Firestore] 가이드의 처음 두 단계를 따르세요.

* [Cloud Firestore 데이터베이스 만들기][Create a Cloud Firestore database]
* [개발 환경 설정][Set up your development environment]

원하는 결과는 다음과 같습니다.

* **Test mode**에서, 클라우드에 준비된 Firestore 데이터베이스
* 생성된 `firebase_options.dart` 파일
* `pubspec.yaml`에 추가된 적절한 플러그인

이 단계에서는 Dart 코드를 작성할 필요가 *없습니다*. 
해당 가이드에서 Dart 코드 작성 단계를 이해하자마자, 이 레시피로 돌아오세요.

{% comment %}
  Revisit to see if we can inline the steps here:
  <https://firebase.google.com/docs/flutter/setup>
  ... followed by the first 2 steps here:
  <https://firebase.google.com/docs/firestore/quickstart>
{% endcomment %}

[Cloud Firestore]: https://cloud.google.com/firestore/
[Create a Cloud Firestore database]: {{site.firebase}}/docs/firestore/quickstart#create
[Get started with Cloud Firestore]: {{site.firebase}}/docs/firestore/quickstart
[Set up your development environment]: {{site.firebase}}/docs/firestore/quickstart#set_up_your_development_environment

## 3. Firestore 초기화 {:#3-initialize-firestore}

1. `lib/main.dart`를 열고 플러그인을 import 하고, 
   이전 단계에서 `flutterfire configure`를 통해 생성된, `firebase_options.dart` 파일도 가져옵니다.

    <?code-excerpt "lib/main.dart (imports)"?>
    ```dart
    import 'package:cloud_firestore/cloud_firestore.dart';
    import 'package:firebase_core/firebase_core.dart';
    
    import 'firebase_options.dart';
    ```

2. `lib/main.dart`에서 `runApp()` 호출 바로 위에 다음 코드를 추가합니다.

    <?code-excerpt "lib/main.dart (initializeApp)"?>
    ```dart
    WidgetsFlutterBinding.ensureInitialized();
    
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    ```

    이렇게 하면 게임 시작 시 Firebase가 초기화됩니다.

3. 앱에 Firestore 인스턴스를 추가합니다. 이렇게 하면, 모든 위젯이 이 인스턴스에 액세스할 수 있습니다. 
   위젯은, 필요한 경우, 인스턴스 누락에 반응할 수도 있습니다.

   `card` 템플릿으로 이를 수행하려면, `provider` 패키지(이미 종속성으로 설치되어 있음)를 사용할 수 있습니다.

   보일러플레이트 `runApp(MyApp())`를 다음으로 바꿉니다.

    <?code-excerpt "lib/main.dart (runApp)"?>
    ```dart
    runApp(
      Provider.value(
        value: FirebaseFirestore.instance,
        child: MyApp(),
      ),
    );
    ```

    provider를 `MyApp` 안에 두지 말고, 위에 두세요. 
    이렇게 하면 Firebase 없이도 앱을 테스트할 수 있습니다.

    :::note
    `card` 템플릿을 사용하지 *않는* 경우, [`provider` 패키지를 설치][install the `provider` package]하거나
    코드베이스의 다양한 부분에서 `FirebaseFirestore` 인스턴스에 액세스하는 고유한 메서드를 사용해야 합니다.
    :::

[install the `provider` package]: {{site.pub-pkg}}/provider/install

## 4. Firestore 컨트롤러 클래스 생성 {:#4-create-a-firestore-controller-class}

Firestore에 직접 통신할 수는 있지만, 
코드를 더 읽기 쉽고 유지 관리하기 쉽게 만들기 위해 전용 컨트롤러 클래스를 작성해야 합니다.

컨트롤러를 구현하는 방법은 게임과 멀티플레이어 경험의 정확한 디자인에 따라 달라집니다. 
`card` 템플릿의 경우, 두 개의 원형 플레이 영역의 내용을 동기화할 수 있습니다. 
완전한 멀티플레이어 경험에는 충분하지 않지만, 좋은 시작입니다.

![Screenshot of the card game, with arrows pointing to playing areas](/assets/images/docs/cookbook/multiplayer-areas.jpg){:.site-mobile-screenshot .site-illustration}

컨트롤러를 만들려면, 다음 코드를 복사하여, `lib/multiplayer/firestore_controller.dart`라는 새 파일에 붙여넣습니다.

<?code-excerpt "lib/multiplayer/firestore_controller.dart"?>
```dart
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../game_internals/board_state.dart';
import '../game_internals/playing_area.dart';
import '../game_internals/playing_card.dart';

class FirestoreController {
  static final _log = Logger('FirestoreController');

  final FirebaseFirestore instance;

  final BoardState boardState;

  /// 지금은 매치가 하나뿐입니다. 
  /// 하지만 매치메이킹을 준비하려면, matches라는 Firestore 컬렉션에 넣으세요.
  late final _matchRef = instance.collection('matches').doc('match_1');

  late final _areaOneRef = _matchRef
      .collection('areas')
      .doc('area_one')
      .withConverter<List<PlayingCard>>(
          fromFirestore: _cardsFromFirestore, toFirestore: _cardsToFirestore);

  late final _areaTwoRef = _matchRef
      .collection('areas')
      .doc('area_two')
      .withConverter<List<PlayingCard>>(
          fromFirestore: _cardsFromFirestore, toFirestore: _cardsToFirestore);

  StreamSubscription? _areaOneFirestoreSubscription;
  StreamSubscription? _areaTwoFirestoreSubscription;

  StreamSubscription? _areaOneLocalSubscription;
  StreamSubscription? _areaTwoLocalSubscription;

  FirestoreController({required this.instance, required this.boardState}) {
    // 원격 변경 사항을 구독합니다. (Firestore에서)
    _areaOneFirestoreSubscription = _areaOneRef.snapshots().listen((snapshot) {
      _updateLocalFromFirestore(boardState.areaOne, snapshot);
    });
    _areaTwoFirestoreSubscription = _areaTwoRef.snapshots().listen((snapshot) {
      _updateLocalFromFirestore(boardState.areaTwo, snapshot);
    });

    // 게임 상태의 로컬 변경 사항을 구독합니다.
    _areaOneLocalSubscription = boardState.areaOne.playerChanges.listen((_) {
      _updateFirestoreFromLocalAreaOne();
    });
    _areaTwoLocalSubscription = boardState.areaTwo.playerChanges.listen((_) {
      _updateFirestoreFromLocalAreaTwo();
    });

    _log.fine('Initialized');
  }

  void dispose() {
    _areaOneFirestoreSubscription?.cancel();
    _areaTwoFirestoreSubscription?.cancel();
    _areaOneLocalSubscription?.cancel();
    _areaTwoLocalSubscription?.cancel();

    _log.fine('Disposed');
  }

  /// Firestore에서 나오는 raw JSON 스냅샷을 가져와 [PlayingCard] 리스트로 변환하려고 시도합니다.
  List<PlayingCard> _cardsFromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()?['cards'] as List?;

    if (data == null) {
      _log.info('No data found on Firestore, returning empty list');
      return [];
    }

    final list = List.castFrom<Object?, Map<String, Object?>>(data);

    try {
      return list.map((raw) => PlayingCard.fromJson(raw)).toList();
    } catch (e) {
      throw FirebaseControllerException(
          'Failed to parse data from Firestore: $e');
    }
  }

  // [PlayingCard] 리스트를 가져와 Firestore에 저장할 수 있는 JSON 객체로 변환합니다.
  Map<String, Object?> _cardsToFirestore(
    List<PlayingCard> cards,
    SetOptions? options,
  ) {
    return {'cards': cards.map((c) => c.toJson()).toList()};
  }

  /// [area]의 로컬 상태로 Firestore를 업데이트합니다.
  Future<void> _updateFirestoreFromLocal(
      PlayingArea area, DocumentReference<List<PlayingCard>> ref) async {
    try {
      _log.fine('Updating Firestore with local data (${area.cards}) ...');
      await ref.set(area.cards);
      _log.fine('... done updating.');
    } catch (e) {
      throw FirebaseControllerException(
          'Failed to update Firestore with local data (${area.cards}): $e');
    }
  }

  /// `boardState.areaOne`의 로컬 상태를 Firestore로 전송합니다.
  void _updateFirestoreFromLocalAreaOne() {
    _updateFirestoreFromLocal(boardState.areaOne, _areaOneRef);
  }

  /// `boardState.areaTwo`의 로컬 상태를 Firestore로 전송합니다.
  void _updateFirestoreFromLocalAreaTwo() {
    _updateFirestoreFromLocal(boardState.areaTwo, _areaTwoRef);
  }

  /// Firestore의 데이터로 [area]의 로컬 상태를 업데이트합니다.
  void _updateLocalFromFirestore(
      PlayingArea area, DocumentSnapshot<List<PlayingCard>> snapshot) {
    _log.fine('Received new data from Firestore (${snapshot.data()})');

    final cards = snapshot.data() ?? [];

    if (listEquals(cards, area.cards)) {
      _log.fine('No change');
    } else {
      _log.fine('Updating local data with Firestore data ($cards)');
      area.replaceWith(cards);
    }
  }
}

class FirebaseControllerException implements Exception {
  final String message;

  FirebaseControllerException(this.message);

  @override
  String toString() => 'FirebaseControllerException: $message';
}
```

이 코드의 다음 기능에 주목하세요.

* 컨트롤러의 생성자는 `BoardState`를 취합니다. 
  이를 통해 컨트롤러는 게임의 로컬 상태를 조작할 수 있습니다.

* 컨트롤러는 
  Firestore를 업데이트하기 위한 로컬 변경 사항과 
  로컬 상태 및 UI를 업데이트하기 위한 원격 변경 사항을 
  모두 구독합니다.

* 필드 `_areaOneRef`와 `_areaTwoRef`는 Firebase 문서 참조입니다. 
  각 영역의 데이터가 있는 위치와 
  로컬 Dart 객체(`List<PlayingCard>`)와 원격 JSON 객체(`Map<String, dynamic>`) 간에 변환하는 방법을 설명합니다.
  Firestore API를 사용하면 `.snapshots()`를 사용하여 이러한 참조를 구독하고, `.set()`를 사용하여 이에 쓸 수 있습니다.

## 5. Firestore 컨트롤러 사용 {:#5-use-the-firestore-controller}

1. 플레이 세션을 시작하는 데 책임이 있는 파일을 엽니다. 
   `card` 템플릿의 경우, `lib/play_session/play_session_screen.dart`. 
   이 파일에서 Firestore 컨트롤러를 인스턴스화합니다.

2. Firebase와 컨트롤러를 import 합니다.

    <?code-excerpt "lib/play_session/play_session_screen.dart (imports)"?>
    ```dart
    import 'package:cloud_firestore/cloud_firestore.dart';
    import '../multiplayer/firestore_controller.dart';
    ```

3. `_PlaySessionScreenState` 클래스에 컨트롤러 인스턴스를 포함하기 위해 null 허용 필드를 추가합니다.

    <?code-excerpt "lib/play_session/play_session_screen.dart (controller)"?>
    ```dart
    FirestoreController? _firestoreController;
    ```

4. 같은 클래스의 `initState()` 메서드에서, FirebaseFirestore 인스턴스를 읽는 것을 시도하고, 
   성공하면, 컨트롤러를 구성하는 코드를 추가합니다. 
   `FirebaseFirestore` 인스턴스를 *Initialize Firestore* 단계에서 `main.dart`에 추가했습니다.

    <?code-excerpt "lib/play_session/play_session_screen.dart (init-state)"?>
    ```dart
    final firestore = context.read<FirebaseFirestore?>();
    if (firestore == null) {
      _log.warning("Firestore instance wasn't provided. "
          'Running without _firestoreController.');
    } else {
      _firestoreController = FirestoreController(
        instance: firestore,
        boardState: _boardState,
      );
    }
    ```

5. 같은 클래스의 `dispose()` 메서드를 사용하여 컨트롤러를 삭제합니다.

    <?code-excerpt "lib/play_session/play_session_screen.dart (dispose)"?>
    ```dart
    _firestoreController?.dispose();
    ```

## 6. 게임 테스트 {:#6-test-the-game}

1. 두 개의 별도 기기에서 게임을 실행하거나, 같은 기기에서 두 개의 다른 창에서 실행합니다.

2. 한 기기의 영역에 카드를 추가하면, 다른 기기에 어떻게 나타나는지 확인합니다.

    {% comment %}
      TBA: GIF of multiplayer working
    {% endcomment %}

3. [Firebase 웹 콘솔][Firebase web console]을 열고, 프로젝트의 Firestore 데이터베이스로 이동합니다.

4. 실시간으로 데이터가 업데이트되는 방식을 확인합니다. 
   심지어 콘솔에서 데이터를 편집하여 실행 중인 모든 클라이언트가 업데이트되는 것을 볼 수도 있습니다.

    ![Screenshot of the Firebase Firestore data view](/assets/images/docs/cookbook/multiplayer-firebase-data.png)

[Firebase web console]: https://console.firebase.google.com/

### 문제 해결 {:#troubleshooting}

Firebase 통합을 테스트할 때 발생할 수 있는 가장 일반적인 문제는 다음과 같습니다.

* **Firebase에 접속하려고 하면 게임이 충돌합니다.**
  * Firebase 통합이 제대로 설정되지 않았습니다. 
  * *2단계*를 다시 살펴보고, 해당 단계의 일부로 `flutterfire configure`를 실행해야 합니다.

* **macOS에서 게임이 Firebase와 통신하지 않습니다.**
  * 디폴트로, macOS 앱은 인터넷에 액세스할 수 없습니다. 
  * 먼저 [인터넷 자격(entitlement)][internet entitlement]을 활성화하세요.

[internet entitlement]: /data-and-backend/networking#macos

## 7. 다음 스텝 {:#7-next-steps}

이 시점에서, 게임은 클라이언트 간에 거의 즉각적이고 신뢰할 수 있는 상태 동기화를 제공합니다. 
실제 게임 규칙이 없습니다. 언제 어떤 카드를 플레이할 수 있고, 어떤 결과가 나올지 알 수 없습니다. 
이는 게임 자체에 따라 달라지며 시도는 사용자에게 달려 있습니다.

![An illustration of two mobile phones and a two-way arrow between them](/assets/images/docs/cookbook/multiplayer-two-mobiles.jpg){:.site-illustration}

이 시점에서, 매치의 공유 상태에는 두 개의 플레이 영역과 그 안에 있는 카드만 포함됩니다. 
플레이어가 누구인지, 누구의 차례인지와 같은 다른 데이터도 `_matchRef`에 저장할 수 있습니다. 
어디서부터 시작해야 할지 잘 모르겠다면, 
[Firestore 코드랩 하나나 둘][a Firestore codelab or two]을 따라 API에 익숙해지세요.

처음에는, 동료 및 친구와 함께 멀티플레이어 게임을 테스트하기에 단일 매치로 충분할 것입니다. 
출시일이 다가오면, 인증 및 매치메이킹에 대해 생각해보세요. 
다행히도, Firebase는 [사용자를 인증하는 빌트인 방식][built-in way to authenticate users]을 제공하고, 
Firestore 데이터베이스 구조는 여러 매치를 처리할 수 있습니다. 
단일 `match_1` 대신, 필요한 만큼 많은 레코드로 matches 컬렉션을 채울 수 있습니다.

![Screenshot of the Firebase Firestore data view with additional matches](/assets/images/docs/cookbook/multiplayer-firebase-match.png)

온라인 매치는 첫 번째 플레이어만 있는 "대기" 상태에서 시작할 수 있습니다. 
다른 플레이어는 일종의 로비에서 "대기" 매치를 볼 수 있습니다. 
충분한 플레이어가 매치에 참여하면, "활성화"됩니다. 
다시 말하지만, 정확한 구현은 원하는 온라인 경험의 종류에 따라 달라집니다. 
기본은 동일합니다. 각각 활성 또는 잠재적 매치를 나타내는 방대한 문서 모음입니다.

[a Firestore codelab or two]: {{site.codelabs}}/?product=flutter&text=firestore
[built-in way to authenticate users]: {{site.firebase}}/docs/auth/flutter/start
