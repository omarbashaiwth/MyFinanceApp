import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myfinance_app/transactions/home/controller/transaction_controller.dart';
import 'package:myfinance_app/transactions/home/view/screens/add_transaction_screen.dart';
import 'package:myfinance_app/transactions/home/view/screens/home_screen.dart';
import 'package:myfinance_app/wallets/controller/wallet_controller.dart';
import 'package:myfinance_app/wallets/view/screens/add_wallet_screen.dart';
import 'package:myfinance_app/wallets/view/screens/wallets_screen.dart';
import 'package:provider/provider.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'auth/controller/auth_controller.dart';
import 'auth/view/screens/auth_screen.dart';
import 'core/ui/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<TransactionController>(create: (_) => TransactionController()),
          ChangeNotifierProvider<WalletController>(create: (_) => WalletController()),
          ChangeNotifierProvider<AuthController>(create: (_) => AuthController()),
        ],
          child: const MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
        ],
        theme: AppTheme.lightTheme,
        home: const Directionality(
          textDirection: TextDirection.rtl,
          child: MyHomePage(),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  var _selectedIndex = 0;
  var _isFabVisible = true;
  late AnimationController _hideBottomBarAnimationController;
  bool onScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification &&
        notification.metrics.axis == Axis.vertical) {
      switch (notification.direction) {
        case ScrollDirection.forward:
          _hideBottomBarAnimationController.reverse();
          setState(() => _isFabVisible = true);
          break;
        case ScrollDirection.reverse:
          _hideBottomBarAnimationController.forward();
          setState(() => _isFabVisible = false);
          break;
        case ScrollDirection.idle:
          break;
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _hideBottomBarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _hideBottomBarAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));

    final bottomNanScreens = [const HomeScreen(), const WalletsScreen()];
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        floatingActionButton: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if(snapshot.hasData  && snapshot.data!.emailVerified) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: _isFabVisible ? 60.0 : 0.0,
                child: FloatingActionButton(
                  onPressed: () {
                    Get.to(
                      Directionality(
                          textDirection: TextDirection.rtl,
                          child: _selectedIndex == 0? const AddTransactionScreen() :   AddWalletScreen()
                      )
                    );
                  },
                  child: const Icon(Icons.add, color: Colors.white),
                )
              );
            } else {
             return const SizedBox.shrink();
            }
          }
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
        bottomNavigationBar: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if(snapshot.hasData  && snapshot.data!.emailVerified) {
              return AnimatedBottomNavigationBar.builder(
                itemCount: 2,
                tabBuilder: (index, isActive) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                          index == 0
                              ? Icons.cached_sharp
                              : Icons.account_balance_wallet_outlined,
                          size: 24,
                          color: isActive ? redColor : darkGray,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        index == 0 ? 'المعاملات' : 'المحفظات',
                        style: TextStyle(
                            fontFamily: 'Tajawal',
                            color: isActive ? redColor : darkGray,
                        ),
                      )
                    ],
                  );
                },
                hideAnimationController: _hideBottomBarAnimationController,
                gapLocation: GapLocation.center,
                notchSmoothness: NotchSmoothness.smoothEdge,
                leftCornerRadius: 32,
                rightCornerRadius: 32,
                activeIndex: _selectedIndex,
                onTap: (index){setState(() => _selectedIndex = index);}
                ,
              );
            } else {return const SizedBox.shrink();}
          }
        ),
        body: NotificationListener<ScrollNotification>(
            onNotification: onScrollNotification,
            child: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context,snapshot){
                if(snapshot.hasData && snapshot.data!.emailVerified){
                    return  bottomNanScreens.elementAt(_selectedIndex);
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: AuthScreen(),
                  );
                }
              },
            ),
          ),
    );
  }
}


