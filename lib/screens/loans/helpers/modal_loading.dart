import 'package:flutter/material.dart';

import '../components/colors_frave.dart';
import '../components/text_custom.dart';

void modalLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.white54,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      content: SizedBox(
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const TextCustom(
                    text: 'Mtwende ',
                    color: ColorsFrave.primaryColor,
                    fontWeight: FontWeight.w500),
                TextCustom(
                  text: 'Parcels',
                  fontWeight: FontWeight.w500,
                  color: Colors.red.shade900,
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 10.0),
            Row(
              children: const [
                CircularProgressIndicator(color: ColorsFrave.primaryColor),
                SizedBox(width: 15.0),
                TextCustom(text: 'Loading...')
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
