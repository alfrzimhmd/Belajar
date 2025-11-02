# Workflow Git & GitHub: Konfigurasi, Kolaborasi, dan Sinkronisasi Proyek Android Studio / VS Code

> Dokumen ini menjelaskan secara mendalam mengenai konsep **Git** dan **GitHub**, serta langkah-langkah praktis dalam penggunaannya untuk mengelola proyek pengembangan perangkat lunak, khususnya menggunakan **Android Studio** dan **Visual Studio Code**.  
> Pembahasan mencakup pengertian dasar, instalasi, konfigurasi, workflow, cloning repository, kolaborasi, hingga tips manajemen versi proyek.

---

## Daftar Isi


- [1. Pengertian Git dan GitHub](#1-pengertian-git-dan-github)
- [2. Instalasi dan Konfigurasi Awal Git di Windows](#2-instalasi-dan-konfigurasi-awal-git-di-windows)
- [3. Perintah Dasar Bash di Terminal VS Code](#3-perintah-dasar-bash-di-terminal-vs-code)
- [4. Dasar Penggunaan Git (Workflow Lokal)](#4-dasar-penggunaan-git-workflow-lokal)
- [5. Menghubungkan Repository Lokal ke GitHub](#5-menghubungkan-repository-lokal-ke-github)
- [6. Workflow Lengkap: Commit, Push, dan Pull](#6-workflow-lengkap-commit-push-dan-pull)
- [7. Branching dan Penggabungan (Merge)](#7-branching-dan-penggabungan-merge)
- [8. Cloning Repository](#8-cloning-repository)
- [9. Sinkronisasi dan Update Proyek](#9-sinkronisasi-dan-update-proyek)
- [10. Kolaborasi dalam Satu Proyek](#10-kolaborasi-dalam-satu-proyek)
- [11. Perintah Git Lengkap dengan Komentar](#11-perintah-git-lengkap-dengan-komentar)
- [12. Praktik Terbaik dan Tips Penggunaan Git](#12-praktik-terbaik-dan-tips-penggunaan-git)
- [13. Glosarium ](#13-glosarium)
- [14. Referensi Resmi](#14-referensi-resmi)

---

## 1. Pengertian Git dan GitHub

**Git** adalah sistem kontrol versi terdistribusi (Distributed Version Control System) yang digunakan untuk mencatat setiap perubahan kode pada suatu proyek.  
Dengan Git, setiap versi proyek dapat disimpan, dilacak, dan dikembalikan ke kondisi sebelumnya tanpa kehilangan data.

**GitHub** adalah layanan berbasis cloud yang menyediakan penyimpanan dan pengelolaan repository Git secara daring. GitHub memudahkan kolaborasi antar-developer dengan menyediakan fitur seperti **branching, pull request, issue tracking, dan code review**.

Keduanya saling terhubung:  
Git digunakan untuk bekerja secara lokal di komputer, sedangkan GitHub digunakan untuk menyimpan dan membagikan repository secara online.

---

## 2. Instalasi dan Konfigurasi Awal Git di Windows
1. **Unduh Git untuk Windows**  
   Kunjungi situs resmi: [https://git-scm.com/downloads](https://git-scm.com/downloads)
2. **Instalasi Git**  
   Jalankan file instalasi dan ikuti wizard. Biarkan semua opsi default, kecuali jika ada kebutuhan khusus.
3. **Verifikasi Instalasi**  
   ```
   git --version
   ```
   Jika Git sudah terpasang dengan benar, akan muncul versi Git yang terinstal.
4. **Konfigurasi Identitas Pengguna**
   ```
   git config --global user.name "Nama Lengkap"
   git config --global user.email "email@example.com
   ```
   Gunakan nama dan email yang sama dengan akun GitHub.
5. **Cek Konfigurasi**
   ```
   git config --list
   ```
   Menampilkan semua pengaturan Git yang aktif.

## 3. Perintah Dasar Bash di Terminal VS Code
| Perintah              | Fungsi                         |
| --------------------- | ------------------------------ |
| `pwd`                 | Menampilkan direktori aktif    |
| `ls`                  | Melihat daftar file            |
| `cd [folder]`         | Masuk ke direktori tertentu    |
| `cd ..`               | Naik satu level folder         |
| `mkdir [nama_folder]` | Membuat folder baru            |
| `touch [nama_file]`   | Membuat file baru              |
| `rm [nama_file]`      | Menghapus file                 |
| `clear`               | Membersihkan tampilan terminal |

## 4. Dasar Penggunaan Git (Workflow Lokal)
1. Inisialisasi Repository
   ```
   git init
   ```
   Membuat repository Git baru di direktori lokal proyek.
2. Menambahkan File ke Staging Area
   ```
   git add .
   ```
   Menambahkan semua file baru atau yang telah diubah ke area persiapan (staging).
3. Membuat Commit
   ```
   git commit -m "Pesan commit pertama"
   ```
   Menyimpan snapshot perubahan ke dalam riwayat repository

## 5. Menghubungkan Repository Lokal ke GitHub
1. Buat repository baru di GitHub (tanpa README.md)
2. Salin URL repository, contoh:
    ```
   https://github.com/username/nama-proyek.git
   ```
3. Hubungkan repository lokal:
   ```
   git remote add origin https://github.com/username/nama-proyek.git
   ```
   “origin” adalah nama default untuk repository remote.
4. Verifikasi koneksi:
   ```
   git remote -v
   ```
   Menampilkan alamat repository remote untuk operasi fetch dan push.

## 6. Workflow Lengkap: Commit, Push, dan Pull
1. Menambahkan semua file ke staging
   ```
   git add .
   ```
2. Membuat commit
   ```
   git commit -m "Update fitur baru"
   ```
3. Mengirim commit ke GitHub (push)
   ```
   git push -u origin main
   ```
4. Menarik pembaruan dari GitHub ke lokal (pull)
   ```
   git pull
   ```
   Setelah push -u pertama kali, selanjutnya cukup gunakan git push tanpa parameter tambahan.

## 7. Branching dan Penggabungan (Merge)
Branch digunakan untuk mengembangkan fitur baru tanpa mengganggu branch utama.
1. Membuat branch baru
   ```
   git branch fitur-login
   ```
2. Berpindah ke branch tersebut
   ```
   git checkout fitur-login
   ```
4. Setelah selesai, pindah ke main
   ```
   git checkout main
   ```
5. Gabungkan branch fitur-login ke main
   ```
   git merge fitur-login
   ```
**Untuk melihat daftar branch:**
```
git branch
```

## 8. Cloning Repository 
Cloning adalah proses menyalin seluruh repository dari GitHub ke komputer lokal.
Langkah-Langkah Cloning Repository
1. Salin URL Repository dari GitHub
   contoh :
   ```
   https://github.com/username/nama-proyek.git
   ```
2. Pilih Lokasi Penyimpanan di Komputer
   Misalnya:
   ```
   D:\Project\
   ```
3. Jalankan Perintah Clone
   ```
   git clone https://github.com/username/nama-proyek.git
   ```
   Perintah ini akan membuat folder baru nama-proyek berisi salinan repository.
4. Masuk ke Folder Hasil Clone
   ```
   cd nama-proyek
   ```
5. Verifikasi Remote
   ```
   git remote -v
   ```
   Output:
   ```
   origin  https://github.com/username/nama-proyek.git (fetch)
   origin  https://github.com/username/nama-proyek.git (push)
   ```
   Jika cloning dilakukan untuk proyek yang ingin diperbarui atau dikembangkan, maka setiap perubahan yang dilakukan dapat langsung di-push ke repository yang sama.
   Contoh Workflow Setelah Clone:
   ```
   git pull              # Ambil pembaruan terbaru dari GitHub
   git add .             # Tambahkan perubahan lokal
   git commit -m "Edit tampilan dashboard"
   git push              # Kirim hasil edit ke GitHub
   ```
**Integrasi dengan Android Studio dan VS Code:**
1. Android Studio: dapat melakukan cloning melalui menu File → New → Project from Version Control → GitHub lalu masukkan URL repository.
2. VS Code: dapat menggunakan menu Source Control → Clone Repository atau melalui perintah Ctrl+Shift+P → Git: Clone.
   
## 9. Sinkronisasi dan Update Proyek
1. Mengambil Update Terbaru dari GitHub
   ```
   git pull
   ```
   Menarik semua perubahan terbaru dari repository GitHub ke lokal.
2. Mengambil Tanpa Menggabungkan
   ```
   git fetch
   ```
   Mengambil update dari remote tanpa langsung menggabungkan.

## 10. Kolaborasi dalam Satu Proyek
Ketika bekerja bersama tim, setiap anggota biasanya membuat branch sendiri:
```
git checkout -b fitur-register
```
Setelah selesai mengembangkan fitur, lakukan:
```
git add .
git commit -m "Tambah fitur register"
git push origin fitur-register
```
Kemudian ajukan Pull Request (PR) di GitHub untuk menggabungkan branch tersebut ke branch utama.

## 11. Perintah Git Lengkap dengan Komentar
```
# Membuat repository baru
git init

# Mengecek status file
git status

# Menambahkan semua file
git add .

# Menyimpan perubahan ke commit
git commit -m "Initial commit"

# Menghubungkan ke repository GitHub
git remote add origin https://github.com/username/nama-proyek.git

# Mengirim commit ke GitHub
git push -u origin main

# Mengambil perubahan terbaru dari GitHub
git pull

# Membuat branch baru
git branch nama_branch

# Berpindah ke branch tersebut
git checkout nama_branch

# Menghapus branch
git branch -d nama_branch

# Menggabungkan branch lain
git merge nama_branch

# Menyimpan sementara perubahan (belum commit)
git stash

# Mengembalikan perubahan yang disimpan sementara
git stash pop
```

## 12. Praktik Terbaik dan Tips Penggunaan Git
- Lakukan commit secara berkala dengan pesan yang jelas
- Gunakan branch terpisah untuk setiap fitur
- Lakukan git pull sebelum melakukan perubahan
- Gunakan .gitignore untuk mengecualikan file yang tidak perlu
- Pastikan kredensial GitHub tersimpan dengan benar agar proses push tidak gagal.

## 13. Glosarium
| Istilah               | Penjelasan                                                              |
| --------------------- | ----------------------------------------------------------------------- |
| **Repository (Repo)** | Tempat penyimpanan seluruh file dan riwayat proyek.                     |
| **Commit**            | Snapshot perubahan yang disimpan ke riwayat Git.                        |
| **Branch**            | Cabang pengembangan yang memungkinkan bekerja paralel.                  |
| **Merge**             | Proses penggabungan antar-branch.                                       |
| **Remote**            | Versi repository yang tersimpan di server (GitHub).                     |
| **Clone**             | Menyalin repository dari remote ke komputer lokal.                      |
| **Pull**              | Mengambil perubahan terbaru dari remote.                                |
| **Push**              | Mengirim commit dari lokal ke remote.                                   |
| **Staging Area**      | Tempat sementara sebelum commit dibuat.                                 |
| **.gitignore**        | File konfigurasi untuk mengecualikan file tertentu agar tidak di-track. |

## 14. Referensi Resmi
- Dokumentasi Git => https://git-scm.com/docs
- Dokumentasi GitHub => https://docs.github.com/en/get-started
- Integrasi Version Control di Android Studio => https://developer.android.com/studio/intr
- Integrasi Git di Visual Studio Code => https://code.visualstudio.com/docs/sourcecontrol/overview
- Panduan GitHub CLI => https://cli.github.com/manual/


