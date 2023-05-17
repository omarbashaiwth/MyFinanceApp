import 'package:flutter/material.dart';

import '../ui/theme.dart';

class Utils {
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  static void showAlertDialog(
      {required BuildContext context,
      required String title,
      required String content,
        required String positiveLabel,
        required String negativeLabel,
      required Function(BuildContext) onPositiveClick,
      required Function(BuildContext) onNegativeClick,
      }) {
    showDialog(
        context: context,
        builder: (ctx) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              icon: const Icon(Icons.warning_amber_rounded, size: 30),
              titleTextStyle: AppTextTheme.textButtonStyle.copyWith(fontSize: 18),
              title:  Text(title),
              contentTextStyle: AppTextTheme.normalTextStyle,
              content:Text(content),
              actions: [
                TextButton(
                  onPressed: () => onNegativeClick(ctx),
                  child:  Text(negativeLabel, style: AppTextTheme.textButtonStyle,),
                ),
                TextButton(
                  onPressed: () => onPositiveClick(ctx),
                  child:  Text(positiveLabel, style: AppTextTheme.textButtonStyle.copyWith(color: Theme.of(context).colorScheme.primary)),
                ),
              ],
            ),
          );
        });
  }
}
