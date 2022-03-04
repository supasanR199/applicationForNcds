import 'package:appilcation_for_ncds/models/KeepRecord.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/src/iterable_extensions.dart';

List getSumAllChoice(List<QueryDocumentSnapshot> snap, List<String> choice) {
  List returnList = List();
  List<KeepChoieAndSocre> keepData = List();
  List<KeepChoieAndSocre> keepDataReturn = List<KeepChoieAndSocre>();
  List<int> scoreList = List();
  snap.forEach((elements) {
    choice.forEach((element) {
      KeepChoieAndSocre _keepsweet =
          KeepChoieAndSocre(element, int.parse(elements.get(element)));
      keepData.add(_keepsweet);
    });
  });
  choice.forEach((element) {
    Iterable<KeepChoieAndSocre> sumIter =
        keepData.where((e) => e.choice.contains(element));
    sumIter.forEach((eSum) {
      scoreList.add(eSum.score);
    });
    KeepChoieAndSocre keepsumall = KeepChoieAndSocre(element, scoreList.sum);
    keepDataReturn.add(keepsumall);
  });

  returnList.add(
    keepDataReturn,
  );
  returnList.add(
      scoreList.reduce((curr, next) => curr > next ? curr : next).toDouble());
  return returnList;
}
