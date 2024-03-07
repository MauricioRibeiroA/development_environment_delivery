abstract class SplashServiceInterface  {
  Future<dynamic> getConfigData();
  Future<dynamic> initSharedData();
  Future<dynamic> removeSharedData();
  void setLanguageIntro(bool intro);
  bool showLanguageIntro();
}