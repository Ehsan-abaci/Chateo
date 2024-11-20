import 'package:ehsan_chat/src/core/utils/resources/assets_manager.dart';
import 'package:ehsan_chat/src/core/utils/resources/route.dart';
import 'package:ehsan_chat/src/core/widgets/chateo_rounded_button.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  final _img = const AssetImage(AssetsImage.onboarding);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: SizedBox(
        height: h,
        width: w,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox.fromSize(
                size: Size.fromHeight(h * 0.1),
              ),
              _getImage(w),
              SizedBox.fromSize(
                size: Size.fromHeight(h * 0.03),
              ),
              _getTextContent(context),
              SizedBox.fromSize(
                size: Size.fromHeight(h * 0.15),
              ),
              _getTermsTextContent(context),
              SizedBox.fromSize(
                size: Size.fromHeight(h * 0.02),
              ),
              _getStartButton(context, w),
              SizedBox.fromSize(
                size: Size.fromHeight(h * 0.02),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getImage(double width) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * .1),
      child: Image(image: _img),
    );
  }

  _getTextContent(BuildContext context) {
    return Text(
      '''
Connect easily with 
your family and friends
 over countries
''',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  _getTermsTextContent(BuildContext context) {
    return Text(
      'Terms & Privacy Policy',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  _getStartButton(BuildContext context, double width) {
    return ChateoRoundedButton(
      text: "Start Messaging",
      function: () => _startMessaging(context),
    );
  }

  void _startMessaging(BuildContext context) {
    Navigator.pushNamed(context, Routes.registerRoute);
  }
}
