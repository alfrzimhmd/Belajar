import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'addnote_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

// Model data untuk satu catatan
class Note {
  String id; // ID unik setiap catatan
  String title; // Judul catatan
  String content; // Isi catatan
  DateTime createdAt; // Waktu catatan dibuat
  DateTime updatedAt; // Waktu catatan terakhir diperbarui

  // Konstruktor
  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  // Mengubah objek Note menjadi Map (untuk disimpan dalam JSON)
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  // Membuat objek Note dari Map (saat mengambil dari JSON)
  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );
}

// State utama halaman catatan
class _NotesPageState extends State<NotesPage> {
  List<Note> _notes = []; // Menyimpan semua catatan
  final _searchController = TextEditingController(); // Controller input pencarian
  String _searchQuery = ''; // Menyimpan teks pencarian

  @override
  void initState() {
    super.initState();
    _loadNotes(); // Memuat catatan saat halaman dibuka
    _searchController.addListener(() {
      setState(() {
        // Update teks pencarian setiap kali user mengetik
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  // Fungsi untuk memuat catatan dari SharedPreferences
  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance(); // Ambil instance SharedPreferences
    final String? notesString = prefs.getString('notes'); // Ambil data string 'notes'

    if (notesString != null) {
      // Jika data ada, decode dari JSON
      final List<dynamic> jsonList = json.decode(notesString);
      setState(() {
        // Ubah setiap item JSON menjadi objek Note
        _notes = jsonList.map((json) => Note.fromJson(json)).toList();
        _sortNotesByDate(); // Urutkan catatan berdasarkan tanggal update
      });
    }
  }

  // Fungsi untuk menyimpan catatan ke SharedPreferences
  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    // Ubah list Note menjadi JSON string
    final String notesString = json.encode(
      _notes.map((note) => note.toJson()).toList(),
    );
    await prefs.setString('notes', notesString); // Simpan ke storage lokal
  }

  // Mengurutkan catatan dari yang terbaru berdasarkan updatedAt
  void _sortNotesByDate() {
    _notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  // Mendapatkan daftar catatan yang sesuai dengan pencarian
  List<Note> get _filteredNotes {
    if (_searchQuery.isEmpty) return _notes; // Jika tidak mencari, tampilkan semua
    // Filter catatan yang mengandung kata kunci di judul atau isi
    return _notes.where((note) {
      return note.title.toLowerCase().contains(_searchQuery) ||
          note.content.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  // Pindah ke halaman tambah catatan baru
  void _navigateToAddNote() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNotePage()),
    );

    // Jika pengguna menambah catatan baru, reload data
    if (result == true) {
      _loadNotes();
    }
  }

  // Pindah ke halaman edit catatan
  void _navigateToEditNote(Note note) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNotePage(note: note),
      ),
    );

    // Jika catatan diedit, reload data
    if (result == true) {
      _loadNotes();
    }
  }

  // Menghapus sebuah catatan
  void _deleteNote(Note note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Catatan?'),
        content: Text('Yakin ingin menghapus "${note.title}"?'),
        actions: [
          // Tombol batal
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          // Tombol hapus
          TextButton(
            onPressed: () {
              setState(() {
                // Hapus catatan dari list
                _notes.removeWhere((n) => n.id == note.id);
              });
              _saveNotes(); // Simpan perubahan
              Navigator.pop(context);

              // Tampilkan notifikasi berhasil
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('"${note.title}" berhasil dihapus'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _logout() {
    Navigator.pushReplacementNamed(context, '/splash');
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotes = _filteredNotes; // Ambil catatan sesuai pencarian

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Catatan Saya',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
            color: Colors.white,
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Kelola catatan pribadi Anda',
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                Text(
                  'Buat, edit, dan hapus catatan dengan mudah',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Bagian kolom pencarian
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            elevation: 2,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.search, size: 18, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Cari Catatan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _searchController, 
                    decoration: InputDecoration(
                      hintText: 'Cari berdasarkan judul atau isi catatan...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            elevation: 2,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Total', _notes.length.toString(), Icons.note),
                  _buildStatItem('Ditemukan', filteredNotes.length.toString(),
                      Icons.search),
                  _buildStatItem(
                    'Terbaru',
                    _notes.isNotEmpty
                        ? _formatDate(_notes.first.updatedAt)
                        : '-',
                    Icons.access_time,
                  ),
                ],
              ),
            ),
          ),

          // Daftar catatan
          Expanded(
            child: filteredNotes.isEmpty
                ? Center(
                    // Jika belum ada catatan
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _searchQuery.isEmpty
                              ? Icons.note_add_outlined
                              : Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'Belum ada catatan'
                              : 'Tidak ada hasil pencarian',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        if (_searchQuery.isEmpty)
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Klik + untuk buat catatan pertama!',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = filteredNotes[index];
                      return _buildNoteItem(note); 
                    },
                  ),
          ),
        ],
      ),
      // Tombol tambah catatan
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddNote,
        backgroundColor: Colors.blue[800],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.blue[700]),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue[700],
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildNoteItem(Note note) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue[100],
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.note_outlined,
            color: Colors.blue[700],
          ),
        ),
        title: Text(
          note.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              note.content.isEmpty ? '(Tidak ada konten)' : note.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: note.content.isEmpty ? Colors.grey : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Diperbarui: ${_formatDate(note.updatedAt)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        // Menu edit dan hapus
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red, size: 20),
                  SizedBox(width: 8),
                  Text('Hapus', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          // Aksi saat menu dipilih
          onSelected: (value) {
            if (value == 'edit') {
              _navigateToEditNote(note);
            } else if (value == 'delete') {
              _deleteNote(note);
            }
          },
        ),
        // Ketika diklik, buka halaman edit
        onTap: () => _navigateToEditNote(note),
      ),
    );
  }

  // Fungsi untuk memformat tanggal
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hari ini';
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
