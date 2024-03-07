import 'package:image_picker/image_picker.dart';
import 'package:stackfood_multivendor_driver/api/api_client.dart';
import 'package:stackfood_multivendor_driver/helper/user_type_helper.dart';

abstract class ChatServiceInterface {
  Future<dynamic> getConversationList(int offset);
  Future<dynamic> searchConversationList(String name);
  Future<dynamic> getMessages(int offset, int? userId, UserType userType, int? conversationID);
  Future<dynamic> sendMessage(String message, List<MultipartBody> file, int? conversationId, int? userId, UserType userType);
  List<MultipartBody> processImages(List <XFile>?chatImage);
}