import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Year extends StatefulWidget {
  @override
  _YearState createState() => _YearState();
}

class _YearState extends State<Year> {
  var _year;
  @override
  void initState() {
    super.initState();
    _year = Get.arguments;
    // print(_year);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Year'),
      ),
      body: ListView.builder(
        itemCount: _year == null ? 0 : _year.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text('${_year[index]['year']}'),
            onTap: () {
              Get.back(result: _year[index]['year']);
            },
          );
        },
      ),
    );
  }
}
