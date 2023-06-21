import 'package:eschool/cubits/studentParentDetailsCubit.dart';
import 'package:eschool/ui/styles/colors.dart';
import 'package:eschool/ui/widgets/customShimmerContainer.dart';
import 'package:eschool/ui/widgets/errorContainer.dart';
import 'package:eschool/ui/widgets/parentProfileDetailsContainer.dart';
import 'package:eschool/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:eschool/ui/widgets/shimmerLoadingContainer.dart';
import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/uiUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentProfileContainer extends StatefulWidget {
  ParentProfileContainer({Key? key}) : super(key: key);

  @override
  State<ParentProfileContainer> createState() => _ParentProfileContainerState();
}

class _ParentProfileContainerState extends State<ParentProfileContainer> {
  @override
  void initState() {
    super.initState();
    fetchParentDetails();
  }

  void fetchParentDetails() {
    Future.delayed(Duration.zero, () {
      context.read<StudentParentDetailsCubit>().getStudentParentDetails();
    });
  }

  Widget _buildParentDetailsValueShimmerLoading(BoxConstraints boxConstraints) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        ShimmerLoadingContainer(
          child: CustomShimmerContainer(
              margin: EdgeInsetsDirectional.only(
                end: boxConstraints.maxWidth * (0.7),
              ),
              height: 8),
        ),
        SizedBox(
          height: 10,
        ),
        ShimmerLoadingContainer(
          child: CustomShimmerContainer(
              margin: EdgeInsetsDirectional.only(
                end: boxConstraints.maxWidth * (0.5),
              ),
              height: 8),
        ),
      ],
    );
  }

  Widget _buildParentDetailsShimmerLoading() {
    return Container(
      width: MediaQuery.of(context).size.width * (0.8),
      child: LayoutBuilder(builder: (context, boxConstraints) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            PositionedDirectional(
                top: -40,
                start: MediaQuery.of(context).size.width * (0.4) - 42.5,
                child: ShimmerLoadingContainer(
                  child: Container(
                    width: 85.0,
                    height: 85.0,
                    padding: EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: shimmerContentColor),
                    ),
                    decoration: BoxDecoration(shape: BoxShape.circle),
                  ),
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 50,
                ),
                ShimmerLoadingContainer(
                  child: Divider(
                    color: shimmerContentColor,
                    height: 2,
                  ),
                ),
                _buildParentDetailsValueShimmerLoading(boxConstraints),
                _buildParentDetailsValueShimmerLoading(boxConstraints),
                _buildParentDetailsValueShimmerLoading(boxConstraints),
                SizedBox(
                  height: 70,
                ),
              ],
            ),
          ],
        );
      }),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
    );
  }

  Widget _buildAppBar() {
    return ScreenTopBackgroundContainer(
      padding: EdgeInsets.all(0),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              UiUtils.getTranslatedLabel(context, parentProfileKey),
              style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontSize: UiUtils.screenTitleFontSize),
            ),
          ),
        ],
      ),
      heightPercentage: UiUtils.appBarSmallerHeightPercentage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<StudentParentDetailsCubit, StudentParentDetailsState>(
          builder: (context, state) {
            if (state is StudentParentDetailsFetchSuccess) {
              return Align(
                alignment: Alignment.topCenter,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                      bottom: UiUtils.getScrollViewBottomPadding(context),
                      top: MediaQuery.of(context).size.height *
                          (UiUtils.appBarSmallerHeightPercentage + 0.075)),
                  child: Column(
                    children: [
                      ParentProfileDetailsContainer(
                          nameKey: motherNameKey, parent: state.mother),
                      SizedBox(
                        height: 70.0,
                      ),
                      ParentProfileDetailsContainer(
                          nameKey: fatherNameKey, parent: state.father),
                      SizedBox(
                        height: 70.0,
                      ),
                      state.guardian.id == 0
                          ? SizedBox()
                          : ParentProfileDetailsContainer(
                              nameKey: guardianNameKey, parent: state.guardian),
                    ],
                  ),
                ),
              );
            }
            if (state is StudentParentDetailsFetchFailure) {
              return ErrorContainer(errorMessageCode: state.errorMessage);
            }

            return Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    bottom: UiUtils.getScrollViewBottomPadding(context),
                    top: MediaQuery.of(context).size.height *
                        (UiUtils.appBarSmallerHeightPercentage + 0.075)),
                child: Column(
                  children: [
                    _buildParentDetailsShimmerLoading(),
                    _buildParentDetailsShimmerLoading(),
                    _buildParentDetailsShimmerLoading()
                  ],
                ),
              ),
            );
          },
        ),
        Align(
          alignment: Alignment.topCenter,
          child: _buildAppBar(),
        ),
      ],
    );
  }
}
