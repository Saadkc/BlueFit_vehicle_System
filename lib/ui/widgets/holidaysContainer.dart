import 'package:eschool/cubits/appConfigurationCubit.dart';
import 'package:eschool/cubits/authCubit.dart';
import 'package:eschool/cubits/holidaysCubit.dart';
import 'package:eschool/data/models/holiday.dart';
import 'package:eschool/ui/widgets/changeCalendarMonthButton.dart';
import 'package:eschool/ui/widgets/customBackButton.dart';
import 'package:eschool/ui/widgets/customShimmerContainer.dart';
import 'package:eschool/ui/widgets/errorContainer.dart';
import 'package:eschool/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:eschool/ui/widgets/shimmerLoadingContainer.dart';
import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/uiUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

class HolidaysContainer extends StatefulWidget {
  HolidaysContainer({Key? key}) : super(key: key);

  @override
  State<HolidaysContainer> createState() => _HolidaysContainerState();
}

class _HolidaysContainerState extends State<HolidaysContainer> {
  //last and first day of calendar
  late DateTime firstDay = DateTime.now();
  late DateTime lastDay = DateTime.now();

  //current day
  late DateTime focusedDay = DateTime.now();
  late List<Holiday> holidays = [];
  PageController? calendarPageController;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      context.read<HolidaysCubit>().fetchHolidays();
    });
    super.initState();
  }

  @override
  void dispose() {
    calendarPageController?.dispose();
    super.dispose();
  }

  void updateMonthViceHolidays() {
    holidays.clear();
    for (var holiday in context.read<HolidaysCubit>().holidays()) {
      if (holiday.date.month == focusedDay.month &&
          holiday.date.year == focusedDay.year) {
        holidays.add(holiday);
      }
    }

    holidays.sort((first, second) => first.date.compareTo(second.date));
    setState(() {});
  }

  Widget _buildHolidayDetailsList() {
    return Column(
      children: holidays
          .map((holiday) => Container(
                margin: EdgeInsets.only(bottom: 15),
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.5),
                width: MediaQuery.of(context).size.width * (0.85),
                child: LayoutBuilder(builder: (context, boxConstraints) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: boxConstraints.maxWidth * (0.7),
                            child: Text(
                              holiday.title,
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.0),
                            ),
                          ),
                          Spacer(),
                          SizedBox(
                            width: boxConstraints.maxWidth * (0.25),
                            child: Text(
                              UiUtils.formatDate(holiday.date),
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontSize: 12.0),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: holiday.description.isEmpty ? 0 : 2.5,
                      ),
                      holiday.description.isEmpty
                          ? SizedBox()
                          : Text(
                              holiday.description,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontSize: 11.5),
                            )
                    ],
                  );
                }),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(10.0)),
              ))
          .toList(),
    );
  }

  Widget _buildCalendarContainer() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
                color:
                    Theme.of(context).colorScheme.secondary.withOpacity(0.075),
                offset: Offset(5.0, 5),
                blurRadius: 10,
                spreadRadius: 0)
          ],
          borderRadius: BorderRadius.circular(15.0)),
      margin: EdgeInsets.only(top: 20),
      child: TableCalendar(
        calendarFormat: CalendarFormat.month,
        headerVisible: false,
        daysOfWeekHeight: 40,
        onPageChanged: (DateTime dateTime) {
          setState(() {
            focusedDay = dateTime;
          });
          updateMonthViceHolidays();
          //
        },

        onCalendarCreated: (contoller) {
          calendarPageController = contoller;
        },

        holidayPredicate: (dateTime) {
          return holidays.indexWhere((element) =>
                  UiUtils.formatDate(dateTime) ==
                  UiUtils.formatDate(element.date)) !=
              -1;
        },

        availableGestures: AvailableGestures.none,
        calendarStyle: CalendarStyle(
          isTodayHighlighted: false,
          holidayTextStyle:
              TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
          holidayDecoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
            weekendStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold),
            weekdayStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold)),
        headerStyle:
            HeaderStyle(titleCentered: true, formatButtonVisible: false),
        firstDay: firstDay, //start education year
        lastDay: lastDay, //end education year
        focusedDay: focusedDay,
      ),
    );
  }

  Widget _buildHolidaysCalendar() {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width *
                UiUtils.screenContentHorizontalPaddingInPercentage,
            right: MediaQuery.of(context).size.width *
                UiUtils.screenContentHorizontalPaddingInPercentage,
            bottom: UiUtils.getScrollViewBottomPadding(context),
            top: UiUtils.getScrollViewTopPadding(
                context: context,
                appBarHeightPercentage: UiUtils.appBarMediumtHeightPercentage)),
        child: BlocConsumer<HolidaysCubit, HolidaysState>(
          listener: ((context, state) {
            if (state is HolidaysFetchSuccess) {
              if (UiUtils.isToadyIsInAcademicYear(
                  context
                      .read<AppConfigurationCubit>()
                      .getAppConfiguration()
                      .academicYear
                      .startDate,
                  context
                      .read<AppConfigurationCubit>()
                      .getAppConfiguration()
                      .academicYear
                      .endDate)) {
                firstDay = context
                    .read<AppConfigurationCubit>()
                    .getAppConfiguration()
                    .academicYear
                    .startDate;
                lastDay = context
                    .read<AppConfigurationCubit>()
                    .getAppConfiguration()
                    .academicYear
                    .endDate;

                setState(() {});
                updateMonthViceHolidays();
              }
            }
          }),
          builder: (context, state) {
            if (state is HolidaysFetchSuccess) {
              return Column(
                children: [
                  _buildCalendarContainer(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * (0.025),
                  ),
                  _buildHolidayDetailsList()
                ],
              );
            }

            if (state is HolidaysFetchFailure) {
              return Center(
                child: ErrorContainer(
                  errorMessageCode: UiUtils.getErrorMessageFromErrorCode(
                      context, state.errorMessage),
                  onTapRetry: () {
                    context.read<HolidaysCubit>().fetchHolidays();
                  },
                ),
              );
            }
            return Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                ShimmerLoadingContainer(
                    child: CustomShimmerContainer(
                  height: MediaQuery.of(context).size.height * (0.425),
                )),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return ScreenTopBackgroundContainer(
      heightPercentage: UiUtils.appBarMediumtHeightPercentage,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          context.read<AuthCubit>().isParent()
              ? CustomBackButton()
              : SizedBox(),
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              UiUtils.getTranslatedLabel(context, holidaysKey),
              style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontSize: UiUtils.screenTitleFontSize),
            ),
          ),
          PositionedDirectional(
              bottom: -20,
              start: MediaQuery.of(context).size.width * (0.075),
              child: Container(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "${UiUtils.getMonthName(focusedDay.month)} ${focusedDay.year}",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: ChangeCalendarMonthButton(
                            onTap: () {
                              if (context.read<HolidaysCubit>().state
                                  is HolidaysFetchInProgress) {
                                return;
                              }

                              calendarPageController?.previousPage(
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeInOut);
                            },
                            isDisable: false,
                            isNextButton: false)),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: ChangeCalendarMonthButton(
                          onTap: () {
                            if (context.read<HolidaysCubit>().state
                                is HolidaysFetchInProgress) {
                              return;
                            }

                            calendarPageController?.nextPage(
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeInOut);
                          },
                          isDisable: false,
                          isNextButton: true),
                    ),
                  ],
                ),
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.075),
                          offset: Offset(2.5, 2.5),
                          blurRadius: 5,
                          spreadRadius: 0)
                    ],
                    color: Theme.of(context).scaffoldBackgroundColor),
                width: MediaQuery.of(context).size.width * (0.85),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildHolidaysCalendar(),
        _buildAppBar(),
      ],
    );
  }
}
