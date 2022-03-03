import 'package:advanced_mobile_dev/widgets/screens/tabs/home-screen.dart';
import 'package:advanced_mobile_dev/widgets/screens/tabs/schedule.dart';
import 'package:advanced_mobile_dev/widgets/screens/tabs/tutor-list.dart';
import 'package:flutter/material.dart';

class Tabbar extends StatefulWidget {
  const Tabbar({Key? key}) : super(key: key);

  @override
  _TabbarState createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
  int _selectedIndex = 0;

  void _seclectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, Object>> _pages = [
      {'page': HomeScreen(seclectPage: _seclectPage), 'title': 'Home'},
      {'page': const Schedule(), 'title': 'Schedule'},
      {'page': const TurtorList(), 'title': 'Tutors'},
      {'page': const TurtorList(), 'title': 'Tutors'},

      // {'screen': const TutorLuis(), 'title': 'Home'}
    ];

    return Scaffold(
      appBar: AppBar(
          title: Text(_pages[_selectedIndex]['title'] as String,
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 16)),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor),
      body: _pages[_selectedIndex]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _seclectPage,
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Upcoming'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Tutors'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
