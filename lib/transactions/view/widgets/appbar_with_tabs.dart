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
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 0,
      actions: [
        IconButton(onPressed: () => onCloseClicked(), icon:  Icon(Icons.close, color: Theme.of(context).colorScheme.onSecondary,))
      ],
      leading: IconButton(
          onPressed: () => onSaveClicked(),
          icon:  Icon(Icons.check, color: Theme.of(context).colorScheme.onSecondary,)
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight * 0.5),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.only(bottom: 8, left: 4, right: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          child: TabBar(
            onTap:(index) =>  onIndexChange(index),
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            indicator:  BoxDecoration(color: tabController.index == 0? orangeyRed : green, borderRadius: BorderRadius.circular(20)),
            controller: tabController,
            tabs: [
              _buildTab(label: 'نـفـقــة', labelColor: tabController.index == 0? white: lightGrey),
              _buildTab(label: 'دخـــــــل', labelColor: tabController.index == 1? white: lightGrey),
            ],
          ),
        ),
      ),
      titleTextStyle: AppTextTheme.appBarTitleTextStyle.copyWith(color: Theme.of(context).colorScheme.onSecondary),
      title: const Text('إضافة معاملة جديدة'),
    );
  }

  Widget _buildTab({required String label, required Color labelColor}) {
    return Tab(
      child: Text(label,
      style: AppTextTheme.elevatedButtonTextStyle
          .copyWith(fontSize: 16, color: labelColor),),
    );
  }
}




