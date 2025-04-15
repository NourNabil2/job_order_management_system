import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Utilts/Assets_Manager.dart';
import 'package:quality_management_system/Features/Dashboard/view/mainScreen.dart';

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
  NavItem(label: 'Overview', assetPath: AssetsManager.menuIcon, screen: const MainScreen()),
  NavItem(label: 'Add Orders', assetPath: AssetsManager.invoiceIcon, screen: const MainScreen()),
  NavItem(label: '----', assetPath: AssetsManager.invoiceIcon, screen: const MainScreen()),
];

