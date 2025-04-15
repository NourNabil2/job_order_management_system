import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Utilts/Constants.dart';
import 'order_process.dart';

class OrderStatusCard extends StatelessWidget {
  const OrderStatusCard({
    super.key,
    required this.orderId,
    required this.placedOn,
    this.products,
    required this.orderStatus,
    required this.processingStatus,
    required this.shippedStatus,
    required this.deliveredStatus,
    this.press,
    this.isCancled = false,
  });

  final String orderId, placedOn;
  final List<Widget>? products;
  final OrderProcessStatus orderStatus,
      processingStatus,
      shippedStatus,
      deliveredStatus;
  final VoidCallback? press;
  final bool isCancled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius:
           BorderRadius.all(Radius.circular(SizeApp.borderRadius)),
      onTap: press,
      child: Container(
        margin:  EdgeInsets.all(SizeApp.borderRadius),
        decoration: BoxDecoration(
          borderRadius:  BorderRadius.all(Radius.circular(SizeApp.borderRadius)),
          border: Border.all(
            color: Theme.of(context).dividerColor, // Semi-transparent color
            width: 0.5, // Thin border
          ),
        ),


        child: Column(
          children: [
            Padding(
              padding:  EdgeInsets.all(SizeApp.defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextStyle(
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color:
                              Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                        child: Row(
                          children: [
                            const Text("Order"),
                             SizedBox(width: SizeApp.defaultPadding / 2),
                            Text("#$orderId"),
                          ],
                        ),
                      ),
                       SizedBox(height: SizeApp.defaultPadding / 2),
                      Text(
                        "Placed on $placedOn",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                  SvgPicture.asset(
                    "assets/icons/miniRight.svg",
                    height: 24,
                    width: 24,
                    colorFilter: ColorFilter.mode(
                        Theme.of(context).dividerColor, BlendMode.srcIn),
                  )
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding:  EdgeInsets.symmetric(vertical: SizeApp.defaultPadding),
              child: OrderProgress(
                orderStatus: orderStatus,
                processingStatus: processingStatus,
                shippedStatus: shippedStatus,
                deliveredStatus: deliveredStatus,
                isCanceled: isCancled,
              ),
            ),
            Padding(
              padding:
                   EdgeInsets.symmetric(horizontal: SizeApp.defaultPadding),
              child: Column(
                children: products ?? [],
              ),
            )
          ],
        ),
      ),
    );
  }
}
