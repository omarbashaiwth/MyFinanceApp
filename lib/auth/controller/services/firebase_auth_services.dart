import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfinance_app/auth/controller/services/google_auth_service.dart';
import 'package:myfinance_app/auth/model/my_user.dart';
import 'package:myfinance_app/core/utils/utils.dart';
import 'package:get/get.dart';
import 'package:myfinance_app/currency/controller/currency_controller.dart';
import 'package:myfinance_app/currency/view/currenciesBottomSheet.dart';
import 'package:provider/provider.dart';

class FirebaseAuthServices {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> emailPasswordAuth(
      {required Function(String) onTag,
      required Function onNavigateToHomeScreen,
      required Color backgroundColor,
      required bool isLogin,
      required BuildContext context,
      required MyUser user,
      }) async {
    final currencyController =
        Provider.of<CurrencyController>(context, listen: false);
    try {
      if (isLogin) {
        final userCredential = await _auth.signInWithEmailAndPassword(
            email: user.email, password: user.password);
        final firebaseUser = userCredential.user;
        if (!firebaseUser!.emailVerified) {
          onTag('confirm verification');
        } else {
          final selectedCurrency = await currencyController.hasSelectedCurrency(
            firestore: _firestore,
            userId: firebaseUser.uid,
          );
          debugPrint('Selected currency: $selectedCurrency');
          if (!selectedCurrency) {
            CurrenciesBottomSheet.show(
                backgroundColor: backgroundColor,
                onCurrencySelected: (currency) async {
                  await currencyController.saveCurrency(
                      firestore: _firestore,
                      user: firebaseUser,
                      currency: currency);
                  Get.back();
                  onNavigateToHomeScreen();
                });
          } else {
            onNavigateToHomeScreen();
          }
        }
      } else {
        // onShowLoadingDialog();
        final userCredential = await _auth.createUserWithEmailAndPassword(
            email: user.email, password: user.password);
        if (userCredential.user != null) {
          await _sendEmailVerification(onMessage: (msg) => onTag(msg));
          await _auth.currentUser!.updateDisplayName(user.username);
          debugPrint('Send Email:');
        } else {
          debugPrint('Something Wrong:');
          onTag('حدث خطأ أثناء إنشاء الحساب');
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = 'حدث خطأ ما';
      if (e.code == 'weak-password') {
        message = 'كلمة المرور ضعيفة جدا';
      } else if (e.code == 'email-already-in-use') {
        message = 'هذا البريد الالكتروني مستخدم بالفعل. الرجاء تسجيل الدخول';
      } else if (e.code == 'invalid-email') {
        message = 'البريد الإلكتروني غير صالح';
      } else if (e.code == 'user-not-found') {
        message = 'هذا المستخدم غير موجود. الرجاء إنشاء حساب';
      } else if (e.code == 'wrong-password') {
        message = 'كلمة المرور خاطئة. الرجاء إدخال كلمة مرور صحيحة';
      }
      onTag(message);
      debugPrint('Firebase error: $message: ${e.message}');
    } catch (e) {
      onTag('Error: ${e.toString()}');
      debugPrint(e.toString());
    }
  }

  static Future<void> googleAuth(
      {required double screenHeight,
      required BuildContext context,
      required Color backgroundColor}) async {
    final currencyController =
        Provider.of<CurrencyController>(context, listen: false);
    final userCredential = await GoogleAuthService.signInWithGoogle(_auth);
    final firebaseUser = userCredential.user;
    final selectedCurrency = await currencyController.hasSelectedCurrency(
        firestore: _firestore, userId: firebaseUser!.uid);
    debugPrint('Selected currency: $selectedCurrency');
    if (!selectedCurrency) {
      //show pick currency dialog
      CurrenciesBottomSheet.show(
          backgroundColor: backgroundColor,
          onCurrencySelected: (currency) async {
            await currencyController.saveCurrency(
                firestore: _firestore, user: firebaseUser, currency: currency);
            Get.back();
          });
    }
  }

  static Future<void> _sendEmailVerification(
      {required Function(String) onMessage}) async {
    try {
      _auth.setLanguageCode('ar');
      _auth.currentUser!.sendEmailVerification();
      onMessage('send email verification');
    } on FirebaseAuthException catch (e) {
      onMessage(e.message.toString()); // Display error message
    }
  }

  static Future<void> logout() async {
    GoogleAuthService.signOut();
    _auth.signOut();
  }

  static void resetPassword({
    required String email,
    required Function() onShowLoadingDialog,
    required Function() onHideLoadingDialog,
    required Function(String, IconData) onMessage,
  }) async {
    onShowLoadingDialog();
    try {
      await _auth.sendPasswordResetEmail(email: email);
      onHideLoadingDialog();
      onMessage(
        'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني. الرجاء التحقق من بريدك الإلكتروني واتباع التعليمات لإعادة تعيين كلمة المرور الخاصة بك',
        Icons.outgoing_mail,
      );
    } on FirebaseAuthException catch (e) {
      String message = 'حدث خطأ ما';
      IconData icon = Icons.error;

      if (e.code == 'user-not-found') {
        message = 'هذا المستخدم غير موجود. الرجاء إنشاء حساب';
        icon = Icons.person_off;
      }
      if (e.code == 'invalid-email') {
        message = 'البريد الإلكتروني غير صحيح';
        icon = Icons.email;
      }
      if (e.code == 'connection-failed') {
        message = 'لا يوجد اتصال بالإنترنت';
        icon = Icons.wifi_off;
      }
      onHideLoadingDialog();
      onMessage(message, icon);
      debugPrint('Firebase error: $message: ${e.message}');
    }
  }

  static void showMessageToUser(
      {required FirebaseAuth auth,
      required String tag,
      required BuildContext context,
      required Widget Function(String) content}) {
    if (tag == 'confirm verification') {
      Utils.showAlertDialog(
          context: context,
          primaryActionLabel: 'إعادة الإرسال',
          secondaryActionLabel: 'إغلاق',
          title: 'تأكيد الحساب',
          content: content(
            'لم يتم تأكيد ملكية هذا الحساب بعد. الرجاء مراحعة بريدك الإلكتروني للتأكد من أنك قمت بالضغط على رابط التأكيد المرسل لك.',
          ),
          onPrimaryActionClicked: (ctx) {
            auth.currentUser!.sendEmailVerification();
            Utils.showSnackBar(ctx, 'تم ارسال التأكيد الى بريدك الإلكتروني');
            Navigator.pop(ctx);
          },
          onSecondaryActionClicked: () => Get.back());
    } else if (tag == 'send email verification') {
      Utils.showAlertDialog(
        context: context,
        title: 'تأكيد الحساب',
        content: content(
          'لقد قمنا بإرسال رابط التحقق عبر البريد الإلكتروني المدخل. يرجى مراجعة البريد الإلكتروني وتأكيد الحساب',
        ),
        primaryActionLabel: 'تم',
        onPrimaryActionClicked: () => Get.back(),
      );
    } else {
      Utils.showSnackBar(context, tag);
    }
  }
}
