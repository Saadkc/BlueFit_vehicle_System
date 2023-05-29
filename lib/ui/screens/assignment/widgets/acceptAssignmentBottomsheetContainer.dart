import 'package:eschool_teacher/data/models/reviewAssignmentssubmition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:eschool_teacher/cubits/editreviewassignmetcubit.dart';
import 'package:eschool_teacher/data/models/assignment.dart';
import 'package:eschool_teacher/ui/widgets/bottomSheetTextFiledContainer.dart';
import 'package:eschool_teacher/ui/widgets/bottomSheetTopBarMenu.dart';
import 'package:eschool_teacher/ui/widgets/customCircularProgressIndicator.dart';
import 'package:eschool_teacher/ui/widgets/customRoundedButton.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';

class AcceptAssignmentBottomsheetContainer extends StatefulWidget {
  final Assignment assignment;
  final ReviewAssignmentssubmition reviewAssignment;
  AcceptAssignmentBottomsheetContainer({
    Key? key,
    required this.assignment,
    required this.reviewAssignment,
  }) : super(key: key);

  @override
  State<AcceptAssignmentBottomsheetContainer> createState() =>
      _AcceptAssignmentBottomsheetContainerState();
}

class _AcceptAssignmentBottomsheetContainerState
    extends State<AcceptAssignmentBottomsheetContainer> {
  late TextEditingController _remarkTextEditingController =
      TextEditingController();

  late TextEditingController _pointsTextEditingController =
      TextEditingController();

  void showErrorMessage(String errorMessageKey) {
    UiUtils.showBottomToastOverlay(
        context: context,
        errorMessage: errorMessageKey,
        backgroundColor: Theme.of(context).colorScheme.error);
  }

  void updateAssignment() {
    if (_remarkTextEditingController.text.trim().isEmpty) {
      showErrorMessage(
          UiUtils.getTranslatedLabel(context, pleaseEnterRemarkkey));
    }
    if (_pointsTextEditingController.text.trim().isEmpty) {
      showErrorMessage(
          UiUtils.getTranslatedLabel(context, pleaseEnterPointskey));
    }
    if (int.parse(_pointsTextEditingController.text) <=
        widget.assignment.points) {
      context.read<EditReviewAssignmetCubit>().updateReviewAssignmet(
          reviewAssignmetId: widget.reviewAssignment.id,
          reviewAssignmentStatus: 1,
          reviewAssignmentPoints:
              (widget.assignment.points == 0 && widget.assignment.points == -1)
                  ? "0"
                  : _pointsTextEditingController.text.trim(),
          reviewAssignmentFeedBack: _remarkTextEditingController.text.trim());
    } else {
      UiUtils.showBottomToastOverlay(
          context: context,
          errorMessage:
              UiUtils.getTranslatedLabel(context, pleaseEnterlessPointskey),
          backgroundColor: Theme.of(context).colorScheme.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              BottomSheetTopBarMenu(
                  onTapCloseButton: () {
                    Navigator.of(context).pop();
                  },
                  title: UiUtils.getTranslatedLabel(context, acceptKey)),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: UiUtils.bottomSheetHorizontalContentPadding),
                  child: Column(children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (0.0125),
                    ),
                    BottomSheetTextFieldContainer(
                        hintText:
                            UiUtils.getTranslatedLabel(context, addRemarkKey),
                        maxLines: 2,
                        textEditingController: _remarkTextEditingController),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (0.025),
                    ),
                    if (widget.assignment.points != 0 &&
                        widget.assignment.points != -1)
                      BottomSheetTextFieldContainer(
                          hintText:
                              UiUtils.getTranslatedLabel(context, pointsKey),
                          maxLines: 1,
                          textEditingController: _pointsTextEditingController),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (0.025),
                    ),
                    BlocConsumer<EditReviewAssignmetCubit,
                            EditReviewAssignmetState>(
                        bloc: context.read<EditReviewAssignmetCubit>(),
                        listener: (context, state) {
                          if (state is EditReviewAssignmetSuccess) {
                            UiUtils.showBottomToastOverlay(
                                context: context,
                                errorMessage: UiUtils.getTranslatedLabel(
                                    context, reviewAssignmentsucessfullukey),
                                backgroundColor:
                                    Theme.of(context).colorScheme.onPrimary);
                            //TOTO
                            Navigator.of(context).pop(
                              widget.reviewAssignment.copywith(
                                  id: widget.reviewAssignment.id,
                                  feedback:
                                      _remarkTextEditingController.text.trim(),
                                  points: int.parse(
                                      _pointsTextEditingController.text.trim()),
                                  status: 1),
                            );
                          }
                          if (state is EditReviewAssignmetFailure) {
                            UiUtils.showBottomToastOverlay(
                                context: context,
                                errorMessage: UiUtils.getTranslatedLabel(
                                    context, failureAssignmentReviewkey),
                                backgroundColor:
                                    Theme.of(context).colorScheme.error);
                            Navigator.of(context).pop();
                          }
                        },
                        builder: (context, state) {
                          return CustomRoundedButton(
                              height: UiUtils.bottomSheetButtonHeight,
                              widthPercentage:
                                  UiUtils.bottomSheetButtonWidthPercentage,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              buttonTitle: UiUtils.getTranslatedLabel(
                                  context, submitKey),
                              showBorder: false,
                              child: state is EditReviewAssignmetInProgress
                                  ? CustomCircularProgressIndicator(
                                      strokeWidth: 2,
                                      widthAndHeight: 20,
                                    )
                                  : null,
                              onTap: () {
                                FocusScope.of(context).unfocus();

                                updateAssignment();
                              });
                        }),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * (0.05),
                    ),
                  ]))
            ])),
        onWillPop: () {
          return Future.value(true);
        });
  }
}
