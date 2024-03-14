import 'package:stackfood_multivendor_driver/feature/language/domain/services/language_service_interface.dart';
import 'package:stackfood_multivendor_driver/feature/language/domain/models/language_model.dart';
import 'package:stackfood_multivendor_driver/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationController extends GetxController implements GetxService {
  final LanguageServiceInterface languageServiceInterface;
  LocalizationController({required this.languageServiceInterface}){
    loadCurrentLanguage();
  }

  Locale _locale = Locale(AppConstants.languages[0].languageCode!, AppConstants.languages[0].countryCode);
  Locale get locale => _locale;

  bool _isLtr = true;
  bool get isLtr => _isLtr;

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  List<LanguageModel> _languages = [];
  List<LanguageModel> get languages => _languages;

  void setLanguage(Locale locale) {
    Get.updateLocale(locale);
    _locale = locale;
    _isLtr = languageServiceInterface.checkIsRTL(_locale, _isLtr);
    languageServiceInterface.updateHeader(_locale);
    _saveLanguage(_locale);
    update();
  }

  void loadCurrentLanguage() async {
    _locale = languageServiceInterface.getLocaleFromSharedPref();
    _isLtr = _locale.languageCode != 'ar';
    _selectedIndex = languageServiceInterface.activeLanguageIndex(_locale);
    _languages = [];
    _languages.addAll(AppConstants.languages);
    update();
  }

  void _saveLanguage(Locale locale) async {
    languageServiceInterface.saveLanguage(locale);
  }

  void setSelectIndex(int index) {
    _selectedIndex = index;
    update();
  }

}