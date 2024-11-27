import 'package:ehsan_chat/src/core/utils/resources/assets_manager.dart';
import 'package:ehsan_chat/src/core/utils/resources/route.dart';
import 'package:ehsan_chat/src/core/utils/utils.dart';
import 'package:ehsan_chat/src/core/widgets/chateo_icon.dart';
import 'package:ehsan_chat/src/core/widgets/chateo_rounded_button.dart';
import 'package:ehsan_chat/src/core/widgets/error/error_screen.dart';
import 'package:ehsan_chat/src/core/widgets/loading/loading_screen.dart';
import 'package:ehsan_chat/src/model/signup_request.dart';
import 'package:ehsan_chat/src/ui/register/view_models/register_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login/view_models/login_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();

  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  final emailFocusNode = FocusNode();

  final paswordFocusNode = FocusNode();

  final continueFocusNode = FocusNode();

  SignupRequest signupRequest = SignupRequest(
    email: '',
    password: '',
    username: '',
  );

  register(BuildContext context) async {
    signupRequest = signupRequest.copyWith(
      email: emailController.text,
      username: usernameController.text,
      password: passwordController.text,
    );
    registerViewModel.register(signupRequest);
  }

  late RegisterViewModel registerViewModel;

  @override
  void initState() {
    registerViewModel = context.read<RegisterViewModel>();
    registerViewModel.addListener(_onResult);
    super.initState();
  }

  @override
  void dispose() {
    registerViewModel.removeListener(_onResult);
    super.dispose();
  }

  _onResult() {
    if (registerViewModel.status == Status.loading) {
      LoadingScreen.instance().show(context);
    } else if (registerViewModel.status == Status.success) {
      LoadingScreen.instance().hide();
      Utils.showSnackBar(context,registerViewModel.message!);
      Navigator.pushNamed(
        context,
        Routes.otpRoute,
        arguments: signupRequest,
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
                _getEmailText(context),
                _getExplanationText(context),
                SizedBox.fromSize(
                  size: Size.fromHeight(h * 0.03),
                ),
                _getUsernameInput(context),
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
      "Enter Your Email",
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  _getExplanationText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Text(
        "Please enter your username, email and password to verify your account",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  _getUsernameInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: TextField(
          onSubmitted: (_) =>
              FocusScope.of(context).requestFocus(emailFocusNode),
          style: Theme.of(context).textTheme.titleMedium,
          controller: usernameController,
          decoration: const InputDecoration(
            hintText: "Username",
          ),
        ),
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
        child: TextField(
          onSubmitted: (_) =>
              FocusScope.of(context).requestFocus(continueFocusNode),
          focusNode: paswordFocusNode,
          style: Theme.of(context).textTheme.titleMedium,
          controller: passwordController,
          decoration: const InputDecoration(
            hintText: "Password",
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
          function: () => register(context),
          focusNode: continueFocusNode,
        ),
      ),
    );
  }

  _getLoginTextButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("You already have an account?"),
        TextButton(
          onPressed: () => Navigator.pushNamed(
            context,
            Routes.loginRoute,
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            overlayColor: Colors.transparent,
          ),
          child: const Text("login"),
        ),
      ],
    );
  }
}
