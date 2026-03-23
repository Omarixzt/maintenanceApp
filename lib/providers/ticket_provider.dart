import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Index;
import 'package:isar/isar.dart';
import '../models/app_models.dart';
import '../services/isar_service.dart';

class TicketProvider extends ChangeNotifier {
  List<MaintenanceTicket> tickets = [];
  StreamSubscription<QuerySnapshot>? _ticketsSubscription;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  TicketProvider() {
    _loadTickets();
    _setupConnectivityListener();
    _startRealtimeSync();
    syncAllPendingTickets();
  }

  // تحميل التذاكر النشطة فقط (غير المؤرشفة) في الذاكرة
  Future<void> _loadTickets() async {
    tickets = await IsarService.db.maintenanceTickets
        .filter()
        .isArchivedEqualTo(false)
        .sortByReceivedDateDesc()
        .findAll();
    notifyListeners();
  }

  void _setupConnectivityListener() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (results.contains(ConnectivityResult.mobile) || results.contains(ConnectivityResult.wifi)) {
        syncAllPendingTickets();
      }
    });
  }

  Future<void> syncAllPendingTickets() async {
    try {
      final pendingTickets = await IsarService.db.maintenanceTickets.filter().syncStatusEqualTo(0).findAll();
      for (var ticket in pendingTickets) {
        await _syncTicketToFirebase(ticket);
      }
    } catch (e) {
      debugPrint("خطأ في مزامنة المعلقات: $e");
    }
  }

  // الاستماع للتذاكر النشطة فقط من السحابة
  void _startRealtimeSync() {
    _ticketsSubscription?.cancel();
    _ticketsSubscription = FirebaseFirestore.instance
        .collection('maintenance_tickets')
        .where('isArchived', isEqualTo: false)
        .snapshots()
        .listen((snapshot) async {
      final isar = IsarService.db;
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added || change.type == DocumentChangeType.modified) {
          final incomingData = change.doc.data();
          if (incomingData != null) {
            final cloudTicket = MaintenanceTicket.fromMap(incomingData);
            final localTicket = await isar.maintenanceTickets.filter().firebaseIdEqualTo(cloudTicket.firebaseId).findFirst();
            if (localTicket != null && localTicket.syncStatus == 0 && localTicket.updatedAt > cloudTicket.updatedAt) {
              continue; 
            }
            await isar.writeTxn(() async => await isar.maintenanceTickets.put(cloudTicket));
          }
        }
      }
      _loadTickets();
    });
  }

  Future<void> _syncTicketToFirebase(MaintenanceTicket ticket) async {
    try {
      if (ticket.firebaseId == null || ticket.firebaseId!.isEmpty) return;
      await FirebaseFirestore.instance.collection('maintenance_tickets').doc(ticket.firebaseId).set(ticket.toMap(), SetOptions(merge: true));
      ticket.syncStatus = 1; 
      await IsarService.db.writeTxn(() async => await IsarService.db.maintenanceTickets.put(ticket));
    } catch (e) {
      ticket.syncStatus = 0;
      await IsarService.db.writeTxn(() async => await IsarService.db.maintenanceTickets.put(ticket));
    }
  }

  Future<void> addTicket(MaintenanceTicket ticket) async {
    await IsarService.db.writeTxn(() async => await IsarService.db.maintenanceTickets.put(ticket));
    tickets.insert(0, ticket);
    notifyListeners();
    await _syncTicketToFirebase(ticket);
  }

  Future<void> updateTicketStatus(MaintenanceTicket ticket, String newStatus, {bool archive = false}) async {
    ticket.status = newStatus;
    ticket.updatedAt = DateTime.now().millisecondsSinceEpoch;
    if (archive) ticket.isArchived = true;
    
    if (newStatus == 'Delivered' && ticket.syncStatus == 0) {
      try {
        await FirebaseFirestore.instance.collection('pos_sync').doc(ticket.firebaseId).set({
          'customerName': ticket.customerName,
          'deviceModel': ticket.deviceModel,
          'finalCost': ticket.finalCost,
          'netProfit': ticket.netProfit,
          'timestamp': FieldValue.serverTimestamp(),
          'ticketId': ticket.firebaseId,
        });
      } catch (e) {
        debugPrint("فشلت مزامنة POS اللحظية.");
      }
    }

    await IsarService.db.writeTxn(() async => await IsarService.db.maintenanceTickets.put(ticket));
    if (archive) tickets.removeWhere((t) => t.firebaseId == ticket.firebaseId);
    notifyListeners();
    await _syncTicketToFirebase(ticket);
  }

  Future<bool> usePartForTicket(MaintenanceTicket ticket, LocalPart part) async {
    if (part.quantity <= 0) return false;
    part.quantity -= 1;
    ticket.netProfit = ticket.finalCost - part.costPrice;
    ticket.updatedAt = DateTime.now().millisecondsSinceEpoch;

    await IsarService.db.writeTxn(() async {
      await IsarService.db.localParts.put(part);
      await IsarService.db.maintenanceTickets.put(ticket);
    });
    notifyListeners();
    await _syncTicketToFirebase(ticket);
    return true;
  }

  // دالة جلب الأجهزة المؤرشفة الجديدة فقط من السحابة (Delta Sync)
  Future<String> syncNewArchivedTickets() async {
    try {
      final isar = IsarService.db;

      // البحث عن أحدث جهاز مؤرشف محلياً لمعرفة وقت آخر تحديث
      final lastLocalArchivedTicket = await isar.maintenanceTickets
          .filter()
          .isArchivedEqualTo(true)
          .sortByUpdatedAtDesc()
          .findFirst();

      int lastSyncTime = lastLocalArchivedTicket?.updatedAt ?? 0;

      // جلب الأجهزة المؤرشفة من فايربيس التي تم تحديثها بعد هذا الوقت فقط
      final snapshot = await FirebaseFirestore.instance
          .collection('maintenance_tickets')
          .where('isArchived', isEqualTo: true)
          .where('updatedAt', isGreaterThan: lastSyncTime)
          .get();

      if (snapshot.docs.isEmpty) {
        return "الأرشيف المحلي محدث بالفعل، لا توجد أجهزة جديدة.";
      }

      int addedCount = 0;
      await isar.writeTxn(() async {
        for (var doc in snapshot.docs) {
          final cloudTicket = MaintenanceTicket.fromMap(doc.data());
          
          final exists = await isar.maintenanceTickets
              .filter()
              .firebaseIdEqualTo(cloudTicket.firebaseId)
              .findFirst();
              
          if (exists == null) {
            await isar.maintenanceTickets.put(cloudTicket);
            addedCount++;
          }
        }
      });

      return "تم سحب $addedCount جهاز جديد إلى الأرشيف بنجاح.";
    } catch (e) {
      debugPrint("خطأ في مزامنة الأرشيف: $e");
      return "حدث خطأ أثناء الاتصال بالسحابة.";
    }
  }

  @override
  void dispose() {
    _ticketsSubscription?.cancel();
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}