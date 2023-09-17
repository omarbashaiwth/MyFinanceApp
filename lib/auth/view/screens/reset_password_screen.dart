import 'package:flutter/material.dart';
import 'package:myfinance_app/auth/controller/auth_controller.dart';
import 'package:myfinance_app/auth/controller/services/firebase_auth_services.dart';
import 'package:myfinance_app/core/utils/utils.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../core/ui/theme.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final authController = Provider.of<AuthController>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon:  Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          title: Text(
            'إعادة تعيين كلمة المرور',
            style: AppTextTheme.appBarTitleTextStyle
                .copyWith(color: Theme.of(context).colorScheme.onSecondary),
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Text(
                'أدخل البريد الإلكتروني المرتبط بحسابك وسنرسل بريدًا إلكترونيًا يحتوي على إرشادات لإعادة تعيين كلمة المرور الخاصة بك',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Tajawal',
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
              const SizedBox(height: 30),
              TextField(
                decoration: InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  labelStyle: TextStyle(
                      fontFamily: 'Tajawal',
                      color: Theme.of(context).colorScheme.onPrimary),
                  border: const OutlineInputBorder(),
                ),
                controller: emailController,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (emailController.text.isNotEmpty) {
                    FirebaseAuthServices.resetPassword(
                        email: emailController.text,
                        onMessage: (message, icon) {
                          Utils.showAlertDialog(
                              context: context,
                              icon: icon,
                              title: '',
                              content: Text(message),
                              primaryActionLabel: 'حسناً',
                              onPrimaryActionClicked: () {
                                Get.back();
                              }
                          );
                        },
                      onShowLoadingDialog: () => Utils.showLoadingDialog(context, 'جاري إرسال البريد الإلكتروني ...'),
                      onHideLoadingDialog: () => Utils.hideLoadingDialog()
                    );
                  } else {
                    Utils.showAlertDialog(
                        context: context,
                        icon: Icons.error,
                        title: '',
                        content: const Text('الرجاء إدخال البريد الإلكتروني'),
                        primaryActionLabel: 'حسناً',
                        onPrimaryActionClicked: () {
                          Get.back();
                        }
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: orangeyRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 14,
                  ),
                ),
                child: Text(
                  'إرسال',
                  style: AppTextTheme.elevatedButtonTextStyle
                      .copyWith(color: white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
