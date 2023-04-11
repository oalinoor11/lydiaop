import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/Constant.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';
import 'package:flutter_app/Resources/RouteConstant.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:flutter_app/Utils/SharedPreferenceUtil.dart';
import 'package:flutter_app/Utils/ToastUtil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'bloc/resetpin_bloc.dart';

class ResetPinScreen extends StatefulWidget {
  final tokenId;
  const ResetPinScreen({Key key, this.tokenId}) : super(key: key);
  @override
  _ResetPinScreenState createState() => _ResetPinScreenState();
}

class _ResetPinScreenState extends State<ResetPinScreen> {
  final TextEditingController controller1 = new TextEditingController();
  final TextEditingController controller2 = new TextEditingController();
  final TextEditingController controller3 = new TextEditingController();
  final TextEditingController controller4 = new TextEditingController();
  final TextEditingController controller5 = new TextEditingController();
  final TextEditingController controller6 = new TextEditingController();

  final TextEditingController controller7 = new TextEditingController();
  final TextEditingController controller8 = new TextEditingController();
  final TextEditingController controller9 = new TextEditingController();
  final TextEditingController controller10 = new TextEditingController();
  final TextEditingController controller11 = new TextEditingController();
  final TextEditingController controller12 = new TextEditingController();

  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();
  final FocusNode focusNode5 = FocusNode();
  final FocusNode focusNode6 = FocusNode();

  final FocusNode focusNode7 = FocusNode();
  final FocusNode focusNode8 = FocusNode();
  final FocusNode focusNode9 = FocusNode();
  final FocusNode focusNode10 = FocusNode();
  final FocusNode focusNode11 = FocusNode();
  final FocusNode focusNode12 = FocusNode();

  String enteredPin = "";
  String reEnteredPin = "";
  String pinErrorMsg = "Please Enter 6 digit PIN";
  String reEnterPinErrorMsg = "Please Re-enter 6 digit PIN";
  String pinMissMatchError = "Please Re-enter correct pin";

  bool isPinError = false;
  bool isreEnterPinError = false;

  ResetpinBloc reSetPinBloc = ResetpinBloc();

  SharedPreferenceUtil _sharedPreference = SharedPreferenceUtil();

  ScreenUtil screenUtil = ScreenUtil();
  ToastUtil toastUtil = ToastUtil();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    reSetPinBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetpinBloc, ResetpinState>(
      cubit: reSetPinBloc,
      buildWhen: (prevState, state) {
        if (state is ResetpinInitial) {
          return false;
        }

        if (state is ResetPinUpdateState) {
          Navigator.pop(context);
          if (state.isNetworkConnected == true &&
              state.resData["code"].toString() == "200") {
            _sharedPreference.addSharedPref('alreadyLogin', "true");
            setPinAlert();
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pushNamed(RouteConst.routeMainDashboard);
            });
          } else if (state.isNetworkConnected == false) {
            toastUtil.showMsg(Constant.noInternetMsg, Colors.black,
                Colors.white, 12.0, "short", "bottom");
          } else {
            toastUtil.showMsg(state.resData["message"], Colors.black,
                Colors.white, 12.0, "short", "bottom");
          }
          return false;
        }
        return false;
      },
      // ignore: missing_return
      builder: (context, state) {
        if (state is ResetpinLoadedState) {
          return WillPopScope(
            // ignore: missing_return
            onWillPop: () {
              Navigator.of(context)
                  .pushReplacementNamed(RouteConst.routeMainDashboard);
            },
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Scaffold(
                backgroundColor: kBackgroundColor2,
                body: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: HelperUtil.backgroundGradient(),
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin:
                              EdgeInsets.only(top: screenUtil.setHeight(58.0)),
                          child: HelperUtil.backButton(
                            context: context,
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed(
                                  RouteConst.routeMainDashboard);
                            },
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: screenUtil.setWidth(18.0),
                              right: screenUtil.setWidth(18.0),
                              top: screenUtil.setHeight(45.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    "Reset PIN",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                        fontSize: screenUtil.setSp(24.0),
                                        fontFamily: "Poppins"),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    top: screenUtil.setHeight(5.0),
                                  ),
                                  child: Text(
                                    "It’s a good idea to have a strong security PIN that you don’t use anywhere else.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        color: kTextColor2,
                                        fontSize: screenUtil.setSp(16.0),
                                        fontFamily: "Poppins"),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    top: screenUtil.setHeight(48.0),
                                  ),
                                  child: Text(
                                    "Enter PIN",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                        fontSize: screenUtil.setSp(15.0),
                                        fontFamily: "Poppins"),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: screenUtil.setHeight(5.0)),
                                  height: screenUtil.setHeight(80),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: isPinError
                                          ? Colors.red
                                          : kTextColor6.withOpacity(0.3),
                                    ),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: enterPinWidget(),
                                ),
                                if (isPinError)
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: screenUtil.setHeight(8.0),
                                        left: screenUtil.setWidth(12.0)),
                                    child: Text(
                                      pinErrorMsg,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: Colors.red,
                                          fontSize: screenUtil.setSp(14.0),
                                          fontFamily: "Poppins"),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                Container(
                                  padding: EdgeInsets.only(
                                    top: screenUtil.setHeight(18.0),
                                  ),
                                  child: Text(
                                    "Re-enter PIN",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                        fontSize: screenUtil.setSp(15.0),
                                        fontFamily: "Poppins"),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: screenUtil.setHeight(5.0)),
                                  height: screenUtil.setHeight(80),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: isreEnterPinError
                                          ? Colors.red
                                          : kTextColor6.withOpacity(0.3),
                                    ),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: reEnterPinWidget(),
                                ),
                                if (isreEnterPinError)
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: screenUtil.setHeight(8.0),
                                        left: screenUtil.setWidth(12.0)),
                                    child: Text(
                                      reEnterPinErrorMsg,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: Colors.red,
                                          fontSize: screenUtil.setSp(14.0),
                                          fontFamily: "Poppins"),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: screenUtil.setWidth(24.0),
                                    left: screenUtil.setWidth(24.0),
                                    top: screenUtil.setHeight(23.0),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      validatePin(1, 3);
                                    },
                                    child: HelperUtil.buttonWithGradientColor(
                                        context: context, text: "SAVE"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  void setPinAlert() {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return WillPopScope(
          onWillPop: () {},
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: screenUtil.setWidth(339),
              height: screenUtil.setHeight(189),
              child: Container(
                decoration: BoxDecoration(
                  color: kAppbarColor,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.8),
                        offset: Offset(0, 0),
                        blurRadius: 15),
                  ],
                ),
                child: Material(
                  type: MaterialType.transparency,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: SvgPicture.asset(
                          ImageConst.successImg,
                          width: screenUtil.setWidth(56),
                          height: screenUtil.setHeight(59),
                        ),
                      ),
                      Container(
                        child: Text(
                          "THANK YOU!",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins",
                              fontSize: screenUtil.setSp(24.0),
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text(
                          "Your PIN was generated successfully!",
                          style: TextStyle(
                              color: kTextColor3,
                              fontFamily: "Poppins",
                              fontSize: screenUtil.setSp(16.0),
                              fontWeight: FontWeight.w300),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              margin: EdgeInsets.only(
                  left: 18,
                  right: 18,
                  bottom: screenUtil.screenHeight / 2 -
                      (screenUtil.setHeight(194) / 2)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }

  Widget enterPinWidget() {
    return Container(
      child: Row(
        children: [
          pinTextFiled(controller1, focusNode1, focusNode2, null, 1),
          verticalSeparator(),
          pinTextFiled(controller2, focusNode2, focusNode3, focusNode1, 1),
          verticalSeparator(),
          pinTextFiled(controller3, focusNode3, focusNode4, focusNode2, 1),
          verticalSeparator(),
          pinTextFiled(controller4, focusNode4, focusNode5, focusNode3, 1),
          verticalSeparator(),
          pinTextFiled(controller5, focusNode5, focusNode6, focusNode4, 1),
          verticalSeparator(),
          pinTextFiled(controller6, focusNode6, null, focusNode5, 1),
        ],
      ),
    );
  }

  Widget reEnterPinWidget() {
    return Container(
      child: Row(
        children: [
          pinTextFiled(controller7, focusNode7, focusNode8, null, 2),
          verticalSeparator(),
          pinTextFiled(controller8, focusNode8, focusNode9, focusNode7, 2),
          verticalSeparator(),
          pinTextFiled(controller9, focusNode9, focusNode10, focusNode8, 2),
          verticalSeparator(),
          pinTextFiled(controller10, focusNode10, focusNode11, focusNode9, 2),
          verticalSeparator(),
          pinTextFiled(controller11, focusNode11, focusNode12, focusNode10, 2),
          verticalSeparator(),
          pinTextFiled(controller12, focusNode12, null, focusNode11, 2),
        ],
      ),
    );
  }

  Widget verticalSeparator() {
    return Container(
      width: 1,
      margin: EdgeInsets.only(
        top: screenUtil.setHeight(15.0),
        bottom: screenUtil.setHeight(15.0),
      ),
      decoration: BoxDecoration(
        color: kSeparatorColor1,
      ),
    );
  }

  Widget pinTextFiled(TextEditingController controller, FocusNode currentFnode,
      FocusNode nextFnode, FocusNode prevFnode, int from) {
    return Expanded(
      child: Center(
        child: TextFormField(
          onTap: () {},
          enableInteractiveSelection: false,
          controller: controller,
          cursorColor: kTextColor3,
          maxLength: 1,
          readOnly: (from == 2 && enteredPin.length != 6) ? true : false,
          obscureText: true,
          textAlign: TextAlign.center,
          focusNode: currentFnode,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (text) {
            if (nextFnode != null && controller.text != "") {
              nextFnode.requestFocus();
            } else if (controller.text == "") {
              if (prevFnode != null) prevFnode.requestFocus();
            } else {
              FocusScope.of(context).requestFocus(new FocusNode());
              validatePin(2, from);
            }
          },
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: screenUtil.setSp(20),
            fontWeight: FontWeight.w600,
            color: kTextColor3,
          ),
          decoration: InputDecoration(
            hintText: "-",
            counterText: "",
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintStyle: TextStyle(
              fontSize: screenUtil.setSp(16.0),
              color: kTextColor7,
            ),
          ),
        ),
      ),
    );
  }

  // type 1. validate enter pin 2. validate reEnter pin 3. validate all
  void validatePin(int from, int type) {
    enteredPin = controller1.text +
        controller2.text +
        controller3.text +
        controller4.text +
        controller5.text +
        controller6.text;
    reEnteredPin = controller7.text +
        controller8.text +
        controller9.text +
        controller10.text +
        controller11.text +
        controller12.text;
    setState(() {
      if (enteredPin.length != 6 && type == 1 ||
          enteredPin.length != 6 && type == 3) {
        isPinError = true;
        isreEnterPinError = false;
      } else if (reEnteredPin.length != 6 && type == 2 ||
          reEnteredPin.length != 6 && type == 3) {
        isPinError = false;
        isreEnterPinError = true;
        reEnterPinErrorMsg = "Please Re-enter 6 digit PIN";
      } else if (enteredPin != reEnteredPin && type == 2 ||
          enteredPin != reEnteredPin && type == 3) {
        isreEnterPinError = true;
        isPinError = false;
        reEnterPinErrorMsg = "Plese Re-enter correct pin";
      } else {
        isreEnterPinError = false;
        isPinError = false;

        if (from == 1) {
          HelperUtil.checkInternetConnection().then((internet) {
            if (internet) {
              HelperUtil.showLoaderDialog(context);
              reSetPinBloc.add(ReSetSecurityPinEvent(
                  pin: enteredPin, token: "${widget.tokenId}"));
            } else {
              toastUtil.showMsg(Constant.noInternetMsg, Colors.black,
                  Colors.white, 12.0, "short", "bottom");
            }
          });
        }
      }
    });
  }
}
