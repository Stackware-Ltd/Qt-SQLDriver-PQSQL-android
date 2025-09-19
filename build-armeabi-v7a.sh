#!/usr/bin/env bash
set -e

### ==============================
### User-configurable paths
### ==============================
NDK_ROOT="$HOME/Android/Sdk/ndk/26.1.10909125"
ANDROID_SDK_ROOT="$HOME/Android/Sdk"
API_LEVEL=34

# Qt installation paths (update version if different)
QT_ROOT="$HOME/Qt/6.8.3"
QT_ANDROID="$QT_ROOT/android_armv7"
QT_HOST="$QT_ROOT/gcc_64"

# PostgreSQL source directory (assumed to be alongside this script)
PG_SRC="postgresql-17.6"

### ==============================
### Derived paths (no need to edit)
### ==============================
TARGET_TRIPLET=armv7a-linux-androideabi
TOOLCHAIN="$NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64"
SYSROOT="$TOOLCHAIN/sysroot"
PATH="$TOOLCHAIN/bin:$PATH"

# Compiler wrappers
export CC="$TOOLCHAIN/bin/${TARGET_TRIPLET}${API_LEVEL}-clang"
export CXX="$TOOLCHAIN/bin/${TARGET_TRIPLET}${API_LEVEL}-clang++"
export AR="$TOOLCHAIN/bin/llvm-ar"
export RANLIB="$TOOLCHAIN/bin/llvm-ranlib"
export LD="$TOOLCHAIN/bin/ld"

### ==============================
### Build libpq.so (PostgreSQL client)
### ==============================
cd "$PG_SRC"

make distclean || true

./configure \
    --host=$TARGET_TRIPLET \
    --without-readline \
    --disable-rpath \
    --prefix=$PWD/install \
    CFLAGS="--sysroot=$SYSROOT -fPIC" \
    LDFLAGS="--sysroot=$SYSROOT"
# --with-openssl=no \

make -C src/interfaces/libpq
# make -C src/interfaces/libpq install

cd ..

### ==============================
### Build Qt PostgreSQL driver plugin
### ==============================
rm -rf ./build
mkdir -p build && cd build

cmake \
    -DCMAKE_TOOLCHAIN_FILE="$NDK_ROOT/build/cmake/android.toolchain.cmake" \
    -DANDROID_ABI=armeabi-v7a \
    -DANDROID_NATIVE_API_LEVEL=$API_LEVEL \
    -DANDROID_SDK_ROOT="$ANDROID_SDK_ROOT" \
    -DCMAKE_PREFIX_PATH="$QT_ANDROID;$QT_HOST" \
    -DQt6_DIR="$QT_ANDROID/lib/cmake/Qt6" \
    -DQt6Core_DIR="$QT_ANDROID/lib/cmake/Qt6Core" \
    -DQt6Sql_DIR="$QT_ANDROID/lib/cmake/Qt6Sql" \
    -DQT_HOST_PATH="$QT_HOST" \
    -DCMAKE_INSTALL_PREFIX="$QT_ANDROID" \
    -DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=BOTH \
    ..

cmake --build . --parallel

cd ..

rm -rf ./output
mkdir -p output/libs/armeabi-v7a
mkdir -p output/plugins
mv build/plugins/sqldrivers/libplugins__qsqlpsql_armeabi-v7a.so output/plugins/libplugins_sqldrivers_qsqlpsql_armeabi-v7a.so
mv postgresql-17.6/src/interfaces/libpq/libpq.so output/libs/armeabi-v7a/libpq.so

