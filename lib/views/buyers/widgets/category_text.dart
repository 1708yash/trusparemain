import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CategoryText extends StatelessWidget {
  final List<String> _categories = const [
    'Shoe Brakes',
    'Mudguard',
    'Silencer',
    'Headlights',
    'Stickers',
    'Paints'
  ];

  const CategoryText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Categories",
          style: TextStyle(fontSize: 19),
        ),
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
                      child: ActionChip(
                          onPressed: (){},
                          label: Text(_categories[index],
                              style: const TextStyle(color: Colors.black))),
                    );
                  },
                ),
              ),
              IconButton(
                  onPressed: () {}, icon: const Icon(Iconsax.arrow_right_3))
            ],
          ),
        ),
      ],
    );
  }
}
