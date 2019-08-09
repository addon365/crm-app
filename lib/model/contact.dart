class Contact{
  String firstName;
  String mobileNumber;

  Contact({this.firstName, this.mobileNumber});

  static Contact fromJson(Map<String,dynamic> map){
    if(map==null)
      return null;
    return Contact(
      firstName: map["firstName"],
      mobileNumber: map["mobileNumber"]
    );
  }
}