import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/core/utils/utils.dart';
import 'package:myfinance_app/onboarding/controller/onboarding_controller.dart';
import 'package:myfinance_app/onboarding/model/on_boarding.dart';
import 'package:myfinance_app/onboarding/view/widget/currency_item.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatelessWidget {
  final Function(BuildContext) onBoardingEnd;

  OnBoardingScreen({Key? key, required this.onBoardingEnd})
      : super(key: key);

  final onBoardingKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    final selectedCurrency = Provider.of<OnBoardingController>(context, listen: false).selectedCurrency;
    final onBoardingPages = [
      OnBoarding(
          'سجّل نفقاتك',
          'قم بتسجيل جميع نفقاتك في التطبيق حتى تقوم بمتابعتها ومراقبتها.',
          'assets/images/onboarding1.png'),
      OnBoarding('نوّع محفظاتك', 'بإمكانك توزيع مصادر دخلك على عدة محفظات حتى ',
          'assets/images/onboarding2.png'),
      OnBoarding(
          'تقارير شهرية',
          'سوف تحصل على تقارير وبيانات توضيحية  حول أدائك المالي خلال كل شهر.',
          'assets/images/onboarding3.png'),
    ];
    const pageDecoration = PageDecoration(
        titleTextStyle: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: whiteColor
        ),
        imagePadding: EdgeInsets.all(30),
        imageFlex: 2,
        bodyTextStyle:
            TextStyle(fontFamily: 'Tajawal', fontSize: 18, color: whiteColor));
    final currenciesList = Utils.currencies();
    return IntroductionScreen(
      key: onBoardingKey,
      globalBackgroundColor: redColor,
      pages: [
        PageViewModel(
            title: onBoardingPages[0].title,
            body: onBoardingPages[0].description,
            image: Image.asset(onBoardingPages[0].image),
            decoration: pageDecoration),
        PageViewModel(
            title: onBoardingPages[1].title,
            body: onBoardingPages[1].description,
            image: Image.asset(onBoardingPages[1].image),
            decoration: pageDecoration),
        PageViewModel(
            title: onBoardingPages[2].title,
            body: onBoardingPages[2].description,
            image: Image.asset(onBoardingPages[2].image),
            decoration: pageDecoration),
        PageViewModel(
            decoration: const PageDecoration(
                bodyAlignment: Alignment.center,
                bodyPadding: EdgeInsets.symmetric(horizontal: 4)),
            titleWidget: Column(
              children: [
                Text(
                  'اختر العملة',
                  style: pageDecoration.titleTextStyle,
                ),
                Text(
                  'يمكنك تغيير ذلك لاحقاً',
                  style: pageDecoration.bodyTextStyle,
                )
              ],
            ),
            bodyWidget: SingleChildScrollView(
              child: Container(
                  height: 430,
                  decoration: BoxDecoration(
                      color: whiteColor, borderRadius: BorderRadius.circular(20)),
                  child: ListView.builder(
                    itemCount: currenciesList.length,
                    itemBuilder: (_, index) {
                      final currency = currenciesList[index];
                      return Column(
                        children: [
                          CurrencyItem(
                            currency: currency,
                            isSelected: Provider.of<OnBoardingController>(context)
                                    .selectedCurrency
                                    ?.code ==
                                currency.code,
                            onSelectCurrency: () {
                              Provider.of<OnBoardingController>(context,
                                      listen: false)
                                  .onSelectedCurrencyChange(currency
                              );
                            },
                          ),
                          const SizedBox(height: 4)
                        ],
                      );
                    },
                  )),
            ))
      ],
      next: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {onBoardingKey.currentState?.next();},
        child: const Icon(
          Icons.navigate_next,
          color: redColor,
        ),
      ),
      nextFlex: 0,
      dotsFlex: 3,
      done: selectedCurrency != null ? FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: (){
          onBoardingEnd(context);
        },
        child: const Icon(
          Icons.done,
          color: redColor,
        ),
      ): Container(),
      onDone: (){},
      dotsDecorator:
          const DotsDecorator(size: Size(10, 10), activeColor: whiteColor),
    );
  }
}
