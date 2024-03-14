import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stackfood_multivendor_driver/common/models/config_model.dart';
import 'package:stackfood_multivendor_driver/common/widgets/custom_snackbar_widget.dart';
import 'package:stackfood_multivendor_driver/api/api_client.dart';
import 'package:stackfood_multivendor_driver/feature/auth/domain/models/vehicle_model.dart';
import 'package:stackfood_multivendor_driver/feature/auth/domain/repositories/auth_repository_interface.dart';
import 'package:stackfood_multivendor_driver/feature/auth/domain/services/auth_service_interface.dart';

class AuthService implements AuthServiceInterface {
  final AuthRepositoryInterface authRepositoryInterface;
  AuthService({required this.authRepositoryInterface});

  @override
  Future<Response> login(String phone, String password) async {
    return await authRepositoryInterface.login(phone, password);
  }

  @override
  Future<bool> registerDeliveryMan(Map<String, String> data, List<MultipartBody> multiParts, List<MultipartDocument> additionalDocument) async {
    return await authRepositoryInterface.registerDeliveryMan(data, multiParts, additionalDocument);
  }

  @override
  Future< List<VehicleModel>?> getVehicleList() async {
    return await authRepositoryInterface.getList();
  }

  @override
  Future<bool> saveUserToken(Response response) async {
    return await authRepositoryInterface.saveUserToken(response.body['token'], response.body['topic']);
  }

  @override
  Future<Response> updateToken({String notificationDeviceToken = ''}) async {
    return await authRepositoryInterface.updateToken(notificationDeviceToken: notificationDeviceToken);
  }

  @override
  bool isLoggedIn() {
    return authRepositoryInterface.isLoggedIn();
  }

  @override
  Future<bool> clearSharedData() async {
    return await authRepositoryInterface.clearSharedData();
  }

  @override
  Future<void> saveUserNumberAndPassword(String number, String password, String countryCode) async {
    await authRepositoryInterface.saveUserNumberAndPassword(number, password, countryCode);
  }

  @override
  String getUserNumber() {
    return authRepositoryInterface.getUserNumber();
  }

  @override
  String getUserCountryCode() {
    return authRepositoryInterface.getUserCountryCode();
  }

  @override
  String getUserPassword() {
    return authRepositoryInterface.getUserPassword();
  }

  @override
  Future<bool> clearUserNumberAndPassword() async {
    return await authRepositoryInterface.clearUserNumberAndPassword();
  }

  @override
  String getUserToken() {
    return authRepositoryInterface.getUserToken();
  }

  @override
  Future<FilePickerResult?> picFile(MediaData mediaData) async{
    List<String> permission = [];
    if(mediaData.image == 1) {
      permission.add('jpg');
    }
    if(mediaData.pdf == 1) {
      permission.add('pdf');
    }
    if(mediaData.docs == 1) {
      permission.add('doc');
    }

    FilePickerResult? result;

    result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: permission,
      allowMultiple: false,
    );
    if(result != null && result.files.isNotEmpty) {
      if(result.files.single.size > 2000000) {
        result = null;
        showCustomSnackBar('please_upload_lower_size_file'.tr);
      } else {
        return result;
      }
    }
    return result;
  }

  @override
  Future<XFile?> pickImageFromGallery() async{
    XFile? pickImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickImage != null) {
      pickImage.length().then((value) {
        if (value > 2000000) {
          showCustomSnackBar('please_upload_lower_size_file'.tr);
        } else {
          return pickImage;
        }
      });
    }
    return pickImage;
  }

  @override
  List<MultipartDocument> prepareMultipartDocuments(List<String> inputTypeList, List<FilePickerResult> additionalDocuments){
    List<MultipartDocument> multiPartsDocuments = [];
    List<String> dataName = [];
    for(String data in inputTypeList) {
      dataName.add('additional_documents[$data]');
    }
    for(FilePickerResult file in additionalDocuments) {
      int index = additionalDocuments.indexOf(file);
      multiPartsDocuments.add(MultipartDocument('${dataName[index]}[]', file));
    }
    return multiPartsDocuments;
  }

  @override
  List<MultipartBody> prepareMultiPartsBody(XFile? pickedImage, List<XFile> pickedIdentities) {
    List<MultipartBody> multiParts = [];
    multiParts.add(MultipartBody('image', pickedImage));
    for(XFile file in pickedIdentities) {
      multiParts.add(MultipartBody('identity_image[]', file));
    }
    return multiParts;
  }

  @override
  List<int?> vehicleIds (List<VehicleModel>? vehicles) {
    List<int?>? vehicleIds = [];
    vehicleIds.add(0);
    for(VehicleModel vehicle in vehicles!) {
      vehicleIds.add(vehicle.id);
    }
    return vehicleIds;
  }

  @override
  List<Data> processDataList(DeliverymanAdditionalJoinUsPageData? deliverymanAdditionalJoinUsPageData) {
    List<Data> dataList = [];
    if(deliverymanAdditionalJoinUsPageData != null) {
      for (var data in deliverymanAdditionalJoinUsPageData.data!) {
        dataList.add(data);
      }
    }
    return dataList;
  }

  @override
  List<dynamic> processAdditionalDataList(DeliverymanAdditionalJoinUsPageData? deliverymanAdditionalJoinUsPageData) {
    List<dynamic> additionalList = [];
    if(deliverymanAdditionalJoinUsPageData != null) {
      for (var data in deliverymanAdditionalJoinUsPageData.data!) {
        int index = deliverymanAdditionalJoinUsPageData.data!.indexOf(data);
        if(data.fieldType == 'text' || data.fieldType == 'number' || data.fieldType == 'email' || data.fieldType == 'phone'){
          additionalList.add(TextEditingController());
        } else if(data.fieldType == 'date') {
          additionalList.add(null);
        } else if(data.fieldType == 'check_box') {
          additionalList.add([]);
          if(data.checkData != null) {
            for (var element in data.checkData!) {
              additionalList[index].add(0);
              debugPrint(element);
            }
          }
        } else if(data.fieldType == 'file') {
          additionalList.add([]);
        }
      }
    }
    return additionalList;
  }
}