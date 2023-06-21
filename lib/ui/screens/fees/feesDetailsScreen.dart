import 'package:eschool/app/routes.dart';
import 'package:eschool/cubits/appConfigurationCubit.dart';
import 'package:eschool/cubits/authCubit.dart';
import 'package:eschool/cubits/feesPaymentCubit.dart';
import 'package:eschool/cubits/studentDetailedFeesCubit.dart';
import 'package:eschool/data/models/fees.dart';
import 'package:eschool/data/models/student.dart';
import 'package:eschool/data/repositories/studentRepository.dart';
import 'package:eschool/ui/widgets/customBackButton.dart';
import 'package:eschool/ui/widgets/customCircularProgressIndicator.dart';
import 'package:eschool/ui/widgets/customRoundedButton.dart';
import 'package:eschool/ui/widgets/customShimmerContainer.dart';
import 'package:eschool/ui/widgets/errorContainer.dart';
import 'package:eschool/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:eschool/ui/widgets/shimmerLoadingContainer.dart';
import 'package:eschool/utils/stripeService.dart';
import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class FeesDetailsScreen extends StatefulWidget {
  final Student studentDetails;

  const FeesDetailsScreen({Key? key, required this.studentDetails})
      : super(key: key);

  @override
  FeesDetailsScreenState createState() => FeesDetailsScreenState();
  static Route route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => StudentDetailedFeesCubit(StudentRepository()),
        child: FeesDetailsScreen(studentDetails: arguments['studentDetails']),
      ),
    );
  }
}

class FeesDetailsScreenState extends State<FeesDetailsScreen> {
  List<bool> isChecked = [];
  double totalFees = 0;

  List<int> choices = [];

  double amount = 0;
  int paymentTransactionId = 0;

  String orderId = "order0";
  String paymentIntentId = '', clientSecret = '';

  ///payment
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    fetchDetailedFees();
    choices.clear();
    isChecked.clear();

    ///payment
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

    StripeService.init(
        (context.read<AppConfigurationCubit>().getFeesSettings().stripeStatus ==
                "1")
            ? context
                .read<AppConfigurationCubit>()
                .getFeesSettings()
                .stripePublishableKey
            : '',
        "test");
  }

  @override
  void dispose() {
    ///payment
    _razorpay.clear();
    super.dispose();
  }

  void fetchDetailedFees() {
    Future.delayed(Duration.zero, () {
      context.read<StudentDetailedFeesCubit>().fetchDetailedFees(
          classSectionId: widget.studentDetails.classSectionId);
    });
  }

  Widget _buildAppBar() {
    return Align(
        alignment: Alignment.topCenter,
        child: ScreenTopBackgroundContainer(
            heightPercentage: UiUtils.appBarSmallerHeightPercentage,
            child: LayoutBuilder(builder: (context, boxConstraints) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  context.read<AuthCubit>().isParent()
                      ? CustomBackButton(
                          onTap: () {
                            if (context.read<FeesPaymentCubit>().state
                                is FeesPaymentFetchInProgress) {
                              return;
                            }
                            Navigator.of(context).pop();
                          },
                        )
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
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: boxConstraints.maxHeight * (0.205) +
                              UiUtils.screenTitleFontSize),
                      child: Text(
                        "${UiUtils.getTranslatedLabel(context, classKey)} ${widget.studentDetails.classSectionName}",
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: UiUtils.screenSubTitleFontSize,
                            color: Theme.of(context).scaffoldBackgroundColor),
                      ),
                    ),
                  ),
                ],
              );
            })));
  }

  Widget setRow(
      {required String titleLabel,
      required String amountLabel,
      required bool isCheckboxRequired,
      required int index}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isCheckboxRequired)
            SizedBox(
              height: 15,
              width: 15,
              child: Checkbox(
                  activeColor: Theme.of(context).colorScheme.primary,
                  value: isChecked[index],
                  onChanged: (value) => _onChanged(value!, index, amountLabel)),
            )
          else
            SizedBox.shrink(),
          Expanded(
              child: Padding(
            padding: (isCheckboxRequired)
                ? const EdgeInsetsDirectional.only(start: 15)
                : const EdgeInsetsDirectional.only(start: 30),
            child: Text(titleLabel),
          )),
          Text(
            UiUtils.formatAmount(strVal: amountLabel, context: context),
          )
        ],
      ),
    );
  }

  _onChanged(bool val, int index, String amountLabel) {
    setState(() {
      isChecked[index] = val;

      (val)
          ? totalFees += double.parse(amountLabel)
          : totalFees -= double.parse(amountLabel);
    });
  }

  Widget setDivider() {
    return Divider(
      thickness: 1.0,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }

  payNowProcess() {
    for (int i = 0; i < isChecked.length; i++) {
      if (isChecked[i] == true) {
        choices
            .add(context.read<StudentDetailedFeesCubit>().getFees()[i].id ?? 0);
      }
    }
    choices.remove(0); //remove due charges from choices/fees_type_id
    Future.delayed(Duration.zero, () {
      context.read<FeesPaymentCubit>().setFeesChoices(
          selectedChoice: choices, childId: widget.studentDetails.id);
    });
  }

  Widget setPayNowBtn() {
    return Padding(
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * (0.07),
        ),
        child: BlocConsumer<FeesPaymentCubit, FeesPaymentState>(
          listener: (context, state) {
            if (state is FeesPaymentFetchSuccess) {
              amount = double.parse(
                  state.paymentGatewayDetails["amount"].toString());
              paymentTransactionId =
                  state.paymentGatewayDetails["payment_transaction_id"];

              if (context
                      .read<AppConfigurationCubit>()
                      .getFeesSettings()
                      .razorpayStatus ==
                  "1") {
                orderId =
                    state.paymentGatewayDetails["order_id"]; //for razorpay only
                openCheckout(
                    amountToPay:
                        double.parse((amount * 100).toStringAsFixed(2)),
                    apiKey: context
                        .read<AppConfigurationCubit>()
                        .getFeesSettings()
                        .razorpayApiKey!,
                    orderId: orderId,
                    parentName: context
                        .read<AuthCubit>()
                        .getParentDetails()
                        .getFullName(),
                    parentMobile:
                        context.read<AuthCubit>().getParentDetails().mobile,
                    parentEmail:
                        context.read<AuthCubit>().getParentDetails().email);
              } else {
                paymentIntentId =
                    state.paymentGatewayDetails["payment_intent_id"];
                clientSecret = state.paymentGatewayDetails["client_secret"];
                paymentWithStripe(
                    amountToPay: amount.toString(),
                    clientSecret: clientSecret,
                    paymentIntentId: paymentIntentId);
              }
            }
            if (state is FeesPaymentFetchFailure) {
              UiUtils.showCustomSnackBar(
                  context: context,
                  errorMessage: UiUtils.getErrorMessageFromErrorCode(
                      context, state.errorMessage),
                  backgroundColor: Theme.of(context).colorScheme.error);
            }
          },
          builder: (context, state) {
            return CustomRoundedButton(
                child: state is FeesPaymentFetchInProgress
                    ? CustomCircularProgressIndicator(
                        strokeWidth: 2,
                        widthAndHeight: 20,
                      )
                    : null,
                onTap: () => payNowProcess(),
                widthPercentage: 0.4,
                height: 50,
                backgroundColor: UiUtils.getColorScheme(context).primary,
                buttonTitle: UiUtils.getTranslatedLabel(context, payNowKey),
                titleColor: Theme.of(context).scaffoldBackgroundColor,
                showBorder: false);
          },
        ));
  }

  Widget listOfFees({required List<Fees> feesDetails}) {
    return Column(
        children: new List.generate(
            feesDetails.length,
            (index) => setRow(
                titleLabel: UiUtils.getTranslatedLabel(
                    context,
                    feesDetails[index].isDueData == false
                        ? feesDetails[index].name!
                        : UiUtils.getTranslatedLabel(context, dueKey)),
                amountLabel: feesDetails[index].isDueData == false
                    ? feesDetails[index].amount.toString()
                    : feesDetails[index].dueCharges.toString(),
                isCheckboxRequired: feesDetails[index].isOptional,
                index: index)));
  }

  Widget _buildDetailsContainer({required List<Fees> feesDetails}) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * (0.075)),
        child: Column(
          children: [
            listOfFees(feesDetails: feesDetails),
            setDivider(),
            setRow(
                //set total text with formatted amount based on Selection
                titleLabel: UiUtils.getTranslatedLabel(context, totalKey),
                amountLabel: totalFees.toString(),
                isCheckboxRequired: false,
                index: 0),
            setPayNowBtn()
          ],
        ));
  }

  Widget _buildShimmerLoader() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * (0.075)),
      child: ShimmerLoadingContainer(
        child: LayoutBuilder(builder: (context, boxConstraints) {
          return Column(children: [
            SizedBox(
              height: 250,
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: UiUtils.defaultShimmerLoadingContentCount,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ShimmerLoadingContainer(
                            child: CustomShimmerContainer(
                          height: 20,
                          borderRadius: 0,
                        )));
                  }),
            ),
            CustomShimmerContainer(
              margin: const EdgeInsets.all(20),
              height: boxConstraints.maxWidth * (0.18),
              width: boxConstraints.maxWidth * (0.4),
            )
          ]);
        }),
      ),
    );
  }

  Widget _buildLoadingContainer() {
    return Align(
      alignment: Alignment.center,
      child: _buildShimmerLoader(),
    );
  }

  Widget detailedFeesContainer() {
    return SingleChildScrollView(
        padding: EdgeInsets.only(
            bottom: UiUtils.getScrollViewBottomPadding(context),
            top: UiUtils.getScrollViewTopPadding(
                context: context,
                appBarHeightPercentage: UiUtils.appBarSmallerHeightPercentage)),
        child: BlocBuilder<StudentDetailedFeesCubit, StudentDetailedFeesState>(
            builder: (context, state) {
          if (state is StudentDetailedFeesFetchSuccess) {
            return Align(
                alignment: Alignment.center,
                child: _buildDetailsContainer(feesDetails: state.feesDetails));
          }
          if (state is StudentDetailedFeesFetchFailure) {
            return ErrorContainer(
              errorMessageCode: state.errorMessage,
              onTapRetry: () {
                fetchDetailedFees();
              },
            );
          }

          return _buildLoadingContainer();
        }));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StudentDetailedFeesCubit, StudentDetailedFeesState>(
      listener: (context, state) {
        if (state is StudentDetailedFeesFetchSuccess) {
          for (int i = 0; i < state.feesDetails.length; i++) {
            isChecked.add(false); //checkboxValue list
            if (state.feesDetails[i].isOptional == false) {
              totalFees += (state.feesDetails[i].dueCharges != 0.0)
                  ? state.feesDetails[i].dueCharges!
                  : state.feesDetails[i].amount!;
              choices.add(state.feesDetails[i].id ?? 0);
            }
          }
        }
      },
      child: WillPopScope(
        onWillPop: () {
          if (context.read<FeesPaymentCubit>().state
              is FeesPaymentFetchInProgress) {
            return Future.value(false);
          }
          return Future.value(true);
        },
        child: Scaffold(
            body: Stack(
          children: [
            detailedFeesContainer(),
            _buildAppBar(),
          ],
        )),
      ),
    );
  }

  ///payments

  //Razorpay
  void openCheckout(
      {required double amountToPay,
      required String apiKey,
      required String orderId,
      required String parentName,
      required String parentMobile,
      required String parentEmail}) async {
    var options = {
      'key': apiKey,
      'amount': amountToPay,
      'order_id': orderId,
      'name': parentName,
      'prefill': {'contact': parentMobile, 'email': parentEmail},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Success Response: ${response.paymentId}');

    Navigator.of(context)
        .pushReplacementNamed(Routes.paymentVerify, arguments: {
      "studentDetails": widget.studentDetails,
      "orderId": orderId,
      "transactionId": paymentTransactionId,
      "paymentSignature": response.signature,
      "paymentId": response.paymentId,
      "status": 1
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: ${response.message}');
    Navigator.of(context)
        .pushReplacementNamed(Routes.paymentVerify, arguments: {
      "studentDetails": widget.studentDetails,
      "orderId": orderId,
      "transactionId": paymentTransactionId,
      "status": 0
    });
  }

//stripe
  paymentWithStripe({
    required String amountToPay,
    required String clientSecret,
    required String paymentIntentId,
  }) async {
    try {
      await StripeService.payWithPaymentSheet(
          merchantDisplayName: context
              .read<AppConfigurationCubit>()
              .getAppConfiguration()
              .schoolName,
          amount: amountToPay,
          currency: context
              .read<AppConfigurationCubit>()
              .getFeesSettings()
              .currencyCode,
          clientSecret: clientSecret,
          paymentIntentId: paymentIntentId);
      Navigator.of(context)
          .pushReplacementNamed(Routes.paymentVerify, arguments: {
        "studentDetails": widget.studentDetails,
        "orderId": orderId,
        "transactionId": paymentTransactionId,
        "paymentIntentId": paymentIntentId,
      });
    } catch (e) {
      print(e.toString());
      Navigator.of(context)
          .pushReplacementNamed(Routes.paymentVerify, arguments: {
        "studentDetails": widget.studentDetails,
        "orderId": orderId,
        "transactionId": paymentTransactionId,
        "paymentIntentId": paymentIntentId,
      });
    }
  }
}
