import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/app_models.dart';
import '../services/isar_service.dart';
import 'package:isar/isar.dart';

class SettingsProvider extends ChangeNotifier {
  String telegramBotToken = '';
  String telegramChatId = '';
  String printerMac = '';
  
  bool autoCleanupEnabled = false;
  int autoCleanupDays = 90;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    telegramBotToken = await IsarService.getSetting('bot_token') ?? '';
    telegramChatId = await IsarService.getSetting('chat_id') ?? '';
    printerMac = await IsarService.getSetting('printer_mac') ?? '';
    
    String? cleanupEnabledStr = await IsarService.getSetting('auto_cleanup_enabled');
    autoCleanupEnabled = cleanupEnabledStr == 'true';

    String? cleanupDaysStr = await IsarService.getSetting('auto_cleanup_days');
    autoCleanupDays = int.tryParse(cleanupDaysStr ?? '90') ?? 90;

    if (autoCleanupEnabled) cleanupOldImages();
    notifyListeners();
  }

  Future<void> saveSettings(String token, String chat, String mac) async {
    telegramBotToken = token;
    telegramChatId = chat;
    printerMac = mac;
    await IsarService.saveSetting('bot_token', token);
    await IsarService.saveSetting('chat_id', chat);
    await IsarService.saveSetting('printer_mac', mac);
    notifyListeners();
  }

  Future<void> updateAutoCleanupSettings(bool enabled, int days) async {
    autoCleanupEnabled = enabled;
    autoCleanupDays = days;
    await IsarService.saveSetting('auto_cleanup_enabled', enabled.toString());
    await IsarService.saveSetting('auto_cleanup_days', days.toString());
    notifyListeners();
  }

  Future<int> cleanupOldImages({bool force = false}) async {
    if (!autoCleanupEnabled && !force) return 0;
    int deletedCount = 0;
    final isar = IsarService.db;
    final thresholdDate = DateTime.now().subtract(Duration(days: autoCleanupDays));
    final archivedTickets = await isar.maintenanceTickets.filter().isArchivedEqualTo(true).findAll();

    for (var ticket in archivedTickets) {
      try {
        DateTime received = DateTime.parse(ticket.receivedDate);
        if (received.isBefore(thresholdDate)) {
          bool updated = false;
          if (ticket.imagePath != null) {
            final file = File(ticket.imagePath!);
            if (await file.exists()) { await file.delete(); deletedCount++; }
            ticket.imagePath = null; updated = true;
          }
          if (ticket.imagePathAfter != null) {
            final file = File(ticket.imagePathAfter!);
            if (await file.exists()) { await file.delete(); deletedCount++; }
            ticket.imagePathAfter = null; updated = true;
          }
          if (updated) {
            await isar.writeTxn(() async => await isar.maintenanceTickets.put(ticket));
          }
        }
      } catch (e) {
        debugPrint('خطأ في التنظيف: $e');
      }
    }
    if (deletedCount > 0) notifyListeners();
    return deletedCount;
  }

  Future<bool> sendMonthlyArchiveToTelegram() async {
    if (telegramBotToken.isEmpty || telegramChatId.isEmpty) return false;
    try {
      final now = DateTime.now();
      final allTickets = await IsarService.db.maintenanceTickets.where().findAll();
      final currentMonthTickets = allTickets.where((t) {
        final d = DateTime.parse(t.receivedDate);
        return d.month == now.month && d.year == now.year;
      }).toList();

      StringBuffer csvData = StringBuffer();
      csvData.writeln("ID,Customer,Device,Status,Final Cost,Net Profit,Date");
      for (var t in currentMonthTickets) {
        csvData.writeln("${t.firebaseId},${t.customerName},${t.deviceModel},${t.status},${t.finalCost},${t.netProfit},${t.receivedDate}");
      }

      var request = http.MultipartRequest('POST', Uri.parse('https://api.telegram.org/bot$telegramBotToken/sendDocument'));
      request.fields['chat_id'] = telegramChatId;
      request.fields['caption'] = 'Archive for ${DateFormat('MMMM yyyy').format(now)}';
      request.files.add(http.MultipartFile.fromString('document', csvData.toString(), filename: 'Archive_${now.month}_${now.year}.csv'));
      var response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}