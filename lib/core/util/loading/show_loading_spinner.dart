import 'package:flutter/material.dart';

import 'page_loading_spinner.dart';

/// Shows a loading spinner dialog with proper barrier configuration
/// Returns a Future that completes when the dialog is shown
Future<dynamic> showLoadingSpinner(BuildContext context) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return const PopScope(
        canPop: false,
        child: Center(child: PageLoadingSpinner()),
      );
    },
  );
}
