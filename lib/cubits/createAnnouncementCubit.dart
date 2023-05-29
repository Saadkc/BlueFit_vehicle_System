import 'package:eschool_teacher/data/repositories/announcementRepository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CreateAnnouncementState {}

class CreateAnnouncementInitial extends CreateAnnouncementState {}

class CreateAnnouncementInProgress extends CreateAnnouncementState {}

class CreateAnnouncementSuccess extends CreateAnnouncementState {}

class CreateAnnouncementFailure extends CreateAnnouncementState {
  final String errorMessage;

  CreateAnnouncementFailure(this.errorMessage);
}

class CreateAnnouncementCubit extends Cubit<CreateAnnouncementState> {
  final AnnouncementRepository _announcementRepository;

  CreateAnnouncementCubit(this._announcementRepository)
      : super(CreateAnnouncementInitial());

  void createAnnouncement(
      {required String title,
      required String description,
      required List<PlatformFile> attachments,
      required int classSectionId,
      required int subjectId}) async {
    emit(CreateAnnouncementInProgress());
    try {
      await _announcementRepository.createAnnouncement(
          title: title,
          description: description,
          attachments: attachments,
          classSectionId: classSectionId,
          subjectId: subjectId);
      emit(CreateAnnouncementSuccess());
    } catch (e) {
      emit(CreateAnnouncementFailure(e.toString()));
    }
  }
}
