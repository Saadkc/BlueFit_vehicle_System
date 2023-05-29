class StudyFile {
  final String name;
  final String url;
  final String chapterId;
  final String classDivisonId;
  final String subjectId;

  StudyFile(
      {required this.name,
      required this.url,
      required this.chapterId,
      required this.classDivisonId,
      required this.subjectId});

  StudyFile copyWith({
    String? newName,
    String? newUrl,
    String? newchapterId,
    String? newClassDivisionId,
    String? newSubjectID,
  }) {
    return StudyFile(
        name: newName ?? name,
        url: newUrl ?? url,
        chapterId: newchapterId ?? chapterId,
        classDivisonId: newClassDivisionId ?? classDivisonId,
        subjectId: newSubjectID ?? subjectId);
  }
}
