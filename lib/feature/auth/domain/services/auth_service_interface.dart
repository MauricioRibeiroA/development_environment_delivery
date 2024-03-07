import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stackfood_multivendor_driver/common/models/config_model.dart';
import 'package:stackfood_multivendor_driver/api/api_client.dart';
import 'package:stackfood_multivendor_driver/feature/auth/domain/models/vehicle_model.dart';

abstract class AuthServiceInterface {
  Future<dynamic> login(String phone, String password);
  Future<dynamic> registerDeliveryMan(Map<String, String> data, List<MultipartBody> multiParts, List<MultipartDocument> additionalDocument);
  Future<dynamic> getVehicleList();
  Future<bool> saveUserToken(Response response);
  Future<dynamic> updateToken({String notificationDeviceToken = ''});
  bool isLoggedIn();
  Future<bool> clearSharedData();
  Future<void> saveUserNumberAndPassword(String number, String password, String countryCode);
  String getUserNumber();
  String getUserCountryCode();
  String getUserPassword();
  Future<bool> clearUserNumberAndPassword();
  String getUserToken();
  Future<FilePickerResult?> picFile(MediaData mediaData);
  Future<XFile?> pickImageFromGallery();
  List<MultipartDocument> prepareMultipartDocuments(List<String> inputTypeList, List<FilePickerResult> additionalDocuments);
  List<MultipartBody> prepareMultiPartsBody(XFile? pickedImage, List<XFile> pickedIdentities);
  List<int?> vehicleIds (List<VehicleModel>? vehicles);
  List<Data> processDataList(DeliverymanAdditionalJoinUsPageData? deliverymanAdditionalJoinUsPageData);
  List<dynamic> processAdditionalDataList(DeliverymanAdditionalJoinUsPageData? deliverymanAdditionalJoinUsPageData);
}