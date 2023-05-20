import 'package:flutter/material.dart';

import '../ui/theme.dart';

class EmptyWidget extends StatelessWidget {
  final String imageAsset;
  final double imageSize;
  final String message;
  const EmptyWidget({Key? key, this.imageAsset = 'assets/icons/empty.png',  this.imageSize = 50,  this.message = 'لا يوجد بيانات'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:  [
        Opacity(opacity: 0.6, child: Image.asset(imageAsset, height: imageSize)),
        const SizedBox(height: 10),
        SizedBox(width: double.infinity, child: Text(message, style: AppTextTheme.headerTextStyle, textAlign: TextAlign.center,)),
      ],
    );
  }
}
