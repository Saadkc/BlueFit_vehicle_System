import 'package:eschool_teacher/app/routes.dart';
import 'package:eschool_teacher/cubits/topicsCubit.dart';
import 'package:eschool_teacher/data/models/classSectionDetails.dart';
import 'package:eschool_teacher/data/models/lesson.dart';
import 'package:eschool_teacher/data/models/subject.dart';
import 'package:eschool_teacher/data/repositories/topicRepository.dart';
import 'package:eschool_teacher/ui/widgets/customAppbar.dart';
import 'package:eschool_teacher/ui/widgets/customFloatingActionButton.dart';
import 'package:eschool_teacher/ui/widgets/customRefreshIndicator.dart';
import 'package:eschool_teacher/ui/widgets/topicsContainer.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopcisByLessonScreen extends StatefulWidget {
  final Lesson lesson;
  final Subject subject;
  final ClassSectionDetails classSectionDetails;

  TopcisByLessonScreen(
      {Key? key,
      required this.lesson,
      required this.classSectionDetails,
      required this.subject})
      : super(key: key);

  @override
  State<TopcisByLessonScreen> createState() => _TopcisByLessonScreenState();

  static Route<dynamic> route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
        builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<TopicsCubit>(
                    create: (_) => TopicsCubit(TopicRepository()))
              ],
              child: TopcisByLessonScreen(
                classSectionDetails: arguments['classSectionDetails'],
                lesson: arguments['lesson'],
                subject: arguments['subject'],
              ),
            ));
  }
}

class _TopcisByLessonScreenState extends State<TopcisByLessonScreen> {
  @override
  void initState() {
    fetchTopics();
    super.initState();
  }

  void fetchTopics() {
    Future.delayed(Duration.zero, () {
      context.read<TopicsCubit>().fetchTopics(lessonId: widget.lesson.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionAddButton(onTap: () {
        Navigator.of(context)
            .pushNamed<bool?>(Routes.addOrEditTopic, arguments: {
          "classSectionDetails": widget.classSectionDetails,
          "subject": widget.subject,
          "lesson": widget.lesson
        }).then((value) {
          if (value != null && value) {
            fetchTopics();
          }
        });
      }),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: CustomRefreshIndicator(
              onRefreshCallback: () {
                fetchTopics();
              },
              displacment: UiUtils.getScrollViewTopPadding(
                  context: context,
                  appBarHeightPercentage:
                      UiUtils.appBarSmallerHeightPercentage),
              child: ListView(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width *
                        UiUtils.screenContentHorizontalPaddingPercentage,
                    right: MediaQuery.of(context).size.width *
                        UiUtils.screenContentHorizontalPaddingPercentage,
                    top: UiUtils.getScrollViewTopPadding(
                        context: context,
                        appBarHeightPercentage:
                            UiUtils.appBarSmallerHeightPercentage)),
                children: [
                  TopicsContainer(
                      classSectionDetails: widget.classSectionDetails,
                      lesson: widget.lesson,
                      subject: widget.subject)
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: CustomAppBar(
              title: UiUtils.getTranslatedLabel(context, topicsKey),
              subTitle: widget.lesson.name,
            ),
          ),
        ],
      ),
    );
  }
}
