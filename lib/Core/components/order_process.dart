import 'package:flutter/material.dart';
import '../Utilts/Constants.dart';

class OrderProgress extends StatelessWidget {
  const OrderProgress({
    super.key,
    required this.orderStatus,
    required this.processingStatus,
    required this.shippedStatus,
    required this.deliveredStatus,
    this.isCanceled = false,
  });

  final OrderProcessStatus orderStatus,
      processingStatus,
      shippedStatus,
      deliveredStatus;
  final bool isCanceled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ProcessDotWithLine(
            isShowLeftLine: false,
            title: "Ordered",
            status: orderStatus,
            nextStatus: processingStatus,
          ),
        ),
        Expanded(
          child: ProcessDotWithLine(
            isActive: processingStatus == OrderProcessStatus.processing,
            title: "Processing",
            status: processingStatus,
            nextStatus: shippedStatus,
          ),
        ),
        Expanded(
          child: ProcessDotWithLine(
            title: "Shipped",
            status: shippedStatus,
            nextStatus: isCanceled ? OrderProcessStatus.canceled : deliveredStatus,
            isActive: shippedStatus == OrderProcessStatus.processing,
          ),
        ),
        isCanceled
            ? const Expanded(
          child: ProcessDotWithLine(
            title: "Canceled",
            status: OrderProcessStatus.canceled,
            isShowRightLine: false,
            isActive: true,
          ),
        )
            : Expanded(
          child: ProcessDotWithLine(
            title: "Delivered",
            status: deliveredStatus,
            isShowRightLine: false,
            isActive: deliveredStatus == OrderProcessStatus.done,
          ),
        ),
      ],
    );
  }
}

class ProcessDotWithLine extends StatelessWidget {
  const ProcessDotWithLine({
    super.key,
    this.isShowLeftLine = true,
    this.isShowRightLine = true,
    required this.status,
    required this.title,
    this.nextStatus,
    this.isActive = false,
  });

  final bool isShowLeftLine, isShowRightLine;
  final OrderProcessStatus status;
  final OrderProcessStatus? nextStatus;
  final String title;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
            fontWeight: FontWeight.w500,
            color: isActive
                ? Theme.of(context).textTheme.bodyLarge!.color
                : Theme.of(context).textTheme.bodyMedium!.color,
          ),
        ),
         SizedBox(height: SizeApp.defaultPadding / 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isShowLeftLine)
              Expanded(
                child: Container(
                  height: 2,
                  color: lineColor(context, status),
                ),
              ),
            if (!isShowLeftLine) const Spacer(),
            statusWidget(context, status),
            if (isShowRightLine)
              Expanded(
                child: Container(
                  height: 2,
                  color: nextStatus != null
                      ? lineColor(context, nextStatus!)
                      : ColorApp.successColor,
                ),
              ),
            if (!isShowRightLine) const Spacer(),
          ],
        )
      ],
    );
  }
}

enum OrderProcessStatus { done, processing, canceled, notDoneYet }

Widget statusWidget(BuildContext context, OrderProcessStatus status) {
  switch (status) {
    case OrderProcessStatus.processing:
      return CircleAvatar(
        radius: 12,
        backgroundColor:ColorApp. warningColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
            color: Theme.of(context).scaffoldBackgroundColor,
            strokeWidth: 2,
          ),
        ),
      );
    case OrderProcessStatus.notDoneYet:
      return CircleAvatar(
        radius: 12,
        backgroundColor: Theme.of(context).dividerColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
      );
    case OrderProcessStatus.canceled:
      return CircleAvatar(
        radius: 12,
        backgroundColor:ColorApp. errorColor,
        child: Icon(
          Icons.close,
          size: 12,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      );
    default:
      return CircleAvatar(
        radius: 12,
        backgroundColor:ColorApp. successColor,
        child: Icon(
          Icons.done,
          size: 12,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      );
  }
}


Color lineColor(BuildContext context, OrderProcessStatus status) {
  switch (status) {
    case OrderProcessStatus.notDoneYet:
      return Theme.of(context).dividerColor;

    case OrderProcessStatus.processing:
      return ColorApp. warningColor;

    case OrderProcessStatus.canceled:
      return ColorApp. errorColor;

    default:
      return ColorApp. successColor;
  }
}
