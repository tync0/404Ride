// import 'package:flutter/material.dart';
// import 'package:uber/widget/draggable_widget.dart';

// class InfoCard extends StatelessWidget {
//   const InfoCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () => showModalBottomSheet<void>(
//         isScrollControlled: true,
//         context: context,
//         builder: (context) => const DraggableWidget(),
//       ),
//       child: SizedBox(
//         width: MediaQuery.sizeOf(context).width,
//         child: Container(
//           height: 65,
//           margin: const EdgeInsets.symmetric(horizontal: 20),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(4),
//             color: Colors.white,
//           ),
//           child: const Row(
//             children: [
//               Expanded(
//                 child: Icon(
//                   Icons.ac_unit,
//                   color: Colors.black,
//                 ),
//               ),
//               SizedBox(width: 5),
//               Expanded(
//                 flex: 5,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Addres',
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 14,
//                       ),
//                     ),
//                     Text(
//                       'Where to?',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
