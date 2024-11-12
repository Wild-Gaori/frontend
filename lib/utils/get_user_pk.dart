import 'package:shared_preferences/shared_preferences.dart';

Future<int> getUserPk() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  final int? userPk = pref.getInt("user_pk");
  return userPk ?? 0;
}
