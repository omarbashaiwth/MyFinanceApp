import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/ui/theme.dart';


class CustomDialog extends StatelessWidget {
  final TextEditingController textEditingController;
  final Function onPositiveClick;
  const CustomDialog({Key? key, required this.textEditingController, required this.onPositiveClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        height: 250,
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 40),
                const Expanded(
                    child: Text(
                      'إضافة رصيد',
                      style: TextStyle(fontFamily: 'Tajawal'),
                      textAlign: TextAlign.center,
                    ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(
                    Icons.close,
                    size: 20,
                    color: normalGray,
                  ),
                  splashRadius: 15,
                )
              ],
            ),
            const Divider(),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                const Text(
                  'ريال',
                  style: TextStyle(fontFamily: 'Tajawal', fontSize: 20),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                      ),
                      color: Colors.grey.shade100,
                  ),
                  width: 120,
                  child: TextField(
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.number,
                    controller: textEditingController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: (){
                onPositiveClick();
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: redColor),
                  minimumSize: const Size(100, 40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),
                  ),
              ),
              child:  Text(
                'إضافة',
                style: AppTextTheme
                    .elevatedButtonTextStyle.copyWith(color: blackColor, fontWeight: FontWeight.normal),
              ),
            )
          ],
        ),
      ),
    );
  }
}
