import 'package:flutter/material.dart';
import 'package:myfinance_app/core/ui/theme.dart';

class AppBarWithTabs extends StatelessWidget {
  final TabController tabController;
  final Function(int) onIndexChange;
  final Function onCloseClicked;
  final Function onSaveClicked;
  const AppBarWithTabs({Key? key, required this.tabController, required this.onCloseClicked, required this.onSaveClicked, required this.onIndexChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      elevation: 0,
      actions: [
        IconButton(onPressed: () => onCloseClicked(), icon: const Icon(Icons.close, color: whiteColor,))
      ],
      leading: TextButton(
          onPressed: () => onSaveClicked(),
          child: const Text('حفظ',style: TextStyle(fontFamily: 'Tajawal', color: whiteColor))),
      bottom: TabBar(
        onTap:(index) =>  onIndexChange(index),
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        indicator: const BoxDecoration(color: lightRedColor),
        controller: tabController,
        tabs: [
          _buildTab(label: 'نـفـقــة', icon: Icons.arrow_downward_outlined),
          _buildTab(label: 'دخـــــــل', icon: Icons.arrow_upward_outlined),
        ],
      ),
      titleTextStyle: AppTextTheme.appBarTitleTextStyle,
      title: const Text('إضافة معاملة جديدة'),
    );
  }

  Tab _buildTab({required String label, required IconData icon}) {
    return Tab(child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label,
          style: AppTextTheme.elevatedButtonTextStyle
              .copyWith(fontSize: 16),),
        const SizedBox(
          width: 10,
        ),
        Icon(icon)
      ],
    ),
    );
  }
}




