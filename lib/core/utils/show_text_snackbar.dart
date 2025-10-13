import 'package:awesome_snackbar_content_new/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:nashik/core/constants/keys.dart';

void showTextSnackbar({
  ContentType? contentType,
  String? title,
  required String text,
}) {
  scaffoldMessangerKey.currentState
    ?..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: title ?? '',
          message: text,
          contentType: contentType ?? ContentType.success,
          inMaterialBanner: true,
        ),
      ),
    );
}
