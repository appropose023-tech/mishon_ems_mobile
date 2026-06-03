import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import 'login_screen.dart';
import 'shift_clock.dart';
import 'execution_floor.dart';
import 'ledger_transfer.dart';
import 'analytics.dart';

class PrimaryDashboardRouter extends StatefulWidget {
  const PrimaryDashboardRouter({Key? key}) : super(key: key);

  @override
  State<PrimaryDashboardRouter> createState() => _PrimaryDashboardRouterState();
}

class _PrimaryDashboardRouterState extends State<PrimaryDashboardRouter> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<EMSStateEngine>(context);
    final user = state.currentUser;

    if (user == null) return const IdentityGatewayPortal();

    bool isManagement = (user.role == 'admin' || user.role == 'manager');

    // Establish dynamic runtime view options matrices based on profile credentials
    final List<Widget> views = [];
    final List<BottomNavigationBarItem> navigationTabs = [];

    if (!isManagement) {
      views.addAll([
        const ShiftClockTerminalView(),
        const ExecutionFloorAssemblyView(),
        const InterDepartmentLedgerGatewayView(),
      ]);
      navigationTabs.addAll([
        const BottomNavigationBarItem(icon: Icon(Icons.timer), label: "Shift Clock"),
        const BottomNavigationBarItem(icon: Icon(Icons.precision_manufacturing), label: "Floor Entry"),
        const BottomNavigationBarItem(icon: Icon(Icons.swap_horizontal_circle), label: "Trace Ledger"),
      ]);
    } else {
      views.addAll([
        const OperationalAnalyticsMatrixView(),
        const InterDepartmentLedgerGatewayView(),
      ]);
      navigationTabs.addAll([
        const BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "Performance Hub"),
        const BottomNavigationBarItem(icon: Icon(Icons.history_edu), label: "Ledger History"),
      ]);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mishon Solutions EMS", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF004d4d),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              state.clearSession();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const IdentityGatewayPortal()));
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF008080).withOpacity(0.1),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Operator: ${user.username.toUpperCase()}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF004d4d))),
                Text("Dept: ${user.segment} [${user.team}]", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF008080))),
              ],
            ),
          ),
          Expanded(child: views[_selectedIndex]),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFF008080), width: 2)),
            ),
            padding: const EdgeInsets.all(8),
            child: const Text(
              "Mishon Solutions | www.mishonsolutions.com | contact: noreply@mishonsolutions.com +91 9223135678",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 9, color: Color(0xFF004d4d), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF008080),
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: navigationTabs,
      ),
    );
  }
}