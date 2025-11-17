import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

Future<void> openUrl(
  String url, {
  LaunchMode mode = LaunchMode.platformDefault,
}) async {
  // Validate if the URL is empty
  if (url.isEmpty) {
    throw ArgumentError('URL cannot be empty');
  }

  // Try parsing the URL, catching any FormatException
  final Uri uri;
  try {
    uri = Uri.parse(url);
  } on FormatException catch (e) {
    throw ArgumentError('Invalid URL format: ${e.message}');
  }

  // Check if the URL can be launched (if there's a handler available)
  if (!await canLaunchUrl(uri)) {
    throw Exception('Cannot launch $url - no handler available');
  }

  // Try launching the URL with the specified LaunchMode
  if (!await launchUrl(uri, mode: mode)) {
    throw Exception('Could not launch $url');
  }
}
