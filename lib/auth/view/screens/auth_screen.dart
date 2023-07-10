import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfinance_app/auth/controller/auth_controller.dart';
import 'package:myfinance_app/auth/controller/services/google_auth_service.dart';
import 'package:myfinance_app/auth/model/my_user.dart';
import 'package:myfinance_app/auth/view/widgets/app_logo.dart';
import 'package:myfinance_app/auth/view/widgets/auth_form.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/main.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../../controller/services/firebase_auth_services.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthController>(context);
    final silentProvider = Provider.of<AuthController>(context, listen: false);
    final auth = FirebaseAuth.instance;
    final formKey = GlobalKey<FormState>();
    final MyUser user = MyUser('', '', '');
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 40),
                const AppLogo(image: 'assets/images/Logo.png', name: 'مصاريفي'),
                const SizedBox(height: 50),
                AuthForm(formKey: formKey, user: user),
                const SizedBox(height: 2),
                provider.isLogin?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: const Text('نسيت كلمة المرور؟',
                              style: AppTextTheme.textButtonStyle
                          ),
                        ),
                        const SizedBox(width: 50,),
                        provider.isLoading
                            ? const CircularProgressIndicator()
                            : const SizedBox.shrink(),
                      ],
                    )
                : provider.isLoading
                    ? const CircularProgressIndicator()
                    : const SizedBox.shrink(),
                const SizedBox(height: 18,),
                ElevatedButton(
                  onPressed: () async {
                    final isValid = formKey.currentState?.validate();
                    FocusScope.of(context).unfocus();
                    if (isValid != null && isValid) {
                      formKey.currentState?.save();
                      await FirebaseAuthServices.emailPasswordAuth(
                          context: context,
                          user: user,
                          isLogin: provider.isLogin,
                          screenHeight: screenHeight,
                          onLoading: (bool loading) {
                            silentProvider.onLoadingStateChange(loading);
                            // setState(() => _isLoading = loading);
                          },
                          onMessage: (String msg) async {
                            FirebaseAuthServices.showMessageToUser(
                                auth, msg, context);
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
                  onPressed: () => FirebaseAuthServices.googleAuth(screenHeight: screenHeight, context: context),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      backgroundColor:
                          Theme.of(context).colorScheme.secondaryContainer),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 20),
                      Text(
                        provider.isLogin
                            ? 'تسجيل الدخول من خلال حساب قوقل'
                            : 'إنشاء حساب من خلال قوقل',
                        style: AppTextTheme.normalTextStyle,
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
                        style: AppTextTheme.normalTextStyle),
                    GestureDetector(
                      child: Text(
                          provider.isLogin
                              ? 'قم بإنشاء حساب جديد'
                              : 'قم بتسجيل الدخول',
                          style: AppTextTheme.normalTextStyle.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold)),
                      onTap: () {
                        silentProvider.onLoginStateChange(!provider.isLogin);
                        // setState(() => _isLogin = !_isLogin);
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
