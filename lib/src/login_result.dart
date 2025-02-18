import 'dart:convert';

class LoginResult {
  static LoginResult fromString(String text) =>
      LoginResult.fromJson(json.decode(text));

  String? authId;
  String? openId;
  LoginUser? user;

  LoginResult({  this.authId, this.openId,this.user});

  LoginResult.fromJson(Map<String, dynamic> json) {
    authId = json['authId'].toString();
    openId = json['openId'].toString();
    if(json['user']!=null) {
      user = LoginUser.fromJson(json['user']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        data[key] = value;
      }
    }

    writeNotNull('authId', authId);
    writeNotNull('openId', openId);
    writeNotNull('user', user?.toJson());
    return data;
  }

  @override
  String toString()=>json.encode(toJson());
}


class LoginUser{

  LoginUser({this.id, this.fullName,
    this.firstName, this.middleName,
    this.lastName,this.phone, this.email});

  String? id;
  String? fullName;
  String? firstName;
  String? middleName;
  String? lastName;
  String? phone;
  String? email;

  factory LoginUser.fromString(String text) => LoginUser.fromJson(json.decode(text));
  static List<LoginUser>? fromStringAsList(String text) => json.decode(text).map<LoginUser>((item) => LoginUser.fromJson(item)).toList();
  static List<LoginUser> fromJsonAsList(List<dynamic> json) => json.map<LoginUser>((item) => LoginUser.fromJson(item)).toList();
  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$LoginUserToJson`.
  @override
  String toString() => json.encode(toJson());
  static String toListString(var list) => json.encode(toListJson(list));
  static List<dynamic>? toListJson(var list) =>list?.map((item) => item.toJson()).toList();

  LoginUser.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    fullName = json['fullName'].toString();
    firstName = json['firstName']?.toString();
    middleName = json['middleName']?.toString();
    lastName = json['lastName']?.toString();
    phone = json['phone']?.toString();
    email = json['email']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        data[key] = value;
      }
    }
    data["id"] = id;
    data["fullName"] = fullName;
    data["firstName"] = firstName;
    data["middleName"] = middleName;
    data["lastName"] = lastName;
    data["phone"] = phone;
    data["email"] = email;

    /*writeNotNull('id', id);
    writeNotNull('fullName', fullName);
    writeNotNull('firstName', firstName);

    writeNotNull('middleName', middleName);
    writeNotNull('lastName', lastName);
    writeNotNull('phone', phone);
    writeNotNull('email', email);*/

    return data;
  }
}