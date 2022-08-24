import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:therapy_app/constants/constants.dart';
import 'package:therapy_app/main.dart';
import 'package:therapy_app/services/Authentication.dart';
import 'package:therapy_app/services/FirebaseOperations.dart';
import 'package:profanity_filter/profanity_filter.dart';

class UploadPost with ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  TextEditingController postController = TextEditingController();
  final filter = ProfanityFilter();
  // Future uploadPostImageToFirebase() async {

  // }

  Future editPostSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 30.0,
                        width: 30.0,
                        // child: Image.asset('assets/badges/badge-04.png'),
                      ),
                      Container(
                        height: 110.0,
                        width: 5.0,
                        color: constantColors.blueColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          height: 120.0,
                          width: 330.0,
                          child: TextField(
                            maxLines: 5,
                            //* textAlign: TextAlign.start,
                            textCapitalization: TextCapitalization.words,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(100)
                            ],
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            maxLength: 100,
                            controller: postController,
                            style: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              hintText: 'Let out your burden!',
                              hintStyle: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                MaterialButton(
                  //* MIGHT DO IN THE FUTURE :
                  // child: Icon(
                  //   FontAwesomeIcons.check,
                  //   color: constantColors.whiteColor,
                  // ),
                  //*
                  child: Text(
                    'Share',
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  onPressed: () async {
                    bool hasProfanity =
                        filter.hasProfanity(postController.text);
                    if (hasProfanity == true) {
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Error!"),
                            content: Text("Your post contains explicit words!"),
                            actions: [
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Edit your post!"),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      Provider.of<FirebaseOperations>(context, listen: false)
                          .uploadPostData(postController.text, {
                        'caption': postController.text,
                        'username': Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .getInitUserName,
                        'userimage': Provider.of<FirebaseOperations>(context,
                                listen: false)
                            .getInitUserImage,
                        'useruid':
                            Provider.of<Authentication>(context, listen: false)
                                .getUserUid,
                        'time': Timestamp.now()
                      }).whenComplete(() {
                        Navigator.pop(context);
                      });
                    }
                  },
                  color: constantColors.greenColor,
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.circular(12.0)),
          );
        });
  }
}
