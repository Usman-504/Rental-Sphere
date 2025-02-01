import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_sphere/res/components/navigation_helper.dart';
import 'package:rental_sphere/utils/routes/routes_name.dart';

import '../utils/utils.dart';

class BookingViewModel with ChangeNotifier{
final TextEditingController nameController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController addressController = TextEditingController();
final TextEditingController pickUpDateController = TextEditingController();
final TextEditingController pickUpTimeController = TextEditingController();
final TextEditingController dropOffDateController = TextEditingController();
final TextEditingController dropOffTimeController = TextEditingController();

 FocusNode nameFocusNode = FocusNode();
 FocusNode phoneFocusNode = FocusNode();
 FocusNode addressFocusNode = FocusNode();
 FocusNode pickUpDateFocusNode = FocusNode();
 FocusNode pickUpTimeFocusNode = FocusNode();
 FocusNode dropOffDateFocusNode = FocusNode();
 FocusNode dropOffTimeFocusNode = FocusNode();

DateTime? _selectedDate;
DateTime? get selectedDate => _selectedDate;

TimeOfDay? _selectedTime;
TimeOfDay? get selectedTime => _selectedTime;

int _duration = 1;
int get duration => _duration;

void selectDate(BuildContext context, TextEditingController controller) async {
 _selectedDate = await showDatePicker(
  context: context,
  initialDate: DateTime.now(),
  firstDate: DateTime(2000),
  lastDate: DateTime(2100),
 );
 if (_selectedDate != null) {
  controller.text = DateFormat('MM/dd/yyyy').format(_selectedDate!);
  calculateDuration();
 }
 notifyListeners();
}

void selectTime(BuildContext context, TextEditingController controller) async {
 _selectedTime = await showTimePicker(
  context: context,
  initialTime: TimeOfDay.now(),
 );

 if (_selectedTime != null) {
  final now = DateTime.now();
  final formattedTime = DateFormat('hh:mm a').format(DateTime(
   now.year,
   now.month,
   now.day,
   _selectedTime!.hour,
   _selectedTime!.minute,
  ));
  controller.text = formattedTime;
 }
 notifyListeners();
}


void calculateDuration() {
 if (pickUpDateController.text.isNotEmpty &&
     dropOffDateController.text.isNotEmpty) {

  DateTime pickUpDate = DateFormat('MM/dd/yyyy').parse(pickUpDateController.text);

  DateTime dropOffDate = DateFormat('MM/dd/yyyy').parse(dropOffDateController.text);
  int days = dropOffDate.difference(pickUpDate).inDays;

  _duration = days;
  if (_duration < 1) _duration = 1;
 } else {
  _duration = 1;
 }

 notifyListeners();
}

String? validateFields() {

  if (nameController.text.isEmpty) {
   return 'Please Enter Name';
  }
  else if(phoneController.text.isEmpty){
   return 'Please Enter Phone Number';
  }
  else if(addressController.text.isEmpty){
   return 'Please Enter Address';
  }

  else if(pickUpDateController.text.isEmpty){
   return 'Please Select Starting Date';
  }
  else if(pickUpTimeController.text.isEmpty){
   return 'Please Select Starting Time';
  }
  else if(dropOffDateController.text.isEmpty){
   return 'Please Select Ending Date';
  }
  else if(dropOffTimeController.text.isEmpty){
   return 'Please Select Ending Time';
  }


 return null;


}

void bookNow(BuildContext context, Map args){
 String? validation = validateFields();
 if (validation != null) {
  Utils.flushBarMessage(validation, context, true);
  return;
 }
 NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.bookingDetail, arguments:args );
}



}