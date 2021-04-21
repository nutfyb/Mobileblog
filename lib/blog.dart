import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class Blog extends StatefulWidget {
  @override
  _BlogState createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  String _url = 'http://10.0.2.2:35000/mobile/blog';

  var _res;
  var _blog;
  var _year;
  String _token;
  void logout() async {
    // =========== remove local token ===========
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.remove('token');
    FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.delete(key: 'token');

    // =========== retrun to login ==============
    // Navigator.pushReplacementNamed(context, '/login');
    Get.offAllNamed('/login');
  }

  Future<dynamic> getBlog() async {
    
    // ============== get token ======================
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // _token = prefs.getString('token');
    FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.read(key: 'token');
    if (_token != null) {
      http.Response response =
          await http.get(_url, headers: {'authorization': _token});
      if (response.statusCode == 200) {
        // keep data to class variable to display later
        print(response.body);
        var data = json.decode(response.body);
        return Future.delayed(Duration(seconds: 1), () {
          return data;
        });
      }
    } else {
      print('no token');
    }
  }
  //Create a Listview

  Widget createListview(blog) {
    // keep blog data
    _blog = blog;
    var post = blog['post'];
    // List<DropdownMenuItem<int>> item = blog['year']
    //     .map<DropdownMenuItem<int>>((e) => DropdownMenuItem<int>(
    //         child: Text('${e['year']}'), value: e['year']))
    //     .toList();

    // item.insert(
    //     0,
    //     DropdownMenuItem(
    //       child: Text('All year'),
    //       value: 0,
    //     ));

    // var item = blog['year'].map((e) => DropdownMenuItem(child: Text('${e['year']}'), value: e['year'])).toList();
    // print(post);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _year == null ? Text('All year') : Text('$_year'),
            IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () async {
                  _year = await Get.toNamed('/year', arguments: blog['year']);
                  print(_year);
                  if (_year != null) {
                    setState(() {
                      _url = 'http://10.0.2.2:35000/mobile/blog/$_year';
                    });
                  }
                }),
            IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  setState(() {
                    _year = null;
                    _url = 'http://10.0.2.2:35000/mobile/blog';
                  });
                })
          ],
        ),
        // DropdownButton(
        //   value: _year,
        //   items: item,
        //   onChanged: (int val) {
        //     setState(() {
        //       _year = val;
        //       if (_year != 0) {
        //         _url = 'http://10.0.2.2:35000/mobile/blog/$_year';
        //       }
        //       else{
        //          _url = 'http://10.0.2.2:35000/mobile/blog';
        //       }
        //     });
        //   },
        //   // items: [
        //   //   DropdownMenuItem(
        //   //     child: Text('2021'),
        //   //     value: 2021,
        //   //   ),
        //   //   DropdownMenuItem(
        //   //     child: Text('2020'),
        //   //     value: 2020,
        //   //   ),
        //   // ],
        //   // onChanged: (int newYear) {
        //   //   setState(() {
        //   //     _year = newYear;
        //   //   });
        //   // },
        // ),
        Expanded(
          child: ListView.builder(
            itemCount: post == null ? 0 : post.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Get.toNamed('/edit', arguments: post[index]);
                    }),
                title: Text(post[index]['title']),
                subtitle: Text(post[index]['detail']),
                trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => deletePost(post[index]['blogID'])),
              );
            },
          ),
        ),
      ],
    );
  }

  // @override
  // void initState() {
  //   super.initState();
  //   // connect to server to get blog data
  //   var data = getBlog();
  // }

  void deletePost(blogID) {
    int userID = _blog['user']['blogID'];
    print(blogID);
    print(userID);

    Get.defaultDialog(
        title: 'warning',
        middleText: 'Delete this post',
        textConfirm: 'Yed',
        textCancel: 'cancel',
        confirmTextColor: Colors.white,
        radius: 0.0,
        onConfirm: () async {
          //close dialog
          Get.back();
          //delete data from
          String url = '$_url/$blogID';
          http.Response response =
              await http.delete(url, headers: {'authorization': _token});
          if (response.statusCode == 200) {
            //refresh page
            setState(() {});
          } else {
            //show error dialog
            Get.defaultDialog(
                title: 'error', middleText: 'Failed to delete post');
            throw Exception('Delete error');
          }
        });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog'),
        actions: [IconButton(icon: Icon(Icons.logout), onPressed: logout)],
      ),
      // body: ListView.builder(
      //   itemCount: _res['post'].length,
      //   itemBuilder: (BuildContext context, int index) {
      //     return ListTile(
      //       leading: Icon(Icons.edit),
      //       title: Text(_res['post'][index]['title']),
      //       subtitle: Text('Post Subtitle'),
      //       trailing: Icon(Icons.delete),
      //     );
      //   },
      // ),
      body: FutureBuilder(
        future: getBlog(),
        builder: (context, snapshot) {
          // if the connection finishes
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              var data = snapshot.data;
              print(data);
              // return Text('$data');
              return createListview(data);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Navigator.pushNamed(context, '/add');
          Get.toNamed('/add');
        },
      ),
    );
  }
}
