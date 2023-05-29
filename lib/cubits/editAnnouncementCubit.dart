import 'package:eschool_teacher/data/repositories/announcementRepository.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class EditAnnouncementState {}

class EditAnnouncementInitial extends EditAnnouncementState {}

class EditAnnouncementInProgress extends EditAnnouncementState {}

class EditAnnouncementSuccess extends EditAnnouncementState {}

class EditAnnouncementFailure extends EditAnnouncementState {
  final String errorMessage;

  EditAnnouncementFailure(this.errorMessage);
}

class EditAnnouncementCubit extends Cubit<EditAnnouncementState> {
  final AnnouncementRepository _announcementRepository;

  EditAnnouncementCubit(this._announcementRepository)
      : super(EditAnnouncementInitial());

  void editAnnouncement(
      {required String title,
      required String description,
      required List<PlatformFile> attachments,
      required int classSectionId,
      required int subjectId,
      required int announcementId}) async {
    emit(EditAnnouncementInProgress());
    try {
      await _announcementRepository.updateAnnouncement(
          title: title,
          description: description,
          attachments: attachments,
          classSectionId: classSectionId,
          subjectId: subjectId,
          announcementId: announcementId);
      emit(EditAnnouncementSuccess());
    } catch (e) {
      emit(EditAnnouncementFailure(e.toString()));
    }
  }
}
