import 'package:ehsan_chat/src/view/register/blocs/opt/otp_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class OtpWidget extends StatefulWidget {
  const OtpWidget({super.key, required this.email});
  final String email;
  @override
  State<OtpWidget> createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpWidget> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();

  _verify() {
    if (_controller1.text.isNotEmpty &&
        _controller2.text.isNotEmpty &&
        _controller3.text.isNotEmpty &&
        _controller4.text.isNotEmpty) {
      final code = _controller1.text +
          _controller2.text +
          _controller3.text +
          _controller4.text;

      context.read<OtpBloc>().add(VerifyOtpRequestEvent(
            email: widget.email,
            otp: code,
          ));
    }
  }

  @override
  void initState() {
    _controller1.addListener(_verify);
    _controller2.addListener(_verify);
    _controller3.addListener(_verify);
    _controller4.addListener(_verify);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OtpBloc, OtpState>(
      listener: (context, state) {
       if(state is OtpError){
        _controller1.clear();
        _controller2.clear();
        _controller3.clear();
        _controller4.clear();
       }
      },
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _textFormFiled(_controller1, _focusNode1, _focusNode2, null),
                _textFormFiled(
                    _controller2, _focusNode2, _focusNode3, _focusNode1),
                _textFormFiled(
                    _controller3, _focusNode3, _focusNode4, _focusNode2),
                _textFormFiled(_controller4, _focusNode4, null, _focusNode3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textFormFiled(TextEditingController controller, FocusNode focusNode,
      FocusNode? nextFocusNode, FocusNode? previousFocusNode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SizedBox(
        width: 50,
        height: 50,
        child: TextFormField(
          focusNode: focusNode,
          keyboardType: TextInputType.number,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
          textAlign: TextAlign.center,
          textInputAction: TextInputAction.next,
          scrollPadding: EdgeInsets.zero,
          style: Theme.of(context).textTheme.titleMedium,
          controller: controller,
          decoration: InputDecoration(
            counterText: "",
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1000),
                borderSide: BorderSide.none),
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(1000),
                borderSide: BorderSide.none),
            fillColor: controller.text.isEmpty ? null : Colors.transparent,
          ),
          onEditingComplete: () {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            }
          },
          onChanged: (value) {
            if (value.length == 1) {
              if (nextFocusNode != null) {
                FocusScope.of(context).requestFocus(nextFocusNode);
              }
            } else if (value.isEmpty) {
              if (previousFocusNode != null) {
                FocusScope.of(context).requestFocus(previousFocusNode);
              }
            }
            setState(() {});
          },
        ),
      ),
    );
  }
}
