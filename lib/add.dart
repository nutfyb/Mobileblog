import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

class Add extends StatelessWidget {
  TextEditingController tcTitle = TextEditingController();
  TextEditingController tcDetail = TextEditingController();

  void add() async {
    // get title and detail
    String title = tcTitle.text;
    String detail = tcDetail.text;

    // get token
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String token = prefs.getString('token');
    FlutterSecureStorage storage = FlutterSecureStorage();
    String token = await storage.read(key: 'token');

    // sent data to server
    String url = 'http://10.0.2.2:35000/mobile/blog/new';
    http.Response response = await http.post(
      url,
      headers: {
        HttpHeaders.authorizationHeader: token,
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode({'title': title, 'detail': detail}),
    );

    // add OK?
    if (response.statusCode == 200) {
      // return to blog
      // Navigator.pushNamedAndRemoveUntil(context, routeName)
      Get.offAllNamed('/blog');
    } else {
      Get.defaultDialog(title: 'Error', middleText: response.body.toString());
      throw Exception(response.body.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: tcTitle,
              decoration: InputDecoration(hintText: 'Title'),
            ),
            TextField(
              controller: tcDetail,
              maxLines: 5,
              decoration: InputDecoration(hintText: 'Detail'),
            ),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(onPressed: add, child: Text('Save')),
          ],
        ),
      ),
    );
  }
}
