import 'package:stackfood_multivendor_driver/feature/profile/domain/models/profile_model.dart';
import 'package:stackfood_multivendor_driver/interface/repository_interface.dart';

abstract class ForgotPasswordRepositoryInterface implements RepositoryInterface {
  Future<dynamic> changePassword(ProfileModel userInfoModel, String password);
  Future<dynamic> forgotPassword(String? phone);
  Future<dynamic> resetPassword(String? resetToken, String phone, String password, String confirmPassword);
  Future<dynamic> verifyToken(String? phone, String token);
}