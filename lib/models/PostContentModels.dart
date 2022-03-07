class PostContentModels {
  String content;
  String createBy;
  String topic;
  DateTime createAt;
  List recommentForDieases;
  int recommentForAge;
  // List<dynamic> recommentForBMI = List();
  int recommentForBMI;
  int recommentForBMR;
  int recommentForTDEE;

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
