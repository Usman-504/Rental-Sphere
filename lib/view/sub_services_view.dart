import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_sphere/res/colors.dart';
import 'package:rental_sphere/res/components/navigation_helper.dart';
import 'package:rental_sphere/utils/routes/routes_name.dart';
import 'package:rental_sphere/utils/size_config.dart';
import 'package:rental_sphere/utils/styles.dart';
import 'package:rental_sphere/view_model/services_view_model.dart';
import '../res/components/custom_header.dart';
import '../res/components/services_container.dart';

class SubServicesView extends StatelessWidget {

  final Map args;
  const SubServicesView({super.key,  required this.args});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=>ServicesViewModel(),
      child: Consumer<ServicesViewModel>(
        builder: (context, vm, child) {
          List<dynamic> serviceList = args['serviceType'] == 'Car'
              ? vm.filteredCarServices
              : args['serviceType'] == 'Home'
              ? vm.filteredHomeServices
              : vm.filteredCameraServices;
          return Scaffold(
            backgroundColor: AppColors.scaffoldColor,
            body: Column(
              children: [
                Header(controller: vm.searchSubController, ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: SizeConfig.scaleHeight(50),
                        left: SizeConfig.scaleHeight(25),
                        right: SizeConfig.scaleHeight(25),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${args['serviceType']} Services:', style: secondaryTextStyle),
                          SizedBox(
                            height: SizeConfig.screenHeight * 0.65,
                            child: serviceList.isEmpty ? Center(
                              child: Text('No ${args['serviceType']} Service Found', style: smallTextStyle,),
                            ) :
                            ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount:
                              args['serviceType'] == 'Car' ?  vm.filteredCarServices.length :  args['serviceType'] == 'Home' ? vm.filteredHomeServices.length : vm.filteredCameraServices.length,
                              itemBuilder: (context, index) {
                                var item = args['serviceType'] == 'Car' ?  vm.filteredCarServices[index]:args['serviceType'] == 'Home' ?  vm.filteredHomeServices[index] : vm.filteredCameraServices[index];
                                return InkWell(
                                    onTap: (){
                                      NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.detailedServices, arguments: {
                                        'imageUrl' : item['imageUrl'],
                                        'serviceType' : args['serviceType'],
                                        'price' : item['pricePerDay'],
                                        'location' : item['location'],
                                        'availableFrom' : item['availableFrom'],
                                        'availableTo' : item['availableTo'],
                                        'type' : args['serviceType'] == 'Camera' ? item['model'] : args['serviceType'] == 'Car' ? item['type'] : item['bedrooms'],
                                        'model' : args['serviceType'] == 'Home' ? item['type'] : args['serviceType'] == 'Camera' ? item['brand'] : item['model'],
                                        'transmission' : args['serviceType'] == 'Home' ? item['bathrooms']  : args['serviceType'] == 'Camera'? item['resolution'] : item['transmission'],
                                        'year' : args['serviceType'] == 'Home' ? item['size'] : args['serviceType'] == 'Camera'? item['sensorType'] :  item['year'],
                                        'fuelType' : args['serviceType'] == 'Home' ? item['furnished'] : args['serviceType'] == 'Camera'? item['lensType'] : item['fuelType'],
                                      });
                                    },
                                    child:
                                    ServiceContainer(
                                      subService: true,
                                      image: item['imageUrl'],
                                      title: args['serviceType'] == 'Camera' ? 'Brand: ${item['brand']}' : 'Type: ${item['type']}',
                                      subTitle: args['serviceType'] == 'Home' ? 'Bedrooms: ${item['bedrooms']}'  : 'Model: ${item['model']}',
                                      price: 'Price: ${item['pricePerDay']} Pkr/day',
                                      location: 'Location: ${item['location']}',
                                    ));
                              },),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

