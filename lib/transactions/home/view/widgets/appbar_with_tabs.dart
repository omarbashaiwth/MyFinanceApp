import 'package:flutter/material.dart';
import 'package:myfinance_app/core/ui/theme.dart';

class AppBarWithTabs extends StatelessWidget {
  final TabController tabController;
  final Function onCloseClicked;
  final Function onSaveClicked;
  const AppBarWithTabs({Key? key, required this.tabController, required this.onCloseClicked, required this.onSaveClicked}) : super(key: key);

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
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        indicator: const BoxDecoration(color: lightRedColor),
        controller: tabController,
        tabs: [
          _buildTab(label: 'نـفـقــة', icon: Icons.file_upload_rounded),
          _buildTab(label: 'دخـــــــل', icon: Icons.download ),
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




