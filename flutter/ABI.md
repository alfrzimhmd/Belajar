# Application Binary Interface (ABI) di Flutter dan Android

> Dokumen ini menjelaskan secara mendalam mengenai konsep **ABI (Application Binary Interface)** dalam konteks pengembangan aplikasi Android menggunakan **Flutter**.  
Materi ini mencakup pengertian ABI, jenis-jenis ABI yang digunakan Android, hubungannya dengan sistem build Flutter, serta strategi optimasi ukuran aplikasi.
---
## Daftar Isi
- [Pengertian ABI](#1-pengertian-abi)
- [Jenis ABI pada Platform Android](#2-jenis-abi-pada-platform-android)
- [Pentingnya ABI dalam Proses Build Flutter](#3-pentingnya-abi-dalam-proses-build-flutter)
- [Mekanisme Build Flutter Berdasarkan ABI](#4-mekanisme-build-flutter-berdasarkan-abi)
- [Pemeriksaan ABI pada Perangkat](#5-pemeriksaan-abi-pada-perangkat)
- [Proses Instalasi APK Berdasarkan ABI](#6-proses-instalasi-apk-berdasarkan-abi)
- [Melihat ABI dalam File APK](#7-melihat-abi-dalam-file-apk)
- [Perbandingan Ukuran Berdasarkan Jenis Build](#8-perbandingan-ukuran-berdasarkan-jenis-build)
- [Praktik Terbaik dalam Penggunaan ABI](#9-praktik-terbaik-dalam-penggunaan-abi)
- [Optimasi Ukuran APK Berdasarkan ABI](#10-optimasi-ukuran-apk-berdasarkan-abi)
- [Diagram Proses Build Flutter dan ABI](#11-diagram-proses-build-flutter-dan-abi)
- [Skrip Otomatis Build dan Instalasi](#12-skrip-otomatis-build-dan-instalasi)
- [Glosarium / Istilah](#13-glosarium-istilah)
- [Referensi](#14-referensi)
---
## 1. Pengertian ABI
Application Binary Interface (ABI) adalah perantara antara aplikasi dan sistem operasi yang menentukan bagaimana kode biner (native code) dijalankan pada arsitektur CPU tertentu.
Secara sederhana, ABI menjembatani hasil kompilasi program dengan perangkat keras yang mengeksekusinya. Ia memastikan bahwa kode mesin yang dihasilkan oleh compiler dapat berinteraksi dengan sistem operasi dan CPU dengan benar.
ABI mengatur:
- Format dan struktur file biner yang digunakan sistem.
- Konvensi pemanggilan fungsi (calling convention), yaitu bagaimana argumen dan nilai balik fungsi dikelola di register atau memori.
- Ukuran dan alignment dari setiap tipe data (misalnya int, float, double).
- Cara program menggunakan register dan memori dalam eksekusi.
- Kompatibilitas antara kode hasil kompilasi dan sistem target.

**Tentang file .so (Shared Object)**.
File dengan ekstensi .so (shared object) adalah library biner yang berisi kode native yang dapat digunakan ulang oleh aplikasi Android.
Library ini biasanya dihasilkan dari bahasa pemrograman seperti C atau C++ melalui NDK (Native Development Kit), lalu disertakan di dalam aplikasi agar dapat dijalankan langsung oleh sistem operasi.
Setiap ABI memiliki versi .so yang berbeda, misalnya:
```
lib/arm64-v8a/libflutter.so
lib/armeabi-v7a/libflutter.so
```
Meskipun keduanya memiliki nama file sama (libflutter.so), isi biner di dalamnya berbeda karena dikompilasi untuk arsitektur CPU yang berbeda (ARM 32-bit dan ARM 64-bit).
Jika aplikasi dijalankan pada perangkat dengan ABI yang tidak sesuai dengan file .so yang tersedia, maka aplikasi akan gagal diluncurkan dan menampilkan error:
```
INSTALL_FAILED_NO_MATCHING_ABIS
```
Dengan kata lain, ABI adalah “bahasa mesin” yang menyatukan tiga komponen utama seperti Kode program (hasil kompilasi dari Flutter, C++, dll), Sistem operasi Android, dan Arsitektur perangkat keras (CPU).
**Tanpa ABI yang sesuai, kode tidak bisa dieksekusi dengan benar di perangkat target.**

---

## 2. Jenis ABI pada Platform Android

Berikut adalah jenis-jenis ABI yang umum digunakan dalam ekosistem Android:

| ABI | Arsitektur | Deskripsi |
|------|-------------|------------|
| **armeabi-v7a** | ARM 32-bit | Digunakan pada perangkat lama (biasanya Android 5–7). Masih banyak ditemukan pada perangkat kelas bawah. Performa relatif lebih lambat. |
| **arm64-v8a** | ARM 64-bit | Standar modern pada Android (Android 8 ke atas). Mendukung pemrosesan 64-bit, lebih cepat, dan mampu mengakses lebih banyak memori. |
| **x86 / x86_64** | Intel 32/64-bit | Digunakan terutama pada emulator Android Studio untuk meningkatkan performa simulasi. Hampir tidak ada perangkat fisik yang menggunakan ini. |
| **MIPS** | — | Arsitektur lama yang sudah tidak digunakan lagi dalam ekosistem Android. |

ABI menentukan folder `lib/<ABI>/` dalam file APK yang berisi library `.so`.  
Sebagai contoh, pada aplikasi Flutter, engine dan plugin-plugin native seperti `camera` atau `path_provider` akan disertakan dalam direktori sesuai ABI.

---

## 3. Pentingnya ABI dalam Proses Build Flutter

ABI berpengaruh langsung terhadap:
1. **Kompatibilitas Aplikasi**  
   Jika perangkat hanya mendukung `arm64-v8a` tetapi APK hanya berisi `x86`, maka instalasi akan gagal dengan pesan:
   INSTALL_FAILED_NO_MATCHING_ABIS

2. **Ukuran File APK**  
APK yang menyertakan semua ABI (universal APK) akan memiliki ukuran lebih besar karena mengandung banyak file `.so`.

3. **Optimasi Distribusi di Play Store**  
Dengan format AAB (Android App Bundle), Google Play secara otomatis menghasilkan APK terpisah berdasarkan ABI perangkat pengguna sehingga mengurangi ukuran unduhan.

---

## 4. Mekanisme Build Flutter Berdasarkan ABI

Flutter menggunakan **Android NDK** untuk mengompilasi kode native (termasuk engine dan plugin).  
NDK akan menghasilkan file `.so` untuk masing-masing ABI yang ditargetkan, lalu menggabungkannya ke dalam APK atau AAB sesuai perintah build.

Flutter menyediakan beberapa opsi build terkait ABI:

a. Universal APK

```bash
flutter build apk --release
```
- Menghasilkan satu file app-release.apk.
- Berisi semua ABI: arm64-v8a, armeabi-v7a, x86_64.
- Cocok untuk pengujian umum, namun ukurannya besar (50–100 MB).

b. Split APK per ABI
```bash
flutter build apk --release --split-per-abi
```
Menghasilkan beberapa APK, masing-masing hanya untuk satu ABI:
- app-arm64-v8a-release.apk
- app-armeabi-v7a-release.apk
- app-x86_64-release.apk
Ukuran setiap APK menjadi lebih kecil (sekitar 20–30 MB) dan Perlu memilih APK yang sesuai dengan ABI perangkat.

c. Target ABI Spesifik
```bash
flutter build apk --release --target-platform android-arm64
```
Hanya menghasilkan APK untuk ABI tertentu (misalnya ARM64).
Ukuran lebih kecil dan instalasi lebih cepat.
Hanya dapat dijalankan pada perangkat dengan ABI tersebut.

d. Android App Bundle (AAB)
```bash
flutter build appbundle --release
```
Menghasilkan file .aab yang merupakan format distribusi resmi di Google Play.
Play Store akan memecah AAB menjadi APK sesuai ABI, densitas layar, dan bahasa.
Ukuran yang diunduh pengguna menjadi jauh lebih kecil (15–25 MB).
Tidak dapat diinstal secara manual di luar Play Store.

## 5. Pemeriksaan ABI pada Perangkat
Gunakan perintah berikut untuk memeriksa ABI yang didukung oleh perangkat Android:
```bash
adb shell getprop ro.product.cpu.abi
adb shell getprop ro.product.cpu.abilist
```
Contoh hasil:
- arm64-v8a
- armeabi-v7a,arm64-v8a
Artinya perangkat mendukung dua ABI, namun biasanya akan menjalankan aplikasi menggunakan ABI 64-bit (arm64-v8a).

## 6. Proses Instalasi APK Berdasarkan ABI
Untuk menginstal APK ke perangkat:
Jika hanya ada satu perangkat yang terhubung:
```bash
adb install -r build/app/outputs/flutter-apk/app-release.apk
```
Jika terdapat lebih dari satu perangkat/emulator:
```bash
adb devices
adb -s <DEVICE_ID> install -r build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

## 7. Melihat ABI dalam File APK
Gunakan perintah berikut untuk memeriksa ABI apa saja yang terdapat di dalam APK:
```bash
unzip -l build/app/outputs/flutter-apk/app-release.apk | grep lib/
```
Contoh output:
```bash
lib/arm64-v8a/libflutter.so
lib/armeabi-v7a/libflutter.so
lib/x86_64/libflutter.so
```
Jika terdapat banyak folder ABI, maka itu adalah Universal APK.

## 8. Perbandingan Ukuran Berdasarkan Jenis Build
| Jenis Build               | Isi ABI                      | Ukuran APK |
| ------------------------- | ---------------------------- | ---------- |
| Debug APK (`flutter run`) | Semua ABI + simbol debug     | >100 MB    |
| Universal APK             | Semua ABI                    | ±50 MB     |
| Split per ABI             | 1 ABI                        | ±20–30 MB  |
| App Bundle (AAB)          | Disesuaikan dengan perangkat | ±15–25 MB  |

## 9. Praktik Terbaik dalam Penggunaan ABI
- Gunakan Split-per-ABI untuk Pengujian Lokal untuk Membuat proses instalasi lebih cepat dan ukuran file lebih kecil.
- Gunakan App Bundle (AAB) untuk Distribusi Publik, Google Play akan secara otomatis mengoptimalkan APK sesuai perangkat pengguna.
- Gunakan ABI Spesifik untuk Build Internal, Berguna untuk distribusi internal atau CI/CD dengan target perangkat tertentu.
- Perhatikan Dukungan Plugin karna beberapa plugin Flutter dengan kode native mungkin hanya mendukung ABI tertentu dan pastikan plugin kompatibel sebelum membuat split build.

## 10. Optimasi Ukuran APK Berdasarkan ABI
Selain memilih ABI yang relevan, optimasi dapat dilakukan melalui pengaturan Gradle:
```bash
buildTypes {
    release {
        shrinkResources true
        minifyEnabled true
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
    }
}
```
Kombinasi antara pemilihan ABI yang tepat dan pengaktifan fitur shrinking dapat menurunkan ukuran APK hingga 40–60%.

## 11. Diagram Proses Build Flutter dan ABI
Proses pembuatan aplikasi Flutter yang mendukung beberapa ABI dapat digambarkan secara umum sebagai berikut:
```bash 
Kode Sumber Flutter
        │
        ▼
Flutter Engine & Native Plugins
        │
        ▼
Kompilasi melalui Android NDK → menghasilkan file .so per ABI
        │
        ▼
lib/arm64-v8a/libflutter.so
lib/armeabi-v7a/libflutter.so
        │
        ▼
Proses Packaging → APK atau AAB
```
Setiap tahap di atas memastikan bahwa kode native yang dihasilkan kompatibel dengan arsitektur CPU target.
Hasil akhir berupa APK atau AAB kemudian siap untuk distribusi ke pengguna.

## 12. Skrip Otomatis Build dan Instalasi
Bagian ini berisi contoh urutan perintah yang umum digunakan dalam proses build, pemeriksaan ABI perangkat, dan instalasi hasil build Flutter ke perangkat Android menggunakan ADB (Android Debug Bridge).
Setiap bagian dijelaskan secara singkat mengenai fungsinya.

a. Menampilkan Perangkat yang Terhubung
```bash
adb devices
```
Perintah ini digunakan untuk menampilkan daftar perangkat Android (fisik maupun emulator) yang terhubung ke komputer melalui USB atau jaringan lokal.
Contoh output:
```
List of devices attached
emulator-5554   device
R58M12ABC123    device
```
- emulator-5554 → ID dari Android Emulator.
- R58M12ABC123 → ID dari perangkat fisik.
Jika daftar kosong, pastikan USB Debugging diaktifkan dan perangkat sudah diotorisasi di komputer.

b. Mengecek ABI yang Digunakan oleh Perangkat
```
adb shell getprop ro.product.cpu.abi
adb shell getprop ro.product.cpu.abilist
```
- ro.product.cpu.abi menampilkan ABI utama yang sedang digunakan sistem.
- ro.product.cpu.abilist menampilkan seluruh ABI yang didukung perangkat.

Contoh output:
```
arm64-v8a
armeabi-v7a,arm64-v8a
```
Artinya perangkat dapat menjalankan aplikasi 32-bit (armeabi-v7a) maupun 64-bit (arm64-v8a), tetapi secara default menjalankan versi 64-bit.

c. Membangun Universal APK (Mendukung Semua ABI)
```
flutter build apk --release
```
Perintah ini membuat satu file APK berisi semua ABI (arm64-v8a, armeabi-v7a, x86_64).
Cocok untuk pengujian cepat di berbagai perangkat tanpa perlu mengetahui ABI-nya, tetapi ukuran file menjadi besar (sekitar 50–100 MB).
Hasil build tersimpan di:
```
build/app/outputs/flutter-apk/app-release.apk
```
Instalasi ke perangkat:
```
adb install -r build/app/outputs/flutter-apk/app-release.apk
```
Opsi -r berarti “replace” atau menimpa aplikasi sebelumnya tanpa menghapus datanya.

d. Membangun Split APK per ABI (Ukuran Lebih Kecil)
```
flutter build apk --release --split-per-abi
```
Membuat beberapa file APK, masing-masing hanya berisi library untuk satu ABI tertentu.

Hasil build:
```
app-armeabi-v7a-release.apk
app-arm64-v8a-release.apk
app-x86_64-release.apk
```
Ukuran setiap file lebih kecil (sekitar 20–30 MB).
Cocok digunakan ketika kamu mengetahui ABI dari perangkat target.

Instalasi ke perangkat ARM64:
```
adb install -r build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```
Instalasi ke perangkat 32-bit ARM:
```
adb install -r build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk
```

e. Membangun Target ABI Spesifik (Build Terarah)
```
flutter build apk --release --target-platform android-arm64
```
Build hanya untuk satu platform tertentu (misalnya android-arm64).
File yang dihasilkan sangat kecil karena hanya berisi library .so untuk ABI tersebut.
Hasil build:
```
build/app/outputs/flutter-apk/app-release.apk
```
Instalasi ke perangkat ARM64:
```
adb install -r build/app/outputs/flutter-apk/app-release.apk
```
Gunakan opsi ini untuk build internal atau pengujian perangkat dengan arsitektur tunggal.

f. Membangun App Bundle (AAB) untuk Play Store
```
flutter build appbundle --release
```
Menghasilkan file .aab (Android App Bundle), yang merupakan format resmi dan wajib untuk distribusi aplikasi di Google Play Store.
Google Play akan otomatis memecah AAB menjadi APK yang disesuaikan berdasarkan:
- ABI perangkat pengguna
- Densitas layar
- Bahasa sistem
Hasil build:
```
build/app/outputs/bundle/release/app-release.aab
```
File .aab tidak dapat diinstal manual menggunakan adb install.
Distribusi hanya dilakukan melalui Google Play Console.

g. Melihat ABI dalam APK yang Telah Dibangun
```
unzip -l build/app/outputs/flutter-apk/app-release.apk | grep lib/
```
Perintah ini menampilkan isi folder lib/ dalam APK dan menunjukkan ABI apa saja yang ada di dalamnya.
Contoh hasil:
```
lib/arm64-v8a/libflutter.so
lib/armeabi-v7a/libflutter.so
lib/x86_64/libflutter.so
```
Jika terdapat beberapa folder ABI, maka APK tersebut adalah Universal APK.

h. Melihat Daftar ABI di Semua APK Split
```
ls build/app/outputs/flutter-apk/
```
Menampilkan daftar semua file APK hasil proses build, sehingga kamu bisa memeriksa setiap versi berdasarkan ABI.
Contoh hasil:
```
app-arm64-v8a-release.apk
app-armeabi-v7a-release.apk
app-x86_64-release.apk
```

i. Membersihkan Cache Build Sebelum Rebuild
```
flutter clean
flutter pub get
```
Digunakan untuk menghapus hasil build dan cache dependency sebelumnya, kemudian mengunduh ulang semua paket.
Langkah ini disarankan sebelum melakukan build rilis baru agar tidak terjadi konflik versi library atau plugin.

j. Proses Build Lengkap (Rekomendasi Workflow)
Contoh alur lengkap dari awal hingga distribusi:
1. Membersihkan build sebelumnya
```
flutter clean
flutter pub get
```
2. Mengecek perangkat dan ABI-nya
```
adb devices
adb shell getprop ro.product.cpu.abilist
```
3. Membangun Split APK (direkomendasikan untuk pengujian)
```
flutter build apk --release --split-per-abi
```
4. Menginstal hasil build ke perangkat ARM64
```
adb install -r build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```
5. Membangun AAB untuk rilis di Play Store
```
flutter build appbundle --release
```
Ringkasan:
- Gunakan Split-per-ABI untuk testing lokal (file lebih kecil, instalasi lebih cepat).
- Gunakan App Bundle (AAB) untuk distribusi resmi di Play Store.
- Gunakan Target ABI bila aplikasi hanya dijalankan di lingkungan tertentu.

## 13. Glosarium / Istilah
Berikut beberapa istilah penting yang sering digunakan dalam pembahasan ABI (Application Binary Interface) pada Flutter dan Android:
| Istilah                                | Penjelasan                                                                                                                                                                                        |
| -------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **ABI (Application Binary Interface)** | Antarmuka biner antara aplikasi dan sistem operasi yang menentukan bagaimana kode biner dieksekusi pada arsitektur CPU tertentu.                                                                  |
| **NDK (Native Development Kit)**       | Sekumpulan alat dan library resmi dari Android yang digunakan untuk menulis dan mengompilasi kode native (C/C++) agar dapat dijalankan di Android.                                                |
| **`.so` (Shared Object)**              | File library hasil kompilasi kode native yang dapat digunakan bersama oleh aplikasi. Berisi fungsi dan logika yang dijalankan langsung oleh CPU. Lokasinya biasanya di dalam folder `lib/<ABI>/`. |
| **AAB (Android App Bundle)**           | Format distribusi resmi aplikasi Android di Google Play. Google Play akan membagi AAB menjadi beberapa APK sesuai perangkat pengguna.                                                             |
| **APK (Android Package)**              | Format paket aplikasi Android yang berisi kode, resource, dan library siap dijalankan pada perangkat.                                                                                             |
| **AGP (Android Gradle Plugin)** | Plugin utama yang digunakan oleh Gradle untuk membangun aplikasi Android. AGP mengatur proses kompilasi, pengemasan, dan optimasi aplikasi, termasuk konfigurasi build per ABI, proguard, serta resource shrinking. Flutter secara internal memanggil AGP melalui Gradle saat menjalankan perintah `flutter build`. |
| **ARM / ARM64**                        | Arsitektur CPU yang umum digunakan di sebagian besar perangkat Android modern. ARM64 (arm64-v8a) adalah versi 64-bit yang lebih cepat dan efisien dibanding ARM 32-bit (armeabi-v7a).             |
| **x86 / x86_64**                       | Arsitektur CPU berbasis Intel, umumnya digunakan pada emulator Android, bukan perangkat fisik.                                                                                                    |
| **Gradle**                             | Sistem build yang digunakan oleh Android Studio dan Flutter untuk mengelola dependensi, kompilasi, dan konfigurasi build aplikasi.                                                                |
| **`flutter build`**                    | Perintah CLI Flutter untuk membangun aplikasi dalam format APK, AAB, atau iOS build.                                                                                                              |
| **ADB (Android Debug Bridge)**         | Alat baris perintah untuk berkomunikasi dengan perangkat Android. Dapat digunakan untuk instalasi, debugging, atau memeriksa properti sistem seperti ABI.                                         |
| **ProGuard / R8**                      | Alat optimasi yang digunakan untuk mengecilkan ukuran APK dengan cara menghapus kode yang tidak digunakan dan mengompresi bytecode.                                                               |


## 14. Referensi
- Flutter Documentation =? https://docs.flutter.dev/deployment/android
- Android Developers => https://developer.android.com/ndk/guides/abis
- Android Studio Build Configuration => https://developer.android.com/studio/build/configure-apk-splits
- Flutter CLI Reference => https://docs.flutter.dev/reference/flutter-cli
