import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:myfinance_app/currency/utils/currencies.dart' as all_currencies;


import '../../currency/model/currency.dart';
import '../ui/theme.dart';

class Utils {
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  static void showAlertDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String primaryActionLabel,
    required Function onPrimaryActionClicked,
    String? secondaryActionLabel,
    Function? onSecondaryActionClicked,
  }) {
    showDialog(
        context: context,
        builder: (ctx) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              icon: const Icon(Icons.warning_amber_rounded, size: 30),
              titleTextStyle:
                  AppTextTheme.textButtonStyle.copyWith(fontSize: 18),
              title: Text(title),
              contentTextStyle: AppTextTheme.normalTextStyle,
              content: Text(content),
              actions: [
                secondaryActionLabel != null ? TextButton(
                  onPressed: () => onSecondaryActionClicked!(),
                  child: Text(
                    secondaryActionLabel,
                    style: AppTextTheme.textButtonStyle,
                  ),
                ):const SizedBox.shrink(),
                TextButton(
                  onPressed: () => onPrimaryActionClicked(),
                  child: Text(primaryActionLabel,
                      style: AppTextTheme.textButtonStyle.copyWith(
                          color: Theme.of(context).colorScheme.primary)),
                ),
              ],
            ),
          );
        });
  }

  static String dateFormat({required DateTime date, bool showDays = true}) {
    if(showDays) {
      return intl.DateFormat.yMMMd('ar').format(date);
    } else {
      return intl.DateFormat('MMMM yyyy', 'ar').format(date);
    }

  }

  static String emojiFlag(String flag){
    // 0x41 is Letter A
    // 0x1F1E6 is Regional Indicator Symbol Letter A
    // Example :
    // firstLetter U => 20 + 0x1F1E6
    // secondLetter S => 18 + 0x1F1E6
    // See: https://en.wikipedia.org/wiki/Regional_Indicator_Symbol
    final firstLetter = flag.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final secondLetter = flag.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }

  static List<Currency> currencies(){
    final rowData = all_currencies.currencies;
    rowData.sort((a, b) => a['name'].compareTo(b['name']));
    return rowData.map((currency) => Currency.fromJson(json: currency)).toList();
  }

}
