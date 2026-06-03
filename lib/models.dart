class UserProfile {
  final String username;
  final String role; // admin, manager, supervisor, technician
  final String team; // Production, Quality, None
  final String segment; // SMT, Through hole, None

  UserProfile({
    required this.username,
    required this.role,
    required this.team,
    required this.segment,
  });
}

class JobBatch {
  final String batchNo;
  final String jobName;
  final String clientName;
  final String projectName;
  final int initialQty;
  String status; // OPEN, CLOSED, DISPATCHED

  JobBatch({
    required this.batchNo,
    required this.jobName,
    required this.clientName,
    required this.projectName,
    required this.initialQty,
    this.status = 'OPEN',
  });
}

class LedgerEntry {
  final String batchNo;
  final String fromStage;
  final String toStage;
  final int qtyTransferred;
  final DateTime timestamp;
  final String operator;
  final String comments;

  LedgerEntry({
    required this.batchNo,
    required this.fromStage,
    required this.toStage,
    required this.qtyTransferred,
    required this.timestamp,
    required this.operator,
    required this.comments,
  });
}

class FloorTarget {
  final String batchNo;
  final String segment;
  final String team;
  final int targetQty;

  FloorTarget({
    required this.batchNo,
    required this.segment,
    required this.team,
    required this.targetQty,
  });
}
