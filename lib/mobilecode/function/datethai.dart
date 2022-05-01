  import 'package:intl/intl.dart';

DateThai(var dateTh){
    var year = DateFormat('yyyy').format(DateTime.parse(dateTh)).toString();
    var month = DateFormat('MM').format(DateTime.parse(dateTh)).toString();
    var day = DateFormat('d').format(DateTime.parse(dateTh)).toString();
    var yearTH = 543 + num.parse(year);
      switch (month) {
    case "01":
    month = "ม.ค.";
      break;
    case "02":
    month = "ก.พ.";
      break;
    case "03":
    month = "มี.ค.";
      break;
    case "04":
    month = "เม.ย.";
      break;
    case "05":
    month = "พ.ค.";
      break;
    case "06":
    month = "มิ.ย.";
      break;
    case "07":
    month = "ก.ค.";
      break;
    case "08":
    month = "ส.ค.";
      break;
    case "09":
    month = "ก.ย.";
      break;
    case "10":
    month = "ต.ค.";
      break;
    case "11":
    month = "พ.ย.";
      break;
    case "12":
    month = "ธ.ค.";
      break;
  }
  return "$day $month $yearTH";
  }



class stepper{
num stepp = 0;
// stepper({this.stepp});
stepper();
}