import 'package:eschool_teacher/app/routes.dart';
import 'package:eschool_teacher/cubits/announcementsCubit.dart';
import 'package:eschool_teacher/cubits/deleteAnnouncementCubit.dart';
import 'package:eschool_teacher/data/models/announcement.dart';
import 'package:eschool_teacher/data/models/classSectionDetails.dart';
import 'package:eschool_teacher/data/models/subject.dart';
import 'package:eschool_teacher/data/repositories/announcementRepository.dart';
import 'package:eschool_teacher/ui/styles/colors.dart';
import 'package:eschool_teacher/ui/widgets/attachmentsBottomsheetContainer.dart';
import 'package:eschool_teacher/ui/widgets/confirmDeleteDialog.dart';
import 'package:eschool_teacher/ui/widgets/customShimmerContainer.dart';
import 'package:eschool_teacher/ui/widgets/deleteButton.dart';
import 'package:eschool_teacher/ui/widgets/editButton.dart';
import 'package:eschool_teacher/ui/widgets/errorContainer.dart';
import 'package:eschool_teacher/ui/widgets/noDataContainer.dart';
import 'package:eschool_teacher/ui/widgets/shimmerLoadingContainer.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:timeago/timeago.dart' as timeago;

class AnnouncementsContainer extends StatelessWidget {
  final Subject subject;
  final ClassSectionDetails classSectionDetails;

  AnnouncementsContainer(
      {Key? key, required this.classSectionDetails, required this.subject})
      : super(key: key);

  Widget _buildAnnouncementShimmerLoading(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 25.0),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12.5),
      width: MediaQuery.of(context).size.width * (0.8),
      child: LayoutBuilder(builder: (context, boxConstraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerLoadingContainer(
                child: CustomShimmerContainer(
              borderRadius: 4.0,
              width: boxConstraints.maxWidth * (0.65),
            )),
            SizedBox(
              height: 10,
            ),
            ShimmerLoadingContainer(
                child: CustomShimmerContainer(
              borderRadius: 3.0,
              width: boxConstraints.maxWidth * (0.5),
            )),
            SizedBox(
              height: 20,
            ),
            ShimmerLoadingContainer(
                child: CustomShimmerContainer(
              borderRadius: 3.0,
              height: UiUtils.shimmerLoadingContainerDefaultHeight - 2,
              width: boxConstraints.maxWidth * (0.3),
            )),
          ],
        );
      }),
    );
  }

  Widget _buildAnnouncementContainer(
      {required Announcement announcement,
      required BuildContext context,
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
          return _buildAnnouncementShimmerLoading(context);
        }
        if (fetchMoreAnnouncementsFailure) {
          return Center(
            child: CupertinoButton(
                child: Text(UiUtils.getTranslatedLabel(context, retryKey)),
                onPressed: () {
                  context.read<AnnouncementsCubit>().fetchMoreAnnouncements(
                      classSectionId: classSectionDetails.id,
                      subjectId: subject.id);
                }),
          );
        }
      }
    }

    return BlocProvider(
      create: (context) => DeleteAnnouncementCubit(AnnouncementRepository()),
      child: Builder(builder: (context) {
        return BlocConsumer<DeleteAnnouncementCubit, DeleteAnnouncementState>(
          listener: (context, state) {
            if (state is DeleteAnnouncementSuccess) {
              context
                  .read<AnnouncementsCubit>()
                  .deleteAnnouncement(announcement.id);
            } else if (state is DeleteAnnouncementFailure) {
              UiUtils.showBottomToastOverlay(
                  context: context,
                  errorMessage:
                      UiUtils.getTranslatedLabel(context, unableToDeleteKey),
                  backgroundColor: Theme.of(context).colorScheme.error);
            }
          },
          builder: (context, state) {
            return Opacity(
              opacity: state is DeleteAnnouncementInProgress ? 0.5 : 1.0,
              child: Container(
                margin: EdgeInsets.only(bottom: 20),
                child: LayoutBuilder(builder: (context, boxConstraints) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: boxConstraints.maxWidth * (0.75),
                            child: Text(
                              announcement.title,
                              style: TextStyle(
                                height: 1.1,
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                          Spacer(),
                          EditButton(onTap: () {
                            if (state is DeleteAnnouncementInProgress) {
                              return;
                            }
                            Navigator.of(context).pushNamed<bool?>(
                                Routes.addOrEditAnnouncement,
                                arguments: {
                                  "subject": subject,
                                  "classSectionDetails": classSectionDetails,
                                  "announcement": announcement
                                }).then((value) {
                              if (value != null && value) {
                                context
                                    .read<AnnouncementsCubit>()
                                    .fetchAnnouncements(
                                        classSectionId: classSectionDetails.id,
                                        subjectId: subject.id);
                              }
                            });
                          }),
                          SizedBox(
                            width: 10,
                          ),
                          DeleteButton(onTap: () {
                            if (state is DeleteAnnouncementInProgress) {
                              return;
                            }
                            showDialog<bool>(
                                    context: context,
                                    builder: (_) => ConfirmDeleteDialog())
                                .then((value) {
                              if (value != null && value) {
                                context
                                    .read<DeleteAnnouncementCubit>()
                                    .deleteAnnouncement(announcement.id);
                              }
                            });
                          })
                        ],
                      ),
                      announcement.description.isEmpty
                          ? SizedBox()
                          : Text(
                              announcement.description,
                              style: TextStyle(
                                height: 1.2,
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.w400,
                                fontSize: 11.5,
                              ),
                            ),
                      announcement.files.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: GestureDetector(
                                onTap: () {
                                  UiUtils.showBottomSheet(
                                      child: AttachmentBottomsheetContainer(
                                        fromAnnouncementsContainer: true,
                                        studyMaterials: announcement.files,
                                      ),
                                      context: context);
                                },
                                child: Text(
                                  "${announcement.files.length} ${UiUtils.getTranslatedLabel(context, attachmentsKey)}",
                                  style: TextStyle(
                                      color: assignmentViewButtonColor),
                                ),
                              ),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: announcement.files.isNotEmpty ? 0 : 5,
                      ),
                      Text(timeago.format(announcement.createdAt),
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground
                                  .withOpacity(0.75),
                              fontWeight: FontWeight.w400,
                              fontSize: 10),
                          textAlign: TextAlign.start)
                    ],
                  );
                }),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(10.0)),
                width: MediaQuery.of(context).size.width * (0.85),
              ),
            );
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnnouncementsCubit, AnnouncementsState>(
      builder: (context, state) {
        if (state is AnnouncementsFetchSuccess) {
          return state.announcements.isEmpty
              ? NoDataContainer(titleKey: noAnnouncementsKey)
              : Column(
                  children: List.generate(
                          state.announcements.length, (index) => index)
                      .map((index) => _buildAnnouncementContainer(
                          context: context,
                          announcement: state.announcements[index],
                          index: index,
                          totalAnnouncements: state.announcements.length,
                          hasMoreAnnouncements:
                              context.read<AnnouncementsCubit>().hasMore(),
                          hasMoreAnnouncementsInProgress:
                              state.fetchMoreAnnouncementsInProgress,
                          fetchMoreAnnouncementsFailure:
                              state.moreAnnouncementsFetchError))
                      .toList(),
                );
        }
        if (state is AnnouncementsFetchFailure) {
          return Center(
            child: ErrorContainer(
              errorMessageCode: state.errorMessage,
              onTapRetry: () {
                context.read<AnnouncementsCubit>().fetchAnnouncements(
                    classSectionId: classSectionDetails.id,
                    subjectId: subject.id);
              },
            ),
          );
        }

        return Column(
          children: List.generate(
                  UiUtils.defaultShimmerLoadingContentCount, (index) => index)
              .map((e) => _buildAnnouncementShimmerLoading(context))
              .toList(),
        );
      },
    );
  }
}
