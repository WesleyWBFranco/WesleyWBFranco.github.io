import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lista_de_presentes/modules/admin/crud_screen.dart';
import 'package:lista_de_presentes/modules/user/screens/about_screen.dart';
import 'package:lista_de_presentes/modules/user/screens/cart_screen.dart';
import 'package:lista_de_presentes/modules/user/screens/user_feedback_screen.dart';
import 'package:lista_de_presentes/modules/user/screens/present_screen.dart';

class StandardScreen extends StatefulWidget {
  const StandardScreen({super.key});

  @override
  State<StandardScreen> createState() => _StandardScreenState();
}

class _StandardScreenState extends State<StandardScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const PresentScreen(),
    const CartScreen(),
    const UserFeedbackScreen(),
    const AboutScreen(),
    const CrudScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 39, 93, 80),
        elevation: 0,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Icon(Icons.menu, color: Colors.white),
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: Icon(FontAwesomeIcons.gift, color: Colors.white, size: 20),
            ),
            onPressed: () {
              setState(() => _selectedIndex = 1);
            },
          ),
        ],
      ),

      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 5, 104, 61),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: DrawerHeader(
                    child: Icon(
                      FontAwesomeIcons.gift,
                      size: 100,
                      color: Colors.black,
                    ),
                  ),
                ),
                _buildDrawerItem(
                  icon: Icons.favorite,
                  title: "P R E S E N T E S",
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _selectedIndex = 0);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.shopping_cart,
                  title: "C A R R I N H O",
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _selectedIndex = 1);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.sms,
                  title: "M E N S A G E M",
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _selectedIndex = 2);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.info,
                  title: "S O B R E",
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _selectedIndex = 3);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.settings,
                  title: "C O N F I G U R A R",
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _selectedIndex = 4);
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
              child: GestureDetector(
                onTap: () {},
                child: const ListTile(
                  leading: Icon(Icons.logout, color: Colors.black),
                  title: Text('Sair', style: TextStyle(color: Colors.black)),
                ),
              ),
            ),
          ],
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(title, style: const TextStyle(color: Colors.black)),
        onTap: onTap,
      ),
    );
  }
}
