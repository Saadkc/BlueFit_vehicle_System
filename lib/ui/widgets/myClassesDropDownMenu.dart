import 'package:eschool_teacher/cubits/myClassesCubit.dart';
import 'package:eschool_teacher/cubits/subjectsOfClassSectionCubit.dart';
import 'package:eschool_teacher/ui/widgets/customDropDownMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyClassesDropDownMenu extends StatelessWidget {
  final String currentSelectedItem;
  final Function(String) changeSelectedItem;
  final double width;

  const MyClassesDropDownMenu(
      {Key? key,
      required this.currentSelectedItem,
      required this.width,
      required this.changeSelectedItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDropDownMenu(
        width: width,
        onChanged: (result) {
          //
          changeSelectedItem(result!);

          //
          context.read<SubjectsOfClassSectionCubit>().fetchSubjects(context
              .read<MyClassesCubit>()
              .getClassSectionDetails(classSectionName: result)
              .id);
        },
        menu: context.read<MyClassesCubit>().getClassSectionName(),
        currentSelectedItem: currentSelectedItem);
  }
}
