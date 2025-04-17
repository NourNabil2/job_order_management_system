// navbar.dart
import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Utilts/Assets_Manager.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Utilts/Responsive_Helper.dart';
import 'package:quality_management_system/Core/Widgets/CustomAppBar_widget.dart';
import 'package:quality_management_system/Core/Widgets/CustomIcon.dart';
import 'package:quality_management_system/Features/Dashboard/view/mainScreen.dart';
import 'package:quality_management_system/Core/models/nav_Item_model.dart';
import 'package:quality_management_system/Features/auth/view/screens/signup_screen.dart';

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
    return ResponsiveBuilder(
      mobileBuilder: (context) => Scaffold(
        appBar: const CustomAppBar(title: StringApp.overView, icon: AssetsManager.dashboard,),
        body: SingleChildScrollView(child: _getSelectedScreen()),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: List.generate(
            navItems.length,
                (index) => BottomNavigationBarItem(
              icon: CustomIcon(
                assetPath: navItems[index].assetPath,
                color: index == selectedIndex
                    ? ColorApp.primaryColor
                    : Colors.grey,
              ),
              label: navItems[index].label,
            ),
          ),
          selectedItemColor: ColorApp.primaryColor,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
      ),

      desktopBuilder: (context) => Scaffold(
        body: Row(
          children: [
            NavigationRail(
              extended: isExpanded,
              backgroundColor: ColorApp.primaryColor,
              unselectedIconTheme: const IconThemeData(color: ColorApp.mainLight),
              unselectedLabelTextStyle: const TextStyle(color: ColorApp.mainLight),
              selectedIconTheme: const IconThemeData(color: ColorApp.primaryColor),
              selectedLabelTextStyle: const TextStyle(color: ColorApp.mainLight),
              destinations: List.generate(
                navItems.length,
                    (index) {
                  final isSelected = index == selectedIndex;
                  return NavigationRailDestination(
                    icon: CustomIcon(
                      assetPath: navItems[index].assetPath,
                      color: isSelected ? ColorApp.primaryColor : ColorApp.mainLight,
                    ),
                    label: Text(navItems[index].label),
                  );
                },
              ),
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
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
                          CustomIcon(
                            assetPath: AssetsManager.logo,
                            size: SizeApp.logoSize,
                            isImage: true,
                          )
                        ],
                      ),
                      _getSelectedScreen(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getSelectedScreen() {
    switch (selectedIndex) {
      case 0:
        return const MainScreen();
      case 1:
        return const MainScreen();
      case 2:
        return const SignupScreen();
      default:
        return const MainScreen();
    }
  }
}