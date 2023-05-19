import 'dart:io';
import 'package:flutter/material.dart';

import '../styles.dart';

class EyePhotoView extends StatelessWidget {
  final File? file;
  const EyePhotoView({super.key, this.file});

  @override
  Widget build(BuildContext context) {
    // 크기와 배경색 설정
    return Container(
      width: 250,
      height: 250,
      color: Colors.blueGrey,
      child: (file == null)
          ? _buildEmptyView() // 파일이 null일 경우
          : Image.file(file!, fit: BoxFit.cover), // 파일이 존재할 경우
    );
  }

  Widget _buildEmptyView() {
    // 파일이 업로드 되지 않았을 때 보이는 view
    return const Center(
        child: Text(
      '사진 업로드',
      style: kAnalyzingTextStyle,
    ));
  }
}
