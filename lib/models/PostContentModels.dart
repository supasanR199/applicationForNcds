class PostContentModels {
  String content;
  String createBy;
  String topic;
  DateTime createAt;
  List recommentForDieases;
  String recommentForAge;
  // List<dynamic> recommentForBMI = List();
  String recommentForBMI;
  String recommentForBMR;

  PostContentModels(
      {this.content,
      this.createBy,
      this.topic,
      this.createAt,
      this.recommentForDieases,
      this.recommentForAge,
      this.recommentForBMI,
      this.recommentForBMR});
}
