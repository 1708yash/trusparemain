import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../nav_screens/search_screen.dart'; // Import your SearchScreen

class CategoryText extends StatefulWidget {
  const CategoryText({Key? key}) : super(key: key);

  @override
  _CategoryTextState createState() => _CategoryTextState();
}

class _CategoryTextState extends State<CategoryText> {
  late List<String> _categories;

  @override
  void initState() {
    super.initState();
    _categories = [];
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('categories').get();
      setState(() {
        _categories = snapshot.docs.map((doc) => doc['categoryName'] as String).toList();
      });
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Categories",
          style: TextStyle(
            fontSize: 19,
            color: Colors.cyan, // Default text color
          ),
        ),
        const SizedBox(height: 20,),
        SizedBox(
          height: 40,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to SearchScreen with selected category
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchScreen(),
                            ),
                          );
                        },
                        child: ActionChip(
                          label: Text(
                            _categories[index],
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.black // White text color in dark mode
                                  : Colors.white, // Black text color in light mode
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
