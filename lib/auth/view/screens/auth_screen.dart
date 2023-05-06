import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfinance_app/auth/controller/auth_controller.dart';
import 'package:myfinance_app/auth/model/my_user.dart';
import 'package:myfinance_app/auth/view/widgets/app_logo.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/main.dart';
import 'package:myfinance_app/transactions/home/view/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../../controller/services/firebase_auth_services.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({Key? key}) : super(key: key);

  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  final MyUser _user = MyUser('','','');

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthController>(context);
    final silentProvider = Provider.of<AuthController>(context, listen: false);
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),
          buildAppLogo(logoImage: 'assets/images/Logo.png', name: 'MyFinance'),
          const SizedBox(height: 24),
          _buildForm(context),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {},
                style: ButtonStyle(
                    overlayColor:
                    MaterialStateProperty.all(Colors.transparent)),
                child: Text(
                  'نسيت كلمة المرور؟',
                  style: AppTextTheme.textButtonStyle
                      .copyWith(decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(width: 50),
              provider.isLoading ? const CircularProgressIndicator() : Container()

            ],
          ),
          ElevatedButton(
            onPressed: () async {
              final isValid = _formKey.currentState?.validate();
              FocusScope.of(context).unfocus();
              if (isValid != null && isValid) {
                _formKey.currentState?.save();
                await FirebaseAuthServices(_auth).firebaseAuth(
                  user: _user,
                  isLogin: provider.isLogin,
                  context: context,
                  onLoading: (bool loading) {
                    silentProvider.onLoadingStateChange(loading);
                    // setState(() => _isLoading = loading);
                  },
                  onMessage: (String msg) async {
                    FirebaseAuthServices.showMessageToUser(_auth, msg, context);
                  },
                );
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ),
            child: Text(
              provider.isLogin ? 'تسجيل الدخول' : 'إنشاء حساب',
              style: AppTextTheme.elevatedButtonTextStyle,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                backgroundColor:
                Theme
                    .of(context)
                    .colorScheme
                    .secondaryContainer),
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
                    provider.isLogin ? 'قم بإنشاء حساب جديد' : 'قم بتسجيل الدخول',
                    style: AppTextTheme.normalTextStyle.copyWith(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .primary,
                        fontWeight: FontWeight.bold)),
                onTap: () {
                  silentProvider.onLoginStateChange(!provider.isLogin);
                  // setState(() => _isLogin = !_isLogin);
                },
              ),
            ],
          )
        ],
      ),
    );
  }



  Widget _buildForm(BuildContext context) {
    final provider = Provider.of<AuthController>(context);
    final silentProvider = Provider.of<AuthController>(context, listen: false);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme
                    .of(context)
                    .colorScheme
                    .secondaryContainer),
            child: TextFormField(
              key: const ValueKey('email'),
              validator: (value) {
                if (value!.isEmpty || !value.contains('@')) {
                  return 'الرجاء قم بإدخال بريد إلكتروني صحيح';
                }
                return null;
              },
              onSaved: (newValue) => _user.email = newValue!,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'البريد الإلكتروني',
                hintStyle: AppTextTheme.hintTextStyle,
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: Theme
                      .of(context)
                      .colorScheme
                      .onSecondaryContainer,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          !provider.isLogin
              ? Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme
                    .of(context)
                    .colorScheme
                    .secondaryContainer),
            child: TextFormField(
              key: const ValueKey('username'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'الرجاء قم بإدخال اسم المستخدم';
                }
                return null;
              },
              onSaved: (newValue) => _user.username = newValue!,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'اسم المستخدم',
                hintStyle: AppTextTheme.hintTextStyle,
                prefixIcon: Icon(
                  Icons.person_2_outlined,
                  color:
                  Theme
                      .of(context)
                      .colorScheme
                      .onSecondaryContainer,
                ),
              ),
            ),
          )
              : Container(),
          !provider.isLogin ? const SizedBox(height: 24) : Container(),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme
                    .of(context)
                    .colorScheme
                    .secondaryContainer),
            child: TextFormField(
              key: const ValueKey('password'),
              onSaved: (newValue) => _user.password = newValue!,
              obscureText: !provider.showPassword,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'الرجاء قم بإدخال كلمة المرور';
                } else if (value.length < 6) {
                  return 'كلمةالمرور يجب أن تكون أكثر من 6 أحرف';
                }
                return null;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'كلمة المرور',
                hintStyle: AppTextTheme.hintTextStyle,
                prefixIcon: Icon(Icons.lock_outline,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .onSecondaryContainer),
                suffixIcon: IconButton(
                  splashColor: Colors.transparent,
                  onPressed: () =>
                      silentProvider.onShowPasswordStateChange(!provider.showPassword),
                      // setState(() => _showPassword = !_showPassword),
                  icon: Icon(
                      provider.showPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color:
                      Theme
                          .of(context)
                          .colorScheme
                          .onSecondaryContainer),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
