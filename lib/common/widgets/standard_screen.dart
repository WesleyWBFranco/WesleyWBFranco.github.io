import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lista_de_presentes/modules/admin/crud_screen.dart';
import 'package:lista_de_presentes/modules/admin/orders_screen.dart';
import 'package:lista_de_presentes/modules/admin/status_screen.dart';
import 'package:lista_de_presentes/modules/user/screens/cart_screen.dart';
import 'package:lista_de_presentes/modules/user/screens/home_screen.dart';
import 'package:lista_de_presentes/modules/user/screens/present_screen.dart';

class StandardScreen extends StatefulWidget {
  final Function(int)? onPageChanged;
  const StandardScreen({super.key, this.onPageChanged});

  @override
  State<StandardScreen> createState() => StandardScreenState();
}

class StandardScreenState extends State<StandardScreen> {
  int _selectedIndex = 0;
  late Future<String?> _userRoleFuture = Future.value(null);

  @override
  void initState() {
    super.initState();
    _userRoleFuture = _getUserRole();
  }

  Future<String?> _getUserRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      return userDoc.data()?['role'] as String?;
    }
    return null;
  }

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _userRoleFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final userRole = snapshot.data;
        List<Widget> pages = [];
        List<Widget> drawerItems = [];

        if (userRole == 'admin') {
          pages = [
            const StatusScreen(),
            const CrudScreen(),
            const OrdersScreen(),
          ];
          drawerItems = [
            _buildDrawerItem(
              icon: const Icon(
                Icons.timeline,
                color: Color.fromARGB(255, 253, 243, 222),
              ),
              title: "S T A T U S",
              onTap: () => changePage(0),
            ),
            _buildDrawerItem(
              icon: const Icon(
                Icons.settings_outlined,
                color: Color.fromARGB(255, 253, 243, 222),
              ),
              title: "C O N F I G U R A R",
              onTap: () => changePage(1),
            ),
            _buildDrawerItem(
              icon: const Icon(
                Icons.assignment_outlined,
                color: Color.fromARGB(255, 253, 243, 222),
              ),
              title: "P E D I D O S",
              onTap: () => changePage(2),
            ),
          ];
        } else {
          pages = [
            const HomeScreen(),
            const PresentScreen(),
            const CartScreen(),
          ];
          drawerItems = [
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: _buildDrawerItem(
                icon: Image.asset(
                  'assets/images/home.png',
                  color: Color.fromARGB(255, 253, 243, 222),
                  height: 25,
                ),
                title: "I N Í C I O",
                onTap: () => changePage(0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: _buildDrawerItem(
                icon: Image.asset(
                  'assets/images/coração.png',
                  color: Color.fromARGB(255, 253, 243, 222),
                  height: 20,
                ),
                title: "P R E S E N T E S",
                onTap: () => changePage(1),
              ),
            ),
            _buildDrawerItem(
              icon: Image.asset('assets/images/carrinho2.png', height: 30),
              title: "C A R R I N H O",
              onTap: () => changePage(2),
            ),
          ];
        }

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 253, 243, 222),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 39, 93, 80),
            elevation: 0,
            leading: Builder(
              builder:
                  (context) => IconButton(
                    icon: const Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Icon(
                        Icons.menu,
                        color: Color.fromARGB(255, 253, 243, 222),
                      ),
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
            ),
            title: Center(
              child: Text(
                'Lista de Presentes',
                style: GoogleFonts.greatVibes(
                  color: const Color.fromARGB(255, 253, 243, 222),
                  fontSize: 34,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            actions: <Widget>[
              if (userRole == 'user')
                IconButton(
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Image.asset(
                      'assets/images/carrinho2.png',
                      height: 30,
                    ),
                  ),
                  onPressed: () => changePage(2, fromDrawer: false),
                ),
            ],
          ),
          drawer: Drawer(
            backgroundColor: const Color.fromARGB(255, 39, 93, 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: DrawerHeader(
                        child: Image.asset('assets/images/presente.png'),
                      ),
                    ),
                    ...drawerItems,
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
                  child: GestureDetector(
                    onTap: logout,
                    child: ListTile(
                      leading: const Icon(
                        Icons.logout,
                        color: Color.fromARGB(255, 253, 243, 222),
                      ),
                      title: Text(
                        'Sair',
                        style: GoogleFonts.cormorantSc(
                          color: Color.fromARGB(255, 253, 243, 222),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: IndexedStack(index: _selectedIndex, children: pages),
        );
      },
    );
  }

  void changePage(int index, {bool fromDrawer = true}) {
    setState(() {
      _selectedIndex = index;
    });
    if (fromDrawer) {
      Navigator.pop(context);
    }
  }

  Widget _buildDrawerItem({
    required Widget icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: ListTile(
        leading: Align(
          alignment: Alignment.centerLeft,
          widthFactor: 1.0,
          child: icon,
        ),
        title: Text(
          title,
          style: GoogleFonts.cormorantSc(
            color: const Color.fromARGB(255, 253, 243, 222),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
