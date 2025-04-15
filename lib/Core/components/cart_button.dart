import 'package:flutter/material.dart';

import '../Utilts/Constants.dart';

class CartButton extends StatelessWidget {
  const CartButton({
    super.key,
    required this.price,
    this.afterDiscountPrice,
    this.color,
    required this.title,
    required this.subTitle,
    required this.press,
  });

  final double price;
  final Color? color;
  final double? afterDiscountPrice;
  final String title, subTitle;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:  EdgeInsets.symmetric(
            horizontal: SizeApp.defaultPadding, vertical: SizeApp.borderRadius / 2),
        child: SizedBox(
          height: 64,
          child: Material(
            color: color ?? ColorApp.primaryColor,
            clipBehavior: Clip.hardEdge,
            shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(SizeApp.borderRadius),
              ),
            ),
            child: InkWell(
              onTap: press,
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding:  EdgeInsets.symmetric(
                          horizontal: SizeApp.defaultPadding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              text: "EG${(afterDiscountPrice ?? price).toStringAsFixed(2)}  ",
                              style: Theme.of(context).textTheme.titleSmall!
                                  .copyWith(color: Colors.white),
                              children: [
                                if (afterDiscountPrice != price)
                                  TextSpan(
                                    text: "EG${price.toStringAsFixed(2)}",
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Theme.of(context).textTheme.bodySmall!.color,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Text(
                            subTitle,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      alignment: Alignment.center,
                      height: double.infinity,
                      color: Colors.black.withOpacity(0.15),
                      child: Text(
                        title,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
