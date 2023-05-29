import 'package:eschool_teacher/cubits/createAnnouncementCubit.dart';
import 'package:eschool_teacher/cubits/editAnnouncementCubit.dart';
import 'package:eschool_teacher/cubits/myClassesCubit.dart';
import 'package:eschool_teacher/cubits/subjectsOfClassSectionCubit.dart';
import 'package:eschool_teacher/data/models/announcement.dart';
import 'package:eschool_teacher/data/models/classSectionDetails.dart';
import 'package:eschool_teacher/data/models/studyMaterial.dart';
import 'package:eschool_teacher/data/models/subject.dart';
import 'package:eschool_teacher/data/repositories/announcementRepository.dart';
import 'package:eschool_teacher/data/repositories/teacherRepository.dart';
import 'package:eschool_teacher/ui/widgets/addedFileContainer.dart';
import 'package:eschool_teacher/ui/widgets/announcementAttachmentContainer.dart';
import 'package:eschool_teacher/ui/widgets/bottomSheetTextFiledContainer.dart';
import 'package:eschool_teacher/ui/widgets/bottomsheetAddFilesDottedBorderContainer.dart';
import 'package:eschool_teacher/ui/widgets/classSubjectsDropDownMenu.dart';
import 'package:eschool_teacher/ui/widgets/customAppbar.dart';
import 'package:eschool_teacher/ui/widgets/customCircularProgressIndicator.dart';
import 'package:eschool_teacher/ui/widgets/customRoundedButton.dart';
import 'package:eschool_teacher/ui/widgets/defaultDropDownLabelContainer.dart';
import 'package:eschool_teacher/ui/widgets/myClassesDropDownMenu.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class AddOrEditAnnouncementScreen extends StatefulWidget {
  final Announcement? announcement;
  final ClassSectionDetails? classSectionDetails;
  final Subject? subject;
  AddOrEditAnnouncementScreen(
      {Key? key, this.classSectionDetails, this.announcement, this.subject})
      : super(key: key);

  static Route<bool?> route(RouteSettings routeSettings) {
    final arguments = (routeSettings.arguments ?? Map<String, dynamic>.from({}))
        as Map<String, dynamic>;
    return CupertinoPageRoute(
        builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) =>
                        SubjectsOfClassSectionCubit(TeacherRepository()),
                  ),
                  BlocProvider(
                    create: (context) =>
                        CreateAnnouncementCubit(AnnouncementRepository()),
                  ),
                  BlocProvider(
                    create: (context) =>
                        EditAnnouncementCubit(AnnouncementRepository()),
                  ),
                ],
                child: AddOrEditAnnouncementScreen(
                  announcement: arguments['announcement'],
                  subject: arguments['subject'],
                  classSectionDetails: arguments['classSectionDetails'],
                )));
  }

  @override
  State<AddOrEditAnnouncementScreen> createState() =>
      _AddOrEditAnnouncementScreenState();
}

class _AddOrEditAnnouncementScreenState
    extends State<AddOrEditAnnouncementScreen> {
  late String currentSelectedClassSection = widget.classSectionDetails != null
      ? widget.classSectionDetails!.getClassSectionName()
      : context.read<MyClassesCubit>().getClassSectionName().first;

  late String currentSelectedSubject = widget.subject != null
      ? widget.subject!.name
      : UiUtils.getTranslatedLabel(context, fetchingSubjectsKey);

  late TextEditingController _announcementTitleEditingController =
      TextEditingController(
          text:
              widget.announcement != null ? widget.announcement!.title : null);
  late TextEditingController _announcementDescriptionEditingController =
      TextEditingController(
          text: widget.announcement != null
              ? widget.announcement!.description
              : null);

  List<PlatformFile> _addedAttatchments = [];

  late List<StudyMaterial> attatchments =
      widget.announcement != null ? widget.announcement!.files : [];

  //This will determine if need to refresh the previous page
  //lessons data. If teacher remove the the any study material
  //so we need to fetch the list again
  late bool refreshAnnouncementsInPreviousPage = false;

  @override
  void initState() {
    if (widget.classSectionDetails == null) {
      context.read<SubjectsOfClassSectionCubit>().fetchSubjects(
          context.read<MyClassesCubit>().getAllClasses().first.id);
    }
    super.initState();
  }

  void deleteAttachment(int attachmentId) {
    attatchments.removeWhere((element) => element.id == attachmentId);

    refreshAnnouncementsInPreviousPage = true;
    setState(() {});
  }

  Future<bool> _isPermissionGiven() async {
    bool permissionGiven = (await Permission.storage.status).isGranted;
    if (!permissionGiven) {
      permissionGiven = (await Permission.storage.request()).isGranted;
    }
    return permissionGiven;
  }

  void addAttachment() async {
    final permissionGiven = await _isPermissionGiven();
    if (permissionGiven) {
      final pickedFile = await FilePicker.platform.pickFiles();
      if (pickedFile != null) {
        _addedAttatchments.add(pickedFile.files.first);
        setState(() {});
      }
    } else {
      UiUtils.showBottomToastOverlay(
          context: context,
          errorMessage:
              UiUtils.getTranslatedLabel(context, permissionToPickFileKey),
          backgroundColor: Theme.of(context).colorScheme.error);
    }
  }

  void createAnnouncement() {
    if (_announcementTitleEditingController.text.trim().isEmpty) {
      UiUtils.showBottomToastOverlay(
          context: context,
          errorMessage: UiUtils.getTranslatedLabel(
              context, pleaseAddAnnouncementTitleKey),
          backgroundColor: Theme.of(context).colorScheme.error);
      return;
    }
    context.read<CreateAnnouncementCubit>().createAnnouncement(
        title: _announcementTitleEditingController.text.trim(),
        description: _announcementDescriptionEditingController.text.trim(),
        attachments: _addedAttatchments,
        classSectionId: widget.classSectionDetails != null
            ? widget.classSectionDetails!.id
            : context
                .read<MyClassesCubit>()
                .getClassSectionDetails(
                    classSectionName: currentSelectedClassSection)
                .id,
        subjectId: widget.subject != null
            ? widget.subject!.id
            : context
                .read<SubjectsOfClassSectionCubit>()
                .getSubjectIdByName(currentSelectedSubject));
  }

  void editAnnouncement() {
    if (_announcementTitleEditingController.text.trim().isEmpty) {
      UiUtils.showBottomToastOverlay(
          context: context,
          errorMessage: UiUtils.getTranslatedLabel(
              context, pleaseAddAnnouncementTitleKey),
          backgroundColor: Theme.of(context).colorScheme.error);
      return;
    }
    context.read<EditAnnouncementCubit>().editAnnouncement(
        announcementId: widget.announcement!.id,
        title: _announcementTitleEditingController.text.trim(),
        description: _announcementDescriptionEditingController.text.trim(),
        attachments: _addedAttatchments,
        classSectionId: widget.classSectionDetails!.id,
        subjectId: widget.subject!.id);
  }

  Widget _buildClassAndSubjectDropDowns() {
    return LayoutBuilder(builder: (context, boxConstraints) {
      return Column(
        children: [
          widget.classSectionDetails == null
              ? MyClassesDropDownMenu(
                  currentSelectedItem: currentSelectedClassSection,
                  width: boxConstraints.maxWidth,
                  changeSelectedItem: (result) {
                    setState(() {
                      currentSelectedClassSection = result;
                    });
                  })
              : DefaultDropDownLabelContainer(
                  titleLabelKey: currentSelectedClassSection,
                  width: boxConstraints.maxWidth),

          //
          widget.subject == null
              ? ClassSubjectsDropDownMenu(
                  changeSelectedItem: (result) {
                    setState(() {
                      currentSelectedSubject = result;
                    });
                  },
                  currentSelectedItem: currentSelectedSubject,
                  width: boxConstraints.maxWidth)
              : DefaultDropDownLabelContainer(
                  titleLabelKey: currentSelectedSubject,
                  width: boxConstraints.maxWidth),
        ],
      );
    });
  }

  Widget _buildAnnouncementForm() {
    return SingleChildScrollView(
        padding: EdgeInsets.only(
            bottom: 25,
            right: UiUtils.screenContentHorizontalPaddingPercentage *
                MediaQuery.of(context).size.width,
            left: UiUtils.screenContentHorizontalPaddingPercentage *
                MediaQuery.of(context).size.width,
            top: UiUtils.getScrollViewTopPadding(
                context: context,
                appBarHeightPercentage: UiUtils.appBarSmallerHeightPercentage)),
        child: Column(
          children: [
            _buildClassAndSubjectDropDowns(),
            BottomSheetTextFieldContainer(
                hintText:
                    UiUtils.getTranslatedLabel(context, announcementTitleKey),
                margin: EdgeInsets.only(bottom: 20),
                maxLines: 1,
                contentPadding: EdgeInsetsDirectional.only(start: 15),
                textEditingController: _announcementTitleEditingController),
            BottomSheetTextFieldContainer(
                margin: EdgeInsets.only(bottom: 20),
                hintText: UiUtils.getTranslatedLabel(
                    context, announcementDescriptionKey),
                maxLines: 3,
                contentPadding: EdgeInsetsDirectional.only(start: 15),
                textEditingController:
                    _announcementDescriptionEditingController),
            widget.announcement != null
                ? Column(
                    children: attatchments
                        .map((file) => AnnouncementAttachmentContainer(
                            onDeleteCallback: deleteAttachment,
                            showDeleteButton: true,
                            studyMaterial: file))
                        .toList(),
                  )
                : SizedBox(),
            BottomsheetAddFilesDottedBorderContainer(
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  addAttachment();
                },
                title: UiUtils.getTranslatedLabel(context, attachmentsKey)),
            SizedBox(
              height: 20,
            ),
            ...List.generate(_addedAttatchments.length, (index) => index)
                .map((index) => Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: AddedFileContainer(
                          onDelete: () {
                            _addedAttatchments.removeAt(index);
                            setState(() {});
                          },
                          platformFile: _addedAttatchments[index]),
                    ))
                .toList(),
            widget.announcement != null
                ? BlocConsumer<EditAnnouncementCubit, EditAnnouncementState>(
                    listener: (context, state) {
                      if (state is EditAnnouncementSuccess) {
                        Navigator.of(context).pop(true);
                      } else if (state is EditAnnouncementFailure) {
                        UiUtils.showBottomToastOverlay(
                            context: context,
                            errorMessage: UiUtils.getErrorMessageFromErrorCode(
                                context, state.errorMessage),
                            backgroundColor:
                                Theme.of(context).colorScheme.error);
                      }
                    },
                    builder: (context, state) {
                      return LayoutBuilder(builder: (context, boxConstraints) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: boxConstraints.maxWidth * (0.15)),
                          child: CustomRoundedButton(
                              onTap: () {
                                if (state is EditAnnouncementInProgress) {
                                  return;
                                }
                                editAnnouncement();
                              },
                              child: state is EditAnnouncementInProgress
                                  ? CustomCircularProgressIndicator(
                                      strokeWidth: 2,
                                      widthAndHeight: 20,
                                    )
                                  : null,
                              height: 45,
                              widthPercentage: 1.0,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              buttonTitle: UiUtils.getTranslatedLabel(
                                  context, editAnnouncementKey),
                              showBorder: false),
                        );
                      });
                    },
                  )
                : BlocConsumer<CreateAnnouncementCubit,
                    CreateAnnouncementState>(
                    listener: (context, state) {
                      if (state is CreateAnnouncementSuccess) {
                        _announcementTitleEditingController.text = "";
                        _announcementDescriptionEditingController.text = "";
                        _addedAttatchments = [];
                        setState(() {});
                        UiUtils.showBottomToastOverlay(
                            context: context,
                            errorMessage: UiUtils.getTranslatedLabel(
                                context, announcementAddedKey),
                            backgroundColor:
                                Theme.of(context).colorScheme.onPrimary);
                      } else if (state is CreateAnnouncementFailure) {
                        UiUtils.showBottomToastOverlay(
                            context: context,
                            errorMessage: UiUtils.getErrorMessageFromErrorCode(
                                context, state.errorMessage),
                            backgroundColor:
                                Theme.of(context).colorScheme.error);
                      }
                    },
                    builder: (context, state) {
                      return LayoutBuilder(builder: (context, boxConstraints) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: boxConstraints.maxWidth * (0.125)),
                          child: CustomRoundedButton(
                              onTap: () {
                                //
                                if (state is CreateAnnouncementInProgress) {
                                  return;
                                }
                                createAnnouncement();
                              },
                              child: state is CreateAnnouncementInProgress
                                  ? CustomCircularProgressIndicator(
                                      strokeWidth: 2,
                                      widthAndHeight: 20,
                                    )
                                  : null,
                              height: 45,
                              widthPercentage: boxConstraints.maxWidth * (0.45),
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              buttonTitle: UiUtils.getTranslatedLabel(
                                  context, addAnnouncementKey),
                              showBorder: false),
                        );
                      });
                    },
                  ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (context.read<EditAnnouncementCubit>().state
            is EditAnnouncementInProgress) {
          return Future.value(false);
        }
        if (context.read<CreateAnnouncementCubit>().state
            is CreateAnnouncementInProgress) {
          return Future.value(false);
        }
        Navigator.of(context).pop(refreshAnnouncementsInPreviousPage);
        return Future.value(false);
      },
      child: Scaffold(
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: _buildAnnouncementForm(),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: CustomAppBar(
                onPressBackButton: () {
                  if (context.read<EditAnnouncementCubit>().state
                      is EditAnnouncementInProgress) {
                    return;
                  }
                  if (context.read<CreateAnnouncementCubit>().state
                      is CreateAnnouncementInProgress) {
                    return;
                  }
                  Navigator.of(context).pop(refreshAnnouncementsInPreviousPage);
                },
                title: UiUtils.getTranslatedLabel(
                    context,
                    widget.announcement != null
                        ? editAnnouncementKey
                        : addAnnouncementKey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
