import 'package:eschool_teacher/data/models/announcement.dart';
import 'package:eschool_teacher/data/repositories/announcementRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AnnouncementsState {}

class AnnouncementsInitial extends AnnouncementsState {}

class AnnouncementsFetchInProgress extends AnnouncementsState {}

class AnnouncementsFetchSuccess extends AnnouncementsState {
  final List<Announcement> announcements;
  final int totalPage;
  final int currentPage;
  final bool moreAnnouncementsFetchError;
  final bool fetchMoreAnnouncementsInProgress;

  AnnouncementsFetchSuccess(
      {required this.announcements,
      required this.fetchMoreAnnouncementsInProgress,
      required this.moreAnnouncementsFetchError,
      required this.currentPage,
      required this.totalPage});

  AnnouncementsFetchSuccess copyWith(
      {List<Announcement>? newAnnouncements,
      bool? newFetchMoreAnnouncementsInProgress,
      bool? newMoreAnnouncementsFetchError,
      int? newCurrentPage,
      int? newTotalPage}) {
    return AnnouncementsFetchSuccess(
        announcements: newAnnouncements ?? announcements,
        fetchMoreAnnouncementsInProgress: newFetchMoreAnnouncementsInProgress ??
            fetchMoreAnnouncementsInProgress,
        moreAnnouncementsFetchError:
            newMoreAnnouncementsFetchError ?? moreAnnouncementsFetchError,
        currentPage: newCurrentPage ?? currentPage,
        totalPage: newTotalPage ?? totalPage);
  }
}

class AnnouncementsFetchFailure extends AnnouncementsState {
  final String errorMessage;

  AnnouncementsFetchFailure({required this.errorMessage});
}

class AnnouncementsCubit extends Cubit<AnnouncementsState> {
  final AnnouncementRepository _announcementRepository;

  AnnouncementsCubit(this._announcementRepository)
      : super(AnnouncementsInitial());

  void deleteAnnouncement(int announcementId) {
    if (state is AnnouncementsFetchSuccess) {
      List<Announcement> announcements =
          (state as AnnouncementsFetchSuccess).announcements;
      announcements.removeWhere((element) => element.id == announcementId);
      emit((state as AnnouncementsFetchSuccess)
          .copyWith(newAnnouncements: announcements));
    }
  }

  void fetchAnnouncements(
      {required int classSectionId, required int subjectId}) async {
    try {
      emit(AnnouncementsFetchInProgress());
      final result = await _announcementRepository.fetchAnnouncements(
        classSectionId: classSectionId,
        subjectId: subjectId,
      );
      emit(AnnouncementsFetchSuccess(
          announcements: result['announcements'],
          fetchMoreAnnouncementsInProgress: false,
          moreAnnouncementsFetchError: false,
          currentPage: result['currentPage'],
          totalPage: result['totalPage']));
    } catch (e) {
      emit(AnnouncementsFetchFailure(errorMessage: e.toString()));
    }
  }

  void updateState(AnnouncementsState updateState) {
    emit(updateState);
  }

  bool hasMore() {
    if (state is AnnouncementsFetchSuccess) {
      return (state as AnnouncementsFetchSuccess).currentPage <
          (state as AnnouncementsFetchSuccess).totalPage;
    }
    return false;
  }

  void fetchMoreAnnouncements(
      {required int classSectionId, required int subjectId}) async {
    if (state is AnnouncementsFetchSuccess) {
      if ((state as AnnouncementsFetchSuccess)
          .fetchMoreAnnouncementsInProgress) {
        return;
      }
      try {
        emit((state as AnnouncementsFetchSuccess)
            .copyWith(newFetchMoreAnnouncementsInProgress: true));
        //fetch more announcements
        //more announcements result
        final moreAssignmentsResult =
            await _announcementRepository.fetchAnnouncements(
          subjectId: subjectId,
          classSectionId: classSectionId,
          page: (state as AnnouncementsFetchSuccess).currentPage + 1,
        );

        final currentState = (state as AnnouncementsFetchSuccess);
        List<Announcement> announcements = currentState.announcements;

        //add more announcements into original announcements list
        announcements.addAll(moreAssignmentsResult['announcements']);

        emit(AnnouncementsFetchSuccess(
            fetchMoreAnnouncementsInProgress: false,
            announcements: announcements,
            moreAnnouncementsFetchError: false,
            currentPage: moreAssignmentsResult['currentPage'],
            totalPage: moreAssignmentsResult['totalPage']));
      } catch (e) {
        emit((state as AnnouncementsFetchSuccess).copyWith(
            newFetchMoreAnnouncementsInProgress: false,
            newMoreAnnouncementsFetchError: true));
      }
    }
  }
}
