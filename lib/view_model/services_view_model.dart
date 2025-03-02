import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../res/components/navigation_helper.dart';
import '../utils/assets.dart';
import '../utils/routes/routes_name.dart';

class ServicesViewModel with ChangeNotifier{

  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchSubController = TextEditingController();

  FocusNode searchFocusNode = FocusNode();

  String searchQuery = '';
  String searchSubQuery = '';

 late String _image = '';
  String get image => _image;

  void fetchUserData() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    _image = sp.getString('profile_url') ?? '';
   notifyListeners();
  }

  void onChanged(value){
    searchSubController.text = value.trim();
    notifyListeners();
  }

  final List<Map<String, dynamic>> allServices = [
    {
      'serviceType': 'Car',
      'image': Assets.car1,
      'title': 'Car Rentals',
      'subTitle': 'Find the perfect car for your next trip.',
    },
    {
      'serviceType': 'Home',
      'image': Assets.home,
      'title': 'Home Rentals',
      'subTitle': 'Book cozy apartments and luxury stays.',
    },
    {
      'serviceType': 'Camera',
      'image': Assets.camera,
      'title': 'Camera Rentals',
      'subTitle': 'Rent professional cameras for stunning shots.',
    },

  ];

  List<Map<String, dynamic>> filteredServices = [];
  // List<Map<String, dynamic>> filteredCarServices = [];
  // List<Map<String, dynamic>> filteredHomeServices = [];
  // List<Map<String, dynamic>> filteredCameraServices = [];


  // List<Map<String, dynamic>> cars = [
  //   {
  //     'imageUrl': Assets.car1,
  //     'type': 'Sedan',
  //     'model': 'Civic',
  //     'year': '2022',
  //     'transmission': 'Automatic',
  //     'fuelType': 'Petrol',
  //     'pricePerDay': 2200,
  //     'location': 'Islamabad',
  //     'availableFrom': 'Feb 5',
  //     'availableTo': 'Feb 20',
  //   },
  //   {
  //     'imageUrl': Assets.car2,
  //     'type': 'SUV',
  //     'model': 'Tucson',
  //     'year': '2023',
  //     'transmission': 'Automatic',
  //     'fuelType': 'Diesel',
  //     'pricePerDay': 2600,
  //     'location': 'Lahore',
  //     'availableFrom': 'Feb 10',
  //     'availableTo': 'Feb 25',
  //   },
  //   {
  //     'imageUrl': Assets.car3,
  //     'type': 'Hatchback',
  //     'model': 'Swift',
  //     'year': '2021',
  //     'transmission': 'Manual',
  //     'fuelType': 'Petrol',
  //     'pricePerDay': 1800,
  //     'location': 'Karachi',
  //     'availableFrom': 'Feb 1',
  //     'availableTo': 'Feb 12',
  //   },
  //   {
  //     'imageUrl': Assets.car4,
  //     'type': 'Truck',
  //     'model': 'F-150',
  //     'year': '2023',
  //     'transmission': 'Automatic',
  //     'fuelType': 'Diesel',
  //     'pricePerDay': 3200,
  //     'location': 'Rawalpindi',
  //     'availableFrom': 'Feb 15',
  //     'availableTo': 'Mar 1',
  //   },
  //   {
  //     'imageUrl': Assets.car5,
  //     'type': 'Coupe',
  //     'model': 'M4',
  //     'year': '2022',
  //     'transmission': 'Automatic',
  //     'fuelType': 'Petrol',
  //     'pricePerDay': 5000,
  //     'location': 'Faisalabad',
  //     'availableFrom': 'Feb 20',
  //     'availableTo': 'Mar 10',
  //   },
  // ];
  // List<Map<String, dynamic>> homes = [
  //   {
  //     'imageUrl': Assets.home,
  //     'type': 'Apartment',
  //     'bedrooms': '2',
  //     'bathrooms': '1',
  //     'location': 'Peshawar',
  //     'pricePerDay': 5000,
  //     'availableFrom': 'Feb 5',
  //     'availableTo': 'Feb 20',
  //     'size': '1200 sqft',
  //     'furnished': 'Yes',
  //   },
  //   {
  //     'imageUrl': Assets.home,
  //     'type': 'House',
  //     'bedrooms': '3',
  //     'bathrooms': '2',
  //     'location': 'Islamabad',
  //     'pricePerDay': 8000,
  //     'availableFrom': 'Mar 1',
  //     'availableTo': 'Mar 15',
  //     'size': '1800 sqft',
  //     'furnished': 'No',
  //   },
  //   {
  //     'imageUrl': Assets.home,
  //     'type': 'Villa',
  //     'bedrooms': '5',
  //     'bathrooms': '4',
  //     'location': 'Lahore',
  //     'pricePerDay': 15000,
  //     'availableFrom': 'Apr 10',
  //     'availableTo': 'Apr 25',
  //     'size': '3000 sqft',
  //     'furnished': 'Yes',
  //   },
  //   {
  //     'imageUrl': Assets.home,
  //     'type': 'Studio',
  //     'bedrooms': '1',
  //     'bathrooms': '1',
  //     'location': 'Karachi',
  //     'pricePerDay': 3500,
  //     'availableFrom': 'May 5',
  //     'availableTo': 'May 20',
  //     'size': '600 sqft',
  //     'furnished': 'Yes',
  //   },
  //   {
  //     'imageUrl': Assets.home,
  //     'type': 'Penthouse',
  //     'bedrooms': '4',
  //     'bathrooms': '3',
  //     'location': 'Rawalpindi',
  //     'pricePerDay': 12000,
  //     'availableFrom': 'Jun 1',
  //     'availableTo': 'Jun 30',
  //     'size': '2500 sqft',
  //     'furnished': 'Yes',
  //   },
  //   {
  //     'imageUrl': Assets.home,
  //     'type': 'Cottage',
  //     'bedrooms': '2',
  //     'bathrooms': '1',
  //     'location': 'Murree',
  //     'pricePerDay': 7000,
  //     'availableFrom': 'Jul 10',
  //     'availableTo': 'Jul 25',
  //     'size': '1400 sqft',
  //     'furnished': 'No',
  //   },
  // ];
  // List<Map<String, dynamic>> cameras = [
  //   {
  //     'imageUrl': Assets.camera,
  //     'brand': 'Canon',
  //     'model': 'EOS 5D Mark IV',
  //     'lensType': '24-70mm f/2.8',
  //     'resolution': '30.4 MP',
  //     'pricePerDay': 2000,
  //     'availableFrom': 'Feb 5',
  //     'availableTo': 'Feb 20',
  //     'location': 'Peshawar',
  //     'sensorType': 'Full Frame',
  //   },
  //   {
  //     'imageUrl': Assets.camera,
  //     'brand': 'Nikon',
  //     'model': 'D850',
  //     'lensType': '70-200mm f/2.8',
  //     'resolution': '45.7 MP',
  //     'pricePerDay': 2500,
  //     'availableFrom': 'Mar 1',
  //     'availableTo': 'Mar 15',
  //     'location': 'Islamabad',
  //     'sensorType': 'Full Frame',
  //   },
  //   {
  //     'imageUrl': Assets.camera,
  //     'brand': 'Sony',
  //     'model': 'A7 III',
  //     'lensType': '28-70mm f/3.5-5.6',
  //     'resolution': '24.2 MP',
  //     'pricePerDay': 1800,
  //     'availableFrom': 'Apr 10',
  //     'availableTo': 'Apr 25',
  //     'location': 'Lahore',
  //     'sensorType': 'Full Frame',
  //   },
  //   {
  //     'imageUrl': Assets.camera,
  //     'brand': 'Fujifilm',
  //     'model': 'X-T4',
  //     'lensType': '18-55mm f/2.8-4',
  //     'resolution': '26.1 MP',
  //     'pricePerDay': 1500,
  //     'availableFrom': 'May 5',
  //     'availableTo': 'May 20',
  //     'location': 'Karachi',
  //     'sensorType': 'APS-C',
  //   },
  // ];




  ServicesViewModel() {
    filteredServices = List.from(allServices);
    // filteredCarServices = List.from(cars);
    // filteredHomeServices = List.from(homes);
    // filteredCameraServices = List.from(cameras);
    searchController.addListener(() {
      filterServices(searchController.text);
    });
    // searchSubController.addListener(() {
    //   // filterSubServices(searchSubController.text);
    //  });
  }

  void filterServices(String query) {
    searchQuery = query.toLowerCase();
    if (searchQuery.isEmpty) {
      filteredServices = List.from(allServices);
    }
    else {
      filteredServices = allServices
          .where((service) => service['title'].toLowerCase().contains(searchQuery))
          .toList();
    }
    notifyListeners();
  }


  Stream<QuerySnapshot> getCarServices() {
    String searchQuery = searchSubController.text.trim().toLowerCase();
    if (searchQuery.isEmpty) {
      return FirebaseFirestore.instance.collection('car').snapshots();
    }
    else {
      return FirebaseFirestore.instance
          .collection('car')
          .where('car_model', isGreaterThanOrEqualTo: searchQuery)
          .where('car_model', isLessThanOrEqualTo: '$searchQuery\uf8ff')
          .snapshots();
    }
  }
  Stream<QuerySnapshot> getHomeServices() {
    String searchQuery = searchSubController.text.trim().toLowerCase();
    if (searchQuery.isEmpty) {
      return FirebaseFirestore.instance.collection('home').snapshots();
    }
    else {
      return FirebaseFirestore.instance
          .collection('home')
          .where('home_type', isGreaterThanOrEqualTo: searchQuery)
          .where('home_type', isLessThanOrEqualTo: '$searchQuery\uf8ff')
          .snapshots();
    }
  }
  Stream<QuerySnapshot> getCameraServices() {
    String searchQuery = searchSubController.text.trim().toLowerCase();
    if (searchQuery.isEmpty) {
      return FirebaseFirestore.instance.collection('camera').snapshots();
    }
    else {
      return FirebaseFirestore.instance
          .collection('camera')
          .where('camera_brand', isGreaterThanOrEqualTo: searchQuery)
          .where('camera_brand', isLessThanOrEqualTo: '$searchQuery\uf8ff')
          .snapshots();
    }
  }




}