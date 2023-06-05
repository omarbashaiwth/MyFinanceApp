import 'package:flutter/material.dart';

import '../../../core/ui/theme.dart';

class OnBoardingImage extends StatelessWidget {
  final String image;
  const OnBoardingImage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  ClipOval(
      child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: lightRedColor.withOpacity(0.5)
          ),
          child: Image.asset(image)
      ),
    );
  }
}
