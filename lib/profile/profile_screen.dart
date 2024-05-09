// ignore_for_file: unused_element

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../auth/login_screen.dart';
import 'otp_screen.dart';
import 'package:image_picker/image_picker.dart';

// ignore: use_key_in_widget_constructors
class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _LocationPageState();
}

class _LocationPageState extends State<ProfileScreen> {
  String? tokenzz;
  String? username;
  String? phone;
  String? fullname;
  String? email;
  String? status;

  void account() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenzz = prefs.getString('jwt')!;
    Map<String, dynamic> token = jsonDecode(tokenzz!);
    // print(token);
    setState(() {
      username = '${token['data']['user']['username']}';
      phone = '${token['data']['user']['phoneNumber']}';
      fullname = '${token['data']['user']['fullName']}';
      email = '${token['data']['user']['email']}';
      status = '${token['data']['user']['status']}';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadImages();
    account();
  }

  void _launchURL() async {
    const url = 'http://52.23.50.252:9077/api/privacy';
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchTerms() async {
    const url = 'http://52.23.50.252:9077/api/terms';
    // ignore: deprecated_member_use
    if (await canLaunch(url)) {
      // ignore: deprecated_member_use
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String backgroundImage = 'assets/logo.jpg';
  String logoImage = 'assets/logo.jpg';

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _loadImages() async {
    try {
      final file = File('image_paths.json');
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final jsonMap = json.decode(jsonString);
        setState(() {
          backgroundImage = jsonMap['backgroundImage'];
          logoImage = jsonMap['logoImage'];
        });
      }
    } catch (e) {
      print('Error loading images: $e');
    }
  }

  Future<void> _saveImage(Uint8List bytes, String imageType) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final String assetsDirectory =
          directory.path; // Use the documents directory
      final String fileName =
          imageType == 'background' ? 'background.jpg' : 'logo.jpg';

      final String imagePath = '$assetsDirectory/$fileName';
      final File imageFile = File(imagePath);

      await imageFile.writeAsBytes(bytes);

      setState(() {
        if (imageType == 'background') {
          backgroundImage = imagePath;
        } else if (imageType == 'logo') {
          logoImage = imagePath;
        }
      });

      print('Image saved to: $imagePath');
    } catch (e) {
      print('Error saving image: $e');
    }
  }

  Future<void> getImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(source: source);
      if (pickedFile != null) {
        final imageBytes = await pickedFile.readAsBytes();
        await _saveImage(
            imageBytes, 'background'); // Example: Saving as background image
      }
    } catch (e) {
      print('Error getting image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("Profile",
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'Baloo2',
                fontWeight: FontWeight.bold,
                color: Colors.lightBlueAccent.shade100,
              )),
          centerTitle: false,
          automaticallyImplyLeading: false,
          // iconTheme:
          //     const IconThemeData(color: Colors.lightBlueAccent, size: 30),
          actions: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text("$status",
                    style: TextStyle(
                      fontSize: 8,
                      color: Colors.lightGreenAccent.shade200,
                    ))),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Opacity(
                    opacity: .5,
                    child: Container(
                        height: MediaQuery.of(context).size.height * .34,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(backgroundImage),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.white,
                                blurRadius: 5,
                                offset: Offset(2, 2)),
                          ],
                        ),
                        margin: EdgeInsets.only(bottom: 50))),
                GestureDetector(
                  onTap: () {
                    getImage(ImageSource.gallery);
                  },
                  child: Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                        child: Image.asset(
                          logoImage,
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.height * 0.12,
                        ),
                      ),
                      Positioned(
                        top: 40,
                        right: 4,
                        child: Icon(Icons.camera_alt_rounded,
                            size: 25, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.transparent.withOpacity(.1),
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  AccountLinkWidget(
                    icon: const Icon(
                      Icons.person_outline,
                      color: Colors.blueGrey,
                    ),
                    text: Text(
                      '$fullname',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onTap: (e) {},
                  ),
                  AccountLinkWidget(
                    icon: const Icon(
                      Icons.phone,
                      color: Colors.blueGrey,
                    ),
                    text: Text(
                      '$phone',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onTap: (e) {},
                  ),
                  AccountLinkWidget(
                    icon: const Icon(
                      Icons.email,
                      color: Colors.blueGrey,
                    ),
                    text: Text(
                      '$email',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onTap: (e) {},
                  ),
                ],
              ),
            ),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.transparent.withOpacity(.1),
                    borderRadius: BorderRadius.circular(8)),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctx) => OTPPINScreen()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.pin_rounded,
                          color: Colors.blueGrey,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          width: 1,
                          height: 24,
                          color: Colors.grey.withOpacity(0.8),
                        ),
                        Expanded(
                          child: const Text(
                            'Change Wallet Pin',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.edit_rounded,
                          size: 12,
                          color: Colors.blueGrey,
                        ),
                      ],
                    ),
                  ),
                )),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.transparent.withOpacity(.1),
                  // border: Border.all(
                  //     // color: Get.theme.focusColor.withOpacity(0.2),
                  //     ),
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  AccountLinkWidget(
                    icon: const Icon(
                      Icons.privacy_tip_rounded,
                      color: Colors.blueGrey,
                    ),
                    text: const Text(
                      'Privacy Policy',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onTap: (e) {
                      _launchURL();
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.transparent.withOpacity(.1),
                  // border: Border.all(
                  //     // color: Get.theme.focusColor.withOpacity(0.2),
                  //     ),
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  AccountLinkWidget(
                    icon: const Icon(
                      Icons.privacy_tip_outlined,
                      color: Colors.blueGrey,
                    ),
                    text: const Text(
                      'Terms and Conditions',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onTap: (e) {
                      _launchTerms();
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.transparent.withOpacity(.1),
                  // border: Border.all(
                  //     // color: Get.theme.focusColor.withOpacity(0.2),
                  //     ),
                  borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  AccountLinkWidget(
                    icon: Icon(
                      Icons.logout,
                      color: Colors.redAccent.shade100,
                    ),
                    text: const Text("Logout"),
                    onTap: (e) async {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                height:
                                    MediaQuery.of(context).size.height * 0.18,
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    const Text(
                                      "Are you sure to logout?",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            margin: EdgeInsets.all(
                                              MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.018,
                                            ),
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                                color: Colors.redAccent
                                                    .withOpacity(0.6),
                                                border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.2),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            child: const Center(
                                              child: Text("Cancel",
                                                  maxLines: 2,
                                                  softWrap: false,
                                                  overflow: TextOverflow.fade,
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.white)),
                                            ),
                                          ),
                                        )),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () async {
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              prefs
                                                  .remove('jwt')
                                                  .then((value) =>
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const SignInScreen())))
                                                  .onError((error,
                                                          stackTrace) =>
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              SnackBar(
                                                        content: Text('$error'),
                                                      )));
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              margin: EdgeInsets.all(
                                                MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.018,
                                              ),
                                              padding: const EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                  color: Colors
                                                      .lightBlueAccent, //Get.theme.primaryColor,
                                                  border: Border.all(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(6)),
                                              child: const Center(
                                                child: Text("Ok",
                                                    maxLines: 2,
                                                    softWrap: false,
                                                    overflow: TextOverflow.fade,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.white)),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                  ),
                ],
              ),
            ),
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //   margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            //   decoration: BoxDecoration(
            //       color: Colors.transparent.withOpacity(.1),
            //       borderRadius: BorderRadius.circular(8)),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text("Delete your account!",
            //                 style: TextStyle(
            //                     color: Colors.redAccent.shade400,
            //                     fontSize: 15)),
            //             const SizedBox(
            //               height: 5,
            //             ),
            //             Text(
            //                 "Once you delete this account, there is no going back. Please be certain.",
            //                 style: TextStyle(
            //                     color: Colors.blue.shade900, fontSize: 12)),
            //           ],
            //         ),
            //       ),
            //       const SizedBox(width: 10),
            //       MaterialButton(
            //         onPressed: () {
            //           showDialog<void>(
            //             context: context,
            //             barrierDismissible: false, // user must tap button!
            //             builder: (BuildContext context) {
            //               return AlertDialog(
            //                 title: Text(
            //                   "Delete your account!",
            //                   style:
            //                       TextStyle(color: Colors.redAccent.shade200),
            //                 ),
            //                 content: SingleChildScrollView(
            //                   child: Column(
            //                     children: <Widget>[
            //                       Text(
            //                         "Once you delete this account, there is no going back. Please be certain.",
            //                         style:
            //                             TextStyle(color: Colors.blue.shade900),
            //                       ),
            //                     ],
            //                   ),
            //                 ),
            //                 actions: <Widget>[
            //                   TextButton(
            //                     child: const Text("Cancel"),
            //                     onPressed: () {
            //                       Navigator.pop(context);
            //                     },
            //                   ),
            //                   TextButton(
            //                     child: const Text(
            //                       "Confirm",
            //                       style: TextStyle(color: Colors.redAccent),
            //                     ),
            //                     onPressed: () async {
            //                       Navigator.pop(context);
            //                     },
            //                   ),
            //                 ],
            //               );
            //             },
            //           );
            //         },
            //         padding: const EdgeInsets.symmetric(
            //             horizontal: 30, vertical: 12),
            //         shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(10)),
            //         color: Colors.redAccent,
            //         elevation: 0,
            //         highlightElevation: 0,
            //         hoverElevation: 0,
            //         focusElevation: 0,
            //         child: const Text("Delete"),
            //       ),
            //     ],
            //   ),
            // )
          ],
        )));
  }
}

class AccountLinkWidget extends StatelessWidget {
  final Icon icon;
  final Widget text;
  final ValueChanged<void> onTap;

  const AccountLinkWidget({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap('');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          children: [
            icon,
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              width: 1,
              height: 24,
              color: Colors.grey.withOpacity(0.8),
            ),
            Expanded(
              child: text,
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: Colors.blueGrey,
            ),
          ],
        ),
      ),
    );
  }
}

            // Stack(
            //   alignment: AlignmentDirectional.centerStart,
            //   children: [
            //     Opacity(
            //       opacity: 0.85,
            //       child: GestureDetector(
            //         onTap: () {
            //           // _getImage(ImageSource.gallery, 'background');
            //         },
            //         child: Stack(
            //           children: [
            //             Container(
            //               height: MediaQuery.of(context).size.height * 0.34,
            //               width: MediaQuery.of(context).size.width,
            //               decoration: BoxDecoration(
            //                 image: DecorationImage(
            //                   image: AssetImage(backgroundImage),
            //                   fit: BoxFit.fitWidth,
            //                 ),
            //                 borderRadius: const BorderRadius.vertical(
            //                     bottom: Radius.circular(35)),
            //                 boxShadow: const [
            //                   BoxShadow(
            //                     color: Colors.white70,
            //                     blurRadius: 5,
            //                     offset: Offset(2, 2),
            //                   ),
            //                 ],
            //               ),
            //               margin: const EdgeInsets.only(bottom: 0),
            //             ),
            //             Positioned(
            //               bottom: 25,
            //               right: 5,
            //               child: Container(
            //                 margin: const EdgeInsets.all(5),
            //                 decoration: BoxDecoration(
            //                   shape: BoxShape.circle,
            //                   color: Colors.grey.withOpacity(0.5),
            //                 ),
            //                 child: IconButton(
            //                   onPressed: () {
            //                     // _getImage(ImageSource.gallery, 'background');
            //                   },
            //                   icon: const Icon(Icons.camera_alt_rounded,
            //                       size: 20, color: Colors.grey),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //     Padding(
            //       padding: EdgeInsets.only(left: 10),
            //       child: GestureDetector(
            //         onTap: () {
            //           // _getImage(ImageSource.gallery, 'logo');
            //         },
            //         child: Stack(
            //           alignment: AlignmentDirectional.topEnd,
            //           children: [
            //             ClipRRect(
            //               borderRadius:
            //                   const BorderRadius.all(Radius.circular(100)),
            //               child: Image.asset(
            //                 logoImage,
            //                 fit: BoxFit.cover,
            //                 height: MediaQuery.of(context).size.height * 0.1,
            //               ),
            //             ),
            //             Positioned(
            //               top: 25,
            //               right: 2,
            //               child: Icon(Icons.camera_alt_rounded,
            //                   size: 18,
            //                   color: Colors.grey.shade200.withOpacity(0.7)),
            //             ),
            //           ],
            //         ),
            //       ),
            //     )
            //   ],
            // ),