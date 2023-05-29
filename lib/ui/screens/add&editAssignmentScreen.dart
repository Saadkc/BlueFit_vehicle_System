import 'package:dotted_border/dotted_border.dart';
import 'package:eschool_teacher/cubits/createAssignmentCubit.dart';
import 'package:eschool_teacher/cubits/editassignment.dart';
import 'package:eschool_teacher/cubits/myClassesCubit.dart';
import 'package:eschool_teacher/cubits/subjectsOfClassSectionCubit.dart';
import 'package:eschool_teacher/data/models/assignment.dart';
import 'package:eschool_teacher/data/models/studyMaterial.dart';
import 'package:eschool_teacher/data/repositories/assignmentRepository.dart';
import 'package:eschool_teacher/data/repositories/teacherRepository.dart';
import 'package:eschool_teacher/ui/styles/colors.dart';
import 'package:eschool_teacher/ui/widgets/assignmentAttachmentContainer.dart';
import 'package:eschool_teacher/ui/widgets/bottomSheetTextFiledContainer.dart';
import 'package:eschool_teacher/ui/widgets/bottomsheetAddFilesDottedBorderContainer.dart';
import 'package:eschool_teacher/ui/widgets/classSubjectsDropDownMenu.dart';
import 'package:eschool_teacher/ui/widgets/customAppbar.dart';
import 'package:eschool_teacher/ui/widgets/customCircularProgressIndicator.dart';
import 'package:eschool_teacher/ui/widgets/customCupertinoSwitch.dart';
import 'package:eschool_teacher/ui/widgets/customRoundedButton.dart';
import 'package:eschool_teacher/ui/widgets/defaultDropDownLabelContainer.dart';
import 'package:eschool_teacher/ui/widgets/myClassesDropDownMenu.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';

class AddAssignmentScreen extends StatefulWidget {
  final bool editassignment;
  final Assignment? assignment;

  AddAssignmentScreen({
    Key? key,
    required this.editassignment,
    this.assignment,
  }) : super(key: key);

  static Route<bool?> Routes(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(builder: (context) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<SubjectsOfClassSectionCubit>(
            create: (_) => SubjectsOfClassSectionCubit(TeacherRepository()),
          ),
          BlocProvider<CreateAssignmentCubit>(
            create: (_) => CreateAssignmentCubit(AssignmentRepository()),
          ),
          BlocProvider<editAssignmentCubit>(
              create: (context) => editAssignmentCubit(AssignmentRepository()))
        ],
        child: AddAssignmentScreen(
          editassignment: arguments["editAssignment"],
          assignment: arguments["assignment"],
        ),
      );
    });
  }

  @override
  State<AddAssignmentScreen> createState() => _AddAssignmentScreenState();
}

class _AddAssignmentScreenState extends State<AddAssignmentScreen> {
  late String currentSelectedClassSection = widget.editassignment
      ? context
          .read<MyClassesCubit>()
          .getClassSectionDetailsById(widget.assignment!.classSectionId)
          .getClassSectionName()
      : context.read<MyClassesCubit>().getClassSectionName().first;

  late String currentSelectedSubject =
      UiUtils.getTranslatedLabel(context, fetchingSubjectsKey);

  DateTime? dueDate;

  TimeOfDay? dueTime;

  late TextEditingController _assignmentNameTextEditingController =
      TextEditingController(
          text: widget.editassignment ? widget.assignment!.name : null);

  late TextEditingController _assignmentInstructionTextEditingController =
      TextEditingController(
          text: widget.editassignment ? widget.assignment!.instructions : null);

  late TextEditingController _assignmentPointsTextEditingController =
      TextEditingController(
          text: widget.editassignment
              ? widget.assignment!.points.toString()
              : null);

  late TextEditingController _extraResubmissionDaysTextEditingController =
      TextEditingController(
          text: widget.editassignment
              ? widget.assignment!.extraDaysForResubmission.toString()
              : null);

  final double _textFieldBottomPadding = 25;

  late bool _allowedReSubmissionOfRejectedAssignment = widget.editassignment
      ? widget.assignment!.resubmission == 0
          ? false
          : true
      : true;

  @override
  void initState() {
    if (!widget.editassignment) {
      context.read<SubjectsOfClassSectionCubit>().fetchSubjects(context
          .read<MyClassesCubit>()
          .getClassSectionDetails(classSectionName: currentSelectedClassSection)
          .id);
    } else {
      dueDate = DateFormat('dd-MM-yyyy').parse(
          UiUtils.formatStringDate(widget.assignment!.dueDate.toString()));

      dueTime = TimeOfDay.fromDateTime(widget.assignment!.dueDate);
    }
    super.initState();
  }

  void changeAllowedReSubmissionOfRejectedAssignment(bool value) {
    setState(() {
      _allowedReSubmissionOfRejectedAssignment = value;
    });
  }

  List<PlatformFile> uploadedFiles = [];

  late List<StudyMaterial> assignmentattatchments =
      widget.editassignment ? widget.assignment!.studyMaterial : [];

  void _pickFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      uploadedFiles.add(result.files.first);
      setState(() {});
    }
  }

  void _addFiles() async {
    //upload files
    bool permissionGiven = (await Permission.storage.status).isGranted;
    if (permissionGiven) {
      _pickFiles();
    } else {
      permissionGiven = (await Permission.storage.request()).isGranted;
      if (permissionGiven) {
        _pickFiles();
      }
    }
  }

  Widget _buildUploadedFileContainer(int fileIndex) {
    return LayoutBuilder(
      builder: (context, boxConstraints) {
        return Padding(
          padding: EdgeInsetsDirectional.only(bottom: 15),
          child: DottedBorder(
            borderType: BorderType.RRect,
            dashPattern: [10, 10],
            radius: Radius.circular(10.0),
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
            child: LayoutBuilder(builder: (context, boxConstraints) {
              return Padding(
                padding: EdgeInsetsDirectional.only(start: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: boxConstraints.maxWidth * (0.75),
                      child: Text(uploadedFiles[fileIndex].name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          )),
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          if (context.read<CreateAssignmentCubit>().state
                              is createAssignmentInProcess) {
                            return;
                          }
                          uploadedFiles.removeAt(fileIndex);
                          setState(() {});
                        },
                        icon: Icon(Icons.close)),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget assignmentassignmentattatchments(int fileIndex) {
    return LayoutBuilder(builder: (context, boxConstraints) {
      return Padding(
        padding: EdgeInsetsDirectional.only(bottom: 15),
        child: DottedBorder(
          borderType: BorderType.RRect,
          dashPattern: [10, 10],
          radius: Radius.circular(10.0),
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
          child: LayoutBuilder(builder: (context, boxConstraints) {
            return Padding(
              padding: EdgeInsetsDirectional.only(start: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: boxConstraints.maxWidth * (0.75),
                    child: Text(assignmentattatchments[fileIndex].fileName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        )),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        if (context.read<CreateAssignmentCubit>().state
                            is createAssignmentInProcess) {
                          return;
                        }

                        assignmentattatchments.removeAt(fileIndex);
                        setState(() {});
                      },
                      icon: Icon(Icons.close)),
                ],
              ),
            );
          }),
        ),
      );
    });
  }

  void openDatePicker() async {
    dueDate = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(
                  onPrimary: Theme.of(context).scaffoldBackgroundColor)),
          child: child!,
        );
      },
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        Duration(days: 30),
      ),
    );

    setState(() {});
  }

  void openTimePicker() async {
    dueTime = await showTimePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                    onPrimary: Theme.of(context).scaffoldBackgroundColor)),
            child: child!,
          );
        },
        context: context,
        initialTime: TimeOfDay.now());
    setState(() {});
  }

  void showErrorMessage(String errorMessageKey) {
    UiUtils.showBottomToastOverlay(
        context: context,
        errorMessage: errorMessageKey,
        backgroundColor: Theme.of(context).colorScheme.error);
  }

  void createAssignment() {
    if (_assignmentNameTextEditingController.text.trim().isEmpty) {
      showErrorMessage(
          UiUtils.getTranslatedLabel(context, pleaseEnterAssignmentnameKey));
      return;
    }
    if (_assignmentPointsTextEditingController.text.length >= 10) {
      showErrorMessage(UiUtils.getTranslatedLabel(context, pointsLengthKey));
      return;
    }
    if (dueDate == null) {
      showErrorMessage(
          UiUtils.getTranslatedLabel(context, pleaseSelectDateKey));
      return;
    }
    if (dueTime == null) {
      showErrorMessage(
          UiUtils.getTranslatedLabel(context, pleaseSelectDateKey));
      return;
    }
    print("uploadedFiles create $uploadedFiles");
    context.read<CreateAssignmentCubit>().createAssignment(
          classsId: context
              .read<MyClassesCubit>()
              .getClassSectionDetails(
                  classSectionName: currentSelectedClassSection)
              .id,
          subjectId: context
              .read<SubjectsOfClassSectionCubit>()
              .getSubjectIdByName(currentSelectedSubject),
          name: _assignmentNameTextEditingController.text.trim(),
          datetime:
              "${DateFormat('dd-MM-yyyy').format(dueDate!).toString()} ${dueTime!.hour}:${dueTime!.minute}",
          extraDayForResubmission:
              _extraResubmissionDaysTextEditingController.text.trim(),
          instruction: _assignmentInstructionTextEditingController.text.trim(),
          points: _assignmentPointsTextEditingController.text.trim(),
          resubmission: _allowedReSubmissionOfRejectedAssignment,
          file: uploadedFiles,
        );
  }

  void editAssignment() {
    if (_assignmentNameTextEditingController.text.trim().isEmpty) {
      showErrorMessage(
          UiUtils.getTranslatedLabel(context, pleaseEnterAssignmentnameKey));
    }
    if (dueDate == null) {
      showErrorMessage(
          UiUtils.getTranslatedLabel(context, pleaseSelectDateKey));
    }
    if (_assignmentPointsTextEditingController.text.length >= 10) {
      showErrorMessage(UiUtils.getTranslatedLabel(context, pointsLengthKey));
      return;
    }
    if (dueTime == null) {
      showErrorMessage(
          UiUtils.getTranslatedLabel(context, pleaseSelectDateKey));
    }

    print("uploadedFiles upload $uploadedFiles");
    context.read<editAssignmentCubit>().editAssignment(
          classSelectionId: widget.assignment!.classSectionId,
          subjectId: widget.assignment!.subjectId,
          name: _assignmentNameTextEditingController.text.trim(),
          dateTime:
              "${DateFormat('dd-MM-yyyy').format(dueDate!).toString()} ${dueTime!.hour}:${dueTime!.minute}",
          extraDayForResubmission:
              _extraResubmissionDaysTextEditingController.text.trim(),
          instruction: _assignmentInstructionTextEditingController.text.trim(),
          points: _assignmentPointsTextEditingController.text.trim(),
          resubmission: _allowedReSubmissionOfRejectedAssignment ? 1 : 0,
          filePaths: uploadedFiles,
          assignmentId: widget.assignment!.id,
        );
  }

  Widget _buildAppBar() {
    return Align(
      alignment: Alignment.topCenter,
      child: CustomAppBar(
          title: UiUtils.getTranslatedLabel(context,
              widget.editassignment ? editAssignmentKey : createAssignmentKey),
          onPressBackButton: () {
            if (context.read<CreateAssignmentCubit>().state
                is createAssignmentInProcess) {
              return;
            }
            if (context.read<editAssignmentCubit>().state
                is editAssignmentInProgress) {
              return;
            }
            Navigator.of(context).pop();
          }),
    );
  }

  Widget _buildAssignmentClassDropdownButtons() {
    return LayoutBuilder(builder: (context, boxConstraints) {
      return Column(
        children: [
          widget.editassignment
              ? DefaultDropDownLabelContainer(
                  titleLabelKey: currentSelectedClassSection,
                  width: boxConstraints.maxWidth)
              : MyClassesDropDownMenu(
                  currentSelectedItem: currentSelectedClassSection,
                  width: boxConstraints.maxWidth,
                  changeSelectedItem: (result) {
                    setState(() {
                      currentSelectedClassSection = result;
                    });
                  }),
          widget.editassignment
              ? DefaultDropDownLabelContainer(
                  titleLabelKey: widget.assignment!.subject.name.toString(),
                  width: boxConstraints.maxWidth)
              : ClassSubjectsDropDownMenu(
                  changeSelectedItem: (result) {
                    setState(() {
                      currentSelectedSubject = result;
                    });
                  },
                  currentSelectedItem: currentSelectedSubject,
                  width: boxConstraints.maxWidth),
        ],
      );
    });
  }

  Widget _buildAddDueDateAndTimeContainer() {
    return Padding(
      padding: EdgeInsets.only(bottom: _textFieldBottomPadding),
      child: LayoutBuilder(builder: (context, boxConstraints) {
        return Row(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                openDatePicker();
              },
              child: Container(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  dueDate == null
                      ? UiUtils.getTranslatedLabel(context, dueDateKey)
                      : DateFormat('dd-MM-yyyy').format(dueDate!).toString(),
                  style: TextStyle(
                      color: hintTextColor,
                      fontSize: UiUtils.textFieldFontSize),
                ),
                padding: EdgeInsetsDirectional.only(start: 20.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.5),
                  ),
                ),
                width: boxConstraints.maxWidth * (0.475),
                height: 50,
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                openTimePicker();
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  dueTime == null
                      ? UiUtils.getTranslatedLabel(context, dueTimeKey)
                      : "${dueTime!.hour}:${dueTime!.minute}",
                  style: TextStyle(
                      color: hintTextColor,
                      fontSize: UiUtils.textFieldFontSize),
                ),
                padding: EdgeInsetsDirectional.only(start: 20.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.5),
                  ),
                ),
                width: boxConstraints.maxWidth * (0.475),
                height: 50,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildReSubmissionOfRejectedAssignmentToggleContainer() {
    return Padding(
      padding: EdgeInsets.only(bottom: _textFieldBottomPadding),
      child: LayoutBuilder(builder: (context, boxConstraints) {
        return Container(
          height: 70,
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
            ),
          ),
          child: Row(
            children: [
              Flexible(
                child: SizedBox(
                  width: boxConstraints.maxWidth * (0.85),
                  child: Text(
                    UiUtils.getTranslatedLabel(
                        context, resubmissionOfRejectedAssignmentKey),
                    style: TextStyle(
                        color: hintTextColor,
                        fontSize: UiUtils.textFieldFontSize),
                  ),
                ),
              ),
              SizedBox(
                width: boxConstraints.maxWidth * (0.075),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: boxConstraints.maxWidth * (0.1),
                child: CustomCupertinoSwitch(
                    onChanged: changeAllowedReSubmissionOfRejectedAssignment,
                    value: _allowedReSubmissionOfRejectedAssignment),
              )
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAssignmentDetailsFormContaienr() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * (0.075),
          right: MediaQuery.of(context).size.width * (0.075),
          top: UiUtils.getScrollViewTopPadding(
              context: context,
              appBarHeightPercentage: UiUtils.appBarSmallerHeightPercentage)),
      child: Column(
        children: [
          //
          _buildAssignmentClassDropdownButtons(),
          BottomSheetTextFieldContainer(
            margin: EdgeInsetsDirectional.only(bottom: _textFieldBottomPadding),
            hintText: UiUtils.getTranslatedLabel(context, assignmentNameKey),
            maxLines: 1,
            textEditingController: _assignmentNameTextEditingController,
          ),

          BottomSheetTextFieldContainer(
            margin: EdgeInsetsDirectional.only(bottom: _textFieldBottomPadding),
            hintText: UiUtils.getTranslatedLabel(context, instructionsKey),
            maxLines: 3,
            textEditingController: _assignmentInstructionTextEditingController,
          ),

          _buildAddDueDateAndTimeContainer(),

          BottomSheetTextFieldContainer(
            margin: EdgeInsetsDirectional.only(bottom: _textFieldBottomPadding),
            hintText: UiUtils.getTranslatedLabel(context, pointsKey),
            maxLines: 1,
            keyboardType: TextInputType.number,
            textEditingController: _assignmentPointsTextEditingController,
            textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
          ),

          //_buildLateSubmissionToggleContainer(),

          _buildReSubmissionOfRejectedAssignmentToggleContainer(),

          _allowedReSubmissionOfRejectedAssignment
              ? BottomSheetTextFieldContainer(
                  margin: EdgeInsetsDirectional.only(
                      bottom: _textFieldBottomPadding),
                  hintText: UiUtils.getTranslatedLabel(
                      context, extraDaysForRejectedAssignmentKey),
                  maxLines: 2,
                  textEditingController:
                      _extraResubmissionDaysTextEditingController,
                  keyboardType: TextInputType.number,
                  textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                )
              : SizedBox(),
          assignmentattatchments.isNotEmpty
              ? Column(
                  children: assignmentattatchments
                      .map((studyMaterial) => AssignmentAttachmentContainer(
                          onDeleteCallback: (fileId) {
                            assignmentattatchments
                                .removeWhere((element) => element.id == fileId);
                            setState(() {});
                          },
                          showDeleteButton: true,
                          studyMaterial: studyMaterial))
                      .toList(),
                )
              : SizedBox(),

          Padding(
            padding: EdgeInsets.only(bottom: _textFieldBottomPadding),
            child: BottomsheetAddFilesDottedBorderContainer(
                onTap: () async {
                  _addFiles();
                },
                title:
                    UiUtils.getTranslatedLabel(context, referenceMaterialsKey)),
          ),

          ...List.generate(uploadedFiles.length, (index) => index)
              .map((fileIndex) => _buildUploadedFileContainer(fileIndex))
              .toList(),

          widget.editassignment
              ? BlocConsumer<editAssignmentCubit, EditAssignmentState>(
                  listener: (context, state) {
                    if (state is editAssignmentSuccess) {
                      UiUtils.showBottomToastOverlay(
                          context: context,
                          errorMessage: UiUtils.getTranslatedLabel(
                              context, editsucessfullyassignmentkey),
                          backgroundColor:
                              Theme.of(context).colorScheme.onPrimary);
                      Navigator.of(context).pop(true);
                    }
                    if (state is editAssignmentFailure) {
                      UiUtils.showBottomToastOverlay(
                          context: context,
                          errorMessage: UiUtils.getTranslatedLabel(
                              context, state.errorMessage),
                          backgroundColor:
                              Theme.of(context).colorScheme.onPrimary);
                      Navigator.of(context).pop();
                    }
                  },
                  builder: (context, state) {
                    return LayoutBuilder(builder: (context, boxConstraints) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: boxConstraints.maxWidth * (0.125)),
                        child: CustomRoundedButton(
                            height: 45,
                            radius: 10,
                            widthPercentage: boxConstraints.maxWidth * (0.45),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            buttonTitle: UiUtils.getTranslatedLabel(
                                context, editassignmentkey),
                            showBorder: false,
                            child: state is editAssignmentInProgress
                                ? CustomCircularProgressIndicator(
                                    strokeWidth: 2,
                                    widthAndHeight: 20,
                                  )
                                : null,
                            onTap: () {
                              if (state is editAssignmentInProgress) {
                                return;
                              }
                              editAssignment();
                            }),
                      );
                    });
                  },
                )
              : BlocConsumer<CreateAssignmentCubit, createAssignmentState>(
                  listener: (context, state) {
                    if (state is createAssignmentSuccess) {
                      UiUtils.showBottomToastOverlay(
                          context: context,
                          errorMessage: UiUtils.getTranslatedLabel(
                              context, sucessfullycreateassignmentkey),
                          backgroundColor:
                              Theme.of(context).colorScheme.onPrimary);
                      Navigator.of(context).pop();
                    }
                    if (state is createAssignmentFailure) {
                      UiUtils.showBottomToastOverlay(
                          context: context,
                          errorMessage: UiUtils.getTranslatedLabel(
                              context, state.errormessage),
                          backgroundColor: Theme.of(context).colorScheme.error);
                    }
                  },
                  builder: (context, state) {
                    return CustomRoundedButton(
                      height: 45,
                      radius: 10,
                      widthPercentage: 0.65,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      buttonTitle: UiUtils.getTranslatedLabel(
                          context, createAssignmentKey),
                      showBorder: false,
                      child: state is createAssignmentInProcess
                          ? CustomCircularProgressIndicator(
                              strokeWidth: 2,
                              widthAndHeight: 20,
                            )
                          : null,
                      onTap: () {
                        if (state is createAssignmentInProcess) {
                          return;
                        }
                        createAssignment();
                      },
                    );
                  },
                ),
          SizedBox(
            height: _textFieldBottomPadding,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          if (context.read<CreateAssignmentCubit>().state
              is createAssignmentInProcess) {
            return Future.value(false);
          }
          if (context.read<editAssignmentCubit>().state
              is editAssignmentInProgress) {
            return Future.value(false);
          }
          Navigator.of(context).pop();
          return Future.value(true);
        },
        child: Scaffold(
          body: Stack(
            children: [
              _buildAssignmentDetailsFormContaienr(),
              _buildAppBar(),
            ],
          ),
        ));
  }
}
/*context.read<editAssignmentCubit>().editAssignment(
                          assignmentId: widget.assignment!.id,
                          classSelectionId: widget.assignment!.classSectionId,
                          dateTime:
                              "${DateFormat('dd-MM-yyyy').format(dueDate!).toString()} ${dueTime!.hour}:${dueTime!.minute}",
                          subjectId: widget.assignment!.sessionYearId,
                          name: _assignmentNameTextEditingController.text,
                          points: _assignmentPointsTextEditingController.text,
                          resubmission:
                              _allowedReSubmissionOfRejectedAssignment ? 1 : 0,
                          extraDayForResubmission:
                              _extraResubmissionDaysTextEditingController.text,
                          filePaths: uploadedFiles.map((e) => e.path!).toList(),
                          instruction:
                              _assignmentInstructionTextEditingController.text)*/