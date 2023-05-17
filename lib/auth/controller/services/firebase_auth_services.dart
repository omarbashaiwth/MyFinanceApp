import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfinance_app/auth/model/my_user.dart';
import 'package:myfinance_app/core/utils/utils.dart';

class FirebaseAuthServices {
  final FirebaseAuth auth;

  FirebaseAuthServices(this.auth);

  Future<void> firebaseAuth({
    required Function(String) onMessage,
    required Function(bool) onLoading,
    required BuildContext context,
    required bool isLogin,
    required MyUser user
  }) async {
    UserCredential authResult;
    final firestore = FirebaseFirestore.instance;
    try {
      if (isLogin) {
        onLoading(true);
        debugPrint('currentUser: ${auth.currentUser}');
        await auth.signInWithEmailAndPassword(
            email: user.email, password: user.password);
        if (auth.currentUser!.emailVerified) {
          //move to the home page
          onLoading(false);
        } else {
          onMessage('الرجاء تأكيد ملكية هذا الحساب');
          onLoading(false);
        }
      } else {
        onLoading(true);
        authResult = await auth.createUserWithEmailAndPassword(
            email: user.email, password: user.password);
        debugPrint('account created');
        await _sendEmailVerification(onMessage: (msg) => onMessage(msg));
        firestore
            .collection('Users')
            .doc(authResult.user?.uid.toString())
            .set({'username': user.username, 'password': user.password});
        onLoading(false);
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
      debugPrint('Firebase error: $message');
    } catch (e) {
      onMessage('Error: ${e.toString()}');
      onLoading(false);
      debugPrint(e.toString());
    }
  }

  Future<void> _sendEmailVerification(
      {required Function(String) onMessage}) async {
    try {
      auth.setLanguageCode('ar');
      auth.currentUser!.sendEmailVerification();
      onMessage(
          'لقد قمنا بإرسال رابط التحقق عبر البريد الإلكتروني المدخل. يرجى مراجعة البريد الإلكتروني وتأكيد الحساب');
    } on FirebaseAuthException catch (e) {
      onMessage(e.message.toString()); // Display error message
    }
  }

  Future<void> logout() async {
    auth.signOut();
  }

  static void showMessageToUser(
      FirebaseAuth auth, String msg, BuildContext context) {
    if (msg == 'الرجاء تأكيد ملكية هذا الحساب') {
      Utils.showAlertDialog(
          context: context,
          positiveLabel: 'إعادة الإرسال',
          negativeLabel: 'إغلاق',
          title: 'تأكيد الحساب',
          content:
              'لم يتم تأكيد ملكية هذا الحساب بعد. الرجاء مراحعة بريدك الإلكتروني للتأكد من أنك قمت بالضغط على رابط التأكيد المرسل لك.',
          onPositiveClick: (ctx) {
            auth.currentUser!.sendEmailVerification();
            Utils.showSnackBar(ctx, 'تم ارسال التأكيد الى بريدك الإلكتروني');
            Navigator.pop(ctx);
          },
          onNegativeClick: (ctx) {
            Navigator.pop(ctx);
            debugPrint('back pressed');
          });
    } else {
      Utils.showSnackBar(context, msg);
    }
  }
}
