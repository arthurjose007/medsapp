// ignore_for_file: avoid_types_as_parameter_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meds/screens/store/stock_screen.dart';
import 'package:meds/screens/store/order_screen.dart';

class StoreMainScreen extends StatefulWidget {
  const StoreMainScreen({super.key});

  @override
  State<StoreMainScreen> createState() => _StoreMainScreenState();
}

class _StoreMainScreenState extends State<StoreMainScreen> {
  final user = FirebaseAuth.instance.currentUser;

  //bottom nav bar
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    //pages
    final List<Widget> pages = <Widget>[
      //medication
      const StockScreen(),
      //order page
      const OrdersScreen(),
    ];

    //scaffold
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(),
      ),
      body: SafeArea(
        child: Center(
          child: pages.elementAt(_selectedIndex),
        ),
      ),

      //bottom navigation
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color.fromARGB(255, 242, 253, 255),
        destinations: const [
          //medications
          NavigationDestination(
            icon: Icon(
              Icons.medication_outlined,
            ),
            label: "Stock",
            selectedIcon: Icon(
              Icons.medication,
              color: Color.fromRGBO(7, 82, 96, 1),
            ),
          ),
          //order
          NavigationDestination(
            icon: Icon(
              Icons.shopping_bag_outlined,
            ),
            label: "Orders",
            selectedIcon: Icon(
              Icons.shopping_bag,
              color: Color.fromRGBO(7, 82, 96, 1),
            ),
          ),
        ],
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int) {
          setState(() {
            _selectedIndex = int;
          });
        },
      ),
    );
  }
}
