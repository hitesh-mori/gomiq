
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double height;
  final double width;
  final double? loadWidth;
  final String title;
  final Color textColor;
  final Color bgColor;
  final VoidCallback onTap;
  final double textSize;
  final bool isLoading;

  CustomButton({
    super.key,
    required this.height,
    required this.width,
    this.loadWidth,
    required this.textColor,
    required this.bgColor,
    required this.onTap,
    required this.title,
    this.isLoading = false,
    this.textSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Center(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          height: height,
          width: isLoading ? loadWidth ?? width : width,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: isLoading
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 15,
                  width: 15,
                  child: Center(child: CircularProgressIndicator(color: textColor)),
                ),
                SizedBox(width: 10),
                Text(
                  "Wait...",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: textSize,
                  ),
                ),
              ],
            )
                : Text(
              title,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: textSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}