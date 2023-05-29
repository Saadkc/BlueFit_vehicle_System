import 'package:eschool_teacher/data/models/pickedStudyMaterial.dart';
import 'package:eschool_teacher/data/repositories/topicRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CreateTopicState {}

class CreateTopicInitial extends CreateTopicState {}

class CreateTopicInProgress extends CreateTopicState {}

class CreateTopicSuccess extends CreateTopicState {}

class CreateTopicFailure extends CreateTopicState {
  final String errorMessage;

  CreateTopicFailure(this.errorMessage);
}

class CreateTopicCubit extends Cubit<CreateTopicState> {
  final TopicRepository _topicRepository;

  CreateTopicCubit(this._topicRepository) : super(CreateTopicInitial());

  void createTopic(
      {required String topicName,
      required int lessonId,
      required int classSectionId,
      required int subjectId,
      required String topicDescription,
      required List<PickedStudyMaterial> files}) async {
    emit(CreateTopicInProgress());
    try {
      List<Map<String, dynamic>> filesJosn = [];
      for (var file in files) {
        filesJosn.add(await file.toJson());
      }
      await _topicRepository.createTopic(
          topicName: topicName,
          classSectionId: classSectionId,
          subjectId: subjectId,
          topicDescription: topicDescription,
          lessonId: lessonId,
          files: filesJosn);
      emit(CreateTopicSuccess());
    } catch (e) {
      emit(CreateTopicFailure(e.toString()));
    }
  }
}
