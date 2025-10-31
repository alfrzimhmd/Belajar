import 'package:flutter/material.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

// State dari halaman CounterPage.
class _CounterPageState extends State<CounterPage> {
  int _counter = 0; // Menyimpan nilai counter saat ini.
  String _message = 'Selamat Datang ';

  // Fungsi untuk menambah nilai
  void _incrementCounter() {
    setState(() {
      _counter++;
      _updateMessage(); // Update pesan setiap kali counter berubah.
    });
  }

  // Fungsi untuk mengurangi nilai
  void _decrementCounter() {
    setState(() {
      if (_counter > 0) _counter--; // Tidak boleh kurang dari 0.
      _updateMessage();
    });
  }

  // Fungsi untuk mengembalikan nilai
  void _resetCounter() {
    setState(() {
      _counter = 0;
      _updateMessage();
    });
  }

  // Fungsi untuk memperbarui pesan berdasarkan nilai counter.
  void _updateMessage() {
    if (_counter == 0) {
      _message = 'Tekan Tombol Ini!!!';
    } else {
      _message = 'Kamu sudah menekan $_counter Kali!!!';
    }
  }

  void _logout() {
    Navigator.pushReplacementNamed(context, '/splash');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar 
      appBar: AppBar(
        title: const Text(
          'Counter ++',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
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

      // Bagian isi utama halaman
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[50]!,
              Colors.blue[100]!,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.flutter_dash, size: 100, color: Colors.blue),

              const SizedBox(height: 20),

              Text(
                _message,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Tampilan angka counter dalam sebuah kartu
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Text(
                  '$_counter', // Menampilkan nilai counter
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Deretan tombol aksi (Kurang, Reset, Tambah)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Tombol Kurangi (-)
                  ElevatedButton(
                    onPressed: _decrementCounter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.remove),
                        SizedBox(width: 5),
                        Text('Kurang'),
                      ],
                    ),
                  ),

                  // Tombol Reset (0)
                  ElevatedButton(
                    onPressed: _resetCounter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.refresh),
                        SizedBox(width: 5),
                        Text('Reset'),
                      ],
                    ),
                  ),

                  // Tombol Tambah (+)
                  ElevatedButton(
                    onPressed: _incrementCounter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.add),
                        SizedBox(width: 5),
                        Text('Tambah'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Tekan tombol-tombol di atas dan lihat perubahan yang terjadi.',
                  style: TextStyle(
                    fontSize: 18, color: Colors.black54, fontWeight: FontWeight.bold,),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
