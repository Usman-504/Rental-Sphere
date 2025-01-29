import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../res/components/services_container.dart';
import '../utils/assets.dart';

class ServicesViewModel with ChangeNotifier{

  final TextEditingController searchController = TextEditingController();

  FocusNode searchFocusNode = FocusNode();

  String searchQuery = '';

  String? _image = '';
  String? get image => _image;

  void fetchUserData() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    _image = sp.getString('profile_url');
  }

  final List<ServiceContainer> allServices = [
    const ServiceContainer(
      image: Assets.car,
      title: 'Car Rentals',
      subTitle: 'Find the perfect car for your next trip.',
    ),
    const ServiceContainer(
      image: Assets.home,
      title: 'Home Rentals',
      subTitle: 'Book cozy apartments and luxury stays.',
    ),
    const ServiceContainer(
      image: Assets.camera,
      title: 'Camera Rentals',
      subTitle: 'Rent professional cameras for stunning shots.',
    ),
  ];

  List<ServiceContainer> filteredServices = [];

  ServicesViewModel() {
    filteredServices = List.from(allServices);
    searchController.addListener(() {
      filterServices(searchController.text);
    });
  }

  void filterServices(String query) {
    searchQuery = query.toLowerCase();
    if (searchQuery.isEmpty) {
      filteredServices = List.from(allServices);
    } else {
      filteredServices = allServices
          .where((service) => service.title.toLowerCase().contains(searchQuery))
          .toList();
    }
    notifyListeners();
  }

}