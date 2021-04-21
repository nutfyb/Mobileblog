import 'package:blogmobile/add.dart';
import 'package:blogmobile/blog.dart';
import 'package:blogmobile/edit.dart';
import 'package:blogmobile/login.dart';
import 'package:blogmobile/year.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  //ensure that all commands finish before runnApp()
  WidgetsFlutterBinding.ensureInitialized();
  String home = '/login';
  String url = 'http://10.0.2.2:35000/mobile/verify';

  // check token
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // String token = prefs.getString('token');

  FlutterSecureStorage storage = FlutterSecureStorage();
  String token = await storage.read(key: 'token');

  if (token != null) {
    //token exists
    print('token exists');
    //send this token to server
    http.Response response =
        await http.get(url, headers: {'authorization': token});
    if (response.statusCode == 200) {
      print('token is good');
      home = '/blog';
    } else {
      print('token is bad');
    }
  } else {
    print('no token');
  }

  runApp(GetMaterialApp(
    initialRoute: home,
    // routes: {
    //   '/login': (context) => Login(),
    //   '/blog': (context) => Blog(),
    //   '/add': (context) => Add(),
    // },

    getPages: [
      GetPage(name: '/login', page: () => Login()),
      GetPage(name: '/blog', page: () => Blog()),
      GetPage(name: '/add', page: () => Add()),
      GetPage(name: '/edit', page: () => Edit()),
      GetPage(name: '/year', page: () => Year()),
    ],
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {}
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
