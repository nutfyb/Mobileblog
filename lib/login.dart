import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:get/get.dart';

class Login extends StatelessWidget {
  final String _url = 'http://10.0.2.2:35000/mobile/login';
  TextEditingController tcUsername = TextEditingController();
  TextEditingController tcPassword = TextEditingController();

  void login(BuildContext context) async {
    String username = tcUsername.text;
    String password = tcPassword.text;
    print(username);
    print(password);

    http.Response response = await http.post(
      _url,
      body: {'username': username, 'password': password},
    );
    if (response.statusCode == 200) {
      print('ok');
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = response.body.toString();
      // prefs.setString('token', token);
      FlutterSecureStorage storage = FlutterSecureStorage();
      await storage.write(key: 'token', value: token);

      //go to blog
      // Navigator.pushReplacementNamed(context, '/blog');
      Get.offNamed('/blog');
    } else {
      Get.defaultDialog(title: 'error', middleText: response.body.toString());
      //  print(response.body.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: tcUsername,
              decoration: InputDecoration(hintText: 'Username'),
            ),
            TextField(
              controller: tcPassword,
              obscureText: true,
              decoration: InputDecoration(hintText: 'Password'),
            ),
            ElevatedButton(
              onPressed: () => login(context),
              child: Text('Sign in'),
            ),
          ],
        ),
      ),
    );
  }
}
