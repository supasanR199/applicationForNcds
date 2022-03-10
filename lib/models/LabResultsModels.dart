class LabResultsModels {
  String weight;
  String height;
  String waistline;
  String bmi;
  String pulse;
  String breathe;
  String bloodpressure;
  String DTX;
  String FBSFPG;
  String Hb1c;
  String BUN;
  String Cr;
  String LDL;
  String HDL;
  String Chol;
  String Microalbumin;
  String Uricacid;
  String Proteininurine;
  String Eyetest;
  String Tg;
  String Other;
  DateTime createAt;

  LabResultsModels(
      {this.weight,
      this.height,
      this.bmi,
      this.waistline,
      this.pulse,
      this.breathe,
      this.bloodpressure,
      this.DTX,
      this.FBSFPG,
      this.Hb1c,
      this.BUN,
      this.Cr,
      this.LDL,
      this.HDL,
      this.Chol,
      this.Uricacid,
      this.Microalbumin,
      this.Proteininurine,
      this.Eyetest,
      this.Tg,
      this.Other,
      this.createAt});
}
