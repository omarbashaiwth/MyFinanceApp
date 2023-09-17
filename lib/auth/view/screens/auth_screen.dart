import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfinance_app/auth/controller/auth_controller.dart';
import 'package:myfinance_app/auth/view/widgets/auth_logo.dart';
import 'package:myfinance_app/auth/view/widgets/auth_form.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/main.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../../../core/utils/utils.dart';
import '../../controller/services/firebase_auth_services.dart';
import 'reset_password_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthController>(context);
    final auth = FirebaseAuth.instance;
    final formKey = GlobalKey<FormState>();
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 40),
                AuthLogo(
                    image: provider.isLogin
                        ? 'assets/images/log_in.png'
                        : 'assets/images/sign_up.png',
                    text: provider.isLogin ? 'تسجيل الدخول' : 'حساب جديد'),
                const SizedBox(height: 50),
                AuthForm(formKey: formKey),
                const SizedBox(height: 2),
                provider.isLogin
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () {
                              Get.to(() => const ResetPasswordScreen());
                            },
                            child: Text('نسيت كلمة المرور؟',
                                style: AppTextTheme.textButtonStyle.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary)),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                        ],
                      )
                    : const SizedBox(
                        height: 18,
                      ),
                ElevatedButton(
                  onPressed: () async {
                    final isValid = formKey.currentState?.validate();
                    debugPrint("clicked: $isValid");
                    if (isValid != null && isValid) {
                      formKey.currentState?.save();
                      await FirebaseAuthServices.emailPasswordAuth(
                          backgroundColor:
                              Theme.of(context).colorScheme.onBackground,
                          context: context,
                          user: provider.user,
                          isLogin: provider.isLogin,
                          screenHeight: screenHeight,
                          onShowLoadingDialog: () => Utils.showLoadingDialog(
                              context, 'جاري التحقق من البيانات...'),
                          onHideLoadingDialog: () => Utils.hideLoadingDialog(),
                          onTag: (String tag) async {
                            FirebaseAuthServices.showMessageToUser(
                                auth: auth,
                                tag: tag,
                                context: context,
                                content: (msg) => Text(msg));
                          },
                          onNavigateToHomeScreen: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const MyHomePage()));
                          });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    provider.isLogin ? 'تسجيل الدخول' : 'إنشاء حساب',
                    style: AppTextTheme.elevatedButtonTextStyle,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => FirebaseAuthServices.googleAuth(
                    screenHeight: screenHeight,
                    context: context,
                    backgroundColor: Theme.of(context).colorScheme.onBackground,
                  ),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      backgroundColor:
                          Theme.of(context).colorScheme.onPrimaryContainer),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 20),
                      Text(
                        provider.isLogin
                            ? 'تسجيل الدخول من خلال حساب قوقل'
                            : 'إنشاء حساب من خلال قوقل',
                        style: AppTextTheme.normalTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                      const SizedBox(width: 20),
                      Image.asset('assets/images/Google_logo.png'),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(provider.isLogin ? 'ليس لديك حساب؟ ' : 'لديك حساب؟ ',
                        style: AppTextTheme.normalTextStyle.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary)),
                    GestureDetector(
                      child: Text(
                          provider.isLogin
                              ? 'قم بإنشاء حساب جديد'
                              : 'قم بتسجيل الدخول',
                          style: AppTextTheme.normalTextStyle.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold)),
                      onTap: () {
                        provider.onLoginStateChange(!provider.isLogin);
                      },
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
