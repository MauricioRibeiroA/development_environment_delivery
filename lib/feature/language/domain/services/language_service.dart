import 'package:stackfood_multivendor_driver/feature/language/domain/repositories/language_repository_interface.dart';
import 'package:stackfood_multivendor_driver/feature/language/domain/services/language_service_interface.dart';
import 'package:flutter/material.dart';
import 'package:stackfood_multivendor_driver/util/app_constants.dart';

class LanguageService implements LanguageServiceInterface {
  final LanguageRepositoryInterface languageRepositoryInterface;
  LanguageService({required this.languageRepositoryInterface});

  @override
  updateHeader(Locale locale) {
    languageRepositoryInterface.updateHeader(locale);
  }

  @override
  Locale getLocaleFromSharedPref() {
    return languageRepositoryInterface.getLocaleFromSharedPref();
  }

  @override
  void saveLanguage(Locale locale) {
    languageRepositoryInterface.saveLanguage(locale);
  }

  @override
  bool checkIsRTL(Locale locale, bool ltr) {
    bool isLtr = ltr;
    if(locale.languageCode == 'ar') {
      isLtr = false;
    }else {
      isLtr = true;
    }
    return isLtr;
  }

  @override
  int activeLanguageIndex(Locale locale) {
    int selectedIndex = 0;
    for(int index = 0; index<AppConstants.languages.length; index++) {
      if(AppConstants.languages[index].languageCode == locale.languageCode) {
        selectedIndex = index;
        break;
      }
    }
    return selectedIndex;
  }

}