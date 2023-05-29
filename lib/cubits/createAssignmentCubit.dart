import 'package:eschool_teacher/data/repositories/assignmentRepository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class createAssignmentState {}

class createAssignmentInitial extends createAssignmentState {}

class createAssignmentInProcess extends createAssignmentState {}

class createAssignmentSuccess extends createAssignmentState {}

class createAssignmentFailure extends createAssignmentState {
  final String errormessage;
  createAssignmentFailure({
    required this.errormessage,
  });
}

class CreateAssignmentCubit extends Cubit<createAssignmentState> {
  final AssignmentRepository _assignmentRepository;

  CreateAssignmentCubit(this._assignmentRepository)
      : super(createAssignmentInitial());

  void createAssignment({
    required int classsId,
    required int subjectId,
    required String name,
    required String instruction,
    required String datetime,
    required String points,
    required bool resubmission,
    required String extraDayForResubmission,
    List<PlatformFile>? file,
  }) async {
    print("bodypoints $points");
    emit(createAssignmentInProcess());
    try {
      await _assignmentRepository
          .createAssignment(
            classsId: classsId,
            subjectId: subjectId,
            name: name,
            datetime: datetime,
            resubmission: resubmission,
            extraDayForResubmission: int.parse(extraDayForResubmission.isEmpty
                ? "0"
                : extraDayForResubmission),
            filePaths: file,
            instruction: instruction,
            points: int.parse(points.isEmpty ? "0" : points),
          )
          .then((value) => emit(createAssignmentSuccess()));
    } catch (e) {
      print(e.toString());
      emit(createAssignmentFailure(errormessage: e.toString()));
    }
  }
}
