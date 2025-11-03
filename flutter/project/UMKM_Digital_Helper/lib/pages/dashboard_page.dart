import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardPage> {
  bool showToday = true;

  final List<Map<String, dynamic>> todayTransactions = [
    {
      'title': 'Penjualan Kopi Susu',
      'date': '13 Oktober 2025, 10.30',
      'amount': 120000,
      'isIncome': true,
    },
    {
      'title': 'Penjualan Americano',
      'date': '13 Oktober 2025, 10.30',
      'amount': 125000,
      'isIncome': true,
    },
    {
      'title': 'Beli Stok Bensin',
      'date': '13 Oktober 2025, 07.00',
      'amount': 650000,
      'isIncome': false,
    },
  ];

  final List<Map<String, dynamic>> allTransactions = [
    {
      'title': 'Penjualan Latte',
      'date': '10 Oktober 2025, 09.15',
      'amount': 84000,
      'isIncome': true,
    },
    {
      'title': 'Beli Token Listrik',
      'date': '7 Oktober 2025, 08.30',
      'amount': 340000,
      'isIncome': false,
    },
    {
      'title': 'Bayar Gaji Karyawan',
      'date': '3 Oktober 2025, 08.30',
      'amount': 480000,
      'isIncome': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final transactions = showToday ? todayTransactions : allTransactions;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Hallo 👋',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "Syahroni's Coffee Shop",
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.blue),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Balance Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Jumlah Saldo Anda',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Rp 1.968.634.000',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _incomeExpenseCard(
                        title: 'Pemasukan',
                        color: Colors.green.shade600,
                        amount: '+ Rp 67.852.000',
                        icon: LucideIcons.plus,
                      ),
                      _incomeExpenseCard(
                        title: 'Pengeluaran',
                        color: Colors.red.shade600,
                        amount: '- Rp 53.971.000',
                        icon: LucideIcons.minus,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _tabButton('Hari Ini', showToday),
                const SizedBox(width: 10),
                _tabButton('Semua Transaksi', !showToday),
              ],
            ),

            const SizedBox(height: 16),

            ...transactions.map((trx) => _transactionCard(
              trx['title'],
              trx['date'],
              trx['amount'],
              trx['isIncome'],
            )),
          ],
        ),
      ),
    );
  }

  Widget _incomeExpenseCard({
    required String title,
    required Color color,
    required String amount,
    required IconData icon,
  }) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withAlpha(1),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500)),
                Text(amount,
                    style: TextStyle(
                        color: color, fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabButton(String title, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() => showToday = title == 'Hari Ini');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue.shade700 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _transactionCard(String title, String date, int amount, bool isIncome) {
    final color = isIncome ? Colors.green : Colors.red;
    final icon = isIncome ? Icons.arrow_upward : Icons.arrow_downward;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withAlpha(1),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black87)),
                Text(date,
                    style:
                    const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+' : '-'} Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
