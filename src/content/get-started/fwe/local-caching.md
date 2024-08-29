---
# title: Local caching
title: 로컬 캐싱
# description: Learn how to persist data locally.
description: 데이터를 로컬에 저장하는 방법을 알아보세요.
prev:
  # title: Networking and data
  title: 네트워킹 및 데이터
  path: /get-started/fwe/networking
next:
  # title: Learn more
  title: 더 알아보기
  path: /get-started/learn-more
---

이제 네트워크를 통해 서버에서 데이터를 로드하는 방법을 알게 되었으니, Flutter 앱이 더욱 생동감 있게 느껴질 것입니다. 
그러나, 원격 서버에서 데이터를 *로드할 수* 있다고 해서, 항상 *로드해야만* 한다는 것은 아닙니다. 
때로는, 이전 네트워크 요청에서 받은 데이터를 다시 렌더링하는 것이, 
반복해서 완료될 때까지 사용자를 기다리게 하는 것보다 낫습니다. 
나중에 다시 표시하기 위해 애플리케이션 데이터를 보관하는 이 기술을 *캐싱*이라고 하며, 
이 페이지에서는 Flutter 앱에서 이 작업에 접근하는 방법을 다룹니다.

## 캐싱 소개 {:#introduction-to-caching}

가장 기본적으로, 모든 캐싱 전략은 다음의 pseudocode로 표현된 동일한 3단계 작업으로 구성됩니다.

```dart
Data? _cachedData;

Future<Data> get data async {
    // 1단계: 캐시에 원하는 데이터가 이미 포함되어 있는지 확인하세요.
    if (_cachedData == null) {
        // 2단계: 캐시가 비어있는 경우 데이터 로드
        _cachedData = await _readData();
    }
    // 3단계: 캐시에 있는 값 반환
    return _cachedData!;
}
```

캐시의 위치, 캐시에 값을 미리 쓰는(preemptively) 정도 또는 캐시를 "예열(warm)"하는 정도 등, 
이 전략을 다양하게 바꿀 수 있는 흥미로운 방법이 많이 있습니다.

## 일반적인 캐싱 용어 {:#common-caching-terminology}

캐싱에는 고유한 용어가 있으며, 그 중 일부는 아래에 정의되어 설명되어 있습니다.

**캐시 적중 (Cache hit)**
: 캐시에 이미 원하는 정보가 포함되어 있고 실제 진실 소스에서 로드할 필요가 없을 때, 
  앱은 캐시 적중이 발생했다고 합니다.

**캐시 미스 (Cache miss)**
: 캐시가 비어 있고 원하는 데이터가 실제 진실 소스에서 로드된 다음 향후 읽기를 위해 캐시에 저장될 때, 
  앱은 캐시 미스가 발생했다고 합니다.

## 데이터 캐싱의 위험 {:#risks-of-caching-data}

앱은 진실의 근원에 있는 데이터가 변경되어, 오래되고 오래된 정보를 렌더링할 위험이 있을 때, 
**오래된 캐시(stale cache)** 를 가지고 있다고 합니다.

모든 캐싱 전략은 오래된 데이터를 보관할 위험이 있습니다. 
안타깝게도 캐시의 신선도를 확인하는 작업은 종종 해당 데이터를 완전히 로드하는 데 걸리는 시간만큼 걸립니다. 
즉, 대부분의 앱은 검증 없이 런타임에 데이터가 신선하다고 믿을 때만, 데이터 캐싱의 이점을 얻는 경향이 있습니다.

이를 처리하기 위해, 대부분의 캐싱 시스템은 캐시된 데이터의 개별 부분에 시간 제한을 포함합니다. 
이 시간 제한을 초과하면, 캐시 히트가 캐시 미스로 처리되어, 신선한 데이터가 로드될 때까지 처리됩니다.

컴퓨터 과학자들 사이에서 인기 있는 농담은, 
"컴퓨터 과학에서 가장 어려운 두 가지는 캐시 무효화, 사물 명명 및 off-by-one 오류"라는 것입니다. 😄

위험에도 불구하고, 전 세계의 거의 모든 앱은 데이터 캐싱을 많이 사용합니다. 
이 페이지의 나머지 부분에서는 Flutter 앱에서 데이터를 캐싱하는 여러 가지 접근 방식을 살펴보겠지만, 
이러한 모든 접근 방식은 상황에 맞게 조정하거나 결합할 수 있습니다.

## 로컬 메모리에 데이터 캐싱 {:#caching-data-in-local-memory}

가장 간단하고 성능이 좋은 캐싱 전략은 메모리 내 캐시(in-memory cache)입니다. 
이 전략의 단점은, 캐시가 시스템 메모리에만 보관되기 때문에, 
원래 캐시된 세션을 넘어서는 데이터가 보관되지 않는다는 것입니다. 
(물론, 이 "단점"은 대부분의 오래된 캐시 문제를 자동으로 해결한다는 장점도 있습니다!)

메모리 내 캐시(in-memory cache)는 단순하기 때문에, 위에서 본 pseudocode와 매우 유사합니다. 
그렇기는 하지만, ([저장소 패턴][repository pattern]과 같은) 입증된 설계 원칙을 사용하여 코드를 구성하고, 
위와 같은 캐시 검사가 코드 기반 전체에 나타나지 않도록 하는 것이 가장 좋습니다.

중복된 네트워크 요청을 방지하기 위해, 
메모리에 사용자를 캐싱하는 작업도 맡은 `UserRepository` 클래스를 상상해 보세요. 
구현은 다음과 같습니다.

```dart
class UserRepository {
  UserRepository(this.api);
  
  final Api api;
  final Map<int, User?> _userCache = {};

  Future<User?> loadUser(int id) async {
    if (!_userCache.containsKey(id)) {
      final response = await api.get(id);
      if (response.statusCode == 200) {
        _userCache[id] = User.fromJson(response.body);
      } else {
        _userCache[id] = null;
      }
    }
    return _userCache[id];
  }
}
```

이 `UserRepository`는 다음을 포함한 여러 입증된 설계 원칙을 따릅니다.

* [종속성 주입][dependency injection], 테스트에 도움이 됨
* [느슨한 결합][loose coupling], 주변 코드를 구현 세부 정보로부터 보호함
* [관심사 분리][separation of concerns], 구현이 너무 많은 관심사를 처리하지 못하도록 함.

그리고 무엇보다도, 사용자가 단일 세션 내에서 Flutter 앱에서 주어진 사용자를 로드하는 페이지를 몇 번 방문하든,
`UserRepository` 클래스는 네트워크를 통해 해당 데이터를 *한 번*만 로드합니다.

그러나, 사용자는 결국 앱을 다시 시작할 때마다 데이터가 로드될 때까지 기다리는 데 지칠 수 있습니다. 
이를 위해 아래에 있는 지속적(persistent) 캐싱 전략 중 하나를 선택해야 합니다.

[dependency injection]: https://en.wikipedia.org/wiki/Dependency_injection
[loose coupling]: https://en.wikipedia.org/wiki/Loose_coupling
[repository Pattern]: https://medium.com/@pererikbergman/repository-design-pattern-e28c0f3e4a30
[separation of concerns]: https://en.wikipedia.org/wiki/Separation_of_concerns

## 지속적(Persistent) 캐시 {:#persistent-caches}

메모리에 데이터를 캐싱해도, 귀중한 캐시가 사용자 단일 세션보다 오래 지속되는 경우는 없습니다. 
애플리케이션을 새로 시작할 때, 캐시 히트의 성능 이점을 누리려면, 
장치의 하드 드라이브 어딘가에 데이터를 캐싱해야 합니다.

### (1) `shared_preferences`로 데이터 캐시 {:#caching-data-with-shared_preferences}

[`shared_preferences`][]는 Flutter의 6개 대상 플랫폼 모두에서, 
플랫폼별 [키-값 저장소][key-value storage]를 래핑하는 Flutter 플러그인입니다. 
이러한 기본 플랫폼 키-값 저장소는 작은 데이터 크기를 위해 설계되었지만, 
대부분 애플리케이션의 캐싱 전략에 여전히 적합합니다. 
전체 가이드는, 키-값 저장소 사용에 대한 다른 리소스를 참조하세요.

* 쿡북: [키-값 데이터를 디스크에 저장][Store key-value data on disk]
* 비디오: [주간 패키지: `shared_preferences`][Package of the Week: `shared_preferences`]

[key-value storage]: https://en.wikipedia.org/wiki/Key%E2%80%93value_database
[Package of the Week: `shared_preferences`]: https://www.youtube.com/watch?v=sa_U0jffQII
[`shared_preferences`]: {{site.pub-pkg}}/shared_preferences
[Store key-value data on disk]: /cookbook/persistence/key-value

### (2) 파일 시스템으로 데이터 캐싱 {:#caching-data-with-the-file-system}

Flutter 앱이 `shared_preferences`에 이상적인 저처리량 시나리오를 벗어나면, 
기기의 파일 시스템으로 데이터 캐싱을 탐색할 준비가 되었을 수 있습니다. 
더 자세한 가이드는 파일 시스템 캐싱에 대한 다른 리소스를 참조하세요.

* 쿡북: [파일 읽기 및 쓰기][Read and write files]

[Read and write files]: /cookbook/persistence/reading-writing-files

### (3) 온디바이스 데이터베이스로 데이터 캐싱 {:#caching-data-with-an-on-device-database}

로컬 데이터 캐싱의 최종 보스는 적절한 데이터베이스를 사용하여 데이터를 읽고 쓰는 모든 전략입니다. 
관계형 및 비관계형 데이터베이스를 포함하여 여러 가지 플레이버가 있습니다. 
모든 접근 방식은 간단한 파일보다 성능이 크게 향상됩니다. 
특히 대규모 데이터 세트의 경우 더욱 그렇습니다. 
더 자세한 가이드는 다음 리소스를 참조하세요.

* 쿡북: [SQLite로 데이터 유지][Persist data with SQLite]
* SQLite 대체: [`sqlite3` 패키지][`sqlite3` package]
* 관계형 데이터베이스인, Drift: [`drift` 패키지][`drift` package]
* 비관계형 데이터베이스인, Hive: [`hive` 패키지][`hive` package]
* 비관계형 데이터베이스인, Isar: [`isar` 패키지][`isar` package]

[`drift` package]: {{site.pub-pkg}}/drift
[`hive` package]: {{site.pub-pkg}}/hive
[`isar` package]: {{site.pub-pkg}}/isar
[Persist data with SQLite]: /cookbook/persistence/sqlite
[`sqlite3` package]: {{site.pub-pkg}}/sqlite3

## 이미지 캐싱 {:#caching-images}

이미지 캐싱은 일반 데이터 캐싱과 비슷한 문제 공간이지만, 모든 상황에 맞는 솔루션이 있습니다. 
Flutter 앱이 파일 시스템을 사용하여 이미지를 저장하도록 지시하려면, [`cached_network_image` 패키지][`cached_network_image` package]를 사용하세요.

* 비디오: [주간 패키지: `cached_network_image`][Package of the Week: `cached_network_image`]

{% comment %}
TODO: My understanding is that we now recommend `Image.network` instead of cache_network_image.
{% endcomment %}

[`cached_network_image` package]: {{site.pub-pkg}}/cached_network_image
[Package of the Week: `cached_network_image`]: https://www.youtube.com/watch?v=fnHr_rsQwDA

## 상태 복원 {:#state-restoration}

애플리케이션 데이터와 함께 탐색 스택, 스크롤 위치, 심지어 양식 작성의 부분 진행률과 같이, 
사용자 세션의 다른 측면을 지속하고 싶을 수도 있습니다. 
이 패턴을 "상태 복원"이라고 하며, Flutter에 내장되어 있습니다.

상태 복원은 Flutter 프레임워크에 Element 트리의 데이터를 Flutter 엔진과 동기화하도록 지시하여 작동하며, 
그런 다음, 이를 플랫폼별 저장소에 캐시하여 향후 세션에 사용합니다. 
Android 및 iOS용 Flutter에서 상태 복원을 활성화하려면 다음 문서를 참조하세요.

* Android 문서: [Android 상태 복원][Android state restoration]
* iOS 문서: [iOS 상태 복원][iOS state restoration]

[Android state restoration]: /platform-integration/android/restore-state-android
[iOS state restoration]: /platform-integration/ios/restore-state-ios

## 피드백 {:#feedback}

이 웹사이트의 이 섹션이 발전하기 때문에, 우리는 [당신의 피드백을 환영합니다][welcome your feedback]!

[welcome your feedback]: https://google.qualtrics.com/jfe/form/SV_6A9KxXR7XmMrNsy?page="local-caching"
