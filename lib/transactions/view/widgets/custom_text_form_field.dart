import 'package:flutter/material.dart';

import '../../../core/ui/theme.dart';

class CustomTextFormField extends StatelessWidget {
  final String hint;
  final IconData? leadingIcon;
  final String textFormKey;
  final int maxLines;
  final bool isRequired;
  final bool readOnly;
  final Function? onClick;
  final TextStyle hintStyle;
  final double textSize;
  final TextAlign textAlign;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final Function(String) onSaved;

  const CustomTextFormField(
      {Key? key,
      required this.hint,
      required this.onSaved,
      required this.textFormKey,
      this.leadingIcon,
      this.onClick,
      this.maxLines = 1,
      this.isRequired = true,
      this.readOnly = false,
      this.keyboardType = TextInputType.text,
      this.controller,
      this.hintStyle = AppTextTheme.hintTextStyle,
       this.textSize = 15, this.textAlign = TextAlign.start})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).colorScheme.onPrimaryContainer),
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
        textAlign: textAlign,
        style:  TextStyle(fontFamily: 'Tajawal', fontSize: textSize),
        onTap: () => readOnly ? onClick!() : null,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintTextDirection: TextDirection.rtl,
          hintStyle: hintStyle,
          prefixIcon: leadingIcon != null ? Icon(leadingIcon,
              color: lightGrey): null,
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
