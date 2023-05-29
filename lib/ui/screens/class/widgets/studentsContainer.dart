import 'package:eschool_teacher/cubits/studentsByClassSectionCubit.dart';
import 'package:eschool_teacher/data/models/classSectionDetails.dart';

import 'package:eschool_teacher/ui/widgets/customShimmerContainer.dart';
import 'package:eschool_teacher/ui/widgets/errorContainer.dart';
import 'package:eschool_teacher/ui/widgets/shimmerLoadingContainer.dart';
import 'package:eschool_teacher/ui/widgets/studentTileContainer.dart';

import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentsContainer extends StatelessWidget {
  final ClassSectionDetails classSectionDetails;

  const StudentsContainer({Key? key, required this.classSectionDetails})
      : super(key: key);

  Widget _buildStudentShimmerLoadContainer() {
    return LayoutBuilder(builder: (context, boxConstraints) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            ShimmerLoadingContainer(
                child: CustomShimmerContainer(
              height: 50,
              width: boxConstraints.maxWidth * (0.2),
              borderRadius: 10,
            )),
            SizedBox(
              width: boxConstraints.maxWidth * (0.05),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoadingContainer(
                    child: CustomShimmerContainer(
                  width: boxConstraints.maxWidth * (0.5),
                  borderRadius: 10,
                )),
                SizedBox(
                  height: 10,
                ),
                ShimmerLoadingContainer(
                    child: CustomShimmerContainer(
                  width: boxConstraints.maxWidth * (0.35),
                  borderRadius: 10,
                )),
              ],
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentsByClassSectionCubit,
        StudentsByClassSectionState>(
      builder: (context, state) {
        if (state is StudentsByClassSectionFetchSuccess) {
          return Column(
            children: state.students
                .map((student) => StudentTileContainer(student: student))
                .toList(),
          );
        }
        if (state is StudentsByClassSectionFetchFailure) {
          return ErrorContainer(
            errorMessageCode: UiUtils.getErrorMessageFromErrorCode(
                context, state.errorMessage),
            onTapRetry: () {
              context
                  .read<StudentsByClassSectionCubit>()
                  .fetchStudents(classSectionId: classSectionDetails.id);
            },
          );
        }

        return Column(
          children: List.generate(UiUtils.defaultShimmerLoadingContentCount,
              (index) => _buildStudentShimmerLoadContainer()).toList(),
        );
      },
    );
  }
}
