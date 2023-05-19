import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widget/eye_recognizer.dart';

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    return MaterialApp(
      title: '우리 EYE',
      theme: ThemeData.light(),
      home: const EyeRecognizer(),
      debugShowCheckedModeBanner: false,
    );
  }
}
