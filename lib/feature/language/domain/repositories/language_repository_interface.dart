import 'package:stackfood_multivendor_driver/interface/repository_interface.dart';
import 'package:flutter/material.dart';

abstract class LanguageRepositoryInterface extends RepositoryInterface {
  void updateHeader(Locale locale);
  Locale getLocaleFromSharedPref();
  void saveLanguage(Locale locale);
}