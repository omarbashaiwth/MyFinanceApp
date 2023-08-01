import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myfinance_app/auth/controller/services/firebase_auth_services.dart';
import 'package:myfinance_app/settings/controller/settings_cntroller.dart';
import 'package:myfinance_app/settings/view/widget/currency_widget.dart';
import 'package:myfinance_app/settings/view/widget/header_text.dart';
import 'package:myfinance_app/settings/view/widget/profile_widget.dart';
import 'package:myfinance_app/settings/view/widget/theme_options_dialog.dart';
import 'package:myfinance_app/settings/view/widget/theme_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SettingsScreen extends StatelessWidget {
  final SharedPreferences prefs;
  const SettingsScreen({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    final settingsController = Provider.of<SettingsController>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon:  Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSecondary,),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              ProfileWidget(
                  currentUser: auth.currentUser,
                  onLogout: () async {
                    await FirebaseAuthServices.logout();
                    Get.back();
                  }
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              const HeaderText(text: 'العملة'),
              CurrencyWidget(auth: auth, firestore: firestore),
              const SizedBox(height: 30),
              const HeaderText(text: 'الثيم'),
              ThemeWidget(
                  themeModeOptions: SettingsController.getThemeModeOption(prefs),
                  onThemeChangeClicked: (){
                    ThemeOptionsDialog.show(
                      context: context,
                      onSelected: (themeMode) {
                        settingsController.toggleThemeModeOption(themeMode);
                      }
                    );
                  }
              )

            ],
          ),
        ),

      ),
    );
  }
}
