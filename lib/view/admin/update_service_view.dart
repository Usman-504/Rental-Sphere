import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_sphere/res/components/custom_button.dart';
import 'package:rental_sphere/res/components/datetime_textfield.dart';
import 'package:rental_sphere/utils/size_config.dart';
import 'package:rental_sphere/view_model/admin/update_service_view_model.dart';
import '../../res/colors.dart';
import '../../res/components/custom_textfield.dart';
import '../../utils/styles.dart';

class UpdateServiceView extends StatefulWidget {
  final Map args;
  const UpdateServiceView({super.key, required this.args});

  @override
  State<UpdateServiceView> createState() => _UpdateServiceViewState();
}

class _UpdateServiceViewState extends State<UpdateServiceView> {

  late TextEditingController modelController;
  late TextEditingController typeController;
  late TextEditingController fuelController;
  late TextEditingController yearController;
  late TextEditingController transmissionController;
  late TextEditingController locationController;
  late TextEditingController priceController;
  late TextEditingController availableFromController;
  late TextEditingController availableToController;



  @override
  void initState() {
    super.initState();
    modelController = TextEditingController(text: widget.args['model']);
    typeController = TextEditingController(text: widget.args['type']);
    fuelController = TextEditingController(text: widget.args['fuelType']);
    transmissionController = TextEditingController(text: widget.args['transmission']);
    yearController = TextEditingController(text: widget.args['year']);
    locationController = TextEditingController(text: widget.args['location']);
    priceController = TextEditingController(text: widget.args['price'].toString());
    availableFromController = TextEditingController(text: widget.args['availableFrom']);
    availableToController = TextEditingController(text: widget.args['availableTo']);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=> UpdateServiceViewModel()..setImages( widget.args['images']),
      child: Consumer<UpdateServiceViewModel>(
        builder: (context, vm, child) {
          // List<dynamic> images = [
          //   ...widget.args['images'],
          //   ...vm.files,
          // ];
          return Scaffold(
            backgroundColor: AppColors.scaffoldColor,
            appBar: AppBar(
              backgroundColor: AppColors.blackColor,
              centerTitle: true,
              title:  Text("Update Service", style: secondaryTextStyle.copyWith(color: AppColors.whiteColor),),
              automaticallyImplyLeading: false,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding:  EdgeInsets.all(SizeConfig.scaleHeight(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:  EdgeInsets.symmetric(vertical: SizeConfig.scaleHeight(20)),
                      child: InkWell(
                        onTap: ()async{
                          vm.pickImage();
                        },
                        child: Container(
                          height: SizeConfig.scaleHeight(250),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: vm.imageFile != null ?
                                  FileImage(File(vm.imageFile!.path)) :
                                  NetworkImage(widget.args['image_url'])
                              ),
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(width: 1, color: AppColors.blackColor)
                          ),

                        ),
                      ),
                    ),
                    Text(
                      'Gallery Images*',
                      style: mediumTextStyle,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Row(
                            children: List.generate(vm.images.length, (index) {
                              return Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(5),
                                    width: SizeConfig.scaleHeight(130),
                                    height: SizeConfig.scaleHeight(130),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image:
                                      vm.images[index] is File
                                          ? FileImage(File(vm.images[index].path))
                                          : NetworkImage(vm.images[index]), fit: BoxFit.cover),
                                      border: Border.all(color: AppColors.blackColor, width: 2),
                                      borderRadius: BorderRadius.circular(5),
                                    ),

                                  ),
                                 Positioned(
                                      top: SizeConfig.scaleHeight(10),
                                      right: SizeConfig.scaleHeight(10),
                                      child: InkWell(
                                        onTap: () async{
                                          if (vm.images[index] is File) {
                                            vm.removeImage(index);
                                          } else {
                                           await showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text("Delete Image"),
                                                  content: Text("Are you sure you want to delete this image?"),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context),
                                                      child: Text("Cancel"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        vm.deleteImage(widget.args['imagePaths'][index], widget.args['category'], widget.args['docId'], context);
                                                      },
                                                      child: Text("Delete"),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );

                                          }
                                        },
                                        child: Container(
                                            height: SizeConfig.scaleHeight(30),
                                            width: SizeConfig.scaleHeight(30),
                                            decoration: BoxDecoration(
                                                color: AppColors.whiteColor,
                                                borderRadius: BorderRadius.circular(5)
                                            ),
                                            child: Icon(Icons.close, color: Colors.red,)),
                                      )
                                  ),

                                ],
                              );
                            }),
                          ),
                          Container(
                            width: SizeConfig.scaleHeight(130),
                            height: SizeConfig.scaleHeight(130),
                            decoration: BoxDecoration(
                                border: Border.all(color: AppColors.blackColor, width: 2),
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.whiteColor
                            ),
                            child: InkWell(
                                onTap: (){
                                  vm.pickImages();
                                },
                                child: Icon(Icons.add, color: AppColors.blackColor, size: 40,)),
                          ),

                        ],
                      ),
                    ),

                    Text(  widget.args['category'] == 'home' ? 'Home Type*' :  widget.args['category'] == 'camera' ? 'Camera Brand*' :
                    'Car Model*',
                      style: mediumTextStyle,
                    ),
                    CustomTextField(
                      filled: true,
                      focusNode: vm.modelFocusNode,
                      controller: modelController,
                      keyboardType: TextInputType.text,
                      hintText: widget.args['category']== 'home' ? 'House, Apartment' : widget.args['category'] == 'camera' ? 'Nikon, Sony' :'Civic, Swift',
                      current: vm.modelFocusNode,
                      next:vm.typeFocusNode,
                    ),
                    Text(widget.args['category'] == 'home' ? 'Bedrooms*' : widget.args['category'] == 'camera' ? 'Camera Model*' :
                    'Car Type*',
                      style: mediumTextStyle,
                    ),
                    CustomTextField(
                      filled: true,
                      focusNode: vm.typeFocusNode,
                      controller: typeController,
                      keyboardType:widget.args['category']== 'home' ? TextInputType.number : TextInputType.text,
                      hintText: widget.args['category'] == 'home' ? '2, 3' : widget.args['category']== 'camera' ? 'Mark IV, A7 III' : 'Sedan, Truck',
                      current: vm.typeFocusNode,
                      next:vm.fuelFocusNode,
                    ),
                    Text(widget.args['category']== 'home' ? 'Bathrooms*' : widget.args['category'] == 'camera' ? 'Lens Type*' :
                    'Fuel Type*',
                      style: mediumTextStyle,
                    ),
                    CustomTextField(
                      filled: true,
                      focusNode: vm.fuelFocusNode,
                      controller: fuelController,
                      keyboardType: widget.args['category'] == 'home' ? TextInputType.number : TextInputType.text,
                      hintText: widget.args['category'] == 'home' ? '1, 2' : widget.args['category'] == 'camera' ? '70-200mm f/2.8' : 'Petrol, Diesel',
                      current: vm.fuelFocusNode,
                      next:vm.transmissionFocusNode,
                    ),
                    Text(widget.args['category'] == 'home' ? 'Furnished*' : widget.args['category'] == 'camera' ? 'Sensor Type*' :
                    'Transmission*',
                      style: mediumTextStyle,
                    ),
                    CustomTextField(
                      filled: true,
                      focusNode: vm.transmissionFocusNode,
                      controller: transmissionController,
                      keyboardType: TextInputType.text,
                      hintText: widget.args['category'] == 'home' ? 'Yes, No' : widget.args['category'] == 'camera' ? 'Full Frame, APS-C' : 'Automatic, Manual',
                      current: vm.transmissionFocusNode,
                      next:vm.yearFocusNode,
                    ),
                    Text(widget.args['category']== 'home' ? 'Size*' : widget.args['category'] == 'camera' ? 'Resolution*' :
                    'Year*',
                      style: mediumTextStyle,
                    ),
                    CustomTextField(
                      filled: true,
                      focusNode: vm.yearFocusNode,
                      controller: yearController,
                      keyboardType:widget.args['category'] == 'camera' ? TextInputType.text : TextInputType.number,
                      hintText: widget.args['category']== 'home' ? '1800(In Sqft)' : widget.args['category']== 'camera' ? '26.1 MP, 24.2 MP' : '2022, 2023',
                      current: vm.yearFocusNode,
                      next:vm.locationFocusNode,
                    ),
                    Text(
                      'Location*',
                      style: mediumTextStyle,
                    ),
                    CustomTextField(
                      filled: true,
                      focusNode: vm.locationFocusNode,
                      controller: locationController,
                      keyboardType: TextInputType.text,
                      hintText: 'Peshawar, Islamabad',
                      current: vm.locationFocusNode,
                      next:vm.priceFocusNode,
                    ),
                    Text(
                      'Price Per Day*',
                      style: mediumTextStyle,
                    ),
                    CustomTextField(
                      filled: true,
                      focusNode: vm.priceFocusNode,
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      hintText: '1000(In Pkr)',
                      current: vm.priceFocusNode,
                      next:null,
                    ),
                    Text(
                      'Available From*',
                      style: mediumTextStyle,
                    ),
                    DateTimeTextField(
                        filled: true,
                        textStyle: mediumTextStyle.copyWith(fontSize: 16, color: AppColors.blackColor),
                        hintStyle: mediumTextStyle.copyWith(fontSize: 16, color: AppColors.hintTextColor),
                        controller: availableFromController,
                        hintText: 'DD/MM/YYY',
                        onPress: (){
                          vm.selectDate(context, availableFromController);
                        },
                        date: true),
                    Text(
                      'Available To*',
                      style: mediumTextStyle,
                    ),
                    DateTimeTextField(
                        filled: true,
                        textStyle: mediumTextStyle.copyWith(fontSize: 16, color: AppColors.blackColor),
                        hintStyle: mediumTextStyle.copyWith(fontSize: 16, color: AppColors.hintTextColor),
                        controller: availableToController,
                        hintText: 'DD/MM/YYY',
                        onPress: (){
                          vm.selectDate(context, availableToController);
                        },
                        date: true),
                    CustomButton(
                        loading: vm.loading,
                        text: 'Update Service', onPress: (){
                      vm.updateService(context,
                        widget.args['docId'],
                        widget.args['category'],
                        modelController.text.trim().toLowerCase(),
                        typeController.text.trim(),
                        fuelController.text.trim(),
                        transmissionController.text.trim(),
                        yearController.text.trim(),
                        locationController.text.trim(),
                        priceController.text.trim(),
                        availableFromController.text.trim(),
                        availableToController.text.trim(),
                      );
                    }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
