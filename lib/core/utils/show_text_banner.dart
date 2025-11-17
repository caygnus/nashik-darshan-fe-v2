import 'package:awesome_snackbar_content_new/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:nashik/core/constants/keys.dart';

void showTextBanner({
  ContentType? contentType,
  required String title,
  required String text,
}) {
  final materialBanner = MaterialBanner(
    /// need to set following properties for best effect of awesome_snackbar_content_new
    elevation: 0,
    backgroundColor: Colors.transparent,
    forceActionsBelow: true,
    content: AwesomeSnackbarContent(
      title: title,
      message: text,
      contentType: contentType ?? ContentType.success,
      inMaterialBanner: true,
    ),
    actions: const [SizedBox.shrink()],
  );
  scaffoldMessengerKey.currentState
    ?..hideCurrentMaterialBanner()
    ..showMaterialBanner(materialBanner);
}
