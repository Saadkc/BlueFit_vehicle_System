import 'package:eschool_teacher/app/routes.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/material.dart';

class TermsAndConditionAndPrivacyPolicyContainer extends StatelessWidget {
  TermsAndConditionAndPrivacyPolicyContainer();
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            UiUtils.getTranslatedLabel(context, termsAndConditionAgreementKey),
            style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.secondary.withOpacity(0.8), fontWeight: FontWeight.bold),
          ),
        ],
      ),
      SizedBox(
        height: 4,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(Routes.termsAndCondition);
              },
              child: Text(
                UiUtils.getTranslatedLabel(context, termsAndConditionKey),
                style: TextStyle(color: Theme.of(context).colorScheme.primary, decoration: TextDecoration.underline, fontWeight: FontWeight.bold, fontSize: 13),
              )),
          SizedBox(
            width: 5.0,
          ),
          Text("&", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold)),
          SizedBox(
            width: 5.0,
          ),
          InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(Routes.privacyPolicy);
              },
              child: Text(
                UiUtils.getTranslatedLabel(context, privacyPolicyKey),
                style: TextStyle(color: Theme.of(context).colorScheme.primary, decoration: TextDecoration.underline, fontWeight: FontWeight.bold, fontSize: 13),
              )),
        ],
      ),
    ]));
  }
}
