# Catatan Perintah Bash & Git

## Perintah Dasar Bash (Navigasi & File/Folder)

| Perintah | Fungsi |
|----------|--------|
| 1. `pwd` | Menampilkan lokasi direktori saat ini (Print Working Directory). |
| 2. `ls` | Menampilkan daftar file & folder di direktori saat ini. |
| 3. `ls -a` | Menampilkan semua file termasuk file tersembunyi (hidden files). |
| 4. `cd [nama_folder]` | Masuk ke folder tertentu. |
| 5. `cd ..` | Naik satu level folder (keluar ke folder induk). |
| 6. `mkdir [nama_folder]` | Membuat folder baru. |
| 7. `touch [nama_file]` | Membuat file kosong baru. |
| 8. `echo "isi teks" > [nama_file]` | Membuat file dengan isi teks. Kalau file sudah ada, isinya ditimpa. |
| 9. `echo "isi teks" >> [nama_file]` | Menambahkan teks ke baris akhir file (append). |
|10. `cat [nama_file]` | Melihat isi file. |
|11. `rm [nama_file]` | Menghapus file. |
|12.  `rm -r [nama_folder]` | Menghapus folder beserta isinya. |
|13.  `clear` | Membersihkan layar terminal. |
|14.  `history` | Menampilkan daftar perintah yang sudah dijalankan. |
|15.  `cp [sumber] [tujuan]` | Menyalin file/folder. |
|16.  `mv [sumber] [tujuan]` | Memindahkan/rename file/folder. |

## Perintah Dasar Git (Setup Awal)

| Perintah | Fungsi |
|----------|--------|
| 1. `git init` | Membuat repo Git baru di folder lokal. |
| 2. `git status` | Mengecek status repo (file baru, diubah, siap commit, dsb). |
| 3. `git config --global user.name "NamaKamu"` | Menyetel nama global Git (ditampilkan di setiap commit). |
| 4. `git config --global user.email "email@example.com"` | Menyetel email global Git. |
| 5. `git config --list` | Menampilkan semua konfigurasi Git. |


## Workflow Git Dasar (Tambah File → Commit → Push)

| Perintah | Fungsi |
|----------|--------|
| 1. `git add [nama_file]` | Menambahkan file tertentu ke staging area. |
| 2. `git add .` | Menambahkan semua file baru/ubah ke staging area. |
| 3. `git commit -m "pesan commit"` | Membuat commit dengan pesan singkat. |
| 4. `git log` | Melihat riwayat commit. |
| 5. `git log --oneline` | Melihat riwayat commit singkat. |

---

## Hubungkan ke GitHub
Tambahkan remote GitHub (sekali saja):
```bash
"git remote add origin https://github.com/username/nama-repo.git"
fungsi : Menghubungkan repo lokal dengan repo remote di GitHub.

## Cek remote:
git remote -v
Fungsi: Melihat daftar remote (origin → fetch & push).

##Push pertama kali (set upstream):
git push -u origin main
Fungsi: Mengirim branch main ke GitHub dan menghubungkannya dengan remote.
Setelah itu cukup:
git push
Fungsi: Mengirim commit terbaru ke GitHub.
Kalau ada update di GitHub, ambil ke lokal:
git pull

## Membuat Folder & File Baru, lalu Push
1. mkdir docs                        # Membuat folder baru bernama docs
2. cd docs                           # Masuk ke folder docs
3. echo "Dokumentasi" > info.txt     # Membuat file info.txt dengan isi teks
4. cd ..                             # Kembali ke root repo
5. git add docs/                     # Menambahkan folder docs ke staging
6. git commit -m "Tambah folder docs berisi info.txt"
7. git push                          # Mengirim commit ke GitHub

## Trik Tambahan Git
Perintah   | 	Fungsi
git branch	| Menampilkan daftar branch lokal.
git checkout -b [nama_branch]	| Membuat branch baru dan langsung pindah ke branch itu.
git checkout [nama_branch]	| Pindah ke branch tertentu.
git diff	| Menampilkan perbedaan (diff) file yang diubah sebelum commit.
git reset [nama_file] |	Membatalkan staging file (sebelum commit).
git rm [nama_file]	| Menghapus file sekaligus mencatat penghapusan di commit.
git stash	| Menyimpan sementara perubahan yang belum di-commit.
git stash pop	| Mengembalikan perubahan terakhir yang disimpan dengan stash.
git clone [url] |	Mengunduh (clone) repo GitHub ke komputer lokal.
git fetch |	Mengambil update terbaru dari remote tanpa menggabungkan ke branch lokal.
git merge [nama_branch]	| Menggabungkan branch lain ke branch aktif saat ini.
