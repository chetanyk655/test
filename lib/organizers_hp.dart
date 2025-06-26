import 'package:flutter/material.dart';
import 'package:event_app/drawer.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class OrganizersHp extends StatefulWidget {
  const OrganizersHp({super.key});

  @override
  State<OrganizersHp> createState() => _OrganizersHpState();
}

class _OrganizersHpState extends State<OrganizersHp> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/subtle_pattern.png",
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.2),
            ),
          ),
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: true,
                title: const Text(
                  "Organizers Data",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.blue,
        animationDuration: const Duration(milliseconds: 300),
        index: _selectedIndex,
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.search, size: 30, color: Colors.white),
          Icon(Icons.groups, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) {
          } else if (index == 1) {
          } else if (index == 2) {}
        },
      ),
    );
  }
}
