import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_sphere/res/colors.dart';
import 'package:rental_sphere/res/components/custom_textfield.dart';
import 'package:rental_sphere/utils/size_config.dart';
import 'package:rental_sphere/utils/styles.dart';
import 'package:rental_sphere/view_model/specific_chat_view_model.dart';

class SpecificChatView extends StatefulWidget {
  final Map args;
  const SpecificChatView({super.key, required this.args});

  @override
  _SpecificChatViewState createState() => _SpecificChatViewState();
}

class _SpecificChatViewState extends State<SpecificChatView> {

  late String senderId;
  late String receiverId;
  late String name;
  late String image;



  @override
  void initState() {
    super.initState();
    senderId = widget.args['senderId'];
    receiverId = widget.args['receiverId'];
    name = widget.args['name'];
    image = widget.args['image'];
  }

  @override
  Widget build(BuildContext context) {
    String chatId = senderId.compareTo(receiverId) < 0
        ? '${senderId}_$receiverId'
        : '${receiverId}_$senderId';
    return ChangeNotifierProvider(
      create: (_) => SpecificChatViewModel(),
      child: Consumer<SpecificChatViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            backgroundColor: AppColors.scaffoldColor,
            appBar: AppBar(
              leading: InkWell(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back, size: 30, color: AppColors.whiteColor),
              ),
              backgroundColor: AppColors.blackColor,
              title:Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(image),
                    radius: 18,
                  ),
                  SizedBox(width: 10),
                  Text(
                    name,
                    style: secondaryTextStyle.copyWith(color: AppColors.whiteColor),
                  ),
                ],
              ),
              automaticallyImplyLeading: false,
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: vm.getSpecificChat(chatId),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(child: CircularProgressIndicator());
                      }
                      if(snapshot.hasError){
                       return Text('Error Occurred');
                      }
                      if (!snapshot.hasData) {
                        return Text('No Message Sent Yet');
                      }
                      var messages = snapshot.data!.docs;
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (messages.isNotEmpty) {
                          vm.scrollToBottom();
                        }
                      });
                      return ListView.builder(
                        controller: vm.scrollController,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          var message = messages[index];
                          bool isMe = message['senderId'] == senderId;
                          return Align(
                            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: SizeConfig.scaleHeight(5), horizontal: SizeConfig.scaleWidth(10)),
                              padding: EdgeInsets.all(SizeConfig.scaleHeight(10)),
                              decoration: BoxDecoration(
                                color: isMe ? AppColors.blueColor.shade300 : AppColors.greyColor.shade300,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: SizeConfig.screenWidth * 0.8
                                ),
                                child: Text(
                                  message['text'],
                                  style: smallTextStyle.copyWith(fontSize: 13),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(SizeConfig.scaleHeight(10)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.image, size: 30, color: AppColors.blackColor),
                        onPressed: () {},
                      ),
                      Expanded(
                        child: CustomTextField(
                          maxLines: vm.maxLines,
                          bottom: 0,
                          focusNode: vm.chatFocusNode,
                          controller: vm.chatController,
                          keyboardType: TextInputType.text,
                          hintText: 'Message',
                          current: vm.chatFocusNode,
                          next: null,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send, size: 30, color: AppColors.blackColor),
                        onPressed: () async {
                          vm.sendMessage(senderId, receiverId, context);
                        },
                      ),
                    ],
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
