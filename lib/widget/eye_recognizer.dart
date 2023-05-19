import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import '../classifier/classifier.dart';
import '../styles.dart';
import 'photo.dart';

const _labelsFileName = 'assets/labels.txt';
const _modelFileName = 'model_unquant.tflite';

class EyeRecognizer extends StatefulWidget {
  // 눈 이미지 인식 화면의 상태 관리
  const EyeRecognizer({super.key});

  @override
  State<EyeRecognizer> createState() => _EyeRecognizerStzer();
}

enum _ResultStatus {
  notStarted,
  notFound,
  found,
}

class _EyeRecognizerStzer extends State<EyeRecognizer> {
  bool _isAnalyzing = false; // 분석중인지 여부를 나타내는 변수
  final picker = ImagePicker(); // 이미지 선택을 위한 인스턴스
  File? _selectedImageFile; // 선택된 이미지 파일을 나타내는 변수

  // Result
  _ResultStatus _resultStatus =
      _ResultStatus.notStarted; // 분석 결과 상태를 나타내는 열거형 변수
  // 분석 시작되지 않음(notStarted), 인식 실패(notFound), 인식 성공(found) 중 하나의 값이 할당됨
  String _eyeLabel = ''; // 인식된 눈의 레이블을 나타내는 변수
  double _accuracy = 0.0; // 인식 정확도를 나타내는 변수

  late Classifier _classifier;

  @override
  void initState() {
    super.initState();
    _loadClassifier();
  }

  Future<void> _loadClassifier() async {
    // 분류 모델 로드
    debugPrint(
      'Start loading of Classifier with '
      'labels at $_labelsFileName, '
      'model at $_modelFileName',
    );

    final classifier = await Classifier.loadWith(
      labelsFileName: _labelsFileName,
      modelFileName: _modelFileName,
    );
    _classifier = classifier!;
  }

  @override
  Widget build(BuildContext context) {
    // 화면 구성 위젯 트리
    return Container(
      color: kBgColor,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: _buildTitle(),
          ),
          const SizedBox(height: 20),
          _buildPhotolView(),
          const SizedBox(height: 10),
          _buildResultView(),
          const Spacer(flex: 5),
          _buildPickPhotoButton(
            title: '사진 촬영',
            source: ImageSource.camera,
          ),
          _buildPickPhotoButton(
            title: '갤러리에서 가져오기',
            source: ImageSource.gallery,
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildPhotolView() {
    // 눈 이미지 표시 위젯
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        EyePhotoView(file: _selectedImageFile),
        _buildAnalyzingText(),
      ],
    );
  }

  Widget _buildAnalyzingText() {
    // 분석 중인지 나타내는 텍스트 위젯
    if (!_isAnalyzing) {
      return const SizedBox.shrink();
    }
    return const Text('분석 중...', style: kAnalyzingTextStyle);
  }

  Widget _buildTitle() {
    return const Text(
      '우리 EYE',
      style: kTitleTextStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPickPhotoButton({
    required ImageSource source,
    required String title,
  }) {
    return TextButton(
      onPressed: () => _onPickPhoto(source),
      child: Container(
        width: 300,
        height: 50,
        color: kColorBrown,
        child: Center(
            child: Text(title,
                style: const TextStyle(
                  fontFamily: kButtonFont,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: kColorLightYellow,
                ))),
      ),
    );
  }

  void _setAnalyzing(bool flag) {
    // 분석 중인지 업데이트
    setState(() {
      _isAnalyzing = flag;
    });
  }

  void _onPickPhoto(ImageSource source) async {
    // 사진 선택시 호출되는 함수
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile == null) {
      return;
    }

    final imageFile = File(pickedFile.path);
    setState(() {
      _selectedImageFile = imageFile;
    });

    _analyzeImage(imageFile);
  }

  void _analyzeImage(File image) {
    // 선택한 이미지를 분석하여 결과를 업데이트
    _setAnalyzing(true);

    final imageInput = img.decodeImage(image.readAsBytesSync())!;

    final resultCategory = _classifier.predict(imageInput);

    final result = resultCategory.score >= 0.8
        ? _ResultStatus.found
        : _ResultStatus.notFound;
    final eyeLabel = resultCategory.label;
    final accuracy = resultCategory.score;

    _setAnalyzing(false);

    setState(() {
      _resultStatus = result;
      _eyeLabel = eyeLabel;
      _accuracy = accuracy;
    });
  }

  Widget _buildResultView() {
    // 분석 결과 표시 위젯
    var title = '';

    if (_resultStatus == _ResultStatus.notFound) {
      title = '인식에 실패하였습니다.';
    } else if (_resultStatus == _ResultStatus.found) {
      title = _eyeLabel;
    } else {
      title = '';
    }

    //
    var accuracyLabel = '';
    if (_resultStatus == _ResultStatus.found) {
      accuracyLabel = '정확도: ${(_accuracy * 100).toStringAsFixed(2)}%';
    }

    return Column(
      children: [
        Text(title, style: kResultTextStyle),
        const SizedBox(height: 10),
        Text(accuracyLabel, style: kResultRatingTextStyle)
      ],
    );
  }
}
