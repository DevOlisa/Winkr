import 'package:flutter/material.dart';
import 'package:winkr/pages/settings/general.dart';
import 'package:winkr/uiElements/CircleTabIndicator.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  final List<Tab> settingsTabs = <Tab>[
    Tab(text: 'General'),
    Tab(text: 'Chat'),
    Tab(
      text: 'Privacy',
    )
  ];

  @override
  void initState() {
    super.initState();
    super.initState();
    _tabController = TabController(
      length: settingsTabs.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          title: Text("Setings",
              style: Theme.of(context)
                  .appBarTheme
                  .titleTextStyle
                  .copyWith(color: Theme.of(context).primaryColor)),
          bottom: TabBar(
            automaticIndicatorColorAdjustment: true,
            isScrollable: true,
            controller: _tabController,
            indicator: CircleTabIndicator(
                color: Theme.of(context).primaryColor,
                radius: 3.0,
                offsetY: -8.0),
            unselectedLabelColor: Theme.of(context).primaryColorLight,
            labelColor: Theme.of(context).primaryColorDark,
            tabs: [
              Tab(child: Text("General")),
              Tab(child: Text("Chat")),
              Tab(child: Text("Privacy")),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [GeneralSettings(), ChatSettings(), PrivacySettings()],
      ),
    );
  }
}
