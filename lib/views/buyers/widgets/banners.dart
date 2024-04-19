import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class Banners extends StatefulWidget {
  const Banners({Key? key}) : super(key: key);

  @override
  State<Banners> createState() => _BannersState();
}

class _BannersState extends State<Banners> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<String> _bannerImage = [];
  final PageController _pageController = PageController(initialPage: 0); // Create PageController instance

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
    // Delay the start of banner movement until after the widget has been built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startBannerMovement();
    });
  }

  void startBannerMovement() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_bannerImage.isNotEmpty) {
        int nextPageIndex = (_pageController.page?.round() ?? 0) + 1;
        if (nextPageIndex < _bannerImage.length) {
          _pageController.animateToPage(
            nextPageIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        } else {
          // Handle reaching the end (optional: loop back to the beginning)
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose of PageController when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: PageView.builder(
        controller: _pageController, // Use PageController for programmatic control
        itemCount: _bannerImage.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: _bannerImage[index],
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer(
                duration: const Duration(seconds: 3),
                interval: const Duration(seconds: 5),
                color: Colors.white,
                colorOpacity: 0,
                enabled: true,
                direction: const ShimmerDirection.fromLTRB(),
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
