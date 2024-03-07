import 'package:stackfood_multivendor_driver/interface/repository_interface.dart';

abstract class SplashRepositoryInterface extends RepositoryInterface {
  Future<dynamic> getConfigData();
  Future<dynamic> initSharedData();
  Future<dynamic> removeSharedData();
  void setLanguageIntro(bool intro);
  bool showLanguageIntro();
}