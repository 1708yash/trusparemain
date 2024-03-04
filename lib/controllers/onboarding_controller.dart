import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:trusparemain/views/account_type.dart';


class OnBoardingController extends GetxController{
  static OnBoardingController get instance => Get.find();

  /// variables
  final pageController =PageController();
  Rx<int> currentPageIndex = 0.obs;
/// update current index
 void updatePageIndicator(index) => currentPageIndex.value =index;

  /// jump to the specific dot selected

void dotNavigationClick(int index) {
  currentPageIndex.value =index;
  pageController.jumpTo(index.toDouble());
}

  /// update current index & to the next page
 void nextPage(){
  if(currentPageIndex.value==2){
   Get.offAll(const AccountType());
  }else{
    int page = currentPageIndex.value + 1;
    pageController.jumpToPage(page);
  }
 }

  void skipPage(){
  currentPageIndex.value =2;
  pageController.jumpToPage(2);
  }
}