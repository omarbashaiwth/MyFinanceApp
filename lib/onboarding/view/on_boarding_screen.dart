import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/core/utils/utils.dart';
import 'package:myfinance_app/onboarding/controller/onboarding_controller.dart';
import 'package:myfinance_app/onboarding/model/on_boarding.dart';
import 'package:myfinance_app/onboarding/view/widget/onboarding_image.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/currencies_picker.dart';

class OnBoardingScreen extends StatelessWidget {
  final Function(BuildContext) onBoardingEnd;

  OnBoardingScreen({Key? key, required this.onBoardingEnd})
      : super(key: key);

  final onBoardingKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    // final selectedCurrency = context.read<OnBoardingController>().selectedCurrency;
    final onBoardingPages = [
      OnBoarding(
          'سجّل نفقاتك',
          'قم بتسجيل جميع نفقاتك في التطبيق حتى تقوم بمتابعتها ومراقبتها',
          'assets/images/onboarding1.png'
      ),
      OnBoarding('نوّع محفظاتك', 'بإمكانك توزيع مصادر دخلك على عدة محفظات',
          'assets/images/onboarding2.png'
      ),
      OnBoarding(
          'تقارير شهرية',
          'سوف تحصل على تقارير وبيانات توضيحية  حول أدائك المالي خلال كل شهر',
          'assets/images/onboarding3.png'
      ),
    ];
    const pageDecoration = PageDecoration(
        titleTextStyle: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: redColor
        ),
        bodyTextStyle: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 18,
            color: redColor
        ),
        imagePadding: EdgeInsets.all(50),
        imageFlex: 2,
    );
    final currenciesList = Utils.currencies();
    return IntroductionScreen(
      key: onBoardingKey,
      globalBackgroundColor: whiteColor,
      pages: [
        PageViewModel(
            title: onBoardingPages[0].title,
            body: onBoardingPages[0].description,
            image: OnBoardingImage(image: onBoardingPages[0].image),
            decoration: pageDecoration),
        PageViewModel(
            title: onBoardingPages[1].title,
            body: onBoardingPages[1].description,
            image: OnBoardingImage(image: onBoardingPages[1].image),
            decoration: pageDecoration),
        PageViewModel(
            title: onBoardingPages[2].title,
            body: onBoardingPages[2].description,
            image: OnBoardingImage(image: onBoardingPages[2].image),
            decoration: pageDecoration),
        // PageViewModel(
        //     decoration: const PageDecoration(
        //         bodyAlignment: Alignment.center,
        //         bodyPadding: EdgeInsets.symmetric(horizontal: 4)),
        //     titleWidget: Column(
        //       children: [
        //         Text(
        //           'اختر العملة',
        //           style: pageDecoration.titleTextStyle,
        //         ),
        //         Text(
        //           'يمكنك تغيير ذلك لاحقاً',
        //           style: pageDecoration.bodyTextStyle,
        //         )
        //       ],
        //     ),
        //     bodyWidget: CurrenciesPicker(
        //       currenciesList: currenciesList,
        //       isSelected: (currency) {
        //         return context.watch<OnBoardingController>()
        //           .selectedCurrency?.code == currency.code;
        //       },
        //       onCurrencySelected: (currency) {
        //         context.read<OnBoardingController>()
        //           .onSelectedCurrencyChange(currency);
        //       },
        //     )
        // )
      ],
      next: FloatingActionButton(
        backgroundColor: redColor,
        onPressed: () {onBoardingKey.currentState?.next();},
        child: const Icon(
          Icons.navigate_next,
          color: whiteColor,
        ),
      ),
      nextFlex: 0,
      dotsFlex: 3,
      done: FloatingActionButton(
        backgroundColor: redColor,
        onPressed: (){
          onBoardingEnd(context);
        },
        child: const Icon(
          Icons.done,
          color: whiteColor,
        ),
      ),
      onDone: (){},
      dotsDecorator:
          const DotsDecorator(size: Size(10, 10), activeColor: redColor),
    );
  }
}
