import "package:delivery/common/const/colors.dart";
import "package:flutter/material.dart";

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;

  const CustomTextFormField(
      {this.hintText,
      this.errorText,
      this.obscureText = false,
      this.autofocus = false,
      required this.onChanged,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
        borderSide: BorderSide(
      color: INPUT_BORDER_COLOR,
      width: 1.0,
    ));

    return TextFormField(
      cursorColor: PRIMARY_COLOR,
      obscureText: obscureText, // 비밀번호 입력할때씀, true인 경우 마스킹처리
      autofocus: autofocus,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        hintText: hintText,
        errorText: errorText,
        hintStyle: const TextStyle(
          color: BODY_TEXT_COLOR,
          fontSize: 14.0,
        ),
        fillColor: INPUT_BG_COLOR,
        filled: true, // true = 배경색 있음, false = 배경색 없음
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: PRIMARY_COLOR,
          ),
        ),
      ),
    );
  }
}
