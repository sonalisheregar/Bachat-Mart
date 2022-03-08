import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../constants/api.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../assets/ColorCodes.dart';
import '../../assets/images.dart';
import '../../constants/IConstants.dart';
import '../../constants/features.dart';
import '../../controller/mutations/login.dart';
import '../../generated/l10n.dart';
import '../../models/newmodle/user.dart';
import '../../repository/authenticate/AuthRepo.dart';
import '../../screens/home_screen.dart';
import '../../screens/policy_screen.dart';
import '../../services/firebaseAnaliticsService.dart';
import '../../utils/prefUtils.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;
import '../rought_genrator.dart';


class LoginWeb with Navigations {
  final _formweb = GlobalKey<FormState>();
  bool? _showOtp = false;
  Timer? _timer;
  int _timeRemaining = 30;
  final TextEditingController mobileNumbercontroller = new TextEditingController();
  final TextEditingController firstnamecontroller = new TextEditingController();
  final TextEditingController lastnamecontroller = new TextEditingController();
  final TextEditingController _referController = new TextEditingController();
  TextEditingController controller = TextEditingController();
  final _lnameFocusNode = FocusNode();
  String fn = "";
  String ln = "";
  String ea = "";
  String _appletoken = "";
  String channel = "";
  Auth _auth = Auth();
  Function(bool p1)? result;

  LoginWeb(context,{Function(bool)? result}){
    this.result = result;
   _dialogforsignIn(context);
  }
  _dialogforsignIn(context) {
    String countryName =  CountryPickerUtils.getCountryByPhoneCode(IConstants.countryCode.split('+')[1]).name;
    try {
      if (Platform.isIOS) {
        channel = "IOS";
      } else {
        channel = "Android";
      }
    } catch (e) {
      channel = "Web";
    }

    if (PrefUtils.prefs!.getString('applesignin') == "yes") {
      _appletoken = PrefUtils.prefs!.getString('apple')!;
    } else {
      _appletoken = "";
    }
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width/2.5,
                  child: Column(children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50.0,
                      color: ColorCodes.lightGreyWebColor,
                      padding: EdgeInsets.only(left: 20.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            S .of(context).signin,//"Sign in",
                            style: TextStyle(
                                color: ColorCodes.mediumBlackColor,
                                fontSize: 20.0),
                          )),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 30.0, bottom: 30.0, right: 30.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 32.0,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: 52,
                            margin: EdgeInsets.only(bottom: 8.0),
                            padding: EdgeInsets.only(
                                left: 10.0, top: 5.0, right: 5.0, bottom: 5.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                border: Border.all(
                                    width: 0.5, color: ColorCodes.darkGrey)
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  Images.countryImg,
                                ),
                                SizedBox(
                                  width: 14,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                        S .of(context).country_region,//"Country/Region",
                                        style: TextStyle(
                                          color: ColorCodes.greyColor,
                                        )),
                                    Text(countryName + " (" + IConstants.countryCode + ")",
                                        style: TextStyle(
                                            color: ColorCodes.blackColor,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: 52.0,
                            padding: EdgeInsets.only(
                                left: 10.0, top: 5.0, right: 5.0, bottom: 5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(
                                  width: 0.5, color: ColorCodes.darkGrey),
                            ),
                            child: Row(
                              children: <Widget>[
                                Image.asset(Images.phoneImg),
                                SizedBox(
                                  width: 14,
                                ),
                                Container(
                                    width:
                                    MediaQuery.of(context).size.width / 4.0,
                                    child: Form(
                                      key: _formweb,
                                      child: TextFormField(
                                        controller: mobileNumbercontroller,
                                        style: TextStyle(fontSize: 16.0),
                                        textAlign: TextAlign.left,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(12)
                                        ],
                                        cursorColor:
                                        Theme.of(context).primaryColor,
                                        keyboardType: TextInputType.number,
                                        autofocus: true,
                                        decoration: new InputDecoration.collapsed(
                                            hintText: 'Enter Your Mobile Number',
                                            hintStyle: TextStyle(
                                              color: ColorCodes.mediumBlackColor,
                                            )),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter a Mobile number.';
                                          }
                                          return null; //it means user entered a valid input
                                        },
                                        /*onSaved: (value) {
                                            addMobilenumToSF(value);
                                        },*/
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: 60.0,
                            margin: EdgeInsets.only(top: 8.0, bottom: 36.0),
                            child: Text(
                              S .of(context).we_will_call_or_text,//"We'll call or text you to confirm your number. Standard message data rates apply.",
                              style: TextStyle(
                                  fontSize: 13, color: ColorCodes.mediumBlackWebColor),
                            ),
                          ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                _dialogforProcessing(context);
                                  _saveForm(context,mobileNumbercontroller.text,setState);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.2,
                                height: 32,
                                padding: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                    width: 1.0,
                                    color: ColorCodes.greenColor,
                                  ),
                                ),
                                child: Text(
                                  S .of(context).login_using_otp,//"LOGIN USING OTP",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15.0,
                                      color: ColorCodes.blackColor),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: 60.0,
                            margin: EdgeInsets.only(top: 12.0, bottom: 32.0),
                            child: new RichText(
                              text: new TextSpan(
                                // Note: Styles for TextSpans must be explicitly defined.
                                // Child text spans will inherit styles from parent
                                style: new TextStyle(
                                  fontSize: 13.0,
                                  color: ColorCodes.blackColor,
                                ),
                                children: <TextSpan>[
                                  new TextSpan(
                                    text: S .of(context).agreed_terms,//'By continuing you agree to the '
                                  ),
                                  new TextSpan(
                                      text: S .of(context).terms_of_service,//' Terms of Service',
                                      style:
                                      new TextStyle(color: ColorCodes.darkthemeColor),
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigation(context, name: Routename.Policy, navigatore: NavigatoreTyp.Push,
                                              parms: {"title": "Terms of Use"/*, "body" :IConstants.restaurantTerms*/}
                                              );
                                        }),
                                  new TextSpan(text: S.of(context).and//' and'
                                  ),
                                  new TextSpan(
                                      text: S .of(context).privacy_policy,//' Privacy Policy',
                                      style:
                                      new TextStyle(color: ColorCodes.darkthemeColor),
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigation(context, name: Routename.Policy, navigatore: NavigatoreTyp.Push,
                                              parms: {"title": "Privacy"/*, "body" :PrefUtils.prefs!.getString("privacy").toString()*/}
                                              );
                                        }),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 30,
                            width: MediaQuery.of(context).size.width / 1.2,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    thickness: 0.5,
                                    color: ColorCodes.greyColor,
                                  ),
                                ),
                                Container(
                                  //padding: EdgeInsets.all(4.0),
                                  width: 23.0,
                                  height: 23.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: ColorCodes.greyColor,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                      child: Text(
                                        S .of(context).or,//"OR",
                                        style: TextStyle(
                                            fontSize: 10.0, color: ColorCodes.greyColor),
                                      )),
                                ),
                                Expanded(
                                  child: Divider(
                                    thickness: 0.5,
                                    color:ColorCodes.greyColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          /*Container(
                            height: 44,
                            width: MediaQuery.of(context).size.width / 1.2,
                            margin: EdgeInsets.only(top: 20.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(
                                  width: 0.5,
                                  color: ColorCodes.darkGrey.withOpacity(1)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      _dialogforProcessing();
                                      Navigator.of(context).pop();
                                      _handleSignIn();
                                    },
                                    child: Image.asset(Images.googleImg)),
                                GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      _dialogforProcessing();
                                      Navigator.of(context).pop();
                                      facebooklogin();
                                    },
                                    child: Image.asset(Images.facebookImg)),
                                if (_isAvailable)
                                  GestureDetector(
                                      onTap: () {
                                        appleLogIn();
                                      },
                                      child: Image.asset(Images.appleImg))
                              ],
                            ),
                          ),*/
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 28),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    userappauth.login(AuthPlatform.google,onSucsess: (SocialAuthUser value,_){
                                      debugPrint("new user...."+value.newuser.toString());
                                      if(value.newuser!){
                                        userappauth.register(data:RegisterAuthBodyParm(
                                          username: value.name,
                                          email: value.email,
                                          branch: PrefUtils.prefs!.getString("branch"),
                                          tokenId:PrefUtils.prefs!.getString("ftokenid"),
                                          guestUserId:PrefUtils.prefs!.getString("tokenid"),
                                          device:channel,
                                          referralid:_referController.text,
                                          path: _appletoken ,
                                          mobileNumber: ((PrefUtils.prefs!.getString('Mobilenum'))??""),
                                        ),onSucsess: (UserData response){
                                         /*Navigator.pushNamedAndRemoveUntil(
                                              context, HomeScreen.routeName, (route) => false);*/
                                          Navigation(context, navigatore: NavigatoreTyp.homenav);
                                        },onerror: (message){
                                          print("error..."+message);
                                          Navigator.of(context).pop();
                                          Fluttertoast.showToast(msg: message);
                                        });
                                      }else{
                                        result!(true);
                                        PrefUtils.prefs!.setString("apikey",value.id!);
                                        _auth.getuserProfile(onsucsess: (value){
                                         /* Navigator.pushNamedAndRemoveUntil(
                                              context, HomeScreen.routeName, (route) => false);*/
                                          Navigation(context, navigatore: NavigatoreTyp.homenav);
                                        },onerror: (message){
                                          print("error...fa"+message);
                                          Navigator.of(context).pop();
                                          Fluttertoast.showToast(msg: message);
                                        });
                                        debugPrint("old user....");
                                        // Navigator.pushNamedAndRemoveUntil(
                                        //     context, HomeScreen.routeName, (route) => false);

                                      }
                                    },onerror:(message){
                                      print("error...1"+message);
                                      Navigator.of(context).pop();
                                      Fluttertoast.showToast(msg: message);
                                    });
                                  },
                                  child: Material(
                                    borderRadius: BorderRadius.circular(4.0),
                                    elevation: 2,
                                    shadowColor: Colors.grey,
                                    child: Container(

                                      padding: EdgeInsets.only(
                                          left: 10.0, right: 5.0,top:MediaQuery.of(context).size.height/130, bottom:MediaQuery.of(context).size.height/130),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4.0),),
                                      child:
                                      Padding(
                                        padding: const EdgeInsets.only(right:23.0,left:23,),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              //SvgPicture.asset(Images.googleImg, width: 25, height: 25,),
                                              Image.asset(Images.googlewebImg,width: 20,height: 20,),
                                              SizedBox(
                                                width: 14,
                                              ),
                                              Text(
                                                S .of(context).sign_in_with_google,//"Sign in with Google" , //"Sign in with Google",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: ColorCodes.signincolor),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height/70, horizontal: 28),
                                child: GestureDetector(
                                  onTap: () {
                                    userappauth.login(AuthPlatform.facebook,onSucsess: (SocialAuthUser value,_){
                                      if(value.newuser!){
                                        userappauth.register(data:RegisterAuthBodyParm(
                                          username: value.name,
                                          email: value.email,
                                          branch: PrefUtils.prefs!.getString("branch"),
                                          tokenId:PrefUtils.prefs!.getString("ftokenid"),
                                          guestUserId:PrefUtils.prefs!.getString("tokenid"),
                                          device:channel,
                                          referralid:_referController.text,
                                          path: _appletoken, mobileNumber: '' ,
                                           ),onSucsess: (UserData response){
                                          Navigation(context, navigatore: NavigatoreTyp.homenav);
                                         /* Navigator.pushNamedAndRemoveUntil(
                                              context, HomeScreen.routeName, (route) => false);*/
                                        },onerror: (message){
                                          print("error...fa"+message);
                                          Navigator.of(context).pop();
                                          Fluttertoast.showToast(msg: message);
                                        });
                                      }else{
                                        debugPrint("facebook old user....");
                                        result!(true);
                                        PrefUtils.prefs!.setString("apikey",value.id!);
                                        _auth.getuserProfile(onsucsess: (value){
                                          Navigation(context, navigatore: NavigatoreTyp.homenav);
                                       /*   Navigator.pushNamedAndRemoveUntil(
                                              context, HomeScreen.routeName, (route) => false);*/
                                        },onerror: (message){
                                          print("error...fa"+message);
                                          Navigator.of(context).pop();
                                          Fluttertoast.showToast(msg: message);
                                        });

                                      }

                                    },onerror:(message){
                                      print("error...fa2"+message);
                                      Navigator.of(context).pop();
                                      Fluttertoast.showToast(msg: message);
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: Material(
                                    borderRadius: BorderRadius.circular(4.0),
                                    elevation: 2,
                                    shadowColor: Colors.grey,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 10.0,  right: 5.0, top:MediaQuery.of(context).size.height/130, bottom:MediaQuery.of(context).size.height/130),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4.0),

                                        // border: Border.all(width: 0.5, color: Color(0xff4B4B4B)),
                                      ),
                                      child:
                                      Padding(
                                        padding: const EdgeInsets.only(right:23.0,left: 23),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              //SvgPicture.asset(Images.facebookImg, width: 25, height: 25,),
                                              Image.asset(Images.facebookwebImg,width: 20,height: 20,),
                                              SizedBox(
                                                width: 14,
                                              ),
                                              Text(
                                                S .of(context).sign_in_with_facebook,//"Sign in with Facebook" ,// "Sign in with Facebook",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: ColorCodes.signincolor),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            );
          });
        });
  }

  _verifyOtp(context, String enteredotp,String otp, bool newuser, String mobile) async {
    debugPrint("verify otp...");
   debugPrint("verify otp..."+enteredotp+"  "+otp);
    if (enteredotp == otp) {
      debugPrint("verify otp...1"+PrefUtils.prefs!.getBool('type').toString());
        if (!newuser) {
          debugPrint("old user...");
          Navigator.of(context).pop();
            result!(true);

        } else {
          debugPrint("new user...");
         // PrefUtils.prefs!.setString('prevscreen', "otpconfirmscreen");
        //  Navigator.of(context).pop();
        //  PrefUtils.prefs!.setString('skip', "no");
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          _dialogforAddInfo(context,mobile);

        }

    } else {
      Navigator.of(context).pop();
      if(Platform.isIOS)FocusManager.instance.primaryFocus!.unfocus();
      return Fluttertoast.showToast(msg: S .of(context).please_enter_valid_otp,//"Please enter a valid otp!!!",
        gravity: ToastGravity.BOTTOM,
        fontSize: MediaQuery.of(context).textScaleFactor *13,
      );
    }
  }

  _dialogforAddInfo(BuildContext context, String mobile,) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: Container(
                height:
                     MediaQuery.of(context).size.width / 2,
                width: MediaQuery.of(context).size.width / 2.7,
                //padding: EdgeInsets.only(left: 30.0, right: 20.0),
                child: Column(children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50.0,
                    color: ColorCodes.lightGreyWebColor,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          S .of(context).add_info,//"Add your info",
                          style: TextStyle(
                              color: ColorCodes.mediumBlackColor,
                              fontSize: 20.0),
                        )),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 30.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Form(
                            key: _formweb,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 10),
                                Text(
                                  S .of(context).what_should_we_call_you,//'* What should we call you?',
                                  style: TextStyle(
                                      fontSize: 17, color: ColorCodes.lightBlack),
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  textAlign: TextAlign.left,
                                  controller: firstnamecontroller,
                                  decoration: InputDecoration(
                                    hintText: S .of(context).name,//'Name',
                                    hoverColor: ColorCodes.darkgreen,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: ColorCodes.grey),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: ColorCodes.darkgreen),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: ColorCodes.darkgreen),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: ColorCodes.darkgreen),
                                    ),
                                  ),
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_lnameFocusNode);
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      setState(() {
                                        fn = "  Please Enter Name";
                                      });
                                      return '';
                                    }
                                    setState(() {
                                      fn = "";
                                    });
                                    return null;
                                  },
                                 /* onSaved: (value) {
                                    addFirstnameToSF(value);
                                  },*/
                                ),
                                Text(
                                  fn,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: ColorCodes.lightred),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  S .of(context).tell_us_your_email,//'Tell us your e-mail',
                                  style: TextStyle(
                                      fontSize: 17, color: ColorCodes.lightBlack),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  controller: lastnamecontroller,
                                  textAlign: TextAlign.left,
                                  keyboardType: TextInputType.emailAddress,
                                  style: new TextStyle(
                                      decorationColor:
                                      Theme.of(context).primaryColor),
                                  decoration: InputDecoration(
                                    hintText: 'xyz@gmail.com',
                                    fillColor: ColorCodes.darkgreen,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: ColorCodes.grey),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: ColorCodes.darkgreen),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide:
                                      BorderSide(color: ColorCodes.darkgreen),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide(
                                          color: ColorCodes.darkgreen, width: 1.2),
                                    ),
                                  ),
                                  validator: (value) {
                                    bool emailValid;
                                    if (value == "")
                                      emailValid = true;
                                    else
                                      emailValid = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value!);

                                    if (!emailValid) {
                                      setState(() {
                                        ea =
                                        ' Please enter a valid email address';
                                      });
                                      return '';
                                    }
                                    setState(() {
                                      ea = "";
                                    });
                                    return null; //it means user entered a valid input
                                  },
                                  /*onSaved: (value) {
                                    addEmailToSF(value);
                                  },*/
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      ea,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(color: ColorCodes.lightred),
                                    ),
                                  ],
                                ),
                                Text(
                                  S .of(context).we_will_email,//' We\'ll email you as a reservation confirmation.',
                                  style: TextStyle(
                                      fontSize: 15.2, color: ColorCodes.grey),
                                ),

                                SizedBox(
                                  height: 15.0,
                                ),
                                if(Features.isReferEarn)
                                  Text(
                                    S .of(context).apply_referal_code,//'Apply referral Code',
                                    style: TextStyle(fontSize: 17, color: ColorCodes.lightBlack),
                                  ),
                                if(Features.isReferEarn)
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                if(Features.isReferEarn)
                                  TextFormField(
                                    controller: _referController,
                                    textAlign: TextAlign.left,
                                    style: new TextStyle(
                                        decorationColor: Theme.of(context).primaryColor),
                                    decoration: InputDecoration(
                                      hintText: S .of(context).refer_earn,//'Refer and Earn',
                                      fillColor: Colors.green,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(color: Colors.grey),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(color: Colors.green),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(color: Colors.green),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: BorderSide(color: Colors.green, width: 1.2),
                                      ),
                                    ),

                                  ),
                                if(Features.isReferEarn)
                                  SizedBox(
                                    height: 10.0,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        //  Spacer(),
                      ],
                    ),
                  ),
                  Spacer(),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          _dialogforProcessing(context);
                          Future.delayed(Duration(seconds: 1), () async {
                            await _saveAddInfoForm(context, mobile);
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                              )),
                          height: 60.0,
                          child: Center(
                            child: Text(
                              S .of(context).continue_button,// "CONTINUE",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Theme.of(context).buttonColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )),
                  ),
                ]),
              ),
            );
          });
        });
  }
  _dialogforProcessing(context) {
    debugPrint("dialog....");
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AbsorbPointer(
              child: Container(
                color: Colors.transparent,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
            );
          });
        });
  }


  Future<void> SignupUser(BuildContext context, String mobile) async{
    String channel = "";
    try {
      if (Platform.isIOS) {
        channel = "IOS";
      } else {
        channel = "Android";
      }
    } catch (e) {
      channel = "Web";
    }
    try {
    String apple = "";
    if(PrefUtils.prefs!.containsKey("applesignin"))
      if (PrefUtils.prefs!.getString('applesignin') == "yes") {
        apple = PrefUtils.prefs!.getString('apple')!;
      } else {
        apple = "";
      }
    userappauth.register(data:RegisterAuthBodyParm(
        username: firstnamecontroller.text,
        email: (lastnamecontroller.text),
        branch: PrefUtils.prefs!.getString("branch"),
        tokenId:PrefUtils.prefs!.getString("ftokenid"),
        guestUserId:PrefUtils.prefs!.getString("tokenid"),
        device:channel.toString(),
        referralid:(_referController.text),
        path: apple.toString(),
        mobileNumber: mobile

    ),onSucsess: (UserData response){
      debugPrint("abc..."+response.toString());
      fas.LogSignUp();
      PrefUtils.prefs!.setString('apiKey', response.apiKey!);
      PrefUtils.prefs!.setString('userID', response.id!);
      PrefUtils.prefs!.setString('membership', response.membership!);
      PrefUtils.prefs!.setString("mobile", mobile);
      PrefUtils.prefs!.setString('referral', (_referController.text));
      PrefUtils.prefs!.setString('LoginStatus', "true");
      PrefUtils.prefs!.setString('referid', _referController.text);
      Navigator.of(context).pop();
      Navigation(context, navigatore: NavigatoreTyp.homenav);
      result!(true);
    },onerror: (message){
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: message,
          fontSize: MediaQuery.of(context).textScaleFactor *13,
          backgroundColor: Colors.black87,
          textColor: Colors.white);
    });
    } catch (error) {
      throw error;
    }
  }
  _saveAddInfoForm(BuildContext context, String mobile) async {
    String channel = "";
    try {
      if (Platform.isIOS) {
        channel = "IOS";
      } else {
        channel = "Android";
      }
    } catch (e) {
      channel = "Web";
    }

    String apple = "";
    if (PrefUtils.prefs!.getString('applesignin') == "yes") {
      apple = PrefUtils.prefs!.getString('apple')!;
    } else {
      apple = "";
    }
    final isValid = _formweb.currentState!.validate();
    if (!isValid) {
      return;
    } //it will check all validators
    _formweb.currentState!.save();
    //_dialogforProcessing(context);
    // userappauth.register(data:RegisterAuthBodyParm(
    //     username: firstnamecontroller.text,
    //     email: (lastnamecontroller.text),
    //     branch: PrefUtils.prefs!.getString("branch"),
    //     tokenId:PrefUtils.prefs!.getString("ftokenid"),
    //     guestUserId:PrefUtils.prefs!.getString("tokenid"),
    //     device:channel.toString(),
    //     referralid:(_referController.text),
    //     path: apple.toString(),
    //     mobileNumber: mobile
    //
    // ),onSucsess: (UserData response){
    //   debugPrint("abc..."+response.toString());
    //   fas.LogSignUp();
    //   PrefUtils.prefs!.setString('apiKey', response.apiKey!);
    //   PrefUtils.prefs!.setString('userID', response.id!);
    //   PrefUtils.prefs!.setString('membership', response.membership!);
    //   PrefUtils.prefs!.setString("mobile", mobile);
    //   PrefUtils.prefs!.setString('referral', (_referController.text));
    //   PrefUtils.prefs!.setString('LoginStatus', "true");
    //   PrefUtils.prefs!.setString('referid', _referController.text);
    //   Navigator.of(context).pop();
    //   result!(true);
    // },onerror: (message){
    //   Navigator.of(context).pop();
    //   Fluttertoast.showToast(
    //       msg: message,
    //       fontSize: MediaQuery.of(context).textScaleFactor *13,
    //       backgroundColor: Colors.black87,
    //       textColor: Colors.white);
    // });
    if(/*PrefUtils.prefs!.getString('Email') == "" || PrefUtils.prefs!.getString('Email') == "null"*/lastnamecontroller.text==""||lastnamecontroller.text=="null") {
      SignupUser(context, mobile);
    }
    else
      {
        print("check emial....");
        checkemail(context,mobile,(lastnamecontroller.text));
      }
  }

  Future<void> checkemail(BuildContext context,String mobile,String email) async {
    print("email check ..."+email.toString());
    try {
      final response = await http.post(Api.emailCheck, body: {
        "email": email,//PrefUtils.prefs!.getString('Email'),
      });
      final responseJson = json.decode(response.body);

      if (responseJson['status'].toString() == "true") {
        if (responseJson['type'].toString() == "old") {
         // Navigator.of(context).pop();
          //Fluttertoast.showToast(msg: 'Email id already exists!!!');
          Fluttertoast.showToast(
              msg: S .of(context).email_exist,//"Email id already exists",
              fontSize: MediaQuery.of(context).textScaleFactor *13,
              backgroundColor: Colors.black87,
              textColor: Colors.white);;
        } else if (responseJson['type'].toString() == "new") {
          return SignupUser(context,mobile);
        }
      } else {
        Fluttertoast.showToast(msg: S .of(context).something_went_wrong,//"Something went wrong!!!"
        );
      }
    } catch (error) {
      throw error;
    }
  }

  _saveForm(context, String mobileNumber,setState) async {
    debugPrint("mobile...."+mobileNumber);
    final isValid = _formweb.currentState!.validate();
    debugPrint("isValid...."+isValid.toString());
    if (!isValid) {
      return;
    } //it will check all validators
    _formweb.currentState!.save();



    userappauth.login(AuthPlatform.phone,data: {"mobile": mobileNumber},onSucsess: (SocialAuthUser value,LoginData otp){
print("new user...."+value.newuser.toString());
      if (value.newuser == true){
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        alertOtp(
            context, mobileNumber, setState, otp.otp.toString(), value.newuser);
      }
      else {
        PrefUtils.prefs!.setString('apikey', value.id!);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        alertOtp(
            context, mobileNumber, setState, otp.otp.toString(), value.newuser);
      }
      // debugPrint("otp..."+otp.otp.toString());
      // PrefUtils.prefs!.setString('apikey', value.id!);
      // Navigator.of(context).pop();
      // Navigator.of(context).pop();
      // alertOtp(context,mobileNumber,setState, otp.otp.toString(),value.newuser);
    });

  }

   alertOtp(ctx,String mobile,setState,String otp,newuser) {
     Future<void> otpCall() async {
       // imp feature in adding async is the it automatically wrap into Future.
       try {
         final response = await http.post(Api.resendOtpCall, body: {
           // await keyword is used to wait to this operation is complete.
           "resOtp": PrefUtils.prefs!.getString('Otp'),
           "mobileNumber": PrefUtils.prefs!.getString('Mobilenum'),
         });
         final responseJson = json.decode(utf8.decode(response.bodyBytes));
       } catch (error) {
         setState(() {
           //_isLoading = false;
         });
         throw error;
       }
     }


   // mobile = PrefUtils.prefs!.getString("Mobilenum");
    print("otp....."+ otp);
    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (BuildContext context) {
        var setstate;
        void getTime() {
          print("s......ll.l.l" + _timeRemaining.toString());
          if(_timeRemaining <= 0)
            _timer!.cancel();
         else {
            try {
              setstate(() {
                            _timeRemaining == 0 ? _timeRemaining = 0 : _timeRemaining--;
                            debugPrint("time..." + _timeRemaining.toString());
                          });
            } catch (e) {
              _timer!.cancel();
            }
          }
        }
        _timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getTime());
        return StatefulBuilder(builder: (context, setState)
      {
        setstate = setState;
        return AlertDialog(
            contentPadding: EdgeInsets.all(0.0),
            content: SingleChildScrollView(
                child: Column(
                    children: [
                      Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width / 2.5,
                          child: Column(children: <Widget>[
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              height: 50.0,
                              padding: EdgeInsets.only(left: 20.0),
                              color: ColorCodes.lightGreyWebColor,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    S .of(context)
                                        .signup_otp, //"Signup using OTP",
                                    style: TextStyle(
                                        color: ColorCodes.mediumBlackColor,
                                        fontSize: 20.0),
                                  )),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 30.0, right: 30.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 25.0),
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      S .of(context)
                                          .please_check_otp_sent_to_your_mobile_number,
                                      //'Please check OTP sent to your mobile number',
                                      style: TextStyle(
                                          color: ColorCodes.mediumBlackWebColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0),

                                      // textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(width: 20.0),
                                      Text(
                                        IConstants.countryCode + mobile,
                                        style: new TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: ColorCodes.blackColor,
                                            fontSize: 16.0),
                                      ),
                                      SizedBox(width: 30.0),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                          //_dialogforSignIn();
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: ColorCodes.whiteColor,
                                            borderRadius: BorderRadius.circular(
                                                8),
                                            border: Border.all(
                                                color: Color(0x707070B8),
                                                width: 1.5),
                                          ),
                                          child: Center(
                                              child: Text(
                                                  S .of(context)
                                                      .change, //'Change',
                                                  style: TextStyle(
                                                      color: ColorCodes
                                                          .blackColor,
                                                      fontSize: 13))),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.0),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Text(
                                      S .of(context)
                                          .enter_otp, //'Enter OTP',
                                      style: TextStyle(
                                          color: ColorCodes.greyColor,
                                          fontSize: 14),
                                      //textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: [
                                        // Auto Sms
                                        Container(
                                            height: 40,
                                            //width: MediaQuery.of(context).size.width*80/100,
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width / 3,
                                            //padding: EdgeInsets.zero,
                                            child: PinFieldAutoFill(
                                              controller: controller,
                                              decoration: UnderlineDecoration(
                                                //gapSpace: 30.0,
                                                  textStyle: TextStyle(fontSize: 18, color: ColorCodes.blackColor),
                                                  colorBuilder: FixedColorBuilder(ColorCodes.greyColor)),
                                              onCodeChanged: (text) {
                                                // otpvalue = text;
                                                // print("text......" + text + "  "+ otpvalue);
                                                SchedulerBinding.instance!.addPostFrameCallback((_) => setState(() {

                                                }));
                                                // if(text.length == 4) {
                                                //   _dialogforProcessing();
                                                //   _verifyOtp(otpvalue);
                                                // }
                                              },
                                              onCodeSubmitted: (text) {
                                                SchedulerBinding.instance!
                                                    .addPostFrameCallback((_) => setState(() {
                                                  // otpvalue = text;
                                                  // print("text......otp" + text + "  "+ otpvalue);
                                                }));
                                              },
                                              codeLength: 4,
                                              currentCode: controller.text,
                                            )),
                                      ]),
                                  SizedBox(
                                    height: 20,
                                  ),

                                  _showOtp!
                                      ? Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            height: 40,
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width *
                                                32 /
                                                100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(6),
                                              border: Border.all(
                                                  color: Color(0xFF6D6D6D),
                                                  width: 1.5),
                                            ),
                                            child: Center(
                                                child: Text(
                                                  S .of(context)
                                                      .resend_otp, //'Resend OTP'
                                                )),
                                          ),
                                        ),
                                        if(Features.callMeInsteadOTP)
                                          Container(
                                            height: 28,
                                            width: 28,
                                            margin: EdgeInsets.only(
                                                left: 20.0, right: 20.0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(20),
                                              border: Border.all(
                                                  color: Color(0xFF6D6D6D),
                                                  width: 1.5),
                                            ),
                                            child: Center(
                                                child: Text(
                                                  S .of(context)
                                                      .or, //'OR',
                                                  style: TextStyle(
                                                      fontSize: 10),
                                                )),
                                          ),
                                        if(Features.callMeInsteadOTP)
                                          _timeRemaining == 0
                                              ? MouseRegion(
                                            cursor:
                                            SystemMouseCursors.click,
                                            child: GestureDetector(
                                              behavior: HitTestBehavior
                                                  .translucent,
                                              onTap: () {
                                                otpCall();
                                                _timeRemaining = 60;
                                              },
                                              child: Expanded(
                                                child: Container(
                                                  height: 40,
                                                  //width: MediaQuery.of(context).size.width*32/100,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(6),
                                                    border: Border.all(
                                                        color: ColorCodes
                                                            .primaryColor,
                                                        width: 1.5),
                                                  ),

                                                  child: Center(
                                                      child: Text(
                                                        S .of(context)
                                                            .call_me_instead, //'Call me Instead'
                                                      )),
                                                ),
                                              ),
                                            ),
                                          )
                                              : Expanded(
                                            child: Container(
                                              height: 40,
                                              //width: MediaQuery.of(context).size.width*32/100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    6),
                                                border: Border.all(
                                                    color:
                                                    Color(0xFF6D6D6D),
                                                    width: 1.5),
                                              ),
                                              child: Center(
                                                child: RichText(
                                                  text: TextSpan(
                                                    children: <TextSpan>[
                                                      new TextSpan(
                                                          text: S .of(context)
                                                              .call_in,
                                                          //'Call in',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                      new TextSpan(
                                                        text:
                                                        ' 00:$_timeRemaining',
                                                        style: TextStyle(
                                                          color: Color(
                                                              0xffdbdbdb),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                      ])
                                      : Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      _timeRemaining == 0
                                          ? Expanded(
                                            child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          behavior:
                                          HitTestBehavior.translucent,
                                          onTap: () {
                                            //  _showCall = true;
                                            /*setstate(() {
                                              _showOtp = true;
                                              _timeRemaining += 30;
                                            });*/
                                            //Otpin30sec();
                                          },
                                          child: Container(
                                            height: 40,
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width *
                                                15 /
                                                100,
                                            //width: MediaQuery.of(context).size.width*32/100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  6),
                                              border: Border.all(
                                                  color: ColorCodes
                                                      .primaryColor,
                                                  width: 1.5),
                                            ),
                                            child: Center(
                                                child:
                                                Text(S .of(context)
                                                    .resend_otp, //'Resend OTP'
                                                )),
                                          ),
                                        ),
                                      ),
                                          )
                                          : Expanded(
                                        child: Container(
                                          height: 40,
                                          //width: MediaQuery.of(context).size.width*40/100,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(6),
                                            border: Border.all(
                                                color: Color(0x707070B8),
                                                width: 1.5),
                                          ),
                                          child: Center(
                                            child: RichText(
                                              text: TextSpan(
                                                children: <TextSpan>[
                                                  new TextSpan(
                                                      text:
                                                      S .of(context)
                                                          .resend_otp_in,
                                                      //'Resend Otp in',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .black)),
                                                  new TextSpan(
                                                    text:
                                                    ' 00:$_timeRemaining',
                                                    style: TextStyle(
                                                      color: Color(
                                                          0xffdbdbdb),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      if(Features.callMeInsteadOTP)
                                        Container(
                                          height: 28,
                                          width: 28,
                                          margin: EdgeInsets.only(
                                              left: 20.0, right: 20.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(20),
                                            border: Border.all(
                                                color: Color(0xFF6D6D6D),
                                                width: 1.5),
                                          ),
                                          child: Center(
                                              child: Text(
                                                S .of(context)
                                                    .or, //'OR',
                                                style: TextStyle(fontSize: 10),
                                              )),
                                        ),
                                      if(Features.callMeInsteadOTP)
                                        Expanded(
                                          child: Container(
                                            height: 40,
                                            //width: MediaQuery.of(context).size.width*32/100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(6),
                                              border: Border.all(
                                                  color: Color(0xFF6D6D6D),
                                                  width: 1.5),
                                            ),
                                            child: Center(
                                                child: Text(S .of(context)
                                                    .call_me_instead, //'Call me Instead'
                                                )),
                                          ),
                                        ),
                                    ],
                                  ),


                                ],
                              ),
                            ),
                            //Spacer(),
                            SizedBox(height: 20),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    debugPrint("verify ..."+controller.text);
                                    _dialogforProcessing(context);
                                      Future.delayed(Duration(seconds: 1), () async {
                                        await _verifyOtp(context, controller.text,otp,newuser,mobile);
                                      });
                                   if(_timer!.isActive) _timer!.cancel();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Theme
                                            .of(context)
                                            .primaryColor,
                                        border: Border.all(
                                          color: Theme
                                              .of(context)
                                              .primaryColor,
                                        )),
                                    height: 60.0,
                                    child: Center(
                                      child: Text(
                                        S .of(context)
                                            .login, //"LOGIN",
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Theme
                                              .of(context)
                                              .buttonColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                          ])),
                    ]))
        );
      });
      },
    );
   //  var alert = AlertDialog(
   //      contentPadding: EdgeInsets.all(0.0),
   //      content: SingleChildScrollView(
   //              child: Column(
   //                children: [
   //                  Container(
   //                      width:  MediaQuery.of(ctx).size.width / 2.5,
   //                      child: Column(children: <Widget>[
   //                        Container(
   //                          width: MediaQuery.of(ctx).size.width,
   //                          height: 50.0,
   //                          padding: EdgeInsets.only(left: 20.0),
   //                          color: ColorCodes.lightGreyWebColor,
   //                          child: Align(
   //                              alignment: Alignment.centerLeft,
   //                              child: Text(
   //                                S.of(ctx).signup_otp,//"Signup using OTP",
   //                                style: TextStyle(
   //                                    color: ColorCodes.mediumBlackColor,
   //                                    fontSize: 20.0),
   //                              )),
   //                        ),
   //                        Container(
   //                          padding: EdgeInsets.only(left: 30.0, right: 30.0),
   //                          child: Column(
   //                              mainAxisAlignment: MainAxisAlignment.start,
   //                              crossAxisAlignment: CrossAxisAlignment.start,
   //                              children: <Widget>[
   //                                SizedBox(height: 25.0),
   //                                Padding(
   //                                  padding: const EdgeInsets.all(20.0),
   //                                  child: Text(
   //                                    S.of(ctx).please_check_otp_sent_to_your_mobile_number,//'Please check OTP sent to your mobile number',
   //                                    style: TextStyle(
   //                                        color: ColorCodes.mediumBlackWebColor,
   //                                        fontWeight: FontWeight.bold,
   //                                        fontSize: 14.0),
   //
   //                                    // textAlign: TextAlign.center,
   //                                  ),
   //                                ),
   //                                SizedBox(height: 10.0),
   //                                Row(
   //                                  mainAxisAlignment: MainAxisAlignment.center,
   //                                  children: <Widget>[
   //                                    SizedBox(width: 20.0),
   //                                    Text(
   //                                      IConstants.countryCode + text,
   //                                      style: new TextStyle(
   //                                          fontWeight: FontWeight.w600,
   //                                          color: ColorCodes.blackColor,
   //                                          fontSize: 16.0),
   //                                    ),
   //                                    SizedBox(width: 30.0),
   //                                    GestureDetector(
   //                                      onTap: () {
   //                                        Navigator.pop(ctx);
   //                                        //_dialogforSignIn();
   //                                      },
   //                                      child: Container(
   //                                        height: 35,
   //                                        width: 100,
   //                                        decoration: BoxDecoration(
   //                                          color: ColorCodes.whiteColor,
   //                                          borderRadius: BorderRadius.circular(8),
   //                                          border: Border.all(
   //                                              color: Color(0x707070B8), width: 1.5),
   //                                        ),
   //                                        child: Center(
   //                                            child: Text(
   //                                                S.of(ctx).change,//'Change',
   //                                                style: TextStyle(
   //                                                    color: ColorCodes.blackColor,
   //                                                    fontSize: 13))),
   //                                      ),
   //                                    ),
   //                                  ],
   //                                ),
   //                                SizedBox(height: 20.0),
   //                                Padding(
   //                                  padding: const EdgeInsets.only(left: 20.0),
   //                                  child: Text(
   //                                    S.of(ctx).enter_otp,//'Enter OTP',
   //                                    style: TextStyle(
   //                                        color: ColorCodes.greyColor, fontSize: 14),
   //                                    //textAlign: TextAlign.left,
   //                                  ),
   //                                ),
   //                                Row(
   //                                    mainAxisAlignment: MainAxisAlignment.start,
   //                                    children: [
   //                                      // Auto Sms
   //                                      Container(
   //                                          height: 40,
   //                                          //width: MediaQuery.of(context).size.width*80/100,
   //                                          width: MediaQuery.of(ctx).size.width / 3,
   //                                          //padding: EdgeInsets.zero,
   //                                          child: PinFieldAutoFill(
   //                                              controller: controller,
   //                                              decoration: UnderlineDecoration(
   //                                                  colorBuilder: FixedColorBuilder(
   //                                                      Color(0xFF707070))),
   //                                              onCodeChanged: (text) {
   //                                                controller.text = text;
   //                                                SchedulerBinding.instance
   //                                                    .addPostFrameCallback(
   //                                                        (_) => setState(() {
   //
   //                                                        }));
   //                                              },
   //                                              onCodeSubmitted: (text) {
   //                                                SchedulerBinding.instance
   //                                                    .addPostFrameCallback(
   //                                                        (_) => setState(() {
   //                                                          controller.text = text;
   //                                                    }));
   //                                              },
   //                                              codeLength: 4,
   //                                              currentCode: controller.text)),
   //                                    ]),
   //                                SizedBox(
   //                                  height: 20,
   //                                ),
   //
   //                                _showOtp
   //                                    ? Row(
   //                                    mainAxisAlignment:
   //                                    MainAxisAlignment.spaceEvenly,
   //                                    children: <Widget>[
   //                                      Expanded(
   //                                        child: Container(
   //                                          height: 40,
   //                                          width: MediaQuery.of(ctx)
   //                                              .size
   //                                              .width *
   //                                              32 /
   //                                              100,
   //                                          decoration: BoxDecoration(
   //                                            borderRadius:
   //                                            BorderRadius.circular(6),
   //                                            border: Border.all(
   //                                                color: Color(0xFF6D6D6D),
   //                                                width: 1.5),
   //                                          ),
   //                                          child: Center(
   //                                              child: Text(
   //                                                S.of(ctx).resend_otp,//'Resend OTP'
   //                                              )),
   //                                        ),
   //                                      ),
   //                                      if(Features.callMeInsteadOTP)
   //                                        Container(
   //                                          height: 28,
   //                                          width: 28,
   //                                          margin: EdgeInsets.only(
   //                                              left: 20.0, right: 20.0),
   //                                          decoration: BoxDecoration(
   //                                            borderRadius:
   //                                            BorderRadius.circular(20),
   //                                            border: Border.all(
   //                                                color: Color(0xFF6D6D6D),
   //                                                width: 1.5),
   //                                          ),
   //                                          child: Center(
   //                                              child: Text(
   //                                                S.of(ctx).or,//'OR',
   //                                                style: TextStyle(fontSize: 10),
   //                                              )),
   //                                        ),
   //                                      if(Features.callMeInsteadOTP)
   //                                        _timeRemaining == 0
   //                                            ? MouseRegion(
   //                                          cursor:
   //                                          SystemMouseCursors.click,
   //                                          child: GestureDetector(
   //                                            behavior: HitTestBehavior
   //                                                .translucent,
   //                                            onTap: () {
   //                                              //otpCall();
   //                                              _timeRemaining = 60;
   //                                            },
   //                                            child: Expanded(
   //                                              child: Container(
   //                                                height: 40,
   //                                                //width: MediaQuery.of(context).size.width*32/100,
   //                                                decoration: BoxDecoration(
   //                                                  borderRadius:
   //                                                  BorderRadius
   //                                                      .circular(6),
   //                                                  border: Border.all(
   //                                                      color: ColorCodes.primaryColor,
   //                                                      width: 1.5),
   //                                                ),
   //
   //                                                child: Center(
   //                                                    child: Text(
   //                                                      S.of(ctx).call_me_instead,//'Call me Instead'
   //                                                    )),
   //                                              ),
   //                                            ),
   //                                          ),
   //                                        )
   //                                            : Expanded(
   //                                          child: Container(
   //                                            height: 40,
   //                                            //width: MediaQuery.of(context).size.width*32/100,
   //                                            decoration: BoxDecoration(
   //                                              borderRadius:
   //                                              BorderRadius.circular(
   //                                                  6),
   //                                              border: Border.all(
   //                                                  color:
   //                                                  Color(0xFF6D6D6D),
   //                                                  width: 1.5),
   //                                            ),
   //                                            child: Center(
   //                                              child: RichText(
   //                                                text: TextSpan(
   //                                                  children: <TextSpan>[
   //                                                    new TextSpan(
   //                                                        text: S.of(ctx).call_in,//'Call in',
   //                                                        style: TextStyle(
   //                                                            color: Colors
   //                                                                .black)),
   //                                                    new TextSpan(
   //                                                      text:
   //                                                      ' 00:$_timeRemaining',
   //                                                      style: TextStyle(
   //                                                        color: Color(
   //                                                            0xffdbdbdb),
   //                                                      ),
   //                                                    ),
   //                                                  ],
   //                                                ),
   //                                              ),
   //                                            ),
   //                                          ),
   //                                        )
   //                                    ])
   //                                    : Row(
   //                                  mainAxisAlignment:
   //                                  MainAxisAlignment.spaceEvenly,
   //                                  children: <Widget>[
   //                                    _timeRemaining == 0
   //                                        ? MouseRegion(
   //                                      cursor: SystemMouseCursors.click,
   //                                      child: GestureDetector(
   //                                        behavior:
   //                                        HitTestBehavior.translucent,
   //                                        onTap: () {
   //                                          //  _showCall = true;
   //                                          _showOtp = true;
   //                                          _timeRemaining += 30;
   //                                          //Otpin30sec();
   //                                        },
   //                                        child: Expanded(
   //                                          child: Container(
   //                                            height: 40,
   //                                            width: MediaQuery.of(ctx)
   //                                                .size
   //                                                .width *
   //                                                15 /
   //                                                100,
   //                                            //width: MediaQuery.of(context).size.width*32/100,
   //                                            decoration: BoxDecoration(
   //                                              borderRadius:
   //                                              BorderRadius.circular(
   //                                                  6),
   //                                              border: Border.all(
   //                                                  color: ColorCodes.primaryColor,
   //                                                  width: 1.5),
   //                                            ),
   //                                            child: Center(
   //                                                child:
   //                                                Text(S.of(ctx).resend_otp,//'Resend OTP'
   //                                                )),
   //                                          ),
   //                                        ),
   //                                      ),
   //                                    )
   //                                        : Expanded(
   //                                      child: Container(
   //                                        height: 40,
   //                                        //width: MediaQuery.of(context).size.width*40/100,
   //                                        decoration: BoxDecoration(
   //                                          borderRadius:
   //                                          BorderRadius.circular(6),
   //                                          border: Border.all(
   //                                              color: Color(0x707070B8),
   //                                              width: 1.5),
   //                                        ),
   //                                        child: Center(
   //                                          child: RichText(
   //                                            text: TextSpan(
   //                                              children: <TextSpan>[
   //                                                new TextSpan(
   //                                                    text:
   //                                                    S.of(ctx).resend_otp_in,//'Resend Otp in',
   //                                                    style: TextStyle(
   //                                                        color: Colors
   //                                                            .black)),
   //                                                new TextSpan(
   //                                                  text:
   //                                                  ' 00:$_timeRemaining',
   //                                                  style: TextStyle(
   //                                                    color: Color(
   //                                                        0xffdbdbdb),
   //                                                  ),
   //                                                ),
   //                                              ],
   //                                            ),
   //                                          ),
   //                                        ),
   //                                      ),
   //                                    ),
   //                                    if(Features.callMeInsteadOTP)
   //                                      Container(
   //                                        height: 28,
   //                                        width: 28,
   //                                        margin: EdgeInsets.only(
   //                                            left: 20.0, right: 20.0),
   //                                        decoration: BoxDecoration(
   //                                          borderRadius:
   //                                          BorderRadius.circular(20),
   //                                          border: Border.all(
   //                                              color: Color(0xFF6D6D6D),
   //                                              width: 1.5),
   //                                        ),
   //                                        child: Center(
   //                                            child: Text(
   //                                              S.of(ctx).or,//'OR',
   //                                              style: TextStyle(fontSize: 10),
   //                                            )),
   //                                      ),
   //                                    if(Features.callMeInsteadOTP)
   //                                      Expanded(
   //                                        child: Container(
   //                                          height: 40,
   //                                          //width: MediaQuery.of(context).size.width*32/100,
   //                                          decoration: BoxDecoration(
   //                                            borderRadius:
   //                                            BorderRadius.circular(6),
   //                                            border: Border.all(
   //                                                color: Color(0xFF6D6D6D),
   //                                                width: 1.5),
   //                                          ),
   //                                          child: Center(
   //                                              child: Text(S.of(ctx).call_me_instead,//'Call me Instead'
   //                                              )),
   //                                        ),
   //                                      ),
   //                                  ],
   //                                ),
   //
   //
   //
   //                ],
   //              ),
   //                        ),
   //                        //Spacer(),
   //                        SizedBox(height:20),
   //                        MouseRegion(
   //                          cursor: SystemMouseCursors.click,
   //                          child: GestureDetector(
   //                              behavior: HitTestBehavior.translucent,
   //                              onTap: () {
   //                                debugPrint("verify ...");
   //                                //_dialogforProcessing(ctx);
   //                                _verifyOtp(ctx,controller.text);
   //
   //                              },
   //                              child: Container(
   //                                padding: EdgeInsets.all(10),
   //                                decoration: BoxDecoration(
   //                                    color: Theme.of(ctx).primaryColor,
   //                                    border: Border.all(
   //                                      color: Theme.of(ctx).primaryColor,
   //                                    )),
   //                                height: 60.0,
   //                                child: Center(
   //                                  child: Text(
   //                                    S.of(ctx).login,//"LOGIN",
   //                                    style: TextStyle(
   //                                      fontSize: 18.0,
   //                                      color: Theme.of(ctx).buttonColor,
   //                                      fontWeight: FontWeight.bold,
   //                                    ),
   //                                  ),
   //                                ),
   //                              )),
   //                        ),
   //                      ])),
   //          ]))
   //  );
   // // _startTimer();
   //  showDialog(
   //      context: ctx,
   //      barrierDismissible: false,
   //      builder: (BuildContext c) {
   //        return alert;
   //      });
  }


}