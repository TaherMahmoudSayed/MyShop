import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime expireDate = DateTime.now();
  String? _userId;
  Timer? _authTimer = null;

  get isAuthenticated {
    return token()!=null?true:false ;
  }

  String? token() {
    if (expireDate.isAfter(DateTime.now()) && _token != null)
      {
        print("expireDate    "+expireDate.toString());
        print("expireDate.isAfter(DateTime.now()):   "+expireDate.isAfter(DateTime.now()).toString());
        print(DateTime.now());
        return _token;}
    else
      return null;
  }

  get userId {
    return _userId;
  }

  Future<void> signup(String? email, String? password) async {
    print("entered sing up method");
    var url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyC5aAc2a3Xm2Lw0hjgV3eZ7RaSoSSIoMmM");

    return postCredentials(email, password, url);
  }

  Future<void> login(String? email, String? password) async {
    Uri url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyC5aAc2a3Xm2Lw0hjgV3eZ7RaSoSSIoMmM");
    return postCredentials(email, password, url);
  }

  Future<void> postCredentials(String? email, String? password, Uri url) {
    print("entered post credential");
    return http
        .post(url,
            body: json.encode({
              "email": email,
              "password": password,
              "returnSecureToken": true,
            }))
        .then((response) {
      final extractedData = json.decode(response.body);
      print(response.body);
      if (extractedData["error"] != null) {
        print("enterd auth postCredentials error check");
        throw HttpException(extractedData["error"]["message"]);
      }
      _token = extractedData['idToken'];
      _userId = extractedData['localId'];
      expireDate = DateTime.now()
          .add(Duration(seconds: int.parse(extractedData["expiresIn"])));
          print("expiration date : "+extractedData["expiresIn"].toString());
      _autoLogout();
      notifyListeners();
      final userData = json.encode({
        'token': this._token,
        'userId': this._userId,
        'expiryDate': this.expireDate.toIso8601String(),
      });
      SharedPreferences.getInstance().then((value) {
        value.setString("userData", userData);
      });
    }).catchError((e) {
      throw e.toString().split(":")[1];
    });
  }

  Future<bool> tryLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData") &&
        (prefs.getString("userData") == "null" ||
            prefs.getString("userData")!.isEmpty)) {
      return false;
    }
    final extractedData =
        json.decode(prefs.getString("userData")!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedData["expiryDate"]);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    this._token = extractedData["token"];
    this._userId = extractedData["userId"];
    this.expireDate = expiryDate;
    notifyListeners();

    return true;
  }

  void logout() {
    _token = null;
    _userId = null;
    expireDate = DateTime.now();
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    SharedPreferences.getInstance().then((value) => {
      value.clear()
    });
  }

  void _autoLogout() {
    final timeToExpire = expireDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logout);
  }
}
