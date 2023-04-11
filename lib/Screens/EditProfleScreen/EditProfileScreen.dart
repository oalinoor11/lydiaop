import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/editprofile_bloc.dart';
import 'widgets/chooseProfileWidget.dart';
import 'widgets/editProfileAppbar.dart';
import 'widgets/getTextFieldStyle.dart';
import 'widgets/validationClass.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  EditprofileBloc editProfile = EditprofileBloc();

  final TextEditingController fnameController = new TextEditingController();
  final TextEditingController lnameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();

  final FocusNode fnameFocusNode = FocusNode();
  final FocusNode lnameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();

  final emailKey = GlobalKey<FormFieldState>();
  final fnameKey = GlobalKey<FormFieldState>();
  final lnameKey = GlobalKey<FormFieldState>();

  GlobalKey<FormState> key = new GlobalKey();
  bool validate = false;

  bool isReadOnly = true;

  String profileImage = "";
  String emailAddress = "";
  String firstName = "";
  String lastName = "";
  bool alreadyLogin;
  String type = "1";

  final ValueNotifier<File> selectedImage = ValueNotifier<File>(null);

  ScreenUtil screenUtil = ScreenUtil();
  HelperUtil helperUtil = HelperUtil();
  ToastUtil toastUtil = ToastUtil();

  @override
  void initState() {
    super.initState();
    getBasicInfo();
  }

  Future getBasicInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      alreadyLogin = prefs.getString("alreadyLogin") == "true" ? true : false;
      profileImage = prefs.getString("profileImage") ?? "";
      firstName = prefs.getString("firstName") ?? "";
      lastName = prefs.getString("lastName") ?? "";
      emailAddress = prefs.getString("email") ?? "";

      fnameController.text = "$firstName";
      lnameController.text = "$lastName";
      emailController.text = "$emailAddress";
    });
  }

  @override
  void dispose() {
    editProfile?.close();
    selectedImage?.dispose();
    super.dispose();
  }

  void editButtonPressed() {
    setState(() {
      if (isReadOnly == false) {
        validate = true;
        if (!emailKey.currentState.validate()) {
          emailFocusNode.requestFocus();
        } else if (!fnameKey.currentState.validate()) {
          fnameFocusNode.requestFocus();
        } else if (!lnameKey.currentState.validate()) {
          lnameFocusNode.requestFocus();
        } else {
          HelperUtil.checkInternetConnection().then((internet) {
            if (internet) {
              HelperUtil.showLoaderDialog(context);
              editProfile.add(UpdateProfileDetailsEvent(
                  firtsName: fnameController.text,
                  lastName: lnameController.text,
                  imagePath: (selectedImage.value != null &&
                          selectedImage.value.path != null)
                      ? selectedImage.value.path
                      : "",
                  type: type));
            } else {
              toastUtil.showMsg(Constant.noInternetMsg, Colors.black,
                  Colors.white, 12.0, "short", "bottom");
            }
          });
        }
      } else {
        isReadOnly = !isReadOnly;
      }
    });
  }

  camera() async {
    var img = await ImagePicker().getImage(
      source: ImageSource.camera,
    );

    if (img != null && img.path != null) {
      selectedImage.value = File(img.path);
      type = "1";
      Navigator.pop(context);
    }
  }

  chooseImage() async {
    var img = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (img != null && img.path != null) {
      selectedImage.value = File(img.path);
      type = "1";
      Navigator.pop(context);
    }
  }

  deletePhoto() {
    selectedImage.value = null;
    profileImage = "";
    type = "2";
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditprofileBloc, EditprofileState>(
      cubit: editProfile,
      buildWhen: (prevState, state) {
        if (state is EditprofileInitial) {
          return false;
        }
        if (state is UploadProfileState) {
          Navigator.pop(context);
          state.profileResp.stream.transform(utf8.decoder).listen((value) {
            var jsonData = json.decode(value);
            if (state.isNetworkConnected == true &&
                jsonData["code"].toString() == "200") {
              SharedPreferenceUtil _sharedPreference = SharedPreferenceUtil();
              _sharedPreference.addSharedPref('profileImage',
                  "${jsonData["result"]["profileImg"]["filePath"]}");
              _sharedPreference.addSharedPref(
                  'firstName', "${jsonData["result"]["firstName"]}");
              _sharedPreference.addSharedPref(
                  'lastName', "${jsonData["result"]["lastName"]}");

              profileUpdatedAlert();
              Future.delayed(Duration(seconds: 3), () {
                Navigator.of(context).pushNamed(RouteConst.routeMainDashboard);
              });
            } else if (state.isNetworkConnected == false) {
              toastUtil.showMsg(Constant.noInternetMsg, Colors.black,
                  Colors.white, 12.0, "short", "bottom");
            } else {
              toastUtil.showMsg("${jsonData["message"]}", Colors.black,
                  Colors.white, 12.0, "short", "bottom");
            }
          });
          return false;
        }
        return true;
      },
      // ignore: missing_return
      builder: (context, state) {
        if (state is EditprofileLoadedState) {
          return Scaffold(
            backgroundColor: kBackgroundColor2,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(screenUtil.setHeight(85)),
              child: editProfileAppbar(
                  context, editButtonPressed, isReadOnly, screenUtil),
            ),
            body: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: HelperUtil.backgroundGradient(),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Container(
                    width: double.infinity,
                    child: Form(
                      key: key,
                      autovalidate: false,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin:
                                EdgeInsets.only(top: screenUtil.setHeight(48)),
                            child: GestureDetector(
                              onTap: () {
                                if (isReadOnly == false) {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  showUploadOptionsBottomModalSheet();
                                }
                              },
                              child: ValueListenableBuilder(
                                builder: (context, selImage, Widget child) {
                                  return Stack(children: [
                                    selectedImage.value != null
                                        ? Container(
                                            height: 100,
                                            width: 100,
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  kBackgroundColor4,
                                              child: Container(
                                                margin: EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                  image: DecorationImage(
                                                    image: FileImage(selImage),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                height: 100,
                                                width: 100,
                                              ),
                                            ),
                                          )
                                        : profileImage == ""
                                            ? Container(
                                                height: 100,
                                                width: 100,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      kBackgroundColor2,
                                                  radius: 50.0,
                                                  child: ClipOval(
                                                    child: Image.asset(
                                                      ImageConst
                                                          .profileDefalutImg,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                height: 100,
                                                width: 100,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      kBackgroundColor4,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(2),
                                                    child: CachedNetworkImage(
                                                      imageUrl: profileImage,
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                        height: 98,
                                                        width: 98,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          image:
                                                              DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      placeholder:
                                                          (context, url) =>
                                                              Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Image.asset(
                                                        ImageConst
                                                            .profileDefalutImg,
                                                        fit: BoxFit.fill,
                                                      ),
                                                      height: 98,
                                                      width: 98,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                    isReadOnly
                                        ? SizedBox(
                                            height: 0,
                                          )
                                        : Container(
                                            margin: new EdgeInsets.only(
                                                top: 75.0,
                                                left: 65,
                                                right: 0.0,
                                                bottom: 0.0),
                                            height: 25,
                                            width: 25,
                                            child: new CircleAvatar(
                                                backgroundColor: Colors.white,
                                                radius: 60.0,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: new SvgPicture.asset(
                                                    ImageConst.selectCameraImg,
                                                    fit: BoxFit.fill,
                                                    color: kTextColor5
                                                        .withOpacity(0.8),
                                                  ),
                                                )),
                                          )
                                  ]);
                                },
                                valueListenable: selectedImage,
                              ),
                            ),
                          ),

                          ///
                          Container(
                            margin: EdgeInsets.only(
                              top: screenUtil.setHeight(24),
                            ),
                            child: Text(
                              "$firstName $lastName",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenUtil.setSp(18),
                                  fontFamily: "HelveticaNeue"),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                              top: screenUtil.setHeight(29),
                              left: screenUtil.setWidth(18),
                              right: screenUtil.setWidth(18),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    top: screenUtil.setHeight(24),
                                  ),
                                  child: textfieldLabel(
                                      "Email Address", screenUtil),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: screenUtil.setHeight(10),
                                  ),
                                  child: TextFormField(
                                    onTap: () {},
                                    readOnly: true,
                                    key: emailKey,
                                    focusNode: emailFocusNode,
                                    controller: emailController,
                                    cursorColor: kTextColor5,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: validateEmail,
                                    onChanged: (text) {
                                      emailKey.currentState.validate();
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(
                                          RegExp('[  ]')),
                                      FilteringTextInputFormatter.deny(RegExp(
                                          r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])')),
                                    ],
                                    style: getTextFieldStyle(),
                                    decoration: getInputDecoration(
                                        "Enter email address",
                                        1,
                                        true,
                                        screenUtil),
                                  ),
                                ),
                                //
                                Container(
                                  margin: EdgeInsets.only(
                                    top: screenUtil.setHeight(24),
                                  ),
                                  child:
                                      textfieldLabel("First Name", screenUtil),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: screenUtil.setHeight(10),
                                  ),
                                  child: TextFormField(
                                    onTap: () {},
                                    readOnly: isReadOnly,
                                    maxLength: 30,
                                    key: fnameKey,
                                    focusNode: fnameFocusNode,
                                    controller: fnameController,
                                    cursorColor: kTextColor5,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    keyboardType: TextInputType.text,
                                    validator: validateFirstName,
                                    onChanged: (text) {
                                      fnameKey.currentState.validate();
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[a-zA-Z ]")),
                                      FilteringTextInputFormatter.deny(
                                          RegExp(r"\s\s")),
                                    ],
                                    style: getTextFieldStyle(),
                                    decoration: getInputDecoration(
                                        "Enter first name",
                                        2,
                                        isReadOnly,
                                        screenUtil),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: screenUtil.setHeight(24),
                                  ),
                                  child:
                                      textfieldLabel("Last Name", screenUtil),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: screenUtil.setHeight(10),
                                  ),
                                  child: TextFormField(
                                    onTap: () {},
                                    readOnly: isReadOnly,
                                    maxLength: 30,
                                    key: lnameKey,
                                    focusNode: lnameFocusNode,
                                    validator: validateLastName,
                                    controller: lnameController,
                                    cursorColor: kTextColor5,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    keyboardType: TextInputType.text,
                                    onChanged: (text) {
                                      lnameKey.currentState.validate();
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[a-zA-Z ]")),
                                      FilteringTextInputFormatter.deny(
                                          RegExp(r"\s\s")),
                                    ],
                                    style: getTextFieldStyle(),
                                    decoration: getInputDecoration(
                                        "Enter last name",
                                        3,
                                        isReadOnly,
                                        screenUtil),
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
              ),
            ),
          );
        }
      },
    );
  }

  showUploadOptionsBottomModalSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      isDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop();
            return true;
          },
          child: Container(
            height: screenUtil.setHeight(160),
            decoration: BoxDecoration(
              color: kAppbarColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(0, -7),
                    blurRadius: 15)
              ],
            ),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return LimitedBox(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            width: 80,
                            height: 3,
                            decoration: BoxDecoration(
                                color: kTextColor5,
                                borderRadius: BorderRadius.circular(3)),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: screenUtil.setHeight(30),
                          left: screenUtil.setWidth(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            chooseProfileWidget(
                                title: "Remove photo",
                                image: ImageConst.deletePhotoImg,
                                onTap: () {
                                  deletePhoto();
                                },
                                screenUtil: screenUtil),
                            chooseProfileWidget(
                                title: "Gallery",
                                image: ImageConst.selectGalleryImg,
                                onTap: () {
                                  chooseImage();
                                },
                                screenUtil: screenUtil),
                            chooseProfileWidget(
                                title: "Camera",
                                image: ImageConst.selectCameraImg,
                                onTap: () {
                                  camera();
                                },
                                screenUtil: screenUtil),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void profileUpdatedAlert() {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return WillPopScope(
          onWillPop: () {},
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: screenUtil.setWidth(339),
              height: screenUtil.setHeight(190),
              child: Container(
                decoration: BoxDecoration(
                  color: kAppbarColor,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.6),
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
                      // Container(
                      //   child: Text(
                      //     "THANK YOU!",
                      //     style: TextStyle(
                      //         color: Colors.white,
                      //         fontFamily: "Poppins",
                      //         fontSize: screenUtil.setSp(24.0),
                      //         fontWeight: FontWeight.w500),
                      //     textAlign: TextAlign.center,
                      //   ),
                      // ),

                      Container(
                        child: SvgPicture.asset(
                          ImageConst.successImg,
                          width: screenUtil.setWidth(56),
                          height: screenUtil.setHeight(59),
                        ),
                      ),
                      SizedBox(
                        height: 21,
                      ),
                      Container(
                        child: Text(
                          "Your profile has been updated \nsuccessfully.",
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
}
