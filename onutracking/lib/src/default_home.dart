import 'package:flutter/material.dart';

class DefaultHome extends StatefulWidget {

  // final String pic;

  // DefaultHome({
  //   Key key,
  //   @required this.pic,
  // }) : super(key: key);

  @override
  _DefaultHomeState createState() => _DefaultHomeState();
}

class _DefaultHomeState extends State<DefaultHome> {

  // String piclocation = '';

  @override
  void initState() {
    super.initState();
    // piclocation = widget.pic;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          // child: (piclocation.isNotEmpty)
          //   ? Image.network(piclocation, width: 200, height: 200)
          //   : Icon(Icons.person),
          child: Text('User กำลังล็อกอินด้วย Line \r\n กรุณาปัดที่ขอบจอด้านซ้าย \r\n เลือก ลงทะเบียน User',
          style: TextStyle(fontSize: 18.0, color: Colors.green.shade900),)
          // child: Text('Login by $nameString'),
        ),
    );
  }
}