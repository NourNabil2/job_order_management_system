// navbar.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quality_management_system/Core/Utilts/Assets_Manager.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Utilts/Responsive_Helper.dart';
import 'package:quality_management_system/Core/Widgets/CustomAppBar_widget.dart';
import 'package:quality_management_system/Core/Widgets/CustomIcon.dart';
import 'package:quality_management_system/Features/Dashboard/view/mainScreen.dart';
import 'package:quality_management_system/Core/models/nav_Item_model.dart';
import 'package:quality_management_system/Features/auth/view/screens/add_member_screen.dart';
import 'package:sidebarx/sidebarx.dart';
import 'Features/OrderTableDetails/view/Screens/OrdersDetails.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});
  static String id = 'Mainscreen';

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int selectedIndex = 0;
  final SidebarXController sidebarController = SidebarXController(
    selectedIndex: 0,
    extended: true, // Start with sidebar expanded
  );

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobileBuilder: (context) => Scaffold(
        appBar: const CustomAppBar(title: StringApp.overView, icon: AssetsManager.dashboard),
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
            SidebarX(
              controller: sidebarController,
              showToggleButton: true,
              extendedTheme: SidebarXTheme(
                width: 200, // Expanded width
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ColorApp.primaryColor,
                  borderRadius: BorderRadius.circular(SizeApp.radius),
                ),
              ),
              theme: SidebarXTheme(
                width: 70, // Collapsed width
                margin: const EdgeInsets.all(10),
                hoverColor: Colors.white,
                hoverTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: ColorApp.mainLight),
                decoration: BoxDecoration(
                  color: ColorApp.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: ColorApp.greyColor),
                selectedTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: ColorApp.mainLight),

              ),
              items: List.generate(
                navItems.length,
                    (index) => SidebarXItem(

                  iconBuilder: (selected, hovered) => SvgPicture.asset(navItems[index].assetPath,colorFilter: ColorFilter.mode(selectedIndex == index ? ColorApp.mainLight : ColorApp.greyColor, BlendMode.srcIn),),
                  label: navItems[index].label,
                      onTap: () => selectedIndex = index,
                ),
              ),
            ),
            Expanded(
              child: AnimatedBuilder(
                animation: sidebarController,
                builder: (context, child) {
                  return _getSelectedScreen();
                },
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
        return const OrdersTableDetails();
      case 2:
        return const AddMemberScreen();
      default:
        return const MainScreen();
    }
  }
}