# Qt-SQLDriver-PQSQL-android

This repository provides a ready-to-use build setup for compiling the **Qt PostgreSQL SQL driver (`qsqlpsql`)** plugin for **Android (arm64-v8a)**.  
It uses **Qt 6.8.3** and links against **libpq.so (PostgreSQL 17.6)**.

---

## ⚙️ Requirements
- Qt 6.8.3 installed (with both Android and host kits)
- Android NDK (tested with r26.1)
- CMake ≥ 3.20
- PostgreSQL 17.6 source code (Provided in repo)

---

## 📖 Instructions

1. **Clone this repository** and place the PostgreSQL source (version 17.7) in the same directory.  
   Example structure:

```
Qt-SQLDriver-PQSQL-android/
├── build.sh
├── postgresql-17.7/
```

2. **Adjust paths** in `build.sh` to match your system:
- `NDK_ROOT` → Android NDK path  
- `ANDROID_SDK_ROOT` → Android SDK path  
- `QT_ROOT` → Qt installation root  
- `PG_SRC` → PostgreSQL source directory  

3. **Run the build script**:
```bash
chmod +x build.sh
./build.sh
```

4. **The script will:**

- Cross-compile libpq.so for arm64-v8a
- Build the qsqlpsql plugin for Qt Android

5. Bundle with your Qt Android app:

- Copy libplugins_sqldrivers_qsqlpsql_arm64-v8a.so into your Qt project under libs/arm64-v8a/
- Copy libpq.so into the same folder

## 🔄 Other Platforms

This setup only compiles for Android arm64-v8a.

- To build for other platforms (e.g., x86, armv7), the script must be adapted.
- You can use ChatGPT or another AI to generate platform-specific instructions.

## 📌 Notes

- OpenSSL support can be disabled by adding `--with-openssl=no`. OpenSSL needs to be cross-compiled for Android.
- Tested only with Qt 6.8.3 + Android arm64-v8a.
