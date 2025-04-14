// navbar.dart
import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Features/Dashboard/view/mainScreen.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});
  static String id = 'Mainscreen';
  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  bool isExpanded = false;
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: isExpanded,
            backgroundColor: ColorApp.primaryColor,
            unselectedIconTheme: const IconThemeData(color: ColorApp.mainLight),
            unselectedLabelTextStyle: const TextStyle(color: ColorApp.mainLight),
            selectedIconTheme: const IconThemeData(color: ColorApp.primaryColor),
            selectedLabelTextStyle: const TextStyle(color: ColorApp.mainLight),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text("OverView"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.library_books_sharp),
                label: Text("Orders"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.description),
                label: Text("Workers"),
              ),
            ],
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          icon: const Icon(Icons.menu),
                        ),
                        Image.asset(
                          'assets/images/logo1.png',
                          width: 200,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                    if (selectedIndex == 0)
                      const MainScreen()
                    else if (selectedIndex == 1)
                      MainScreen()
                    else if (selectedIndex == 2)
                      const MainScreen()
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
