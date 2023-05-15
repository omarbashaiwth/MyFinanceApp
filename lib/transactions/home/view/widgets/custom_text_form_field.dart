import 'package:flutter/material.dart';
import 'package:myfinance_app/transactions/home/model/transaction.dart';

import '../../../../core/ui/theme.dart';

class CustomTextFormField extends StatelessWidget {
  final String hint;
  final IconData leadingIcon;
  final String textFormKey;
  final int maxLines;
  final bool isRequired;
  final bool readOnly;
  final Function? onClick;
  final bool hasPrefix;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final Function(String) onSaved;

  const CustomTextFormField(
      {Key? key,
      required this.hint,
      required this.leadingIcon,
      required this.onSaved,
      required this.textFormKey,
      this.onClick,
      this.maxLines = 1,
      this.isRequired = true,
      this.readOnly = false,
      this.hasPrefix = false,
      this.keyboardType = TextInputType.text, this.controller}
      )
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).colorScheme.secondaryContainer
      ),
      child: TextFormField(
        controller: controller,
        key: ValueKey(key),
        onSaved: (newValue) => onSaved(newValue!),
        validator: (value) {
          if (isRequired && value!.isEmpty) {
            return 'هذا الحقل مطلوب';
          }
          return null;
        },
        readOnly: readOnly,
        maxLines: maxLines,
        style: const TextStyle(fontFamily: 'Tajawal'),
        onTap: () => readOnly ? onClick!() : null,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefix: hasPrefix
              ? const Text('- ',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
              : null,
          border: InputBorder.none,
          hintText: hint,
          hintStyle: AppTextTheme.hintTextStyle,
          prefixIcon: Icon(leadingIcon,
              color: Theme.of(context).colorScheme.onSecondaryContainer),
        ),
      ),
    );
  }
}

// Widget customTextFormField({
//   required BuildContext context,
//   required String key,
//   required String hint,
//   required IconData leadingIcon,
//   required Function(String) onSaved,
//   int maxLines = 1,
//   bool isRequired = true,
//   bool readOnly = true,
//   Function? onClick,
//   bool hasPrefix = false,
//   TextInputType keyboardType = TextInputType.text,
// }) {
//   return Container(
//     decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         color: Theme.of(context).colorScheme.secondaryContainer),
//     child: TextFormField(
//       key: ValueKey(key),
//       onSaved: (newValue) => onSaved(newValue!),
//       validator: (value) {
//         if (isRequired && value!.isEmpty) {
//           return 'هذا الحقل مطلوب';
//         }
//         return null;
//       },
//       readOnly: readOnly,
//       maxLines: maxLines,
//       style: const TextStyle(fontFamily: 'Tajawal'),
//       onTap: () => readOnly ? onClick!() : null,
//       keyboardType: keyboardType,
//       decoration: InputDecoration(
//         prefix: hasPrefix
//             ? const Text('- ',
//                 style:
//                     TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
//             : null,
//         border: InputBorder.none,
//         hintText: hint,
//         hintStyle: AppTextTheme.hintTextStyle,
//         prefixIcon: Icon(leadingIcon,
//             color: Theme.of(context).colorScheme.onSecondaryContainer),
//       ),
//     ),
//   );
// }
