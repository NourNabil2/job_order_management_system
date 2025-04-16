import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final String icon;
  final VoidCallback? onTap;
  const CustomAppBar({super.key, required this.title, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      title: Text(title,style: Theme.of(context).textTheme.titleMedium),
      leading:  onTap == null ? Padding(
       padding: EdgeInsets.all(SizeApp.padding),
        child: SvgPicture.asset(icon ,
          colorFilter: ColorFilter.mode(
            Theme.of(context).textTheme.titleLarge!.color!,
            BlendMode.srcIn,
          ),),
      ) : MaterialButton(
          onPressed: onTap,
          child: SvgPicture.asset(icon ,
          height: SizeApp.iconSizeMedium,
            width: SizeApp.iconSizeMedium,
            colorFilter: ColorFilter.mode(
              Theme.of(context).textTheme.titleLarge!.color!,
              BlendMode.srcIn,
            ),)),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
