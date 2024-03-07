import 'package:image_picker/image_picker.dart';
import 'package:stackfood_multivendor_driver/api/api_client.dart';
import 'package:stackfood_multivendor_driver/feature/chat/domain/models/conversation_model.dart';
import 'package:stackfood_multivendor_driver/feature/chat/domain/repositories/chat_repository_interface.dart';
import 'package:stackfood_multivendor_driver/feature/chat/domain/services/chat_service_interface.dart';
import 'package:stackfood_multivendor_driver/helper/user_type_helper.dart';
import 'package:get/get.dart';

class ChatService implements ChatServiceInterface {
  final ChatRepositoryInterface chatRepositoryInterface;
  ChatService({required this.chatRepositoryInterface});

  @override
  Future<ConversationsModel?> getConversationList(int offset) async {
    return await chatRepositoryInterface.getConversationList(offset);
  }

  @override
  Future<ConversationsModel?> searchConversationList(String name) async {
    return await chatRepositoryInterface.searchConversationList(name);
  }

  @override
  Future<Response> getMessages(int offset, int? userId, UserType userType, int? conversationID) async {
    return await chatRepositoryInterface.getMessages(offset, userId, userType, conversationID);
  }

  @override
  Future<Response> sendMessage(String message, List<MultipartBody> file, int? conversationId, int? userId, UserType userType) async {
    return await chatRepositoryInterface.sendMessage(message, file, conversationId, userId, userType);
  }

  @override
  List<MultipartBody> processImages(List <XFile>?chatImage) {
    List<MultipartBody> myImages = [];
    for (var image in chatImage!) {
      myImages.add(MultipartBody('image[]', image));
    }
    return myImages;
  }

}