import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Edit extends StatefulWidget {
  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  TextEditingController tcTitle = TextEditingController();

  TextEditingController tcDetail = TextEditingController();

  var _post;

  void edit() async {
    // get edit data

    // get token
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String token = prefs.getString('token');
    FlutterSecureStorage storage = FlutterSecureStorage();
    String token = await storage.read(key: 'token');

    // use remote service
    String url = 'http://10.0.2.2:35000/mobile/blog/edit';
    http.Response response = await http.put(url,
        headers: {'authorization': token, 'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            'title': tcTitle.text,
            'detail': tcDetail.text,
            'blogID': _post['blogID'],
          },
        ));
    // return to blog
    if (response.statusCode == 200) {
      Get.offAllNamed('/blog');
    } else {
      Get.defaultDialog(title: 'Error', middleText: response.body.toString());
      // throw Exception(response.body.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _post = Get.arguments;
    print(_post);
    tcTitle.text = _post['title'];
    tcDetail.text = _post['detail'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit a post'),
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
            ElevatedButton(onPressed: edit, child: Text('Save')),
          ],
        ),
      ),
    );
  }
}
