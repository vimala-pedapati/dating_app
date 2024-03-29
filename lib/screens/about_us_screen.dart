import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../helpers/app_helper.dart';
import '../helpers/app_localizations.dart';
import '../models/app_model.dart';
import '../widgets/app_logo.dart';

class AboutScreen extends StatelessWidget {
  // Variables

  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          i18n.translate('about_us'),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 0, left: 25, right: 25, bottom: 65),
          child: Center(
            child: Container(
              child: Column(
                children: <Widget>[
                  /// App icon
                  const AppLogo(),
                  const SizedBox(height: 10),

                  /// App name
                  const Text(
                    APP_NAME,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  // slogan
                  Text(i18n.translate('app_short_description'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      )),
                  const SizedBox(height: 15),
                  // App description
                  Text(i18n.translate('about_us_description'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center),
                  // Share app button
                  const SizedBox(height: 10),
                  TextButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Theme.of(context).primaryColor)),
                    icon: const Icon(Icons.share, color: Colors.white),
                    label: Text(i18n.translate('share_app'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        )),
                    onPressed: () async {
                      /// Share app
                      AppHelper().shareApp();
                    },
                  ),
                  const SizedBox(height: 10),
                  // App version name
                  const Text(APP_VERSION_NAME,
                      style:
                          TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold)),
                  const Divider(height: 30, thickness: 1),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // Contact
                      Text(i18n.translate('do_you_have_a_question'),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text(i18n.translate('send_your_message_to_our_email_address'),
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                          textAlign: TextAlign.center),
                      Text(AppModel().appInfo.appEmail,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
