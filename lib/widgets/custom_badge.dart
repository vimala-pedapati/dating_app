import 'package:flutter/material.dart';

class CustomBadge extends StatelessWidget {
  // Variables
  final Widget? icon;
  final String? text;
  final TextStyle? textStyle;
  final Color? bgColor;
  final EdgeInsetsGeometry? padding;
  const CustomBadge({
    Key? key,
    this.icon,
    this.text,
    this.bgColor,
    this.textStyle,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: bgColor ?? Colors.white, borderRadius: BorderRadius.circular(15.0)),
        padding: padding ?? const EdgeInsets.all(6.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
                  Icons.location_on,
                  color: Colors.black,
                ) ??
                const SizedBox(width: 0, height: 0),
            icon != null ? const SizedBox(width: 5) : const SizedBox(width: 0, height: 0),
            Text(text ?? "", style: textStyle ?? const TextStyle(color: Colors.black)),
          ],
        ));
  }
}
