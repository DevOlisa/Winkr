import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:winkr/pages/settings_page.dart';
import 'package:winkr/pages/contact_list_page.dart';
import 'package:winkr/pages/group_grid_page.dart';
import 'package:winkr/pages/recent_chat_page.dart';
import 'package:winkr/widgets/SearchBar.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final List<Tab> homepageTabs = <Tab>[
    Tab(text: 'Recent'),
    Tab(text: 'Groups'),
    Tab(
      text: 'Contacts',
    )
  ];
  final GlobalKey<NavigatorState> _navigatorState = GlobalKey<NavigatorState>();
  TabController _tabController;
  TextEditingController _searchFieldController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: homepageTabs.length,
      vsync: this,
    );
    _searchFieldController = TextEditingController();
    _searchFieldController.addListener(() {
      print("Calling Search Contact Function");
      // searchContacts(_searchFieldController.text);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRoute = !await _navigatorState.currentState.maybePop();

        if (isFirstRoute) {
          if (_tabController.index != 0) {
            _tabController.animateTo(0);
            return false;
          }
        }

        return isFirstRoute;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: AppBar(
            elevation: 0.0,
            actions: [
              IconButton(
                icon: Icon(Icons.search_rounded),
                onPressed: () {
                  showGeneralDialog(
                      context: context,
                      pageBuilder: (context, _, __) {
                        return SearchBar();
                      });
                },
              ),
              PopupMenuButton(
                  icon: Icon(Icons.more_vert_outlined),
                  offset: Offset(0.0, -16.0),
                  elevation: 2.0,
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        child: GestureDetector(
                            child: Text("Settings"),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return SettingsPage();
                              }));
                            }),
                      ),
                      PopupMenuItem(
                          height: 1.0, child: PopupMenuDivider(height: 1.0)),
                      PopupMenuItem(child: Text("About")),
                    ];
                  }),
            ],
            title: Text(widget.title,
                style: Theme.of(context).appBarTheme.titleTextStyle),
            bottom: TabBar(
                // isScrollable: true,
                controller: _tabController,
                tabs: homepageTabs),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            ReccentChatPage(),
            GroupGridPage(),
            ContactListPage(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.message_rounded),
          backgroundColor: Theme.of(context).primaryColorDark,
          onPressed: () {
            _tabController.animateTo(2);
          },
        ),
      ),
    );
  }
}
