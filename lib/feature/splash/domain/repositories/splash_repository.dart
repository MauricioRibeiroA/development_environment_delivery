import 'package:stackfood_multivendor_driver/common/models/config_model.dart';
import 'package:stackfood_multivendor_driver/api/api_client.dart';
import 'package:stackfood_multivendor_driver/feature/splash/domain/repositories/splash_repository_interface.dart';
import 'package:stackfood_multivendor_driver/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashRepository implements SplashRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  SplashRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future<ConfigModel?> getConfigData() async {
    ConfigModel? configModel;
    Response response = await apiClient.getData(AppConstants.configUri);
    if(response.statusCode == 200) {
      configModel = ConfigModel.fromJson(response.body);
    }
    return configModel;
  }

  @override
  Future<bool> initSharedData() {
    if(!sharedPreferences.containsKey(AppConstants.theme)) {
      return sharedPreferences.setBool(AppConstants.theme, false);
    }
    if(!sharedPreferences.containsKey(AppConstants.countryCode)) {
      return sharedPreferences.setString(AppConstants.countryCode, AppConstants.languages[0].countryCode!);
    }
    if(!sharedPreferences.containsKey(AppConstants.languageCode)) {
      return sharedPreferences.setString(AppConstants.languageCode, AppConstants.languages[0].languageCode!);
    }
    if(!sharedPreferences.containsKey(AppConstants.notification)) {
      return sharedPreferences.setBool(AppConstants.notification, true);
    }
    if(!sharedPreferences.containsKey(AppConstants.notificationCount)) {
      sharedPreferences.setInt(AppConstants.notificationCount, 0);
    }
    if(!sharedPreferences.containsKey(AppConstants.ignoreList)) {
      sharedPreferences.setStringList(AppConstants.ignoreList, []);
    }
    if(!sharedPreferences.containsKey(AppConstants.langIntro)) {
      sharedPreferences.setBool(AppConstants.langIntro, true);
    }
    return Future.value(true);
  }

  @override
  Future<bool> removeSharedData() {
    return sharedPreferences.clear();
  }

  @override
  void setLanguageIntro(bool intro) {
    sharedPreferences.setBool(AppConstants.langIntro, intro);
  }

  @override
  bool showLanguageIntro() {
    return sharedPreferences.getBool(AppConstants.langIntro) ?? true;
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    throw UnimplementedError();
  }

  @override
  Future get(int id) {
    throw UnimplementedError();
  }

  @override
  Future getList() {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

}