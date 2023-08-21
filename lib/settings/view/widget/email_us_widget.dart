import 'package:flutter/material.dart';

class EmailUsWidget extends StatelessWidget {
  final Function() onEmailUsClicked;
  const EmailUsWidget({super.key, required this.onEmailUsClicked});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEmailUsClicked,
      child: Container(
        margin: const EdgeInsets.only(left: 12),
        child: Row(
          children: [
            Expanded(
                child: Row(
                  children: [
                    Icon(Icons.email, color: Theme.of(context).colorScheme.onPrimary),
                    const SizedBox(width: 8),
                    Text(
                      'راسلنا عبر البريد الالكتروني بمقترحاتك أو استفساراتك',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 12,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                )),
            Icon(Icons.keyboard_arrow_left_rounded, color: Theme.of(context).colorScheme.onPrimary),
          ],
        ),
      ),
    );
  }
}
