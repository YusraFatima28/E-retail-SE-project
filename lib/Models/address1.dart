class AddressModel {
  String name;
  String phoneNumber;
  String homeAddress;
  //String city;
  //String state;
  String pinCode;
  AddressModel(
      {this.name,
        this.phoneNumber,
        this.homeAddress,
        //this.city,
        //this.state,
        this.pinCode});
  AddressModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    phoneNumber = json['phoneNumber'];
    homeAddress = json['homeAddress'];
    //city = json['city'];
    //state = json['state'];
    pinCode = json['pinCode'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["name"] = this.name;
    data['phoneNumber'] = this.phoneNumber;
    data['homeAddress'] = this.homeAddress;
    //data['city'] = this.city;
    //data['state'] = this.state;
    data['pinCode'] = this.pinCode;
    return data;
  }
}