@echo off

setlocal

set NDK=android-ndk-r16b
set NDKURL=https://dl.google.com/android/repository/android-ndk-r16b-windows-x86_64.zip
set ANDROID_TOOLS_DIR=c:\tools\android_tools

if not "%1"=="install" goto :build

if exist %ANDROID_TOOLS_DIR% goto :eof

echo Downloading Android NDK...

if not exist android-tools.zip curl -sSL -o android-tools.zip %NDKURL%

echo Unpacking Android NDK...

7z x -y -aos -bd android-tools.zip

echo Installing Android tools...

python %NDK%\build\tools\make_standalone_toolchain.py --arch arm --api 19 --stl libc++ --install-dir %ANDROID_TOOLS_DIR%

goto :eof

:build

echo Building for Android...

set PATH=%ANDROID_TOOLS_DIR%\bin;%PATH%

copy /b src\*.cpp src\combined_a.cpp > nul

rem call clang++ -Ofast -s -std=c++14 -march=armv7-a -mfpu=neon -fPIE -fPIC -fno-rtti -fno-stack-protector -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -fno-ident -DUSE_THREADS -DUSEGEN -DNDEBUG -D_FORTIFY_SOURCE=0 -DBOOKSPATH=/sdcard/RodentIII/books/ -DPERSONALITIESPATH=/sdcard/RodentIII/personalities/ src\combined_a.cpp -static-libstdc++ -Wl,--fix-cortex-a8,-pie -o rodentiii_arm7a_neon_nta

call clang -Ofast -s -std=c++14 -march=armv7-a -mfpu=neon -fPIE -fPIC -fno-rtti -fno-stack-protector -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables -fno-ident -lm -DNO_THREADS -DUSEGEN -DNDEBUG -D_FORTIFY_SOURCE=0 -DBOOKSPATH=/sdcard/RodentIII/books/ -DPERSONALITIESPATH=/sdcard/RodentIII/personalities/ src\combined_a.cpp -Wl,--fix-cortex-a8,-pie -o rodentiii_arm7a_neon_nta

del /q src\combined_a.cpp
