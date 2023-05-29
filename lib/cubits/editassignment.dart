import 'package:eschool_teacher/data/repositories/assignmentRepository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class EditAssignmentState {}

class editAssignmentInitial extends EditAssignmentState {}

class editAssignmentInProgress extends EditAssignmentState {}

class editAssignmentSuccess extends EditAssignmentState {}

class editAssignmentFailure extends EditAssignmentState {
  final String errorMessage;

  editAssignmentFailure(this.errorMessage);
}

class editAssignmentCubit extends Cubit<EditAssignmentState> {
  final AssignmentRepository _assignmentRepository;

  editAssignmentCubit(this._assignmentRepository)
      : super(editAssignmentInitial());

  void editAssignment({
    required int assignmentId,
    required int classSelectionId,
    required int subjectId,
    required String name,
    required String dateTime,
    required String instruction,
    required String points,
    required int resubmission,
    required String extraDayForResubmission,
    required List<PlatformFile> filePaths,
  }) async {
    emit(editAssignmentInProgress());
    try {
      await _assignmentRepository.editassignment(
        assignmentId: assignmentId,
        classSelectionId: classSelectionId,
        dateTime: dateTime,
        name: name,
        subjectId: subjectId,
        extraDayForResubmission: int.parse(
            extraDayForResubmission.isEmpty ? "0" : extraDayForResubmission),
        instruction: instruction,
        points: int.parse(points.isEmpty ? "0" : points),
        resubmission: resubmission,
        filePaths: filePaths,
      );
      emit(editAssignmentSuccess());
    } catch (e) {
      print(e.toString());
      emit(editAssignmentFailure(e.toString()));
    }
  }
}
