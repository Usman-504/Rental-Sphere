import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_sphere/res/colors.dart';
import 'package:rental_sphere/res/components/custom_textfield.dart';
import 'package:rental_sphere/utils/size_config.dart';
import '../res/components/custom_button.dart';
import '../utils/styles.dart';
import '../view_model/update_profile_view_model.dart';

class UpdateProfileView extends StatefulWidget {
  final Map args;


  const UpdateProfileView(
      {required this.args,

      super.key});

  @override
  State<UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  TextEditingController passwordController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  final ValueNotifier<bool> obscurePassword = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.args['name']);
    emailController = TextEditingController(text: widget.args['email']);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=>UpdateProfileViewModel(),
      child: Consumer<UpdateProfileViewModel>(
        builder:  (context, vm, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.blackColor,
              leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    // size: heightX * 0.04,
                    color: AppColors.whiteColor,
                  )),
              centerTitle: true,
              title: Text('Update Profile',
                  style: secondaryTextStyle.copyWith(
                      color: AppColors.whiteColor, )),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: SizeConfig.scaleWidth(25)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: SizeConfig.scaleHeight(160),
                            width: SizeConfig.scaleHeight(160),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.blackColor,
                                    width: 3),
                                shape: BoxShape.circle),
                          ),
                          Positioned(
                            top: SizeConfig.scaleHeight(7),
                            left: SizeConfig.scaleHeight(7),
                            child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: SizeConfig.scaleHeight(146),
                                  width: SizeConfig.scaleHeight(146),
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image:vm.file != null
                                              ? FileImage(
                                              File(vm.file!.path))
                                              :  NetworkImage(widget.args['image']),),
                                      shape: BoxShape.circle),
                                )),
                          ),
                          Positioned(
                            top: SizeConfig.scaleHeight(115),
                            left: SizeConfig.scaleHeight(115),
                            child: GestureDetector(
                                onTap: () {
                                  vm.pickImage();
                                },
                                child: Container(
                                  height: SizeConfig.scaleHeight(40),
                                  width: SizeConfig.scaleHeight(40),
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                      shape: BoxShape.circle),
                                  child: Icon(Icons.camera_alt),
                                )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.scaleHeight(35),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name*',
                            style: mediumTextStyle,
                          ),
                          CustomTextField(
                              focusNode: nameFocusNode,
                              controller: nameController,
                              keyboardType: TextInputType.text,
                              hintText:'Update Name',
                              current: nameFocusNode,
                              next: emailFocusNode),
                          Text(
                            'Email*',
                            style: mediumTextStyle,
                          ),
                          CustomTextField(
                              focusNode: emailFocusNode,
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              hintText:'Update Email',
                              current: emailFocusNode,
                              next: passwordFocusNode),
                          SizedBox(
                            height: SizeConfig.scaleHeight(70),
                          ),
                          Text(
                            'Enter Password to Save:',
                            style: smallTextStyle.copyWith(fontSize: 16),
                          ),
                          ValueListenableBuilder(
                            valueListenable: obscurePassword,
                            builder: (context, vm, child) {
                              return CustomTextField(
                                bottom: 20,
                                isPassword: true,
                                obscurePassword: obscurePassword,
                                focusNode: passwordFocusNode,
                                controller: passwordController,
                                keyboardType: TextInputType.text,
                                hintText: 'Enter Your Password',
                                current: passwordFocusNode,
                                next: null,
                              );
                            },
                          ),
                          CustomButton(
                            text: 'Save',
                            loading: vm.loading,
                            onPress: () {
                              vm.updateUserDetails(
                                  nameController.text.trim(),
                                  emailController.text.trim(),
                                  widget.args['docId'],
                                  passwordController.text.trim(),
                                  context);
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
