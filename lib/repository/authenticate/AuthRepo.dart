import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:bachat_mart/generated/l10n.dart';
import 'package:sign_in_apple/apple_id_user.dart';
import 'package:sign_in_apple/sign_in_apple.dart';
import '../../controller/mutations/login.dart';
import '../../models/newmodle/user.dart';
import '../../repository/api.dart';
import '../../utils/prefUtils.dart';
import 'package:bachat_mart/constants/api.dart' as apis;
import "package:http/http.dart" as http;
import 'package:sms_autofill/sms_autofill.dart';
import 'package:velocity_x/velocity_x.dart';

class Auth {
  var _authresponse;

  Future<AuthData> facebookLogin(returns) async {
    final _facebookLogin = FacebookLogin();

    _facebookLogin.loginBehavior =
    Platform.isIOS ? FacebookLoginBehavior.webViewOnly : FacebookLoginBehavior
        .nativeWithFallback; //FacebookLoginBehavior.webViewOnly; _facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    final result = await _facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final response = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,picture,email&access_token=${result
                .accessToken.token}');

        Map<String, dynamic> map = json.decode(response.body);

        _isnewUser(map["email"]).then((value) {
          _authresponse = returns(AuthData(code: response.statusCode,
              messege: "Login Success",
              status: true,
              data: SocialAuthUser.fromJson(SocialAuthUser.fromJson(map).toJson(newuser: value.type=="old"?false:true,id: value.apikey))));
        });
        // TODO: Handle this case.
        break;
      case FacebookLoginStatus.cancelledByUser:
        _authresponse = returns(AuthData(
            code: 200, messege: "Login Canceled by User", status: false));
        // TODO: Handle this case.
        break;
      case FacebookLoginStatus.error:
        _authresponse = returns(
            AuthData(code: 200, messege: result.errorMessage, status: false));
        // TODO: Handle this case.
        break;
    }
    return Future.value(_authresponse);
  }

  Future<AuthData> googleLogin(returns) async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: <String>[
        'email', /*'https://www.googleapis.com/auth/contacts.readonly',*/
      ],
    );
    final response = await _googleSignIn.signIn();
    response!.authentication.then((value) {
      _isnewUser(response.email).then((value) =>
          returns(AuthData(code: 200,
              messege: "Login Success",
              status: true,
              data: SocialAuthUser(email: response.email,
                  firstName: response.displayName,
                  id: value.apikey,
                  lastName: "",
                  name: response.displayName,
                  picture: Picture(data: Data(url: response.photoUrl)),
                  newuser: value.type=="old"?false:true))));
    }).onError((error, stackTrace) {
      _authresponse = AuthData(code: 200, messege: error.toString(), status: false);
      returns(_authresponse);
    });
    return Future.value(_authresponse);
  }

  Future<AuthData?> phoneNumberAuth(mobile, Function(LoginData, AuthData) otp) async {
    Api api = Api();
    final response = json.decode(
        await api.Geturl("customer/pre-register?mobileNumber=$mobile&signature=${Vx.isWeb? "":await SmsAutoFill().getAppSignature}&tokenId=${PrefUtils.prefs!.getString('ftokenid')}&branch=${PrefUtils.prefs!.getString("branch")}"));
   debugPrint("sp........"+PrefUtils.prefs!.getString('ftokenid').toString());
    debugPrint("response..." + response["type"].toString() + " " +
        response/*["data"]*/.toString());
    if (response["type"] == "new") {
      _authresponse = AuthData(code: 200,
          messege: "Login Success",
          status: true,
          data: SocialAuthUser(newuser: true));
      otp(LoginData.fromJson(response["data"]), _authresponse);
    } else {
      PrefUtils.prefs!.setString("apikey", response["userID"].toString());
      getuserProfile(onsucsess: (value) {
        _authresponse = AuthData(code: 200,
            messege: "Login Success",
            status: true,
            data: SocialAuthUser(newuser: false, id: value.id));
        otp(LoginData.fromJson(response["data"]), _authresponse);
      }, onerror: (){

      });
    }
  }
  
  ioslogin(Function(AuthData) returns,Function(String) errors)async {
    PrefUtils.prefs!.setString('applesignin', "yes");
    // _dialogforProcessing();
    PrefUtils.prefs!.setString('skip', "no");
    if (await SignInApple.canUseAppleSigin()) {
      /// AppleIdUser(name: ,mail: ,userIdentifier: ,authorizationCode: ,identifyToken: )
      SignInApple.handleAppleSignInCallBack(onCompleteWithSignIn: (AppleIdUser? appleidentifier) async {
        // print("flutter receiveCode: \n");
        // print(authorizationCode);
        // print("flutter receiveToken \n");
        // print(identifyToken);
        // setState(() {
        //   _name = name;
        //   _mail = mail;
        //   _userIdentify = userIdentifier;
        //   _authorizationCode = authorizationCode;
        // });

        _isnewUserApple(appleidentifier!.userIdentifier).then((value) => returns(AuthData(code: 200,
        messege: "Login Success",
        status: true,
        data: SocialAuthUser(email:appleidentifier.mail!,
        firstName: appleidentifier.familyName!,
        id: value.apikey,
        lastName: "",
        name: appleidentifier.name!,
        picture: Picture(data: Data(url:"")),
        newuser: value.type=="old"?false:true))));

      }, onCompleteWithError: (AppleSignInErrorCode code) async {
        var errorMsg = "unknown";
        switch (code) {
          case AppleSignInErrorCode.canceled:
            errorMsg = S.current.sign_in_cancelledbyuser;
            break;
          case AppleSignInErrorCode.failed:
            errorMsg =  S.current.sign_in_failed;
            break;
          case AppleSignInErrorCode.invalidResponse:
            errorMsg =S.current.apple_signin_not_available_forthis_device;
            break;
          case AppleSignInErrorCode.notHandled:
            errorMsg = S.current.apple_signin_not_available_forthis_device;
            break;
          case AppleSignInErrorCode.unknown:
            errorMsg = S.current.apple_signin_not_available_forthis_device;
            break;
        }
        print(errorMsg);
        errors(errorMsg);
      });
      SignInApple.clickAppleSignIn();
    } else {
      errors(S.current.apple_signin_not_available_forthis_device);
    }
  }
  userRegister(RegisterAuthBodyParm body, { required Function onSucsess, onError}) async {
    Api api = Api();
    api.body = body.toJson();
    final regresp = json.decode(await api.Posturl("customer/register"));
    debugPrint("status.." + regresp["status"].toString());
    if (regresp["status"]) {
      PrefUtils.prefs!.setString("apikey", regresp["userId"].toString());
      getuserProfile(onsucsess: (UserData data) => onSucsess(data),
          onerror: (messege) => onError(messege));
    } else {
      onError(regresp["data"]);
    }
  }
  
  _emailelogin(){
    
  }
  getuserProfile({required Function(UserData) onsucsess,required onerror}) async {
  print("calling get profile api ${PrefUtils.prefs!.containsKey("ftokenid")}");
    if(PrefUtils.prefs!.containsKey("apikey")) {
      Api api = Api();
      print("log...."+PrefUtils.prefs!.getString("apikey").toString());
      final resp = UserModle.fromJson(json.decode(await api.Geturl("customer/get-profile?apiKey=${PrefUtils.prefs!.getString("apikey")}&branch=${PrefUtils.prefs!.getString("branch")}")));
      if (resp.status!) {
        print('loged user branch...' + resp.data![0].toJson().toString()+ "current branch ${PrefUtils.prefs!.getString("branch")}");
        final response = UserModle(status: resp.status,notificationCount: resp.notificationCount,prepaid: resp.prepaid,
        data: [UserData.fromJson(resp.data!.first.toJson(branch: PrefUtils.prefs!.getString("branch")))]);
        SetUserData(response);
        onsucsess(UserData.fromJson(resp.data![0].toJson(branch: PrefUtils.prefs!.getString("branch"))));
        // return Future.value(UserData.fromJson(resp["data"][0]));
      } else {
        api.body={
          "token":PrefUtils.prefs!.getString("ftokenid")!,
          "device":"android"
        };
        PrefUtils.prefs!.setString(
            "tokenid", json.decode(await api.Posturl("customer/register/guest/user",isv2: false))["guestUserId"]);
        onerror();
        // return null;
      }
    }
    else{
      Api api = Api();

      api.body={
        "token":PrefUtils.prefs!.getString("ftokenid")!,
        "device":"android"
      };

      PrefUtils.prefs!.setString("tokenid", (json.decode(await api.Posturl("customer/register/guest/user",isv2: false))["guestUserId"]).toString());
      debugPrint("tokenid..."+PrefUtils.prefs!.getString("tokenid")!);

      onerror();
    }
    // else {
    //   PrefUtils.prefs!.setString("tokenid", json.decode(await api.Geturl("url"))["guestUserId"]);
    //  }
  }

  Future<String> getuserNotificationCount(apikey) async {
    Api api = Api();
    print("userid $apikey");
    return Future.value(json.decode(await api.Geturl(
        "customer/get-profile?apiKey=$apikey&branch=${PrefUtils.prefs!.getString("branch")}"))["notification_count"]);
  }

  Future<EmailResponse> _isnewUser(String email) async {
    Api api = Api();

    return EmailResponse.fromJson(json.decode(
        await api.Posturl("customer/email-check?email=$email")));
  }
  Future<EmailResponse> _isnewUserApple(String appleid) async {
    Api api = Api();

    api.body = {
      "email":appleid,
    "tokenId":PrefUtils.prefs!.getString("ftokenid")!
    };
    return EmailResponse.fromJson(json.decode(
        await api.Posturl("customer/email-login")));
  }
}
class EmailResponse {
  bool? status;
  String? type;
  String? apikey;

  EmailResponse({required this.status, required this.type, required this.apikey});

  EmailResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    type = json['type'];
    apikey = json['apikey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['type'] = this.type;
    data['apikey'] = this.apikey;
    return data;
  }
}

final auth = Auth();
class AuthData {
  bool? status;
  String? messege;
  int? code;
  SocialAuthUser? data;

  AuthData({required this.status, required this.messege, required this.code, this.data});

  AuthData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    messege = json['messege'];
    code = json['code'];
    data = json['data'] != null ? new SocialAuthUser.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['messege'] = this.messege;
    data['code'] = this.code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
class RegisterAuthBodyParm {
  String? username;
  String? email;
  String? path;
  String? tokenId;
  String? guestUserId;
  String? branch;
  String? referralid;
  String? device;
  String? mobileNumber;

  RegisterAuthBodyParm(
      {required this.username,
        required this.email,
        required this.path,
        required this.guestUserId,
        required this.tokenId,
        required this.branch,
        required this.referralid,
        required this.mobileNumber,
        required this.device});

  RegisterAuthBodyParm.fromJson(Map<String, String> json) {
    username = json['username'];
    email = json['email'];
    path = json['path'];
    tokenId = json['tokenId'];
    guestUserId = json['guestUserId'];
    branch = json['branch'];
    referralid = json['referralid'];
    device = json['device'];
    mobileNumber = json['mobileNumber'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = new Map<String, String>();
    data['username'] = this.username!;
    data['email'] = this.email!;
    data['path'] = this.path!;
    data['guestUserId'] = this.guestUserId!;
    data['tokenId'] = this.tokenId!;
    data['branch'] = this.branch!;
    data['referralid'] = this.referralid!;
    data['device'] = this.device!;
    data['mobileNumber'] = this.mobileNumber!;
    return data;
  }
}
class LoginData {
  int? otp;
  int? apiKey;

  LoginData({this.otp,this.apiKey});

  LoginData.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    apiKey = json['apiKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp'] = this.otp;
    data['apiKey'] = this.apiKey;
    return data;
  }
}