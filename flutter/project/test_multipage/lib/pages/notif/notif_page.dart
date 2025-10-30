import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'dart:async';
import 'notification_helper.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _isLoading = false;
  String _notificationStatus = '';
  Timer? _countdownTimer;
  int _countdownSeconds = 0;

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _logout() {
    Navigator.pushReplacementNamed(context, '/splash');
  }

  /// Notifikasi sederhana dengan validasi permission
  Future<void> _testSimpleNotification() async {
    setState(() {
      _isLoading = true;
      _notificationStatus = 'Memeriksa izin notifikasi...';
    });

    try {
      // Validasi permission terlebih dahulu
      bool isAllowed = await NotificationHelper.checkPermission();
      if (!isAllowed) {
        setState(() {
          _notificationStatus = '❌ Izin notifikasi belum diberikan. Silakan minta izin terlebih dahulu.';
        });
        return;
      }

      setState(() {
        _notificationStatus = 'Mengirim notifikasi sederhana...';
      });

      bool success = await NotificationHelper.showTestNotification();

      setState(() {
        _notificationStatus = success
            ? '✅ Notifikasi sederhana berhasil dikirim!\nCek status bar device Anda untuk melihat notifikasi.'
            : '❌ Gagal mengirim notifikasi. Pastikan izin notifikasi sudah diberikan.';
      });
    } catch (e) {
      setState(() {
        _notificationStatus = '❌ Error saat mengirim notifikasi: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Notifikasi dengan Big Text Layout
  Future<void> _testBigTextNotification() async {
    setState(() {
      _isLoading = true;
      _notificationStatus = 'Memeriksa izin notifikasi...';
    });

    try {
      bool isAllowed = await NotificationHelper.checkPermission();
      if (!isAllowed) {
        setState(() {
          _notificationStatus = '❌ Izin notifikasi belum diberikan. Silakan minta izin terlebih dahulu.';
        });
        return;
      }

      setState(() {
        _notificationStatus = 'Mengirim notifikasi big text...';
      });

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: NotificationHelper.getNextId(),
          channelKey: 'basic_channel',
          title: 'Notifikasi Big Text 📝',
          body: 'Ini adalah notifikasi dengan tampilan big text. Anda bisa melihat teks yang lebih panjang dan detail dalam notifikasi ini. Fitur ini berguna untuk menampilkan konten yang lebih banyak seperti pesan panjang, artikel, atau deskripsi detail.',
          notificationLayout: NotificationLayout.BigText,
          payload: {'type': 'big_text', 'screen': 'details'},
        ),
      );

      setState(() {
        _notificationStatus = '✅ Notifikasi big text berhasil dikirim!\nGesek notifikasi untuk melihat teks lengkapnya.';
      });
    } catch (e) {
      setState(() {
        _notificationStatus = '❌ Gagal mengirim notifikasi big text: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Notifikasi Terjadwal dengan feedback lebih baik
  Future<void> _testScheduledNotification() async {
    setState(() {
      _isLoading = true;
      _notificationStatus = 'Memeriksa izin notifikasi...';
    });

    try {
      bool isAllowed = await NotificationHelper.checkPermission();
      if (!isAllowed) {
        setState(() {
          _notificationStatus = '❌ Izin notifikasi belum diberikan. Silakan minta izin terlebih dahulu.';
        });
        return;
      }

      setState(() {
        _notificationStatus = 'Menjadwalkan notifikasi...';
      });

      // Jadwalkan untuk 10 detik lagi
      bool success = await NotificationHelper.showScheduledNotification(
        title: 'Notifikasi Terjadwal ⏰',
        body: 'Ini adalah notifikasi yang dijadwalkan 10 detik dari sekarang. Dikirim pada: ${DateTime.now().add(const Duration(seconds: 10)).toString()}',
        delay: const Duration(seconds: 10),
        payload: {'type': 'scheduled', 'time': '10_seconds'},
      );

      if (success) {
        setState(() {
          _notificationStatus = '✅ Notifikasi terjadwal berhasil!\n'
              '• Akan muncul dalam 10 detik\n'
              '• Pastikan app dalam background atau terkunci\n'
              '• Device tidak dalam mode penghemat baterai';
        });

        // Tampilkan countdown
        _startCountdown(10);
      } else {
        setState(() {
          _notificationStatus = '❌ Gagal menjadwalkan notifikasi.\nPastikan izin notifikasi sudah diberikan.';
        });
      }
    } catch (e) {
      setState(() {
        _notificationStatus = '❌ Error saat menjadwalkan notifikasi: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Fungsi countdown untuk scheduled notification
  void _startCountdown(int seconds) {
    _countdownTimer?.cancel();
    _countdownSeconds = seconds;

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownSeconds > 0) {
        setState(() {
          _notificationStatus = '✅ Notifikasi terjadwal berhasil!\n'
              '• Akan muncul dalam $_countdownSeconds detik\n'
              '• Pastikan app dalam background atau terkunci\n'
              '• Device tidak dalam mode penghemat baterai';
        });
        _countdownSeconds--;
      } else {
        timer.cancel();
        setState(() {
          _notificationStatus = '⏰ Waktu notifikasi terjadwal sudah habis!\n'
              '• Cek status bar device untuk notifikasi\n'
              '• Jika tidak muncul, coba lock/unlock device\n'
              '• Pastikan tidak ada mode penghemat baterai';
        });
      }
    });
  }

  /// Meminta izin notifikasi yang lebih cepat dan smart
  Future<void> _requestPermission() async {
    setState(() {
      _isLoading = true;
      _notificationStatus = 'Memeriksa status izin...';
    });

    try {
      // Cek status saat ini
      bool isCurrentlyAllowed = await NotificationHelper.checkPermission();

      if (isCurrentlyAllowed) {
        setState(() {
          _notificationStatus = '✅ Izin notifikasi sudah aktif!\nAnda bisa mengirim notifikasi sekarang.';
        });
        return;
      }

      setState(() {
        _notificationStatus = 'Meminta izin notifikasi...\nTunggu dialog izin muncul.';
      });

      // Hanya request jika benar-benar belum ada izin
      bool isAllowed = await NotificationHelper.requestPermission();

      setState(() {
        _notificationStatus = isAllowed
            ? '✅ Izin notifikasi diberikan!\nSekarang Anda bisa mengirim notifikasi.'
            : '❌ Izin notifikasi ditolak.\nSilakan aktifkan manual di pengaturan device atau beri izin ketika dialog muncul kembali.';
      });

    } catch (e) {
      setState(() {
        _notificationStatus = '❌ Gagal meminta izin: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Cek Status Permission
  Future<void> _checkPermissionStatus() async {
    setState(() {
      _isLoading = true;
      _notificationStatus = 'Memeriksa status izin notifikasi...';
    });

    try {
      bool isAllowed = await NotificationHelper.checkPermission();

      setState(() {
        _notificationStatus = isAllowed
            ? '✅ Izin notifikasi sudah aktif!\nStatus: DIIZINKAN\nAnda bisa mengirim semua jenis notifikasi.'
            : '❌ Izin notifikasi belum diberikan.\nStatus: DITOLAK\nSilakan minta izin terlebih dahulu.';
      });
    } catch (e) {
      setState(() {
        _notificationStatus = '❌ Gagal memeriksa status izin: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Menghapus semua notifikasi
  Future<void> _clearAllNotifications() async {
    setState(() {
      _isLoading = true;
      _notificationStatus = 'Menghapus semua notifikasi dan badge...';
    });

    try {
      await NotificationHelper.clearAllNotifications();

      setState(() {
        _notificationStatus = '✅ Berhasil menghapus semua notifikasi!\n'
            '• Notifikasi aktif di status bar\n'
            '• Badge counter (angka merah) di icon app\n'
            '• Notifikasi terjadwal yang belum muncul';
      });
    } catch (e) {
      setState(() {
        _notificationStatus = '❌ Gagal menghapus notifikasi: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// UI utama halaman
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Test Notifikasi',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon yang lebih kecil
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                      Icons.notifications_active,
                      size: 24,
                      color: Colors.blue[800]
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Test Notifikasi',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Uji berbagai jenis notifikasi dengan Awesome Notifications',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            Card(
              elevation: 3,
              color: _getStatusColor(),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 20,
                          color: _getStatusIconColor(),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Status Notifikasi:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    /// Menampilkan proses loading atau status teks
                    _isLoading
                        ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blue[700]!),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Sedang memproses permintaan...',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    )
                        : Text(
                      _notificationStatus.isEmpty
                          ? 'Pilih salah satu test notifikasi di bawah untuk memulai.\nStatus akan ditampilkan di sini.'
                          : _notificationStatus,
                      style: TextStyle(
                        color: _getStatusTextColor(),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 16),

            // Judul section test
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                'Pilih Jenis Test:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(height: 12),

            /// Daftar tombol pengujian notifikasi
            Expanded(
              child: ListView(
                children: [
                  _buildTestButton(
                    icon: Icons.notifications_none,
                    title: 'Notifikasi Sederhana',
                    subtitle: 'Tes notifikasi basic dengan tampilan default dan suara',
                    onTap: _testSimpleNotification,
                    color: Colors.blue,
                  ),
                  _buildTestButton(
                    icon: Icons.text_fields,
                    title: 'Notifikasi Big Text',
                    subtitle: 'Tes notifikasi dengan teks panjang yang bisa di-expand',
                    onTap: _testBigTextNotification,
                    color: Colors.green,
                  ),
                  _buildTestButton(
                    icon: Icons.schedule_rounded,
                    title: 'Notifikasi Terjadwal',
                    subtitle: 'Tes notifikasi yang dijadwalkan 10 detik dari sekarang',
                    onTap: _testScheduledNotification,
                    color: Colors.purple,
                  ),
                  _buildTestButton(
                    icon: Icons.perm_device_info,
                    title: 'Minta Izin Notifikasi',
                    subtitle: 'Request permission dari sistem untuk mengirim notifikasi',
                    onTap: _requestPermission,
                    color: Colors.orange,
                  ),
                  _buildTestButton(
                    icon: Icons.verified_user,
                    title: 'Cek Status Izin',
                    subtitle: 'Periksa status permission notifikasi saat ini',
                    onTap: _checkPermissionStatus,
                    color: Colors.teal,
                  ),
                  _buildTestButton(
                    icon: Icons.cleaning_services,
                    title: 'Hapus Semua Notifikasi',
                    subtitle: 'Bersihkan notifikasi aktif, terjadwal, dan badge counter',
                    onTap: _clearAllNotifications,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper untuk menentukan warna status card
  Color _getStatusColor() {
    if (_notificationStatus.contains('✅')) return Colors.green[50]!;
    if (_notificationStatus.contains('❌')) return Colors.red[50]!;
    if (_notificationStatus.contains('⏰')) return Colors.orange[50]!;
    if (_notificationStatus.contains('Memeriksa') ||
        _notificationStatus.contains('Mengirim') ||
        _notificationStatus.contains('Menjadwalkan')) {
      return Colors.blue[50]!;
    }
    return Colors.grey[50]!;
  }

  /// Helper untuk menentukan warna teks status
  Color _getStatusTextColor() {
    if (_notificationStatus.contains('✅')) return Colors.green[800]!;
    if (_notificationStatus.contains('❌')) return Colors.red[800]!;
    if (_notificationStatus.contains('⏰')) return Colors.orange[800]!;
    if (_notificationStatus.contains('Memeriksa') ||
        _notificationStatus.contains('Mengirim') ||
        _notificationStatus.contains('Menjadwalkan')) {
      return Colors.blue[800]!;
    }
    return Colors.grey[800]!;
  }

  /// Helper untuk menentukan warna icon status
  Color _getStatusIconColor() {
    if (_notificationStatus.contains('✅')) return Colors.green;
    if (_notificationStatus.contains('❌')) return Colors.red;
    if (_notificationStatus.contains('⏰')) return Colors.orange;
    return Colors.blue;
  }

  /// Widget Reusable untuk tombol pengujian
  Widget _buildTestButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha:0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ),
        trailing: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha:0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.arrow_forward_ios, color: color, size: 14),
        ),
        onTap: onTap,
      ),
    );
  }
}