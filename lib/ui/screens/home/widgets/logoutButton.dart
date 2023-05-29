import 'package:eschool_teacher/app/routes.dart';
import 'package:eschool_teacher/cubits/authCubit.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  void showLogOutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content:
                  Text(UiUtils.getTranslatedLabel(context, sureToLogoutKey)),
              actions: [
                CupertinoButton(
                    child: Text(UiUtils.getTranslatedLabel(context, yesKey)),
                    onPressed: () {
                      context.read<AuthCubit>().signOut();
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed(Routes.login);
                    }),
                CupertinoButton(
                    child: Text(UiUtils.getTranslatedLabel(context, noKey)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: InkWell(
        onTap: () {
          showLogOutDialog(context);
        },
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 16,
                    width: 16,
                    child: SvgPicture.asset(
                        UiUtils.getImagePath("logout_icon.svg"))),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  UiUtils.getTranslatedLabel(context, logoutKey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
              ],
            ),
          ),
          width: MediaQuery.of(context).size.width * (0.4),
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Theme.of(context).colorScheme.secondary),
        ),
      ),
    );
  }
}
