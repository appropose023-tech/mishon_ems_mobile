import 'package:flutter/material.dart';
import 'models.dart';

class EMSStateEngine extends ChangeNotifier {
  UserProfile? currentUser;
  DateTime? activePunchInTime;
  List<JobBatch> batches = [];
  List<LedgerEntry> materialLedger = [];
  List<FloorTarget> targetingMatrix = [];
  Map<String, Map<String, int>> processingCounters = {}; // batchNo -> (TOP/BOTTOM) -> quantityDone

  EMSStateEngine() {
    _seedInitialOperationalContext();
  }

  void _seedInitialOperationalContext() {
    batches.addAll([
      JobBatch(batchNo: "KD/26/001", jobName: "JOB-A", clientName: "Alpha Corp", projectName: "PCB-Mainframe", initialQty: 1200),
      JobBatch(batchNo: "KD/26/002", jobName: "JOB-B", clientName: "Beta Electronics", projectName: "IoT-Sensor-Node", initialQty: 500),
    ]);
    
    targetingMatrix.addAll([
      FloorTarget(batchNo: "KD/26/001", segment: "SMT", team: "Production", targetQty: 800),
      FloorTarget(batchNo: "KD/26/001", segment: "SMT", team: "Quality", targetQty: 800),
    ]);
  }

  bool authenticateUser(String username, String password) {
    String lowerName = username.toLowerCase();
    if (lowerName == 'admin' && password == 'admin123') {
      currentUser = UserProfile(username: "admin", role: "admin", team: "None", segment: "None");
    } else if (lowerName == 'manager' && password == 'manager123') {
      currentUser = UserProfile(username: "manager1", role: "manager", team: "None", segment: "None");
    } else if (lowerName == 'supervisor' && password == 'super123') {
      currentUser = UserProfile(username: "super_smt", role: "supervisor", team: "Production", segment: "SMT");
    } else if (lowerName == 'technician' && password == 'tech123') {
      currentUser = UserProfile(username: "tech_th_qc", role: "technician", team: "Quality", segment: "Through hole");
    } else {
      return false;
    }
    notifyListeners();
    return true;
  }

  void clearSession() {
    currentUser = null;
    activePunchInTime = null;
    notifyListeners();
  }

  void toggleShiftPunch(bool punchIn) {
    activePunchInTime = punchIn ? DateTime.now() : null;
    notifyListeners();
  }

  int getLayerRunningTotal(String batchNo, String side) {
    return processingCounters[batchNo]?[side] ?? 0;
  }

  void commitHourlyStatus(String batchNo, String side, int amount) {
    if (!processingCounters.containsKey(batchNo)) {
      processingCounters[batchNo] = {"TOP": 0, "BOTTOM": 0};
    }
    processingCounters[batchNo]![side] = (processingCounters[batchNo]![side] ?? 0) + amount;
    notifyListeners();
  }

  void closeBatchProcessingBlock(String batchNo) {
    final idx = batches.indexWhere((element) => element.batchNo == batchNo);
    if (idx != -1) {
      batches[idx].status = 'CLOSED';
      notifyListeners();
    }
  }

  void dispatchBillingClearance(String batchNo) {
    final idx = batches.indexWhere((element) => element.batchNo == batchNo);
    if (idx != -1) {
      batches[idx].status = 'DISPATCHED';
      notifyListeners();
    }
  }

  void injectLedgerTransaction({
    required String batchNo,
    required String fromStage,
    required String toStage,
    required int qty,
    required String operator,
    required String remarks,
  }) {
    materialLedger.add(LedgerEntry(
      batchNo: batchNo,
      fromStage: fromStage,
      toStage: toStage,
      qtyTransferred: qty,
      timestamp: DateTime.now(),
      operator: operator,
      comments: remarks,
    ));
    notifyListeners();
  }

  void provisionNewTarget(String batchNo, String segment, String team, int targetQty) {
    targetingMatrix.add(FloorTarget(batchNo: batchNo, segment: segment, team: team, targetQty: targetQty));
    notifyListeners();
  }
}
