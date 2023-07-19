import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfinance_app/core/ui/theme.dart';
class ProfileWidget extends StatelessWidget {
  final User? currentUser;
  final Function() onLogout;

  const ProfileWidget(
      {Key? key,
      required this.currentUser,
      required this.onLogout,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipOval(
            child: currentUser?.photoURL != null
                ? Image.network(currentUser!.photoURL!, height: 70)
                : const Icon(
                    Icons.account_circle_rounded,
                    size: 70,
                    color: Colors.red,
                  )
        ),
        const SizedBox(height: 10),
        Text(
          currentUser?.displayName ?? 'Unknown Name',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5),
        Text(currentUser?.email ?? 'Unknown Email'),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onLogout,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.logout, size: 15, color: redColor),
              SizedBox(width: 8),
              Text(
                'تسجيل الخروج',
                style: TextStyle(
                    fontFamily: 'Tajawal', fontSize: 15, color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
