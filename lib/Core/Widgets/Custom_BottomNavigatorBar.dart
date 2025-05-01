import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';
import 'package:quality_management_system/Core/Widgets/alert_widget.dart';
import 'package:quality_management_system/Core/components/cart_button.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({
    super.key,
    this.onTap,
    required this.orderId,
    required this.address,
    required this.totalPrice,
    required this.status,
    required this.name,
    required this.phone,
    required this.deliveryFee,
  });

  final VoidCallback? onTap;
  final String name;
  final String phone;
  final double deliveryFee;
  final String address;
  final String status;
  final int orderId;
  final double totalPrice;

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  bool isBottomBarVisible = true; // State to track visibility
  @override
  Widget build(BuildContext context) {
    void toggleVisibility() {
      setState(() {
        isBottomBarVisible = !isBottomBarVisible; // Toggle visibility
      });
    }

    // Handle canceling the order
    void handleCancelOrder() {
      showCustomOptionsDialog(
        context: context,
        title: 'Cancel Order',
        content: 'Once canceled, it cannot be restored.',
        confirmText: 'Yes, Cancel Order',
        onConfirm: () {
          Navigator.of(context).pop();
          // Perform canceling action
          // OrdersCubit.get(context).cancelOrder(widget.orderId);
          // OrdersCubit.get(context).fetchOrders();
          Navigator.of(context).pop();
        },
        onCancel: () {
          // Optional cancel action
          Navigator.of(context).pop();
        },
      );
    }

    return Column(
      children: [
        IconButton(
          onPressed: toggleVisibility,
          icon: Icon(
            isBottomBarVisible ? Icons.expand_less : Icons.expand_more,
            color: Theme.of(context).primaryColor,
          ),
          padding:
              EdgeInsets.all(SizeApp.s10), // Remove padding for a compact look
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: isBottomBarVisible
              ? Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(SizeApp.s20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: SizeApp.s10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.all(SizeApp.defaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Align content to the start
                          children: [
                            Text(
                              "Order Info ",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(
                                height:
                                    5), // Small space between label and value
                            // Name
                            Text(
                              'Name:',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(
                                height:
                                    5), // Small space between label and value
                            Text(
                              widget.name,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16), // Space between rows

                            // Address
                            Text(
                              'Address:',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(
                                height:
                                    5), // Small space between label and value
                            Text(
                              widget.address,
                              maxLines: 2,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16), // Space between rows

                            // Mobile
                            Text(
                              'Mobile:',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            const SizedBox(
                                height:
                                    5), // Small space between label and value
                            Text(
                              widget.phone,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16), // Space between rows

                            // Status
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Status:',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                // StatusContainer(
                                //   status: widget.status,
                                //   title: widget.status,
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      CartButton(
                        color: widget.status == 'pending'
                            ? ColorApp.errorColor
                            : ColorApp.blackColor60,
                        title: widget.status == 'pending'
                            ? "Cancel Order"
                            : widget.status,
                        subTitle: 'Total price',
                        price: widget.totalPrice,
                        press: widget.status == 'pending'
                            ? handleCancelOrder
                            : () {},
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(), // Return empty widget when hidden
        ),
      ],
    );
  }
}

// Custom row widget
Widget CustomRow2({required String title, required Widget value}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        value,
      ],
    ),
  );
}

// Custom row value as string for name, phone, etc.
Widget CustomRow({required String title, required String value}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          // Use Expanded to ensure proper handling of large content
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.visible, // Make sure text isn't truncated
            softWrap: true, // Wrap text to next line if too long
          ),
        ),
      ],
    ),
  );
}
