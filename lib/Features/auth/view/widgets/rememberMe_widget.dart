import 'package:flutter/material.dart';
import 'package:quality_management_system/Core/Utilts/Constants.dart';

class RememberMeRow extends StatelessWidget {
  final bool isRememberMe;
  final ValueChanged<bool?> onChanged;

  const RememberMeRow({
    Key? key,
    required this.isRememberMe,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isRememberMe,
          onChanged: onChanged,
          activeColor: ColorApp.primaryColor, // لون صح الاختيار
        ),
        const SizedBox(width: 8),
        Text(
          'Remember me',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
