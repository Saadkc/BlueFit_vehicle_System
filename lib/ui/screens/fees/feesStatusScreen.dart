import 'package:eschool/app/routes.dart';
import 'package:eschool/cubits/appConfigurationCubit.dart';
import 'package:eschool/cubits/authCubit.dart';
import 'package:eschool/cubits/feesReceiptCubit.dart';
import 'package:eschool/cubits/studentFeesCubit.dart';
import 'package:eschool/data/models/paidFees.dart';
import 'package:eschool/data/models/student.dart';
import 'package:eschool/ui/widgets/customBackButton.dart';
import 'package:eschool/ui/widgets/customRefreshIndicator.dart';
import 'package:eschool/ui/widgets/customShimmerContainer.dart';
import 'package:eschool/ui/widgets/errorContainer.dart';
import 'package:eschool/ui/widgets/listItemForFeesStatus.dart';
import 'package:eschool/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:eschool/ui/widgets/shimmerLoadingContainer.dart';
import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeesStatusScreen extends StatefulWidget {
  final Student studentDetails;
  const FeesStatusScreen({Key? key, required this.studentDetails})
      : super(key: key);

  static Route route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
      builder: (_) =>
          FeesStatusScreen(studentDetails: arguments['studentDetails']),
    );
  }

  @override
  State<FeesStatusScreen> createState() => _FeesStatusScreenState();
}

class _FeesStatusScreenState extends State<FeesStatusScreen> {
  @override
  void initState() {
    super.initState();
    fetchFeesList();
  }

  void fetchFeesList() {
    Future.delayed(Duration.zero, () {
      context
          .read<StudentFeesCubit>()
          .fetchStudentFeesList(childId: widget.studentDetails.id);
    });
  }

  Widget _buildAppBar(BuildContext context) {
    return ScreenTopBackgroundContainer(
      heightPercentage: UiUtils.appBarSmallerHeightPercentage,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          context.read<AuthCubit>().isParent()
              ? CustomBackButton()
              : SizedBox(),
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              UiUtils.getTranslatedLabel(context, feesKey),
              style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontSize: UiUtils.screenTitleFontSize),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentYearPendingFees() {
    List<String> className = widget.studentDetails.classSectionName.split(' ');
    return ListItemForFeesStatus(
        className: className[0], //only className,without Division
        status: 0, //pending
        receiptProcessing: false,
        year: context
            .read<AppConfigurationCubit>()
            .getAppConfiguration()
            .academicYear
            .name,
        fees: [],
        onItemTap: () {
          if (context
              .read<AppConfigurationCubit>()
              .getOnlineFeesPaymentStatus()) {
            Navigator.of(context).pushNamed(Routes.feesDetails, arguments: {
              "studentDetails": widget.studentDetails,
            });
          } else {
            //show snackbar
            UiUtils.showCustomSnackBar(
                context: context,
                errorMessage:
                    UiUtils.getTranslatedLabel(context, offlinePaymentMsgKey),
                delayDuration: Duration(milliseconds: 4500),
                backgroundColor: UiUtils.getColorScheme(context).primary);
          }
        });
  }

  Widget _buildFeesList(List<PaidFees> feesList) {
    bool isFeesPending = true;
    for (var listItem in feesList) {
      if (listItem.sessionYearId ==
          context
              .read<AppConfigurationCubit>()
              .getAppConfiguration()
              .academicYear
              .id) {
        isFeesPending = false;
        break;
      }
    }
    return SingleChildScrollView(
      child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isFeesPending) _buildCurrentYearPendingFees(),
              ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: feesList.length,
                  itemBuilder: (context, index) {
                    return BlocConsumer<FeesReceiptCubit, FeesReceiptState>(
                        listener: (context, state) {
                      if (state is FeesReceiptSendSuccess) {
                        int currentIndex = feesList.indexWhere(
                            (element) => element.isProcessing == true);
                        if (index == currentIndex) {
                          String msg =
                              "${state.successMessage}\n${widget.studentDetails.getFullName()},$classKey ${feesList[currentIndex].stClass.name}-${feesList[currentIndex].academicYear.name}";
                          UiUtils.showCustomSnackBar(
                              context: context,
                              errorMessage: msg,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary);
                        }
                        feesList
                                .firstWhere((element) =>
                                    element.id == feesList[index].id)
                                .isProcessing =
                            false; //update value of isProcessing in model

                      }
                      if (state is FeesReceiptSendFailure) {
                        UiUtils.showCustomSnackBar(
                            context: context,
                            errorMessage: UiUtils.getErrorMessageFromErrorCode(
                                context, state.errorMessage),
                            backgroundColor:
                                Theme.of(context).colorScheme.error);
                      }
                    }, builder: (context, state) {
                      return ListItemForFeesStatus(
                        year: feesList[index].academicYear.name,
                        status: 1, //paid
                        className: feesList[index].stClass.name!,
                        onItemTap: () {},
                        id: feesList[index].id,
                        fees: feesList,
                        receiptProcessing: state is FeesReceiptSendInProgress &&
                            state.receiptList
                                    .firstWhere((element) =>
                                        element.id == feesList[index].id)
                                    .isProcessing ==
                                true,
                      );
                    });
                  })
            ],
          )),
    );
  }

  Widget _buildFeesShimmerLoadingContainer() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(
          horizontal: UiUtils.screenContentHorizontalPaddingInPercentage *
              MediaQuery.of(context).size.width),
      child: ShimmerLoadingContainer(
        child: LayoutBuilder(builder: (context, boxConstraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                height: 9,
                width: boxConstraints.maxWidth * (0.3),
              )),
              SizedBox(
                height: boxConstraints.maxWidth * (0.02),
              ),
              ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                height: 10,
                width: boxConstraints.maxWidth * (0.8),
              )),
              SizedBox(
                height: boxConstraints.maxWidth * (0.1),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildFeesLoading() {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(UiUtils.defaultShimmerLoadingContentCount,
                (index) => _buildFeesShimmerLoadingContainer()),
          ),
        ),
      ),
    );
  }

  Widget _buildStudentFeesStatus() {
    return CustomRefreshIndicator(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
            bottom: UiUtils.getScrollViewBottomPadding(context),
            top: UiUtils.getScrollViewTopPadding(
                context: context,
                appBarHeightPercentage: UiUtils.appBarSmallerHeightPercentage)),
        child: Column(
          children: [
            BlocBuilder<StudentFeesCubit, StudentFeesState>(
                builder: (context, state) {
              if (state is StudentFeesFetchSuccess) {
                return Align(
                    alignment: Alignment.topCenter,
                    child: state.feesList.isEmpty
                        ? _buildCurrentYearPendingFees()
                        : _buildFeesList(state.feesList));
              }
              if (state is StudentFeesFetchFailure) {
                return ErrorContainer(
                  errorMessageCode: state.errorMessage,
                  onTapRetry: () {
                    fetchFeesList();
                  },
                );
              }

              return _buildFeesLoading();
            }),
          ],
        ),
      ),
      displacment: UiUtils.getScrollViewTopPadding(
          context: context,
          appBarHeightPercentage: UiUtils.appBarBiggerHeightPercentage),
      onRefreshCallback: () {
        fetchFeesList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildStudentFeesStatus(),
          Align(
            alignment: Alignment.topCenter,
            child: _buildAppBar(context),
          ),
        ],
      ),
    );
  }
}
