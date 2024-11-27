import 'package:ehsan_chat/src/core/utils/utils.dart';
import 'package:ehsan_chat/src/core/widgets/error/error_screen.dart';
import 'package:ehsan_chat/src/core/widgets/loading/loading_screen.dart';
import 'package:ehsan_chat/src/model/login_request.dart';
import 'package:ehsan_chat/src/ui/login/view_models/login_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/resources/assets_manager.dart';
import '../../core/utils/resources/route.dart';
import '../../core/widgets/chateo_icon.dart';
import '../../core/widgets/chateo_rounded_button.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final emailFocusNode = FocusNode();

  final paswordFocusNode = FocusNode();

  final continueFocusNode = FocusNode();

  LoginRequest loginRequest = LoginRequest(
    email: '',
    password: '',
  );

  ValueNotifier<bool> isPasswordHide = ValueNotifier(true);

  login(BuildContext context) async {
    loginRequest = loginRequest.copyWith(
      email: emailController.text,
      password: passwordController.text,
    );
    loginViewModel.login(loginRequest);
  }

  late LoginViewModel loginViewModel;

  @override
  void initState() {
    loginViewModel = context.read<LoginViewModel>();
    loginViewModel.addListener(_onResult);
    super.initState();
  }

  @override
  void dispose() {
    loginViewModel.removeListener(_onResult);
    super.dispose();
  }

  _onResult() {
    if (loginViewModel.status == Status.loading) {
      LoadingScreen.instance().show(context);
    } else if (loginViewModel.status == Status.success) {
      LoadingScreen.instance().hide();
      Utils.showSnackBar(context, loginViewModel.message!);
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.splashRoute,
        ModalRoute.withName(Routes.splashRoute),
      );
    } else if (loginViewModel.status == Status.error) {
      LoadingScreen.instance().hide();
      ErrorScreen.inst().show(
        context: context,
        title: "Ops :(",
        texts: loginViewModel.message!,
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
                _getEmailText(context),
                _getExplanationText(context),
                SizedBox.fromSize(
                  size: Size.fromHeight(h * 0.03),
                ),
                _getEmailInput(context),
                _getPasswordInput(context),
                _getLoginTextButton(context),
                SizedBox.fromSize(
                  size: Size.fromHeight(h * 0.15),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _getContinueButton(context),
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

  _getEmailText(BuildContext context) {
    return Text(
      "Login",
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  _getExplanationText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Text(
        "Please enter your email and password to login to your account",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  _getEmailInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: TextField(
          onSubmitted: (_) =>
              FocusScope.of(context).requestFocus(paswordFocusNode),
          focusNode: emailFocusNode,
          style: Theme.of(context).textTheme.titleMedium,
          controller: emailController,
          decoration: const InputDecoration(
            hintText: "Email Address",
          ),
        ),
      ),
    );
  }

  _getPasswordInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: ValueListenableBuilder(
          valueListenable: isPasswordHide,
          builder: (context, isHide, child) => TextField(
            onSubmitted: (_) =>
                FocusScope.of(context).requestFocus(continueFocusNode),
            focusNode: paswordFocusNode,
            strutStyle: const StrutStyle(
              height: 2,
              forceStrutHeight: true,
            ),
            obscureText: isHide,
            style: Theme.of(context).textTheme.titleMedium,
            controller: passwordController,
            decoration: InputDecoration(
                hintText: "Password",
                suffixIcon: IconButton(
                  onPressed: () {
                    isPasswordHide.value = !(isPasswordHide.value);
                  },
                  icon: Icon(
                    isHide
                        ? CupertinoIcons.eye_slash_fill
                        : CupertinoIcons.eye_solid,
                  ),
                )),
          ),
        ),
      ),
    );
  }

  _getContinueButton(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: ChateoRoundedButton(
          text: "Continue",
          function: () => login(context),
          focusNode: continueFocusNode,
        ),
      ),
    );
  }

  _getLoginTextButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("You have no account?"),
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            overlayColor: Colors.transparent,
          ),
          child: const Text("sign up"),
        ),
      ],
    );
  }
}
