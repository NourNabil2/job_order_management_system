import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ticr_notifications/Core/Utilts/Constants.dart';
import 'package:ticr_notifications/Core/Utilts/Assets_Manager.dart';

class NetworkErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const NetworkErrorWidget({
    Key? key,
    required this.errorMessage,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          Image.asset(EndPoints.connectionIcon,width: SizeApp.logoSize,),
          const SizedBox(height: 20),
          Text(errorMessage,style: Theme.of(context).textTheme.bodyMedium,),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}
