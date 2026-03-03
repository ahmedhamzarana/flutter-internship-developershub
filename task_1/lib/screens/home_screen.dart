// import 'package:flutter/material.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.white.withAlpha(25),
//         elevation: 100,
//         shadowColor: Colors.black45,
//         title: Text(
//           "Shopping App",
//           style: TextStyle(
//             color: Colors.orange.shade900,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt_outlined)),
//           IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
//         ],
//         // 👇 Proper place for TextField
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(55),
//           child: Padding(
//             padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
//             child: SizedBox(
//               height: 45,
//               child: TextField(
//                 cursorColor: Colors.orange,
//                 decoration: InputDecoration(
//                   hintText: "Search",
//                   hintStyle: TextStyle(color: Colors.grey.shade700),
//                   prefixIcon: const Icon(Icons.search, size: 20),
//                   filled: true,
//                   fillColor: Colors.grey.withAlpha(100),
//                   contentPadding: const EdgeInsets.symmetric(vertical: 10),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(50),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),

//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         child: Container(
//           decoration: BoxDecoration(),
//           width: double.infinity,
//           height: double.infinity,
//           child: Column(
//             children: [
//               Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: 150,
//                 decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black54,
//                       blurRadius: 4,
//                       offset: Offset(0, 2),
//                     ),
//                   ],
//                   borderRadius: BorderRadius.circular(12),
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     stops: [0.1, 0.7],
//                     colors: [Colors.orange.shade900, Colors.black],
//                   ),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             "Hi '",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 24,
//                             ),
//                           ),
//                           SizedBox(width: 10),
//                           Text(
//                             "Ahmed",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 24,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             width: 50,
//                             height: 50,
//                             decoration: BoxDecoration(
//                               color: Colors.white.withAlpha(55),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Icon(Icons.shopping_bag_outlined),
//                           ),
//                           Container(
//                             width: 50,
//                             height: 50,
//                             decoration: BoxDecoration(
//                               color: Colors.white.withAlpha(55),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Icon(Icons.shopping_bag_outlined),
//                           ),
//                           Container(
//                             width: 50,
//                             height: 50,
//                             decoration: BoxDecoration(
//                               color: Colors.white.withAlpha(55),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Icon(Icons.shopping_bag_outlined),
//                           ),
//                           Container(
//                             width: 50,
//                             height: 50,
//                             decoration: BoxDecoration(
//                               color: Colors.white.withAlpha(55),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Icon(Icons.shopping_bag_outlined),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
