import 'package:flutter/material.dart';
import '../dilogs/exit_confirmation_dialog.dart';

class DialogHelper {
  static exit(context) => showDialog(context: context, builder: (context) => ExitConfirmationDialog());
}