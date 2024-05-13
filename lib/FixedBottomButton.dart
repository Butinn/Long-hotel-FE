import 'package:flutter/material.dart';
import 'package:my_app/primaryThemeColor.dart';

class FixedBottomButton extends StatelessWidget {
  final String text;
  final bool border;
  final double fontSize, iconSize, spaceIconText, height;
  final Function()? press;
  final Color color, textColor, iconColor;
  const FixedBottomButton({
    Key? key,
    required this.text,
    this.fontSize = 15,
    this.iconSize = 14,
    this.iconColor = Colors.white,
    this.spaceIconText = 4,
    this.border = false,
    required this.height,
    this.press,
    this.color = primaryColor,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: border
          ? BoxDecoration(
        border: Border.all(
            color: textColor, // Set border color
            width: 1.0), // Set border width
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      )
          : null,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size.fromHeight(height),
              //primary: primaryColor,
            ),
            onPressed: press,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: textColor,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}