import 'package:flutter/material.dart';

class AppTextStyle {
  static TextStyle titleTextStyle(BuildContext context) {
    return const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w300,
      height: 18 / 15,
    );
  }

  static TextStyle dateTextStyle(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w700,
      height: 18 / 15,
      color: color,
    );
  }

  static TextStyle backItemTextStyle(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w300,
      height: 17 / 14,
      color: color,
    );
  }

  static TextStyle topMenuTextStyleLight(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w300,
      height: 15 / 12,
      color: color,
    );
  }

  static TextStyle topMenuTextStyleSemiBold(BuildContext context,
      {Color? color}) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 15 / 12,
      color: color,
    );
  }

  static TextStyle topMenuTextStyle(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      height: 15 / 12,
      color: color,
    );
  }

  static TextStyle secondNameTextStyle(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      height: 17 / 14,
      color: color,
    );
  }

  static TextStyle doctorTitleTextStyle(BuildContext context) {
    return const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w300,
      height: 15 / 13,
    );
  }

  static TextStyle buttonTextStyle(BuildContext context) {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w300,
      height: 19 / 16,
    );
  }

  static TextStyle buttonTextStyleSemiBold(BuildContext context) {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 19 / 16,
    );
  }

  static TextStyle mainTextStyleBold(BuildContext context) {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      height: 19 / 16,
    );
  }

  static TextStyle exlTitleTextStyle(BuildContext context) {
    return const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w300,
      height: 20 / 13,
    );
  }

  static TextStyle bottomNavBarTextStyle(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w300,
      height: 12 / 10,
      color: color,
    );
  }

  static TextStyle dolznostTextStyle(BuildContext context, {Color? color}) {
    return TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w300,
      height: 13 / 11,
      color: color,
    );
  }
}
