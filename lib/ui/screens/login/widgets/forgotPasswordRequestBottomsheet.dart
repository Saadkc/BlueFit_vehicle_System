import 'package:eschool_teacher/cubits/forgotPasswordRequestCubit.dart';
import 'package:eschool_teacher/ui/widgets/bottomSheetTextFiledContainer.dart';
import 'package:eschool_teacher/ui/widgets/bottomSheetTopBarMenu.dart';
import 'package:eschool_teacher/ui/widgets/customRoundedButton.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordRequestBottomsheet extends StatefulWidget {
  ForgotPasswordRequestBottomsheet({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordRequestBottomsheet> createState() =>
      _ForgotPasswordRequestBottomsheetState();
}

class _ForgotPasswordRequestBottomsheetState
    extends State<ForgotPasswordRequestBottomsheet> {
  final TextEditingController _emailTextEditingController =
      TextEditingController();

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (context.read<ForgotPasswordRequestCubit>().state
            is ForgotPasswordRequestInProgress) {
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
                  onTapCloseButton: () {
                    if (context.read<ForgotPasswordRequestCubit>().state
                        is ForgotPasswordRequestInProgress) {
                      return;
                    }
                    Navigator.of(context).pop();
                  },
                  title:
                      UiUtils.getTranslatedLabel(context, forgotPasswordKey)),
              BottomSheetTextFieldContainer(
                hintText: emailKey,
                margin: EdgeInsets.symmetric(
                    horizontal: UiUtils.bottomSheetHorizontalContentPadding),
                maxLines: 1,
                textEditingController: _emailTextEditingController,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * (0.025),
              ),
              BlocConsumer<ForgotPasswordRequestCubit,
                  ForgotPasswordRequestState>(
                listener: ((context, state) {
                  if (state is ForgotPasswordRequestFailure) {
                    UiUtils.showBottomToastOverlay(
                        context: context,
                        errorMessage: UiUtils.getErrorMessageFromErrorCode(
                            context, state.errorMessage),
                        backgroundColor: Theme.of(context).colorScheme.error);
                  } else if (state is ForgotPasswordRequestSuccess) {
                    Navigator.of(context).pop({
                      "error": false,
                      "email": _emailTextEditingController.text.trim()
                    });
                  }
                }),
                builder: (context, state) {
                  return CustomRoundedButton(
                      onTap: () {
                        if (state is ForgotPasswordRequestInProgress) {
                          return;
                        }
                        FocusScope.of(context).unfocus();
                        if (_emailTextEditingController.text.trim().isEmpty) {
                          UiUtils.showBottomToastOverlay(
                              context: context,
                              errorMessage: UiUtils.getTranslatedLabel(
                                  context, pleaseEnterEmailKey),
                              backgroundColor:
                                  Theme.of(context).colorScheme.error);
                          return;
                        }

                        context
                            .read<ForgotPasswordRequestCubit>()
                            .requestforgotPassword(
                                email: _emailTextEditingController.text.trim());
                      },
                      height: 40,
                      textSize: 16.0,
                      widthPercentage: 0.45,
                      titleColor: Theme.of(context).scaffoldBackgroundColor,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      buttonTitle: UiUtils.getTranslatedLabel(
                          context,
                          state is ForgotPasswordRequestInProgress
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
