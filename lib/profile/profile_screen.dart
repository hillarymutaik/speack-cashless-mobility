import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../auth/login_screen.dart';
// import 'package:image_picker/image_picker.dart';

// ignore: use_key_in_widget_constructors
class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _LocationPageState();
}

class _LocationPageState extends State<ProfileScreen> {
  // String? tokenzz = "";
  // String username = '';
  // String phone = '';
  // String fullname = '';
  // String email = '';

  // void account() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   tokenzz = prefs.getString('jwt')!;
  //   Map<String, dynamic> token = jsonDecode(tokenzz!);
  //   setState(() {
  //     username = '${token['user']['username']}';
  //     phone = '${token['user']['phone']}';
  //     fullname = '${token['user']['fullname']}';
  //     email = '${token['user']['email']}';
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _loadImages();
  }
  // void _launchURL() async {
  //   const url = 'https://supermetro.gopay.ke/privacy';
  //   // ignore: deprecated_member_use
  //   if (await canLaunch(url)) {
  //     // ignore: deprecated_member_use
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // void _launchTerms() async {
  //   const url = 'https://supermetro.gopay.ke/terms';
  //   // ignore: deprecated_member_use
  //   if (await canLaunch(url)) {
  //     // ignore: deprecated_member_use
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // void listenChatChannel() {
  //   LaravelEcho.instance.private('trip.${994}').listen('.trip.started', (e) {
  //     if (e is PusherEvent) {
  //       if (e.data != null) {
  //         vLog(jsonDecode(e.data!));
  //         //_handleNewMessage(jsonDecode(e.data!));
  //       } else {
  //         vLog('There is no data');
  //       }
  //     }
  //   }).error((err) {
  //     eLog(err);
  //   });
  // }

  // void leaveChatChannel() {
  //   try {
  //     LaravelEcho.instance.leave('trip.994');
  //   } catch (err) {
  //     eLog(err);
  //   }
  // }
  // Future<void> _getBackground(ImageSource source) async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.getImage(source: source);

  //   if (pickedFile != null) {
  //     setState(() {
  //       if (source == ImageSource.camera) {
  //         backgroundImage = pickedFile.path;
  //       } else {
  //         backgroundImage = pickedFile.path;
  //       }
  //     });
  //   }
  // }

  // Future<void> _getLogo(ImageSource source) async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.getImage(source: source);

  //   if (pickedFile != null) {
  //     setState(() {
  //       if (source == ImageSource.camera) {
  //         backgroundImage = pickedFile.path;
  //       } else {
  //         backgroundImage = pickedFile.path;
  //       }
  //     });
  //   }
  // }
  String backgroundImage = 'assets/logo.jpg';
  String logoImage = 'assets/logo.jpg';

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
    final String assetsDirectory =
        'assets/images'; // Define your assets directory
    final String fileName =
        imageType == 'background' ? 'background.jpg' : 'logo.jpg';

    final Directory directory = Directory(assetsDirectory);
    if (!(await directory.exists())) {
      directory.createSync(recursive: true);
    }

    final String imagePath = '${directory.path}/$fileName';
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
  }

  // Future<void> _getImage(ImageSource source, String imageType) async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.getImage(source: source);

  //   if (pickedFile != null) {
  //     setState(() {
  //       if (imageType == 'background') {
  //         backgroundImage = pickedFile.path;
  //       } else if (imageType == 'logo') {
  //         logoImage = pickedFile.path;
  //       }
  //     });
  //     final imageBytes = await pickedFile.readAsBytes();
  //     await _saveImage(imageBytes, imageType); // Correct the function call
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text("Profile",
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'Baloo2',
                fontWeight: FontWeight.normal,
                color: Color.fromARGB(255, 253, 254, 255),
              )),
          centerTitle: false,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Opacity(
                  opacity: 0.8,
                  child: GestureDetector(
                    onTap: () {
                      // _getImage(ImageSource.gallery, 'background');
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.33,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(backgroundImage),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(10)),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.white,
                                blurRadius: 5,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          margin: const EdgeInsets.only(bottom: 0),
                        ),
                        Positioned(
                          bottom: 25,
                          right: 5,
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                            child: IconButton(
                              onPressed: () {
                                // _getImage(ImageSource.gallery, 'background');
                              },
                              icon: const Icon(Icons.camera_alt_rounded,
                                  size: 20, color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // _getImage(ImageSource.gallery, 'logo');
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
                        top: 25,
                        right: 2,
                        child: Icon(Icons.camera_alt_rounded,
                            size: 18,
                            color: Colors.grey.shade200.withOpacity(0.4)),
                      ),
                    ],
                  ),
                ),
              ],
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
                      Icons.person_outline,
                      color: Colors.blueGrey,
                    ),
                    text: const Text(
                      'Speack Limited',
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
                    text: const Text(
                      '+254727918955',
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
                    text: const Text(
                      'speacklimited@gmail.com',
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
                      // _launchURL();
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
                      // _launchTerms();
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
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.redAccent.shade100,
                          content: const Text('You want to Logout?',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.normal)),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          duration: const Duration(seconds: 5),
                          action: SnackBarAction(
                            label: 'Yes',
                            onPressed: () async {
                              // SharedPreferences prefs =
                              //     await SharedPreferences.getInstance();
                              // prefs
                              //     .remove('jwt')
                              //     .then((value) => Navigator.pushReplacement(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (context) =>
                              //                 const SignInScreen())))
                              //     .onError((error, stackTrace) =>
                              //         ScaffoldMessenger.of(context)
                              //             .showSnackBar(SnackBar(
                              //           content: Text('$error'),
                              //         )));
                            },
                          ),
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.8,
                              right: 40,
                              left: 40)));
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.transparent.withOpacity(.1),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Delete your account!",
                            style: TextStyle(
                                color: Colors.redAccent.shade400,
                                fontSize: 15)),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                            "Once you delete this account, there is no going back. Please be certain.",
                            style: TextStyle(
                                color: Colors.blue.shade900, fontSize: 12)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  MaterialButton(
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              "Delete your account!",
                              style:
                                  TextStyle(color: Colors.redAccent.shade200),
                            ),
                            content: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "Once you delete this account, there is no going back. Please be certain.",
                                    style:
                                        TextStyle(color: Colors.blue.shade900),
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text("Cancel"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: const Text(
                                  "Confirm",
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                                onPressed: () async {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.redAccent,
                    elevation: 0,
                    highlightElevation: 0,
                    hoverElevation: 0,
                    focusElevation: 0,
                    child: const Text("Delete"),
                  ),
                ],
              ),
            )
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
