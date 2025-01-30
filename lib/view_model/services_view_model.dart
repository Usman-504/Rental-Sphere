import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/assets.dart';

class ServicesViewModel with ChangeNotifier{

  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchSubController = TextEditingController();

  FocusNode searchFocusNode = FocusNode();

  String searchQuery = '';
  String searchSubQuery = '';

  String? _image = '';
  String? get image => _image;

  void fetchUserData() async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    _image = sp.getString('profile_url');
  }

  final List<Map<String, dynamic>> allServices = [
    {
      'image': Assets.car,
      'title': 'Car Rentals',
      'subTitle': 'Find the perfect car for your next trip.',
    },
    {
      'image': Assets.home,
      'title': 'Home Rentals',
      'subTitle': 'Book cozy apartments and luxury stays.',
    },
    {
      'image': Assets.camera,
      'title': 'Camera Rentals',
      'subTitle': 'Rent professional cameras for stunning shots.',
    },

  ];

  List<Map<String, dynamic>> filteredServices = [];
  List<Map<String, dynamic>> filteredCarServices = [];
  List<Map<String, dynamic>> filteredHomeServices = [];
  List<Map<String, dynamic>> filteredCameraServices = [];

  // List<Map<String, dynamic>> cars = [
  //   {
  //     'imageUrl': Assets.car,
  //     'type': 'SUVG',
  //     'make': 'Toyota',
  //     'model': 'RAV4',
  //     'year': '2023',
  //     'mileage': '15,000',
  //     'transmission': 'Automatic',
  //     'fuelType': 'Petrol',
  //     'pricePerHour': '1000',
  //     'pricePerDay': '2400',
  //     'pricePerWeek': '16800',
  //     'location': 'Peshawar',
  //     'availability': 'Available from Feb 1 - Feb 15',
  //   },
  //   {
  //     'imageUrl': Assets.car,
  //     'type': 'SUV',
  //     'make': 'Toyota',
  //     'model': 'RAV4',
  //     'year': '2023',
  //     'mileage': '15,000',
  //     'transmission': 'Automatic',
  //     'fuelType': 'Petrol',
  //     'pricePerHour': '1000',
  //     'pricePerDay': '2400',
  //     'pricePerWeek': '16800',
  //     'location': 'Peshawar',
  //     'availability': 'Available from Feb 1 - Feb 15',
  //   },
  //   {
  //     'imageUrl': Assets.car,
  //     'type': 'SUV',
  //     'make': 'Toyota',
  //     'model': 'RAV4',
  //     'year': '2023',
  //     'mileage': '15,000',
  //     'transmission': 'Automatic',
  //     'fuelType': 'Petrol',
  //     'pricePerHour': '1000',
  //     'pricePerDay': '2400',
  //     'pricePerWeek': '16800',
  //     'location': 'Peshawar',
  //     'availability': 'Available from Feb 1 - Feb 15',
  //   },
  //   {
  //     'imageUrl': Assets.car,
  //     'type': 'SUV',
  //     'make': 'Toyota',
  //     'model': 'RAV4',
  //     'year': '2023',
  //     'mileage': '15,000',
  //     'transmission': 'Automatic',
  //     'fuelType': 'Petrol',
  //     'pricePerHour': '1000',
  //     'pricePerDay': '2400',
  //     'pricePerWeek': '16800',
  //     'location': 'Peshawar',
  //     'availability': 'Available from Feb 1 - Feb 15',
  //   },
  // ];

  List<Map<String, dynamic>> cars = [
    {
      'imageUrl': Assets.car,
      'type': 'Sedan',
      'model': 'Civic',
      'year': '2022',
      'transmission': 'Automatic',
      'fuelType': 'Petrol',
      'pricePerDay': '2200',
      'location': 'Islamabad',
      'availableFrom': 'Feb 5',
      'availableTo': 'Feb 20',
    },
    {
      'imageUrl': Assets.car,
      'type': 'SUV',
      'model': 'Tucson',
      'year': '2023',
      'transmission': 'Automatic',
      'fuelType': 'Diesel',
      'pricePerDay': '2600',
      'location': 'Lahore',
      'availableFrom': 'Feb 10',
      'availableTo': 'Feb 25',
    },
    {
      'imageUrl': Assets.car,
      'type': 'Hatchback',
      'model': 'Swift',
      'year': '2021',
      'transmission': 'Manual',
      'fuelType': 'Petrol',
      'pricePerDay': '1800',
      'location': 'Karachi',
      'availableFrom': 'Feb 1',
      'availableTo': 'Feb 12',
    },
    {
      'imageUrl': Assets.car,
      'type': 'Truck',
      'model': 'F-150',
      'year': '2023',
      'transmission': 'Automatic',
      'fuelType': 'Diesel',
      'pricePerDay': '3200',
      'location': 'Rawalpindi',
      'availableFrom': 'Feb 15',
      'availableTo': 'Mar 1',
    },
    {
      'imageUrl': Assets.car,
      'type': 'Coupe',
      'model': 'M4',
      'year': '2022',
      'transmission': 'Automatic',
      'fuelType': 'Petrol',
      'pricePerDay': '5000',
      'location': 'Faisalabad',
      'availableFrom': 'Feb 20',
      'availableTo': 'Mar 10',
    },
  ];


  List<Map<String, dynamic>> homes = [
    {
      'imageUrl': Assets.home,
      'type': 'Apartment',
      'bedrooms': '2',
      'bathrooms': '1',
      'location': 'Peshawar',
      'pricePerDay': '5000',
      'availableFrom': 'Feb 5',
      'availableTo': 'Feb 20',
      'size': '1200 sqft',
      'furnished': 'Yes',
    },
    {
      'imageUrl': Assets.home,
      'type': 'House',
      'bedrooms': '3',
      'bathrooms': '2',
      'location': 'Islamabad',
      'pricePerDay': '8000',
      'availableFrom': 'Mar 1',
      'availableTo': 'Mar 15',
      'size': '1800 sqft',
      'furnished': 'No',
    },
    {
      'imageUrl': Assets.home,
      'type': 'Villa',
      'bedrooms': '5',
      'bathrooms': '4',
      'location': 'Lahore',
      'pricePerDay': '15000',
      'availableFrom': 'Apr 10',
      'availableTo': 'Apr 25',
      'size': '3000 sqft',
      'furnished': 'Yes',
    },
    {
      'imageUrl': Assets.home,
      'type': 'Studio',
      'bedrooms': '1',
      'bathrooms': '1',
      'location': 'Karachi',
      'pricePerDay': '3500',
      'availableFrom': 'May 5',
      'availableTo': 'May 20',
      'size': '600 sqft',
      'furnished': 'Yes',
    },
    {
      'imageUrl': Assets.home,
      'type': 'Penthouse',
      'bedrooms': '4',
      'bathrooms': '3',
      'location': 'Rawalpindi',
      'pricePerDay': '12000',
      'availableFrom': 'Jun 1',
      'availableTo': 'Jun 30',
      'size': '2500 sqft',
      'furnished': 'Yes',
    },
    {
      'imageUrl': Assets.home,
      'type': 'Cottage',
      'bedrooms': '2',
      'bathrooms': '1',
      'location': 'Murree',
      'pricePerDay': '7000',
      'availableFrom': 'Jul 10',
      'availableTo': 'Jul 25',
      'size': '1400 sqft',
      'furnished': 'No',
    },
  ];


  List<Map<String, dynamic>> cameras = [
    {
      'imageUrl': Assets.camera,
      'brand': 'Canon',
      'model': 'EOS 5D Mark IV',
      'lensType': '24-70mm f/2.8',
      'resolution': '30.4 MP',
      'pricePerDay': '2000',
      'availableFrom': 'Feb 5',
      'availableTo': 'Feb 20',
      'location': 'Peshawar',
      'sensorType': 'Full Frame',
    },
  ];



  ServicesViewModel() {
    filteredServices = List.from(allServices);
    filteredCarServices = List.from(cars);
    filteredHomeServices = List.from(homes);
    filteredCameraServices = List.from(cameras);
    searchController.addListener(() {
      filterServices(searchController.text);
    });
    searchSubController.addListener(() {
      filterSubServices(searchSubController.text);
    });
  }

  void filterServices(String query) {
    searchQuery = query.toLowerCase();
    print("Search Query: $searchQuery");
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
  void filterSubServices(String query) {

    searchSubQuery = query.toLowerCase();
    print("Search Query: $searchSubQuery");
   if (searchSubQuery.isEmpty) {
     filteredCarServices = List.from(cars);
     filteredHomeServices = List.from(homes);
     filteredCameraServices = List.from(cameras);
    }
    else {

     filteredCarServices = cars.where((car) {
       final carType = car['type'].toString().toLowerCase().trim();
       final model = car['model'].toString().toLowerCase().trim();

       return carType.contains(searchSubQuery) ||
           model.contains(searchSubQuery);
     }).toList();
     filteredHomeServices = homes.where((home) {
       final homeType = home['type'].toString().toLowerCase().trim();
       final location = home['location'].toString().toLowerCase().trim();

       return homeType.contains(searchSubQuery) ||
           location.contains(searchSubQuery);
     }).toList();
     filteredCameraServices = cameras.where((camera) {
       final cameraType = camera['brand'].toString().toLowerCase().trim();
       final location = camera['location'].toString().toLowerCase().trim();

       return cameraType.contains(searchSubQuery) ||
           location.contains(searchSubQuery);
     }).toList();
     print(filteredCarServices.length);
    }

    notifyListeners();
  }


}