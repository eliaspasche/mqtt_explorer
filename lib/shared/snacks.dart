import 'package:flutter/material.dart';

/// Returns a error [SnackBar] in [Colors.red] with the given [title] and [subtitle].
SnackBar errorSnack(String title, [String? subtitle]) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.red,
    showCloseIcon: true,
    elevation: 1,
    duration: const Duration(seconds: 5),
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textScaleFactor: 1.1,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        if (subtitle != null) ...[Text(subtitle)]
      ],
    ),
  );
}

/// Returns a error [SnackBar] in [Colors.lightGreen] with the given [title] and [subtitle].
SnackBar successSnack(String title, [String? subtitle]) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.lightGreen,
    showCloseIcon: true,
    elevation: 1,
    duration: const Duration(seconds: 2),
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textScaleFactor: 1.1,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        if (subtitle != null) ...[Text(subtitle)]
      ],
    ),
  );
}
