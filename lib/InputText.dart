import 'package:flutter/material.dart';
import 'package:my_app/primaryThemeColor.dart';

class InputText extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final String? value;
  final bool isError;
  final bool isNumberInput;
  final String? errorText;
  final double padding;
  final bool? isEnable ;
  final int maxLines;
  final Color focusedBorderColor;
  final Function(String)? onChanged;

  const InputText(
      {Key? key,
      this.isEnable,
      this.labelText,
      this.hintText,
      this.value,
      this.isError = false,
      this.isNumberInput = false,
      this.errorText,
      this.onChanged,
      this.padding = 4.0,
      this.maxLines = 1,
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
                enabled: this.isEnable ,
                maxLines: maxLines,
                cursorColor: primaryColor,
                keyboardType:
                    isNumberInput ? TextInputType.number : TextInputType.text,
                style: TextStyle(color: Colors.black, fontSize: 16),
                initialValue: value,
                onChanged: onChanged,
                decoration: InputDecoration(
                  errorText: isError ? errorText : null,
                  hintText: hintText,
                  hintStyle: TextStyle(
                      color: textHintColor, fontStyle: FontStyle.italic),
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
