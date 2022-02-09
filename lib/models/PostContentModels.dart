class PostContentModels {
  String content;
  String createBy;
  String topic;
  DateTime createAt;
  List recommentForDieases;
  String recommentForAge;
  int recommentForBMI;

  PostContentModels(
      {this.content,
      this.createBy,
      this.topic,
      this.createAt,
      this.recommentForDieases,
      this.recommentForAge,
      this.recommentForBMI});
}
