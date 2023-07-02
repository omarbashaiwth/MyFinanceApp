import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfinance_app/auth/controller/services/google_auth_service.dart';
import 'package:myfinance_app/auth/model/my_user.dart';
import 'package:myfinance_app/core/utils/utils.dart';
import 'package:get/get.dart';
import 'package:myfinance_app/core/widgets/currency_manager.dart';


class FirebaseAuthServices {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  static Future<void> emailPasswordAuth(
      {required Function(String) onMessage,
      required Function(bool) onLoading,
      required Function onNavigateToHomeScreen,
      required double screenHeight,
      required bool isLogin,
      required MyUser user}) async {
    // UserCredential authResult;
    try {
      if (isLogin) {
        onLoading(true);
        await _auth.signInWithEmailAndPassword(
            email: user.email, password: user.password
        );
        if (_auth.currentUser!.emailVerified) {
          //move to the home page after selected currency
          debugPrint('Login: emailVerified = ${_auth.currentUser!.emailVerified}');
          final selectedCurrency = await CurrencyManager.hasSelectedCurrency(
              userId: _auth.currentUser!.uid,
              firestore: _firestore
          );
          if(selectedCurrency){
            onNavigateToHomeScreen();
          } else {
           CurrencyManager.showCurrencyPicker(
               bottomSheetHeight: screenHeight * 0.90,
               firestore: _firestore,
               user: _auth.currentUser!
           );
           onNavigateToHomeScreen();
          }
          onLoading(false);
        } else {
          debugPrint('Login: emailNotVerified = ${_auth.currentUser!.emailVerified}');
          onMessage('confirm verification');
          onLoading(false);
        }
      } else {
        onLoading(true);
        final userCredential = await _auth.createUserWithEmailAndPassword(
            email: user.email, password: user.password
        );
        // await userCredential.user!.updateDisplayName(user.username);
        if(userCredential.user != null) {
          await _sendEmailVerification(onMessage: (msg) => onMessage(msg));
          await _auth.currentUser!.updateDisplayName(user.username);
          onLoading(false);
        } else {
          onMessage('حدث خطأ أثناء إنشاء الحساب');
          onLoading(false);
        }

      }
    } on FirebaseAuthException catch (e) {
      String message = 'حدث خطأ ما';
      if (e.code == 'weak-password') {
        message = 'كلمة المرور ضعيفة جدا';
      } else if (e.code == 'email-already-in-use') {
        message = 'هذا البريد الالكتروني مستخدم بالفعل. الرجاء تسجيل الدخول';
      } else if (e.code == 'user-not-found') {
        message = 'هذا المستخدم غير موجود. الرجاء إنشاء حساب';
      } else if (e.code == 'wrong-password') {
        message = 'كلمة المرور خاطئة. الرجاء إدخال كلمة مرور صحيحة';
      }
      onMessage(message);
      onLoading(false);
      debugPrint('Firebase error: $message: ${e.message}');
    } catch (e) {
      onMessage('Error: ${e.toString()}');
      onLoading(false);
      debugPrint(e.toString());
    }
  }

  static Future<void> googleAuth({required double screenHeight}) async {
    final userCredential = await GoogleAuthService.signInWithGoogle(_auth);
    final user = userCredential.user;
    final hasCurrency = await CurrencyManager.hasSelectedCurrency(userId: user!.uid, firestore: _firestore);
    if (!hasCurrency) {
      //show pick currency dialog
      CurrencyManager.showCurrencyPicker(
          bottomSheetHeight: screenHeight * 0.90,
          firestore: _firestore,
          user: user
      );
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

  static void showMessageToUser(
      FirebaseAuth auth, String msg, BuildContext context) {
    if (msg == 'confirm verification') {
      Utils.showAlertDialog(
          context: context,
          primaryActionLabel: 'إعادة الإرسال',
          secondaryActionLabel: 'إغلاق',
          title: 'تأكيد الحساب',
          content:
              'لم يتم تأكيد ملكية هذا الحساب بعد. الرجاء مراحعة بريدك الإلكتروني للتأكد من أنك قمت بالضغط على رابط التأكيد المرسل لك.',
          onPrimaryActionClicked: (ctx) {
            auth.currentUser!.sendEmailVerification();
            Utils.showSnackBar(ctx, 'تم ارسال التأكيد الى بريدك الإلكتروني');
            Navigator.pop(ctx);
          },
          onSecondaryActionClicked: () => Get.back());
    } else if (msg == 'send email verification') {
      Utils.showAlertDialog(
        context: context,
        title: 'تأكيد الحساب',
        content:
            'لقد قمنا بإرسال رابط التحقق عبر البريد الإلكتروني المدخل. يرجى مراجعة البريد الإلكتروني وتأكيد الحساب',
        primaryActionLabel: 'تم',
        onPrimaryActionClicked: () => Get.back(),
      );
    } else {
      Utils.showSnackBar(context, msg);
    }
  }
}
