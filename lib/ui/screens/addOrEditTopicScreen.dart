import 'package:eschool_teacher/cubits/createTopicCubit.dart';
import 'package:eschool_teacher/cubits/editTopicCubit.dart';
import 'package:eschool_teacher/cubits/lessonsCubit.dart';
import 'package:eschool_teacher/cubits/myClassesCubit.dart';
import 'package:eschool_teacher/cubits/subjectsOfClassSectionCubit.dart';
import 'package:eschool_teacher/data/models/classSectionDetails.dart';
import 'package:eschool_teacher/data/models/lesson.dart';
import 'package:eschool_teacher/data/models/pickedStudyMaterial.dart';
import 'package:eschool_teacher/data/models/studyMaterial.dart';
import 'package:eschool_teacher/data/models/subject.dart';
import 'package:eschool_teacher/data/models/topic.dart';
import 'package:eschool_teacher/data/repositories/lessonRepository.dart';
import 'package:eschool_teacher/data/repositories/teacherRepository.dart';
import 'package:eschool_teacher/data/repositories/topicRepository.dart';
import 'package:eschool_teacher/ui/widgets/addStudyMaterialBottomSheet.dart';
import 'package:eschool_teacher/ui/widgets/addedStudyMaterialFileContainer.dart';
import 'package:eschool_teacher/ui/widgets/bottomSheetTextFiledContainer.dart';
import 'package:eschool_teacher/ui/widgets/bottomsheetAddFilesDottedBorderContainer.dart';
import 'package:eschool_teacher/ui/widgets/classSubjectsDropDownMenu.dart';
import 'package:eschool_teacher/ui/widgets/customAppbar.dart';
import 'package:eschool_teacher/ui/widgets/customCircularProgressIndicator.dart';
import 'package:eschool_teacher/ui/widgets/customDropDownMenu.dart';
import 'package:eschool_teacher/ui/widgets/customRoundedButton.dart';
import 'package:eschool_teacher/ui/widgets/defaultDropDownLabelContainer.dart';
import 'package:eschool_teacher/ui/widgets/myClassesDropDownMenu.dart';
import 'package:eschool_teacher/ui/widgets/studyMaterialContainer.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddOrEditTopicScreen extends StatefulWidget {
  final Lesson? lesson;
  final Subject? subject;
  final Topic? topic;
  final ClassSectionDetails? classSectionDetails;

  AddOrEditTopicScreen(
      {Key? key,
      this.lesson,
      required this.subject,
      this.topic,
      this.classSectionDetails})
      : super(key: key);

  static Route<bool?> route(RouteSettings routeSettings) {
    final arguments = (routeSettings.arguments ?? Map<String, dynamic>.from({}))
        as Map<String, dynamic>;

    return CupertinoPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LessonsCubit(LessonRepository()),
          ),
          BlocProvider(
            create: (context) =>
                SubjectsOfClassSectionCubit(TeacherRepository()),
          ),
          BlocProvider(
            create: (context) => CreateTopicCubit(TopicRepository()),
          ),
          BlocProvider(
            create: (context) => EditTopicCubit(TopicRepository()),
          ),
        ],
        child: AddOrEditTopicScreen(
          classSectionDetails: arguments['classSectionDetails'],
          subject: arguments['subject'],
          lesson: arguments['lesson'],
          topic: arguments['topic'],
        ),
      ),
    );
  }

  @override
  State<AddOrEditTopicScreen> createState() => _AddOrEditTopicScreenState();
}

class _AddOrEditTopicScreenState extends State<AddOrEditTopicScreen> {
  late String currentSelectedClassSection = widget.classSectionDetails != null
      ? widget.classSectionDetails!.getClassSectionName()
      : context.read<MyClassesCubit>().getClassSectionName().first;

  late String currentSelectedSubject = widget.subject != null
      ? widget.subject!.name
      : UiUtils.getTranslatedLabel(context, fetchingSubjectsKey);

  late String currentSelectedLesson = widget.lesson != null
      ? widget.lesson!.name
      : UiUtils.getTranslatedLabel(context, fetchingLessonsKey);

  late TextEditingController _topicNameTextEditingController =
      TextEditingController(
          text: widget.topic != null ? widget.topic!.name : null);
  late TextEditingController _topicDescriptionTextEditingController =
      TextEditingController(
          text: widget.topic != null ? widget.topic!.description : null);

  List<PickedStudyMaterial> _addedStudyMaterials = [];

  late List<StudyMaterial> studyMaterials =
      widget.topic != null ? widget.topic!.studyMaterials : [];

  //This will determine if need to refresh the previous page
  //topics data. If teacher remove the the any study material
  //so we need to fetch the list again
  late bool refreshTopicsInPreviousPage = false;

  @override
  void initState() {
    if (widget.classSectionDetails == null) {
      context.read<SubjectsOfClassSectionCubit>().fetchSubjects(
          context.read<MyClassesCubit>().getAllClasses().first.id);
    }

    super.initState();
  }

  void deleteStudyMaterial(int studyMaterialId) {
    studyMaterials.removeWhere((element) => element.id == studyMaterialId);
    refreshTopicsInPreviousPage = true;
    setState(() {});
  }

  void updateStudyMaterials(StudyMaterial studyMaterial) {
    final studyMaterialIndex =
        studyMaterials.indexWhere((element) => element.id == studyMaterial.id);
    studyMaterials[studyMaterialIndex] = studyMaterial;
    refreshTopicsInPreviousPage = true;
    setState(() {});
  }

  void _addStudyMaterial(PickedStudyMaterial pickedStudyMaterial) {
    setState(() {
      _addedStudyMaterials.add(pickedStudyMaterial);
    });
  }

  void showErrorMessage(String errorMessageKey) {
    UiUtils.showBottomToastOverlay(
        context: context,
        errorMessage: errorMessageKey,
        backgroundColor: Theme.of(context).colorScheme.error);
  }

  void editTopic() {
    if (_topicNameTextEditingController.text.trim().isEmpty) {
      showErrorMessage(
          UiUtils.getTranslatedLabel(context, pleaseEnterTopicNameKey));
      return;
    }

    if (_topicDescriptionTextEditingController.text.trim().isEmpty) {
      showErrorMessage(
          UiUtils.getTranslatedLabel(context, pleaseEnterTopicDescriptionKey));
      return;
    }

    context.read<EditTopicCubit>().editTopic(
        topicDescription: _topicDescriptionTextEditingController.text.trim(),
        topicName: _topicNameTextEditingController.text.trim(),
        lessonId: widget.lesson!.id,
        classSectionId: widget.classSectionDetails!.id,
        subjectId: widget.subject!.id,
        topicId: widget.topic!.id,
        files: _addedStudyMaterials);
  }

  void createTopic() {
    //
    if (_topicNameTextEditingController.text.trim().isEmpty) {
      showErrorMessage(
          UiUtils.getTranslatedLabel(context, pleaseEnterTopicNameKey));
      return;
    }

    if (_topicDescriptionTextEditingController.text.trim().isEmpty) {
      showErrorMessage(
          UiUtils.getTranslatedLabel(context, pleaseEnterTopicDescriptionKey));
      return;
    }
    final selectedSubjectId = widget.subject != null
        ? widget.subject!.id
        : context
            .read<SubjectsOfClassSectionCubit>()
            .getSubjectIdByName(currentSelectedSubject);

    //
    if (selectedSubjectId == -1) {
      showErrorMessage(
          UiUtils.getTranslatedLabel(context, pleasefetchingSubjectsKey));
      return;
    }

    final lessonId = widget.lesson != null
        ? widget.lesson!.id
        : context
            .read<LessonsCubit>()
            .getLessonByName(currentSelectedLesson)
            .id;
    if (lessonId == 0) {
      showErrorMessage(
          UiUtils.getTranslatedLabel(context, pleaseSelectLessonKey));
      return;
    }

    //
    context.read<CreateTopicCubit>().createTopic(
        topicName: _topicNameTextEditingController.text.trim(),
        lessonId: lessonId,
        classSectionId: widget.classSectionDetails != null
            ? widget.classSectionDetails!.id
            : context
                .read<MyClassesCubit>()
                .getClassSectionDetails(
                    classSectionName: currentSelectedClassSection)
                .id,
        subjectId: selectedSubjectId,
        topicDescription: _topicDescriptionTextEditingController.text.trim(),
        files: _addedStudyMaterials);
  }

  Widget _buildClassSubjectAndLessonDropDowns() {
    return LayoutBuilder(builder: (context, boxConstraints) {
      return Column(
        children: [
          widget.classSectionDetails != null
              ? DefaultDropDownLabelContainer(
                  titleLabelKey: currentSelectedClassSection,
                  width: boxConstraints.maxWidth)
              : MyClassesDropDownMenu(
                  currentSelectedItem: currentSelectedClassSection,
                  width: boxConstraints.maxWidth,
                  changeSelectedItem: (value) {
                    currentSelectedClassSection = value;
                    context.read<LessonsCubit>().updateState(LessonsInitial());
                    setState(() {});
                  }),
          widget.subject != null
              ? DefaultDropDownLabelContainer(
                  titleLabelKey: widget.subject!.name,
                  width: boxConstraints.maxWidth)
              : ClassSubjectsDropDownMenu(
                  changeSelectedItem: (result) {
                    setState(() {
                      currentSelectedSubject = result;
                    });
                    final subjectId = context
                        .read<SubjectsOfClassSectionCubit>()
                        .getSubjectIdByName(currentSelectedSubject);
                    if (subjectId != -1) {
                      context.read<LessonsCubit>().fetchLessons(
                          classSectionId: context
                              .read<MyClassesCubit>()
                              .getClassSectionDetails(
                                  classSectionName: currentSelectedClassSection)
                              .id,
                          subjectId: subjectId);
                    }
                  },
                  currentSelectedItem: currentSelectedSubject,
                  width: boxConstraints.maxWidth),
          //

          widget.lesson != null
              ? DefaultDropDownLabelContainer(
                  titleLabelKey: widget.lesson!.name,
                  width: boxConstraints.maxWidth)
              : BlocConsumer<LessonsCubit, LessonsState>(
                  builder: (context, state) {
                  return state is LessonsFetchSuccess
                      ? state.lessons.isEmpty
                          ? DefaultDropDownLabelContainer(
                              titleLabelKey: UiUtils.getTranslatedLabel(
                                  context, noLessonsKey),
                              width: boxConstraints.maxWidth)
                          : CustomDropDownMenu(
                              width: boxConstraints.maxWidth,
                              onChanged: (value) {
                                currentSelectedLesson = value!;
                                setState(() {});
                              },
                              menu: state.lessons.map((e) => e.name).toList(),
                              currentSelectedItem: currentSelectedLesson)
                      : DefaultDropDownLabelContainer(
                          titleLabelKey: fetchingLessonsKey,
                          width: boxConstraints.maxWidth);
                }, listener: (context, state) {
                  if (state is LessonsFetchSuccess) {
                    if (state.lessons.isNotEmpty) {
                      setState(() {
                        currentSelectedLesson = state.lessons.first.name;
                      });
                    }
                  }
                }),
        ],
      );
    });
  }

  Widget _buildAppbar() {
    return Align(
      alignment: Alignment.topCenter,
      child: CustomAppBar(
          onPressBackButton: () {
            if (context.read<CreateTopicCubit>().state
                is CreateTopicInProgress) {
              return;
            }

            if (context.read<EditTopicCubit>().state is EditTopicInProgress) {
              return;
            }
            Navigator.of(context).pop(refreshTopicsInPreviousPage);
          },
          title: UiUtils.getTranslatedLabel(
              context, widget.topic != null ? editTopicKey : addTopicKey)),
    );
  }

  Widget _buildAddOrEditTopicForm() {
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
      child: LayoutBuilder(builder: (context, boxConstraints) {
        return Column(
          children: [
            _buildClassSubjectAndLessonDropDowns(),
            BottomSheetTextFieldContainer(
                hintText: UiUtils.getTranslatedLabel(context, topicNameKey),
                margin: EdgeInsets.only(bottom: 20),
                maxLines: 1,
                contentPadding: EdgeInsetsDirectional.only(start: 15),
                textEditingController: _topicNameTextEditingController),
            BottomSheetTextFieldContainer(
                margin: EdgeInsets.only(bottom: 20),
                hintText:
                    UiUtils.getTranslatedLabel(context, topicDescriptionKey),
                maxLines: 3,
                contentPadding: EdgeInsetsDirectional.only(start: 15),
                textEditingController: _topicDescriptionTextEditingController),
            widget.topic != null
                ? Column(
                    children: studyMaterials
                        .map((studyMaterial) => StudyMaterialContainer(
                            onDeleteStudyMaterial: deleteStudyMaterial,
                            onEditStudyMaterial: updateStudyMaterials,
                            showEditAndDeleteButton: true,
                            studyMaterial: studyMaterial))
                        .toList(),
                  )
                : SizedBox(),
            BottomsheetAddFilesDottedBorderContainer(
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  UiUtils.showBottomSheet(
                      child: AddStudyMaterialBottomsheet(
                          editFileDetails: false,
                          onTapSubmit: _addStudyMaterial),
                      context: context);
                },
                title: UiUtils.getTranslatedLabel(context, studyMaterialsKey)),
            SizedBox(
              height: 20,
            ),
            ...List.generate(_addedStudyMaterials.length, (index) => index)
                .map((index) => AddedStudyMaterialContainer(
                    onDelete: (index) {
                      _addedStudyMaterials.removeAt(index);
                      setState(() {});
                    },
                    onEdit: (index, file) {
                      _addedStudyMaterials[index] = file;
                      setState(() {});
                    },
                    file: _addedStudyMaterials[index],
                    fileIndex: index))
                .toList(),
            widget.topic != null
                ? BlocConsumer<EditTopicCubit, EditTopicState>(
                    listener: (context, state) {
                      if (state is EditTopicSuccess) {
                        Navigator.of(context).pop(true);
                      } else if (state is EditTopicFailure) {
                        UiUtils.showBottomToastOverlay(
                            context: context,
                            errorMessage: UiUtils.getErrorMessageFromErrorCode(
                                context, state.errorMessage),
                            backgroundColor:
                                Theme.of(context).colorScheme.error);
                      }
                    },
                    builder: (context, state) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: boxConstraints.maxWidth * (0.25)),
                        child: CustomRoundedButton(
                            onTap: () {
                              if (state is EditTopicInProgress) {
                                return;
                              }
                              //
                              editTopic();
                            },
                            child: state is EditTopicInProgress
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
                                context, editTopicKey),
                            showBorder: false),
                      );
                    },
                  )
                : BlocConsumer<CreateTopicCubit, CreateTopicState>(
                    listener: (context, state) {
                      if (state is CreateTopicSuccess) {
                        _topicNameTextEditingController.text = "";
                        _topicDescriptionTextEditingController.text = "";
                        _addedStudyMaterials = [];
                        setState(() {});
                        UiUtils.showBottomToastOverlay(
                            context: context,
                            errorMessage: UiUtils.getTranslatedLabel(
                                context,
                                UiUtils.getTranslatedLabel(
                                    context, topicAddedSuccessfullyKey)),
                            backgroundColor:
                                Theme.of(context).colorScheme.onPrimary);
                      } else if (state is CreateTopicFailure) {
                        UiUtils.showBottomToastOverlay(
                            context: context,
                            errorMessage: UiUtils.getErrorMessageFromErrorCode(
                                context, state.errorMessage),
                            backgroundColor:
                                Theme.of(context).colorScheme.error);
                      }
                    },
                    builder: (context, state) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: boxConstraints.maxWidth * (0.25)),
                        child: CustomRoundedButton(
                            onTap: () {
                              if (state is CreateTopicInProgress) {
                                return;
                              }
                              createTopic();
                            },
                            child: state is CreateTopicInProgress
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
                                context, addTopicKey),
                            showBorder: false),
                      );
                    },
                  )
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (context.read<CreateTopicCubit>().state is CreateTopicInProgress) {
          return Future.value(false);
        }

        if (context.read<EditTopicCubit>().state is EditTopicInProgress) {
          return Future.value(false);
        }
        Navigator.of(context).pop(refreshTopicsInPreviousPage);
        return Future.value(false);
      },
      child: Scaffold(
          body: Stack(
        children: [
          _buildAddOrEditTopicForm(),
          _buildAppbar(),
        ],
      )),
    );
  }
}
