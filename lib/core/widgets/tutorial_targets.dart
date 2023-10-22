import 'package:flutter/material.dart';
import 'package:myfinance_app/core/ui/theme.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class TutorialTargets {

  static List<TargetFocus> createTargets(List<GlobalKey> keys){
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify:'tut_target_1',
        keyTarget: keys[0],
        alignSkip: Alignment.topRight,
        paddingFocus: 30,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            padding: const EdgeInsets.only(bottom:60),
            builder: (context, controller) =>  Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('في هذه الشاشة سيتم عرض حميع المعاملات التي ستقوم بإدخالها', style: TextStyle(
                    fontFamily: 'Tajawal',
                      color: Colors.white
                  ), textAlign: TextAlign.end,),
                  TextButton(onPressed: () => controller.next(), child: const Text('التالي', style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.bold,
                      color: orangeyRed
                  ),)
                  ),
                ],
              ),
            ),
          )
        ]
      )
    );
    targets.add(
        TargetFocus(
            identify:'tut_target_2',
            paddingFocus: 30,
            keyTarget: keys[1],
            alignSkip: Alignment.topRight,
            contents: [
              TargetContent(
            align: ContentAlign.top,
                padding: const EdgeInsets.only(bottom:60),
            builder: (context, controller) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('هنا يتم عرض المحفظات المالية حيث يمكنك توزيع دخلك على عدة محفظات',
                    style: TextStyle(
                fontFamily: 'Tajawal',
                color: Colors.white
            ), textAlign: TextAlign.end,),
                TextButton(
                    onPressed: () => controller.next(),
                    child: const Text(
                      'التالي',
                      style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontWeight: FontWeight.bold,
                          color: orangeyRed),
                    ))
              ],
            ),
          )
        ]
        )
    );
    targets.add(
        TargetFocus(
            identify:'tut_target_3',
            keyTarget: keys[2],
            alignSkip: Alignment.topRight,
            contents: [
              TargetContent(
                align: ContentAlign.top,
                padding: const EdgeInsets.only(bottom:60),
                builder: (context, controller) => const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('يجب أولاً إضافة محفظة واحدة على الأقل لكي تتمكن من إدخال المعاملات\nقم بالضغط على هذه الإيقونة لإنشاء محفظة',
                      style: TextStyle(
                          fontFamily: 'Tajawal',
                          color: Colors.white
                      ), textAlign: TextAlign.center,),
                  ],
                ),
              )
            ]
        )
    );
    return targets;
  }
}