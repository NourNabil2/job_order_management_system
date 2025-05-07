// navbar.dart
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quality_management_system/Core/Network/local_db/share_preference.dart';
import 'package:quality_management_system/Core/Utilts/Assets_Manager.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Utilts/Responsive_Helper.dart';
import 'package:quality_management_system/Core/Widgets/CustomAppBar_widget.dart';
import 'package:quality_management_system/Core/Widgets/CustomIcon.dart';
import 'package:quality_management_system/Core/Widgets/Custom_Button_widget.dart';
import 'package:quality_management_system/Features/Dashboard/view/mainScreen.dart';
import 'package:quality_management_system/Core/models/nav_Item_model.dart';
import 'package:quality_management_system/Features/auth/view/screens/memberTable_Screen.dart';
import 'package:quality_management_system/Features/auth/view/screens/signin_screen.dart';
import 'package:quality_management_system/Features/settings/view/setting_page.dart';
import 'package:sidebarx/sidebarx.dart';
import 'Core/Serviecs/Firebase_Notification.dart';
import 'Core/Widgets/alert_widget.dart';
import 'Features/OrderTableDetails/view/Screens/OrdersDetails.dart';

class Navbar extends StatefulWidget {
  final String? role;

  Navbar({super.key, this.role});
  static String id = 'Mainscreen';


  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int selectedIndex = 0;


  final List<Widget> _adminScreens = [
    const MainScreen(),
    const OrdersTableDetails(),
    const MembertableScreen(),
  ];

  final List<Widget> _userScreens = [
    const OrdersTableDetails(),
  ];


  void _fetchUserRole() async {

    setState(() {
      CashSaver.userRole = widget.role;
    });

    log('state.userData.role1111 ${widget.role}');
  }


  @override
  void initState() {
    NotificationHelper.getFirebaseMessagingToken();
   // NotificationHelper.checkSubscriptionStatus();
    super.initState();
    _fetchUserRole();
  }



  final SidebarXController sidebarController = SidebarXController(
    selectedIndex: 0,
    extended: true, // Start with sidebar expanded
  );

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobileBuilder: (context) => Scaffold(
        appBar: CustomAppBar(title: StringApp.overView, icon: AssetsManager.dashboard ,onTap: () {
          showCustomOptionsDialog(
            context: context,
            title: 'تسجيل الخروج',
            content: 'هل أنت متأكد أنك تريد تسجيل الخروج من حسابك؟',
            confirmText: 'نعم',
            onConfirm: () async {
              // تنفيذ تسجيل الخروج من Firebase
              await FirebaseAuth.instance.signOut();
              await CashSaver.clearAllData();
              // التنقل لصفحة تسجيل الدخول مع حذف كل الصفحات السابقة
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const SigninScreen()),
                    (route) => false,
              );
            },
          );
        } ,),
        body: SingleChildScrollView(child: _getSelectedScreen()),
          bottomNavigationBar: CashSaver.userRole == 'admin' ? BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: List.generate(
            CashSaver.userRole == 'admin'? navItems.length : navItemsForWorkers.length,
                (index) => BottomNavigationBarItem(
              icon: CustomIcon(
                assetPath: CashSaver.userRole == 'admin'? navItems[index].assetPath : navItemsForWorkers[index].assetPath ,
                color: index == selectedIndex
                    ? ColorApp.mainLight
                    : Colors.grey,
              ),
              label: CashSaver.userRole == 'admin'? navItems[index].label : navItemsForWorkers[index].label ,
            ),
          ),
          selectedItemColor: ColorApp.mainLight,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ) : null ,
      ),
      desktopBuilder: (context) => Scaffold(
        body: Row(
          children: [
            SidebarX(
              controller: sidebarController,
              showToggleButton: true,
              extendedTheme: SidebarXTheme(
                width: 200, // Expanded width
                margin: EdgeInsets.all(SizeApp.padding),
                decoration: BoxDecoration(
                  color: ColorApp.primaryColor,
                  borderRadius: BorderRadius.circular(SizeApp.radius),
                ),
              ),
              theme: SidebarXTheme(
                selectedItemDecoration: BoxDecoration(color: ColorApp.mainLight,borderRadius: BorderRadius.circular(SizeApp.radius)),
                iconTheme: const IconThemeData(color:ColorApp.mainLight),
                width: 70, // Collapsed width
                margin: const EdgeInsets.all(10),
                hoverTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: ColorApp.mainLight),
                decoration: BoxDecoration(
                  color: ColorApp.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: ColorApp.mainLight),
                selectedTextStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(color: ColorApp.primaryColor),

              ),
             extendIcon: Icons.arrow_forward_ios,
              collapseIcon: Icons.arrow_back_ios_new,
              headerBuilder: (context, extended) => Padding(
                padding: EdgeInsets.all(SizeApp.defaultPadding),
                child: CustomIcon(assetPath: AssetsManager.logoWhite,isImage: true,size: SizeApp.logoSize,),
              ),
              footerBuilder: (context, extended) =>  CustomCancelButon(
                text: 'LogOut',
                onTap: () {
                  showCustomOptionsDialog(
                    context: context,
                    title: 'تسجيل الخروج',
                    content: 'هل أنت متأكد أنك تريد تسجيل الخروج من حسابك؟',
                    confirmText: 'نعم',
                    onConfirm: () async {
                      // تنفيذ تسجيل الخروج من Firebase
                      await FirebaseAuth.instance.signOut();
                      await CashSaver.clearAllData();
                      // التنقل لصفحة تسجيل الدخول مع حذف كل الصفحات السابقة
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const SigninScreen()),
                            (route) => false,
                      );
                    },
                  );
                },
        ),
              footerDivider: const Divider(thickness: 0.3,),
              items: List.generate(
                CashSaver.userRole == 'admin'? navItems.length : navItemsForWorkers.length,
                    (index) => SidebarXItem(
                  iconBuilder: (selected, hovered) => CustomIcon(assetPath: CashSaver.userRole == 'admin'? navItems[index].assetPath : navItemsForWorkers[index].assetPath,color: selectedIndex == index ? ColorApp.primaryColor : ColorApp.mainLight, size: SizeApp.iconSizeMedium,),
                  label: CashSaver.userRole == 'admin'? navItems[index].label : navItemsForWorkers[index].label ,
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
    if (CashSaver.userRole == 'admin') {
      return _adminScreens[selectedIndex];
    } else {
      return _userScreens[selectedIndex];
    }
  }


}