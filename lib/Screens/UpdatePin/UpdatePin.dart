import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/Constant.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';
import 'package:flutter_app/Resources/RouteConstant.dart';
import 'package:flutter_app/Utils/HelperUtil.dart';
import 'package:flutter_app/Utils/ToastUtil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'bloc/updatepin_bloc.dart';

class UpdatePinScreen extends StatefulWidget {
  @override
  _UpdatePinScreenState createState() => _UpdatePinScreenState();
}

class _UpdatePinScreenState extends State<UpdatePinScreen> {
  ScreenUtil screenUtil = ScreenUtil();
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

  final TextEditingController controller13 = new TextEditingController();
  final TextEditingController controller14 = new TextEditingController();
  final TextEditingController controller15 = new TextEditingController();
  final TextEditingController controller16 = new TextEditingController();
  final TextEditingController controller17 = new TextEditingController();
  final TextEditingController controller18 = new TextEditingController();

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

  final FocusNode focusNode13 = FocusNode();
  final FocusNode focusNode14 = FocusNode();
  final FocusNode focusNode15 = FocusNode();
  final FocusNode focusNode16 = FocusNode();
  final FocusNode focusNode17 = FocusNode();
  final FocusNode focusNode18 = FocusNode();

  String oldPin = "";
  String newPin = "";
  String confirmPin = "";

  String oldPinErrorMsg = "Please Enter 6 digit old PIN";
  String newPinErrorMsg = "Please enter 6 digit new PIN";
  String reEnterNewPinErrorMsg = "Pin Re-enter 6 digit new PIN";

  bool isOldError = false;
  bool isNewPinError = false;
  bool isConfirmPinError = false;

  UpdatepinBloc updatePinBloc = UpdatepinBloc();
  ToastUtil toastUtil = ToastUtil();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    updatePinBloc.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdatepinBloc, UpdatepinState>(
      cubit: updatePinBloc,
      buildWhen: (prevState, state) {
        if (state is UpdatepinInitial) {
          return false;
        }

        if (state is UpdateSecurityPinState) {
          Navigator.pop(context);
          if (state.isNetworkConnected == true &&
              state.resData.code.toString() == "200") {
            setPinAlert();
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context)
                  .pushReplacementNamed(RouteConst.routeSettingsScreen);
            });
          } else if (state.isNetworkConnected == false) {
            toastUtil.showMsg(Constant.noInternetMsg, Colors.black,
                Colors.white, 12.0, "short", "bottom");
          } else {
            toastUtil.showMsg(state.resData.message, Colors.black, Colors.white,
                12.0, "short", "bottom");
          }

          return false;
        }
        return false;
      },
      builder: (context, state) {
        if (state is UpdatepinLoadedState) {
          return WillPopScope(
            onWillPop: () async {
              Navigator.of(context)
                  .pushReplacementNamed(RouteConst.routeSettingsScreen);
              return true;
            },
            child: Scaffold(
              backgroundColor: kBackgroundColor2,
              body: Container(
                height: double.infinity,
                width: double.infinity,
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
                                RouteConst.routeSettingsScreen);
                          },
                        ),
                      ),
                      Padding(
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
                                "Update PIN",
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
                                "Enter old PIN",
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
                                  color: isOldError
                                      ? Colors.red
                                      : kTextColor6.withOpacity(0.3),
                                ),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: enterOldPinWidget(),
                            ),
                            if (isOldError)
                              Container(
                                padding: EdgeInsets.only(
                                    top: screenUtil.setHeight(8.0),
                                    left: screenUtil.setWidth(12.0)),
                                child: Text(
                                  oldPinErrorMsg,
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
                                "Enter new PIN",
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
                                  color: isNewPinError
                                      ? Colors.red
                                      : kTextColor6.withOpacity(0.3),
                                ),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: enterNewPinWidget(),
                            ),
                            if (isNewPinError)
                              Container(
                                padding: EdgeInsets.only(
                                    top: screenUtil.setHeight(8.0),
                                    left: screenUtil.setWidth(12.0)),
                                child: Text(
                                  newPinErrorMsg,
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
                                "Re-enter new PIN",
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
                                  color: isConfirmPinError
                                      ? Colors.red
                                      : kTextColor6.withOpacity(0.3),
                                ),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: reEnterNewPinWidget(),
                            ),
                            if (isConfirmPinError)
                              Container(
                                padding: EdgeInsets.only(
                                    top: screenUtil.setHeight(8.0),
                                    left: screenUtil.setWidth(12.0)),
                                child: Text(
                                  reEnterNewPinErrorMsg,
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
                                top: screenUtil.setHeight(50.0),
                                bottom: screenUtil.setWidth(20.0),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  validatePin(1, 4);
                                },
                                child: HelperUtil.buttonWithGradientColor(
                                    context: context, text: "UPDATE"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(),
          );
        }
      },
    );
  }

  void setPinAlert() {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 500),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
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
                        "Your PIN has been updated successfully.",
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

  Widget enterOldPinWidget() {
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

  Widget enterNewPinWidget() {
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

  Widget reEnterNewPinWidget() {
    return Container(
      child: Row(
        children: [
          pinTextFiled(controller13, focusNode13, focusNode14, null, 3),
          verticalSeparator(),
          pinTextFiled(controller14, focusNode14, focusNode15, focusNode13, 3),
          verticalSeparator(),
          pinTextFiled(controller15, focusNode15, focusNode16, focusNode14, 3),
          verticalSeparator(),
          pinTextFiled(controller16, focusNode16, focusNode17, focusNode15, 3),
          verticalSeparator(),
          pinTextFiled(controller17, focusNode17, focusNode18, focusNode16, 3),
          verticalSeparator(),
          pinTextFiled(controller18, focusNode18, null, focusNode17, 3),
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

  // type 1. validate old pin 2. validate new pin 3. validate reenter new pin 4. validate all
  void validatePin(int from, int type) {
    oldPin = controller1.text +
        controller2.text +
        controller3.text +
        controller4.text +
        controller5.text +
        controller6.text;
    newPin = controller7.text +
        controller8.text +
        controller9.text +
        controller10.text +
        controller11.text +
        controller12.text;

    confirmPin = controller13.text +
        controller14.text +
        controller15.text +
        controller16.text +
        controller17.text +
        controller18.text;
    setState(() {
      if (oldPin.length != 6 && type == 1 || oldPin.length != 6 && type == 4) {
        isOldError = true;
        isNewPinError = false;
        isConfirmPinError = false;
      } else if (newPin.length != 6 && type == 2 ||
          newPin.length != 6 && type == 4) {
        isOldError = false;
        isNewPinError = true;
        isConfirmPinError = false;
      } else if (confirmPin.length != 6 && type == 3 ||
          confirmPin.length != 6 && type == 4) {
        isOldError = false;
        isNewPinError = false;
        isConfirmPinError = true;
        reEnterNewPinErrorMsg = "Please Re-enter 6 digit new PIN";
      } else if (newPin != confirmPin && type == 3 ||
          newPin != confirmPin && type == 4) {
        isOldError = false;
        isNewPinError = false;
        isConfirmPinError = true;
        reEnterNewPinErrorMsg = "Please Re-enter correct pin";
      } else {
        isOldError = false;
        isNewPinError = false;
        isConfirmPinError = false;

        if (from == 1) {
          HelperUtil.checkInternetConnection().then((internet) {
            if (internet) {
              HelperUtil.showLoaderDialog(context);

              updatePinBloc
                  .add(UpdateSecurityPinEvent(oldPin: oldPin, newPin: newPin));
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
