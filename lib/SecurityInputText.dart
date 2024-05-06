import 'package:flutter/material.dart';
import 'package:my_app/primaryThemeColor.dart';

class SecurityInputText extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final String? value;
  final bool isError;
  final String? errorText;
  final Color focusedBorderColor;
  final bool isHidePassword;
  final Function(String)? onChanged;
  final Function()? onClickIcon;

  const SecurityInputText(
      {Key? key,
      this.hintText,
      this.labelText,
      this.value,
      this.isError = false,
      this.errorText,
      this.isHidePassword = true,
      this.onChanged,
      this.onClickIcon,
      this.focusedBorderColor = primaryColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                labelText ?? "",
                style: TextStyle(
                    color: textTitleColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
                textAlign: TextAlign.left,
              ),
              TextFormField(
                maxLines: 1,
                cursorColor: primaryColor,
                style: TextStyle(color: Colors.black, fontSize: 16),
                initialValue: value,
                obscureText: isHidePassword,
                onChanged: onChanged,
                decoration: InputDecoration(
                  errorText: isError ? errorText : null,
                  hintText: hintText,
                  hintStyle: TextStyle(
                      color: textHintColor, fontStyle: FontStyle.italic),
                  // suffixIcon: IconButton(
                  //   onPressed: onClickIcon,
                  //   icon: Icon(
                  //     isHidePassword ? Icons.visibility_off : Icons.visibility,
                  //     color: textHintColor,
                  //     size: 16,
                  //   ),
                  // ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: textHintColor,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: textHintColor,
                    ),
                  ),
                ),
              ),
            ]));
  }
}
