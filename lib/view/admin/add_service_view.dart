import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_sphere/res/components/custom_button.dart';
import 'package:rental_sphere/res/components/custom_dropdown.dart';
import 'package:rental_sphere/res/components/datetime_textfield.dart';
import 'package:rental_sphere/utils/size_config.dart';
import 'package:rental_sphere/view_model/admin/add_service_view_model.dart';
import '../../res/colors.dart';
import '../../res/components/custom_textfield.dart';
import '../../utils/styles.dart';

class AddServiceView extends StatelessWidget {
  const AddServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=>AddServiceViewModel(),
      child: Consumer<AddServiceViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            backgroundColor: AppColors.scaffoldColor,
            appBar: AppBar(
              backgroundColor: AppColors.blackColor,
              centerTitle: true,
              title:  Text("Add Service", style: secondaryTextStyle.copyWith(color: AppColors.whiteColor),),
              automaticallyImplyLeading: false,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding:  EdgeInsets.all(SizeConfig.scaleHeight(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomDropDown(
                    ),
                    Padding(
                      padding:  EdgeInsets.symmetric(vertical: SizeConfig.scaleHeight(20)),
                      child: InkWell(
                        onTap: ()async{
                          vm.pickImage();
                        },
                        child: Container(
                          height: SizeConfig.scaleHeight(250),
                          decoration: BoxDecoration(
                              image: vm.file != null
                                  ? DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(File(vm.file!.path)))
                                  : null,
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(width: 1, color: AppColors.blackColor)
                          ),
                          child: Center(
                            child: vm.file == null ?
                            Text(vm.selectedCategory != null ? 'Upload ${vm.selectedCategory} Image' : 'Upload Image',
                            style: mediumTextStyle,
                            ) : null,
                          ),
                        ),
                      ),
                    ),
                    Text( vm.selectedCategory != null && vm.selectedCategory == 'Home' ? 'Home Type*' : vm.selectedCategory != null && vm.selectedCategory == 'Camera' ? 'Camera Brand*' :
                      'Car Model*',
                      style: mediumTextStyle,
                    ),
                    CustomTextField(
                      filled: true,
                      focusNode: vm.modelFocusNode,
                      controller: vm.modelController,
                      keyboardType: TextInputType.text,
                      hintText: vm.selectedCategory != null && vm.selectedCategory == 'Home' ? 'House, Apartment' : vm.selectedCategory != null && vm.selectedCategory == 'Camera' ? 'Nikon, Sony' :'Civic, Swift',
                      current: vm.modelFocusNode,
                      next:vm.typeFocusNode,
                    ),
                    Text(vm.selectedCategory != null && vm.selectedCategory == 'Home' ? 'Bedrooms*' : vm.selectedCategory != null && vm.selectedCategory == 'Camera' ? 'Camera Model*' :
                      'Car Type*',
                      style: mediumTextStyle,
                    ),
                    CustomTextField(
                      filled: true,
                      focusNode: vm.typeFocusNode,
                      controller: vm.typeController,
                      keyboardType: vm.selectedCategory != null && vm.selectedCategory == 'Home' ? TextInputType.number : TextInputType.text,
                      hintText: vm.selectedCategory != null && vm.selectedCategory == 'Home' ? '2, 3' : vm.selectedCategory != null && vm.selectedCategory == 'Camera' ? 'Mark IV, A7 III' : 'Sedan, Truck',
                      current: vm.typeFocusNode,
                      next:vm.fuelFocusNode,
                    ),
                    Text(vm.selectedCategory != null && vm.selectedCategory == 'Home' ? 'Bathrooms*' : vm.selectedCategory != null && vm.selectedCategory == 'Camera' ? 'Lens Type*' :
                      'Fuel Type*',
                      style: mediumTextStyle,
                    ),
                    CustomTextField(
                      filled: true,
                      focusNode: vm.fuelFocusNode,
                      controller: vm.fuelController,
                      keyboardType: vm.selectedCategory != null && vm.selectedCategory == 'Home' ? TextInputType.number : TextInputType.text,
                      hintText: vm.selectedCategory != null && vm.selectedCategory == 'Home' ? '1, 2' : vm.selectedCategory != null && vm.selectedCategory == 'Camera' ? '70-200mm f/2.8' : 'Petrol, Diesel',
                      current: vm.fuelFocusNode,
                      next:vm.transmissionFocusNode,
                    ),
                    Text(vm.selectedCategory != null && vm.selectedCategory == 'Home' ? 'Furnished*' : vm.selectedCategory != null && vm.selectedCategory == 'Camera' ? 'Sensor Type*' :
                      'Transmission*',
                      style: mediumTextStyle,
                    ),
                    CustomTextField(
                      filled: true,
                      focusNode: vm.transmissionFocusNode,
                      controller: vm.transmissionController,
                      keyboardType: TextInputType.text,
                      hintText: vm.selectedCategory != null && vm.selectedCategory == 'Home' ? 'Yes, No' : vm.selectedCategory != null && vm.selectedCategory == 'Camera' ? 'Full Frame, APS-C' : 'Automatic, Manual',
                      current: vm.transmissionFocusNode,
                      next:vm.yearFocusNode,
                    ),
                    Text(vm.selectedCategory != null && vm.selectedCategory == 'Home' ? 'Size*' : vm.selectedCategory != null && vm.selectedCategory == 'Camera' ? 'Resolution*' :
                      'Year*',
                      style: mediumTextStyle,
                    ),
                    CustomTextField(
                      filled: true,
                      focusNode: vm.yearFocusNode,
                      controller: vm.yearController,
                      keyboardType:vm.selectedCategory != null && vm.selectedCategory == 'Camera' ? TextInputType.text : TextInputType.number,
                      hintText: vm.selectedCategory != null && vm.selectedCategory == 'Home' ? '1800(In Sqft)' : vm.selectedCategory != null && vm.selectedCategory == 'Camera' ? '26.1 MP, 24.2 MP' : '2022, 2023',
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
                      controller: vm.locationController,
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
                      controller: vm.priceController,
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
                        controller: vm.availableFromController,
                        hintText: 'DD/MM/YYY',
                        onPress: (){
                          vm.selectDate(context, vm.availableFromController);
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
                        controller: vm.availableToController,
                        hintText: 'DD/MM/YYY',
                        onPress: (){
                          vm.selectDate(context, vm.availableToController);
                        },
                        date: true),
                    CustomButton(
                        loading: vm.loading,
                        text: 'Add Service', onPress: (){
                      vm.addService(context);
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
