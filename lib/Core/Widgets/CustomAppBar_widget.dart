import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      title: Text(title,style: Theme.of(context).textTheme.titleLarge),
      leading: MaterialButton(
          onPressed: () => Navigator.pop(context),
          child: SvgPicture.asset("EndPoints.backtIcon" ,height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(
              Theme.of(context).textTheme.titleLarge!.color!,
              BlendMode.srcIn,
            ),)),
    );
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
