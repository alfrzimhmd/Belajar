import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _display = '0'; 
  String _operation = ''; 
  double _num1 = 0; 
  double _num2 = 0; 
  bool _shouldReset = false; 
  final List<String> _history = []; 

  /// Fungsi utama yang dijalankan setiap tombol ditekan
  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _clearAll();
      } else if (value == '⌫') {
        _backspace();
      } else if (value == '=') {
        _calculate();
      } else if (['+', '-', '×', '÷', '%'].contains(value)) {
        _setOperation(value);
      } else {
        _inputNumber(value);
      }
    });
  }

  /// Reset semua data kalkulator
  void _clearAll() {
    _display = '0';
    _num1 = 0;
    _num2 = 0;
    _operation = '';
    _shouldReset = false;
  }

  /// Menghapus satu digit terakhir
  void _backspace() {
    if (_shouldReset) return;
    if (_display.length > 1) {
      _display = _display.substring(0, _display.length - 1);
    } else {
      _display = '0';
    }
  }

  /// Menangani input angka dan titik desimal
  void _inputNumber(String value) {
    // Jika display perlu direset setelah operasi
    if (_shouldReset) {
      _display = '0';
      _shouldReset = false;
    }

    // Cegah titik ganda
    if (value == '.' && _display.contains('.')) return;

    // Tambahkan angka baru
    if (_display == '0' && value != '.') {
      _display = value;
    } else {
      _display += value;
    }
  }

  /// Menetapkan operasi matematika
  void _setOperation(String op) {
    // Jika sudah ada operasi sebelumnya dan angka baru dimasukkan → hitung dulu
    if (_operation.isNotEmpty && !_shouldReset) {
      _calculate();
    }

    _num1 = double.tryParse(_display) ?? 0;
    _operation = op;
    _shouldReset = true;
  }

  /// Fitur kalkulasi utama
  void _calculate() {
    if (_operation.isEmpty) return;

    _num2 = double.tryParse(_display) ?? 0;
    double result = 0;
    String operationUsed = _operation;

    switch (_operation) {
      case '+':
        result = _num1 + _num2;
        break;
      case '-':
        result = _num1 - _num2;
        break;
      case '×':
        result = _num1 * _num2;
        break;
      case '÷':
        result = _num2 != 0 ? _num1 / _num2 : double.nan;
        break;
      case '%':
        if (_operation == '%' && _num1 != 0) {
          if (_history.isNotEmpty) {
            final last = _history.first;
            if (last.contains('+') || last.contains('-')) {
              result = _num1 + (_num1 * _num2 / 100);
              operationUsed = '+(%)';
              break;
            }
          }
          result = _num1 % _num2;
        }
        break;
    }

    // Format hasil agar rapi
    String resultStr = result.isNaN
        ? 'Error'
        : result.toStringAsFixed(10)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');

    // Tambahkan ke riwayat jika valid
    if (!result.isNaN) {
      _history.insert(0, '$_num1 $operationUsed $_num2 = $resultStr');
      if (_history.length > 10) _history.removeLast();
    }

    // Tampilkan hasil
    _display = resultStr;
    _num1 = result;
    _operation = '';
    _shouldReset = true;
  }

  /// Menghapus seluruh riwayat
  void _clearHistory() {
    setState(() => _history.clear());
  }

  void _logout() {
    Navigator.pushReplacementNamed(context, '/splash');
  }

  /// Widget tombol kalkulator
  Widget _buildButton(String text, {Color? color, bool isWide = false}) {
    return Expanded(
      flex: isWide ? 2 : 1,
      child: Container(
        margin: const EdgeInsets.all(4),
        child: ElevatedButton(
          onPressed: () => _onButtonPressed(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[100],
            foregroundColor: color != null ? Colors.white : Colors.black87,
            padding: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Kalkulator',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                'Kalkulator Sederhana',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // === DISPLAY ===
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(1),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  _display,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),

              const SizedBox(height: 20),

              // === BUTTONS ===
              SizedBox(
                height: 400,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('C', color: Colors.red),
                          _buildButton('⌫', color: Colors.orange),
                          _buildButton('%', color: Colors.blue),
                          _buildButton('÷', color: Colors.blue),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('7'),
                          _buildButton('8'),
                          _buildButton('9'),
                          _buildButton('×', color: Colors.blue),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('4'),
                          _buildButton('5'),
                          _buildButton('6'),
                          _buildButton('-', color: Colors.blue),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('1'),
                          _buildButton('2'),
                          _buildButton('3'),
                          _buildButton('+', color: Colors.blue),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('0', isWide: true),
                          _buildButton('.'),
                          _buildButton('=', color: Colors.green),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),

              // === HISTORY ===
              SizedBox(
                height: 200,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Riwayat Operasi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_history.isNotEmpty)
                          TextButton(
                            onPressed: _clearHistory,
                            child: const Text(
                              'Hapus',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _history.isEmpty
                          ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history,
                                size: 40, color: Colors.grey),
                            SizedBox(height: 8),
                            Text(
                              'Belum ada riwayat',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              'Hasil operasi akan muncul di sini',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                          : Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border:
                          Border.all(color: Colors.grey.shade300),
                        ),
                        child: Scrollbar(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: _history.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 2),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.calculate,
                                        size: 16, color: Colors.blue),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _history[index],
                                        style: const TextStyle(
                                          fontFamily: 'monospace',
                                          fontSize: 14,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
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
      ),
    );
  }
}
