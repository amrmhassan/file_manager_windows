// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:windows_app/global/widgets/table/custom_header_cell.dart';
import 'package:windows_app/global/widgets/button_wrapper.dart';
import 'package:windows_app/screens/ext_report_screen/ext_report_screen.dart';
import 'package:flutter/material.dart';

class CustomTableHeader extends StatelessWidget {
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final SortParameter sortParameter;
  final Function(SortParameter sp) setSortParameter;

  const CustomTableHeader({
    Key? key,
    this.backgroundColor,
    this.onTap,
    required this.sortParameter,
    required this.setSortParameter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonWrapper(
      borderRadius: 0,
      onTap: onTap,
      backgroundColor: backgroundColor,
      child: Row(
        children: [
          ...HeaderItem.values.asMap().entries.map(
                (e) => Expanded(
                  child: Container(
                    alignment: e.key == 0
                        ? Alignment.centerLeft
                        : e.key == HeaderItem.values.length - 1
                            ? Alignment.centerRight
                            : Alignment.center,
                    child: CustomHeaderCell(
                      e: e,
                      setSortParameter: setSortParameter,
                      sortParameter: sortParameter,
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
