import 'package:stackfood_multivendor_driver/feature/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_driver/feature/profile/domain/models/record_location_body.dart';
import 'package:stackfood_multivendor_driver/interface/repository_interface.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileRepositoryInterface implements RepositoryInterface {
  Future<dynamic> getProfileInfo();
  Future<dynamic> recordLocation(RecordLocationBody recordLocationBody);
  Future<dynamic> updateProfile(ProfileModel userInfoModel, XFile? data, String token);
  Future<dynamic> updateActiveStatus({int? shiftId});
  bool isNotificationActive();
  void setNotificationActive(bool isActive);
  Future<dynamic> deleteDriver();
  Future<dynamic> getShiftList();
}