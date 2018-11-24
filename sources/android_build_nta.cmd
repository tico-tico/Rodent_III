@echo off

setlocal

set NDK=android-ndk-r18b
set NDKURL=https://dl.google.com/android/repository/android-ndk-r18b-windows-x86_64.zip
set ANDROID_TOOLS_DIR=c:\tools\android_tools

if not "%1"=="install" goto :build

if exist %ANDROID_TOOLS_DIR% goto :eof

echo Downloading Android NDK...

if not exist android-tools.zip curl -sSL -o android-tools.zip %NDKURL%

echo Unpacking Android NDK...

7z x -y -aos -bd android-tools.zip

echo Installing Android tools...

python %NDK%\build\tools\make_standalone_toolchain.py --arch arm   --api 19 --install-dir %ANDROID_TOOLS_DIR%\32

python %NDK%\build\tools\make_standalone_toolchain.py --arch arm64 --api 21 --install-dir %ANDROID_TOOLS_DIR%\64

goto :eof

:build

echo Building for Android...

copy /b src\*.cpp src\combined_a.cpp > nul


set PATH=%ANDROID_TOOLS_DIR%\32\bin;%PATH%

call clang -Ofast -s -std=c++14 -march=armv7-a -mfpu=neon -fPIE -fPIC -lm -D__ANDROID_API__=19 -DNO_THREADS -DUSEGEN -DNDEBUG -D_FORTIFY_SOURCE=0 -DBOOKSPATH=/sdcard/RodentIII/books/ -DPERSONALITIESPATH=/sdcard/RodentIII/personalities/ src\combined_a.cpp -Wl,--fix-cortex-a8,-pie -o rodentiii_arm7a_neon_nta


set PATH=%ANDROID_TOOLS_DIR%\64\bin;%PATH%

call clang -Ofast -s -std=c++14 -march=armv8-a -mfpu=neon -fPIE -fPIC -lm -D__ANDROID_API__=21 -DNO_THREADS -DUSEGEN -DNDEBUG -D_FORTIFY_SOURCE=0 -DBOOKSPATH=/sdcard/RodentIII/books/ -DPERSONALITIESPATH=/sdcard/RodentIII/personalities/ src\combined_a.cpp -Wl,-pie -o rodentiii_arm8a_64_neon_nta


del /q src\combined_a.cpp


rem this thing is crashing
rem call clang++ -Ofast -s -std=c++14 -march=armv7-a -mfpu=neon -fPIE -fPIC -fno-rtti -fno-stack-protector -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -fno-ident -DUSE_THREADS -DUSEGEN -DNDEBUG -D_FORTIFY_SOURCE=0 -DBOOKSPATH=/sdcard/RodentIII/books/ -DPERSONALITIESPATH=/sdcard/RodentIII/personalities/ src\combined_a.cpp -static-libstdc++ -Wl,--fix-cortex-a8,-pie -o rodentiii_arm7a_neon_nta
