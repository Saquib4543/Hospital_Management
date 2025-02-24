// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// import 'ItemDetailsPage.dart';
// import 'ItemListPage.dart';
// import 'main.dart';
//
// class ItemSearchDelegate extends SearchDelegate<String> {
//   final List<Item> items;
//
//   ItemSearchDelegate(this.items);
//
//   @override
//   ThemeData appBarTheme(BuildContext context) {
//     return ThemeData(
//       appBarTheme: AppBarTheme(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: IconThemeData(color: Colors.black87),
//         titleTextStyle: GoogleFonts.poppins(
//           color: Colors.black87,
//           fontSize: 18,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       inputDecorationTheme: InputDecorationTheme(
//         border: InputBorder.none,
//         hintStyle: GoogleFonts.poppins(
//           color: Colors.grey[400],
//           fontSize: 16,
//         ),
//       ),
//     );
//   }
//
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: Icon(Icons.clear_rounded),
//         onPressed: () {
//           query = '';
//         },
//       ),
//     ];
//   }
//
//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.arrow_back_rounded),
//       onPressed: () {
//         close(context, '');
//       },
//     );
//   }
//
//   @override
//   Widget buildResults(BuildContext context) {
//     return _buildSearchResults();
//   }
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return _buildSearchResults();
//   }
//
//   Widget _buildSearchResults() {
//     final filteredItems = items
//         .where((item) =>
//     item.name.toLowerCase().contains(query.toLowerCase()) ||
//         item.location.toLowerCase().contains(query.toLowerCase()))
//         .toList();
//
//     return Container(
//       color: Colors.grey[100],
//       child: ListView.builder(
//         padding: EdgeInsets.all(16),
//         itemCount: filteredItems.length,
//         itemBuilder: (context, index) {
//           final item = filteredItems[index];
//           return Container(
//             margin: EdgeInsets.only(bottom: 12),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 10,
//                   offset: Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: ListTile(
//               contentPadding: EdgeInsets.all(16),
//               leading: Container(
//                 width: 48,
//                 height: 48,
//                 decoration: BoxDecoration(
//                   color: Colors.blue[50],
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(
//                   Icons.inventory_2_rounded,
//                   color: Colors.blue,
//                 ),
//               ),
//               title: Text(
//                 item.name,
//                 style: GoogleFonts.poppins(
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               subtitle: Text(
//                 item.location,
//                 style: GoogleFonts.poppins(
//                   color: Colors.grey[600],
//                 ),
//               ),
//               trailing: Icon(Icons.chevron_right_rounded),
//               onTap: () {
//                 close(context, item.id);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ItemDetailsPage(itemId: item),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }