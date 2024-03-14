import 'package:flutter/material.dart';

abstract class LanguageServiceInterface {
  void updateHeader(Locale locale);
  Locale getLocaleFromSharedPref();
  void saveLanguage(Locale locale);
  bool checkIsRTL(Locale locale, bool ltr);
  int activeLanguageIndex(Locale locale);
}