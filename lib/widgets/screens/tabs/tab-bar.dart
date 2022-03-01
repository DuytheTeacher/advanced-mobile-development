import 'package:advanced_mobile_dev/widgets/screens/tabs/home-screen.dart';
import 'package:flutter/material.dart';

class Tabbar extends StatefulWidget {
  const Tabbar({Key? key}) : super(key: key);

  @override
  _TabbarState createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
  final List<Widget> _pages = [const HomeScreen(title: 'Home')];

  int _selectedIndex = 0;

  void _seclectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Home',
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 16)),
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _seclectPage,
        backgroundColor: Theme.of(context).primaryColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.messenger), label: 'Message'),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Upcoming'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Tutors'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
