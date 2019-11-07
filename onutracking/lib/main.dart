import 'package:flutter/material.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
// import 'package:flutter_line_sdk_example/src/screen/home_page.dart';

import 'src/app.dart';

void main() {
  LineSDK.instance.setup("1653459898").then((_) {
    print("LineSDK Prepared");
  });
  runApp(App());
  // runApp(HomePage());
}
