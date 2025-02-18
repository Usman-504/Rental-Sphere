import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_sphere/res/colors.dart';
import 'package:rental_sphere/res/components/navigation_helper.dart';
import 'package:rental_sphere/utils/routes/routes_name.dart';
import 'package:rental_sphere/utils/size_config.dart';
import 'package:rental_sphere/view_model/profile_view_model.dart';

import '../utils/styles.dart';


class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {


  @override
  void initState(){
    super.initState();
    Provider.of<ProfileViewModel>(context, listen: false).fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
 SizeConfig.init(context);
    return Consumer<ProfileViewModel>(
      builder: (context, vm, child) {
        String role = vm.role == 'admin' ? 'Service Provider' : 'Service Seeker' ;
       return Scaffold(
            backgroundColor: AppColors.scaffoldColor,
            appBar: AppBar(
              backgroundColor: AppColors.blackColor,
          automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text('Profile',
                  style: secondaryTextStyle.copyWith(color: AppColors.whiteColor)),
            ),
            body: Padding(
              padding: EdgeInsets.all(SizeConfig.scaleHeight(25)),
              child: Column(
                children: [
                  Container(
                    height: SizeConfig.scaleHeight(130),
                    decoration: BoxDecoration(
                      color: AppColors.blackColor,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: SizeConfig.scaleWidth(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: SizeConfig.scaleHeight(100),
                                width: SizeConfig.scaleHeight(100),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.whiteColor,
                                        width: 3),
                                    shape: BoxShape.circle),
                              ),
                              Positioned(
                                top: SizeConfig.scaleHeight(7),
                                left: SizeConfig.scaleHeight(7),
                                child: GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      height: SizeConfig.scaleHeight(86),
                                      width: SizeConfig.scaleHeight(86),
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image:NetworkImage(vm.image)),
                                          shape: BoxShape.circle),
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: SizeConfig.scaleWidth(10),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    overflow: TextOverflow.ellipsis,
                                    vm.name[0].toUpperCase() + vm.name.substring(1),
                                    style: mediumTextStyle.copyWith(color: AppColors.whiteColor),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    overflow: TextOverflow.ellipsis,
                                    vm.email,
                                    style: smallTextStyle.copyWith(color: AppColors.whiteColor),
                                  ),
                                ),
                                Text(
                                  'Role: $role',
                                  style: smallTextStyle.copyWith(color: AppColors.whiteColor),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                              onTap: (){
                                NavigationHelper.navigateWithSlideTransition(context: context, routeName: RoutesName.updateProfile, arguments: {
                                  'name' : vm.name,
                                  'email' : vm.email,
                                  'image' : vm.image,
                                  'docId' : FirebaseAuth.instance.currentUser!.uid,
                                });
                              },
                              child: Icon(Icons.edit, color: AppColors.whiteColor,)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height:SizeConfig.scaleHeight(20),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: vm.role == 'admin' ? vm.adminInfo.length : vm.info.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: SizeConfig.scaleHeight(20),
                            ),
                            child: Container(
                              height:SizeConfig.scaleHeight(80),
                              decoration: BoxDecoration(
                                color: AppColors.blackColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: GestureDetector(
                                onTap: (){
                                  vm.navigateToScreen(context, index);
                                },
                                child: ListTile(
                                  leading: Icon(
                                    vm.role == 'admin' ? vm.adminInfo[index]['icon'] :
                                    vm.info[index]['icon'],
                                    color: AppColors.whiteColor,
                                  ),
                                  title: Text(
                                    vm.role == 'admin' ? vm.adminInfo[index]['title'] :
                                    vm.info[index]['title'],
                                    style: mediumTextStyle.copyWith(color: AppColors.whiteColor, fontSize: 16),
                                  ),
                                  trailing: Icon( vm.role == 'admin' ? vm.adminInfo[index]['staticIcon'] :
                                  vm.info[index]['staticIcon'],

                                  color: AppColors.whiteColor,),
                                  // subtitle: Text(info[index]['description']),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
