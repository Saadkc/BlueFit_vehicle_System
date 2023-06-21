import 'package:eschool/app/routes.dart';
import 'package:eschool/cubits/appConfigurationCubit.dart';
import 'package:eschool/cubits/authCubit.dart';
import 'package:eschool/ui/widgets/errorContainer.dart';
import 'package:eschool/utils/uiUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<AppConfigurationCubit>().fetchAppConfiguration();
    });
  }

  void navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 5));
    if (context.read<AuthCubit>().state is Unauthenticated) {
      Navigator.of(context).pushReplacementNamed(Routes.studentLogin);
    } else {
      Navigator.of(context).pushReplacementNamed(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AppConfigurationCubit, AppConfigurationState>(
        listener: (context, state) {
          if (state is AppConfigurationFetchSuccess) {
            navigateToNextScreen();
          }
        },
        builder: (context, state) {
          if (state is AppConfigurationFetchFailure) {
            return Center(
              child: ErrorContainer(
                  onTapRetry: () {
                    context
                        .read<AppConfigurationCubit>()
                        .fetchAppConfiguration();
                  },
                  errorMessageCode: UiUtils.getErrorMessageFromErrorCode(
                      context, state.errorMessage)),
            );
          }
          return Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top +
                        MediaQuery.of(context).size.height * (0.05)),
                height: MediaQuery.of(context).size.height * (0.4),
                child: Image.asset("assets/animations/login.gif"),
              ),
              Center(
                  child: Image.asset(UiUtils.getImagePath("BlueFitV2.jpeg"))),
            ],
          );
        },
      ),
    );
  }
}
