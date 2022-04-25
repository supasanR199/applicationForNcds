import 'package:cloud_firestore/cloud_firestore.dart';

List<QueryDocumentSnapshot> getFilter(
    List<QueryDocumentSnapshot> snap, String valueFlitter, String flitter) {
  List<QueryDocumentSnapshot> getReturn = List();
  snap.forEach((element) {
    if (element.get(flitter) == valueFlitter) {
      getReturn.add(element);
    }
  });
  // print(getReturn.toList());
  return getReturn;
}

List<QueryDocumentSnapshot> getFilterSerach(
    List<QueryDocumentSnapshot> snap, String valueFlitter) {
  List<QueryDocumentSnapshot> getReturn = List();
  getReturn = snap
      .where((user) => user.get("Firstname").contains(valueFlitter))
      .toList();
  // snap.forEach((element) {
  //   if (element.get(flitter) == valueFlitter) {
  //     getReturn.add(element);
  //   }
  // });
  // print(getReturn.toList());
  return getReturn;
}
