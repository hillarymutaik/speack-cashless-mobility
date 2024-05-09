// import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';

// class FormFieldFrave extends StatelessWidget {
//   final TextEditingController? controller;
//   final String? hintText;
//   final bool isPassword;
//   final TextInputType keyboardType;
//   final int maxLine;
//   final bool readOnly;
//   final FormFieldValidator<String>? validator;

//   const FormFieldFrave(
//       {this.controller,
//       this.hintText,
//       this.isPassword = false,
//       this.keyboardType = TextInputType.text,
//       this.maxLine = 1,
//       this.readOnly = false,
//       this.validator});

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       style: const TextStyle(
//         fontFamily: 'Roboto',
//         fontSize: 13,
//         color: Color.fromARGB(255, 1, 40, 99),
//       ),
//       obscureText: isPassword,
//       maxLines: maxLine,
//       readOnly: readOnly,
//       keyboardType: keyboardType,
//       decoration: InputDecoration(
//         fillColor: Colors.blueGrey.shade50,
//         filled: true,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
//         enabledBorder: const OutlineInputBorder(
//             borderSide: BorderSide(width: .25, color: Colors.grey)),
//         contentPadding: const EdgeInsets.only(left: 15.0),
//         hintText: hintText,
//         hintStyle: const TextStyle(
//             fontFamily: 'Roboto', color: Colors.black54, fontSize: 12),
//       ),
//       validator: validator,
//     );
//   }
// }
