import 'dart:io';
import 'package:stackfood_multivendor_driver/feature/auth/controllers/auth_controller.dart';
import 'package:stackfood_multivendor_driver/feature/splash/controllers/splash_controller.dart';
import 'package:stackfood_multivendor_driver/feature/chat/controllers/chat_controller.dart';
import 'package:stackfood_multivendor_driver/feature/notification/domain/models/notification_body_model.dart';
import 'package:stackfood_multivendor_driver/feature/chat/domain/models/conversation_model.dart';
import 'package:stackfood_multivendor_driver/feature/chat/widgets/message_bubble_widget.dart';
import 'package:stackfood_multivendor_driver/helper/responsive_helper.dart';
import 'package:stackfood_multivendor_driver/helper/user_type_helper.dart';
import 'package:stackfood_multivendor_driver/util/dimensions.dart';
import 'package:stackfood_multivendor_driver/util/images.dart';
import 'package:stackfood_multivendor_driver/util/styles.dart';
import 'package:stackfood_multivendor_driver/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_driver/common/widgets/paginated_list_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  final NotificationBodyModel? notificationBody;
  final User? user;
  final int? conversationId;
  const ChatScreen({super.key, required this.notificationBody, required this.user, this.conversationId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _inputMessageController = TextEditingController();
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    Get.find<ChatController>().getMessages(1, widget.notificationBody!, widget.user, widget.conversationId, firstLoad: true);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (chatController) {

      String? baseUrl = '';

      if(widget.notificationBody!.customerId != null) {
        baseUrl = Get.find<SplashController>().configModel!.baseUrls!.customerImageUrl;
      }else {
        baseUrl = Get.find<SplashController>().configModel!.baseUrls!.restaurantImageUrl;
      }

      return Scaffold(

        appBar: AppBar(
          title: Text(
            chatController.messageModel != null ? '${chatController.messageModel!.conversation!.receiver!.fName ?? ''}'
              ' ${chatController.messageModel!.conversation!.receiver!.lName ?? ''}' : 'receiver_name'.tr,
          ),
          backgroundColor: Theme.of(context).primaryColor,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 40, height: 40, alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(width: 2,color: Theme.of(context).cardColor),
                  color: Theme.of(context).cardColor,
                ),
                child: ClipOval(
                  child: Image.network(
                    '$baseUrl/${chatController.messageModel != null ? chatController.messageModel!.conversation!.receiver!.image : ''}',
                    errorBuilder: (context, error, stackTrace) => Image.asset(Images.placeholder, fit: BoxFit.cover, height: 40, width: 40,),
                    fit: BoxFit.cover, height: 40, width: 40,
                  ),
                ),
              ),
            ),
          ],
        ),

        body: _isLoggedIn ? SafeArea(
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(children: [

                Expanded(child: chatController.messageModel != null ? chatController.messageModel!.messages!.isNotEmpty ? SingleChildScrollView(
                  controller: _scrollController,
                  reverse: true,
                  child: PaginatedListViewWidget(
                    scrollController: _scrollController,
                    totalSize: chatController.messageModel?.totalSize,
                    offset: chatController.messageModel?.offset,
                    onPaginate: (int? offset) async => await chatController.getMessages(
                      offset!, widget.notificationBody!, widget.user, widget.conversationId,
                    ),
                    productView: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: chatController.messageModel!.messages!.length,
                      itemBuilder: (context, index) {
                        return MessageBubbleWidget(
                          message: chatController.messageModel!.messages![index],
                          user: chatController.messageModel!.conversation!.receiver,
                          sender: chatController.messageModel!.conversation!.sender,
                          userType: widget.notificationBody!.customerId != null ? UserType.user : UserType.vendor,
                        );
                      },
                    ),
                  ),
                ) : Center(child: Text('no_message_found'.tr)) : const Center(child: CircularProgressIndicator())),

                (chatController.messageModel != null && (chatController.messageModel!.status! || chatController.messageModel!.messages!.isEmpty)) ? Container(
                  color: Theme.of(context).cardColor,
                  child: Column(children: [

                    chatController.chatImage!.isNotEmpty ? SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: chatController.chatImage!.length,
                        itemBuilder: (BuildContext context, index){
                          return  chatController.chatImage!.isNotEmpty ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(children: [

                              Container(
                                width: 100, height: 100,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault)),
                                  child: ResponsiveHelper.isWeb() ? Image.network(
                                    chatController.chatImage![index].path, width: 100, height: 100, fit: BoxFit.cover,
                                  ) : Image.file(
                                    File(chatController.chatImage![index].path), width: 100, height: 100, fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                              Positioned(
                                top: 0, right: 0,
                                child: InkWell(
                                  onTap : () => chatController.removeImage(index),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Icon(Icons.clear, color: Theme.of(context).colorScheme.error, size: 15),
                                    ),
                                  ),
                                ),
                              ),

                            ]),
                          ) : const SizedBox();
                        },
                      ),
                    ) : const SizedBox(),

                    Row(children: [

                      InkWell(
                        onTap: () async {
                          Get.find<ChatController>().pickImage(false);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                          child: Image.asset(Images.image, width: 25, height: 25, color: Theme.of(context).hintColor),
                        ),
                      ),

                      SizedBox(
                        height: 25,
                        child: VerticalDivider(width: 0, thickness: 1, color: Theme.of(context).hintColor),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeDefault),

                      Expanded(
                        child: TextField(
                          inputFormatters: [LengthLimitingTextInputFormatter(Dimensions.messageInputLength)],
                          controller: _inputMessageController,
                          textCapitalization: TextCapitalization.sentences,
                          style: robotoRegular,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'type_here'.tr,
                            hintStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeLarge),
                          ),
                          onSubmitted: (String newText) {
                            if(newText.trim().isNotEmpty && !Get.find<ChatController>().isSendButtonActive) {
                              Get.find<ChatController>().toggleSendButtonActivity();
                            }else if(newText.isEmpty && Get.find<ChatController>().isSendButtonActive) {
                              Get.find<ChatController>().toggleSendButtonActivity();
                            }
                          },
                          onChanged: (String newText) {
                            if(newText.trim().isNotEmpty && !Get.find<ChatController>().isSendButtonActive) {
                              Get.find<ChatController>().toggleSendButtonActivity();
                            }else if(newText.isEmpty && Get.find<ChatController>().isSendButtonActive) {
                              Get.find<ChatController>().toggleSendButtonActivity();
                            }
                          },
                        ),
                      ),

                      GetBuilder<ChatController>(builder: (chatController) {
                        return InkWell(
                          onTap: () async {
                            if(chatController.isSendButtonActive) {
                              await chatController.sendMessage(
                                message: _inputMessageController.text, notificationBody: widget.notificationBody, conversationId: widget.conversationId,
                              ).then((value) {
                                if(value!.statusCode == 200){
                                  Future.delayed(const Duration(seconds: 2),() {
                                    Get.find<ChatController>().getMessages(1, widget.notificationBody!, widget.user, widget.conversationId);
                                  });
                                }
                              });
                              _inputMessageController.clear();
                            }else{
                              showCustomSnackBar('write_somethings'.tr);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                            child: chatController.isLoading ? const SizedBox(
                              width: 25, height: 25,
                              child: CircularProgressIndicator(),
                            ) : Image.asset(
                              Images.send, width: 25, height: 25,
                              color: chatController.isSendButtonActive ? Theme.of(context).primaryColor : Theme.of(context).hintColor,
                            ),
                          ),
                        );
                      }),

                    ]),

                  ]),
                ) : const SizedBox(),
              ]),
            ),
          ),
        ) : const Center(child: Text('Not Login')),
      );
    });
  }
}