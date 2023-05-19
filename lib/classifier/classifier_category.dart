class ClassifierCategory {
  final String label;
  // 카테고리의 레이블을 나타내는 문자열
  final double score;
  // 해당 카테고리의 점수를 나타내는 값

  ClassifierCategory(this.label, this.score);

  @override
  String toString() {
    return 'Category{label: $label, score: $score}';
  }
}
