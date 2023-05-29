import 'package:eschool_teacher/data/models/subject.dart';
import 'package:eschool_teacher/data/repositories/teacherRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SubjectsOfClassSectionState {}

class SubjectsOfClassSectionInitial extends SubjectsOfClassSectionState {}

class SubjectsOfClassSectionFetchInProgress
    extends SubjectsOfClassSectionState {}

class SubjectsOfClassSectionFetchSuccess extends SubjectsOfClassSectionState {
  List<Subject> subjects;

  SubjectsOfClassSectionFetchSuccess(this.subjects);
}

class SubjectsOfClassSectionFetchFailure extends SubjectsOfClassSectionState {
  final String errorMessage;

  SubjectsOfClassSectionFetchFailure(this.errorMessage);
}

class SubjectsOfClassSectionCubit extends Cubit<SubjectsOfClassSectionState> {
  final TeacherRepository _teacherRepository;

  SubjectsOfClassSectionCubit(this._teacherRepository)
      : super(SubjectsOfClassSectionInitial());

  void fetchSubjects(int classSectionId) async {
    emit(SubjectsOfClassSectionFetchInProgress());
    try {
      emit(SubjectsOfClassSectionFetchSuccess(
          await _teacherRepository.subjectsByClassSection(classSectionId)));
    } catch (e) {
      emit(SubjectsOfClassSectionFetchFailure(e.toString()));
    }
  }

  int getSubjectIdByName(String name) {
    if (state is SubjectsOfClassSectionFetchSuccess) {
      return (state as SubjectsOfClassSectionFetchSuccess)
          .subjects
          .where((element) => element.name == name)
          .first
          .id;
    }
    return -1;
  }

  Subject getSubjectDetailsByName(String name) {
    if (state is SubjectsOfClassSectionFetchSuccess) {
      return (state as SubjectsOfClassSectionFetchSuccess)
          .subjects
          .where((element) => element.name == name)
          .first;
    }
    return Subject.fromJson({});
  }

  Subject getSubjectDetailsById(int subjectId) {
    return (state as SubjectsOfClassSectionFetchSuccess)
        .subjects
        .where((element) => element.id == subjectId)
        .first;
  }
}
