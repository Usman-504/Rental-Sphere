import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_sphere/res/colors.dart';
import 'package:rental_sphere/utils/size_config.dart';
import 'package:rental_sphere/view_model/admin/add_service_view_model.dart';
import '../../utils/styles.dart';

class CustomDropDown extends StatefulWidget {
  final bool isRole;
  final List<String>? items;
  final String? hintText;
  final Function(String?)? onChange;
  const CustomDropDown({
    super.key, this.items, this.onChange, this.hintText,
    this.isRole = false


  });



  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AddServiceViewModel>(context, listen: false).initializeCategory();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AddServiceViewModel>(context);
  SizeConfig.init(context);
  return SizedBox(
    height: SizeConfig.scaleHeight(60),
    child: DropdownSearch<String>(
      popupProps: PopupProps.menu(
        fit: FlexFit.loose,
        showSelectedItems: true,
        menuProps: const MenuProps(
          // backgroundColor: Colors.black,
        ),
        itemBuilder: (context, item, isSelected) {
          return Container(
            decoration: BoxDecoration(
              color:isSelected
                  ? AppColors.blackColor
                  : AppColors.whiteColor,
            ),

            padding:  EdgeInsets.symmetric(vertical: SizeConfig.scaleHeight(10), horizontal: SizeConfig.scaleWidth(10)),
            child: Text(
              item,
              style: mediumTextStyle.copyWith(color: isSelected
                  ? AppColors.whiteColor
                  : AppColors.blackColor,
              ),
            ),
          );
        },
      ),
      dropdownDecoratorProps: DropDownDecoratorProps(
        baseStyle: mediumTextStyle.copyWith(color: AppColors.blackColor),
        dropdownSearchDecoration: InputDecoration(
          hintText: widget.isRole == true ? widget.hintText : 'Select Category',
          filled: true,
          fillColor:  AppColors.whiteColor,
          contentPadding: const EdgeInsets.only(left: 10, top: 15),
          hintStyle: mediumTextStyle.copyWith(color: AppColors.hintTextColor),

          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(color: AppColors.blackColor, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(color: AppColors.blackColor, width: 1.0),
          ),
        ),
      ),
      dropdownButtonProps: const DropdownButtonProps(
        icon: Icon(
          Icons.arrow_drop_down,
          color: AppColors.blackColor,
        ),
      ),
      items: widget.isRole == true ? widget.items! : vm.categories,
      onChanged:widget.isRole == true ? widget.onChange : vm.dropDownCategory,
      selectedItem: widget.isRole == true ? widget.items!.first : vm.selectedCategory,

    ),
  );
  }
}