import 'package:flutter/material.dart';
import 'package:myfinance_app/core/ui/theme.dart';


class ClickableTextField extends StatelessWidget {
  final String text;
  final String image;
  final Color color;
  final Function onClick;

  const ClickableTextField(
      {Key? key,
      required this.onClick,
      required this.text,
      required this.image,
        this.color = whiteColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onClick(),
      child: Container(
          padding: const EdgeInsets.all(15),
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: color),
          child: Row(
            children: [
              Image.asset(image, width: 24),
              const SizedBox(width: 8),
              Text(text, style: const TextStyle(fontFamily: 'Tajawal')),
            ],
          )),
    );
  }
}
