import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Utilts/Assets_Manager.dart';
import 'package:quality_management_system/Features/Dashboard/view/mainScreen.dart';
import 'package:quality_management_system/Features/auth/view/screens/add_member_screen.dart';

class NavItem {
  final String label;
  final String assetPath;
  final Widget screen;

  NavItem({
    required this.label,
    required this.assetPath,
    required this.screen,
  });
}

final List<NavItem> navItems = [
  NavItem(
      label: '  الرئيسية',
      assetPath: AssetsManager.menuIcon,
      screen: const MainScreen()),
  NavItem(
      label: '  أوامر التوريد',
      assetPath: AssetsManager.invoiceIcon,
      screen: const MainScreen()),
  NavItem(
      label: '  أوامر التوريد المنتهيه',
      assetPath: AssetsManager.menuIcon,
      screen: const MainScreen()),
  NavItem(
      label: ' تم تحصيلها ',
      assetPath: AssetsManager.menuIcon,
      screen: const MainScreen()),
  NavItem(
      label: '  أوامر التوريد قيد العمل',
      assetPath: AssetsManager.menuIcon,
      screen: const MainScreen()),
  NavItem(
      label: '  الموظفين',
      assetPath: AssetsManager.addMember,
      screen:  const MainScreen()
      ),
];

final List<NavItem> navItemsForWorkers = [
  NavItem(
      label: '  الرئيسية',
      assetPath: AssetsManager.menuIcon,
      screen: const MainScreen()),
  NavItem(
      label: '  جميع أوامر التوريد',
      assetPath: AssetsManager.menuIcon,
      screen: const MainScreen()),
  NavItem(
      label: '  أومر التوريد الجديده',
      assetPath: AssetsManager.menuIcon,
      screen: const MainScreen()),
  NavItem(
      label: '  أوامر التوريد قيد العمل',
      assetPath: AssetsManager.menuIcon,
      screen: const MainScreen()),
  NavItem(
      label: '  أوامر التوريد المنتهيه',
      assetPath: AssetsManager.menuIcon,
      screen: const MainScreen()),
];

final List<NavItem> navItemsForCollector = [
  NavItem(
      label: '  أوامر التوريد المنتهيه',
      assetPath: AssetsManager.menuIcon,
      screen: const MainScreen()),
  NavItem(
      label: ' تم تحصيلها ',
      assetPath: AssetsManager.menuIcon,
      screen: const MainScreen()),
];
