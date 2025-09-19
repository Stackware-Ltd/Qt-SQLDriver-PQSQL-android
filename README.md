# Qt-SQLDriver-PQSQL-android

This repository provides a ready-to-use build setup for compiling the **Qt PostgreSQL SQL driver (`qsqlpsql`)** plugin for **Android**.  
It uses **Qt 6.8.3** and links against **libpq.so (PostgreSQL 17.6)**.

---

## ⚙️ Requirements
- Qt 6.8.3 installed (with both Android and host kits)
- Android NDK (tested with r26.1)
- CMake ≥ 3.20
- PostgreSQL 17.6 source code (Provided in repo but better to download a fresh copy)

---

## 📖 Instructions

1. **Clone this repository** and place the PostgreSQL source (version 17.6) in the same directory.  
   Example structure:

```
Qt-SQLDriver-PQSQL-android/
├── build.sh
├── postgresql-17.6/
```

2. **Adjust paths** in `build-<arch>.sh` to match your system:
- `NDK_ROOT` → Android NDK path  
- `ANDROID_SDK_ROOT` → Android SDK path  
- `QT_ROOT` → Qt installation root  
- `PG_SRC` → PostgreSQL source directory  

3. **Run the build script**:
```bash
chmod +x build.sh
./build-<arch>.sh
```

4. **The script will:**

- Cross-compile libpq.so for the configured architecture
- Build the qsqlpsql plugin for Qt Android

5. Bundle with your Qt Android app:

- Copy libplugins_sqldrivers_qsqlpsql_<arch>.so into your Qt project under libs/<arch>/
- Copy libpq.so into the same folder

## 🔄 Other Platforms

This setup only compiles for Android arm64-v8a and armeabi-v7a.

- To build for other platforms (e.g., x86), the script must be adapted.
- You can use ChatGPT or another AI to generate platform-specific instructions.

## 📦 Output

After a successful build, you’ll have:

- libplugins_sqldrivers_qsqlpsql_arm64-v8a.so → Qt SQL driver plugin
- libpq.so → PostgreSQL client library

Both will be available in output folder.

To package with your Qt Android app, cop output folder to you project and in your CMakeLists.txt add this (Adjust paths and target as per your project):

```
if (ANDROID)
    set_target_properties(myAppTarget PROPERTIES
        QT_ANDROID_EXTRA_LIBS "${CMAKE_CURRENT_SOURCE_DIR}/output/libs/arm64-v8a/libpq.so"
        QT_ANDROID_EXTRA_PLUGINS "${CMAKE_CURRENT_SOURCE_DIR}/output/plugins"
    )

    # Add OpenSSL Libraries
    include(FetchContent)
    FetchContent_Declare(
        android_openssl
        DOWNLOAD_EXTRACT_TIMESTAMP true
        URL https://github.com/KDAB/android_openssl/archive/refs/heads/master.zip
    )
    FetchContent_MakeAvailable(android_openssl)
    include(${android_openssl_SOURCE_DIR}/android_openssl.cmake)
    add_android_openssl_libraries(myAppTarget)
endif()
```

## 📌 Notes

- OpenSSL support can be disabled by adding `--with-openssl=no`. OpenSSL needs to be cross-compiled for Android.
- Tested only with Qt 6.8.3 + Android arm64-v8a and armeabi-v7a.
