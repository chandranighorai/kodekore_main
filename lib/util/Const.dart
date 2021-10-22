import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class Consts {
  static double shapeHeight = 180.0;
  static String SITE_URL = "http://182.75.124.211/kodecore/";
  static String APP_URL = SITE_URL + "api/";
  static String REGISTRATION = APP_URL + "register";
  static String REGISTRATION_OTP_VERIFICATION =
      APP_URL + "registered-otp-verification";
  static String LOGIN = APP_URL + "login";
  static String LOGIN_OTP_VERIFICATION = APP_URL + "verify-login";
  static String IT_PROJECT_LIST = APP_URL + "it-projects";
  static String IT_PROJECT_BOUGHT_BY_USER =
      APP_URL + "it-projects-bought-by-user";
  static String USER_BUY_IT_PROJECT = APP_URL + "user-buy-it-project";
  static String INVESTMENT_BY_USER = APP_URL + "investment-plans";
  static String INVESTMENT_PLANS_BOUGHT_BY_USER =
      APP_URL + "investment-plans-bought-by-user";
  static String BUY_INVESTMENT_PLAN = APP_URL + "user-buy-investment-plan";
  static String UPDATE_PROFILE = APP_URL + "update-profile";
  static String CRYPTO_CURRENCY = APP_URL + "cryptocurrency-list";
  static String BUY_CRYPTOCURRENCY = APP_URL + "user-buy-cryptocurrency";
  static String CRYPTOCURRENCY_BOUGHT_BY_USERS =
      APP_URL + "cryptocurrency-bought-by-user";
  static String USER_LIST = APP_URL + "users-list";
  static String REDEEM_REQUEST = APP_URL + "redeem-request";
  static String CRYPTOCURRENCY_WALLET = APP_URL + "cryptocurrency-wallet";
  static String SELL_CRIPTOCURRENCY = APP_URL + "user-sell-cryptocurrency";
  static String CRYPTOCURRENCY_TRANSACTION =
      APP_URL + "cryptocurrency-transactions";
  static String TERMS_CONDITIONS = APP_URL + "privacy-and-tnc";
  static String LOGOUT = APP_URL + "logout";
  static String NOTIFICATION = APP_URL + "notification-list";
}
