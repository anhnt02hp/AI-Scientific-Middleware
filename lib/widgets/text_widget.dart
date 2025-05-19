import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({super.key, required this.label, this.fontSize = 18, this.color, this.fontWeight});

  final String label;
  final double fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Nền bo góc và có hiệu ứng nổi
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: color ?? Colors.black,
              fontSize: fontSize,
              fontWeight: fontWeight ?? FontWeight.w500,
            ),
          ),
        ),
      ],
    );

  }
}
