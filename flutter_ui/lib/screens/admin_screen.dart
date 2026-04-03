import 'package:flutter/material.dart';
import '../widgets/admin_settings_tab.dart';
import '../widgets/admin_menu_tab.dart';
import '../widgets/admin_reports_tab.dart';
import '../widgets/admin_end_day_tab.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Panel'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.settings), text: 'Settings'),
              Tab(icon: Icon(Icons.restaurant_menu), text: 'Menu'),
              Tab(icon: Icon(Icons.bar_chart), text: 'Reports'),
              Tab(icon: Icon(Icons.nightlight_round), text: 'End Day'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AdminSettingsTab(),
            AdminMenuTab(),
            AdminReportsTab(),
            AdminEndDayTab(),
          ],
        ),
      ),
    );
  }
}
