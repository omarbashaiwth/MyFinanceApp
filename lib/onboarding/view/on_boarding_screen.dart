import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:myfinance_app/onboarding/model/on_boarding.dart';
import 'package:myfinance_app/onboarding/view/widget/onboarding_image.dart';


class OnBoardingScreen extends StatelessWidget {
  final Function(BuildContext) onBoardingEnd;

  OnBoardingScreen({Key? key, required this.onBoardingEnd})
      : super(key: key);

  final onBoardingKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
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
     final pageDecoration = PageDecoration(
        titleTextStyle: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary
        ),
        bodyTextStyle: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 18,
            color: Theme.of(context).colorScheme.onPrimary
        ),
        imagePadding: const EdgeInsets.all(50),
        imageFlex: 2,
    );
    return IntroductionScreen(
      key: onBoardingKey,
      globalBackgroundColor: Theme.of(context).colorScheme.background,
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
      ],
      next: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {onBoardingKey.currentState?.next();},
        child: const Icon(
          Icons.navigate_next,
          color: white,
        ),
      ),
      nextFlex: 0,
      dotsFlex: 3,
      done: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: (){
          onBoardingEnd(context);
        },
        child: const Icon(
          Icons.done,
          color: white,
        ),
      ),
      onDone: (){},
      dotsDecorator:
           DotsDecorator(size: const Size(10, 10), activeColor: Theme.of(context).colorScheme.primary),
    );
  }
}
