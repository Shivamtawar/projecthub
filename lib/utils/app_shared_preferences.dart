import 'package:shared_preferences/shared_preferences.dart';

class PrefData {
  static String prefName = "com.example.learn_megnagmet";

  static String isIntro = prefName + "isIntro";
  static String isLogin = prefName + "isLigin";
  static String isVarification = prefName + 'isVarification';
  static String isFirstLogin = prefName + 'isFirstLogin';

  static clearAppSharedPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }

  static setIntro(bool intro) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(isIntro, intro);
  }

  static getIntro() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool intro = sharedPreferences.getBool(isIntro) ?? false;
    return intro;
  }

  ///////////////////Ligin Screen////////////////////
  // this method save the id of user for, last login
  static setLogin(int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(isLogin, id);
  }

  static getLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int id = sharedPreferences.getInt(isLogin) ?? -1;
    return id;
  }
  /////////////////////varification/////////
  // static setVarification(bool varification) async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   sharedPreferences.setBool(isVarification, varification);
  // }
  //
  // static getVarification() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   bool Varification = sharedPreferences.getBool(isVarification) ?? false;
  //   return Varification;
  // }
  // /////////////////////////firstLogin//////////
  // static setFirstLogin(bool firstlogin) async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   sharedPreferences.setBool(isFirstLogin, firstlogin);
  // }
  //
  // static getFirstLogin() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   bool FirstLogin = sharedPreferences.getBool(isFirstLogin) ?? false;
  //   return FirstLogin;
  // }
}
