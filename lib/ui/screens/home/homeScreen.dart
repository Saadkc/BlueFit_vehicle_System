import 'package:eschool_teacher/cubits/appConfigurationCubit.dart';
import 'package:eschool_teacher/cubits/timeTableCubit.dart';
import 'package:eschool_teacher/data/repositories/teacherRepository.dart';
import 'package:eschool_teacher/ui/screens/home/widgets/appUnderMaintenanceContainer.dart';
import 'package:eschool_teacher/ui/screens/home/widgets/bottomNavigationItemContainer.dart';
import 'package:eschool_teacher/ui/screens/home/widgets/forceUpdateDialogContainer.dart';
import 'package:eschool_teacher/ui/screens/home/widgets/homeContainer.dart';
import 'package:eschool_teacher/ui/screens/home/widgets/profileContainer.dart';
import 'package:eschool_teacher/ui/screens/home/widgets/timeTableContainer.dart';
import 'package:eschool_teacher/ui/screens/home/widgets/settingsContainer.dart';

import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  static Route<dynamic> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
        builder: (_) => BlocProvider(
              create: (context) => TimeTableCubit(TeacherRepository()),
              child: HomeScreen(),
            ));
  }
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 500));

  late Animation<double> _bottomNavAndTopProfileAnimation =
      Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _animationController, curve: Curves.easeInOut));

  late final List<AnimationController> _bottomNavItemTitlesAnimationController =
      [];

  late int _currentSelectedBottomNavIndex = 0;

  List<BottomNavItem> _bottomNavItems = [
    BottomNavItem(
        activeImageUrl: UiUtils.getImagePath("home_active_icon.svg"),
        disableImageUrl: UiUtils.getImagePath("home_icon.svg"),
        title: homeKey),
    BottomNavItem(
        activeImageUrl: UiUtils.getImagePath("schedule_active.svg"),
        disableImageUrl: UiUtils.getImagePath("schedule.svg"),
        title: scheduleKey),
    BottomNavItem(
        activeImageUrl: UiUtils.getImagePath("profile_active.svg"),
        disableImageUrl: UiUtils.getImagePath("profile.svg"),
        title: profileKey),
    BottomNavItem(
        activeImageUrl: UiUtils.getImagePath("setting_active.svg"),
        disableImageUrl: UiUtils.getImagePath("setting.svg"),
        title: settingKey),
  ];

  @override
  void initState() {
    super.initState();
    initAnimations();
    _animationController.forward();
  }

  void initAnimations() {
    for (var i = 0; i < _bottomNavItems.length; i++) {
      _bottomNavItemTitlesAnimationController.add(AnimationController(
          value: i == _currentSelectedBottomNavIndex ? 0.0 : 1.0,
          vsync: this,
          duration: const Duration(milliseconds: 400)));
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var animationController in _bottomNavItemTitlesAnimationController) {
      animationController.dispose();
    }
    super.dispose();
  }

  void _changeBottomNavItem(int index) async {
    _bottomNavItemTitlesAnimationController[_currentSelectedBottomNavIndex]
        .forward();
    //change current selected bottom index
    setState(() {
      _currentSelectedBottomNavIndex = index;
    });
    _bottomNavItemTitlesAnimationController[_currentSelectedBottomNavIndex]
        .reverse();
  }

  Widget _buildBottomNavigationContainer() {
    return FadeTransition(
      opacity: _bottomNavAndTopProfileAnimation,
      child: SlideTransition(
        position: _bottomNavAndTopProfileAnimation
            .drive(Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)),
        child: Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * (0.075) * (0.075),
          ),
          child: LayoutBuilder(builder: (context, boxConstraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _bottomNavItems.map((bottomNavItem) {
                int index = _bottomNavItems
                    .indexWhere((e) => e.title == bottomNavItem.title);
                return BottomNavItemContainer(
                    onTap: _changeBottomNavItem,
                    boxConstraints: boxConstraints,
                    currentIndex: _currentSelectedBottomNavIndex,
                    bottomNavItem: _bottomNavItems[index],
                    animationController:
                        _bottomNavItemTitlesAnimationController[index],
                    index: index);
              }).toList(),
            );
          }),
          margin: EdgeInsets.only(
            bottom: UiUtils.bottomNavigationBottomMargin,
          ),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: UiUtils.getColorScheme(context)
                        .secondary
                        .withOpacity(0.15),
                    offset: Offset(2.5, 2.5),
                    blurRadius: 20,
                    spreadRadius: 0)
              ],
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10.0)),
          width: MediaQuery.of(context).size.width * (0.8),
          height: MediaQuery.of(context).size.height *
              UiUtils.bottomNavigationHeightPercentage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: context.read<AppConfigurationCubit>().appUnderMaintenance()
          ? AppUnderMaintenanceContainer()
          : Stack(
              children: [
                IndexedStack(
                  index: _currentSelectedBottomNavIndex,
                  children: [
                    HomeContainer(),
                    TimeTableContainer(),
                    ProfileContainer(),
                    SettingsContainer(),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _buildBottomNavigationContainer(),
                ),
                context.read<AppConfigurationCubit>().forceUpdate()
                    ? FutureBuilder<bool>(
                        future: UiUtils.forceUpdate(context
                            .read<AppConfigurationCubit>()
                            .getAppVersion()),
                        builder: (context, snaphsot) {
                          if (snaphsot.hasData) {
                            return (snaphsot.data ?? false)
                                ? ForceUpdateDialogContainer()
                                : SizedBox();
                          }

                          return SizedBox();
                        })
                    : SizedBox(),
              ],
            ),
    );
  }
}
