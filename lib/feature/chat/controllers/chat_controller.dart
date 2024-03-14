import 'package:stackfood_multivendor_driver/feature/chat/domain/services/chat_service_interface.dart';
import 'package:stackfood_multivendor_driver/api/api_client.dart';
import 'package:stackfood_multivendor_driver/feature/notification/domain/models/notification_body_model.dart';
import 'package:stackfood_multivendor_driver/feature/chat/domain/models/conversation_model.dart';
import 'package:stackfood_multivendor_driver/feature/chat/domain/models/message_model.dart';
import 'package:stackfood_multivendor_driver/feature/profile/controllers/profile_controller.dart';
import 'package:stackfood_multivendor_driver/helper/user_type_helper.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChatController extends GetxController implements GetxService {
  final ChatServiceInterface chatServiceInterface;
  ChatController({required this.chatServiceInterface});

  List<bool>? _showDate;
  List<bool>? get showDate => _showDate;

  List<XFile>? _imageFiles;
  List<XFile>? get imageFiles => _imageFiles;

  bool _isSendButtonActive = false;
  bool get isSendButtonActive => _isSendButtonActive;

  final bool _isSeen = false;
  bool get isSeen => _isSeen;

  final bool _isSend = true;
  bool get isSend => _isSend;

  final bool _isMe = false;
  bool get isMe => _isMe;

  bool _isLoading= false;
  bool get isLoading => _isLoading;

  List <XFile>?_chatImage = [];
  List<XFile>? get chatImage => _chatImage;

  int? _pageSize;
  int? get pageSize => _pageSize;

  int? _offset;
  int? get offset => _offset;

  ConversationsModel? _conversationModel;
  ConversationsModel? get conversationModel => _conversationModel;

  ConversationsModel? _searchConversationModel;
  ConversationsModel? get searchConversationModel => _searchConversationModel;

  MessageModel? _messageModel;
  MessageModel? get messageModel => _messageModel;

  Future<void> getConversationList(int offset) async{
    _searchConversationModel = null;
    _conversationModel = null;
    ConversationsModel? conversationModel = await chatServiceInterface.getConversationList(offset);
    if(conversationModel != null) {
      if(offset == 1) {
        _conversationModel = conversationModel;
      }else {
        _conversationModel!.totalSize = conversationModel.totalSize;
        _conversationModel!.offset = conversationModel.offset;
        _conversationModel!.conversations!.addAll(conversationModel.conversations!);
      }
    }
    update();
  }

  Future<void> searchConversation(String name) async {
    _searchConversationModel = ConversationsModel();
    update();
    ConversationsModel? searchConversationModel = await chatServiceInterface.searchConversationList(name);
    if(searchConversationModel != null) {
      _searchConversationModel = searchConversationModel;
    }
    update();
  }

  void removeSearchMode() {
    _searchConversationModel = null;
    update();
  }

  Future<void> getMessages(int offset, NotificationBodyModel notificationBody, User? user, int? conversationID, {bool firstLoad = false}) async {
    Response? response;
    if(firstLoad) {
      _messageModel = null;
    }

    if(notificationBody.customerId != null || notificationBody.type == UserType.user.name) {
      response = await chatServiceInterface.getMessages(offset, notificationBody.customerId, UserType.user, conversationID);
    }else if(notificationBody.vendorId != null || notificationBody.type == UserType.vendor.name) {
      response = await chatServiceInterface.getMessages(offset, notificationBody.vendorId, UserType.vendor, conversationID);
    }

    if (response != null && response.body['messages'] != {} && response.statusCode == 200) {
      if (offset == 1) {

        if(Get.find<ProfileController>().profileModel == null) {
          await Get.find<ProfileController>().getProfile();
        }

        _messageModel = MessageModel.fromJson(response.body);
        if(_messageModel!.conversation == null && user != null) {
          _messageModel!.conversation = Conversation(sender: User(
            id: Get.find<ProfileController>().profileModel!.id, image: Get.find<ProfileController>().profileModel!.image,
            fName: Get.find<ProfileController>().profileModel!.fName, lName: Get.find<ProfileController>().profileModel!.lName,
          ), receiver: user);
        }else if(_messageModel!.conversation != null && _messageModel!.conversation!.receiverType == 'delivery_man') {
          User? receiver = _messageModel!.conversation!.receiver;
          _messageModel!.conversation!.receiver = _messageModel!.conversation!.sender;
          _messageModel!.conversation!.sender = receiver;
        }
      }else {
        _messageModel!.totalSize = MessageModel.fromJson(response.body).totalSize;
        _messageModel!.offset = MessageModel.fromJson(response.body).offset;
        _messageModel!.messages!.addAll(MessageModel.fromJson(response.body).messages!);
      }
    }
    _isLoading = false;
    update();

  }

  void pickImage(bool isRemove) async {
    final ImagePicker picker = ImagePicker();
    if(isRemove) {
      _imageFiles = [];
      _chatImage = [];
    }else {
      _imageFiles = await picker.pickMultiImage(imageQuality: 30);
      if (_imageFiles != null) {
        _chatImage = imageFiles;
        _isSendButtonActive = true;
      }
    }
    update();
  }

  void removeImage(int index){
    chatImage!.removeAt(index);
    update();
  }

  void toggleSendButtonActivity() {
    _isSendButtonActive = !_isSendButtonActive;
    update();
  }

  Future<Response?> sendMessage({required String message, required NotificationBodyModel? notificationBody, required int? conversationId}) async {
    Response? response;
    _isLoading = true;
    update();

    List<MultipartBody> myImages = chatServiceInterface.processImages(_chatImage);

    if(notificationBody != null && (notificationBody.customerId != null || notificationBody.type == UserType.user.name)) {
      response = await chatServiceInterface.sendMessage(message, myImages, conversationId, notificationBody.customerId, UserType.customer);
    }else if(notificationBody != null && (notificationBody.vendorId != null || notificationBody.type == UserType.vendor.name)){
      response = await chatServiceInterface.sendMessage(message, myImages, conversationId, notificationBody.vendorId, UserType.vendor);
    }

    if (response!.statusCode == 200) {
      _imageFiles = [];
      _chatImage = [];
      _isSendButtonActive = false;
      _isLoading = false;
      _messageModel = MessageModel.fromJson(response.body);
      if(_messageModel!.conversation != null && _messageModel!.conversation!.receiverType == 'delivery_man') {
        User? receiver = _messageModel!.conversation!.receiver;
        _messageModel!.conversation!.receiver = _messageModel!.conversation!.sender;
        _messageModel!.conversation!.sender = receiver;
      }
    }
    update();
    return response;
  }

}