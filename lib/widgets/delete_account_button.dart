import 'package:Mingledxb/dialogs/common_dialogs.dart';
import 'package:Mingledxb/helpers/app_localizations.dart';
import 'package:Mingledxb/screens/delete_account_screen.dart';
import 'package:Mingledxb/widgets/default_button.dart';
import 'package:flutter/material.dart';

class DeleteAccountButton extends StatelessWidget {
  const DeleteAccountButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    return Center(
      child: DefaultButton(
        child: Text(i18n.translate("delete_account"),
            style: const TextStyle(fontSize: 18)),
        onPressed: () {
          /// Delete account
          ///
          /// Confirm dialog
          infoDialog(context,
              icon: const CircleAvatar(
                backgroundColor: Colors.red,
                child: Icon(Icons.close, color: Colors.white),
              ),
              title: '${i18n.translate("delete_account")} ?',
              message: i18n.translate(
                  'all_your_profile_data_will_be_permanently_deleted'),
              negativeText: i18n.translate("CANCEL"),
              positiveText: i18n.translate("DELETE"),
              negativeAction: () => Navigator.of(context).pop(),
              positiveAction: () async {
                // Close confirm dialog
                Navigator.of(context).pop();

                /// Go to delete account screen
                Future(() {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const DeleteAccountScreen()));
                });
              });
        },
      ),
    );
  }
}
