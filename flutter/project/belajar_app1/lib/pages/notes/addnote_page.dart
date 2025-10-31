import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../notes/notes_page.dart';

class AddNotePage extends StatefulWidget {
  // Jika ada catatan yang dikirim, berarti halaman ini dalam mode "edit"
  final Note? note;

  // Konstruktor widget dengan parameter opsional "note"
  const AddNotePage({super.key, this.note});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

// State untuk mengelola logika dan data pada halaman AddNotePage
class _AddNotePageState extends State<AddNotePage> {
  // Controller untuk input judul dan isi catatan
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  // Penanda apakah sedang dalam mode edit atau buat baru
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();

    // Jika ada note yang dikirim dari halaman sebelumnya, masuk mode edit
    if (widget.note != null) {
      _isEditing = true;
      // Tampilkan isi catatan lama pada TextField
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  // Fungsi untuk menyimpan catatan ke SharedPreferences
  Future<void> _saveNote() async {
    // Ambil input judul dan isi dari TextField
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    // Validasi: judul tidak boleh kosong
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Judul tidak boleh kosong!'),
          backgroundColor: Colors.red,
        ),
      );
      return; // hentikan proses jika judul kosong
    }

    // Dapatkan instance SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // Ambil daftar catatan yang sudah ada sebelumnya
    final String? notesString = prefs.getString('notes');
    List<Note> notes = [];

    // Jika ada data catatan tersimpan, decode dari JSON menjadi list objek Note
    if (notesString != null) {
      final List<dynamic> jsonList = json.decode(notesString);
      notes = jsonList.map((json) => Note.fromJson(json)).toList();
    }

    if (_isEditing) {
      // Mode edit: update catatan yang sudah ada
      final noteIndex = notes.indexWhere((n) => n.id == widget.note!.id);
      if (noteIndex != -1) {
        // Ubah nilai catatan sesuai input terbaru
        notes[noteIndex].title = title;
        notes[noteIndex].content = content;
        notes[noteIndex].updatedAt = DateTime.now();
      }
    } else {
      // buat catatan baru dan tambahkan ke list
      final newNote = Note(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        content: content,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      notes.add(newNote);
    }

    // Simpan kembali daftar catatan ke SharedPreferences dalam format JSON
    final String updatedNotesString =
        json.encode(notes.map((note) => note.toJson()).toList());
    await prefs.setString('notes', updatedNotesString);

    // Tutup halaman dan kirim hasil ke halaman sebelumnya
    Navigator.pop(context, true);

    // Tampilkan pesan berhasil
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEditing
              ? 'Catatan berhasil diperbarui!'
              : 'Catatan berhasil dibuat!',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Fungsi untuk menangani tombol kembali
  void _onBackPressed() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    // Jika ada teks yang belum disimpan, tampilkan dialog konfirmasi
    if (title.isNotEmpty || content.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Simpan Perubahan?'),
          content: const Text('Anda memiliki perubahan yang belum disimpan.'),
          actions: [
            // Tombol batal menutup dialog
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            // Tombol keluar tanpa menyimpan
            TextButton(
              onPressed: () {
                Navigator.pop(context); // tutup dialog
                Navigator.pop(context); // kembali ke halaman sebelumnya
              },
              child: const Text('Tidak Simpan'),
            ),
            // Tombol simpan perubahan
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _saveNote(); // simpan data sebelum keluar
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      );
    } else {
      // Jika belum ada perubahan, langsung kembali
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Struktur utama halaman menggunakan Scaffold
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        // Judul berubah tergantung mode edit atau tambah
        title: Text(
          _isEditing ? 'Edit Catatan' : 'Catatan Baru',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        elevation: 4,

        // Tombol kembali di kiri atas
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _onBackPressed,
          color: Colors.white,
        ),

        // Tombol simpan di kanan atas
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
            tooltip: 'Simpan',
            color: Colors.white,
          ),
        ],
      ),

      // Bagian isi halaman
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Bagian judul halaman
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: Column(
                children: [
                  Text(
                    'Tulis catatan Anda',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Judul dan konten akan disimpan secara otomatis',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // INPUT JUDUL CATATAN 
            Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              elevation: 2,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.title, size: 18, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'Judul Catatan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // TextField untuk input judul
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan judul catatan...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),

            // INPUT ISI CATATAN 
            Expanded(
              child: Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                elevation: 2,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.description, size: 18, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            'Konten Catatan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // TextField untuk isi catatan
                      Expanded(
                        child: TextField(
                          controller: _contentController,
                          decoration: InputDecoration(
                            hintText: 'Tulis isi catatan Anda di sini...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                            alignLabelWithHint: true,
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                          ),
                          maxLines: null, 
                          expands: true, 
                          textAlignVertical: TextAlignVertical.top,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // TOMBOL SIMPAN 
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ElevatedButton.icon(
                onPressed: _saveNote,
                icon: const Icon(Icons.save, size: 20),
                label: Text(
                  _isEditing ? 'Update Catatan' : 'Simpan Catatan',
                  style: const TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
