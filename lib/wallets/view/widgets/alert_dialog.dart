import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/ui/theme.dart';
import '../../controller/wallet_controller.dart';

class ShowAlertDialog extends StatelessWidget {
  final String title;
  final Widget Function(WalletController) content;
  final String primaryActionLabel;
  final Function(WalletController) onPrimaryActionClicked;
  final IconData? icon = Icons.warning_amber_rounded;
  final String? secondaryActionLabel;
  final Function? onSecondaryActionClicked;  const ShowAlertDialog({super.key, required this.title, required this.content, required this.primaryActionLabel, required this.onPrimaryActionClicked, this.secondaryActionLabel, this.onSecondaryActionClicked});

  @override
  Widget build(BuildContext context) {
    final walletController = Provider.of<WalletController>(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      icon: Icon(icon, size: 30),
      titleTextStyle: AppTextTheme.textButtonStyle.copyWith(
          fontSize: 18, color: Theme.of(context).colorScheme.onPrimary),
      title: Text(title),
      contentTextStyle: AppTextTheme.normalTextStyle
          .copyWith(color: Theme.of(context).colorScheme.onPrimary),
      content: content(walletController),
      actions: [
        secondaryActionLabel != null
            ? TextButton(
          onPressed: () => onSecondaryActionClicked!(),
          child: Text(
            secondaryActionLabel!,
            style: AppTextTheme.textButtonStyle.copyWith(
                color: Theme.of(context).colorScheme.onPrimary),
          ),
        )
            : const SizedBox.shrink(),
        TextButton(
          onPressed: () => onPrimaryActionClicked(walletController),
          child: Text(primaryActionLabel,
              style: AppTextTheme.textButtonStyle.copyWith(
                  color: Theme.of(context).colorScheme.primary)),
        ),
      ],
    );
  }
}
