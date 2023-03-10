import 'package:windows_app/constants/colors.dart';
import 'package:windows_app/constants/styles.dart';
import 'package:flutter/material.dart';

class WhatsAppSectionTitle extends StatelessWidget {
  final String title;
  const WhatsAppSectionTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: h3TextStyle.copyWith(
            color: kActiveTextColor.withOpacity(.8),
          ),
        ),
      ],
    );
  }
}
