import 'package:intl/intl.dart';

DateThai(var dateTh) {
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

DateThaiAndTime(var dateTh) {
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
  return "$day $month ";
}

DateMouthAndYearThai(var dateTh) {
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
  return "$month $yearTH";
}

DateThaiByList(List<DateTime> dateList) {
  print(dateList.length);
  if (dateList.length > 1) {
    var year0 = DateFormat('yyyy')
        .format(DateTime.parse(dateList.first.toString()))
        .toString();
    var month0 = DateFormat('MM')
        .format(DateTime.parse(dateList.first.toString()))
        .toString();
    var day0 = DateFormat('d')
        .format(DateTime.parse(dateList.first.toString()))
        .toString();
    var yearTH0 = 543 + num.parse(year0);
    var year1 = DateFormat('yyyy')
        .format(DateTime.parse(dateList.last.toString()))
        .toString();
    var month1 = DateFormat('MM')
        .format(DateTime.parse(dateList.last.toString()))
        .toString();
    var day1 = DateFormat('d')
        .format(DateTime.parse(dateList.last.toString()))
        .toString();
    var yearTH1 = 543 + num.parse(year1);

    switch (month0) {
      case "01":
        month0 = "ม.ค.";
        break;
      case "02":
        month0 = "ก.พ.";
        break;
      case "03":
        month0 = "มี.ค.";
        break;
      case "04":
        month0 = "เม.ย.";
        break;
      case "05":
        month0 = "พ.ค.";
        break;
      case "06":
        month0 = "มิ.ย.";
        break;
      case "07":
        month0 = "ก.ค.";
        break;
      case "08":
        month0 = "ส.ค.";
        break;
      case "09":
        month0 = "ก.ย.";
        break;
      case "10":
        month0 = "ต.ค.";
        break;
      case "11":
        month0 = "พ.ย.";
        break;
      case "12":
        month0 = "ธ.ค.";
        break;
    }
    switch (month1) {
      case "01":
        month1 = "ม.ค.";
        break;
      case "02":
        month1 = "ก.พ.";
        break;
      case "03":
        month1 = "มี.ค.";
        break;
      case "04":
        month1 = "เม.ย.";
        break;
      case "05":
        month1 = "พ.ค.";
        break;
      case "06":
        month1 = "มิ.ย.";
        break;
      case "07":
        month1 = "ก.ค.";
        break;
      case "08":
        month1 = "ส.ค.";
        break;
      case "09":
        month1 = "ก.ย.";
        break;
      case "10":
        month1 = "ต.ค.";
        break;
      case "11":
        month1 = "พ.ย.";
        break;
      case "12":
        month1 = "ธ.ค.";
        break;
    }
    return "$day0 $month0 $yearTH0 - $day1 $month1 $yearTH1";
  } else if (dateList.length == 1) {
    var year0 = DateFormat('yyyy')
        .format(DateTime.parse(dateList.first.toString()))
        .toString();
    var month0 = DateFormat('MM')
        .format(DateTime.parse(dateList.first.toString()))
        .toString();
    var day0 = DateFormat('d')
        .format(DateTime.parse(dateList.first.toString()))
        .toString();
    var yearTH0 = 543 + num.parse(year0);
    switch (month0) {
      case "01":
        month0 = "ม.ค.";
        break;
      case "02":
        month0 = "ก.พ.";
        break;
      case "03":
        month0 = "มี.ค.";
        break;
      case "04":
        month0 = "เม.ย.";
        break;
      case "05":
        month0 = "พ.ค.";
        break;
      case "06":
        month0 = "มิ.ย.";
        break;
      case "07":
        month0 = "ก.ค.";
        break;
      case "08":
        month0 = "ส.ค.";
        break;
      case "09":
        month0 = "ก.ย.";
        break;
      case "10":
        month0 = "ต.ค.";
        break;
      case "11":
        month0 = "พ.ย.";
        break;
      case "12":
        month0 = "ธ.ค.";
        break;
    }
    return "$day0 $month0 $yearTH0 ";
  }
  // var year = DateFormat('yyyy').format(DateTime.parse(dateTh)).toString();
  // var month = DateFormat('MM').format(DateTime.parse(dateTh)).toString();
  // var day = DateFormat('d').format(DateTime.parse(dateTh)).toString();
  // var yearTH = 543 + num.parse(year);
  // switch (month) {
  //   case "01":
  //     month = "ม.ค.";
  //     break;
  //   case "02":
  //     month = "ก.พ.";
  //     break;
  //   case "03":
  //     month = "มี.ค.";
  //     break;
  //   case "04":
  //     month = "เม.ย.";
  //     break;
  //   case "05":
  //     month = "พ.ค.";
  //     break;
  //   case "06":
  //     month = "มิ.ย.";
  //     break;
  //   case "07":
  //     month = "ก.ค.";
  //     break;
  //   case "08":
  //     month = "ส.ค.";
  //     break;
  //   case "09":
  //     month = "ก.ย.";
  //     break;
  //   case "10":
  //     month = "ต.ค.";
  //     break;
  //   case "11":
  //     month = "พ.ย.";
  //     break;
  //   case "12":
  //     month = "ธ.ค.";
  //     break;
  // }
  // return "$month $yearTH";
}

class stepper {
  num stepp = 0;
// stepper({this.stepp});
  stepper();
}
