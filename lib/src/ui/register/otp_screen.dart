import 'package:ehsan_chat/src/core/utils/resources/assets_manager.dart';
import 'package:ehsan_chat/src/core/utils/resources/route.dart';
import 'package:ehsan_chat/src/core/utils/utils.dart';
import 'package:ehsan_chat/src/core/widgets/chateo_icon.dart';
import 'package:ehsan_chat/src/core/widgets/error/error_screen.dart';
import 'package:ehsan_chat/src/core/widgets/loading/loading_screen.dart';
import 'package:ehsan_chat/src/model/signup_request.dart';
import 'package:ehsan_chat/src/ui/register/view_models/otp_viewmodel.dart';
import 'package:ehsan_chat/src/ui/register/view_models/register_viewmodel.dart';
import 'package:ehsan_chat/src/ui/register/widgets/otp_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login/view_models/login_viewmodel.dart';
// ehsanabaci7755@gmail.com

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.signupRequest});
  final SignupRequest signupRequest;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late RegisterViewModel registerViewModel;
  late OtpViewModel otpViewModel;

  @override
  void initState() {
    registerViewModel = context.read<RegisterViewModel>();
    otpViewModel = context.read<OtpViewModel>();
    registerViewModel.addListener(_onRegisterResult);
    otpViewModel.addListener(_onOtpResult);
    super.initState();
  }

  @override
  void dispose() {
    registerViewModel.removeListener(_onRegisterResult);
    otpViewModel.removeListener(_onOtpResult);
    super.dispose();
  }

  _onOtpResult() {
    if (otpViewModel.status == Status.loading) {
      LoadingScreen.instance().show(context);
    } else if (otpViewModel.status == Status.success) {
      LoadingScreen.instance().hide();
      Utils.showSnackBar(otpViewModel.message!);
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.splashRoute,
        ModalRoute.withName(Routes.splashRoute),
      );
    } else if (otpViewModel.status == Status.error) {
      LoadingScreen.instance().hide();
      ErrorScreen.inst().show(
        context: context,
        title: "Ops :(",
        texts: otpViewModel.message!,
      );
    }
  }

  _onRegisterResult() {
    if (registerViewModel.status == Status.loading) {
      LoadingScreen.instance().show(context);
    } else if (registerViewModel.status == Status.success) {
      LoadingScreen.instance().hide();
      Utils.showSnackBar(registerViewModel.message!);
      Navigator.pushNamed(
        context,
        Routes.otpRoute,
        arguments: widget.signupRequest,
      );
    } else if (registerViewModel.status == Status.error) {
      LoadingScreen.instance().hide();
      ErrorScreen.inst().show(
        context: context,
        title: "Ops :(",
        texts: registerViewModel.message!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: h,
          width: w,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _getBackButton(context),
                SizedBox.fromSize(
                  size: Size.fromHeight(h * 0.1),
                ),
                _getEnterCodeText(context),
                _getExplanationText(context),
                SizedBox.fromSize(
                  size: Size.fromHeight(h * 0.05),
                ),
                OtpWidget(
                  email: widget.signupRequest.email,
                ),
                SizedBox.fromSize(
                  size: Size.fromHeight(h * 0.04),
                ),
                _getResendCodeButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getEnterCodeText(BuildContext context) {
    return Text(
      "Enter Code",
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  _getExplanationText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Text(
        "We have sent you an Email with the code to ${widget.signupRequest.email}",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  _getBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: InkWell(
            onTap: () => Navigator.of(context).pop(),
            customBorder: const CircleBorder(),
            child: const ChateoIcon(
              icon: AssetsIcon.chevronLeft,
              height: 35,
            )),
      ),
    );
  }

  _getResendCodeButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: TextButton(
        onPressed: () {
          context.read<RegisterViewModel>().register(widget.signupRequest);
        },
        child: const Text(
          "Resend Code",
        ),
      ),
    );
  }
}
