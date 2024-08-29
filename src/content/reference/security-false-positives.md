---
# title: Security false positives
title: Security 오탐지 (false positives)
# description: Security vulnerabilities incorrectly reported by automated static analysis tools
description: 자동화된 정적 분석 도구에서 잘못 보고된 보안 취약점
---

## 소개 {:#introduction}

우리는 때때로 다른 종류의 애플리케이션(예: Java 또는 C++로 작성된 애플리케이션)을 위해 빌드된 도구에서, 
생성된 Dart 및 Flutter 애플리케이션의 보안 취약성에 대한 거짓 보고를 받습니다. 
이 문서는 우리가 부정확하다고 믿는 보고에 대한 정보를 제공하고, 우려가 잘못된 이유를 설명합니다.

## 일반적인 우려 사항 {:#common-concerns}

### 공유 객체는 강화된 함수를 사용해야 합니다. {:#shared-objects-should-use-fortified-functions}

> The shared object does not have any fortified functions.
> Fortified functions provides buffer overflow checks against glibc's commons insecure functions like `strcpy`, `gets` etc.
> Use the compiler option `-D_FORTIFY_SOURCE=2` to fortify functions.

> 공유 객체에는 강화된 함수가 없습니다.
> 강화된 함수는 (`strcpy`, `gets` 등과 같은) glibc의 공통적인 안전하지 않은 함수에 대한 버퍼 오버플로 검사를 제공합니다.
> 함수를 강화하려면, 컴파일러 옵션 `-D_FORTIFY_SOURCE=2`를 사용합니다.

이것이 컴파일된 Dart 코드(예: Flutter 애플리케이션의 `libapp.so` 파일)를 참조할 때, 이 조언은 잘못된 것입니다. 
Dart 코드는 libc 함수를 직접 호출하지 않기 때문입니다. 
모든 Dart 코드는 Dart 표준 라이브러리를 거칩니다.

(일반적으로, MobSF는 `_chk` 접미사가 있는 함수의 사용을 확인하기 때문에 여기서 거짓 양성을 얻지만, 
 Dart는 이러한 함수를 전혀 사용하지 않으므로, 접미사가 있거나 없는 호출이 없으므로, 
 MobSF는 코드를 비강화(non-fortified) 호출이 포함된 것으로 처리합니다.)

### 공유 객체는 RELRO를 사용해야 합니다. {:#shared-objects-should-use-relro}

> no RELRO found for `libapp.so` binaries

> `libapp.so` 바이너리에 대한 RELRO가 발견되지 않았습니다.

Dart는 일반적인 Procedure Linkage Table(PLT) 또는 Global Offsets Table(GOT) 메커니즘을 전혀 사용하지 않으므로, 
Relocation Read-Only(RELRO) 기술은 Dart에 그다지 의미가 없습니다.

Dart의 GOT와 동등한 것은 풀 포인터(pool pointer)인데, 
GOT와 달리 무작위 위치에 있으므로 악용하기가 훨씬 어렵습니다.

원칙적으로 Dart FFI를 사용하면 취약한 코드를 만들 수 있지만, 
Dart FFI를 정상적으로 사용하면 RELRO를 적절히 사용하는 C 코드와 함께 사용한다고 가정하면, 
이러한 문제가 발생하지 않습니다.

### 공유 객체는 스택 canary 값을 사용해야 합니다. {:#shared-objects-should-use-stack-canary-values}

> no canary are found for `libapp.so` binaries

> `libapp.so` 바이너리에 대한 canary가 발견되지 않았습니다. 

> This shared object does not have a stack canary value added to the stack.
> Stack canaries are used to detect and prevent exploits from overwriting return address.
> Use the option -fstack-protector-all to enable stack canaries.

> 이 공유 객체에는 스택에 추가된 스택 canary 값이 없습니다.
> 스택 canary는 악용이 반환 주소를 덮어쓰는 것을 감지하고 방지하는 데 사용됩니다.
> -fstack-protector-all 옵션을 사용하여 스택 canary를 활성화합니다.

Dart는, C++와 달리, 스택에 할당된 배열(C/C++에서 스택 스매싱의 주요 원인)이 없기 때문에, 
스택 canary를 생성하지 않습니다.

`dart:ffi`를 사용하지 않고, 순수한 Dart를 작성할 때, 
이미 C++ 완화책이 제공할 수 있는 것보다 훨씬 강력한 격리 보장이 있습니다. 
순수한 Dart 코드는 버퍼 오버런과 같은 것이 존재하지 않는 관리되는 언어이기 때문입니다.

원칙적으로 Dart FFI를 사용할 때 취약한 코드를 만들 수 있지만, 
Dart FFI를 정상적으로 사용하면, 스택 canary 값을 적절히 사용하는 C 코드와 함께 사용된다고 가정할 때, 
이러한 문제가 발생하지 않습니다.

### 코드는 `_sscanf`, `_strlen` 및 `_fopen` API 사용을 피해야 합니다. {:#code-should-avoid-using-the-_sscanf-_strlen-and-_fopen-apis}

> The binary may contain the following insecure API(s) `_sscanf` , `_strlen` , `_fopen`.

> 바이너리에는 다음과 같은 안전하지 않은 API(들) `_sscanf`, `_strlen`, `_fopen`이 포함될 수 있습니다.

이러한 문제를 보고하는 도구는 스캔에서 지나치게 단순화하는 경향이 있습니다. 
예를 들어, 이러한 이름을 가진 커스텀 함수를 찾아서 표준 라이브러리 함수를 참조한다고 가정합니다. 
Flutter의 타사 종속성 중 다수는 이러한 검사를 통과하지 못하는 유사한 이름의 함수를 가지고 있습니다. 
일부 발생이 타당한 우려일 수 있지만, 거짓 양성의 수가 너무 많아서 이러한 도구의 출력에서 ​​알 수 없습니다.

### 코드는 메모리 할당을 위해 `_malloc` 대신 `calloc`을 사용해야 합니다. {:#code-should-use-calloc-instead-of-_malloc-for-memory-allocations}

> The binary may use `_malloc` function instead of `calloc`.

> 바이너리는 `calloc` 대신 `_malloc` 함수를 사용할 수 있습니다.

메모리 할당은 성능과 취약성에 대한 회복성 사이에서 균형을 맞춰야 하는 미묘한 주제입니다. 
단순히 `malloc`을 사용한다고 해서, 자동으로 보안 취약성을 나타내는 것은 아닙니다. 
`calloc`을 사용하는 것이 더 바람직한 경우에 대한 구체적인 보고(아래 참조)를 환영하지만, 
실제로는 모든 `malloc` 호출을 `calloc`으로 일률적으로 대체하는 것은 부적절할 것입니다.

### iOS 바이너리에는 Runpath Search Path (`@rpath`)가 설정되어 있습니다. {:#the-ios-binary-has-a-runpath-search-path-rpath-set}

> The binary has Runpath Search Path (`@rpath`) set.
> In certain cases an attacker can abuse this feature to run arbitrary executable for code execution and privilege escalation.
> Remove the compiler option `-rpath` to remove `@rpath`.

> 바이너리에 Runpath Search Path(`@rpath`)가 설정되어 있습니다.
> 특정 경우에 공격자는 이 기능을 악용하여, 코드 실행 및 권한 상승을 위해 임의의 실행 파일을 실행할 수 있습니다.
> 컴파일러 옵션 `-rpath`를 제거하여, `@rpath`를 제거합니다.

앱이 빌드될 때, Runpath Search Path는 링커가 앱에서 사용하는 동적 라이브러리(dylibs)를 찾기 위해 검색하는 경로를 나타냅니다. 
기본적으로 iOS 앱은 이 경로를 `@executable_path/Frameworks`로 설정합니다. 
즉, 링커는 앱 번들 내의 앱 바이너리를 기준으로 `Frameworks` 디렉터리에서 dylibs를 검색해야 합니다. 
대부분의 임베디드 프레임워크나 dylibs와 마찬가지로, `Flutter.framework` 엔진은 이 디렉터리에 올바르게 복사됩니다. 
앱이 실행되면, 라이브러리 바이너리를 로드합니다.

Flutter 앱은 기본 iOS 빌드 설정(`LD_RUNPATH_SEARCH_PATHS=@executable_path/Frameworks`)을 사용합니다.

`@rpath`와 관련된 취약성은 모바일 설정에는 적용되지 않습니다. 
공격자는 파일 시스템에 액세스할 수 없고, 이러한 프레임워크를 임의로 바꿀 수 없기 때문입니다. 
공격자가 어떻게든 프레임워크를 악성 프레임워크로 바꿀 수 있다 하더라도, 
앱은 코드 설계 위반으로 인해 시작 시 충돌합니다.

### PKCS5/PKCS7 패딩 취약성이 있는 CBC {:#cbc-with-pkcs5pkcs7-padding-vulnerability}

일부 Flutter 패키지에 "PKCS5/PKCS7 패딩 취약점이 있는 CBC"가 있다는 모호한 보고를 받았습니다.

저희가 아는 한, 이는 ExoPlayer의 HLS 구현(`com.google.android.exoplayer2.source.hls.Aes128DataSource` 클래스)에 의해 트리거됩니다. 
HLS는 Apple의 스트리밍 형식으로, DRM에 사용해야 하는 암호화 타입을 정의합니다. 
이는 취약점이 아닙니다. 
DRM은 사용자의 머신이나 데이터를 보호하지 않고, 
대신 사용자가 소프트웨어와 하드웨어를 완전히 사용할 수 있는 기능을 제한하기 위해, 난독화를 제공하기 때문입니다.

### 앱은 외부 저장소를 읽고 쓸 수 있습니다. {:#apps-can-read-and-write-to-external-storage}

> App can read/write to External Storage. Any App can read data written to External Storage.

> 앱은 외부 저장소를 읽고 쓸 수 있습니다. 모든 앱은 외부 저장소에 쓰여진 데이터를 읽을 수 있습니다.

> As with data from any untrusted source, you should perform input validation when handling data from external storage.
> We strongly recommend that you not store executables or class files on external storage prior to dynamic loading.
> If your app does retrieve executable files from external storage, the files should be signed and cryptographically verified prior to dynamic loading.

> 신뢰할 수 없는 출처의 데이터와 마찬가지로, 외부 저장소의 데이터를 처리할 때는 입력 검증을 수행해야 합니다.
> 동적 로딩 전에 실행 파일이나 클래스 파일을 외부 저장소에 저장하지 않는 것이 좋습니다.
> 앱이 외부 저장소에서 실행 파일을 검색하는 경우, 동적 로딩 전에 파일을 서명하고 암호화하여 검증해야 합니다.

일부 취약성 스캐닝 도구가 이미지 피커 플러그인이 외부 저장소를 읽고 쓸 수 있는 기능을, 
위협으로 해석한다는 보고를 받았습니다.

로컬 저장소에서 이미지를 읽는 것이 이러한 플러그인의 목적이며, 이는 취약성이 아닙니다.

### 앱은 file.delete()를 사용하여 데이터를 삭제합니다. {:#apps-delete-data-using-file-delete}

> When you delete a file using file. delete, only the reference to the file is removed from the file system table.
> The file still exists on disk until other data overwrites it, leaving it vulnerable to recovery.

> file.delete를 사용하여 파일을 삭제하면, 파일 시스템 테이블에서 파일에 대한 참조만 제거됩니다.
> 다른 데이터가 덮어쓸 때까지 파일은 디스크에 계속 존재하여, 복구에 취약해집니다.

일부 취약성 검사 도구는 카메라 플러그인이 기기 카메라의 데이터를 기록한 후, 
임시 파일을 삭제하는 것을 보안 취약성으로 해석합니다. 
비디오는 사용자가 녹화하고 사용자의 하드웨어에 저장되므로, 실제 위험은 없습니다.

## 더 이상 유효하지 않은 우려 {:#obsolete-concerns}

이 섹션에는 이전 버전의 Dart 및 Flutter에서 볼 수 있지만, 
최신 버전에서는 더 이상 볼 수 없는 유효한 메시지가 포함되어 있습니다. 
이전 버전의 Dart 또는 Flutter에서 이러한 메시지가 표시되면 최신 안정 버전으로 업그레이드하세요. 
현재 안정 버전에서 이러한 메시지가 표시되면 보고해 주세요. (이 문서의 마지막 섹션 참조)

### 스택에는 NX 비트가 설정되어 있어야 합니다. {:#the-stack-should-have-its-nx-bit-set}

> The shared object does not have NX bit set.
> NX bit offer protection against exploitation of memory corruption vulnerabilities by marking memory page as non-executable.
> Use option `--noexecstack` or `-z noexecstack` to mark stack as non executable.

> 공유 객체에 NX 비트가 설정되어 있지 않습니다.
> NX 비트는 메모리 페이지를 실행 불가능(non-executable)으로 표시하여, 메모리 손상 취약성 악용으로부터 보호합니다.
> `--noexecstack` 또는 `-z noexecstack` 옵션을 사용하여 스택을 실행 불가능으로 표시합니다.

(MobSF의 메시지는 오해의 소지가 있습니다. 공유 객체가 아니라, 스택이 실행 불가능으로 표시되었는지 여부를 찾고 있습니다.)

이전 버전의 Dart와 Flutter에서는 
ELF 생성기가 `~X` 권한으로 `gnustack` 세그먼트를 내보내지 않는 버그가 있었지만, 
이제 이 버그가 수정되었습니다.

## 실제 우려 사항 보고 {:#reporting-real-concerns}

자동화된 취약성 스캐닝 도구가 위의 예와 같은 거짓 양성을 보고하지만, 
더 주의 깊게 살펴봐야 할 실제 문제가 있다는 것을 배제할 수 없습니다. 
합법적인 보안 취약성이라고 생각되는 문제를 발견하면, 보고해 주시면 대단히 감사하겠습니다.

* [Flutter 보안 정책](/security)
* [Dart 보안 정책]({{site.dart-site}}/security)