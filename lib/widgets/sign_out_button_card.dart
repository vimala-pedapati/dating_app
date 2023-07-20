import 'package:Mingledxb/helpers/app_localizations.dart';
import 'package:Mingledxb/models/user_model.dart';
import 'package:Mingledxb/screens/sign_in_screen.dart';
import 'package:Mingledxb/widgets/default_card_border.dart';
import 'package:flutter/material.dart';

class SignOutButtonCard extends StatelessWidget {
  const SignOutButtonCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    return Card(
      color: Colors.grey[900],
      clipBehavior: Clip.antiAlias,
      elevation: 4.0,
      shape: defaultCardBorder(),
      child: ListTile(
        leading: const Icon(
          Icons.exit_to_app,
          color: Colors.white,
        ),
        title: Text(i18n.translate("sign_out"),
            style: const TextStyle(color: Colors.white, fontSize: 18)),
        trailing: const Icon(Icons.arrow_forward, color: Colors.white),
        onTap: () {
          // Log out button
          UserModel().signOut().then((_) {
            /// Go to login screen
            Future(() {
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) => const SignInScreen()));
            });
          });
        },
      ),
    );
  }
}
