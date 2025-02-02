import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rental_sphere/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddServiceViewModel with ChangeNotifier{

  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;

  XFile? _file;
  XFile? get file => _file;

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final TextEditingController modelController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController fuelController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController transmissionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController availableFromController = TextEditingController();
  final TextEditingController availableToController = TextEditingController();

  FocusNode modelFocusNode = FocusNode();
  FocusNode typeFocusNode = FocusNode();
  FocusNode fuelFocusNode = FocusNode();
  FocusNode yearFocusNode = FocusNode();
  FocusNode transmissionFocusNode = FocusNode();
  FocusNode locationFocusNode = FocusNode();
  FocusNode priceFocusNode = FocusNode();

  DateTime? _selectedDate;
  DateTime? get selectedDate => _selectedDate;

  String _imageUrl = '';
  String get imageUrl => _imageUrl;

  String _imagePath = '';
  String get imagePath => _imagePath;

  List<String> categories = ['Car', 'Home', 'Camera'];

  void initializeCategory(){
    _selectedCategory = categories.first;
    notifyListeners();
  }

  void dropDownCategory (String? selectedItem){
    _selectedCategory = selectedItem;
    clearFields();
    notifyListeners();
  }

  void pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    _file = await imagePicker.pickImage(source: ImageSource.gallery);
    notifyListeners();
  }

  void selectDate(BuildContext context, TextEditingController controller) async {
    _selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (_selectedDate != null) {
      controller.text = DateFormat('MM/dd/yyyy').format(_selectedDate!);

    }
    notifyListeners();
  }

  String? validateFields() {

    if (_selectedCategory == null) {
      return 'Please Select Category';
    }
    else if(_file == null){
      return 'Please Upload $selectedCategory Picture';
    }

    else if(modelController.text.isEmpty){
      final value = selectedCategory == 'Car' ? 'Car Model' : selectedCategory == 'Home' ? 'Home Type' : 'Camera Brand' ;
      return 'Please Enter $value';
    }

    else if(typeController.text.isEmpty){
      final value = selectedCategory == 'Car' ? 'Car Type' : selectedCategory == 'Home' ? 'Bedrooms' : 'Camera Model' ;
      return 'Please Enter $value';
    }

    else if(fuelController.text.isEmpty){
      final value = selectedCategory == 'Car' ? 'Fuel Type' : selectedCategory == 'Home' ? 'Bathrooms' : 'Lens Type' ;
      return 'Please Enter $value';
    }

    else if(transmissionController.text.isEmpty){
      final value = selectedCategory == 'Car' ? 'Transmission' : selectedCategory == 'Home' ? 'Furnished' : 'Sensor Type' ;
      return 'Please Enter $value';
    }

    else if(yearController.text.isEmpty){
      final value = selectedCategory == 'Car' ? 'Year' : selectedCategory == 'Home' ? 'Size' : 'Resolution' ;
      return 'Please Enter $value';
    }

    else if(locationController.text.isEmpty){
      return 'Please Enter Location';
    }

    else if(priceController.text.isEmpty){
      return 'Please Enter Price';
    }

    else if(availableFromController.text.isEmpty){
      return 'Please Select Available From Date';
    }
    else if(availableToController.text.isEmpty){
      return 'Please Select Available To Date';
    }



    return null;


  }

  void addService(BuildContext context) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final name = sp.getString('name');
    final email = sp.getString('email');
    String? validation = validateFields();
    if(validation != null){
      Utils.flushBarMessage(validation, context, true);
      return;
    }

    if (_file != null && _imageUrl.isEmpty) {
      print('Uploading image...');
      await uploadImage();
    }
    if (_imageUrl.isNotEmpty) {
      var stringPrice = priceController.text.trim();
      var price = int.tryParse(stringPrice);
      setLoading(true);
      await FirebaseFirestore.instance.collection(selectedCategory.toString().toLowerCase()).doc().set({
        'ownerName': name,
        'ownerEmail': email,
        'image_url': _imageUrl,
        'image_path': _imagePath,
        'category': selectedCategory.toString().toLowerCase(),
        selectedCategory == 'Home' ? 'home_type' : selectedCategory == 'Camera' ? 'camera_brand' : 'car_model': modelController.text.trim().toLowerCase(),
        selectedCategory == 'Home' ? 'bedrooms' : selectedCategory == 'Camera' ? 'camera_model' : 'car_type': typeController.text.trim(),
        selectedCategory == 'Home' ? 'bathrooms' : selectedCategory == 'Camera' ? 'lens_type' : 'fuel_type': fuelController.text.trim(),
        selectedCategory == 'Home' ? 'furnished' : selectedCategory == 'Camera' ? 'sensor_type' : 'transmission': transmissionController.text.trim(),
        selectedCategory == 'Home' ? 'size' : selectedCategory == 'Camera' ? 'resolution' : 'year': yearController.text.trim(),
        'location': locationController.text.trim(),
        'price': price,
        'availableFrom': availableFromController.text.trim(),
        'availableTo': availableToController.text.trim(),
        'reviews': [],
        'averageRating': 0.0,
        'userId' : FirebaseAuth.instance.currentUser!.uid,
      });
      setLoading(false);
      Navigator.pop(context);
     Utils.flushBarMessage('$selectedCategory Service Added Successfully', context, false);
      print('Data saved successfully!');
    } else {
      print('Image URL is empty, not saving data.');
    }
  }

  Future<void> uploadImage() async {
    if (_file != null) {
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('images');
      Reference imageToUpload = referenceDirImages.child(uniqueFileName);
      try {
        setLoading(true);
        await imageToUpload.putFile(File(file!.path));
        _imageUrl = await imageToUpload.getDownloadURL();
        _imagePath = imageToUpload.fullPath;
        print(imageToUpload.fullPath);

        print('Image uploaded successfully, URL: $_imageUrl');
        notifyListeners();
      } catch (e) {
        setLoading(false);
        print('Failed to upload image: $e');
      }
    }
  }

  void clearFields(){
    _file = null;
    modelController.clear();
    typeController.clear();
    fuelController.clear();
    transmissionController.clear();
    yearController.clear();
    locationController.clear();
    priceController.clear();
    availableFromController.clear();
    availableToController.clear();
  }

}