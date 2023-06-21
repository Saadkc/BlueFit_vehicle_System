import 'package:eschool/cubits/authCubit.dart';
import 'package:eschool/cubits/subjectAnnouncementsCubit.dart';
import 'package:eschool/data/models/announcement.dart';
import 'package:eschool/ui/widgets/announcementDetailsContainer.dart';
import 'package:eschool/ui/widgets/errorContainer.dart';
import 'package:eschool/ui/widgets/noDataContainer.dart';
import 'package:eschool/ui/widgets/shimmerLoaders/announcementShimmerLoadingContainer.dart';

import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnnouncementContainer extends StatefulWidget {
  final int subjectId;
  final int? childId;
  AnnouncementContainer({Key? key, required this.subjectId, this.childId})
      : super(key: key);

  @override
  State<AnnouncementContainer> createState() => _AnnouncementContainerState();
}

class _AnnouncementContainerState extends State<AnnouncementContainer> {
  Widget _buildAnnouncementDetailsContainer(
      {required Announcement subjectAnnouncement,
      required int index,
      required int totalAnnouncements,
      required bool hasMoreAnnouncements,
      required bool hasMoreAnnouncementsInProgress,
      required bool fetchMoreAnnouncementsFailure}) {
    //show announcement loading container for last announcement container
    if (index == (totalAnnouncements - 1)) {
      //If has more assignment
      if (hasMoreAnnouncements) {
        if (hasMoreAnnouncementsInProgress) {
          return AnnouncementShimmerLoadingContainer();
        }
        if (fetchMoreAnnouncementsFailure) {
          return Center(
            child: CupertinoButton(
                child: Text(UiUtils.getTranslatedLabel(context, retryKey)),
                onPressed: () {
                  context
                      .read<SubjectAnnouncementCubit>()
                      .fetchMoreAnnouncements(
                        useParentApi: context.read<AuthCubit>().isParent(),
                        subjectId: widget.subjectId,
                        childId: widget.childId,
                      );
                }),
          );
        }
      }
    }

    return AnnouncementDetailsContainer(announcement: subjectAnnouncement);
  }

  //
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubjectAnnouncementCubit, SubjectAnnouncementState>(
      builder: (context, state) {
        if (state is SubjectAnnouncementFetchSuccess) {
          return state.announcements.isEmpty
              ? NoDataContainer(titleKey: noAnnouncementKey)
              : Column(
                  children: List.generate(
                          state.announcements.length, (index) => index)
                      .map((index) => _buildAnnouncementDetailsContainer(
                          subjectAnnouncement: state.announcements[index],
                          index: index,
                          totalAnnouncements: state.announcements.length,
                          hasMoreAnnouncements: context
                              .read<SubjectAnnouncementCubit>()
                              .hasMore(),
                          hasMoreAnnouncementsInProgress:
                              state.fetchMoreAnnouncementsInProgress,
                          fetchMoreAnnouncementsFailure:
                              state.moreAnnouncementsFetchError))
                      .toList(),
                );
        }

        if (state is SubjectAnnouncementFetchFailure) {
          return ErrorContainer(
            errorMessageCode:
                UiUtils.getTranslatedLabel(context, state.errorMessage),
            onTapRetry: () {
              context.read<SubjectAnnouncementCubit>().fetchSubjectAnnouncement(
                  subjectId: widget.subjectId,
                  useParentApi: context.read<AuthCubit>().isParent(),
                  childId: widget.childId);
            },
          );
        }

        return Column(
          children: List.generate(
                  UiUtils.defaultShimmerLoadingContentCount, (index) => index)
              .map((e) => AnnouncementShimmerLoadingContainer())
              .toList(),
        );
      },
    );
  }
}

/*
To add profile pic and teacher name top of announcement container
Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(10)),
                ),
                SizedBox(
                  width: boxConstraints.maxWidth * (0.075),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Albert C. Verdin",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0),
                      ),
                      SizedBox(
                        height: 2.5,
                      ),
                      Text("21, March, 2022",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontWeight: FontWeight.w400,
                              fontSize: 10.0),
                          textAlign: TextAlign.start)
                    ],
                  ),
                ),
              ],
            ),
            */
