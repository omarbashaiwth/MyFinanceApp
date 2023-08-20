import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/ui/theme.dart';
import '../../controller/auth_controller.dart';

class AuthForm extends StatelessWidget {
  final Key formKey;
  const AuthForm({Key? key, required this.formKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthController>(context);

    return Form(
      key: formKey,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            child: TextFormField(
              key: const ValueKey('email'),
              validator: (value) {
                if (value!.isEmpty || !value.contains('@')) {
                  return 'الرجاء قم بإدخال بريد إلكتروني صحيح';
                }
                return null;
              },
              onSaved: (value) {
                provider.onEmailChange(value!);
              },
              controller: provider.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration:  const InputDecoration(
                border: InputBorder.none,
                hintText: 'البريد الإلكتروني',
                hintStyle: AppTextTheme.hintTextStyle,
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: lightGrey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          !provider.isLogin
              ? Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).colorScheme.onPrimaryContainer,
               ),
            child: TextFormField(
              key: const ValueKey('username'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'الرجاء قم بإدخال اسم المستخدم';
                }
                return null;
              },
              onSaved: (value) {
                provider.onUsernameChange(value!);
              },
              controller: provider.usernameController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'اسم المستخدم',
                hintStyle: AppTextTheme.hintTextStyle,
                prefixIcon: Icon(
                  Icons.person_2_outlined,
                  color: lightGrey,
                ),
              ),
            ),
          ) : Container(),
          !provider.isLogin ? const SizedBox(height: 24) : Container(),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            child: TextFormField(
              key: const ValueKey('password'),
              obscureText: !provider.showPassword,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'الرجاء قم بإدخال كلمة المرور';
                } else if (value.length < 6) {
                  return 'كلمةالمرور يجب أن تكون أكثر من 6 أحرف';
                }
                return null;
              },
              onSaved: (value) {
                provider.onPasswordChange(value!);
              },
              controller: provider.passwordController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'كلمة المرور',
                hintStyle: AppTextTheme.hintTextStyle,
                prefixIcon: const Icon(Icons.lock_outline,
                    color: lightGrey),
                suffixIcon: IconButton(
                  splashColor: Colors.transparent,
                  onPressed: () => provider.onShowPasswordStateChange(),
                  icon: Icon(
                      provider.showPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color:lightGrey
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
