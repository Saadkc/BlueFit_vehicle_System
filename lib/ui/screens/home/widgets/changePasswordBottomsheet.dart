import 'package:eschool_teacher/cubits/changePasswordCubit.dart';
import 'package:eschool_teacher/ui/widgets/bottomSheetTextFiledContainer.dart';
import 'package:eschool_teacher/ui/widgets/bottomSheetTopBarMenu.dart';
import 'package:eschool_teacher/ui/widgets/customRoundedButton.dart';
import 'package:eschool_teacher/ui/widgets/passwordHideShowButton.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordBottomsheet extends StatefulWidget {
  ChangePasswordBottomsheet({Key? key}) : super(key: key);

  @override
  State<ChangePasswordBottomsheet> createState() =>
      _ChangePasswordBottomsheetState();
}

class _ChangePasswordBottomsheetState extends State<ChangePasswordBottomsheet> {
  final TextEditingController _currentPasswordTextEditingController =
      TextEditingController();
  final TextEditingController _newPasswordTextEditingController =
      TextEditingController();
  final TextEditingController _confirmNewPasswordTextEditingController =
      TextEditingController();

  bool _hideCurrentPassword = true;

  bool _hideNewPassword = true;

  bool _hideConfirmNewPassword = true;

  @override
  void dispose() {
    _currentPasswordTextEditingController.dispose();
    _newPasswordTextEditingController.dispose();
    _confirmNewPasswordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (context.read<ChangePasswordCubit>().state
            is ChangePasswordInProgress) {
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Container(
        margin: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BottomSheetTopBarMenu(
                title: UiUtils.getTranslatedLabel(context, changePasswordKey),
                onTapCloseButton: () {
                  if (context.read<ChangePasswordCubit>().state
                      is ChangePasswordInProgress) {
                    return;
                  }
                  Navigator.of(context).pop();
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: UiUtils.bottomSheetHorizontalContentPadding),
                child: Column(
                  children: [
                    BottomSheetTextFieldContainer(
                      margin: EdgeInsets.only(bottom: 25),
                      maxLines: 1,
                      suffix: PasswordHideShowButton(
                          hidePassword: _hideCurrentPassword,
                          onTap: () {
                            setState(() {
                              _hideCurrentPassword = !_hideCurrentPassword;
                            });
                          }),
                      hideText: _hideCurrentPassword,
                      hintText: UiUtils.getTranslatedLabel(
                          context, currentPasswordKey),
                      textEditingController:
                          _currentPasswordTextEditingController,
                    ),
                    BottomSheetTextFieldContainer(
                      margin: EdgeInsets.only(bottom: 25),
                      maxLines: 1,
                      suffix: PasswordHideShowButton(
                          hidePassword: _hideNewPassword,
                          onTap: () {
                            setState(() {
                              _hideNewPassword = !_hideNewPassword;
                            });
                          }),
                      hideText: _hideNewPassword,
                      hintText:
                          UiUtils.getTranslatedLabel(context, newPasswordKey),
                      textEditingController: _newPasswordTextEditingController,
                    ),
                    BottomSheetTextFieldContainer(
                      margin: EdgeInsets.only(bottom: 25),
                      maxLines: 1,
                      suffix: PasswordHideShowButton(
                          hidePassword: _hideConfirmNewPassword,
                          onTap: () {
                            setState(() {
                              _hideConfirmNewPassword =
                                  !_hideConfirmNewPassword;
                            });
                          }),
                      hideText: _hideConfirmNewPassword,
                      hintText: UiUtils.getTranslatedLabel(
                          context, confirmNewPasswordKey),
                      textEditingController:
                          _confirmNewPasswordTextEditingController,
                    ),
                    BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
                      listener: ((context, state) {
                        if (state is ChangePasswordFailure) {
                          UiUtils.showBottomToastOverlay(
                              context: context,
                              errorMessage:
                                  UiUtils.getErrorMessageFromErrorCode(
                                      context, state.errorMessage),
                              backgroundColor:
                                  Theme.of(context).colorScheme.error);
                        } else if (state is ChangePasswordSuccess) {
                          Navigator.of(context).pop({
                            "error": false,
                          });
                        }
                      }),
                      builder: (context, state) {
                        return CustomRoundedButton(
                            onTap: () {
                              if (state is ChangePasswordInProgress) {
                                return;
                              }
                              FocusScope.of(context).unfocus();
                              if (_currentPasswordTextEditingController.text
                                      .trim()
                                      .isEmpty ||
                                  _newPasswordTextEditingController.text
                                      .trim()
                                      .isEmpty ||
                                  _confirmNewPasswordTextEditingController.text
                                      .trim()
                                      .isEmpty) {
                                UiUtils.showBottomToastOverlay(
                                    context: context,
                                    errorMessage: UiUtils.getTranslatedLabel(
                                        context, pleaseEnterAllFieldKey),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.error);
                                return;
                              }

                              //new password and confirm password must be same
                              if (_newPasswordTextEditingController.text
                                      .trim() !=
                                  _confirmNewPasswordTextEditingController.text
                                      .trim()) {
                                UiUtils.showBottomToastOverlay(
                                    context: context,
                                    errorMessage: UiUtils.getTranslatedLabel(
                                        context, newPasswordAndConfirmSameKey),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.error);
                                return;
                              }

                              context.read<ChangePasswordCubit>().changePassword(
                                  currentPassword:
                                      _currentPasswordTextEditingController.text
                                          .trim(),
                                  newPassword: _newPasswordTextEditingController
                                      .text
                                      .trim(),
                                  newConfirmedPassword:
                                      _confirmNewPasswordTextEditingController
                                          .text
                                          .trim());
                            },
                            height: 40,
                            textSize: 16.0,
                            widthPercentage: 0.45,
                            titleColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            buttonTitle: UiUtils.getTranslatedLabel(
                                context,
                                state is ChangePasswordInProgress
                                    ? submittingKey
                                    : submitKey),
                            showBorder: false);
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (0.025),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(UiUtils.bottomSheetTopRadius),
              topRight: Radius.circular(UiUtils.bottomSheetTopRadius),
            )),
      ),
    );
  }
}
