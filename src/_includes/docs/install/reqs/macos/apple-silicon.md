일부 Flutter 구성 요소에는, 
[Apple 실리콘][Apple silicon]을 실행하는 Mac에서 [Rosetta 2 번역 프로세스][need-rosetta]가 필요합니다. 
Apple 실리콘에서 모든 Flutter 구성 요소를 실행하려면, [Rosetta 2][rosetta]를 설치하세요.

```console
$ sudo softwareupdate --install-rosetta --agree-to-license
```

[Apple silicon]: https://support.apple.com/en-us/HT211814
[rosetta]: https://support.apple.com/en-us/HT211861
[need-rosetta]: {{site.repo.this}}/pull/7119#issuecomment-1124537969
