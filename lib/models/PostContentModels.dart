class PostContentModels {
  String content;
  String createBy;
  String topic;
  DateTime createAt;
  List recommentForDieases;
  List<dynamic> recommentForAge = List();
  List<dynamic> recommentForBMI = List();

  PostContentModels(
      {this.content,
      this.createBy,
      this.topic,
      this.createAt,
      this.recommentForDieases,
      this.recommentForAge,
      this.recommentForBMI});
}
