import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rental_sphere/res/components/navigation_helper.dart';
import 'package:rental_sphere/utils/routes/routes_name.dart';
import 'package:rental_sphere/utils/utils.dart';

class UpdateServiceViewModel with ChangeNotifier{



  XFile? _imageFile;
  XFile? get imageFile => _imageFile;




  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }


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

  List<String> _imageUrls = [];
  List<String> get imageUrls => _imageUrls;

  List<String> _imagePaths = [];
  List<String> get imagePaths => _imagePaths;

  List<String> categories = ['Car', 'Home', 'Camera'];



  void pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    _imageFile = await imagePicker.pickImage(source: ImageSource.gallery);
    notifyListeners();
  }

  List<dynamic> _images = [];
  List<dynamic> get images => _images;

  void setImages( List<dynamic> urls){
    // _images.addAll(files);
    _images.addAll(urls);
    notifyListeners();
}
  void pickImages() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? selectedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (selectedFile != null) {
      _images.add(File(selectedFile.path));
    }
    print(_images.length);
    notifyListeners();

  }

  void removeImage(int index) {
    print(images.length);
    _images.removeAt(index);
    print(images.length);
    notifyListeners();
  }

  void deleteImage(String imagePath, String category, String docId, BuildContext context) async {
    try {
      await FirebaseStorage.instance.ref(imagePath).delete();
      DocumentReference docRef = FirebaseFirestore.instance.collection(category).doc(docId);
      DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

        List<dynamic> imagePaths = List.from(data['image_paths'] ?? []);
        List<dynamic> imageUrls = List.from(data['image_urls'] ?? []);

        int index = imagePaths.indexOf(imagePath);

        if (index != -1) {
          imagePaths.removeAt(index);
          imageUrls.removeAt(index);

          await docRef.update({
            'image_paths': imagePaths,
            'image_urls': imageUrls,
          }).then((value){
            NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.adminNavBar, replace: true);
          });

          print('Image and references deleted successfully.');
        } else {
          print('Image path not found in Firestore.');
        }
      } else {
        print('Document does not exist.');
      }
    } catch (e) {
      print('Error deleting image: $e');
    }

    notifyListeners();
  }


  // void deleteImage(String imagePath, String category, String docId) async{
  //   await FirebaseStorage.instance.ref(imagePath).delete();
  //   await FirebaseFirestore.instance.collection(category).doc(docId).update({
  //   });
  //   notifyListeners();
  // }

  void selectDate(BuildContext context, TextEditingController controller) async {
    _selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (_selectedDate != null) {
      controller.text = DateFormat('MM/dd/yyyy').format(_selectedDate!);
      print(controller.text);

    }

    notifyListeners();
  }



  void updateService(BuildContext context, String docId, String category, String model, String type,String fuelType, String transmission, String year, String location, String pricePerDay, String availableFrom, String availableTo) async {

    var stringPrice = pricePerDay;
    var price = int.tryParse(stringPrice);
    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection(category)
        .doc(docId)
        .get();
    String oldImagePath = document.get('image_path');
    setLoading(true);
    await FirebaseFirestore.instance.collection(category).doc(docId).update({
      category == 'Home' ? 'home_type' : category == 'Camera' ? 'camera_brand' : 'car_model': model,
      category == 'Home' ? 'bedrooms' : category == 'Camera' ? 'camera_model' : 'car_type': type,
      category == 'Home' ? 'bathrooms' : category == 'Camera' ? 'lens_type' : 'fuel_type': fuelType,
      category == 'Home' ? 'furnished' : category == 'Camera' ? 'sensor_type' : 'transmission': transmission,
      category == 'Home' ? 'size' : category == 'Camera' ? 'resolution' : 'year': year,
      'location': location,
      'price': price,
      'availableFrom':availableFrom,
      'availableTo': availableTo,
    });
    setLoading(false);
    if(_imageFile != null) {
      if (oldImagePath.isNotEmpty) {
        await FirebaseStorage.instance.ref(oldImagePath).delete();
      }
    }

    if ( (_imageFile != null && _imageUrl.isEmpty) || (images.isNotEmpty && _imageUrls.isEmpty)) {
      await uploadImage();
     if(_imageUrl.isNotEmpty) {
       FirebaseFirestore.instance
          .collection(category)
          .doc(docId.toString())
          .update({
        'image_url': _imageUrl,
        'image_path': _imagePath,
      });
     }

      if(_imageUrls.isNotEmpty) {
        FirebaseFirestore.instance
            .collection(category)
            .doc(docId.toString())
            .update({
          'image_urls': FieldValue.arrayUnion(_imageUrls),
          'image_paths': FieldValue.arrayUnion(_imagePaths) ,
        });
      }


      setLoading(false);
      Navigator.pop(context);
      Utils.flushBarMessage(
          '$category Service Updated Successfully', context, false);
      print('Data saved successfully!');
    }
    else {
      print('Image URL is empty, not saving data.');
    }
  }

  Future<void> uploadImage() async  {
    _imageUrls.clear();
    _imagePaths.clear();
    setLoading(true);
    if (_imageFile != null){
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('images');
      Reference imageToUpload = referenceDirImages.child(uniqueFileName);

      await imageToUpload.putFile(File(imageFile!.path));
      _imageUrl = await imageToUpload.getDownloadURL();
      _imagePath = imageToUpload.fullPath;
    }
    List<File> fileImages = images
        .where((file) => file is XFile || file is File)
        .map((file) => File(file.path))
        .toList();

   print(fileImages.length);
    if(fileImages.isNotEmpty) {
      for (var file in fileImages) {
        String uniqueFileName = DateTime
            .now()
            .millisecondsSinceEpoch
            .toString();
        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImages = referenceRoot.child('images');
        Reference imageToUpload = referenceDirImages.child(uniqueFileName);
        try {
          await imageToUpload.putFile(File(file.path));
          String imageUrl = await imageToUpload.getDownloadURL();
          _imageUrls.add(imageUrl);
          _imagePaths.add(imageToUpload.fullPath);
          print('Image uploaded: $imageUrl');
        }
        catch (e) {
          print('Failed to upload image: $e');
        }
      }
    }
    setLoading(false);
    notifyListeners();

  }




}