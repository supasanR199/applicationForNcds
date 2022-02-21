checkRoletoThai(String role){
  if(role ==  "hospital"){
    return "บุลากร รพสต.";
  }
  else if(role == "medicalpersonnel"){
    return "บุคลากรทางการแพทย์";
  }
  else if(role  ==  "Patient"){
    return "ผู้ป่วย";
  }
  else if(role  ==  "Volunteer"){
    return "อสม.";
  }
}