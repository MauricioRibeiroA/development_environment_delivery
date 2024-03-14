import 'package:stackfood_multivendor_driver/common/models/response_model.dart';
import 'package:stackfood_multivendor_driver/feature/auth/domain/repositories/forgot_password_repository_interface.dart';
import 'package:stackfood_multivendor_driver/feature/auth/domain/services/forgot_password_service_interface.dart';
import 'package:stackfood_multivendor_driver/feature/profile/domain/models/profile_model.dart';

class ForgotPasswordService implements ForgotPasswordServiceInterface {
  final ForgotPasswordRepositoryInterface forgotPasswordRepositoryInterface;
  ForgotPasswordService({required this.forgotPasswordRepositoryInterface});

  @override
  Future<ResponseModel?> changePassword(ProfileModel userInfoModel, String password) async {
    return await forgotPasswordRepositoryInterface.changePassword(userInfoModel, password);
  }

  @override
  Future<ResponseModel> forgotPassword(String? phone) async {
    return await forgotPasswordRepositoryInterface.forgotPassword(phone);
  }

  @override
  Future<ResponseModel> resetPassword(String? resetToken, String phone, String password, String confirmPassword) async {
    return await forgotPasswordRepositoryInterface.resetPassword(resetToken, phone, password, confirmPassword);
  }

  @override
  Future<ResponseModel> verifyToken(String? phone, String token) async {
    return await forgotPasswordRepositoryInterface.verifyToken(phone, token);
  }
  
}