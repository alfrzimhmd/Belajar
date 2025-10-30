import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationHelper {
  static int _notificationId = 0;

  /// Inisialisasi notifikasi dengan error handling
  static Future<void> initialize() async {
    try {
      await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
            channelKey: 'basic_channel',
            channelName: 'Basic Notifications',
            channelDescription: 'Channel untuk notifikasi dasar',
            defaultColor: const Color(0xFF007BFF),
            ledColor: Colors.blue,
            ledOnMs: 1000,
            ledOffMs: 500,
            importance: NotificationImportance.High,
            channelShowBadge: true,
            playSound: true,
            enableVibration: true,
          ),
          // Channel khusus untuk scheduled notifications
          NotificationChannel(
            channelKey: 'scheduled_channel',
            channelName: 'Scheduled Notifications',
            channelDescription: 'Channel untuk notifikasi terjadwal',
            defaultColor: const Color(0xFF9C27B0),
            ledColor: Colors.purple,
            importance: NotificationImportance.High,
            channelShowBadge: true,
            playSound: true,
            enableVibration: true,
          ),
        ],
        debug: true,
      );

      // Setup action handlers
      setupNotificationActionHandlers();

      // Request permission jika belum ada
      bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
      if (!isAllowed) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    } catch (e) {
      debugPrint('❌ Error initializing notifications: $e');
    }
  }

  /// Setup handler untuk aksi notifikasi
  static void setupNotificationActionHandlers() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceived,
      onNotificationCreatedMethod: onNotificationCreated,
      onNotificationDisplayedMethod: onNotificationDisplayed,
      onDismissActionReceivedMethod: onDismissActionReceived,
    );
  }

  /// Handler ketika notifikasi diklik
  static Future<void> onActionReceived(ReceivedAction receivedAction) async {
    debugPrint('🔔 Notifikasi diklik: ${receivedAction.id}');

    // Handle payload jika ada
    if (receivedAction.payload != null && receivedAction.payload!.isNotEmpty) {
      debugPrint('📦 Payload: ${receivedAction.payload}');
    }
  }

  /// Handler ketika notifikasi dibuat
  static Future<void> onNotificationCreated(ReceivedNotification receivedNotification) async {
    debugPrint('📝 Notifikasi dibuat: ${receivedNotification.id}');
  }

  /// Handler ketika notifikasi ditampilkan
  static Future<void> onNotificationDisplayed(ReceivedNotification receivedNotification) async {
    debugPrint('👀 Notifikasi ditampilkan: ${receivedNotification.id}');
  }

  /// Handler ketika notifikasi dihapus/dismiss
  static Future<void> onDismissActionReceived(ReceivedAction receivedAction) async {
    debugPrint('🗑️ Notifikasi dihapus: ${receivedAction.id}');
  }

  /// Generate unique ID untuk notifikasi
  static int getNextId() {
    return _notificationId++ % 100000;
  }

  /// Fungsi sederhana untuk test notifikasi
  static Future<bool> showTestNotification() async {
    try {
      // Cek permission terlebih dahulu
      bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
      if (!isAllowed) {
        debugPrint('❌ Izin notifikasi belum diberikan');
        return false;
      }

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: getNextId(),
          channelKey: 'basic_channel',
          title: 'Test dari Notification Helper! 🚀',
          body: 'Notifikasi ini dikirim melalui NotificationHelper.',
          notificationLayout: NotificationLayout.Default,
          payload: {'type': 'test', 'screen': 'home'},
        ),
      );
      return true;
    } catch (e) {
      debugPrint('❌ Error showing test notification: $e');
      return false;
    }
  }

  /// Fungsi untuk notifikasi terjadwal yang lebih reliable
  static Future<bool> showScheduledNotification({
    required String title,
    required String body,
    required Duration delay,
    Map<String, String>? payload,
  }) async {
    try {
      bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
      if (!isAllowed) {
        debugPrint('❌ Izin notifikasi belum diberikan');
        return false;
      }

      // Channel khusus untuk scheduled
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: getNextId(),
          channelKey: 'scheduled_channel', //Ganti channel
          title: title,
          body: body,
          notificationLayout: NotificationLayout.Default,
          payload: payload,
        ),
        schedule: NotificationCalendar.fromDate(
          date: DateTime.now().add(delay),
          allowWhileIdle: true,
        ),
      );
      debugPrint('✅ Notifikasi terjadwal berhasil di-set: ${delay.inSeconds} detik');
      return true;
    } catch (e) {
      debugPrint('❌ Error showing scheduled notification: $e');
      return false;
    }
  }

  /// Cek status permission notifikasi
  static Future<bool> checkPermission() async {
    return await AwesomeNotifications().isNotificationAllowed();
  }

  /// Minta izin notifikasi
  static Future<bool> requestPermission() async {
    return await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  /// Hapus semua notifikasi DAN reset badge counter
  static Future<void> clearAllNotifications() async {
    try {
      // 1. Hapus semua notifikasi dari status bar
      await AwesomeNotifications().cancelAll();

      // 2. Reset badge counter di icon app
      await AwesomeNotifications().resetGlobalBadge();

      debugPrint('✅ Semua notifikasi dan badge berhasil dihapus!');
    } catch (e) {
      debugPrint('❌ Gagal menghapus notifikasi: $e');
      rethrow;
    }
  }
}