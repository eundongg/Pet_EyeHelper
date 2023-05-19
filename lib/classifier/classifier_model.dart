import 'package:tflite_flutter/tflite_flutter.dart';

class ClassifierModel {
  Interpreter interpreter;
  // tflite 모델과 상호작용하기 위한 interpreter 객체

  List<int> inputShape; // 모델의 입력 shape
  List<int> outputShape; // 모델의 출력 shape

  TfLiteType inputType; // 모델의 입력 type, 열거형
  TfLiteType outputType; // 모델의 출력 type, 열거형

  ClassifierModel({
    required this.interpreter,
    required this.inputShape,
    required this.outputShape,
    required this.inputType,
    required this.outputType,
  });
}
