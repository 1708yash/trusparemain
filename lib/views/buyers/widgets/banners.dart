import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Banners extends StatefulWidget {
  const Banners({super.key});

  @override
  State<Banners> createState() => _BannersState();
}

class _BannersState extends State<Banners> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<String> _bannerImage = [];

  Future<void> getBanners() async {
    try {
      QuerySnapshot querySnapshot =
      await _firestore.collection('banners').get();
      setState(() {
        _bannerImage.clear(); // Clear the list before adding new items
        _bannerImage.addAll(
            querySnapshot.docs.map((doc) => doc['image'].toString()));
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching banners: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getBanners();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10)),
      child: PageView.builder(
        itemCount: _bannerImage.length,
        itemBuilder: (context, index) {
          return Image.network(_bannerImage[index]);
        },
      ),
    );
  }
}
