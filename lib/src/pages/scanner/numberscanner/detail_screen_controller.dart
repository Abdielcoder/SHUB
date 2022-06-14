
import 'package:flutter/widgets.dart';

class DetailScreenController {
  BuildContext context;
  Function refresh;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

  }

  void close() {
    refresh();
  }

}