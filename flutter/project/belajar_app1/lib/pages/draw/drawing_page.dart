import 'package:flutter/material.dart';

// Halaman utama untuk menggambar di kanvas
class DrawingPage extends StatefulWidget {
  const DrawingPage({super.key});

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

// State class tempat logika dan state disimpan
class _DrawingPageState extends State<DrawingPage> {
  // Daftar semua titik atau garis yang digambar
  final List<DrawingPoint> _points = [];

  // Nilai default ketebalan brush
  double _strokeWidth = 3.0;

  // Warna aktif untuk brush
  Color _currentColor = Colors.black;

  // Daftar warna yang tersedia di palet
  final List<Color> _colors = [
    Colors.black,
    Colors.white,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.grey,
    Colors.teal,
  ];

  // Fungsi untuk menghapus semua gambar di kanvas
  void _clearCanvas() {
    setState(() {
      _points.clear();
    });
  }

  // Fungsi untuk menghapus garis terakhir (Undo)
  void _undo() {
    setState(() {
      if (_points.isNotEmpty) {
        _points.removeLast();
      }
    });
  }

  // Fungsi untuk logout dan kembali ke halaman splash
  void _logout() {
    Navigator.pushReplacementNamed(context, '/splash');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],

      // AppBar 
      appBar: AppBar(
        title: const Text(
          'Drawing Canvas',
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
          // Tombol logout 
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
            color: Colors.white,
          ),
        ],
      ),

      // Isi utama halaman
      body: Column(
        children: [
          // Deskripsi singkat di bagian atas
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Gambar bebas di kanvas ',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                Text(
                  'Pilih warna dan ukuran brush, lalu mulailah menggambar',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 17,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Bagian pengaturan warna dan ukuran brush
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
                      Icon(Icons.palette, size: 18, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Pilihan Warna',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _colors.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          // Saat warna dipilih, ubah warna aktif
                          onTap: () {
                            setState(() {
                              _currentColor = _colors[index];
                            });
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              color: _colors[index],
                              shape: BoxShape.circle,
                              // Warna aktif diberi border hitam
                              border: Border.all(
                                color: _currentColor == _colors[index]
                                    ? Colors.black
                                    : Colors.transparent,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withAlpha(80),
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  Divider(
                    color: Colors.grey.shade300,
                    height: 1,
                  ),
                  const SizedBox(height: 12),

                  const Row(
                    children: [
                      Icon(Icons.brush, size: 18, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Ukuran Brush',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Slider pengatur ukuran brush
                  Row(
                    children: [
                      const Icon(Icons.brush, size: 18, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Slider(
                          value: _strokeWidth,
                          min: 1.0,
                          max: 20.0,
                          divisions: 19,
                          onChanged: (value) {
                            setState(() {
                              _strokeWidth = value;
                            });
                          },
                        ),
                      ),
                      const Icon(Icons.brush, size: 24, color: Colors.grey),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Text(
                          '${_strokeWidth.toInt()}px',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Area kanvas untuk menggambar
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha(2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    // GestureDetector menangkap gerakan jari
                    child: GestureDetector(
                      onPanStart: (details) {
                        setState(() {
                          _points.add(DrawingPoint(
                            offset: details.localPosition,
                            color: _currentColor,
                            strokeWidth: _strokeWidth,
                          ));
                        });
                      },
                      onPanUpdate: (details) {
                        // Saat jari bergerak (menambah titik baru)
                        setState(() {
                          _points.add(DrawingPoint(
                            offset: details.localPosition,
                            color: _currentColor,
                            strokeWidth: _strokeWidth,
                          ));
                        });
                      },
                      onPanEnd: (details) {
                        setState(() {
                          _points.add(DrawingPoint(
                            offset: const Offset(-1, -1),
                            color: _currentColor,
                            strokeWidth: _strokeWidth,
                          ));
                        });
                      },

                      // Stack untuk lapisan grid, gambar, dan pesan kosong
                      child: Stack(
                        children: [
                          CustomPaint(
                            painter: _GridPainter(),
                            size: Size.infinite,
                          ),

                          CustomPaint(
                            painter: DrawingPainter(points: _points),
                            size: Size.infinite,
                          ),

                          if (_points.isEmpty)
                            const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.brush,
                                      size: 60, color: Colors.grey),
                                  SizedBox(height: 10),
                                  Text(
                                    'Mulai menggambar di sini',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Gunakan jari untuk menggambar\npada area kanvas',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Tombol kontrol (Undo dan Clear)
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[100],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _undo,
                          icon: const Icon(Icons.undo, size: 20),
                          label: const Text('Undo'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _clearCanvas,
                          icon: const Icon(Icons.clear, size: 20),
                          label: const Text('Clear All'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Kelas untuk menyimpan titik (posisi, warna, ukuran brush)
class DrawingPoint {
  final Offset offset;
  final Color color;
  final double strokeWidth;

  DrawingPoint({
    required this.offset,
    required this.color,
    required this.strokeWidth,
  });
}

// Painter utama untuk menggambar garis berdasarkan titik-titik
class DrawingPainter extends CustomPainter {
  final List<DrawingPoint> points;

  DrawingPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Loop untuk menggambar garis antar titik
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i].offset.dx != -1 &&
          points[i + 1].offset.dx != -1 &&
          points[i].color == points[i + 1].color &&
          points[i].strokeWidth == points[i + 1].strokeWidth) {
        paint
          ..color = points[i].color
          ..strokeWidth = points[i].strokeWidth;

        canvas.drawLine(points[i].offset, points[i + 1].offset, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[100]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Membuat garis grid dengan jarak antar garis 20 piksel
    const step = 20.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
