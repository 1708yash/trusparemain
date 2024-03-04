import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

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
        _bannerImage
            .addAll(querySnapshot.docs.map((doc) => doc['image'].toString()));
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
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: PageView.builder(
        itemCount: _bannerImage.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: _bannerImage[index],
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer(
                  duration: const Duration(seconds: 3), //Default value
                  interval: const Duration(seconds: 5), //Default value: Duration(seconds: 0)
                  color: Colors.white, //Default value
                  colorOpacity: 0, //Default value
                  enabled: true, //Default value
                  direction: const ShimmerDirection.fromLTRB(),  //Default Value
                  child: Container(
                    color: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
          );
        },
      ),
    );
  }
}
