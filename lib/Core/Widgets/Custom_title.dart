import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ticr_notifications/Core/Utilts/Constants.dart';
import 'package:ticr_notifications/Core/Utilts/Assets_Manager.dart';
import 'package:ticr_notifications/Features/product/view/All_Product_screen.dart';


BuildSeeAll(context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AllProducts_user()),
      );
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'See all',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
          height: SizeApp.s20,
          width: SizeApp.s20,
          decoration: BoxDecoration(
              color: ColorApp.bg_gray,
              borderRadius: BorderRadius.circular(SizeApp.s5)),
          child: SvgPicture.asset(
            EndPoints.rightArrowIcon,
            colorFilter: ColorFilter.mode(
              Theme.of(context).textTheme.bodySmall!.color!,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    ),
  );
}


BuildTitleApp(context, String title) {
  return Padding(
    padding: EdgeInsets.only(
        top: SizeApp.s24,
        bottom: SizeApp.s15,
        right: SizeApp.s24,
        left: SizeApp.s24),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        BuildSeeAll(context),
      ],
    ),
  );
}
