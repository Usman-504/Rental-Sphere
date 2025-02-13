import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:rental_sphere/res/app_urls.dart';
import 'package:rental_sphere/res/components/navigation_helper.dart';
import 'package:rental_sphere/utils/routes/routes_name.dart';
import 'package:rental_sphere/utils/utils.dart';

class BookingDetailViewModel with ChangeNotifier{

  bool isPaymentSuccessful = false;
  bool _rejectReason = false;
  bool get rejectReason => _rejectReason;

  final TextEditingController reasonController = TextEditingController();
  FocusNode reasonFocusNode = FocusNode();

  bool _loading = false;
  bool get loading => _loading;

  void setReason(bool value) {
    _rejectReason = value;
    notifyListeners();
  }
  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool _paymentLoading = false;
  bool get paymentLoading => _paymentLoading;

  void setPaymentLoading(bool value) {
    _paymentLoading = value;
    notifyListeners();
  }

  Map<String, dynamic>? intentPaymentData;

  showPaymentSheet(BuildContext context) async{
    try{
      await Stripe.instance.presentPaymentSheet().then((val){
        isPaymentSuccessful = true;
        intentPaymentData = null;
        notifyListeners();
      }).onError((errorMsg, sTrace){
        print(errorMsg);
        print(sTrace);
      });
    }
    on StripeException catch (error){
      print(error);

      showDialog(context: context, builder: (context) {
        return const AlertDialog(
          content: Text('Cancelled'),
        );
      },);
    }
    catch(e)
    {
      print(e);
    }
  }

  makeIntentForPayment(amount, currency, BuildContext context) async{
    try{
      Map<String, dynamic>? paymentInfo = {
        'amount' : (amount * 100 ).toString(),
        'currency': currency,
        'payment_method_types[]' : 'card',
      };

      var responseFromStripeApi = await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: paymentInfo,
          headers: {
            'Authorization' : 'Bearer ${AppUrls.stripeSecretKey}',
            'Content-Type' : 'application/x-www-form-urlencoded',
          }
      );
      print('Response: ${responseFromStripeApi.body.toString()}');
      return jsonDecode(responseFromStripeApi.body);

    }
    catch(e){
      print(e);
    }
  }

  paymentSheet(amount, currency, BuildContext context) async{
    try{
      if (isPaymentSuccessful) {
        Utils.flushBarMessage('Payment Already Completed', context, true);
        return;
      }
      setPaymentLoading(true);
      intentPaymentData =  await makeIntentForPayment(amount, currency, context);
      await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
          allowsDelayedPaymentMethods: true,
          paymentIntentClientSecret: intentPaymentData!['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'Usman'
      )).then((value){
     setPaymentLoading(false);
        print(value);
      });

      showPaymentSheet(context);
    }
    catch(e){
      setPaymentLoading(false);
      print(e);
    }
  }

  void confirmBooking(dynamic data, BuildContext context, String serviceType) async{
    if (!isPaymentSuccessful) {
      Utils.flushBarMessage('Please complete the payment first', context, true);
      return;
    }
    setLoading(true);

    String collectionPath = '${serviceType.toLowerCase()}_bookings';
    String userId = data['user_id'];
    String ownerId = data['owner_id'];
    int price = data['total_price'];
    var existingBooking = await FirebaseFirestore.instance
        .collection(collectionPath)
        .where('user_id', isEqualTo: userId)
        .where('owner_id', isEqualTo: ownerId)
        .where('total_price', isEqualTo: price)
        .get();

    if (existingBooking.docs.isNotEmpty) {
      setLoading(false);
      Utils.flushBarMessage('Booking already exists', context, true);
      return;
    }
      await FirebaseFirestore.instance.collection(collectionPath).doc().set(data).then((value){
        setLoading(false);
        NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.navBar, replace: true);
        Utils.flushBarMessage('$serviceType Booking Added Successfully', context, false);
      }).catchError((error){
        setLoading(false);
        Utils.flushBarMessage('Booking Failed, Try Again', context, true);
        print(error);
      });




  }

  void updateBookingStatus(String collection, String docId, bool accept, BuildContext context) async{
    if(accept){
      setLoading(true);
      await  FirebaseFirestore.instance.collection(collection.toLowerCase()).doc(docId).update({
        'status' :'Accepted',
        'reason' :'',
      }).then((value){
        setLoading(false);
        Navigator.pop(context);
      Utils.flushBarMessage( 'Booking Accepted', context, false);
  }).catchError((error){
    setLoading(false);
    print(error);
  });
  }
    else{
      setReason(true);
      if(_rejectReason == true && reasonController.text.isEmpty){
        Utils.flushBarMessage('Please Enter Reason', context, true);
        return;
      }
setPaymentLoading(true);
      await  FirebaseFirestore.instance.collection(collection.toLowerCase()).doc(docId).update({
        'status' :  'Rejected',
        'reason' :  reasonController.text.trim(),
      }).then((value){
        setPaymentLoading(false);
        Navigator.pop(context);
        Utils.flushBarMessage( 'Booking Rejected', context, false);
      }).catchError((error){
        setPaymentLoading(false);
        print(error);
      });
    }
  }

}