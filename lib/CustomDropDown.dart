import 'package:flutter/material.dart';
import 'package:my_app/primaryThemeColor.dart';

class CustomDropDown extends StatelessWidget {
  final String title;
  final String value;
  final String? hintText;
  final bool isError;
  final String? errorText;
  final int maxLines;
  final Function()? onPress;
  final IconData icon;

  const CustomDropDown(
      {Key? key,
      required this.title,
      required this.value,
      this.isError = false,
      this.errorText,
      this.maxLines = 1,
      this.onPress,
      this.hintText = "",
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    color: textTitleColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
                textAlign: TextAlign.left,
              ),
              TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16), // Set the padding here
                  ),
                ),
                onPressed: onPress,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: size.width * 0.9),
                      child: Container(
                        child: Text(
                          value.length > 0 ? value : hintText!,
                          maxLines: maxLines,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: value.length > 0
                                  ? Colors.black
                                  : textHintColor,
                              fontStyle: value.length > 0
                                  ? FontStyle.normal
                                  : FontStyle.italic),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Icon(
                      icon,
                      color: Color(0xFFBBC2C6),
                      size: 24,
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                // color: !isError ? textHintColor : Colors.red[900],
              ),
              Visibility(
                  visible: isError,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      errorText ?? "",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        // color: Colors.red[900],
                      ),
                    ),
                  ))
            ]));
  }
}
