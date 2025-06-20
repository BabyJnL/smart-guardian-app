import 'package:flutter/material.dart';
import 'package:smart_guardian_final/pages/live_surveillance.dart';

// Import Pages
import 'package:smart_guardian_final/pages/realtime_log.dart';

class TabView extends StatefulWidget
{
    const TabView({ super.key });

    @override
    _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> with SingleTickerProviderStateMixin
{
    int _selectedIndex = 0;
    late TabController _tabController; 

    void _onItemTapped(int index) {
        setState(() {
        _selectedIndex = index;
        });

        _tabController.animateTo(index);
    }

    @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

    @override
    Widget build(BuildContext context)
    {
        return MaterialApp(
            theme: ThemeData(
                colorScheme: ColorScheme.light(
                    primary: Color.fromRGBO(123, 185, 224, 1)
                )
            ),
            home: DefaultTabController(
                length: 2,
                child: Scaffold(
                    appBar: AppBar(
                        title: Text(_selectedIndex == 0 ? 'Realtime Log': 'Live Surveillance'),
                    ),
                    bottomNavigationBar: BottomNavigationBar(
                        items: const <BottomNavigationBarItem>[
                            BottomNavigationBarItem(icon: Icon(Icons.alarm), label: 'Realtime Log'),
                            BottomNavigationBarItem(icon: Icon(Icons.video_camera_back), label: 'Live Surveillance')
                        ],  
                        currentIndex: _selectedIndex,
                        selectedItemColor: Color.fromRGBO(123, 185, 224, 1),
                        onTap: _onItemTapped
                    ),
                    body: TabBarView(
                        controller: _tabController,
                        children: [
                            RealtimeLogPage(key: ValueKey(DateTime.now())),
                            LiveSurveillancePage(),
                        ],
                    ),
                ),
            ),
        );
    }
}