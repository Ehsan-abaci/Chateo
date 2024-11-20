import 'package:ehsan_chat/src/core/utils/resources/assets_manager.dart';
import 'package:ehsan_chat/src/core/utils/resources/route.dart';
import 'package:ehsan_chat/src/core/utils/utils.dart';
import 'package:ehsan_chat/src/core/widgets/chateo_icon.dart';
import 'package:ehsan_chat/src/core/widgets/error/error_screen.dart';
import 'package:ehsan_chat/src/core/widgets/loading/loading_screen.dart';
import 'package:ehsan_chat/src/model/signup_request.dart';
import 'package:ehsan_chat/src/view/register/blocs/opt/otp_bloc.dart';
import 'package:ehsan_chat/src/view/register/widgets/otp_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/register/register_bloc.dart';

// ehsanabaci7755@gmail.com

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key, required this.signupRequest});
  final SignupRequest signupRequest;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final w = MediaQuery.sizeOf(context).width;
    return MultiBlocListener(
      listeners: [
        BlocListener<OtpBloc, OtpState>(
          listener: (context, state) {
            if (state is OtpLoading) {
              LoadingScreen.instance().show(context: context);
            } else {
              LoadingScreen.instance().hide();
            }
            if (state is OtpError) {
              ErrorScreen.inst().show(
                context: context,
                title: "Ops :(",
                texts: state.messages,
              );
            } else if (state is OtpSuccess) {
              Utils.showSnackBar(state.message);
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.splashRoute,
                ModalRoute.withName(Routes.splashRoute),
              );
            }
          },
        ),
        BlocListener<RegisterBloc, RegisterState>(
          listener: (ctx, state) {
            if (state is RegisterLoading) {
              LoadingScreen.instance().show(context: context);
            } else {
              LoadingScreen.instance().hide();
            }
            if (state is RegisterError) {
              ErrorScreen.inst().show(
                context: context,
                title: "Ops :(",
                texts: state.messages,
              );
            } else if (state is RegisterSuccess) {
              Utils.showSnackBar(state.message);
            }
          },
        ),
      ],
      child: Scaffold(
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
                    email: signupRequest.email,
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
        "We have sent you an Email with the code to ${signupRequest.email}",
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
          context
              .read<RegisterBloc>()
              .add(RegisterRequestEvent(signupRequest: signupRequest));
        },
        child: const Text(
          "Resend Code",
        ),
      ),
    );
  }
}
