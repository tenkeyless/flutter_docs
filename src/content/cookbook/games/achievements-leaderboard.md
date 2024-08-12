---
# title: Add achievements and leaderboards to your mobile game
title: 모바일 게임에 업적과 리더보드 추가
# description: >
  # How to use the games_services plugin to add functionality to your game.
description: >
  games_services 플러그인을 사용하여 게임에 기능을 추가하는 방법.
---

<?code-excerpt path-base="cookbook/games/achievements_leaderboards"?>

게이머는 게임을 하는 데 다양한 동기를 가지고 있습니다. 대체로, 네 가지 주요 동기가 있습니다. 
[몰입, 성취, 협력, 경쟁][immersion, achievement, cooperation, and competition] 입니다. 
어떤 게임을 만들든 일부 플레이어는 게임에서 *성취(achieve)* 하고 싶어합니다. 
이는 트로피 획득이나 비밀 잠금 해제일 수 있습니다. 
일부 플레이어는 게임에서 *경쟁(compete)* 하고 싶어합니다. 
이는 고득점 달성이나 스피드런 달성일 수 있습니다. 
이 두 가지 아이디어는 *성취(achievements)* 와 *리더보드(leaderboards)* 의 개념에 해당합니다.

![A simple graphic representing the four types of motivation explained above](/assets/images/docs/cookbook/types-of-gamer-motivations.png){:.site-illustration}

App Store 및 Google Play와 같은 생태계는 업적 및 리더보드에 대한 중앙 집중식 서비스를 제공합니다. 
플레이어는 모든 게임의 업적을 한곳에서 볼 수 있으며, 
개발자는 모든 게임에 대해 업적을 다시 구현할 필요가 없습니다.

이 레시피는 [`games_services` 패키지][`games_services` package]를 사용하여 
모바일 게임에 업적과 리더보드 기능을 추가하는 방법을 보여줍니다.

[`games_services` package]: {{site.pub-pkg}}/games_services
[immersion, achievement, cooperation, and competition]: https://meditations.metavert.io/p/game-player-motivations

## 1. 플랫폼 서비스 활성화 {:#1-enable-platform-services}

To enable games services, set up *Game Center* on iOS and
*Google Play Games Services* on Android.

### iOS

To enable Game Center (GameKit) on iOS:

1.  Open your Flutter project in Xcode.
    Open `ios/Runner.xcworkspace`

2.  Select the root **Runner** project.

3.  Go to the **Signing & Capabilities** tab.

4.  Click the `+` button to add **Game Center** as a capability.

5.  Close Xcode.

6.  If you haven't already,
    register your game in [App Store Connect][]
    and from the **My App** section press the `+` icon.

    ![Screenshot of the + button in App Store Connect](/assets/images/docs/cookbook/app-store-add-app-button.png)

7.  Still in App Store Connect, look for the *Game Center* section. You
    can find it in **Services** as of this writing. On the **Game
    Center** page, you might want to set up a leaderboard and several
    achievements, depending on your game. Take note of the IDs of the
    leaderboards and achievements you create.

[App Store Connect]: https://appstoreconnect.apple.com/

### Android

To enable *Play Games Services* on Android:

1.  If you haven't already, go to [Google Play Console][]
    and register your game there.  
    
    ![Screenshot of the 'Create app' button in Google Play Console](/assets/images/docs/cookbook/google-play-create-app.png)

2.  Still in Google Play Console, select *Play Games Services* → *Setup
    and management* → *Configuration* from the navigation menu and
    follow their instructions.

      * This takes a significant amount of time and patience.
        Among other things, you'll need to set up an
        OAuth consent screen in Google Cloud Console.
        If at any point you feel lost, consult the
        official [Play Games Services guide][].    
         
        ![Screenshot showing the Games Services section in Google Play Console](/assets/images/docs/cookbook/play-console-play-games-services.png)

3.  When done, you can start adding leaderboards and achievements in
    **Play Games Services** → **Setup and management**. Create the exact
    same set as you did on the iOS side. Make note of IDs.

4.  Go to **Play Games Services → Setup and management → Publishing**.

5.  Click **Publish**. Don't worry, this doesn't actually publish your
    game. It only publishes the achievements and leaderboard. Once a
    leaderboard, for example, is published this way, it cannot be
    unpublished.

6.  Go to **Play Games Services** **→ Setup and management →
    Configuration → Credentials**.

7.  Find the **Get resources** button.
    It returns an XML file with the Play Games Services IDs.

    ```xml
    <!-- THIS IS JUST AN EXAMPLE -->
    <?xml version="1.0" encoding="utf-8"?>
    <resources>
        <!--app_id-->
        <string name="app_id" translatable="false">424242424242</string>
        <!--package_name-->
        <string name="package_name" translatable="false">dev.flutter.tictactoe</string>
        <!--achievement First win-->
        <string name="achievement_first_win" translatable="false">sOmEiDsTrInG</string>
        <!--leaderboard Highest Score-->
        <string name="leaderboard_highest_score" translatable="false">sOmEiDsTrInG</string>
    </resources>
    ```

8.  Add a file at `android/app/src/main/res/values/games-ids.xml`
    containing the XML you received in the previous step.

[Google Play Console]: https://play.google.com/console/
[Play Games Services guide]: {{site.developers}}/games/services/console/enabling

## 2. 게임 서비스에 로그인 {:#2-sign-in-to-the-game-service}

Now that you have set up *Game Center* and *Play Games Services*, and
have your achievement & leaderboard IDs ready, it's finally Dart time.

1.  Add a dependency on the [`games_services` package]({{site.pub-pkg}}/games_services).

    ```console
    $ flutter pub add games_services
    ```

2.  Before you can do anything else, you have to sign the player into
    the game service.

    <?code-excerpt "lib/various.dart (signIn)"?>
    ```dart
    try {
      await GamesServices.signIn();
    } on PlatformException catch (e) {
      // ... deal with failures ...
    }
    ```

The sign in happens in the background. It takes several seconds, so
don't call `signIn()` before `runApp()` or the players will be forced to
stare at a blank screen every time they start your game.

The API calls to the `games_services` API can fail for a multitude of
reasons. Therefore, every call should be wrapped in a try-catch block as
in the previous example. The rest of this recipe omits exception
handling for clarity.

:::tip
It's a good practice to create a controller. This would be a
`ChangeNotifier`, a bloc, or some other piece of logic that wraps around
the raw functionality of the `games_services` plugin.
:::


## 3. 업적 잠금 해제 {:#3-unlock-achievements}

1.  Register achievements in Google Play Console and App Store Connect,
    and take note of their IDs. Now you can award any of those
    achievements from your Dart code:

    <?code-excerpt "lib/various.dart (unlock)"?>
    ```dart
    await GamesServices.unlock(
      achievement: Achievement(
        androidID: 'your android id',
        iOSID: 'your ios id',
      ),
    );
    ```

    The player's account on Google Play Games or Apple Game Center now
    lists the achievement.

2.  To display the achievements UI from your game, call the
    `games_services` API:

    <?code-excerpt "lib/various.dart (showAchievements)"?>
    ```dart
    await GamesServices.showAchievements();
    ```

    This displays the platform achievements UI as an overlay on your game.

3.  To display the achievements in your own UI, use
    [`GamesServices.loadAchievements()`][].
    
[`GamesServices.loadAchievements()`]: {{site.pub-api}}/games_services/latest/games_services/GamesServices/loadAchievements.html

## 4. 스코어 제출 {:#4-submit-scores}

When the player finishes a play-through, your game can submit the result
of that play session into one or more leaderboards.

For example, a platformer game like Super Mario can submit both the
final score and the time taken to complete the level, to two separate
leaderboards.

1.  In the first step, you registered a leaderboard in Google Play
    Console and App Store Connect, and took note of its ID. Using this
    ID, you can submit new scores for the player:

    <?code-excerpt "lib/various.dart (submitScore)"?>
    ```dart
    await GamesServices.submitScore(
      score: Score(
        iOSLeaderboardID: 'some_id_from_app_store',
        androidLeaderboardID: 'sOmE_iD_fRoM_gPlAy',
        value: 100,
      ),
    );
    ```

    You don't need to check whether the new score is the player's
    highest. The platform game services handle that for you.

2.  To display the leaderboard as an overlay over your game, make the
    following call:

    <?code-excerpt "lib/various.dart (showLeaderboards)"?>
    ```dart
    await GamesServices.showLeaderboards(
      iOSLeaderboardID: 'some_id_from_app_store',
      androidLeaderboardID: 'sOmE_iD_fRoM_gPlAy',
    );
    ```

3.  If you want to display the leaderboard scores in your own UI, you
    can fetch them with [`GamesServices.loadLeaderboardScores()`][].
    
[`GamesServices.loadLeaderboardScores()`]: {{site.pub-api}}/games_services/latest/games_services/GamesServices/loadLeaderboardScores.html

## 5. 다음 스텝 {:#5-next-steps}

There's more to the `games_services` plugin. With this plugin, you can:

- Get the player's icon, name or unique ID
- Save and load game states
- Sign out of the game service

Some achievements can be incremental. For example: "You have collected
all 10 pieces of the McGuffin."

Each game has different needs from game services.

To start, you might want to create this controller 
in order to keep all achievements & leaderboards logic in one place:

<?code-excerpt "lib/games_services_controller.dart"?>
```dart
import 'dart:async';

import 'package:games_services/games_services.dart';
import 'package:logging/logging.dart';

/// Allows awarding achievements and leaderboard scores,
/// and also showing the platforms' UI overlays for achievements
/// and leaderboards.
///
/// A facade of `package:games_services`.
class GamesServicesController {
  static final Logger _log = Logger('GamesServicesController');

  final Completer<bool> _signedInCompleter = Completer();

  Future<bool> get signedIn => _signedInCompleter.future;

  /// Unlocks an achievement on Game Center / Play Games.
  ///
  /// You must provide the achievement ids via the [iOS] and [android]
  /// parameters.
  ///
  /// Does nothing when the game isn't signed into the underlying
  /// games service.
  Future<void> awardAchievement(
      {required String iOS, required String android}) async {
    if (!await signedIn) {
      _log.warning('Trying to award achievement when not logged in.');
      return;
    }

    try {
      await GamesServices.unlock(
        achievement: Achievement(
          androidID: android,
          iOSID: iOS,
        ),
      );
    } catch (e) {
      _log.severe('Cannot award achievement: $e');
    }
  }

  /// Signs into the underlying games service.
  Future<void> initialize() async {
    try {
      await GamesServices.signIn();
      // The API is unclear so we're checking to be sure. The above call
      // returns a String, not a boolean, and there's no documentation
      // as to whether every non-error result means we're safely signed in.
      final signedIn = await GamesServices.isSignedIn;
      _signedInCompleter.complete(signedIn);
    } catch (e) {
      _log.severe('Cannot log into GamesServices: $e');
      _signedInCompleter.complete(false);
    }
  }

  /// Launches the platform's UI overlay with achievements.
  Future<void> showAchievements() async {
    if (!await signedIn) {
      _log.severe('Trying to show achievements when not logged in.');
      return;
    }

    try {
      await GamesServices.showAchievements();
    } catch (e) {
      _log.severe('Cannot show achievements: $e');
    }
  }

  /// Launches the platform's UI overlay with leaderboard(s).
  Future<void> showLeaderboard() async {
    if (!await signedIn) {
      _log.severe('Trying to show leaderboard when not logged in.');
      return;
    }

    try {
      await GamesServices.showLeaderboards(
        // TODO: When ready, change both these leaderboard IDs.
        iOSLeaderboardID: 'some_id_from_app_store',
        androidLeaderboardID: 'sOmE_iD_fRoM_gPlAy',
      );
    } catch (e) {
      _log.severe('Cannot show leaderboard: $e');
    }
  }

  /// Submits [score] to the leaderboard.
  Future<void> submitLeaderboardScore(int score) async {
    if (!await signedIn) {
      _log.warning('Trying to submit leaderboard when not logged in.');
      return;
    }

    _log.info('Submitting $score to leaderboard.');

    try {
      await GamesServices.submitScore(
        score: Score(
          // TODO: When ready, change these leaderboard IDs.
          iOSLeaderboardID: 'some_id_from_app_store',
          androidLeaderboardID: 'sOmE_iD_fRoM_gPlAy',
          value: score,
        ),
      );
    } catch (e) {
      _log.severe('Cannot submit leaderboard score: $e');
    }
  }
}
```

## 더 많은 정보 {:#more-information}

The Flutter Casual Games Toolkit includes the following templates:

* [basic][]: basic starter game
* [card][]: starter card game
* [endless runner][]: starter game (using Flame)
  where the player endlessly runs, avoiding pitfalls
  and gaining rewards

[basic]: {{site.github}}/flutter/games/tree/main/templates/basic#readme
[card]: {{site.github}}/flutter/games/tree/main/templates/card#readme
[endless runner]: {{site.github}}/flutter/games/tree/main/templates/endless_runner#readme
