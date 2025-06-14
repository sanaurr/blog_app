import 'package:flutter/material.dart';

class Searchbar extends StatefulWidget {
  const Searchbar({super.key});

  @override
  State<Searchbar> createState() => _SearchbarState();
}

class _SearchbarState extends State<Searchbar> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Container(
            // width: 250,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),),
            ),
            child: const TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                hintText: 'Search',
              ),
            ),
          ),
        ),
        // const SizedBox(width: 5),
        Container(
          // width: 60,
          height: 40,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),),

          ),
          child: TextButton(
            onPressed: () {},
            child: const Text('Search', style: TextStyle(color: Colors.white),),
          ),
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';

// class SearchBarWithButton extends StatelessWidget {
//   final TextEditingController searchController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         constraints: BoxConstraints(maxWidth: 400), // Equivalent to 'max-w-md'
//         padding: EdgeInsets.symmetric(horizontal: 16), // To add spacing on sides
//         child: Row(
//           children: [
//             // Search input field
//             Expanded(
//               child: TextField(
//                 controller: searchController,
//                 decoration: InputDecoration(
//                   hintText: "Search...",
//                   filled: true,
//                   fillColor: Colors.grey[200], // Equivalent to 'bg-gray-100'
//                   contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.horizontal(
//                       left: Radius.circular(30), // Rounded left side
//                     ),
//                     borderSide: BorderSide.none, // No border
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.horizontal(
//                       left: Radius.circular(30), // Rounded left side
//                     ),
//                     borderSide: BorderSide(
//                       color: Colors.yellow[500]!, // Equivalent to 'focus:ring-yellow-500'
//                       width: 2,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             // Search button
//             Container(
//               height: 48,
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Add your search functionality here
//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.symmetric(horizontal: 24),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.horizontal(
//                       right: Radius.circular(30), // Rounded right side
//                     ),
//                   ),
//                   primary: Colors.orange[400], // Right side gradient equivalent
//                 ),
//                 child: Text("Search"),
//               ),
//             ),
//             SizedBox(width: 16), // Spacing between Search button and Add button
//             // Add button (assuming a separate widget)
//             AddButton(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class AddButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 150, // Equivalent to 'min-w-[150px]'
//       child: ElevatedButton(
//         onPressed: () {
//           // Add button functionality
//         },
//         child: Text('Add'),
//       ),
//     );
//   }
// }
