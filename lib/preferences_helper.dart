import 'package:shared_preferences/shared_preferences.dart';

class preferencesHelper{
  // class _name obj_name =instance();
  static final preferencesHelper instance = preferencesHelper._init();

  preferencesHelper._init();

   final  String isOpenedKey ='is opened';
   SharedPreferences?_preferences;
   Future <void> init()async{
   _preferences =await SharedPreferences.getInstance();

 }
    bool getIsOpened(){
   return  _preferences?.getBool(isOpenedKey)??false;
 }
  Future <void> setIsOpened(bool value)async{
   _preferences!.setBool(isOpenedKey, value);
}
 void clearAllData(){
   _preferences!.clear();
}
  void clearItem(String key){

   _preferences!.remove(key);
}

}
