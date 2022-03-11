String listNcds(List ncds) {
  List ncdsListThai = [];
  for (var i = 0; i < ncds.length; i++) {
    // print(ncds[i]);
    if (ncds[i] == "fat") {
      ncdsListThai.add("โรคอ้วน");
    } else if (ncds[i] == "diabetes") {
      ncdsListThai.add("โรคเบาหวาน");
    } else if (ncds[i] == "hypertension") {
      ncdsListThai.add("โรคความดันโลหิต");
    }
  }
  return ncdsListThai.toString().replaceAll('[', '').replaceAll(']', '');
}
