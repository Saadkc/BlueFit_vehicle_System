import 'package:eschool_teacher/cubits/studentMoreDetailsCubit.dart';
import 'package:eschool_teacher/data/models/student.dart';
import 'package:eschool_teacher/data/repositories/studentRepository.dart';
import 'package:eschool_teacher/ui/screens/studentDetails/widgets/studentDetailsContainer.dart';

import 'package:eschool_teacher/ui/widgets/customAppbar.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentDetailsScreen extends StatefulWidget {
  final Student student;
  StudentDetailsScreen({Key? key, required this.student}) : super(key: key);

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();

  static Route<StudentDetailsScreen> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
        builder: (_) => BlocProvider(
              create: (context) => StudentMoreDetailsCubit(StudentRepository()),
              child: StudentDetailsScreen(
                student: routeSettings.arguments as Student,
              ),
            ));
  }
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context
          .read<StudentMoreDetailsCubit>()
          .fetchStudentMoreDetails(studentId: widget.student.id);
    });
  }

  Widget _buildAppBar() {
    return Align(
      alignment: Alignment.topCenter,
      child: CustomAppBar(
          title: UiUtils.getTranslatedLabel(context, studentDetailsKey)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StudentDetailsContainer(
            student: widget.student,
          ),
          _buildAppBar(),
        ],
      ),
    );
  }
}
