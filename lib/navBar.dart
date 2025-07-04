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
import 'package:quality_management_system/Features/OrderTableDetails/view/Screens/OrdersTableDetails_Prograss.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view/Screens/OrdersTableDetails_collected.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view/Screens/OrdersTableDetails_completed.dart';
import 'package:quality_management_system/Features/OrderTableDetails/view/Screens/OrdersTableDetails_pennding.dart';
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
    const OrdersTableDetailsCompleted(),
    const OrdersTableDetailsCollected(),
    const OrdersTableDetailsProgress(),
    const MembertableScreen(),

  ];

  final List<Widget> _userScreens = [
    const MainScreen(),
    const OrdersTableDetails(),
    const OrdersTableDetailsPending(),
    const OrdersTableDetailsProgress(),
    const OrdersTableDetailsCompleted(),
  ];
  final List<Widget> _collectorScreens = [
    const OrdersTableDetailsCompleted(),
    const OrdersTableDetailsCollected(),
  ];

  void _fetchUserRole() async {
    setState(() {
      CacheSaver.userRole = widget.role;
      if (widget.role == 'admin' || widget.role == 'collector' ) {
        NotificationHelper.checkSubscriptionStatusAdmin();
        NotificationHelper.checkSubscriptionStatus();
      } else {
        NotificationHelper.checkSubscriptionStatus();
      }
    });
  }

  @override
  void initState() {
    NotificationHelper.getFirebaseMessagingToken();
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
          appBar: AppBar(
            title: Text(StringApp.overView),
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
          ),

          drawer: Drawer(
            child: Column(
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(color: ColorApp.mainLight),
                  child: Center(
                    child: Text(
                      'مرحبًا بك!',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: CacheSaver.userRole == 'admin'
                        ? navItems.length
                        : CacheSaver.userRole == 'collector'
                        ? navItemsForCollector.length
                        : navItemsForWorkers.length,
                    itemBuilder: (context, index) {
                      final currentItem = CacheSaver.userRole == 'admin'
                          ? navItems[index]
                          : CacheSaver.userRole == 'collector'
                          ? navItemsForCollector[index]
                          : navItemsForWorkers[index];

                      return ListTile(
                        leading: CustomIcon(
                          assetPath: currentItem.assetPath,
                          color: index == selectedIndex ? ColorApp.mainLight : Colors.grey,
                        ),
                        title: Text(currentItem.label),
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                          Navigator.pop(context); // إغلاق الـ Drawer
                        },
                      );
                    },
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('تسجيل الخروج'),
                  onTap: () {
                    showCustomOptionsDialog(
                      context: context,
                      title: 'تسجيل الخروج',
                      content: 'هل أنت متأكد أنك تريد تسجيل الخروج من حسابك؟',
                      confirmText: 'نعم',
                      onConfirm: () async {
                        await FirebaseAuth.instance.signOut();
                        await CacheSaver.clearAllData();
                        await NotificationHelper.unsubscribeFromTopic('admin');
                        await NotificationHelper.unsubscribeFromTopic('all_users');
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const SigninScreen()),
                              (route) => false,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          body: SingleChildScrollView(child: _getSelectedScreen()),
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
                selectedItemDecoration: BoxDecoration(
                    color: ColorApp.mainLight,
                    borderRadius: BorderRadius.circular(SizeApp.radius)),
                iconTheme: const IconThemeData(color: ColorApp.mainLight),
                width: 70, // Collapsed width
                margin: const EdgeInsets.all(10),
                hoverTextStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: ColorApp.mainLight),
                decoration: BoxDecoration(
                  color: ColorApp.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: ColorApp.mainLight),
                selectedTextStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: ColorApp.primaryColor),
              ),
              extendIcon: Icons.arrow_forward_ios,
              collapseIcon: Icons.arrow_back_ios_new,
              headerBuilder: (context, extended) => Padding(
                padding: EdgeInsets.all(SizeApp.defaultPadding),
                child: CustomIcon(
                  assetPath: AssetsManager.logoWhite,
                  isImage: true,
                  size: SizeApp.logoSize,
                ),
              ),
              footerBuilder: (context, extended) => CustomCancelButon(
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
                      await CacheSaver.clearAllData();
                      NotificationHelper.unsubscribeFromTopic('admin');
                      NotificationHelper.unsubscribeFromTopic('all_users');  // التنقل لصفحة تسجيل الدخول مع حذف كل الصفحات السابقة
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SigninScreen()),
                        (route) => false,
                      );
                    },
                  );
                },
              ),
              footerDivider: const Divider(
                thickness: 0.3,
              ),
              items: List.generate(
                CacheSaver.userRole == 'admin'
                    ? navItems.length
                    :
                CacheSaver.userRole == 'collector' ? navItemsForCollector.length
                : navItemsForWorkers.length,
                (index) => SidebarXItem(
                  iconBuilder: (selected, hovered) => CustomIcon(
                    assetPath: CacheSaver.userRole == 'admin'
                        ? navItems[index].assetPath
                        :
                    CacheSaver.userRole == 'collector' ? navItemsForCollector[index].assetPath
                        : navItemsForWorkers[index].assetPath,
                    color: selectedIndex == index
                        ? ColorApp.primaryColor
                        : ColorApp.mainLight,
                    size: SizeApp.iconSizeMedium,
                  ),
                  label: CacheSaver.userRole == 'admin'
                      ? navItems[index].label
                      :
                  CacheSaver.userRole == 'collector' ? navItemsForCollector[index].label
                      : navItemsForWorkers[index].label,
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
    if (CacheSaver.userRole == 'admin') {
      return _adminScreens[selectedIndex];
    } if (CacheSaver.userRole == 'collector') {
      return _collectorScreens[selectedIndex];
    } else {
      return _userScreens[selectedIndex];
    }
  }
}
