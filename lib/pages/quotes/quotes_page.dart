import 'package:flutter/material.dart';

class QuotesPage extends StatefulWidget {
  const QuotesPage({super.key});

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  /// List kutipan utama (teks + penulis)
  final List<Map<String, String>> _quotes = [
    {
      'text': 'Satu-satunya cara untuk melakukan pekerjaan hebat adalah dengan mencintai apa yang kamu lakukan.',
      'author': 'Steve Jobs'
    },
    {
      'text': 'Inovasi membedakan antara pemimpin dan pengikut.',
      'author': 'Steve Jobs'
    },
    {
      'text': 'Waktumu terbatas, jadi jangan sia-siakan dengan hidup seperti orang lain.',
      'author': 'Steve Jobs'
    },
    {
      'text': 'Tetaplah lapar, tetaplah bodoh.',
      'author': 'Steve Jobs'
    },
    {
      'text': 'Masa depan adalah milik mereka yang percaya pada keindahan mimpi mereka.',
      'author': 'Eleanor Roosevelt'
    },
    {
      'text': 'Kesuksesan bukanlah akhir, kegagalan bukanlah hal yang fatal: keberanian untuk melanjutkanlah yang penting.',
      'author': 'Winston Churchill'
    },
    {
      'text': 'Cara untuk memulai adalah dengan berhenti berbicara dan mulai melakukan.',
      'author': 'Walt Disney'
    },
    {
      'text': 'Jika hidup bisa diprediksi, itu akan berhenti menjadi hidup, dan menjadi tanpa rasa.',
      'author': 'Eleanor Roosevelt'
    },
    {
      'text': 'Hidup adalah tentang membuat dampak, bukan hanya membuat penghasilan.',
      'author': 'Kevin Kruse'
    },
    {
      'text': 'Whatever you are, be a good one.',
      'author': 'Abraham Lincoln'
    },
    {
      'text': 'Percayalah kamu bisa, maka kamu sudah setengah jalan mencapainya.',
      'author': 'Theodore Roosevelt'
    },
    {
      'text': 'Kegagalan adalah kesempatan untuk memulai lagi dengan lebih cerdas.',
      'author': 'Henry Ford'
    },
    {
      'text': 'Kamu tidak perlu menjadi hebat untuk memulai, tapi kamu harus memulai untuk menjadi hebat.',
      'author': 'Zig Ziglar'
    },
    {
      'text': 'Keberanian bukan berarti tidak takut, tetapi tetap melangkah meskipun takut.',
      'author': 'Nelson Mandela'
    },
    {
      'text': 'Jangan menunggu waktu yang sempurna, ambillah waktu dan buatlah itu sempurna.',
      'author': 'Unknown'
    },
    {
      'text': 'Kerja keras mengalahkan bakat ketika bakat tidak bekerja keras.',
      'author': 'Tim Notke'
    },
    {
      'text': 'Bukan seberapa keras kamu jatuh, tapi seberapa cepat kamu bangkit kembali.',
      'author': 'Vince Lombardi'
    },
    {
      'text': 'Jika kamu ingin bahagia, jangan bergantung pada orang lain. Bergantunglah pada dirimu sendiri.',
      'author': 'Dalai Lama'
    },
  ];

  /// Kutipan yang sedang ditampilkan
  Map<String, String> _currentQuote = {};

  /// Daftar kutipan favorit pengguna
  final List<Map<String, String>> _favorites = [];

  @override
  void initState() {
    super.initState();
    _getRandomQuote(); // Ambil kutipan acak saat halaman dibuka
  }

  /// Fungsi untuk mendapatkan kutipan acak
  void _getRandomQuote() {
    setState(() {
      _currentQuote =
      _quotes[DateTime.now().millisecondsSinceEpoch % _quotes.length];
    });
  }

  /// Menambahkan / menghapus kutipan dari daftar favorit
  void _toggleFavorite() {
    setState(() {
      if (_favorites.contains(_currentQuote)) {
        _favorites.remove(_currentQuote);
      } else {
        _favorites.add(_currentQuote);
      }
    });
  }

  /// Logout dan kembali ke halaman splash
  void _logout() {
    Navigator.pushReplacementNamed(context, '/splash');
  }

  /// Mengecek apakah kutipan saat ini sudah difavoritkan
  bool get _isFavorite => _favorites.contains(_currentQuote);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Kutipan Inspiratif',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 23,
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

      // Scroll agar konten panjang tetap bisa dilihat
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Temukan motivasi harianmu ',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                '${_quotes.length} kutipan tersedia',
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 25),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[50]!, Colors.blue[100]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withAlpha(2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(Icons.format_quote,
                        size: 50, color: Colors.blue[400]),
                    const SizedBox(height: 20),

                    // Teks kutipan
                    Text(
                      _currentQuote['text'] ??
                          'Klik tombol di bawah untuk mendapatkan kutipan.',
                      style: const TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: Colors.black87,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // Nama penulis
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.blue[200]!),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withAlpha(1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '- ${_currentQuote['author'] ?? ''}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Tombol Aksi
              Row(
                children: [
                  // Tombol Favorit
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _toggleFavorite,
                      icon: Icon(
                        _isFavorite
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        color: _isFavorite ? Colors.white : Colors.red,
                      ),
                      label: Text(
                        _isFavorite ? 'Disukai' : 'Sukai',
                        style: TextStyle(
                          color: _isFavorite ? Colors.white : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        _isFavorite ? Colors.red : Colors.red[50],
                        foregroundColor:
                        _isFavorite ? Colors.white : Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),

                  // Tombol Kutipan Baru
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _getRandomQuote,
                      icon: const Icon(Icons.refresh, color: Colors.blue),
                      label: const Text(
                        'Kutipan Baru',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[50],
                        foregroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              const Divider(thickness: 1, color: Colors.grey),
              const SizedBox(height: 20),

              // --- Daftar Favorit ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite, size: 24, color: Colors.red),
                  const SizedBox(width: 10),
                  const Text(
                    'Kutipan Favorit',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Jumlah favorit
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_favorites.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Kutipan yang paling menginspirasimu',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),

              // List Favorit
              SizedBox(
                height: 300,
                child: _favorites.isEmpty
                    ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border,
                          size: 70, color: Colors.grey),
                      SizedBox(height: 20),
                      Text(
                        'Belum ada kutipan favorit',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Tekan tombol "Sukai" untuk\nmenyimpan kutipan favoritmu',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  itemCount: _favorites.length,
                  itemBuilder: (context, index) {
                    final quote = _favorites[index];
                    return Card(
                      margin:
                      const EdgeInsets.symmetric(vertical: 8),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.format_quote,
                              color: Colors.red[300], size: 22),
                        ),
                        title: Text(
                          quote['text']!,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 15,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            '- ${quote['author']!}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                              fontSize: 13,
                            ),
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.red, size: 22),
                          onPressed: () {
                            setState(() {
                              _favorites.removeAt(index);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
