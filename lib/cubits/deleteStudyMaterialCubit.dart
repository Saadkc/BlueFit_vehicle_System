import 'package:eschool_teacher/data/repositories/studyMaterialRepositoy.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DeleteStudyMaterialState {}

class DeleteStudyMaterialInitial extends DeleteStudyMaterialState {}

class DeleteStudyMaterialInProgress extends DeleteStudyMaterialState {}

class DeleteStudyMaterialSuccess extends DeleteStudyMaterialState {}

class DeleteStudyMaterialFailure extends DeleteStudyMaterialState {
  final String errorMessage;

  DeleteStudyMaterialFailure(this.errorMessage);
}

class DeleteStudyMaterialCubit extends Cubit<DeleteStudyMaterialState> {
  final StudyMaterialRepository _studyMaterialRepository;

  DeleteStudyMaterialCubit(this._studyMaterialRepository)
      : super(DeleteStudyMaterialInitial());

  void deleteStudyMaterial({required int fileId}) async {
    emit(DeleteStudyMaterialInProgress());
    try {
      await _studyMaterialRepository.deleteStudyMaterial(fileId: fileId);
      emit(DeleteStudyMaterialSuccess());
    } catch (e) {
      emit(DeleteStudyMaterialFailure(e.toString()));
    }
  }
}
