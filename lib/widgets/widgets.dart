import 'package:flutter/material.dart';

Widget loginAppBar(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 22),
          children: <TextSpan>[
            TextSpan(
                text: 'Comm',
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.grey.shade200)),
            const TextSpan(
                text: 'Unify',
                style:
                TextStyle(fontWeight: FontWeight.w600, color: Color(0xAAe7eef6))),
          ],
        ),
        textAlign: TextAlign.center,
      ),

    ],
  );
}

Widget appBar(BuildContext context) {
  return Row(
    children: [
      RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 22),
          children: <TextSpan>[
            TextSpan(
                text: 'Comm',
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.grey.shade200)),
            const TextSpan(
                text: 'Unify',
                style:
                    TextStyle(fontWeight: FontWeight.w600, color: Color(0xAAe7eef6))),
          ],
        ),
      ),

    ],
  );
}

// Widget logoutButton(BuildContext context) {
//   return SizedBox(
//     width: 50.0,
//     height: 45.0,
//     child: Container(
//         margin: const EdgeInsets.all(10.0),
//         decoration: const BoxDecoration(
//           color: Colors.transparent,
//           shape: BoxShape.rectangle,
//         ),
//         child: const Icon(Icons.logout, color: Colors.black,)),
//   );
// }

Widget blueButton(BuildContext context, String label, [buttonWidth]) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 18),
    decoration: BoxDecoration(
        color: const Color(0xff98c1c9), borderRadius: BorderRadius.circular(25)),
    alignment: Alignment.center,
    width: buttonWidth != null ? buttonWidth : MediaQuery.of(context).size.width - 48,
    child: Text(
      label,
      style: const TextStyle(color: Colors.white, fontSize: 16),
    ),
  );
}

