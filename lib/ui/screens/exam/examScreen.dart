import 'package:eschool_teacher/cubits/examCubit.dart';
import 'package:eschool_teacher/data/repositories/studentRepository.dart';
import 'package:eschool_teacher/ui/widgets/customAppbar.dart';
import 'package:eschool_teacher/ui/widgets/examListContainer.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExamScreen extends StatelessWidget {
  const ExamScreen({
    Key? key,
  }) : super(key: key);

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
        builder: (_) => BlocProvider<ExamDetailsCubit>(
              create: (context) => ExamDetailsCubit(StudentRepository()),
              child: ExamScreen(),
            ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ExamListContainer(),
          Align(
            alignment: Alignment.topCenter,
            child: CustomAppBar(
              title: UiUtils.getTranslatedLabel(context, examsKey),
              showBackButton: true,
              onPressBackButton: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
