import 'package:flutter/material.dart';
import 'package:flutter_app/Resources/ColorConst.dart';
import 'package:flutter_app/Resources/ImageConstant.dart';
import 'package:flutter_svg/svg.dart';

Widget editProfileAppbar(
    context, Function editButtonTapped, bool isReadOnly, screenUtil) {
  return Container(
    decoration: BoxDecoration(
      color: kAppbarColor,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(15.0),
        bottomRight: Radius.circular(15.0),
      ),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: Offset(0, 7),
            blurRadius: 15)
      ],
    ),
    child: Container(
      margin: EdgeInsets.only(
        top: screenUtil.setHeight(54.0),
        bottom: screenUtil.setHeight(15.00),
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(
              left: screenUtil.setWidth(12.00),
            ),
            child: IconButton(
              icon: Image(
                image: AssetImage(ImageConst.backArrowIcon),
                height: screenUtil.setHeight(20),
                width: screenUtil.setWidth(20),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            child: Text(
              "My Profile",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Poppins",
                fontSize: screenUtil.setSp(17.0),
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Spacer(),
          IconButton(
            padding: EdgeInsets.only(
              right: screenUtil.setWidth(18.00),
            ),
            icon: SvgPicture.asset(
              isReadOnly ? ImageConst.editimg : ImageConst.profileCheckImg,
              height: screenUtil.setHeight(18),
              width: screenUtil.setWidth(18),
              color: kTextColor5,
            ),
            onPressed: editButtonTapped,
          )
        ],
      ),
    ),
  );
}
