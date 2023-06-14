import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import '../styles.dart';

class DiseaseInfo {
  final String name;

  DiseaseInfo({required this.name});
}

List<DiseaseInfo> diseases = [
  DiseaseInfo(name: '각막궤양'),
  DiseaseInfo(name: '각막부골편'),
  DiseaseInfo(name: '결막염'),
  DiseaseInfo(name: '비궤양성각막염'),
  DiseaseInfo(name: '안검염'),
];

void showDiseaseList(BuildContext context) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('질병 정보 👀', style: TextStyle(fontFamily: kButtonFont)),
        content: SingleChildScrollView(
          child: Column(
            children: diseases.map((disease) {
              return ListTile(
                title: Text(disease.name),
                onTap: () {
                  showDiseaseDetails(context, disease);
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            child: Text('닫기'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> showDiseaseDetails(BuildContext context, DiseaseInfo disease) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return FutureBuilder<String>(
        future: readTextFile(disease.name),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('정보를 불러오는 데에 실패하였습니다.');
          } else {
            return AlertDialog(
              title: Text(disease.name),
              content: SingleChildScrollView(
                child: Text(snapshot.data ?? ''),
              ),
              actions: [
                TextButton(
                  child: Text('닫기'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
        },
      );
    },
  );
  return Future.value();
}

Future<String> readTextFile(String fileName) async {
  try {
    String content =
        await rootBundle.loadString('assets/diseases/$fileName.txt');
    return content;
  } catch (e) {
    print('Error reading file: $e');
  }
  return '';
}
