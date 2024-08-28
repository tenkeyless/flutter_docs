1. {{include.devos}} {{include.target}} 앱을 개발하려면, 다음 명령을 사용하여 이러한 패키지를 설치하세요.
   [`clang`][clang],
   [`cmake`][cmake],
   [`ninja-build`][ninjabuild],
   [`pkg-config`][pkg-config],
   [`libgtk-3-dev`][gtk3],
   [`libstdc++-12-dev`][libstdc]

   ```console
   $ sudo apt-get install \
         clang cmake git \
         ninja-build pkg-config \
         libgtk-3-dev liblzma-dev \
         libstdc++-12-dev
   ```

[clang]: https://clang.llvm.org/
[cmake]: https://cmake.org/
[gtk3]: https://www.gtk.org/docs/installations/linux#installing-gtk3-from-packages
[ninjabuild]: https://ninja-build.org/
[pkg-config]: https://www.freedesktop.org/wiki/Software/pkg-config/
[libstdc]: https://packages.debian.org/sid/libstdc++-12-dev
