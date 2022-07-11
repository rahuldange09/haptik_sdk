class SignupData {
  String authCode;
  String authId;
  String? userName;
  String? email;
  String? mobileNo;
  String? signupType;
  Map<String, dynamic>? customData;

  SignupData({
    required this.authCode,
    required this.authId,
    this.userName,
    this.email,
    this.mobileNo,
    this.signupType,
    this.customData,
  });

  Map<String, dynamic> toJson() => {
        'authCode': authCode,
        'authId': authId,
        'userName': userName,
        'email': email,
        'mobileNo': mobileNo,
        'signupType': signupType,
        'customData': customData,
      };
}
