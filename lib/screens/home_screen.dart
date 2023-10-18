import 'package:flutter/material.dart';

import 'package:yugioh_api_flutter/screens/random_cards.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BottomCardNavigation();
  }
}

class BottomCardNavigation extends StatefulWidget {
  const BottomCardNavigation({super.key});

  @override
  State<BottomCardNavigation> createState() => _BottomCardNavigationState();
}

class _BottomCardNavigationState extends State<BottomCardNavigation> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    RandomCards(),
    RandomCards(),
    RandomCards(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YU-GI-OH'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Random card list',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Random card list',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Random card list',
          ),
        ],
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.cyan,
        onTap: _onItemTapped,
      ),
    );
  }
}
