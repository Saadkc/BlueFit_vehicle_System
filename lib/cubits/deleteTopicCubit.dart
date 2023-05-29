import 'package:eschool_teacher/data/repositories/topicRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DeleteTopicState {}

class DeleteTopicInitial extends DeleteTopicState {}

class DeleteTopicInProgress extends DeleteTopicState {}

class DeleteTopicSuccess extends DeleteTopicState {}

class DeleteTopicFailure extends DeleteTopicState {
  final String errorMessage;

  DeleteTopicFailure(this.errorMessage);
}

class DeleteTopicCubit extends Cubit<DeleteTopicState> {
  final TopicRepository _topicRepository;

  DeleteTopicCubit(this._topicRepository) : super(DeleteTopicInitial());

  void deleteTopic({required int topicId}) async {
    emit(DeleteTopicInProgress());
    try {
      await _topicRepository.deleteTopic(topicId: topicId);
      emit(DeleteTopicSuccess());
    } catch (e) {
      emit(DeleteTopicFailure(e.toString()));
    }
  }
}
