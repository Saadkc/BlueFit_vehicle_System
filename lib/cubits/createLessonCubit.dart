import 'package:eschool_teacher/data/models/pickedStudyMaterial.dart';
import 'package:eschool_teacher/data/repositories/lessonRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CreateLessonState {}

class CreateLessonInitial extends CreateLessonState {}

class CreateLessonInProgress extends CreateLessonState {}

class CreateLessonSuccess extends CreateLessonState {}

class CreateLessonFailure extends CreateLessonState {
  final String errorMessage;

  CreateLessonFailure(this.errorMessage);
}

class CreateLessonCubit extends Cubit<CreateLessonState> {
  final LessonRepository _lessonRepository;

  CreateLessonCubit(this._lessonRepository) : super(CreateLessonInitial());

  void createLesson(
      {required String lessonName,
      required int classSectionId,
      required int subjectId,
      required String lessonDescription,
      required List<PickedStudyMaterial> files}) async {
    emit(CreateLessonInProgress());
    try {
      List<Map<String, dynamic>> filesJosn = [];
      for (var file in files) {
        filesJosn.add(await file.toJson());
      }

      await _lessonRepository.createLesson(
          lessonName: lessonName,
          classSectionId: classSectionId,
          subjectId: subjectId,
          lessonDescription: lessonDescription,
          files: filesJosn);
      emit(CreateLessonSuccess());
    } catch (e) {
      print(e.toString());
      emit(CreateLessonFailure(e.toString()));
    }
  }
}
